import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

//Button Like LOGIN
Widget defaultButton({
  double width = double.infinity,
  Color background =  Colors.blue,
  bool isUpper = true,
  double radius = 5.0,  //was 10
  double height = 45.0, // was 40
  required void Function()? function,
  required String text,
}) =>
    Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      width: width,
      height: height,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpper ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );


//---------------------------------------------------------------------------------------------------\\

Widget defaultTextButton({required void Function()? onPressed, required String text, TextStyle? style})
=>TextButton(
    onPressed: onPressed,
    child: Text(
        text.toUpperCase(),
      style: style,
    )
);



//--------------------------------------------------------------------------------------------------\\

//Default Unit Button
Widget defaultUnitButton({
  Color background =  Colors.grey,
  bool isUpper = true,
  double radius = 10.0,  //was 10
  double width = 150.0,
  double height = 150.0, // was 40
  required void Function()? function,
  required String text,
}) =>
    Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.8),
        borderRadius: BorderRadius.circular(radius),
      ),
      width: width,
      height: height,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpper ? text.toUpperCase() : text,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );


//---------------------------------------------------------------------------------------------------\\
//TextFormField like password..
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType keyboard,
  required String label,
  required IconData prefix,
  required String? Function(String?)? validate,
  IconData? suffix,
  bool isObscure = false,
  bool isClickable = true,
  void Function(String)? onSubmit,
  void Function()? onPressedSuffixIcon,
  void Function()? onTap,
  void Function(String)? onChanged,
  void Function(String?)? onSaved,
  InputBorder? focusedBorderStyle,
  InputBorder? borderStyle,
  TextStyle? labelStyle,
  Color? prefixIconColor,
  TextInputAction? inputAction,
}) =>
    TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboard,
      onFieldSubmitted: onSubmit,
      textInputAction: inputAction,
      validator: validate,
      enabled: isClickable,
      onTap: onTap,
      onSaved: onSaved,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        focusedBorder: focusedBorderStyle,
        enabledBorder: borderStyle,
        labelStyle: labelStyle,
        labelText: label,
        prefixIcon: Icon(prefix, color: prefixIconColor,),
        suffixIcon: IconButton(
          onPressed: onPressedSuffixIcon,
          icon: Icon(suffix),
        ),
      ),
    );


//--------------------------------------------------------------------------------------------------\\


//DefaultToast message
Future<bool?> defaultToast({
  required String msg,
  ToastStates state=ToastStates.defaultType,
  ToastGravity position = ToastGravity.BOTTOM,
  Color color = Colors.grey,
  Color textColor= Colors.white,
  Toast length = Toast.LENGTH_SHORT,
  int time = 1,
}) =>
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: time,
      toastLength: length,
      backgroundColor: chooseToastColor(state),
      textColor: textColor,
    );

enum ToastStates{success,error,warning, defaultType}

Color chooseToastColor(ToastStates state) {
  switch (state)
  {
    case ToastStates.success:
      return Colors.green;
      // break;

    case ToastStates.error:
      return Colors.red;
      // break;

    case ToastStates.defaultType:
      return Colors.grey;

    case ToastStates.warning:
      return Colors.amber;
      // break;


  }
}
//--------------------------------------------------------------------------------------------------\\

//Default URL Launcher, it takes the link to be opened.
Future<void> defaultLaunchUrl(String ur) async
{
  final Uri url = Uri.parse(ur);
  if (!await launchUrl(url))
  {
    throw 'Could not launch $url';
  }
}

//--------------------------------------------------------------------------------------------------\\


//--------------------------------------------------------------------------------------------------\\


// Navigate to a screen, it takes context and a widget to go to.

void navigateTo( BuildContext context, Widget widget) =>Navigator.push(
    context,
    MaterialPageRoute(builder: (context)=>widget)
);

//--------------------------------------------------------------------------------------------------\\

// Navigate to a screen and destroy the ability to go back
void navigateAndFinish(context,Widget widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context)=>widget),
    (route) => false,  // The Route that you came from, false will destroy the path back..
);


//--------------------------------------------------------------------------------------------------\\


//--------------------------------------------------------------------------------------------------\\

//A slider that takes a list of items to slide them and bunch of options.
Widget defaultCarouselSlider(
    {
      required List<Widget>? items,
      double height=250,
      int firstPage=0,  //Which page to start from.
      double viewportFraction=1, //1 will make the image take the whole place, 0.9 will show some of the other pictures from left and right.
      bool infiniteScroll=true, //Will scroll back to the beginning when ended.
      bool isReverse=false,
      bool autoplay=true, //Will slide by it self.
      Duration autoPlayInterval= const Duration(seconds: 5),
      Duration autoPlayAnimationDuration= const Duration(seconds: 3),
      Curve autoPlayCurve= Curves.fastOutSlowIn,
      Axis scrollDirection=Axis.horizontal,
    }
    )
{
  return CarouselSlider(
      items: items,
      options: CarouselOptions(
        height: height,
        initialPage: firstPage,
        viewportFraction: viewportFraction,
        enableInfiniteScroll: infiniteScroll,
        reverse: isReverse,
        autoPlay: autoplay,
        autoPlayInterval: autoPlayInterval,
        autoPlayAnimationDuration:autoPlayAnimationDuration,
        autoPlayCurve:autoPlayCurve,
        scrollDirection: scrollDirection,

      ),
  );
}

//--------------------------------------------------------------------------------------------------\\

//Default Divider for ListViews ...
Widget myDivider({Color? c=Colors.grey}) => Container(height: 1, width: double.infinity , color:c,);