import 'package:call_filter/helpers/config.dart';
import 'package:call_filter/widgets/settings.dart';
import 'package:call_filter/widgets/blacklist.dart';
import 'package:call_filter/widgets/home.dart';
import 'package:call_filter/widgets/tests.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the file exists
  bool fileExists = await isConfigExists("config");

  // Decide whether to start the app or not based on the file existence
  if (!fileExists) {
    Config.createConfig().saveConfig();
  }
  runApp(const NavigationBarApp());
}

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationNormal(),
    );
  }
}
class NavigationNormal extends StatefulWidget {
  const NavigationNormal({super.key});
  @override
  State<NavigationNormal> createState() => _NavigationNormalState();
}

class _NavigationNormalState extends State<NavigationNormal> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.phone_disabled),
            label: 'Liste noire',
          ),
          NavigationDestination(
            icon: Badge(
              label: Icon(Icons.bug_report, size: 16, color: Colors.white ),
              backgroundColor: Colors.green,
              child: Icon(Icons.settings_applications),
            ),
            label: 'Paramètres',
          ),
          NavigationDestination(
            icon: Badge(
              child: Icon(Icons.bug_report),
            ),
            label: 'Dev',
          ),

        ],
      ),
      body: _getDrawerItemWidget(currentPageIndex),
    );
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return HomeWidget();
      case 1:
        return BlacklistWidget();
      case 2:
        return SettingsWidget();
      case 3:
        return TestWidget();
      default:
        return Text("Error");
    }
  }
}
