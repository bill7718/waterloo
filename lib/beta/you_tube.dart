library you_tube;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class NotifiableYouTubeThumbnail extends StatelessWidget {
  final ValueNotifier<String> videoId;

  const NotifiableYouTubeThumbnail({Key? key, required this.videoId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ValueNotifier<String>>.value(
        value: videoId,
        child: Consumer<ValueNotifier<String>>(builder: (consumerContext, provider, _) {
          if (provider.value.isNotEmpty) {
            try {
              return YouTubeThumbnail(videoId: provider.value);
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

class YouTubeThumbnail extends StatelessWidget {

  final String videoId;

  const YouTubeThumbnail({Key? key, required this.videoId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(YoutubePlayerController.getThumbnail(videoId: videoId));
  }
}


