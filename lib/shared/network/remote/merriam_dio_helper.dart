import 'package:dio/dio.dart';

// Dio is like an API helper to get data, we declare in the init() giving the url to get the data from, and it getData we give him the method and queries.
class MerriamDioHelper
{
  static Dio ? dio;

  static init()
  {
    dio=Dio(
      BaseOptions(
        baseUrl: 'https://www.dictionaryapi.com/api/',   // Merriam Webster default url.
        receiveDataWhenStatusError: true,
        // receiveTimeout: Duration.zero,
        // connectTimeout: Duration.zero,
      ),
    );
  }

  static Future<Response> getData({required String url,  Map<String,dynamic>? query, String lang='en', String token='dc4e63df-1cd8-4853-863d-cc32dfa6cbcf',}) async
  {
    dio?.options.headers=
    {
      //'Content-Type':'application/json',
      //'lang':lang,
      'key': token,
    };

    print('in Merriam Dio getData');
    return await dio!.get(
        url,
      queryParameters: query,
    ); //path is the method
  }


}