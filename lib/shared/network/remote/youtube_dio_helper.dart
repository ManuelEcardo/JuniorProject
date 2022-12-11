import 'package:dio/dio.dart';
import 'package:juniorproj/shared/network/end_points.dart';

// Dio is an HTTP client, we declare in the init() giving the url to get the data from, and it getData we give him the method and queries.
class YoutubeDioHelper
{
  static Dio ? dio;

  static init()
  {
    dio=Dio(
      BaseOptions(
        baseUrl: 'https://www.googleapis.com/youtube/v3/',   // Youtube API default url.
        receiveDataWhenStatusError: true,
        receiveTimeout:50000,
        connectTimeout: 30000,
      ),
    );
  }

  static Future<Response> getData({required String url,  Map<String,dynamic>? query}) async
  {
    dio?.options.headers=
    {
      'Connection' : 'keep-alive',
      'key': youtubeToken,
    };

    print('in Main Youtube getData');
    return await dio!.get(
      url,
      queryParameters: query,
    ); //path is the method
  }

}