import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/modules/YoutubeVideos/cubit/states.dart';

class YoutubeCubit extends Cubit<YoutubeStates>
{
  YoutubeCubit():super(YoutubeInitialState());

  static YoutubeCubit get(context) => BlocProvider.of(context);



}