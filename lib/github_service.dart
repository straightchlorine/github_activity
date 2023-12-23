import 'dart:convert';
import 'package:http/http.dart' as http;
import 'github_activity.dart';
import 'user_object.dart';

class GitHubService {
  final String _baseUrl = 'https://api.github.com';

  Future<List<Activity>> getActivity(String username) async {
    final response = await http.get(Uri.parse('$_baseUrl/users/$username/events'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Activity.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch GitHub activity');
    }
  }

  Future<User> getUser(String username) async {
    final response = await http.get(Uri.parse('$_baseUrl/users/$username'));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch GitHub user');
    }
  }
}
