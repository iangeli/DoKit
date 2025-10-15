//
//  DoraemonDBManager.m
//  DoraemonKit
//
//  Created by yixiang on 2019/3/30.
//

#import "DoraemonDBManager.h"
#import <sqlite3.h>

@interface DoraemonDBManager ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation DoraemonDBManager
+ (DoraemonDBManager *)shareManager {
    static dispatch_once_t once;
    static DoraemonDBManager *instance;
    dispatch_once(&once, ^{
        instance = [[DoraemonDBManager alloc] init];
    });
    return instance;
}

- (sqlite3 *)openDB {
    sqlite3 *db = nil;
    sqlite3_open([self.dbPath UTF8String], &db);
    return db;
}

- (NSArray *)tablesAtDB {
    sqlite3 *db = [self openDB];
    if (db == nil) {
        return @[];
    }
    NSMutableArray *tableNameArray = [NSMutableArray array];

    NSString *sql = @"select type, tbl_name from sqlite_master";
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *type_c = sqlite3_column_text(stmt, 0);
            const unsigned char *tbl_name_c = sqlite3_column_text(stmt, 1);
            NSString *type = [NSString stringWithUTF8String:(const char *)type_c];
            NSString *tbl_name = [NSString stringWithUTF8String:(const char *)tbl_name_c];
            if (type && [type isEqualToString:@"table"]) {
                [tableNameArray addObject:tbl_name];
            }
        }
    }
    return tableNameArray;
}

- (NSArray *)dataAtTable {
    sqlite3 *db = [self openDB];
    if (db == nil) {
        return @[];
    }

    NSString *sql = [NSString stringWithFormat:@"select * from %@", self.tableName];

    char *errmsg = nil;
    sqlite3_exec(db, [sql UTF8String], selectCallback, nil, &errmsg);

    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.dataArray];
    [self.dataArray removeAllObjects];

    return arrayM;
}

int selectCallback(void *firstValue, int columnCount, char **columnValues, char **columnNames) {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (int i = 0; i < columnCount; i++) {

        char *columnName = columnNames[i];
        NSString *nameStr = nil;
        if (columnName == NULL) {
            nameStr = nil;
        } else {
            nameStr = [NSString stringWithUTF8String:columnName];
        }

        char *columnValue = columnValues[i];
        NSString *valueStr = nil;
        if (columnValue == NULL) {
            valueStr = nil;
        } else {
            valueStr = [NSString stringWithUTF8String:columnValue];
        }

        if (nameStr.length > 0) {
            [dict setValue:valueStr forKey:nameStr];
        }
    }
    [[[DoraemonDBManager shareManager] dataArray] addObject:dict];
    return 0;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
