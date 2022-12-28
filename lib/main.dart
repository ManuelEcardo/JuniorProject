import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/modules/Login/login_screen.dart';
import 'package:juniorproj/modules/VideoPlayer/cubit/cubit.dart';
import 'package:juniorproj/modules/YoutubeVideos/cubit/cubit.dart';
import 'package:juniorproj/modules/on_boarding/on_boarding_screen.dart';
import 'package:juniorproj/shared/bloc_observer.dart';
import 'package:juniorproj/shared/components/constants.dart';
import 'package:juniorproj/shared/network/end_points.dart';
import 'package:juniorproj/shared/network/local/cache_helper.dart';
import 'package:juniorproj/shared/network/remote/main_dio_helper.dart';
import 'package:juniorproj/shared/network/remote/merriam_dio_helper.dart';
import 'package:juniorproj/shared/network/remote/youtube_dio_helper.dart';
import 'package:juniorproj/shared/styles/colors.dart';
import 'package:juniorproj/shared/styles/themes.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipedetector_nullsafety/swipedetector_nullsafety.dart';
import 'layout/cubit/states.dart';
import 'layout/home_layout.dart';
import 'models/MainModel/userAchievements_model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Makes sure that all the await and initializer get done before runApp

  Bloc.observer = MyBlocObserver(); //Running Bloc Observer which prints change in states and errors etc...  in console

  MerriamDioHelper.init();  //Initializing  Merriam Dio Helper

  MainDioHelper.init();  //Initializing Main Dio Helper to get user data and app data.

  YoutubeDioHelper.init(); //Initializing Youtube Dio Helper.

  await CacheHelper.init(); //Starting CacheHelper, await for it since there is async,await in .init().

  bool? isDark = CacheHelper.getData(key: 'isDarkTheme'); //Caching the last ThemeMode
  isDark ??= false;

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding'); //To get if OnBoarding screen has been shown before, if true then straight to Login Screen.
  onBoarding ??= false;

  if (CacheHelper.getData(key: 'token') != null) {
    token = CacheHelper.getData(key: 'token'); // Get User Token
  }

  Widget widget; //to figure out which widget to send (login, onBoarding or HomePage) we use a widget and set the value in it depending on the token.

  if (onBoarding == true) //OnBoarding Screen has been shown before
  {
    if (token.isNotEmpty) //Token is there, so Logged in before
    {
      widget = const HomeLayout(); //Straight to Home Page.
    }
    else  //OnBoarding has been shown before but the token is empty => Login is required.
    {
      widget = LoginScreen();
    }
  } else //Not shown onBoarding before, First lunch of app
  {
    widget = const OnBoardingScreen();
  }

  runApp(
      MyApp(isDark: isDark, homeWidget: widget,)
  );
}

class MyApp extends StatefulWidget {
  final bool isDark;        //If the app last theme was dark or light
  final Widget homeWidget;  // Passing the widget to be loaded.

