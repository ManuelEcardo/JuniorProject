import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/models/MerriamWebster_model/merriam_model.dart';
import 'package:juniorproj/modules/VideoPlayer/cubit/states.dart';
import 'package:juniorproj/shared/network/remote/merriam_dio_helper.dart';

class WordCubit extends Cubit<WordStates>
{
  WordCubit():super(InitialWordsState());

  static WordCubit get(context) => BlocProvider.of(context);

  static MerriamModel? model;

  String? currentWord;

  void search(String text)
   {
    emit(WordsLoadingState());

    MerriamDioHelper.getData(
        url: 'v3/references/collegiate/json/$text',
        query:{'key':'dc4e63df-1cd8-4853-863d-cc32dfa6cbcf'},
    ).then((value)
         {
          model= MerriamModel.fromJson(value.data[0]);
          print(model?.meta?.id?.replaceAll(RegExp('[^A-Za-z]'), ''));
          emit(WordsSuccessState());
        }
    ).catchError((error)
    {
      print('ERROR IN GETTING MERRIAM DATA, ${error.toString()} ');
      emit(WordsErrorState(error.toString()));
    }
    );
  }
}