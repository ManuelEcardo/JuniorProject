import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/models/MainModel/languages_model.dart';
import 'package:juniorproj/models/MainModel/units_model.dart';

import 'package:juniorproj/modules/Achievements/achievements.dart';
import 'package:juniorproj/modules/Home/home.dart';
import 'package:juniorproj/modules/Profile/profile.dart';
import 'package:juniorproj/shared/network/local/cache_helper.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/shared/network/remote/main_dio_helper.dart';

import '../../models/MainModel/content_model.dart';
import '../../models/MainModel/login_model.dart';
import '../../models/MainModel/userData_model.dart';
import '../../models/MainModel/userData_model.dart';
import '../../modules/Languages/languages.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/end_points.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit(): super(AppInitialState());

  static AppCubit get(context) =>BlocProvider.of(context);

  List<Widget> list= //List of the widgets each bottomNav item will open.
  [
    const HomePage(),
    const LanguagesPage(),
    const AchievementsPage(),
    ProfilePage(),
  ];


  int currentIndex=0;  //The Index of the BottomNavBar item.

  void changeBottom(int index) //Function will be called when the bottom navigation bar item has changed, which will change the index and emit the state.
  {
    currentIndex=index;
    emit(AppChangeBottomNavBarState());

    emit(AppChangeActionState());
  }

  bool isDarkTheme=false; //Check if the theme is Dark.

  void changeTheme({bool? themeFromState})
  {
    if(themeFromState !=null)  //if a value is sent from main, then use it.. we didn't use CacheHelper because the value has already came from cache, then there is no need to..
        {
      isDarkTheme=themeFromState;
      emit(AppChangeThemeModeState());
    }
    else                      // else which means that the button of changing the theme has been pressed.
        {
      isDarkTheme= !isDarkTheme;
      CacheHelper.putBoolean(key: 'isDarkTheme', value: isDarkTheme).then((value)  //Put the data in the sharedPref and then emit the change.
      {
        emit(AppChangeThemeModeState());
      });
    }

  }


  bool isHome() //If its Home, will return true
  {
    if(currentIndex==0)
      {
        return true;
      }
    else
      {
        return false;
      }
  }

  bool isLanguage()  //In order to show FloatingActionButton only in the Languages Page, a check will happen on the index, if 2 then it's languages page, will return true.
  {
    if(currentIndex==1)
      {
        return true;
      }
    else
      {
        return false;
      }
  }

  bool isAchievement()
  {
    if(currentIndex==2)
      {
        return true;
      }
    else
      {
        return false;
      }
  }

  bool isProfile()  //If in Profile Widget, a question mark Icon will show.
  {
    if(currentIndex==3)
      {
        return true;
      }
    else
      {
        return false;
      }
  }


  bool isLastQuiz=false;    // Is this the last question.
  bool isCorrectQuiz=false; // Is this answer correct.
  bool isVisibleQuiz= false; // Is Correct or False visible.
  bool isBoxTappedQuiz=false;

  bool isAnimationQuiz=false;

  void changeQuizIsLast(int index, int tbd)  //TBD SHOULD BE THE MODEL IN THIS CUBIT>>>>
  {
    if(index == tbd-1)
      {
        isLastQuiz=true;
        isVisibleQuiz=false;
        emit(AppQuizChangeisLastState());
      }
    else
      {
        isLastQuiz=false;
        isVisibleQuiz=false;
        emit(AppQuizChangeisLastState());
      }
  }

  void changeQuizIsVisible(bool b)
  {
      isVisibleQuiz=b;
      emit(AppQuizChangeisVisibleState());
  }

  void changeIsCorrectQuiz(bool b)
  {
    if(b==true)
      {
        isCorrectQuiz=true;
        emit(AppQuizChangeisCorrectState());
      }
    else
      {
        isCorrectQuiz=false;
        emit(AppQuizChangeisCorrectState());
      }
  }

  void changeIsBoxTappedQuiz(bool b)  //If True then other choices can't be pressed, meaning the user has already chosen a choice.
  {
    isBoxTappedQuiz=b;
    emit(AppQuizChangeisBoxTappedState());
  }

  void changeIsAnimation(bool b)
  {
    isAnimationQuiz=b;
    emit(AppQuizChangeisAnimationState());
  }


  //----------------------------------------------------------------------------------------------------------------\\

  // GET FROM API METHODS.


  // GET USER DATA
  static UserModel? userModel; // get user info

  void userData()
  {

    emit(AppGetUserDataLoadingState());
    MainDioHelper.getData(
      url: INFO,
      token: token,
    ).then((value)
    {
      print(value.data);
      userModel=UserModel?.fromJson(value.data);
      emit(AppGetUserDataSuccessState());
    }
    ).catchError((error)
    {
      print('ERROR IN GETTING USER DATA, ${error.toString()}');
      emit(AppGetUserDataErrorState());
    }
    );
  }

  //----------------

  //Get all Languages
  static LanguageModel? languagesModel;

  void getLanguages()
  {
    emit(AppGetLanguagesLoadingState());

    MainDioHelper.getData(
      url: LANGUAGES,
    ).then((value)
    {
      //print(value.data);
      languagesModel= LanguageModel?.fromJson(value.data);
      emit(AppGetLanguagesSuccessState());

    }).catchError((error)
    {
      print('ERROR IN GETTING LANGUAGES : ${error.toString()}');
      emit(AppGetLanguagesErrorState());
    });
  }

  //-----------------

  //Get Units for a specified Language. LanguageID is passed through.
  static UnitsModel? unitsModel;

  void getAllUnits(int languageId)
  {
    emit(AppGetAllUnitsLoadingState());
    MainDioHelper.getData(
      url: '$languageId/$ALLUNITS',
      query:{},
    ).then((value)
    {
      print(value.data);

      unitsModel= UnitsModel?.fromJson(value.data);
      emit(AppGetAllUnitsSuccessState());

    }).catchError((error)
    {
      print('ERROR IN GETTING ALL UNITS : ${error.toString()}');
      emit(AppGetAllUnitsErrorState());
    });
  }


  //-----------------


  //Get Unit Contents
  static ContentModel? contentModel;

  void getUnitContent(int unitId)
  {
    emit(AppGetUnitContentLoadingState());

    MainDioHelper.getData(
        url: '$UNITS/$unitId',
    ).then((value)
    {
      print(value.data);

      contentModel=ContentModel?.fromJson(value.data);

      emit(AppGetUnitContentSuccessState());
    }).catchError((error)
    {
      print('ERROR IN GETTING UNIT $unitId CONTENT, ${error.toString()}');

      emit(AppGetLanguagesErrorState());
    });
  }


  //Update User Info.
  void putUserInfo(String? firstName, String? lastName, String? userPhoto)
  {
    String? fname,lname,photo;

    emit(AppPutUserInfoLoadingState());

    firstName ==null ? fname=userModel!.data!.user![0].firstName : fname=firstName;  //If FirstName of Last Name or Userphoto is not null then use it's value, else use the one in UserModel.

    lastName ==null ? lname=userModel!.data!.user![0].lastName : lname=lastName;

    userPhoto ==null ? photo=userModel!.data!.user![0].userPhoto : photo=userPhoto;

    MainDioHelper.putData(
        url: '$PROFILE/${userModel!.data!.user![0].id}',
        data:
        {
          'first_name':fname,
          'last_name':lname,
          'gender':userModel!.data!.user![0].gender,
          'birth_date': userModel!.data!.user![0].birthDate,
          'user_photo': photo,
        },
    ).then((value)
    {
      emit(AppPutUserInfoSuccessState());
    }).catchError((error)
    {
      print('ERROR WHILE PUTTING USER INFO ${error.toString()}');
      emit(AppPutUserInfoErrorState());
    });
  }


  //User Logout

  void logoutUserOut(BuildContext context)
  {
    emit(AppUserSignOutLoadingState());
    MainDioHelper.postData(
        url: LOGOUT,
        token:token,
        data: {},
    ).then((value)
    {
      signOut(context);
      userModel=null;
      emit(AppUserSignOutSuccessState());
    }).catchError((error)
    {
      print('ERROR WHILE SIGNING OUT, ${error.toString()}');
      emit(AppUserSignOutErrorState());
    });
  }



  //-----------------


  // //Get lessons for a specified language
  // static LessonModel? lessonModel;
  //
  // void getLessons(int Id)
  // {
  //   emit(AppGetLessonsLoadingState());
  //
  //   MainDioHelper.getData(
  //     url: '$unitsModel/$LESSONS',
  //
  //   ).then((value)
  //   {
  //     print(value.data);
  //
  //     lessonModel= LessonModel?.fromJson(value.data);
  //
  //     emit(AppGetLanguagesSuccessState());
  //   }).catchError((error)
  //   {
  //     print('ERROR IN GETTING LESSONS : ${error.toString()}');
  //
  //     emit(AppGetLanguagesErrorState());
  //   });
  // }


  // //Get Questions for a specified Language
  // static QuestionModel? questionModel;
  //
  // void getQuestions(int id)
  // {
  //   emit(AppGetQuestionsLoadingState());
  //
  //   MainDioHelper.getData(
  //       url:'$id/$QUESTIONS'
  //   ).then((value)
  //   {
  //     print(value.data);
  //
  //     //questionModel= QuestionModel?.fromJson(value.data);
  //
  //     emit(AppGetQuestionsSuccessState());
  //   }).catchError((error)
  //   {
  //     print('ERROR IN GETTING QUESTIONS: ${error.toString()}');
  //     emit(AppGetLanguagesErrorState());
  //   });
  // }
}