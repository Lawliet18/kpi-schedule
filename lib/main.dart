import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/Models/groups.dart';
import 'package:schedule_kpi/Models/theme_data.dart';
import 'package:schedule_kpi/home_screen.dart';
import 'package:schedule_kpi/http_response/parse_current_week.dart';
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
  String currentWeek;
  bool isAdded;
  List<String> list = [];
  List<String> loadedList = [];

  @override
  void initState() {
    super.initState();
    isAdded = false;
    SharedPref.loadString('groups').then(
      (value) => setState(() {
        groupName = value;
        Provider.of<Notifier>(context, listen: false).addGroupName(value);
      }),
    );
    SharedPref.loadListString('list_groups').then((value) => setState(() {
          loadedList.addAll(value);
        }));
    SharedPref.loadString('current_week').then((value) => setState(() {
          currentWeek = value;
          Provider.of<Notifier>(context, listen: false).addCurrentWeek(value);
        }));
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
      home: groupName == null ||
              groupName == '' ||
              currentWeek == null ||
              currentWeek == ''
          ? Container(
              child: loadedList.isEmpty
                  ? FutureBuilder(
                      future: Future.wait([fetchCurrentWeek(), fetchGroups()]),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          List<Groups> data = snapshot.data[1];
                          String dataWeek = snapshot.data[0].toString();
                          print(data.isEmpty);
                          if (!isAdded) {
                            for (var value in data) {
                              list.add(value.groupFullName);
                            }
                            isAdded = true;
                            SharedPref.saveListString('list_groups', list);
                          }
                          SharedPref.saveString(
                              'current_week', dataWeek.toString());

                          return HomeScreen(
                            groups: list,
                            currentWeek: currentWeek,
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
                      currentWeek: currentWeek,
                    ),
            )
          : Schedule(currentWeek: currentWeek),
    );
  }
}
