import 'package:flutter/material.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/shared/styles/colors.dart';
import 'package:path_drawing/path_drawing.dart';


class CurvePainter extends CustomPainter {
  final BuildContext context;

  CurvePainter(this.context);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.color = AppCubit.get(context).isDarkTheme ? defaultDarkColor : Colors.lightBlue;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3.2;

    var startOverview = Offset(size.width / 2.3 , size.height / 3.9);
    var middleVideos= Offset(size.width / 1.5, size.height / 2.8);

    var overViewControl1 = Offset(size.width / 0.9, size.height / 3);          //0.9
    var overViewControl2 = Offset(0.9 * size.width / 1.25, size.height / 3);  //1.25

    var overViewPath= Path();
    overViewPath.moveTo(startOverview.dx, startOverview.dy);
    overViewPath.cubicTo(overViewControl1.dx, overViewControl1.dy, overViewControl2.dx, overViewControl2.dy, middleVideos.dx, middleVideos.dy);

    canvas.drawPath(dashPath(overViewPath, dashArray: CircularIntervalList<double>(<double>[15.0, 10.5]),), paint);

    //--------------------

    var startVideos = Offset(size.width /2, size.height /2.1);
    var middleLessons = Offset(size.width /4 , size.height / 1.78);


    var videosControl1 = Offset(size.width / 5, size.height / 2.389);
    var videosControl2 = Offset(-0.2 * size.width / -1.3, size.height / 2.389);

    var videosPath= Path();
    videosPath.moveTo(startVideos.dx, startVideos.dy);
    videosPath.cubicTo(videosControl1.dx, videosControl1.dy, videosControl2.dx, videosControl2.dy, middleLessons.dx, middleLessons.dy);

    canvas.drawPath(dashPath(videosPath, dashArray: CircularIntervalList<double>(<double>[15.0, 10.5]),), paint);


    //-----------------

    var startLessons = Offset(size.width / 2.3, size.height / 1.5);
    var middleQuiz = Offset(size.width / 1.5 , size.height / 1.3);

    var lessonsControl1 = Offset(size.width / 1.3, size.height / 1.5);
    var lessonsControl2 = Offset(1 * size.width / 1.3, size.height / 1.5);

    var lessonsPath= Path();
    lessonsPath.moveTo(startLessons.dx, startLessons.dy);
    lessonsPath.cubicTo(lessonsControl1.dx, lessonsControl1.dy, lessonsControl2.dx, lessonsControl2.dy, middleQuiz.dx, middleQuiz.dy);

    canvas.drawPath(dashPath(lessonsPath, dashArray: CircularIntervalList<double>(<double>[15.0, 9]),), paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}