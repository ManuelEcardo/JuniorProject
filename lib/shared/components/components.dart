import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/shared/styles/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_caption_scraper/youtube_caption_scraper.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart';

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
  bool isIcon =false,
  IconData? icon,
  Color? iconColor,
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
        child:isIconDefaultUnitButton(text,isUpper,icon,isIcon,iconColor),
      ),
    );


Widget isIconDefaultUnitButton(String text, bool isUpper, IconData? icon, bool isIcon, Color? iconColor )
{
  if(isIcon==true && icon !=null)
    {
      return Icon(
        icon,
        color: iconColor,
      );
    }
  else
    {
      return Text(
          isUpper? text.toUpperCase() :text,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
      );
    }
}


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
  Color? suffixIconColor,
  TextInputAction? inputAction,
  double borderRadius=0,
  bool readOnly=false,
}) =>
    TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboard,
      onFieldSubmitted: onSubmit,
      textInputAction: inputAction,
      validator: validate,
      enabled: isClickable,
      readOnly: readOnly,
      onTap: onTap,
      onSaved: onSaved,
      onChanged: onChanged,
      decoration: InputDecoration(
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedBorder: focusedBorderStyle,
        enabledBorder: borderStyle,
        labelStyle: labelStyle,
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        prefixIcon: Icon(prefix, color: prefixIconColor,),
        suffixIcon: IconButton(
          onPressed: onPressedSuffixIcon,
          icon: Icon(
            suffix,
            color: suffixIconColor,
          ),
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




// Navigate to a screen, it takes context and a widget to go to.

void navigateTo( BuildContext context, Widget widget) =>Navigator.push(
    context,
    MaterialPageRoute(builder: (context)=>widget),

);


// Navigate to a screen and save the route name

void navigateAndSaveRouteSettings( BuildContext context, Widget widget, String routeName) =>Navigator.push(
  context,
  MaterialPageRoute(
      builder: (context)=>widget,
      settings: RouteSettings(name: routeName,),
  ),

);

//--------------------------------------------------------------------------------------------------\\

// Navigate to a screen and destroy the ability to go back
void navigateAndFinish(context,Widget widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context)=>widget),
    (route) => false,  // The Route that you came from, false will destroy the path back..
);


//--------------------------------------------------------------------------------------------------\\

//Default Divider for ListViews ...
Widget myDivider({Color? c=Colors.grey, double padding=0}) => Container(height: 1, width: double.infinity , color:c, padding: EdgeInsets.symmetric(horizontal: padding),);

//-----------------------------------------


Widget defaultAlertDialog(
{
  required BuildContext context,
  required String title,
  required Widget content,
})
{
  return AlertDialog(
    title: Text(
      title,
      textAlign: TextAlign.center,),

    content: content,

    contentTextStyle: TextStyle(
      fontSize: 18,
      color:  AppCubit.get(context).isDarkTheme? Colors.white: Colors.black,
      fontFamily: 'Jannah',
    ),

    titleTextStyle: TextStyle(
      fontSize: 20,
      color: HexColor('8AA76C'),
      fontWeight: FontWeight.w700,
      fontFamily: 'Jannah',
    ),

    backgroundColor: AppCubit.get(context).isDarkTheme? defaultHomeDarkColor : defaultHomeColor,

  );
}


//-------------------------------------------


//FOR YOUTUBE

Future<String> videoStreamGetter(String videoId, YoutubeExplode yt ) //Get Stream from link
async {

  try
    {
      StreamManifest manifest = await yt.videos.streamsClient.getManifest(videoId); //Get Manifest of this video
      var streamInfo = StreamManifest(manifest.streams).muxed.withHighestBitrate(); //Video and Audio

      return streamInfo.url.toString();
    }

    catch(error)
    {
      print('Couldn\'t Get Stream, ${error.toString()}');
      return 'no stream';
    }
}



Future<Object> captionsGetter(String videoId, YouTubeCaptionScraper captionScraper )  //Get Captions from link
async {

  final Directory directory = await getApplicationDocumentsDirectory();
  print('THE DIRECTORY PATH IS: ${directory.path}');
  final File file = File('${directory.path}/my_file.txt');

  try
  {
    final captionTracks = await captionScraper.getCaptionTracks('https://www.youtube.com/watch?v=$videoId');
    String sub='';  //Initial Subtitle string
    int i=1;  //put a number for each line
    for (var element in captionTracks)
    {
      if(element.languageCode=='en')
      {
        print('CAPTION LINK IS: ${element.baseUrl}');
        var subtitles= await captionScraper.getSubtitles(element);
        for (final subtitle in subtitles) {
          // print('$i \r\n0${subtitle.start.toString().substring(0,11).replaceAll('.', ',')} --> 0${ (subtitle.duration+ subtitle.start).toString().substring(0,11).replaceAll('.', ',') }\r\n');
          sub= '$sub$i \r\n0${subtitle.start.toString().substring(0,11).replaceAll('.', ',') } --> 0${ (subtitle.duration+ subtitle.start).toString().substring(0,11).replaceAll('.', ',') }\r\n${subtitle.text}\r\n\r\n';  //Append each new subtitle line with the old
          i++; //Increment the counter

          await file.writeAsString(sub);
        }
        return file; //element.baseUrl;
      }
    }

    return 'noCaption'; //If no language code as en  //MAKE IT noCaption
  }

  catch(error)
  {
    print('ERROR WHILE GETTING CAPTIONS, ${error.toString()}');
    return 'noCaption';
  }

}

//-----------------------------------------------

//Allows to Print long Strings
void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

//------------------------