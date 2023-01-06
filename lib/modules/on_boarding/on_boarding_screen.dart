import 'package:cached_network_image/cached_network_image.dart';
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
        image: 'https://drive.google.com/u/4/uc?id=1ISd_GjKE1kdZjPLLsvUfca2IQr6pgYRg&export=download',
        title: 'Feeling Bored with Classic Learning?',
        body: 'Reading grammar books and listening to teachers lecture can be quiet a drag.'
    ),

    OnBoardingModel(
        image: 'https://drive.google.com/u/4/uc?id=1xmFu8NwLmSki0Rck21HqH00vXkwdD8TQ&export=download',
        title: 'Learn with Videos is The New Way of Learning !',
        body: 'Scientific researches has proven that videos contributes to a much more efficient learning than plain text'
    ),

    OnBoardingModel(
        image: 'https://drive.google.com/u/4/uc?id=1TJF6-ZY71Mx5CIN_UaO4rK-VAvBfWF_w&export=download',
        title: 'A Revolution in Language Learning',
        body: 'We offer a variety of video types to learn from, including movie scenes, songs, interviews and much more fun content!'
    ),

    OnBoardingModel(
        image: 'https://drive.google.com/u/4/uc?id=1RnyNbGddeIgbLZdYxHk4GvCLMq-CmIQv&export=download',
        title: 'Are You Ready ?',
        body: ''
    ),
  ];

  var pageViewController= PageController();

  void submit()
  {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value)  //Caching that we have already viewed the On Boarding
    {
      if(value==true)
        {
          navigateAndFinish(context, const LoginScreen());
        }
    }
    );
  }

  @override
  void initState()
  {
    super.initState();
  }

  @override
  void dispose()
  {
    pageViewController.dispose();
    super.dispose();
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
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height /1),
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
                        print('Last on_boarding screen');

                        setState(()
                        {
                          isLast=true;
                        }
                        );
                      }
                    else
                      {
                        print('not last on_boarding screen');

                        setState(()
                        {
                          isLast=false;
                        }
                        );
                      }
                  },

                  itemBuilder:(context,index)
                  {
                    if(index==3)
                      {
                        return buildBoardingItem(list[index],titlePlace: AlignmentDirectional.center, heightFromPicture: 15);
                      }
                    return buildBoardingItem(list[index]);
                  },
                  itemCount: list.length,
                ),
              ),

              // const SizedBox(height: 20,),

              Align(
                alignment: AlignmentDirectional.center,
                child: SmoothPageIndicator(
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
              ),

              const SizedBox(height: 20,),

              SizedBox(
                height: 45,
                child: defaultButton(
                    function: ()
                    {
                      if(isLast)
                      {
                        submit();
                      }
                      else
                      {
                        pageViewController.nextPage(
                            duration: const Duration(milliseconds: 950),
                            curve: Curves.fastOutSlowIn,

                        );

                      }
                    },
                    text: isLast? 'Let\'s Go' : 'Next',
                    width: MediaQuery.of(context).size.width /2.2,
                    shadow: true,
                    radius: 10,
                ),
              ),

              const SizedBox(height: 5,),
            ],
          ),
        ),
      ),
    );
  }

  Widget  buildBoardingItem(OnBoardingModel list,{AlignmentGeometry titlePlace=AlignmentDirectional.topStart, double heightFromPicture=2}) =>
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children:
     [
      CachedNetworkImage(
         imageUrl: list.image,
         width: 500,
         height: 250,
         placeholder: (context,url)=>const Center(child: CircularProgressIndicator()),
         errorWidget: (context,url,error)=> const Center (child: Icon(Icons.error, size: 100,)),
       ),

      SizedBox(height: heightFromPicture),

      Align(
        alignment: titlePlace,
        child: Text(
          list.title,
          style: const TextStyle(
            fontSize: 22.0,
            fontFamily: 'Jannah',
            fontWeight: FontWeight.w600
          ),
        ),
      ),

      const SizedBox(height: 8),

      Expanded(
        child: Text(
          list.body,
          // overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16.0,
            fontFamily: 'Jannah',
          ),
        ),
      ),
    ],
  );
}
