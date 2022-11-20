abstract class WordStates{}


class InitialWordsState extends WordStates{}

class WordsLoadingState extends WordStates{}

class WordsSuccessState extends WordStates{}

class WordsErrorState extends WordStates{
  final String error;

  WordsErrorState(this.error);
}

class WordsIsModelTrue extends WordStates{}

class WordsClearModel extends WordStates{}