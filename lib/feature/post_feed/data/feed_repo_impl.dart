import 'package:smooth_feed/feature/post_feed/data/services/service.dart';
import 'package:smooth_feed/feature/post_feed/domain/feed_repo.dart';
import 'package:smooth_feed/feature/post_feed/data/models/post_model.dart';

class FeedRepoImpl implements FeedRepository {
  final MockApi mockerAPIService;

  FeedRepoImpl(this.mockerAPIService);

  @override
  Future<List<PostModel>> fetchPosts(int offset, int limit) async {
    final urls = await mockerAPIService.fetchPosts(offset, limit);
    return List.generate(urls.length, (index) {
      return PostModel(imageUrl: urls[index]);
    });
  }

  @override
  Future<bool> toggleLike(PostModel post) async {
    return await mockerAPIService.toggleLike(post);
  }
}
