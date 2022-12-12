abstract class YoutubeStates{}

class YoutubeInitialState extends YoutubeStates{}

class YoutubeGetVideosLoadingState extends YoutubeStates{}

class YoutubeGetVideosSuccessState extends YoutubeStates{}

class YoutubeGetVideosErrorState extends YoutubeStates{}



//SEARCH

class YoutubeSearchLoadingState extends YoutubeStates{}

class YoutubeSearchSuccessState extends YoutubeStates{}

class YoutubeSearchErrorState extends YoutubeStates{}