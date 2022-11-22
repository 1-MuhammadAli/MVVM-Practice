
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart%20';
import 'package:mvvm/data/app_exceptions.dart';
import 'package:mvvm/data/network/BaseApiServices.dart';
import 'package:http/http.dart' as http; 

class NetworkApiServices extends BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {

    dynamic responseJason ;
    try {

      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 10));
      responseJason = returnResponse(response);
    }on SocketDirection {

      throw FetchDataException('No Internet Connection');
    }

    return responseJason;
  }

  @override
  Future getPostApiResponse(String url , dynamic data) async {

    dynamic responseJason ;
    try {

      Response response = await http.post(
          Uri.parse(url),
          body: data
      ).timeout(Duration(seconds: 10));
      responseJason = returnResponse(response);
    }on SocketDirection {

      throw FetchDataException('No Internet Connection');
    }

    return responseJason;
  }

  dynamic returnResponse (http.Response response) {

    switch(response.statusCode) {
      case 200:
        dynamic responseJson =jsonDecode(response.body);
        return responseJson;
      case 400:
      case 500:
        throw BadRequestException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
        default:
          throw FetchDataException('Error accrued while communicating with server'+
          'with status code' + response.statusCode.toString());
    }
  }

}