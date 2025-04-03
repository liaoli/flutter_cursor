import 'dart:convert';
import 'package:http/http.dart' as http;

/// Unsplash API 服务类
class UnsplashService {
  /// Unsplash API 基础URL
  static const String _baseUrl = 'https://api.unsplash.com';

  /// API Key
  static const String _apiKey = '2fUQmd5KqpGS1Xw8LZqZEzn3nZsqmvp8TepnoDhyTis';

  /// 获取随机图片
  ///
  /// [orientation] 图片方向，可选值：landscape, portrait, squarish
  /// [query] 搜索关键词，可选
  ///
  /// 返回包含图片信息的 Map，包含以下字段：
  /// - id: 图片ID
  /// - urls: 包含不同尺寸图片URL的对象
  /// - user: 摄影师信息
  /// - description: 图片描述
  Future<Map<String, dynamic>> getRandomPhoto({
    String? orientation,
    String? query,
  }) async {
    final queryParams = <String, String>{};
    if (orientation != null) queryParams['orientation'] = orientation;
    if (query != null) queryParams['query'] = query;

    final uri = Uri.parse('$_baseUrl/photos/random')
        .replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Client-ID $_apiKey',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load random photo: ${response.statusCode}');
    }
  }

  /// 获取图片列表
  ///
  /// [page] 页码，从1开始
  /// [perPage] 每页数量
  /// [query] 搜索关键词，可选
  ///
  /// 返回包含图片列表的 List，每个图片包含：
  /// - id: 图片ID
  /// - urls: 包含不同尺寸图片URL的对象
  /// - user: 摄影师信息
  /// - description: 图片描述
  Future<List<Map<String, dynamic>>> getPhotos({
    required int page,
    required int perPage,
    String? query,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (query != null) queryParams['query'] = query;

    final uri =
        Uri.parse('$_baseUrl/photos').replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Client-ID $_apiKey',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load photos: ${response.statusCode}');
    }
  }

  /// 获取热门分类列表
  ///
  /// 返回分类列表，每个分类包含：
  /// - id: 分类ID
  /// - title: 分类名称
  /// - description: 分类描述
  Future<List<Map<String, dynamic>>> getTopics() async {
    final uri = Uri.parse('$_baseUrl/topics');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Client-ID $_apiKey',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load topics: ${response.statusCode}');
    }
  }
}
