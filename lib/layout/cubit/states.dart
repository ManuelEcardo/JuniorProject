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


//-------------------------------------------------------\\

// API METHODS STATES.


// GET USER DATA:

class AppGetUserDataLoadingState extends AppStates{}

class AppGetUserDataSuccessState extends AppStates{}

class AppGetUserDataErrorState extends AppStates{}

//--------------


//GET ALL UNITS:

class AppGetAllUnitsLoadingState extends AppStates{}

class AppGetAllUnitsSuccessState extends AppStates{}

class AppGetAllUnitsErrorState extends AppStates{}

//-----------------------


//GET LANGUAGES:

class AppGetLanguagesLoadingState extends AppStates{}

class AppGetLanguagesSuccessState extends AppStates{}

class AppGetLanguagesErrorState extends AppStates{}


//-----------------------


//GET UNIT CONTENTS:

class AppGetUnitContentLoadingState extends AppStates{}

class AppGetUnitContentSuccessState extends AppStates{}

class AppGetUnitContentErrorState extends AppStates{}

//-----------------------


//GET LESSONS:

class AppGetLessonsLoadingState extends AppStates{}

class AppGetLessonsSuccessState extends AppStates{}

class AppGetLessonsErrorState extends AppStates{}


//-----------------------


//GET QUESTIONS:

class AppGetQuestionsLoadingState extends AppStates{}

class AppGetQuestionsSuccessState extends AppStates{}

class AppGetQuestionsErrorState extends AppStates{}

//-----------------------


//PUT USER INFO:

class AppPutUserInfoLoadingState extends AppStates{}

class AppPutUserInfoSuccessState extends AppStates{}

class AppPutUserInfoErrorState extends AppStates{}