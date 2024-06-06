import 'package:http/http.dart' as http;
import 'package:koumi_app/constants.dart';

class RemoteServices {
  static var client = http.Client();
  int page = 1;
  int size = 10;
   var baseURL = '$apiOnlineUrl/Stock/getAllStocksWithPagination';
  // static var baseURL = 'https://grocery-app-sc6n.onrender.com';

   Future<dynamic> fetchItem(int start) async {
    var response = await client.get(
      Uri.parse('$baseURL/?page=$page&size=$size'),
    );
    return response;
  }

}