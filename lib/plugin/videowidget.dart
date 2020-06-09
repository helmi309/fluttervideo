import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final bool play;
  final String url;

  const VideoWidget({
    @required this.url,
    @required this.play,
    Key key,
  }) : super(key: key);

  @override
  VideoWidgetState createState() => VideoWidgetState();
}

class VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoPlayerController = new VideoPlayerController.network(widget.url);

    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return new Container(
            child: Card(
              key: new PageStorageKey(widget.url),
              elevation: 1.0,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Chewie(
                      key: new PageStorageKey(widget.url),
                      controller: ChewieController(
                        videoPlayerController: videoPlayerController,
                        aspectRatio: videoPlayerController.value.aspectRatio,
                        // Prepare the video to be played and display the first frame
//                        autoInitialize: false,
                        looping: true,
                        autoPlay: true,
                        showControls: true,

                        // Errors can occur for example when trying to play a video
                        // from a non-existent URL
                        errorBuilder: (context, errorMessage) {
                          return Center(
                            child: Text(
                              "Tidak Dapat Memeat Video Dengan Benar",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(
              child: Column(children: <Widget>[
            Center(child: CircularProgressIndicator()),
            Center(child: Text(' Loading Video...'))
          ]));
        }
      },
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    //    widget.videoPlayerController.dispose();
    super.dispose();
  }
}
