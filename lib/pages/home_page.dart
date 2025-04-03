import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/unsplash_service.dart';
import 'photo_detail_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const HomePage({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UnsplashService _unsplashService = UnsplashService();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _photos = [];
  final List<Map<String, dynamic>> _topics = [];
  String? _selectedTopic;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadTopics();
    _loadPhotos();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 加载分类列表
  Future<void> _loadTopics() async {
    try {
      final topics = await _unsplashService.getTopics();
      setState(() {
        _topics.clear();
        _topics.addAll(topics);
      });
    } catch (e) {
      print('加载分类失败: $e');
    }
  }

  /// 加载图片列表
  Future<void> _loadPhotos() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);
    try {
      final photos = await _unsplashService.getPhotos(
        page: _currentPage,
        perPage: 30,
        query: _selectedTopic,
      );

      setState(() {
        _photos.addAll(photos);
        _currentPage++;
        _hasMore = photos.length == 30;
        _isLoading = false;
      });
    } catch (e) {
      print('加载图片失败: $e');
      setState(() => _isLoading = false);
    }
  }

  /// 滚动监听
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadPhotos();
    }
  }

  /// 计算每行显示的图片数量
  int _calculateGridCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final itemWidth = 200.0;
    final count = (width / itemWidth).floor();
    return count >= 3 ? count : 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('壁纸工具'),
        centerTitle: true,
        actions: [
          // 主题切换按钮
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
      body: Column(
        children: [
          // 分类按钮组
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _topics.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: const Text('全部'),
                      selected: _selectedTopic == null,
                      onSelected: (selected) {
                        setState(() {
                          _selectedTopic = null;
                          _photos.clear();
                          _currentPage = 1;
                          _hasMore = true;
                        });
                        _loadPhotos();
                      },
                    ),
                  );
                }

                final topic = _topics[index - 1];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(topic['title']),
                    selected: _selectedTopic == topic['id'],
                    onSelected: (selected) {
                      setState(() {
                        _selectedTopic = topic['id'];
                        _photos.clear();
                        _currentPage = 1;
                        _hasMore = true;
                      });
                      _loadPhotos();
                    },
                  ),
                );
              },
            ),
          ),
          // 图片网格
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _calculateGridCount(context),
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _photos.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _photos.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final photo = _photos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PhotoDetailPage(
                          photo: photo,
                          onThemeToggle: widget.onThemeToggle,
                          isDarkMode: widget.isDarkMode,
                        ),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: photo['urls']['small'],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
