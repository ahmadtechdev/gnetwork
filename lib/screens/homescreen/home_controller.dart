import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../api_service/api_service.dart';
import '../../api_service/local_stroge.dart';


class HomeController extends GetxController {
  final ApiService _apiService = ApiService();
  final Dio _dio = Dio();

  var isLoading = true.obs;
  var userData = {}.obs;
  var posts = [].obs;
  var logs = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading(true);
      final token = LocalStorage.getToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        'https://lightyellow-ape-562667.hostingersite.com/api/dashboard',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        userData.value = response.data['user'];
        posts.value = response.data['posts'];
        logs.value = response.data['logs'];
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch dashboard data: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  String getBalance() {
    return userData['balance']?.toString() ?? '0.00';
  }

  String getMiningRate() {
    return userData['mine_rate']?.toString() ?? '0.00';
  }

  String getNetworkCount() {
    return '${userData['direct_refer_count'] ?? 0}/${userData['whole_team_count'] ?? 0}';
  }
}