  const MyApp({Key? key, required this.isDark, required this.homeWidget}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Timer? timer;
  UserAchievementsModel? newAchievementsModel;

  @override
  void initState()
  {
    super.initState();
    timer= Timer.periodic(const Duration(minutes: 2), (Timer t) => checkAchievements()); //Set Timer to check for new achievements every 2 Minutes.
  }

  @override
  void dispose()
  {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      //Multi BlocProvider will be initialized in the main, so if there is more than one, all can be started here.
      providers: [

        BlocProvider(create: (BuildContext context) => AppCubit()..changeTheme(themeFromState: widget.isDark)..getLanguages()..getAchievements()..getUserAchievements()..userData()  ),  //Main Cubit for the HomeLayout and most of the Views.

        BlocProvider(create: (BuildContext context) => WordCubit()),  //Getting the definition of words.

        BlocProvider(create: (BuildContext context)=>YoutubeCubit())
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return OverlaySupport(
            child: MaterialApp(
                debugShowCheckedModeBanner: false,  //Won't show a check mode banner
                theme: lightTheme(context),         //Setting the default LightTheme which is implemented in themes.dart
                darkTheme: darkTheme(context),      //Setting the default DarkTheme which is implemented in themes.dart
                themeMode: AppCubit.get(context).isDarkTheme   //If the boolean says last used is dark (from Cache Helper) => Then load dark theme
                    ? ThemeMode.dark
                    : ThemeMode.light,
                home: AnimatedSplashScreen(  //Showing a Splash Screen when loaded
                    duration: 3000,
                    splash: SvgPicture.asset(
                      'assets/images/logo.svg',
                      width: 60,
                      height: 60,
                      color: AppCubit.get(context).isDarkTheme? Colors.deepOrange : Colors.blue,
                      fit: BoxFit.contain,
                      semanticsLabel: 'Logo',
                    ),
                    nextScreen: widget.homeWidget,
                    splashTransition: SplashTransition.fadeTransition,
                    pageTransitionType: PageTransitionType.fade,
                    backgroundColor: AppCubit.get(context).isDarkTheme? defaultHomeDarkColor : defaultHomeColor,

                )),
          );  //homeWidget, //HomeLayout(),
        },
      ),
    );
  }

  void checkAchievements()  //Check if the user achieved something new.
  {
    if(token != '') //The User Signed in
    {
      print('CHECKING FOR NEW ACHIEVEMENTS');
      if(AppCubit.userAchievementsModel !=null)  //The user Achievements are ready
          {
        getLatestAchievements();
        if(newAchievementsModel !=null) //If New values are stored in newAchievementModel
        {
          if(newAchievementsModel!.item.isNotEmpty) //Not Empty, since [] is defined by default
          {
            print('NEW ACHIEVEMENTS ARE UNLOCKED');
            for (var element in newAchievementsModel!.item) //Looping new achievements
            {
              for(var e in AppCubit.achievementsModel!.item)  //Looping all achievements
              {
                if(element.achievementId == e.id)  //Getting the new unlocked achievements name and details from achievementsModel
                {
                  print('Achievement is ${e.name}'); //Printing it's name

                  showOverlayNotification( //Show Notification.
                      (context) => notificationCard(e.name!),
                      duration: const Duration(seconds: 5),
                  );
                }
              }
            }
          }
        }
        else
        {
          print('NO NEW ACHIEVEMENTS');
        }
      }

      else
      {
        print('NO USER ACHIEVEMENTS YET.');
      }
    }
  }

  void getLatestAchievements() // Get latest achievement from server.
  {
    MainDioHelper.getData(
      url: latestAchievements,
      token: token,
    ).then((value)
    {
      newAchievementsModel= UserAchievementsModel.fromJson(value.data);
    }).catchError((error)
    {
      print('ERROR WHILE GETTING USER ACHIEVEMENTS, ${error.toString()}');
    });
  }

  Widget notificationCard(String text)  //The Card that will show
  {
    return Builder(
      builder: (BuildContext myContext)
      {
        AppCubit.get(myContext).getUserAchievements(); //Get the new achievements
        return SafeArea(
          child: SwipeDetector(
            onSwipeUp: ()
            {
              OverlaySupportEntry.of(myContext)!.dismiss(); //Dismiss the Notification
            },

            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              clipBehavior: Clip.antiAliasWithSaveLayer, //Allow Clipping

              shape: RoundedRectangleBorder( //Rounded Shape
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: pistachioColor, width: 1.5)
              ),

              child: ListTile(
                tileColor: AppCubit.get(myContext).isDarkTheme? Colors.black : defaultHomeColor,  //Default Notification Color
                style: ListTileStyle.drawer,
                leading: SizedBox.fromSize(
                    size: const Size(40, 40),
                    child: ClipOval(
                      child: Icon(
                        Icons.insert_emoticon,
                        size: 28,
                        color: AppCubit.get(myContext).isDarkTheme? defaultDarkColor :defaultColor,
                      ),
                    )
                ),

                title: Text(
                  'Achievement Unlocked !',
                  style: TextStyle(
                    color: AppCubit.get(myContext).isDarkTheme? Colors.white :Colors.black,
                    fontSize: 16,
                  ),
                ),

                subtitle: Text(
                    text,
                    style: TextStyle(
                      color: AppCubit.get(myContext).isDarkTheme? Colors.white :Colors.black,
                      fontSize: 14,
                    )
                ),

                trailing: TextButton(
                    onPressed: () {
                      OverlaySupportEntry.of(myContext)!.dismiss();
                    },
                    child: const Text('Dismiss')),

              ),
            ),
          ),
        );
      },
    );
  }

}
