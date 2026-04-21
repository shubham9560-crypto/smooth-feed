import 'package:smooth_feed/feature/post_feed/data/models/post_model.dart';

abstract class FeedRepository {
  Future<List<PostModel>> fetchPosts(int offset, int limit);
  Future<bool> toggleLike(PostModel post);
}
