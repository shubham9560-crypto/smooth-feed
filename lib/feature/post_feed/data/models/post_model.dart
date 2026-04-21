// ignore_for_file: public_member_api_docs, sort_constructors_first
class PostModel {
  final String imageUrl;
  int likeCount;
  bool isLiked;
  PostModel({required this.imageUrl, this.likeCount = 0, this.isLiked = false});

  PostModel copyWith({String? imageUrl, int? likeCount, bool? isLiked}) {
    return PostModel(
      imageUrl: imageUrl ?? this.imageUrl,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
