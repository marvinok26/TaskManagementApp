import 'package:get/get.dart';

class DataService extends GetConnect implements GetxService {
  Future<Response> getData() async {
    Response response = await get(
      "http://192.168.0.57:8081/gettasks",
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );

    return response;
  }

  Future<Response> postData(dynamic body) async {
    Response response = await post(
      "http://192.168.0.57:8081/create",
      body,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );

    return response;
  }
}
