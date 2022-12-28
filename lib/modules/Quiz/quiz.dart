import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/models/MainModel/content_model.dart';
import 'package:juniorproj/modules/Quiz/QuizVideoBuilder.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:video_player/video_player.dart';


class QuizPage extends StatefulWidget {

  final List<Questions> model;
  const QuizPage(this.model, {Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin{

  PageController pageController= PageController();

   late AnimationController _animationController; //Animation Controller for FAB button to glow when the question is answered.
   late Animation _animation;

   final AudioPlayer myAudioPlayer=AudioPlayer();  //Audio player for questions that contains audio.
   late Source audioUrl;


  // var correctAnswerId=0;

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
    List<Questions> model= widget.model;

    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state)
      {},

      builder: (context,state)
      {
        cubit.markCalculator(model.length);
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
                          return defaultAlertDialog(
                              context: context,
                              title: 'Quiz Section',
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children:
                                const[
                                  Text('Variety of questions to be answered.',),

                                  Text('-Read the question and choose an answer',),

                                  Text('-Some questions may contain audio or video, listen or watch then answer.',),

                                  Text(
                                    'Notice: You Can\'t change your answer once you\'ve chosen',
                                    style: TextStyle(
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
                          // return AlertDialog(
                          //   title: Text(
                          //     'Quiz Section',
                          //     textAlign: TextAlign.center,
                          //     style: TextStyle(
                          //       color: HexColor('8AA76C'),
                          //       fontWeight: FontWeight.w700,
                          //     ),
                          //   ),
                          //   content:  Column(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     mainAxisSize: MainAxisSize.min,
                          //     children:
                          //     const[
                          //       Text(
                          //         'Variety of questions to be answered.',
                          //         style: TextStyle(
                          //           color: Colors.black,
                          //           fontSize: 18,
                          //         ),
                          //       ),
                          //
                          //       Text(
                          //         '-Read the question and choose an answer',
                          //         style: TextStyle(
                          //           color: Colors.black,
                          //           fontSize: 18,
                          //         ),
                          //       ),
                          //
                          //       Text(
                          //         '-Some questions may contain audio or video, listen or watch then answer.',
                          //         style: TextStyle(
                          //           color: Colors.black,
                          //           fontSize: 18,
                          //         ),
                          //       ),
                          //
                          //       Text(
                          //         'Notice: You Can\'t change your answer once you\'ve chosen',
                          //         style: TextStyle(
                          //           color: Colors.black,
                          //           fontSize: 18,
                          //           fontWeight: FontWeight.w700
                          //         ),
                          //       ),
                          //
                          //       Center(
                          //         child: Text(
                          //           '-Best of Luck',
                          //           style: TextStyle(
                          //             color: Colors.redAccent,
                          //             fontSize: 18,
                          //             fontWeight: FontWeight.w500
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // );
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
                      count: model.length,
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
                      itemBuilder: (context,index) => determineType(cubit,model[index],index),
                      itemCount: model.length,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index)
                      {
                        setState(()
                        {
                          //correctAnswerId=model[index].choices![index].isCorrect.toInt()!;  //Setting the correct answer ID to a variable<<<<<<<< TBD should be moved to cubit.
                        });
                        if(index==model.length)  //if it is the last Question => set IsLast to true
                        {
                          cubit.changeQuizIsLast(index, model.length);

                        }
                        else
                        {
                          cubit.changeQuizIsLast(index, model.length);
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
                            if(cubit.isLastQuiz && pageController.page == model.length -1)   //If the question is the last
                            {
                              //navigateAndFinish(context, HomeLayout());
                              cubit.changeIsBoxTappedQuiz(false);
                              cubit.changeIsAnimation(false);
                              print('LAST');
                              //markDialog(context, cubit);
                              popupDialog(context,cubit);
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


  Widget determineType(AppCubit cubit, Questions questionModel, int answerId) //Will Check for the type if video, audio, photo or normal question.
  {
    if(questionModel.type =='t')        //type is Text, example: What is the color of the sun?  yellow,green,blue
      {
        return completeTheSentenceItemBuilder(cubit, questionModel, answerId);
      }

    else if (questionModel.type =='v')  //Type is video.
      {
        return videoItemBuilder(cubit, questionModel, answerId);
      }

    else if (questionModel.type =='a')  //Type is audio
      {
        return audioItemBuilder(cubit, questionModel, answerId);
      }

    else if (questionModel.type =='p')  //Type is picture.
      {
        return imageItemBuilder(cubit, questionModel, answerId);
      }

    else
      {
        return completeTheSentenceItemBuilder(cubit, questionModel, answerId);
      }
  }

  Widget completeTheSentenceItemBuilder(AppCubit cubit, Questions questionModel, int index)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
      [
        const Text(
          'Complete the following: ',
          style: TextStyle(
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
          questionModel.question!,
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
              answerBuilder(cubit, questionModel.choices![0].choice!, questionModel.choices![0].isCorrect!.toInt()!),

              const SizedBox(width: 10,),

              answerBuilder(cubit,questionModel.choices![1].choice!, questionModel.choices![1].isCorrect!.toInt()!),

              const SizedBox(width: 10,),

              answerBuilder(cubit,questionModel.choices![2].choice!, questionModel.choices![2].isCorrect!.toInt()!),
            ],
          ),
        ),
      ],

    );
  }

  Widget videoItemBuilder(AppCubit cubit, Questions questionModel, int index)
  {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            const Text(
              'Complete after watching the video:',
              style:TextStyle(
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
                videoPlayerController: VideoPlayerController.network(questionModel.link !=null ? questionModel.link! : ''),
                looping: false,
              ),
            ),

            const SizedBox(height: 30,),

            Text(
              questionModel.question!,
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
                  answerBuilder(cubit, questionModel.choices![0].choice!, questionModel.choices![0].isCorrect!.toInt()!),

                  const SizedBox(width: 10,),

                  answerBuilder(cubit, questionModel.choices![1].choice!, questionModel.choices![1].isCorrect!.toInt()!),

                  const SizedBox(width: 10,),

                  answerBuilder(cubit, questionModel.choices![2].choice!, questionModel.choices![2].isCorrect!.toInt()!),
                ],
              ),
            ),
          ],

        ),
      ),
    );
  }

