//
//  DoraemonTimeProfilerCore.c
//  DoraemonKit
//
//  Created by yixiang on 2019/7/9.
//

#include "DoraemonTimeProfilerCore.h"

#ifdef __aarch64__
#include <pthread.h>
#include <stdlib.h>
#include <sys/time.h>
#include <objc/runtime.h>
#include <dispatch/dispatch.h>
#include "doraemon_fishhook.h"

static bool _call_record_enabled = true;
static uint64_t _min_time_cost = 1000; //us
static int _max_call_depth = 10;
static pthread_key_t _thread_key;
__unused static id (*orig_objc_msgSend)(id, SEL, ...);

static dtp_call_record *dtp_records;
static int dtp_record_num;
static int dtp_record_alloc;

typedef struct {
    id self; 
    Class cls;
    SEL cmd; 
    uint64_t time; //us
    uintptr_t lr; //link register
} thread_call_record;

typedef struct {
    thread_call_record *stack;
    int allocated_length;
    int index;
    bool is_main_thread;
} thread_call_stack;

static inline thread_call_stack *get_thread_call_stack(void) {
    thread_call_stack *cs = (thread_call_stack *)pthread_getspecific(_thread_key);
    if (cs == NULL) {
        cs = (thread_call_stack *)malloc(sizeof(thread_call_stack));
        cs->stack = (thread_call_record *)calloc(128, sizeof(thread_call_record));
        cs->allocated_length = 64;
        cs->index = -1;
        cs->is_main_thread = pthread_main_np();
        pthread_setspecific(_thread_key, cs);
    }
    return cs;
}

static void release_thread_call_stack(void *ptr){
    thread_call_stack *cs = (thread_call_stack *)ptr;
    if (!cs) return;
    if (cs->stack) free(cs->stack);
    free(cs);
}

static inline void push_call_record(id _self, Class _cls, SEL _cmd, uintptr_t lr) {
    thread_call_stack *cs = get_thread_call_stack();
    if (cs) {
        int nextIndex = (++cs->index);
        if (nextIndex >= cs->allocated_length) {
            cs->allocated_length += 64;
            cs->stack = (thread_call_record *)realloc(cs->stack, cs->allocated_length * sizeof(thread_call_record));
        }
        thread_call_record *newRecord = &cs->stack[nextIndex];
        newRecord->self = _self;
        newRecord->cls = _cls;
        newRecord->cmd = _cmd;
        newRecord->lr = lr;
        if (cs->is_main_thread && _call_record_enabled) {
            struct timeval now;
            gettimeofday(&now, NULL);
            newRecord->time = (now.tv_sec % 100) * 1000000 + now.tv_usec;
        }
    }
}

static inline uintptr_t pop_call_record(void) {
    thread_call_stack *cs = get_thread_call_stack();
    int curIndex = cs->index;
    int nextIndex = cs->index--;
    thread_call_record *pRecord = &cs->stack[nextIndex];
    
    if (cs->is_main_thread && _call_record_enabled) {
        struct timeval now;
        gettimeofday(&now, NULL);
        uint64_t time = (now.tv_sec % 100) * 1000000 + now.tv_usec;
        if (time < pRecord->time) {
            time += 100 * 1000000;
        }
        uint64_t cost = time - pRecord->time;
        if (cost > _min_time_cost && cs->index < _max_call_depth) {
            if (!dtp_records) {
                dtp_record_alloc = 1024;
                dtp_records = malloc(sizeof(dtp_call_record) * dtp_record_alloc);
            }
            dtp_record_num++;
            if (dtp_record_num >= dtp_record_alloc) {
                dtp_record_alloc += 1024;
                dtp_records = realloc(dtp_records, sizeof(dtp_call_record) * dtp_record_alloc);
            }
            dtp_call_record *log = &dtp_records[dtp_record_num - 1];
            log->cls = pRecord->cls;
            log->depth = curIndex;
            log->sel = pRecord->cmd;
            log->time = cost;
        }
    }
    return pRecord->lr;
}

void before_objc_msgSend(id self, SEL _cmd, uintptr_t lr) {
    push_call_record(self, object_getClass(self), _cmd, lr);
}

uintptr_t after_objc_msgSend(void) {
    return pop_call_record();
}

#define call(b, value) \
    __asm volatile ("stp x8, x9, [sp, #-16]!\n"); \
    __asm volatile ("mov x12, %0\n" :: "r"(value)); \
    __asm volatile ("ldp x8, x9, [sp], #16\n"); \
    __asm volatile (#b " x12\n");

#define save() \
    __asm volatile ( \
        "stp x8, x9, [sp, #-16]!\n" \
        "stp x6, x7, [sp, #-16]!\n" \
        "stp x4, x5, [sp, #-16]!\n" \
        "stp x2, x3, [sp, #-16]!\n" \
        "stp x0, x1, [sp, #-16]!\n");

#define load() \
    __asm volatile ( \
        "ldp x0, x1, [sp], #16\n" \
        "ldp x2, x3, [sp], #16\n" \
        "ldp x4, x5, [sp], #16\n" \
        "ldp x6, x7, [sp], #16\n" \
        "ldp x8, x9, [sp], #16\n");

#define link(b, value) \
    __asm volatile ("stp x8, lr, [sp, #-16]!\n"); \
    __asm volatile ("sub sp, sp, #16\n"); \
    call(b, value); \
    __asm volatile ("add sp, sp, #16\n"); \
    __asm volatile ("ldp x8, lr, [sp], #16\n");

#define ret() __asm volatile ("ret\n");

__attribute__((__naked__))
static void hook_objc_msgSend(void) {
    save()

    __asm volatile ("mov x2, lr\n");
    __asm volatile ("mov x3, x4\n");
    
    call(blr, &before_objc_msgSend)

    load()
    call(blr, orig_objc_msgSend)
    
    save()
    
    call(blr, &after_objc_msgSend)
    
    __asm volatile ("mov lr, x0\n");

    load()

    ret()
}

void dtp_hook_begin(void) {
    _call_record_enabled = true;

    pthread_key_create(&_thread_key, &release_thread_call_stack);
    doraemon_rebind_symbols((struct doraemon_rebinding[1]){"objc_msgSend", (void *)hook_objc_msgSend, (void **)&orig_objc_msgSend},1);
}

void dtp_hook_end(void) {
    _call_record_enabled = false;
    doraemon_rebind_symbols((struct doraemon_rebinding[1]){"objc_msgSend", (void *)orig_objc_msgSend, NULL},1);
}

void dtp_set_min_time(uint64_t us) {
    _min_time_cost = us;
}

void dtp_set_max_depth(int depth) {
    _max_call_depth = depth;
}

dtp_call_record *dtp_get_call_records(int *num) {
    if (num) {
        *num = dtp_record_num;
    }
    return dtp_records;
}

void dtp_clear_call_records(void) {
    if (dtp_records) {
        free(dtp_records);
        dtp_records = NULL;
    }
    dtp_record_num = 0;
}

#else

void dtp_hook_begin(void) {}

void dtp_hook_end(void) {}

void dtp_set_min_time(uint64_t us) {}

void dtp_set_max_depth(int depth) {}

dtp_call_record *dtp_get_call_records(int *num) {return NULL;}

void dtp_clear_call_records(void) {}

#endif
