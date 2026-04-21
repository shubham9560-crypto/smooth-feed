import 'package:smooth_feed/feature/post_feed/data/models/post_model.dart';

class FeedStateModel {
  final List<PostModel> posts;
  final bool isLoading;
  final bool hasMore;
  final int offset;

  FeedStateModel({
    required this.posts,
    required this.isLoading,
    required this.hasMore,
    required this.offset,
  });

  FeedStateModel copyWith({
    List<PostModel>? posts,
    bool? isLoading,
    bool? hasMore,
    int? offset,
  }) {
    return FeedStateModel(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
    );
  }
}
