import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class WaterlooYouTubeThumbnail extends StatelessWidget {
  final YouTubeVideoIdProvider videoIdProvider;

  const WaterlooYouTubeThumbnail({Key? key, required this.videoIdProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<YouTubeVideoIdProvider>.value(
        value: videoIdProvider,
        child: Consumer<YouTubeVideoIdProvider>(builder: (consumerContext, provider, _) {
          if (provider.videoId.isNotEmpty) {
            try {
              return Image.network(YoutubePlayerController.getThumbnail(videoId: provider.videoId));
            } catch (ex) {
              return Container();
            }
          } else {
            return Container();
          }
        }));
  }
}

class WaterlooYouTubePlayer extends StatelessWidget {
  final String videoId;

  const WaterlooYouTubePlayer({Key? key, required this.videoId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    YoutubePlayerController _controller =
        YoutubePlayerController(initialVideoId: videoId, params: const YoutubePlayerParams());

    return YoutubePlayerIFrame(
      controller: _controller,
      aspectRatio: 16 / 9,
    );
  }
}

abstract class YouTubeVideoIdProvider with ChangeNotifier {
  String get videoId;
}
