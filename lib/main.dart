import 'package:flutter/material.dart';
import 'github_service.dart';
import 'github_activity.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Activity App',
      home: GitHubActivityScreen(),
    );
  }
}

class GitHubActivityScreen extends StatefulWidget {
  @override
  _GitHubActivityScreenState createState() => _GitHubActivityScreenState();
}

class _GitHubActivityScreenState extends State<GitHubActivityScreen> {
  final GitHubService _gitHubService = GitHubService();
  late List<GitHubActivity> _activities;
  final String _username = 'straightchlorine';

  @override
  void initState() {
    super.initState();
    _loadGitHubActivity();
  }

  void _loadGitHubActivity() async {
    try {
      final activities = await _gitHubService.getGitHubActivity(_username);
      setState(() {
        _activities = activities;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Activity'),
      ),
      body: _activities == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                final activity = _activities[index];
                return ListTile(
                  title: Text(activity.type),
                  subtitle: Text('${activity.actorLogin} - ${activity.repoName}'),
                  trailing: Text(activity.createdAt.toString()),
                );
              },
            ),
    );
  }
}
