abstract class AppStates{}

class AppInitialState extends AppStates{}

class AppChangeBottomNavBarState extends AppStates{}

class AppChangeActionState extends AppStates{}

class AppChangeThemeModeState extends AppStates{}

class AppQuizChangeisLastState extends AppStates{}   //Change of screen happened in showing questions.

class AppQuizChangeisVisibleState extends AppStates{}   //Change the Correct/False to not shown.

class AppQuizChangeisCorrectState extends AppStates{}   //Change if the state is Correct.

class AppQuizChangeisBoxTappedState extends AppStates{}   //Change if any answers boxes has been tapped.

class AppQuizChangeisAnimationState extends AppStates{}   //Change animation to be true.

