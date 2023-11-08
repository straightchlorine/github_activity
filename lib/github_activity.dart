class GitHubActivity {
  final String type;
  final String repoName;
  final String actorLogin;
  final DateTime createdAt;

  GitHubActivity({
    required this.type,
    required this.repoName,
    required this.actorLogin,
    required this.createdAt,
  });

  factory GitHubActivity.fromJson(Map<String, dynamic> json) {
    return GitHubActivity(
      type: json['type'],
      repoName: json['repo']['name'],
      actorLogin: json['actor']['login'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
