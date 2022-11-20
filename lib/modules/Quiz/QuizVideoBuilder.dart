import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieListItem extends StatefulWidget {


   final VideoPlayerController videoPlayerController;
   final bool looping;

  @override
  State<ChewieListItem> createState() => _ChewieListItemState();

   ChewieListItem({required this.videoPlayerController, required this.looping});
}

class _ChewieListItemState extends State<ChewieListItem> {

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
            style: TextStyle(color: Colors.white),
          ),
        );
      }

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
      padding: EdgeInsetsDirectional.all(8.0),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
