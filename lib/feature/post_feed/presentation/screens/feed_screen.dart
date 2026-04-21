import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:smooth_feed/feature/post_feed/presentation/screens/detailed_screen.dart';
import 'package:smooth_feed/feature/post_feed/presentation/widgets/postcard.dart';
import 'package:smooth_feed/feature/post_feed/providers/feed_notifier.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    // loadMore();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(feedProvider.notifier).loadMore();
    });

    _controller.addListener(() {
      // debugPrint(
      //   "scroll pos cur: ${_controller.position.pixels} max:${_controller.position.maxScrollExtent} ",
      // );
      if (_controller.position.pixels >= _controller.position.maxScrollExtent) {
        ref.read(feedProvider.notifier).loadMore();
      }
    });
  }

  void onLikeTapped(int index) async {
    final bool isConnected = await InternetConnection().hasInternetAccess;
    if (!isConnected) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("No internet ")));
      }
      return;
    }

    bool isLiked = await ref.read(feedProvider.notifier).toggleLike(index);
    if (mounted && !isLiked) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to like")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(feedProvider);
    return Scaffold(
      body: Center(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(feedProvider.notifier).refresh();
          },
          child: ListView.builder(
            controller: _controller,
            itemCount: feed.posts.length,
            itemBuilder: (context, index) {
              // if (index == feed.posts.length) {
              //   return feed.isLoading
              //       ? const Padding(
              //           padding: EdgeInsets.all(16),
              //           child: Center(child: CircularProgressIndicator()),
              //         )
              //       : const SizedBox();
              // }

              return PostCard(
                imageUrl: feed.posts[index].imageUrl,
                likeCount: feed.posts[index].likeCount,
                isLiked: feed.posts[index].isLiked,
                onLike: () => onLikeTapped(index),
                onTap: () {
                  //debugPrint("passing ${feed.posts[index].imageUrl}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailedScreen(post: feed.posts[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
