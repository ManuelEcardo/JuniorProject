import 'package:dio/dio.dart';
import 'package:juniorproj/shared/network/end_points.dart';

// Dio is an HTTP client, we declare in the init() giving the url to get the data from, and it getData we give him the method and queries.
class MainDioHelper
{
  static Dio ? dio;

  static init()
  {
    dio=Dio(
      BaseOptions(
        baseUrl: '$localhost/api/',   // JuniorProject default url.
        receiveDataWhenStatusError: true,
        receiveTimeout:50000,
        connectTimeout: 30000,
      ),
    );
  }

  static Future<Response> getData({required String url,  Map<String,dynamic>? query, String lang='en', String? token,}) async
  {
    dio?.options.headers=
    {
      'Connection' : 'keep-alive',
      'Authorization': 'Bearer $token',
    };

    print('in Main Dio getData');
    return await dio!.get(
      url,
      queryParameters: query,
    ); //path is the method
  }



  static Future<Response> postData(
      {required String url, Map<String,dynamic>?query,  required Map<String,dynamic> data, String lang='en', String? token,  }) async
  {
    dio?.options.headers=
    {
      'Connection' : 'keep-alive',
      'Authorization': 'Bearer $token',
    };

    print('in Main Dio postData');
    return await dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
  }


  static Future<Response> putData(
      {required String url, Map<String,dynamic>?query,  required Map<String,dynamic> data, String lang='en', String? token,  }) async
  {
    dio?.options.headers=
    {
      'Connection' : 'keep-alive',
      'token': token,
    };
    print('in Main Dio putData');
    return await dio!.put(
      url,
      queryParameters: query,
      data: data,
    );
  }

}