# Unsplash壁纸工具

一个使用 Flutter 开发的 Unsplash 壁纸应用，支持图片浏览、保存和分享功能。

## 1. 程序名称
Unsplash壁纸工具

## 2. 功能介绍
- 欢迎页面：展示随机精选壁纸，支持主题切换
- 首页功能：
  - 展示Unsplash精选图片列表
  - 支持下拉刷新
  - 支持图片分类筛选
  - 支持主题切换
- 图片详情页：
  - 支持图片预览和缩放
  - 支持保存图片到相册
  - 支持分享图片
  - 支持主题切换

## 3. Flutter组件列表
### 基础组件
- `MaterialApp`: 应用根组件
- `Scaffold`: 页面基础框架
- `AppBar`: 顶部导航栏
- `BottomNavigationBar`: 底部导航栏
- `Container`: 容器组件
- `Stack`: 层叠布局
- `Column`: 垂直布局
- `Row`: 水平布局
- `Expanded`: 弹性布局
- `SizedBox`: 固定尺寸容器

### 图片相关组件
- `CachedNetworkImage`: 网络图片缓存组件
- `PhotoView`: 图片预览组件
- `Image`: 图片组件
- `CircularProgressIndicator`: 加载指示器

### 交互组件
- `ElevatedButton`: 按钮组件
- `IconButton`: 图标按钮
- `FilterChip`: 筛选标签
- `RefreshIndicator`: 下拉刷新
- `GridView`: 网格布局
- `ListView`: 列表布局

### 主题相关
- `ThemeData`: 主题数据
- `ColorScheme`: 颜色方案
- `AppBarTheme`: 导航栏主题
- `ElevatedButtonTheme`: 按钮主题
- `ChipTheme`: 标签主题

## 4. 程序目录文件清单
```
lib/
├── main.dart                 # 应用入口文件
├── theme/
│   └── app_theme.dart        # 主题配置文件
├── pages/
│   ├── welcome_page.dart     # 欢迎页面
│   ├── home_page.dart        # 首页
│   └── photo_detail_page.dart # 图片详情页
└── services/
    └── unsplash_service.dart # Unsplash API服务
```

## 5. 依赖包列表
- `http`: ^1.2.0 - 网络请求
- `cached_network_image`: ^3.3.1 - 图片缓存
- `photo_view`: ^0.14.0 - 图片预览
- `share_plus`: ^7.2.1 - 分享功能
- `image_gallery_saver`: ^2.0.3 - 图片保存

## 6. 主题配置
- 主色调：#BA7264
- 支持亮色/暗色主题切换
- 自定义按钮样式
- 自定义标签样式
- 自定义导航栏样式

## 7. 图片分辨率配置
- 欢迎页：regular（720p）
- 首页列表：small（200x200）
- 详情页：regular（1440p）

## 8. 开发环境
- Flutter SDK: ^3.5.4
- Dart SDK: ^3.5.4
- 开发工具：Flutter IDE
- 目标平台：iOS/Android

## 9. 安装说明
1. 克隆项目到本地
2. 运行 `flutter pub get` 安装依赖
3. 配置 Unsplash API Key
4. 运行 `flutter run` 启动应用

## 10. 注意事项
- 需要配置 Unsplash API Key 才能正常使用
- iOS 需要配置相册访问权限
- Android 需要配置存储权限
