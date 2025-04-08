import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/unsplash_service.dart';
import 'login_page.dart';

class WelcomePage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const WelcomePage({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final UnsplashService _unsplashService = UnsplashService();
  String? _imageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRandomPhoto();
  }

  Future<void> _loadRandomPhoto() async {
    setState(() => _isLoading = true);
    try {
      final photo = await _unsplashService.getRandomPhoto(
        orientation: 'landscape',
      );
      setState(() {
        _imageUrl = photo['urls']['regular'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载图片失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 背景图片
          if (_imageUrl != null)
            CachedNetworkImage(
              imageUrl: _imageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),

          // 半透明遮罩
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          // 内容
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 主题切换按钮
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: Colors.white,
                    ),
                    onPressed: widget.onThemeToggle,
                  ),
                ),
                const Spacer(),
                const Text(
                  '欢迎使用',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // 刷新按钮
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _loadRandomPhoto,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.refresh),
                  label: const Text('刷新背景'),
                ),
                const SizedBox(height: 15),
                // 开始使用按钮
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(
                          onThemeToggle: widget.onThemeToggle,
                          isDarkMode: widget.isDarkMode,
                        ),
                      ),
                    );
                  },
                  child: const Text('开始使用'),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
