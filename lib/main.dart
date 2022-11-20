import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/modules/Login/login_screen.dart';
import 'package:juniorproj/modules/VideoPlayer/cubit/cubit.dart';
import 'package:juniorproj/modules/on_boarding/on_boarding_screen.dart';
import 'package:juniorproj/shared/bloc_observer.dart';
import 'package:juniorproj/shared/components/constants.dart';
import 'package:juniorproj/shared/network/local/cache_helper.dart';
import 'package:juniorproj/shared/network/remote/merriam_dio_helper.dart';
import 'package:juniorproj/shared/styles/colors.dart';
import 'package:juniorproj/shared/styles/themes.dart';
import 'package:page_transition/page_transition.dart';
import 'layout/cubit/states.dart';
import 'layout/home_layout.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Makes sure that all the await and initializer get done before runApp

  Bloc.observer = MyBlocObserver(); //Running Bloc Observer which prints change in states and errors etc...  in console

  MerriamDioHelper.init();  //Initializing  Merriam Dio Helper

  await CacheHelper.init(); //Starting CacheHelper, await for it since there is async,await in .init().

  bool? isDark = CacheHelper.getData(key: 'isDarkTheme'); //Caching the last ThemeMode
  isDark ??= false;

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding'); //To get if OnBoarding screen has been shown before, if true then straight to Login Screen.
  onBoarding ??= false;

  if (CacheHelper.getData(key: 'token') != null) {
    token = CacheHelper.getData(key: 'token'); // Get User Token
  }

  Widget widget;

  if (onBoarding == true) //OnBoarding Screen has been shown before
  {
    if (token.isNotEmpty) //Token is there, so Logged in before
    {
      widget = HomeLayout(); //Straight to Home Page.
    }
    else
    {
      widget = LoginScreen();
    }
  } else //Not shown onBoarding before
  {
    widget = onBoardingScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    homeWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget homeWidget;

  MyApp({required this.isDark, required this.homeWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      //Multi BlocProvider will be initialized in the main, so if there is more than one, all can be started here.
      providers: [
        BlocProvider(create: (BuildContext context) => AppCubit()..ChangeTheme(ThemeFromState: isDark)),  //Main Cubit for the HomeLayout

        BlocProvider(create: (BuildContext context) => WordCubit()),  //Getting the definition of words.


      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme(context),
              darkTheme: darkTheme(context),
              themeMode: AppCubit.get(context).isDarkTheme
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: AnimatedSplashScreen(
                  duration: 3000,
                  splash: SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: 60,
                    height: 60,
                    color: AppCubit.get(context).isDarkTheme? Colors.deepOrange : Colors.blue,
                    fit: BoxFit.contain,
                    semanticsLabel: 'Logo',
                  ),
                  nextScreen: homeWidget,
                  splashTransition: SplashTransition.fadeTransition,
                  pageTransitionType: PageTransitionType.fade,
                  backgroundColor: AppCubit.get(context).isDarkTheme? Colors.black38 : defaultHomeColor,

              ));  //homeWidget, //HomeLayout(),

        },
      ),
    );
  }
}
