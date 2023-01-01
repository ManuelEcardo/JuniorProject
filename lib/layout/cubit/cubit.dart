import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/models/MainModel/favourites_model.dart';
import 'package:juniorproj/models/MainModel/languages_model.dart';
import 'package:juniorproj/models/MainModel/leaderboards_model.dart';
import 'package:juniorproj/models/MainModel/units_model.dart';

import 'package:juniorproj/modules/Achievements/achievements.dart';
import 'package:juniorproj/modules/Home/home.dart';
import 'package:juniorproj/modules/Profile/profile.dart';
import 'package:juniorproj/shared/network/local/cache_helper.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/shared/network/remote/main_dio_helper.dart';

import '../../models/MainModel/achievements_model.dart';
import '../../models/MainModel/content_model.dart';
import '../../models/MainModel/userAchievements_model.dart';
import '../../models/MainModel/userData_model.dart';
import '../../modules/Languages/languages.dart';
import '../../shared/components/components.dart';
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


  int currentIndex=1;  //The Index of the BottomNavBar item.

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

  void updateUserLanguagesAndUnits()  //Update User Languages and Units when called, in order to lock units for example
  {
    print('in updateUserLanguagesAndUnits');
    emit(AppUserLangUnitsLoadingState());
    try
    {
      userModel?.user?.units?.forEach((element)  //Round each element in his units list and adding languages ids and units ids to a list.
      {
        if(userModel!.user?.userLanguages.contains(element.languageId) ==false )  //checking if this language id is not there
            {
          userModel!.user?.userLanguages.add(element.languageId!); //Adding the language id to the users languages list.

          userModel!.user?.userUnits[element.languageId!]=[]; //Initializing The List

          if(userModel!.user?.userUnits[element.languageId]!.contains(element.unitId) ==false) //If this unit is not in the UnitList for this Language, then add it
              {
            userModel!.user?.userUnits[element.languageId]!.add(element.unitId!);
          }
        }

        else //Language is Added, Will check for the new unit
            {
          if(userModel!.user!.userUnits[element.languageId]!.contains(element.unitId) ==false) //If this unit is not in the UnitList for this Language, then add it
              {
            userModel!.user!.userUnits[element.languageId]!.add(element.unitId!);
          }
        }
      });

      emit(AppUserLangUnitsSuccessState());
    }

    catch(error)
    {
      print('Couldn\'t add units or Languages, ${error.toString()}');
      emit(AppUserLangUnitsErrorState());
    }


    print('User Registered Languages are: ${userModel!.user?.userLanguages}');
    print('User Registered Units are: ${userModel!.user?.userUnits}');
  }

  //-----------------------

  //QUIZ ELEMENTS

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

  //Calculating Quiz marks

  final totalMark= 10; //Total quiz mark
  late double eachQuestionMark; //each question mark
  double finalMark=0; //student mark

  void markCalculator(int questionsNumber)
  {
    eachQuestionMark= totalMark/questionsNumber; //setting each question mark by dividing the total mark to the number of questions we have.
    emit(AppQuizTotalMarkState());
  }

  void markAdder(bool isCorrect)
  {
    if(isCorrect)
    {
      finalMark= finalMark+ eachQuestionMark;
    }
    emit(AppQuizAddMarkState());
  }

  //Setting FinalMark back to 0
   void setFinalMarkToZero()
  {
    finalMark=0;
    emit(AppQuizInitialMarkState());
  }


  //----------------------------------------------------------------------------------------------------------------\\

  // MAIN APP APIS:

  // GET METHODS:


  // GET USER DATA
  static UserModel? userModel; // get user info

  void userData()
  {
    if(token != '') //If token is empty, then don't do the request.
      {
        emit(AppGetUserDataLoadingState());
        MainDioHelper.getData(
          url: info,
          token: token,
        ).then((value)
        {
          print(value.data);
          userModel=UserModel?.fromJson(value.data);

          emit(AppGetUserDataSuccessState());

          updateUserLanguagesAndUnits();

          getFavourites();

        }
        ).catchError((error)
        {
          print('ERROR IN GETTING USER DATA, ${error.toString()}');
          emit(AppGetUserDataErrorState());
        }
        );
      }
  }

  //----------------

  //Get all Languages
  static LanguageModel? languagesModel;

  void getLanguages()
  {
    emit(AppGetLanguagesLoadingState());

    MainDioHelper.getData(
      url: languages,
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

  //Get Achievements

  static AchievementsModel? achievementsModel;
  void getAchievements()
  {
    emit(AppGetAchievementsLoadingState());

    MainDioHelper.getData(
      url: achievements,
    ).then((value)
    {
      print('Available Achievements:, ${value.data}');

      achievementsModel=AchievementsModel.fromJson(value.data);

      emit(AppGetAchievementsSuccessState());
    }).catchError((error)
    {
      print('ERROR WHILE GETTING ACHIEVEMENTS, ${error.toString()}');
      emit(AppGetAchievementsErrorState());
    });
  }
  
  //-----------------
  
  
  //Get User Achievements
  
  static UserAchievementsModel? userAchievementsModel;
  
  void getUserAchievements()
  {
    if(token != '')
      {
        emit(AppGetUserAchievementsLoadingState());

        MainDioHelper.getData(
          url: userAchievements,
          token: token,
        ).then((value)
        {
          print(value.data);

          userAchievementsModel= UserAchievementsModel.fromJson(value.data);
          emit(AppGetUserAchievementsSuccessState());
        }).catchError((error)
        {
          print('ERROR WHILE GETTING USER ACHIEVEMENTS, ${error.toString()}');
          emit(AppGetUserAchievementsErrorState());
        });
      }
  }


  static void staticGetUserAchievements() //Test for statically
  {
    if(token != '')
    {
      MainDioHelper.getData(
        url: userAchievements,
        token: token,
      ).then((value)
      {
        print(value.data);

        userAchievementsModel= UserAchievementsModel.fromJson(value.data);
      }).catchError((error)
      {
        print('ERROR WHILE GETTING USER ACHIEVEMENTS, ${error.toString()}');
      });
    }

  }


  static UnitsModel? unitsModel;

  void getAllUnits(int languageId)
  {
    emit(AppGetAllUnitsLoadingState());
    MainDioHelper.getData(
      url: '$languageId/$allUnits',
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
        url: '$units/$unitId',
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


  //Get Leaderboards
  static LeaderboardsModel? leaderboardsModel;

  void getLeaderboards()
  {
    print('Getting Leaderboards');
    emit(AppGetLeaderboardsLoadingState());

    MainDioHelper.getData(
        url: leaderboards
    ).then((value)
    {
      print('PRINTING LEADERBOARDS VALUES: ${value.data}');

      leaderboardsModel= LeaderboardsModel?.fromJson(value.data);
      emit(AppGetLeaderboardsSuccessState());
    }).catchError((error)
    {
      print('ERROR WHILE GETTING LEADERBOARDS, ${error.toString()}');
      emit(AppGetLeaderboardsErrorState());
    });
  }


  //FAVOURITES:

  //1. Get User Favourites List.

  static FavouritesModel? favouritesModel;

  void getFavourites()
  {
    if(token != '')
      {
        emit(AppGetFavouritesLoadingState());

        MainDioHelper.getData(
          url: 'user/$favourites',
          token: token,
        ).then((value)
        {
          print('Favourites are: ${value.data}');
          favouritesModel= FavouritesModel.fromJson(value.data);
          emit(AppGetFavouritesSuccessState());
        }).catchError((error)
        {
          print('ERROR WHILE GETTING FAVOURITES, ${error.toString()}');
          emit(AppGetFavouritesErrorState());
        });
      }
  }

  //--------------




  //--------------------------------------------------------\\


  // PUT METHODS :

  //Update User Info.
  void putUserInfo(String? firstName, String? lastName, String? userPhoto)
  {
    String? fname,lname,photo;

    emit(AppPutUserInfoLoadingState());

    firstName ==null ? fname=userModel!.user!.firstName : fname=firstName;  //If FirstName of Last Name or User photo is not null then use it's value, else use the one in UserModel.

    lastName ==null ? lname=userModel!.user!.lastName : lname=lastName;

    userPhoto ==null ? photo=userModel!.user!.userPhoto : photo=userPhoto;

    MainDioHelper.patchData(
        url: '$profile/${userModel!.user!.id}',
        data:
        {
          'first_name':fname,
          'last_name':lname,
          'gender':userModel!.user!.gender,
          'birth_date': userModel!.user!.birthDate,
          'user_photo': photo,
        },
    ).then((value)
    {
      userData(); //To Update the current values.
      emit(AppPutUserInfoSuccessState());
    }).catchError((error)
    {
      print('ERROR WHILE PUTTING USER INFO ${error.toString()}');
      emit(AppPutUserInfoErrorState());
    });
  }



  //--------------------------------


  //POST API METHODS


  //Add a Language to user.

  void postLanguageUser(int languageId)
  {
    emit(AppPostUserLanguageLoadingState());

    MainDioHelper.postData(
        url: 'user/$addLanguage/$languageId',
        token: token,
        data: {},
    ).then((value)
    {
      print(value.data);
      userModel=null;
      userData(); // After Adding a language, delete his model and get data again.
      emit(AppPostUserLanguageSuccessState());
    }).catchError((error)
    {
      print('ERROR IN POST_LANGUAGE_USER, ${error.toString()}');
      emit(AppPostUserLanguageErrorState());
    });

  }

  //User Logout

  void logoutUserOut(BuildContext context)
  {
    emit(AppUserSignOutLoadingState());
    MainDioHelper.postData(
        url: logout,
        token:token,
        data: {},
    ).then((value)
    {
      changeBottom(0);
      signOut(context);
      userModel=null;
      emit(AppUserSignOutSuccessState());
      exit(0);
    }).catchError((error)
    {
      print('ERROR WHILE SIGNING OUT, ${error.toString()}');
      emit(AppUserSignOutErrorState());
    });
  }


  //Set A unit as completed for the user
  void setUnitAsComplete(int unitId)
  {
    print('in SetUnitAsComplete');
    emit (AppSetUnitAsCompletedLoadingState());
    
    MainDioHelper.postData(
        url: '$setUnitAsCompleted/$unitId',
        data: {},
        token: token,
    ).then((value)

    {
      print(value.data);
      userData();
      emit(AppSetUnitAsCompletedSuccessState());
    }).catchError((error)
    {
      print('ERROR WHILE SETTING UNIT AS COMPLETED, ${error.toString()}');
      emit(AppSetUnitAsCompletedErrorState());
    });
  }

  // Add A Favourite Word to the user's list.

  void addFavourites(String text)
  {
    emit(AppAddFavouritesLoadingState());
    MainDioHelper.postData(
        url: 'user/$favourites/add',
        data: {},
        token: token,
        query:
        {
          'vocabulary':text
        },
    ).then((value)
    {
      print(value.data);

      changeFav(true); //Change The word to  favourite.

      getFavourites();

      defaultToast(msg: 'Added successfully');
      emit(AppAddFavouritesSuccessState());
    }).catchError((error)
    {
      defaultToast(msg: 'Error while adding');
      print('ERROR WHILE ADDING WORD TO FAVOURITES, ${error.toString()}');
      emit(AppAddFavouritesErrorState());
    });
  }

  // Delete a word from favourites list.
  void deleteFavourite(String text)
  {
    emit(AppDeleteFavouritesLoadingState());

    MainDioHelper.deleteData(
        url: 'user/$favourites/$delete',
        data: {},
        token: token,
        query: {
          'vocabulary':text
        },
    ).then((value)
    {
      print(value.data);

      changeFav(false); //Change The word to non favourite.

      getFavourites();

      defaultToast(msg: 'Deleted successfully');
      emit(AppDeleteFavouritesSuccessState());
    }).catchError((error)
    {
      defaultToast(msg: 'Error while deleting');
      emit(AppDeleteFavouritesErrorState());
    });
  }



  bool isWordFav=false;

  void changeFav(bool fav) //Change Fav to false or true
  {
    if(fav)
    {
      isWordFav=true;
      emit(AppWordChangeTrueFav());
    }
    else
    {
      isWordFav=false;
      emit(AppWordChangeFalseFav());
    }
  }

  bool checkWordAtUser(FavouritesModel? favouritesModel, String word)  //Search for the word set isWordFav
  {
    for( var element in favouritesModel!.item)
    {
      if(element.vocabulary == word)
      {
        changeFav(true);
        return true;
      }
    }
    changeFav(false);
    return false;
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