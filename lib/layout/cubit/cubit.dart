import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:juniorproj/modules/Achievements/achievements.dart';
import 'package:juniorproj/modules/Home/home.dart';
import 'package:juniorproj/modules/Profile/profile.dart';
import 'package:juniorproj/shared/network/local/cache_helper.dart';
import 'package:juniorproj/layout/cubit/states.dart';

import '../../modules/Languages/languages.dart';

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

  // List<Widget> actionIcon=  //Action Icon when bottom nav bar is changed
  // [
  //   Icon(Icons.question_mark_rounded),
  //   Icon(Icons.add_rounded),
  //   Icon(Icons.question_mark_rounded),
  //   Icon(Icons.question_mark_rounded),
  // ];
  //
  // List<void Function()>actionAction= //Action action when bottom nav bar is changed
  // [
  //   ()
  //   {
  //     print('pressed 1');
  //
  //   },
  //
  //   ()
  //   {
  //     print('pressed 2');
  //   },
  //
  //   ()
  //   {
  //     print('pressed 3');
  //   },
  //
  //   ()
  //   {
  //     print('pressed 4');
  //   },
  // ];

  int currentIndex=0;  //The Index of the BottomNavBar item.

  void changeBottom(int index) //Function will be called when the bottom navigation bar item has changed, which will change the index and emit the state.
  {
    currentIndex=index;
    emit(AppChangeBottomNavBarState());

    emit(AppChangeActionState());
  }

  bool isDarkTheme=false;

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
}