## 项目核心概况

-   **项目名称**：DoraemonKit (DoKit) iOS 开发调试工具包
-   **技术栈**：Objective-C 为主，Swift Demo；最低支持 iOS 13.0；CocoaPods 分发
-   **验证方式**：无单元测试，通过 Demo App 进行功能验证

## 构建与运行

```bash
cd iOS/DoraemonKitDemo && pod install && open DoraemonKitDemo.xcworkspace
pod lib lint DoraemonKit.podspec
```

## 架构关键点

-   **核心入口**：`DoraemonManager` 单例（`iOS/DoraemonKit/Src/Core/Manager/`），通过 `[[DoraemonManager shareInstance] install]` 初始化
-   **插件机制**：所有工具均为插件，需实现 `DoraemonPluginProtocol`（`pluginDidLoad` / `pluginDidLoad:`）
-   **模块化 Subspecs**：
    -   `Core`（必选）：基础功能
    -   `WithGPS` / `WithLoad` / `WithUIProfile` / `WithViewMetrics`（可选）：通过 `GCC_PREPROCESSOR_DEFINITIONS` 条件编译
-   **关键目录**（`iOS/DoraemonKit/Src/Core/`）：
    -   `Plugin/`：按 `Common/`、`Performance/`、`UI/` 分类存放插件
    -   `Define/`：宏与常量（`DoraemonDefine.h`）
    -   `Util/`：工具类（含 fishhook 方法交换）
    -   `Entry/`：悬浮窗入口

## 新增插件规范

1.  创建类并实现 `DoraemonPluginProtocol`
2.  通过 `DoraemonManager` 的 `addPluginWithTitle:icon:desc:pluginName:atModule:` 注册，或在 `DoraemonManagerPluginType` 枚举中添加内置插件
3.  按功能归类放入对应 `Plugin/` 子目录

## 强制编码约定

-   **Release 剥离**：所有 DoKit 调用必须包裹在 `#ifdef DEBUG` / `#endif` 中
-   **内存安全**：Block 中必须使用 `@weakify` / `@strongify` 避免循环引用
-   **资源管理**：图片资源统一存放于 `iOS/DoraemonKit/Resource/`