  Widget audioItemBuilder(AppCubit cubit, Questions questionModel, int index)
  {

    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            const Text(
              'Complete after listening: ',
              style:TextStyle(
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
                children:const
               [
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
              questionModel.question!,
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
                  answerBuilder(cubit, questionModel.choices![0].choice!, questionModel.choices![0].isCorrect!.toInt()!),

                  const SizedBox(width: 10,),

                  answerBuilder(cubit, questionModel.choices![1].choice!, questionModel.choices![1].isCorrect!.toInt()!),

                  const SizedBox(width: 10,),

                  answerBuilder(cubit, questionModel.choices![2].choice!, questionModel.choices![2].isCorrect!.toInt()!),
                ],
              ),
            ),
          ],

        ),
      ),
    );
  }

  Widget imageItemBuilder(AppCubit cubit, Questions questionModel, int index)
  {

    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            const Text(
              'Choose the right answer: ',
              style: TextStyle(
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
                image: NetworkImage(questionModel.link!=null ? questionModel.link! : ''),
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 30,),

            Text(
              questionModel.question!,
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
                  answerBuilder(cubit, questionModel.choices![0].choice!, questionModel.choices![0].isCorrect!.toInt()!),

                  const SizedBox(width: 10,),

                  answerBuilder(cubit, questionModel.choices![1].choice!, questionModel.choices![1].isCorrect!.toInt()!),

                  const SizedBox(width: 10,),

                  answerBuilder(cubit, questionModel.choices![2].choice!, questionModel.choices![2].isCorrect!.toInt()!),
                ],
              ),
            ),
          ],

        ),
      ),
    );
  }

  Widget answerBuilder(AppCubit cubit,String text, int answerId)   //Builds blocks that contains choices.
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
              if(answerId == 1)
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

  Widget correctFalseBuilder(AppCubit cubit)  //Tells if an answer is correct or not
  {
    if(cubit.isCorrectQuiz ==true)
      {
        cubit.changeQuizIsVisible(true);
        cubit.markAdder(true);
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



  // Future<void> markDialog(BuildContext context, AppCubit cubit)  //shows dialog contains the final mark for this student.
  //  async {
  //   await Dialogs.materialDialog(
  //     context: context,
  //     title:'Your Result: ',
  //     msg:'${messageBuilder(cubit.finalMark)}, You\'ve scored: ${cubit.finalMark}',
  //     actions:
  //     [
  //       TextButton(
  //         child:const Text(
  //           'NEXT',
  //           style: TextStyle(
  //             fontSize: 20,
  //           ),
  //         ),
  //
  //         onPressed: ()
  //         {
  //           cubit.setFinalMark();
  //           cubit.changeIsBoxTappedQuiz(false);
  //           cubit.changeQuizIsVisible(false);
  //           Navigator.of(context).popUntil((route){
  //             return route.settings.name == 'unit';
  //           });  //Go Back to the previous screen.
  //         },
  //
  //       ),
  //     ],
  //
  //     titleAlign: TextAlign.center,
  //     titleStyle:const TextStyle(
  //       fontSize: 24,
  //       color: Colors.black,
  //     ),
  //
  //     msgStyle: const TextStyle(
  //       fontSize: 18,
  //       color: Colors.black,
  //     ),
  //   );
  // }


  Future<void> popupDialog(BuildContext context, AppCubit cubit) //shows dialog contains the final mark for this student.
  async {

    // myAudioPlayer.stop(); //if audio is being played, then stop
    await showDialog(
        context: context,
        builder: (context)
        {
          return WillPopScope(
            child: AlertDialog(
              title: const Text(
                'Your Result:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              content:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children:
                [
                  Text(
                    '${messageBuilder(cubit.finalMark)}, You\'ve scored: ${cubit.finalMark}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ) ,
                  ),

                  Center(
                    child: TextButton(
                      child:const Text(
                        'NEXT',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),

                      onPressed: ()
                      {
                        cubit.setFinalMark();
                        cubit.changeIsBoxTappedQuiz(false);
                        cubit.changeQuizIsVisible(false);
                        Navigator.of(context).popUntil((route){
                          return route.settings.name == 'unit';
                        });  //Go Back to the previous screen.
                      },

                    ),
                  ),
                ]
              ),
            ),

            onWillPop: () async
            {
              cubit.setFinalMark();
              cubit.changeIsBoxTappedQuiz(false);
              cubit.changeQuizIsVisible(false);
              Navigator.of(context).popUntil((route){
                return route.settings.name == 'unit';
              });
              return true;
            },
          );
        }
    );
  }

  String messageBuilder(double mark) //Will return a message depending on the student mark.
  {
    if(mark==10)
      {
        return 'Amazing!';
      }
    else if (mark<10 && mark>=6)
      {
        return 'Good Job!';
      }
    else if (mark<6 && mark>3)
      {
        return 'Try better';
      }
    else
      {
        return 'Oops, we think you should repeat the unit';
      }
  }

}
