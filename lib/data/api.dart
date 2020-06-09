import 'dart:convert';

import 'package:demoflutter/model/playing.dart';
import 'package:http/http.dart' as http;

class MovieRepository {
  Future<Playing> getNowPlaying(int currentPage, String cari, String sort) async {
    var url = 'http://153.92.4.241/api/get/video?page=' + currentPage.toString()+'&cari='+cari+'&sort='+sort;
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Playing.fromJson(json.decode(response.body));
    } else {
      throw Exception('Faild to load');
    }
  }
}
