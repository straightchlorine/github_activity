import 'package:hive/hive.dart';

part 'github_activity.g.dart';

@HiveType(typeId: 1)
class Activity {

  @HiveField(0)
  final String type;

  @HiveField(1)
  final String repoName;

  @HiveField(2)
  final String actorLogin;

  @HiveField(3)
  final DateTime createdAt;

  Activity({
    required this.type,
    required this.repoName,
    required this.actorLogin,
    required this.createdAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      type: json['type'],
      repoName: json['repo']['name'],
      actorLogin: json['actor']['login'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
