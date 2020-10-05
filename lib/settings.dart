import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/main.dart';
import 'package:schedule_kpi/save_data/notifier.dart';
import 'package:schedule_kpi/save_data/shared_prefs.dart';

class Settings extends StatelessWidget {
  const Settings({Key key}) : super(key: key);

  changeGroup(BuildContext context) {
    SharedPref.remove('groups');
    Provider.of<Notifier>(context, listen: false).removeGroupName();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          buildCategoryName('My Group', Icons.people_outline),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<Notifier>(
                  builder: (context, value, child) =>
                      Text(value.groupName.toUpperCase()),
                ),
                GestureDetector(
                  onTap: changeGroup(context),
                  child: Text('Change'),
                ),
              ],
            ),
          ),
          buildCategoryName('Color Settings', Icons.colorize),
        ],
      ),
    );
  }

  Container buildCategoryName(String name, IconData icon) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white24,
          ),
          SizedBox(width: 20),
          Text(
            name,
            style: TextStyle(color: Colors.white24),
          )
        ],
      ),
      color: Colors.black87,
    );
  }
}
