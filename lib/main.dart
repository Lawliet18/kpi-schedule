import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/Models/groups.dart';
import 'package:schedule_kpi/home_screen.dart';
import 'package:schedule_kpi/http_response/parse_groups.dart';
import 'package:schedule_kpi/save_data/notifier.dart';
import 'package:schedule_kpi/schedule.dart';
import 'package:schedule_kpi/save_data/shared_prefs.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => Notifier(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String groupName;
  List<String> list = [];
  List<String> loadedList = [];

  @override
  void initState() {
    super.initState();
    SharedPref.loadString('groups').then((value) => setState(() {
          groupName = value;
        }));
    SharedPref.loadListString('list_groups').then((value) => setState(() {
          loadedList.addAll(value);
        }));
    if (groupName != null) {
      Provider.of<Notifier>(context).addGroupName(groupName);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(list);
    print(groupName);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'DniproCity',
      ),
      home: groupName == null
          ? Container(
              child: loadedList.isEmpty
                  ? FutureBuilder<List<Groups>>(
                      future: fetchGroups(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          List<Groups> data = snapshot.data;
                          for (var value in data) {
                            list.add(value.groupFullName);
                          }
                          print(list);
                          SharedPref.saveListString('list_groups', list);
                          return HomeScreen(
                            groups: list,
                          );
                        } else {
                          return Scaffold(
                            body: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    )
                  : HomeScreen(
                      groups: loadedList,
                    ),
            )
          : Schedule(),
    );
  }
}
