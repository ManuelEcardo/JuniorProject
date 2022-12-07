import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/modules/Quiz/QuizVideoBuilder.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:video_player/video_player.dart';


class QuestionModel
{
  String question;
  String questionTitle;
  String? link;
  List<String> answers;
  int correctAnswerId;
  String type;

  QuestionModel({required this.question, required this.questionTitle,required this.answers,required this.correctAnswerId, required this.type , this.link});
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin{

  PageController pageController= PageController();
  List<QuestionModel> questionModel=
  [
    QuestionModel(question: 'What instrument is this?', questionTitle: 'Choose the right answer', answers: ['Guitar','Bass','Ukulele'], correctAnswerId: 0,type: 'image', link: 'assets/quizPhotos/guitar.jpg'),

    QuestionModel(question: "I've seen you before!\nYou are -------- ", questionTitle: 'Complete The Following',answers: ['Recognisable','friend','good'], correctAnswerId: 0 ,type: 'com'),

    QuestionModel(question: 'animals are dying from just ---- plastic ', questionTitle: 'Complete after watching the video', answers: ['encountering','countering','encounter'], correctAnswerId: 0,type: 'video', link: 'assets/quizVideos/videoQuiz1.mp4'),

    QuestionModel(question: 'Let me introduce you to my --------', questionTitle: 'Complete The Following', answers: ['couch','friend','dog'], correctAnswerId: 1,type: 'com'),

    QuestionModel(question: 'What was John talking about?', questionTitle: 'Complete after Listening', answers: ['Houses','Nature','Gaming'], correctAnswerId: 1,type: 'audio', link: 'https://www.kozco.com/tech/piano2-CoolEdit.mp3'),

    QuestionModel(question:"Don't use my computer without my --------", questionTitle: 'Complete The Following',answers:['pen','accept','permission'], correctAnswerId:2,type: 'com'),

    QuestionModel(question:'Have you -------- my glasses?\nI can\'t find them anywhere!', questionTitle: 'Complete The Following',answers:['see','seen','watched'], correctAnswerId:1,type: 'com'),

  ];

   late AnimationController _animationController; //Animation Controller for FAB button to glow when the question is answered.
   late Animation _animation;

   final AudioPlayer myAudioPlayer=AudioPlayer();
   late Source audioUrl;


  var correctAnswerId=0;

  @override
  void initState()
  {
    super.initState();

    _animationController= AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation= Tween(begin: 2.0, end: 10.0).animate(_animationController)..addListener(()
    {
      setState(()
      {

      });
    });
  }

  @override
  void dispose()
  {
    pageController.dispose();
    _animationController.dispose();
    myAudioPlayer.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    var cubit= AppCubit.get(context);
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state)
      {},

      builder: (context,state)
      {

        return WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: ()
                {
                  cubit.changeIsBoxTappedQuiz(false);
                  cubit.changeQuizIsVisible(false);
                  Navigator.pop(context);
                },),
              actions:
              [
                IconButton(
                  icon:const Icon(Icons.question_mark_rounded),
                  onPressed: ()
                  async {
                    await showDialog(
                        context: context,
                        builder: (context)
                        {
                          return AlertDialog(
                            title: Text(
                              'Quiz Section',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: HexColor('8AA76C'),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            content:  Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children:
                              const[
                                Text(
                                  'Variety of questions to be answered.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),

                                Text(
                                  '-Read the question and choose an answer',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),

                                Text(
                                  '-Some questions may contain audio or video, listen or watch then answer.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),

                                Text(
                                  'Notice: You Can\'t change your answer once you\'ve chosen',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700
                                  ),
                                ),

                                Center(
                                  child: Text(
                                    '-Best of Luck',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                    );
                  },
                ),

                IconButton(onPressed: (){AppCubit.get(context).changeTheme();}, icon: const Icon(Icons.sunny)),
              ],
            ),

            body: Padding(
              padding: const EdgeInsetsDirectional.all(24),
              child: Column(
                children:
                [
                  SmoothPageIndicator(
                      controller: pageController,
                      count: questionModel.length,
                      effect:  ExpandingDotsEffect
                      (
                      dotColor: Colors.grey,
                      activeDotColor: AppCubit.get(context).isDarkTheme ? defaultDarkColor : defaultColor,
                      dotHeight: 10,
                      dotWidth: 10,
                      expansionFactor: 3,
                      spacing: 5,
                    ),
                  ),

                  const SizedBox(height: 40,),

                  Expanded(
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: pageController,
                      itemBuilder: (context,index) => determineType(cubit,questionModel[index],index),
                      itemCount: questionModel.length,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index)
                      {
                        setState(()
                        {
                          correctAnswerId=questionModel[index].correctAnswerId;  //Setting the correct answer ID to a variable<<<<<<<< TBD should be moved to cubit.
                        });
                        if(index==questionModel.length)  //if it is the last Question => set IsLast to true
                        {
                          cubit.changeQuizIsLast(index, questionModel.length);
                        }
                        else
                        {
                          cubit.changeQuizIsLast(index, questionModel.length);
                        }
                      },
                    ),
                  ),

                  Row(
                    children:
                    [
                      const Spacer(),
                      Container(
                        decoration:BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: cubit.isDarkTheme ? Colors.grey.shade700 : Colors.grey,
                              blurRadius: cubit.isAnimationQuiz ? _animation.value : 0,
                              spreadRadius:cubit.isAnimationQuiz ? _animation.value : 0,
                            ),
                          ],
                        ),
                        child: FloatingActionButton(
                          onPressed: ()
                          {
                            if(cubit.isLastQuiz && pageController.page == questionModel.length -1)   //If the question is the last
                            {
                              //navigateAndFinish(context, HomeLayout());
                              cubit.changeIsBoxTappedQuiz(false);
                              cubit.changeIsAnimation(false);


                              print('LAST');
                            }
                            else
                            {
                              if(cubit.isBoxTappedQuiz==true)
                                {
                                  cubit.changeQuizIsVisible(false);   //Hide the Correct/False statement and move to the next page.
                                  cubit.changeIsBoxTappedQuiz(false); // So Boxes can be tapped again.
                                  cubit.changeIsAnimation(false);
                                  pageController.nextPage(
                                      duration: const Duration(milliseconds: 750),
                                      curve: Curves.fastLinearToSlowEaseIn);
                                }
                              else
                                {
                                  defaultToast(msg: 'Choose an Answer');
                                }
                            }
                          },
                          child:  Icon( cubit.isLastQuiz? Icons.arrow_forward_ios : Icons.arrow_forward_sharp),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          onWillPop: ()async   //When The user presses back, Correct/False will be invisible.
          {
            cubit.changeIsBoxTappedQuiz(false);
            cubit.changeQuizIsVisible(false);
            return true;
          },
        );
      },
    );
  }


  Widget determineType(AppCubit cubit, QuestionModel questionModel, int answerId) //Will Check for the type.
  {
    if(questionModel.type =='com')
      {
        return completeTheSentenceItemBuilder(cubit, questionModel, answerId);
      }
    else if (questionModel.type =='video')
      {
        return videoItemBuilder(cubit, questionModel, answerId);
      }
    else if (questionModel.type =='audio')
      {
        return audioItemBuilder(cubit, questionModel, answerId);
      }

    else if (questionModel.type =='image')
      {
        return imageItemBuilder(cubit, questionModel, answerId);
      }
    else
      {
        return completeTheSentenceItemBuilder(cubit, questionModel, answerId);
      }
  }

  Widget completeTheSentenceItemBuilder(AppCubit cubit, QuestionModel questionModel, int index)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
      [
         Text(
          'Question ${index+1}: ${questionModel.questionTitle}',
          style: const TextStyle(
            fontSize: 30,
          ),
        ),

        const SizedBox(height: 15,),

        Padding(
          padding: const EdgeInsetsDirectional.only(start: 8.0, end:  8.0),
          child: myDivider(),
        ),

        const SizedBox(height: 30,),

         Text(
          questionModel.question,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),

        const SizedBox(height: 40,),

          Center(
          child:  Visibility(
              visible: cubit.isVisibleQuiz,
              child: cubit.isCorrectQuiz ? const Text(
                'Correct !',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.green,
                ),
              ): const Text(
                'False !',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.red,
                ),
              ),
          ),
        ),

        const Spacer(),

        Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 20.0, end: 5),
          child: Row(
            children:
            [
              answerBuilder(cubit,questionModel.answers[0], 0),

              const SizedBox(width: 10,),

              answerBuilder(cubit,questionModel.answers[1],1),

              const SizedBox(width: 10,),

              answerBuilder(cubit,questionModel.answers[2],2),
            ],
          ),
        ),
      ],

    );
  }

  Widget videoItemBuilder(AppCubit cubit, QuestionModel questionModel, int index)
  {

    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Text(
              'Question ${index+1}: ${questionModel.questionTitle}',
              style: const TextStyle(
                fontSize: 30,
              ),
            ),

            const SizedBox(height: 15,),

            Padding(
              padding: const EdgeInsetsDirectional.only(start: 8.0, end:  8.0),
              child: myDivider(),
            ),

            const SizedBox(height: 30,),

            AspectRatio(
              aspectRatio: 16/9,
              child: ChewieListItem(
                videoPlayerController: VideoPlayerController.asset(questionModel.link!),
                looping: false,
              ),
            ),

            const SizedBox(height: 30,),

            Text(
              questionModel.question,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),

            const SizedBox(height: 40,),

            Center(
              child:  Visibility(
                visible: cubit.isVisibleQuiz,
                child: cubit.isCorrectQuiz ? const Text(
                  'Correct !',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.green,
                  ),
                ): const Text(
                  'False !',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.red,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40,),

            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 20.0, end: 5),
              child: Row(
                children:
                [
                  answerBuilder(cubit,questionModel.answers[0], 0),

                  const SizedBox(width: 10,),

                  answerBuilder(cubit,questionModel.answers[1],1),

                  const SizedBox(width: 10,),

                  answerBuilder(cubit,questionModel.answers[2],2),
                ],
              ),
            ),
          ],

        ),
      ),
    );
  }


  Widget audioItemBuilder(AppCubit cubit, QuestionModel questionModel, int index)
  {

    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Text(
              'Question ${index+1}: ${questionModel.questionTitle}',
              style: const TextStyle(
                fontSize: 30,
              ),
            ),

            const SizedBox(height: 15,),

            Padding(
              padding: const EdgeInsetsDirectional.only(start: 8.0, end:  8.0),
              child: myDivider(),
            ),

            const SizedBox(height: 30,),

            TextButton(
              child: Row(
                children:
          const [
                   Text(
                   'Play Audio',
                   style: TextStyle(
                     fontSize: 25,
                     color: Colors.blue,
                   ),
                   ),

                   Spacer(),

                   Icon(
                     Icons.volume_up,
                     size: 45 ,
                     color: Colors.blue,
                   ),
                ],
              ),

              onPressed: ()
              async {
                audioUrl=UrlSource(questionModel.link!);
                await myAudioPlayer.play(audioUrl);
              },

            ),

            const SizedBox(height: 30,),

            Text(
              questionModel.question,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),

            const SizedBox(height: 40,),

            Center(
              child:  Visibility(
                visible: cubit.isVisibleQuiz,
                child: cubit.isCorrectQuiz ? const Text(
                  'Correct !',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.green,
                  ),
                ): const Text(
                  'False !',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.red,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40,),

            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 20.0, end: 5),
              child: Row(
                children:
                [
                  answerBuilder(cubit,questionModel.answers[0], 0),

                  const SizedBox(width: 10,),

                  answerBuilder(cubit,questionModel.answers[1],1),

                  const SizedBox(width: 10,),

                  answerBuilder(cubit,questionModel.answers[2],2),
                ],
              ),
            ),
          ],

        ),
      ),
    );
  }

  Widget imageItemBuilder(AppCubit cubit, QuestionModel questionModel, int index)
  {

    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Text(
              'Question ${index+1}: ${questionModel.questionTitle}',
              style: const TextStyle(
                fontSize: 30,
              ),
            ),

            const SizedBox(height: 15,),

            Padding(
              padding: const EdgeInsetsDirectional.only(start: 8.0, end:  8.0),
              child: myDivider(),
            ),

            const SizedBox(height: 30,),

            Center(
              child: Image(
                image: AssetImage(questionModel.link!),
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 30,),

            Text(
              questionModel.question,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),

            const SizedBox(height: 40,),

            Center(
              child:  Visibility(
                visible: cubit.isVisibleQuiz,
                child: cubit.isCorrectQuiz ? const Text(
                  'Correct !',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.green,
                  ),
                ): const Text(
                  'False !',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.red,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40,),

            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 20.0, end: 5),
              child: Row(
                children:
                [
                  answerBuilder(cubit,questionModel.answers[0], 0),

                  const SizedBox(width: 10,),

                  answerBuilder(cubit,questionModel.answers[1],1),

                  const SizedBox(width: 10,),

                  answerBuilder(cubit,questionModel.answers[2],2),
                ],
              ),
            ),
          ],

        ),
      ),
    );
  }

  Widget answerBuilder(AppCubit cubit,String text, int answerId)
  {
    return Expanded(
      child: GestureDetector(

        onTap: ()
        {
          if(cubit.isBoxTappedQuiz==false)
            {
              print('Box Tapped');
              cubit.changeIsBoxTappedQuiz(true);  //Set that the box has been tapped so the user won't be able to change his answer.
              cubit.changeIsAnimation(true);
              if(answerId == correctAnswerId)
              {
                cubit.changeIsCorrectQuiz(true);
                correctFalseBuilder(cubit);
              }
              else
              {
                cubit.changeIsCorrectQuiz(false);
                correctFalseBuilder(cubit);
              }
            }
          else
            {
              defaultToast(msg: 'You\'ve already chosen an answer');
            }
        },
        onLongPress: ()
        {
          defaultToast(msg: 'Just Press it :)');
        },

        child: Stack(
          alignment: Alignment.center,
          children:
          [
            Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: HexColor('8AA76C'),
            ),
            width: 120,
            height: 75,
          ),

            Text(
              text.capitalize!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget correctFalseBuilder(AppCubit cubit)
  {
    if(cubit.isCorrectQuiz ==true)
      {
        cubit.changeQuizIsVisible(true);
        return const Text(
          'Correct !',
          style: TextStyle(
            fontSize: 30,
            color: Colors.green,
          ),
        );
      }
    else
      {
        cubit.changeQuizIsVisible(true);
        return const Text(
          'False !',
          style: TextStyle(
            fontSize: 30,
            color: Colors.red,
          ),
        );
      }
  }


}
