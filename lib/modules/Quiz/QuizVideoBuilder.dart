import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieListItem extends StatefulWidget {


   final VideoPlayerController videoPlayerController;
   final bool looping;

  @override
  State<ChewieListItem> createState() => _ChewieListItemState();

   const ChewieListItem({Key? key, required this.videoPlayerController, required this.looping}) : super(key: key);
}

class _ChewieListItemState extends State<ChewieListItem> with WidgetsBindingObserver {

  late ChewieController _chewieController;


  @override
  void initState()
  {
    super.initState();
    _chewieController=ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16/9,
      autoInitialize: true,
      looping: widget.looping,
      autoPlay: false,
      allowFullScreen: true,
      zoomAndPan: false,
      allowPlaybackSpeedChanging: false,
      allowMuting: true,
      showOptions: false,
      errorBuilder: (context,errorMessage)
      {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },

      placeholder: const Center(child: CircularProgressIndicator(),),
      showControlsOnInitialize: false,

    );
  }

  @override
  void dispose()
  {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
    _chewieController.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(8.0),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {  //If the user pressed home or moved to another app, then the video will be paused by implementing the callbacks.
    super.didChangeAppLifecycleState(state);

    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
      // widget is resumed
        break;
      case AppLifecycleState.inactive:
        _chewieController.videoPlayerController.pause();
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        _chewieController.videoPlayerController.pause();
        // widget is paused
        break;
      case AppLifecycleState.detached:
        _chewieController.videoPlayerController.pause();
        // widget is detached
        break;
    }
  }
}
