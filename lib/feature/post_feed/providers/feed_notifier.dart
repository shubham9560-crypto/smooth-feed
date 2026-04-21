import 'package:flutter_riverpod/legacy.dart';
import 'package:smooth_feed/feature/post_feed/data/feed_repo_impl.dart';
import 'package:smooth_feed/feature/post_feed/data/services/service.dart';
import 'package:smooth_feed/feature/post_feed/domain/feed_repo.dart';
import 'package:smooth_feed/shared/feed_state_model.dart';

final feedProvider = StateNotifierProvider<FeedNotifier, FeedStateModel>((ref) {
  final repo = FeedRepoImpl(MockApi());

  return FeedNotifier(repo);
});

class FeedNotifier extends StateNotifier<FeedStateModel> {
  final FeedRepository repo;
  FeedNotifier(this.repo)
    : super(
        FeedStateModel(posts: [], isLoading: false, hasMore: true, offset: 0),
      );

  Future<void> refresh() async {
    state = FeedStateModel(
      posts: [],
      isLoading: false,
      hasMore: true,
      offset: state.offset + 1,
    );

    await loadMore();
  }

  Future<bool> toggleLike(int index) async {
    final post = state.posts[index];
    //  SAVE OLD STATE (for rollback)
    final oldLiked = post.isLiked;
    final oldCount = post.likeCount;

    post.isLiked = !post.isLiked;
    post.likeCount += post.isLiked ? 1 : -1;

    state = state.copyWith(posts: [...state.posts]);

    try {
      return await repo.toggleLike(post);
    } catch (e) {
      post.isLiked = oldLiked;
      post.likeCount = oldCount;
      state = state.copyWith(posts: [...state.posts]);
      return false;
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    final newPosts = await repo.fetchPosts(state.offset, 10);

    state = state.copyWith(
      isLoading: false,
      offset: state.offset + 10,
      hasMore: newPosts.isNotEmpty,
      posts: [...state.posts, ...newPosts],
    );

  }
}
