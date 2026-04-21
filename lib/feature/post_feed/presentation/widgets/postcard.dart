import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String imageUrl;
  final int likeCount;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onTap;

  const PostCard({
    super.key,
    required this.imageUrl,
    required this.likeCount,
    required this.isLiked,
    required this.onLike,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onDoubleTap: () => onLike(),
        onTap: onTap,

        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(150),
                blurRadius: 5,
                spreadRadius: 5,
                offset: const Offset(0, 1),
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(25),
            child: Stack(
              children: [
                ///Image
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Hero(
                    tag: imageUrl,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      cacheWidth: 300,
                    ),
                  ),
                ),

                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: onLike,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isLiked ? Colors.red : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: isLiked ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),
                      Text(
                        likeCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
