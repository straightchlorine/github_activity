import 'package:flutter/material.dart';
import 'github_service.dart';
import 'github_activity.dart';
import 'user_object.dart';
import 'globals.dart' as globals;
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: GitHubActivity(),
    )
  );
}

class AppState extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void appendUser(User? user) {
    for (var current_user in globals.fetched)
      if (current_user?.login == user?.login)
        globals.fetched.remove(current_user);
        globals.fetched.add(user);
    notifyListeners();
  }

  void loadStoredActivity(User? user) async {
      globals.current_user = user;
      notifyListeners();
  }

}

class GitHubActivity extends StatefulWidget {
  _GitHubActivityState createState() => _GitHubActivityState();
}

class _GitHubActivityState extends State<GitHubActivity> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      builder: (context, _) {
        final appState = Provider.of<AppState>(context);
        return MaterialApp(
          title: 'GitHub Activity App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: Scaffold(
            appBar: ApplicationControlBar(),
            body: ActivityScreen(),
            drawer: FetchedUsersDrawer(),
          )
        );
      },
    );
  }
}

class ApplicationControlBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _ApplicationControlBarState createState() => _ApplicationControlBarState();

    @override
    Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ApplicationControlBarState extends State<ApplicationControlBar> {

  void toggleTheme() {
      Provider.of<AppState>(context, listen: false).toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('GitHub Activity'),
      actions: [
        IconButton(
          icon: Icon(Icons.brightness_4),
          onPressed: toggleTheme
        )
      ],
    );
  }
}

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {

  TextEditingController _usernameController = TextEditingController();
  final GitHubService _gitHubService = GitHubService();

  void _loadGitHubActivity() async {
    var appState = Provider.of<AppState>(context, listen: false);

    final username = _usernameController.text;
    if (username.isNotEmpty) {
      try {
        final user = await _gitHubService.getUser(username);
        final activities = await _gitHubService.getActivity(username);
        globals.current_user = user;
        globals.current_user!.activities = activities;
        appState.appendUser(globals.current_user);
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Please enter a GitHub username');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if (globals.current_user != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(globals.current_user?.avatar_url ?? 'url missing'),
                ),
                SizedBox(height: 10),
              if (globals.current_user != null)
                Text(
                  globals.current_user?.name ?? globals.current_user?.login ?? 'id missing',
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
          child: globals.current_user?.activities == null ? 
            Center(
              child: Text('No GitHub activity fetched to display')
            ) : ListView.builder(
            itemCount: globals.current_user?.activities.length,
            itemBuilder: (context, index) {
              final activity = globals.current_user!.activities[index];
              return ListTile(
                title: Text(activity.type),
                subtitle: Text('${activity.actorLogin} - ${activity.repoName}'),
                trailing: Text(activity.createdAt.toString()),
              );
            },
          ),
        ),
      ],
    );
  }
}

class FetchedUsersDrawer extends StatefulWidget {
  @override
  _FetchedUsersDrawerState createState() => _FetchedUsersDrawerState();
}

class _FetchedUsersDrawerState extends State<FetchedUsersDrawer> {

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: false);

    return Drawer(
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
          for (var item in globals.fetched.reversed.toList())
            ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(item?.avatar_url ?? 'none')),
              title: Text(item?.login ?? 'id missing'),
              subtitle: Text(item?.name ?? 'name missing'),
              onTap: () {
                appState.loadStoredActivity(item);
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}
