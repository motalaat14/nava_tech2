import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:http_parser/http_parser.dart';

class DioBase {
// next three lines makes this class a Singleton
  static DioBase _instance = new DioBase.internal();

  DioBase.internal();

  // String base_url = "https://lbitak.com/api/";
  // String baseUrl = "https://ewsaly.co/api/";
  // String baseUrl = "https://navaapp.net/api/";
  String baseUrl = "https://navaservices.net/api/";



  Dio dio = Dio();

  factory DioBase() => _instance;

  Future<Response> get(String url, {Map headers}) async {
    var response;
    try {
      dio.options.baseUrl = baseUrl;
      print("--------------------base url : ${baseUrl+url}");
      response = await dio.get(url, options: Options(headers: headers));
      print("--------------------base url = "+baseUrl);
    } on DioError catch (e,trace) {
      print("------- error $e");
      print("------- trace $trace");
      if (e.response != null) {
        response = e.response;
      } else {}
    }
    return handleResponse(response);
  }

  Future<Response> post(String url, {Map headers, FormData body, encoding}) async {
    var response;
    dio.options.baseUrl = baseUrl;
    try {
      response = await dio.post(url, data: body,
          options: Options(headers: headers, requestEncoder: encoding));
    } on DioError catch (e) {
      if (e.response != null) {
        response = e.response;
        print("RESS" + e.response.toString());
      } else {
//        print("LAAAAAA " + e.stackTrace.toString());
      }
    }
    return handleResponse(response);
  }



  uploadFile(url,Map<String,dynamic> body,{Map<String,String> header}) async{
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest("POST", Uri.parse("$baseUrl$url"));
    request.headers.addAll(header);
    //add text fields
    body.forEach((key, value) async {
      if((value) is File){
        //create multipart using filepath, string or bytes
        var pic = await http.MultipartFile.fromPath("$key", value.path,contentType: MediaType('image', 'jpg'));
        //add multipart to request
        request.files.add(pic);
      }else if((value) is List<File>){
        value.forEach((element) async {
          print("key $key :  $value  ");
          var pic = await http.MultipartFile.fromPath("$key", element.path,contentType: MediaType('image', 'jpg'));
          //add multipart to request
          request.files.add(pic);
        });
      }else{
        request.fields["$key"] = "$value";
      }
    });

    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    print("=============== Status Code "+response.statusCode.toString());
    print("================ Response "+responseString);
    var data=json.decode(responseString);
    return data;
  }

  Future<Response> delete(String url, {Map headers}) {
    return dio
        .delete(
      url,
      options: Options(headers: headers),
    )
        .then((Response response) {
      return handleResponse(response);
    });
  }

  Future<Response> put(String url, {Map headers, body, encoding}) {
    return dio
        .put(url,
        data: body,
        options: Options(headers: headers, requestEncoder: encoding))
        .then((Response response) {
      return handleResponse(response);
    });
  }

  Response handleResponse(Response response) {
    final int statusCode = response.statusCode;
    print("RESPONSE : " + response.toString());
    if (statusCode == 401) {
      throw new Exception("Unauthorized");
    } else if (statusCode != 200) {
//      throw new Exception("Error while fetching data");
    }

    if (statusCode >= 200 && statusCode < 300) {
      return response;
    } else {
      return response;
    }
  }
}
