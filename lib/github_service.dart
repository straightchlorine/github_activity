import 'dart:convert';
import 'package:http/http.dart' as http;
import 'github_activity.dart';

class GitHubService {
  final String _baseUrl = 'https://api.github.com';

  Future<List<GitHubActivity>> getGitHubActivity(String username) async {
    final response = await http.get(Uri.parse('$_baseUrl/users/$username/events'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => GitHubActivity.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch GitHub activity');
    }
  }
}
