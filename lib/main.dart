import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/Models/groups.dart';
import 'package:schedule_kpi/Models/theme_data.dart';
import 'package:schedule_kpi/home_screen.dart';
import 'package:schedule_kpi/http_response/parse_groups.dart';
import 'package:schedule_kpi/save_data/notifier.dart';
import 'package:schedule_kpi/save_data/theme_notifier.dart';
import 'package:schedule_kpi/schedule.dart';
import 'package:schedule_kpi/save_data/shared_prefs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPref.loadBool('darkMode').then((value) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<Notifier>(create: (context) => Notifier()),
          ChangeNotifierProvider<ThemeNotifier>(create: (context) {
            bool darkTheme = value;
            if (darkTheme == null || darkTheme == false) {
              return ThemeNotifier(ThemeMode.light);
            } else {
              return ThemeNotifier(ThemeMode.dark);
            }
          }),
        ],
        child: MyApp(),
      ),
    );
  });
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
      Provider.of<Notifier>(context, listen: false).addGroupName(groupName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().lightTheme,
      darkTheme: AppTheme().darkTheme,
      themeMode: themeMode.themeMode,
      home: groupName == null || groupName == ''
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
