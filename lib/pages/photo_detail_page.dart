import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;

class PhotoDetailPage extends StatefulWidget {
  final Map<String, dynamic> photo;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const PhotoDetailPage({
    super.key,
    required this.photo,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<PhotoDetailPage> createState() => _PhotoDetailPageState();
}

class _PhotoDetailPageState extends State<PhotoDetailPage> {
  bool _isLoading = true;
  double _progress = 0;
  bool _isSaving = false;

  void _updateProgress(double progress) {
    Future.microtask(() {
      if (mounted) {
        setState(() {
          _progress = progress;
        });
      }
    });
  }

  void _onLoadingComplete() {
    Future.microtask(() {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  /// 保存图片到相册
  Future<void> _saveImage() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      // 下载图片
      final response = await http.get(
        Uri.parse(widget.photo['urls']['regular']),
      );

      if (response.statusCode == 200) {
        // 保存到相册
        final result = await ImageGallerySaver.saveImage(
          response.bodyBytes,
          quality: 100,
          name: 'unsplash_${widget.photo['id']}',
        );

        if (mounted) {
          if (result['isSuccess']) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('图片已保存到相册')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('保存失败，请重试')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('图片详情'),
        centerTitle: true,
        actions: [
          // 主题切换按钮
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.onThemeToggle,
          ),
          // 保存按钮
          IconButton(
            icon: _isSaving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.download),
            onPressed: _isSaving ? null : _saveImage,
            tooltip: '保存到相册',
          ),
          // 分享按钮
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(
                widget.photo['urls']['regular'],
                subject: widget.photo['description'] ?? '分享图片',
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 小图作为背景
          PhotoView(
            imageProvider: CachedNetworkImageProvider(
              widget.photo['urls']['small'],
            ),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            initialScale: PhotoViewComputedScale.contained,
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),
          // 大图加载层
          PhotoView(
            imageProvider: CachedNetworkImageProvider(
              widget.photo['urls']['regular'],
              maxWidth: 1440,
            ),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            initialScale: PhotoViewComputedScale.contained,
            backgroundDecoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            loadingBuilder: (context, event) {
              if (event == null) {
                _onLoadingComplete();
                return const SizedBox.shrink();
              }
              _updateProgress(
                  event.cumulativeBytesLoaded / event.expectedTotalBytes!);
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: _progress,
                        strokeWidth: 4,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${(_progress * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
