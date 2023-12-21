import 'package:flutter/material.dart';
import 'github_service.dart';
import 'github_activity.dart';
import 'user_object.dart';

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
  User? _userData;
  List<User?> user_list = [];
  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _activities = [];
  }

  void appendUser(User? user, List<User?> users) {
    for (var current_user in user_list)
      if (current_user?.login == user?.login)
        users.remove(current_user);
        users.add(user);
  }

  void _loadGitHubActivity() async {
    final username = _usernameController.text;
    if (username.isNotEmpty) {
      try {
        final activities = await _gitHubService.getGitHubActivity(username);
        final userData = await _gitHubService.getGitHubUser(username);
        setState(() {
          _activities = activities;
          _userData = userData;
          appendUser(userData, user_list);
          user_list.last?.activities = activities;
        });
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Please enter a GitHub username');
    }
  }

  void _loadStoredActivity(User? user) async {
    try {
      setState(() {
        _activities = user?.activities ?? [];
        _userData = user;
        _usernameController.text = user?.login ?? '';
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (_userData != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_userData?.avatar_url ?? 'url missing'),
                ),
                SizedBox(height: 10),
                if (_userData != null)
                Text(
                  _userData?.name ?? _userData?.login ?? 'id missing',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'GitHub Username'),
                ),
                Padding(padding: EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: _loadGitHubActivity,
                    child: Text('Fetch GitHub Activity'),
                  ),
                )
              ],
            ),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Text(
            'Fetched Users',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        for (var item in user_list.reversed.toList())
          ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(item?.avatar_url ?? 'none')),
            title: Text(item?.login ?? 'id missing'),
            subtitle: Text(item?.name ?? 'name missing'),
            onTap: () {
              _loadStoredActivity(item);
              Navigator.pop(context);
            },
          ),
          ],
        ),
      ),
          
    );
  }
}
