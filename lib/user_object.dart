import 'package:github_activity/github_activity.dart';

class User {
  final String name;
  final String login;
  final String avatar_url;

  User({
    required this.name,
    required this.login,
    required this.avatar_url,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      login: json['login'],
      avatar_url: json['avatar_url']
    );
  }
}
