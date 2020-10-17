import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/main.dart';
import 'package:schedule_kpi/save_data/notifier.dart';
import 'package:schedule_kpi/save_data/shared_prefs.dart';
import 'package:schedule_kpi/save_data/theme_notifier.dart';

class Settings extends StatelessWidget {
  const Settings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          buildCategoryName('My Group', Icons.people_outline),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Provider.of<Notifier>(context).groupName.toUpperCase(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    SharedPref.remove('groups');
                    Provider.of<Notifier>(context, listen: false)
                        .removeGroupName();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => MyApp()));
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Text(
                      'Change',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          buildCategoryName('Color Settings', Icons.colorize),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('Dark Theme'),
                Switch(
                  value: Provider.of<Notifier>(context).darkModeOn,
                  onChanged: (value) {
                    Provider.of<Notifier>(context, listen: false)
                        .darkMode(value);
                    if (value) {
                      themeMode.setThemeMode(ThemeMode.dark);
                      Provider.of<Notifier>(context, listen: false)
                          .darkMode(value);
                      SharedPref.saveBool('darkMode', value);
                    } else {
                      SharedPref.remove('darkMode');
                      themeMode.setThemeMode(ThemeMode.light);
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container buildCategoryName(String name, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white54,
          ),
          SizedBox(width: 20),
          Text(
            name,
            style: TextStyle(color: Colors.white54, fontSize: 18),
          )
        ],
      ),
      color: Colors.black87,
    );
  }
}
