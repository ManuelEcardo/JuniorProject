import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:juniorproj/modules/Login/login_screen.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/network/local/cache_helper.dart';
import 'package:juniorproj/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingModel
{
  final String image;
  final String title;
  final String body;

  OnBoardingModel({required this.image, required this.title, required this.body});
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);


  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {


  bool isLast=false;

  List<OnBoardingModel> list=
  [
    OnBoardingModel(
        image: 'assets/images/on_board_1.jpg',
        title: 'Title 1',
        body: 'body 1'
    ),

    OnBoardingModel(
        image: 'assets/images/on_board_2.png',
        title: 'Title 2',
        body: 'body 2'
    ),

    OnBoardingModel(
        image: 'assets/images/on_board_3.png',
        title: 'Title 3',
        body: 'body 3'
    ),
  ];

  var pageViewController= PageController();

  void submit()
  {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value)  //Caching that we have already viewed the On Boarding
    {
      if(value==true)
        {
          navigateAndFinish(context, LoginScreen());
        }
    }
    );
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        actions:
        [
          TextButton(
            onPressed: () => submit(),
            child: const Text('SKIP'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children:
          [
            Expanded(
                child: PageView.builder(
                  controller: pageViewController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (int index)
                  {
                    if(index==list.length-1)  //if it is the last Screen => set IsLast to true
                      {
                        print('Last');

                        setState(()
                        {
                          isLast=true;
                        }
                        );
                      }
                    else
                      {
                        print('not last');

                        setState(()
                        {
                          isLast=false;
                        }
                        );
                      }
                  },
                  itemBuilder:(context,index) => buildBoardingItem(list[index]),
                  itemCount: 3,
                )
            ),

            const SizedBox(height: 40,),

            Row(
              children:
               [
                SmoothPageIndicator(
                    controller: pageViewController,
                    count: list.length,
                  effect:  ExpandingDotsEffect
                    (
                    dotColor: Colors.grey,
                    activeDotColor: defaultColor,
                    dotHeight: 10,
                    dotWidth: 10,
                    expansionFactor: 3,
                    spacing: 5,
                  ),
                ),

                const Spacer(),

                FloatingActionButton(
                    onPressed: ()
                    {
                      if(isLast)
                        {
                          //navigateAndFinish(context, HomeLayout());
                          submit();
                        }
                      else
                        {
                          pageViewController.nextPage(
                              duration: const Duration(milliseconds: 750),
                              curve: Curves.fastLinearToSlowEaseIn);
                        }
                    },
                  child:  Icon( isLast? Icons.arrow_forward_ios : Icons.arrow_forward_sharp),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget  buildBoardingItem(OnBoardingModel list) =>Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:
     [
      Image(
        image: AssetImage(list.image),
      ),

      const SizedBox(height: 10),

      Text(
        list.title,
        style: const TextStyle(
          fontSize: 24.0,
          fontFamily: 'Jannah',

        ),
      ),

      const SizedBox(height: 10),

      Text(
        list.body,
        style: const TextStyle(
          fontSize: 14.0,
          fontFamily: 'Jannah',

        ),
      ),
    ],
  );
}
