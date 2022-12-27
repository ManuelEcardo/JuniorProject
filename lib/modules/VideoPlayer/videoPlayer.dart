import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/models/MerriamWebster_model/merriam_model.dart';
import 'package:juniorproj/modules/VideoPlayer/cubit/cubit.dart';
import 'package:juniorproj/modules/VideoPlayer/cubit/states.dart';
import 'package:juniorproj/modules/VideoPlayer/defShow.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/colors.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:selectable/selectable.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';
import 'package:video_player/video_player.dart';

import '../../models/MainModel/content_model.dart';
import '../../shared/styles/styles.dart';

class VideoGetter extends StatefulWidget {


  final Videos video;

  const VideoGetter(this.video, {Key? key}) : super(key: key);

  @override
  State<VideoGetter> createState() => _VideoGetterState();
}

class _VideoGetterState extends State<VideoGetter> with WidgetsBindingObserver {


  late SubtitleController subtitleController= SubtitleController(  //SubtitleController Helps to manage the subtitles for the video. //WAS FINAL INSTEAD OF LATE

    subtitleUrl: widget.video.videoSubtitle!, //'https://drive.google.com/u/0/uc?id=1x0Qt5gurTM11RDWiuKRCqPrQMlwjgEqp&export=download'
    showSubtitles: true,
    subtitleType: SubtitleType.srt,
  );


  final SelectableController selectableController= SelectableController(); //Controller for the selectable Widget.

  final ScrollController scrollController = ScrollController(); //Controller for scrollable objects if needed.

  var selectableKey=GlobalKey<FormState>();

  var _isTextSelected = false;


  VideoPlayerController get videoController  //Setting a getter for the videoController
  {
    return VideoPlayerController.network(widget.video.videoLink!);
  }

  ChewieController get chewieController {  //Setting a getter for ChewieController which helps to manage the video and it's controls, initialize and fullscreen.
    return ChewieController(
      videoPlayerController: videoController,
      aspectRatio: 16/9,
      autoPlay: false,
      autoInitialize: true,
      allowFullScreen: true,
      zoomAndPan: true,
      errorBuilder: (context,errorMessage)  //Error Message to show.
        {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },

      placeholder: const Center(child: CircularProgressIndicator(),),  //While loading, show Circular Progress
      showControlsOnInitialize: false,  //Won't show options while loading
    );

  }

  // void updateSubtitleUrl({
  //   ExampleSubtitleLanguage? subtitleLanguage,
  // }) {
  //   String? subtitleUrl;
  //   switch (subtitleLanguage) {
  //     case ExampleSubtitleLanguage.english:
  //       //  subtitleUrl = 'https://drive.google.com/u/0/uc?id=1gZ9pHKRoZYdE8C_FH2NbDHa6bLDf5bpt&export=download';
  //       break;
  //     default:
  //   }
  //   if (subtitleUrl != null) {
  //     subtitleController.updateSubtitleUrl(
  //       url: subtitleUrl,
  //     );
  //   }
  // }

  @override
  void initState()
  {
    super.initState();
    selectableController.addListener(_selectionChangedListener);
    WidgetsBinding.instance.addObserver(this); //In Order to implement the application life cycle.
  }

  @override
  void dispose()
  {
   // if (videoController != null && chewieController != null)
    //{
    videoController.dispose(); //Discards any resources used by the object
    chewieController.dispose(); //Dispose the Chewie package.
    //}

    selectableController..removeListener(_selectionChangedListener)..dispose();
    scrollController.dispose();

    super.dispose(); //Called when this object is removed from the tree permanently.

  }

  void _selectionChangedListener() {
    if (_isTextSelected != selectableController.isTextSelected) {
      if (mounted) {
        setState(() {
          _isTextSelected = selectableController.isTextSelected;
        });
      }
    }
  }

  late ChewieController localChewieController = chewieController;

