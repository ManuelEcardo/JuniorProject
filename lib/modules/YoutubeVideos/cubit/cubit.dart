
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/models/YoutubeModel/PopularVideos/popularVideos.dart';
import 'package:juniorproj/models/YoutubeModel/SearchVideos/YoutubeSearchModel.dart';
import 'package:juniorproj/modules/YoutubeVideos/cubit/states.dart';
import 'package:juniorproj/shared/network/end_points.dart';
import 'package:juniorproj/shared/network/remote/main_dio_helper.dart';
import 'package:juniorproj/shared/network/remote/youtube_dio_helper.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../models/MainModel/content_model.dart';
import '../../../shared/components/components.dart';
import '../../Videos/VideoPlayer/videoPlayer.dart';

class YoutubeCubit extends Cubit<YoutubeStates>
{
  YoutubeCubit():super(YoutubeInitialState());

  static YoutubeCubit get(context) => BlocProvider.of(context);


  static PopularYoutubeVideos? youtubeVideosModel;

  void youtubeGetVideos({String? pageToken} )
  {
    emit(YoutubeGetVideosLoadingState());
    YoutubeDioHelper.getData(
      url: youtubeVideos,
      query:
      {
        'key': youtubeToken,
        'chart':'mostPopular',
        'pageToken':pageToken,
        'part':'contentDetails,snippet',
      },
    ).then((value)
    {
      //print(value.data);
      youtubeVideosModel=PopularYoutubeVideos.fromJson(value.data);

      emit(YoutubeGetVideosSuccessState());
    }).catchError((error)
    {
      print('ERROR WHILE GETTING YOUTUBE VIDEOS, ${error.toString()}');
      emit(YoutubeGetVideosErrorState());
    });
  }

  static YoutubeSearchModel? youtubeSearchModel;

  void youtubeSearch({String? item, String? pageToken})
  {
    emit(YoutubeSearchLoadingState());

    YoutubeDioHelper.getData(
      url:youtubeVideosSearch,
      query:
      {
        'key': youtubeToken,
        'pageToken':pageToken,
        'part':'snippet',
        'q':item,
        'type':'video',
        'regionCode':'us'
      },
    ).then((value)
    {
      print(value.data);

      youtubeSearchModel=YoutubeSearchModel.fromJson(value.data);
      emit(YoutubeSearchSuccessState());

    }).catchError((error)
    {
      print('ERROR WHILE YOUTUBE SEARCH, ${error.toString()}');
      emit(YoutubeSearchErrorState());
    });
  }


  void clearYoutubeSearchModel()  //Empty the Search Model, so next time it's accessed it's empty
  {
    youtubeSearchModel=null;
    emit(YoutubeSearchEmptyState());
  }


  //Send the organized Subtitle file that as (.txt) to main database and get a link containing the same file but as (.srt) format.
  Future<void> getSub(File file, {required BuildContext context, required String videoDescription, required String videoLink, required String videoTitle })
  async {
    emit(YoutubeGetSrtLoadingState());

    FormData formData= FormData.fromMap({"subtitle": await MultipartFile.fromFile(file.path,filename:'name'),});  //Add the File as formData

    MainDioHelper.postFileData(
        url: getSrt,
        data:formData,
    ).then((value)
    {
      print(value.data);

      emit(YoutubeGetSrtSuccessState());

      Videos v1= Videos(
        videoDescription: videoDescription,
        videoLink: videoLink,
        videoTitle: videoTitle,
        videoSubtitle: value.data,
      );
      navigateTo(
          context,
          ShowCaseWidget(
              builder: Builder(
                builder: (context)=>VideoGetter(v1),
              )
          ),
      );  //Show the video with it's subtitle

    }).catchError((error)
    {
      defaultToast(msg: 'Error While Exporting Subtitles');
      print('ERROR WHILE GETTING SRT,${error.toString()}');
      emit(YoutubeGetSrtErrorState());
    });

  }


}