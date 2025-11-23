import 'package:frontendnew/utils/app_constants.dart';
import 'package:get/get.dart';

class DataService extends GetConnect implements GetxService {
  Future<Response> getData() async {
    Response response = await get(
      AppConstants.BASE_URL + AppConstants.GET_TASKS,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    return response;
  }

  Future<Response> postData(dynamic body) async {
    Response response = await post(
      AppConstants.BASE_URL + AppConstants.CREATE_TASK,
      body,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    return response;
  }

  Future<Response> updateData(String id, dynamic body) async {
    Response response = await put(
      '${AppConstants.BASE_URL}${AppConstants.UPDATE_TASK}/$id',
      body,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    return response;
  }

  Future<Response> deleteData(String id) async {
    Response response = await delete(
      '${AppConstants.BASE_URL}${AppConstants.DELETE_TASK}/$id',
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    return response;
  }
}
