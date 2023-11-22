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
  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _activities = [];
  }

  void _loadGitHubActivity() async {
    final username = _usernameController.text;
    if (username.isNotEmpty) {
      try {
        final activities = await _gitHubService.getGitHubActivity(username);
        setState(() {
          _activities = activities;
        });
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Please enter a GitHub username');
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Activity'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'GitHub Username'),
            ),
          ),
          ElevatedButton(
            onPressed: _loadGitHubActivity,
            child: Text('Fetch GitHub Activity'),
          ),
          Expanded(
            child: _activities.isEmpty
                ? Center(child: Text('No GitHub activity to display'))
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
          ),
        ],
      ),
    );
  }
}
