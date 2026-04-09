# Memory Land Flutter

当前仓库已经从原来的前后端 Web 项目重构为 Flutter 项目骨架，方向是 iPhone 优先的移动端 App。

## 当前状态

- 已清空旧的 Java / Vue / Node 工程
- 已写入 Flutter 项目基础文件
- 已完成首版 `lib/main.dart`
- 当前机器未安装 Flutter SDK，所以还没有生成 `android/`、`ios/`、`web/` 等平台目录

## 下一步

1. 安装 Flutter SDK
2. 在仓库根目录执行：

```bash
flutter create .
```

3. 然后运行：

```bash
flutter pub get
flutter run
```

如果目标是 iOS 真机或上架 App Store，最终仍然需要在 macOS 上安装 Xcode 完成签名、构建和发布。

