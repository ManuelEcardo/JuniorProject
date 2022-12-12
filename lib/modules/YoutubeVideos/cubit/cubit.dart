import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/models/YoutubeModel/PopularVideos/popularVideos.dart';
import 'package:juniorproj/models/YoutubeModel/SearchVideos/YoutubeSearchModel.dart';
import 'package:juniorproj/modules/YoutubeVideos/cubit/states.dart';
import 'package:juniorproj/shared/network/end_points.dart';
import 'package:juniorproj/shared/network/remote/youtube_dio_helper.dart';

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

}