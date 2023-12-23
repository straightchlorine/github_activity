class Activity {
  final String type;
  final String repoName;
  final String actorLogin;
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