  @override
  Widget build(BuildContext context)  {
    //SubtitleBloc? subtitleBloc;
    //var subtitle;
    //bool isPaused=false;

    // print('This Video Subtitles: ${widget.video.videoSubtitle}');
    return BlocConsumer<WordCubit,WordStates>(
      listener: (context,state)
      {
        if(state is WordsLoadingState)
          {
            defaultToast(msg: 'Loading');
          }

        if(state is WordsErrorState)
          {
            defaultToast(msg: 'Wrong words selected');
          }
        if(state is WordsSuccessState)
          {

            if(WordCubit.model !=null)
              {
                popupDialog(WordCubit.model); //Show Popup that contains the word meaning.
              }
          }
      },
      builder: (context,state)
      {
        var cubit= WordCubit.get(context);
        return WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: ()
                  {
                    localChewieController.videoPlayerController.pause();  //Pausing the video when going back to the Units page.
                    Navigator.pop(context);
                  },),
              actions:
              [
                IconButton(
                  icon:const Icon(Icons.question_mark_rounded),
                  onPressed: ()
                  async {
                    await showDialog(
                        context: context,
                        builder: (context)
                        {
                          return AlertDialog(
                            title: Text(
                              'Video Section',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: HexColor('8AA76C'),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            content:  Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children:
                              const[
                                Text(
                                  'Videos can be stopped either through pressing the stop button, or pressing the box which contains the subtitles',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),

                                Text(
                                  '-Select a word after pausing the video then press translate to check the translation of this word.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),

                                Text(
                                  '- Press the three dots in the video frame to change Playback Speed',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                    );
                  },
                ),

                IconButton(onPressed: (){AppCubit.get(context).changeTheme();}, icon: const Icon(Icons.sunny)),
              ],
            ),

            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 24.0,end: 24.0, bottom: 24.0, top: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:
                  [
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        '${widget.video.videoTitle!}:',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: pistachioColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10,),

                    AspectRatio(
                      aspectRatio: 16/9,
                      child: Chewie(controller: localChewieController,),
                    ),

                    const SizedBox(height: 40,),

                    Selectable(
                      key: selectableKey,
                      selectionController: selectableController,  //Controller for the selectable items.
                      scrollController: scrollController,
                      selectWordOnLongPress: true,
                      selectWordOnDoubleTap: true,
                      popupMenuItems:
                      [
                         SelectableMenuItem(
                            title: 'Translate',
                            type: SelectableMenuItemType.other,  //Type is other because it does something different than the available
                            isEnabled: (selectableController)=>selectableController!.isTextSelected,  //Will check if this item is enabled
                            handler: (selectableController)
                            {
                              cubit.currentWord=selectableController!.getSelection()!.text!; //.split(' ').first  //Storing the selected word in a variable in cubit, remove everything after space.

                              cubit.search(selectableController.getSelection()!.text!);  //.split(' ').first  //Searching for the word using Merriam Webster API

                              localChewieController.videoPlayerController.pause();  //Pausing the video

                             // navigateTo(context, DefinitionShow());          // Navigating to a new class to show the results.

                              selectableController.deselect();  //Deselect the word after searching for it.

                              return true;
                            }

                        ),
                      ],
                      child: GestureDetector(  //If the Subtitles has been pressed, the gesture detector allows taps.
                        onTap: ()
                        {
                          // subtitleBloc= subtitleController.getSubBloc();  //Getting the SubtitleBloc from the SubtitleController through a method I've Created in the SubtitleController class.
                          //
                          // subtitle= subtitleBloc?.subtitles;  //Get ll the subtitles and store them in a variable.
                          //
                          // for( var subItem in subtitle!.subtitles)  //Get to work with each subtitle by itself
                          //     {
                          //   if(subItem.startTime.inSeconds <= localChewieController.videoPlayerController.value.position.inSeconds && localChewieController.videoPlayerController.value.position.inSeconds <= subItem.endTime.inSeconds )  //If the current video time is same as the subtitle timeline,
                          //       {
                          //     DefaultToast(msg: 'Paused');
                          //     localChewieController.videoPlayerController.pause();
                          //     break;  //Break so won't keep on looping inside the for for memory management.
                          //   }
                          // }
                          if(localChewieController.isPlaying)
                            {
                                  defaultToast(msg: 'Paused');
                                  localChewieController.videoPlayerController.pause();
                            }
                          else if (localChewieController.isPlaying ==false)
                            {
                              defaultToast(msg: 'Playing');
                              localChewieController.videoPlayerController.play();
                            }

                        },
                        child: SubtitleWrapper(
                          videoPlayerController: localChewieController.videoPlayerController,  //Specifying the controller of the video.
                          subtitleController: subtitleController,
                          subtitleStyle: const SubtitleStyle(
                            textColor: Colors.white,
                            hasBorder: true,
                            fontSize: 25,
                            borderStyle: SubtitleBorderStyle(

                            ),
                          ),

                          videoChild: Container(  //Here the child isn't a video because I want to show the subtitles below the video => Container
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            width: double.infinity,
                            height: 200,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40,),

                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        'Video description:',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        style: defaultHeadlineTextStyle,
                      ),
                    ),

                    const SizedBox(height: 10,),

                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        widget.video.videoDescription!,
                        style: ordinaryTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //If the user presses back button => the video will be paused.
          onWillPop: ()async
          {
            localChewieController.videoPlayerController.pause();
            return true;

          },

        );

      },

    );

  }


  popupDialog(MerriamModel? model)
  async {
    await Dialogs.materialDialog(
      context: context,
      title: WordCubit.get(context).currentWord.capitalize,
      msg: model!.shortdef!.isNotEmpty ? model.shortdef![0] : '', //model?.shortdef?[0]
      actions:
      [
        TextButton(

          child:const Text(
            'Full Definition',
            style: TextStyle(
              fontSize: 20,
            ),
          ),

          onPressed: ()
          {
            navigateTo(context, const DefinitionShow());
          },
        ),
      ],

      titleAlign: TextAlign.center,
      titleStyle:const TextStyle(
        fontSize: 24,
        color: Colors.black,
      ),

      msgStyle: const TextStyle(
        fontSize: 18,
        color: Colors.black,
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
        localChewieController.videoPlayerController.pause();
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        localChewieController.videoPlayerController.pause();
        // widget is paused
        break;
      case AppLifecycleState.detached:
        localChewieController.videoPlayerController.pause();
      // widget is detached
        break;
    }
  }

}


// enum ExampleSubtitleLanguage {
//   english,
//   spanish,
//   arabic,
// }  //Choose Subtitle Language from here.

