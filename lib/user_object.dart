import 'package:github_activity/github_activity.dart';

import 'package:hive/hive.dart';

part 'user_object.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
 
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String login;

  @HiveField(2)
  final String avatar_url;

  @HiveField(3)
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
