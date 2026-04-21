import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smooth_feed/feature/post_feed/data/models/post_model.dart';

class DetailedScreen extends StatefulWidget {
  final PostModel post;

  const DetailedScreen({super.key, required this.post});
  @override
  State<DetailedScreen> createState() => _DetailedScreenState();
}

class _DetailedScreenState extends State<DetailedScreen> {
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoaded = true;
      });
    });
  }

  void downloadHighRes(String imageUrl) async {
    print("Downloading: $imageUrl");

    try {
      final dio = Dio();
      final dir = await getDownloadsDirectory();
      final filePath =
          "${dir!.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg";

      await dio.download(imageUrl, filePath);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Downloaded")));
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Downloade failed")));
      }
    }
  }

  Future<void> downloadToGallery(String url) async {
    final hdDownloadLink = url.replaceAll("300", "1080");
    try {
      final response = await Dio().get(
        hdDownloadLink,
        options: Options(responseType: ResponseType.bytes),
      );

      await ImageGallerySaverPlus.saveImage(response.data);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Downloaded")));
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Downloade failed")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("getting ${widget.post.imageUrl}");
    return Scaffold(
      body: ListView(
        children: [
          Hero(
            tag: widget.post.imageUrl,
            child: Stack(
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    widget.post.imageUrl,
                    cacheWidth: 300,

                    fit: BoxFit.contain,
                  ),
                ),

                AnimatedOpacity(
                  opacity: isLoaded ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: Image.network(
                    widget.post.imageUrl.replaceAll("300", "1080"),

                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () async {
                // downloadHighRes(widget.post.imageUrl);
                downloadToGallery(widget.post.imageUrl);
              },
              child: const Text("Download High-Res"),
            ),
          ),
        ],
      ),
    );
  }
} //
