import 'package:github_activity/github_activity.dart';

class User {
  final String name;
  final String login;
  final String avatar_url;
  List<GitHubActivity> activities = [];

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

  void set activity(List<GitHubActivity> activities) {
    this.activities = [];
    this.activities.addAll(activities);
  }

  List<GitHubActivity> get activitiy {
    return this.activities;
  }
}
