import 'package:smooth_feed/feature/post_feed/data/models/post_model.dart';

class MockApi {
  Future<List<String>> fetchPosts(int offset, int limit) async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(
      limit,
      (index) => "https://picsum.photos/seed/${offset + index}/300",
    );
  }

  Future<bool> toggleLike(PostModel post) async {
    await Future.delayed(Duration(milliseconds: 500));

    if (DateTime.now().millisecondsSinceEpoch % 5 == 0) {
      return false;
    }

    return true;
  }
}
