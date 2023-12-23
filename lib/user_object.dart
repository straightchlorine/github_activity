import 'package:github_activity/github_activity.dart';

class User {
  final String name;
  final String login;
  final String avatar_url;
  List<Activity> user_activities = [];

  User({
    required this.name,
    required this.login,
    required this.avatar_url,
    this.user_activities = const <Activity>[],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      login: json['login'],
      avatar_url: json['avatar_url']
    );
  }

  void set activities(List<Activity> activities) {
    user_activities = [];
    user_activities.addAll(activities);
  }

  List<Activity> get activities {
    return this.user_activities;
  }
}
