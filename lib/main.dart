import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:schedule_kpi/Models/groups.dart';
import 'package:schedule_kpi/Models/theme_data.dart';
import 'package:schedule_kpi/generated/l10n.dart';
import 'package:schedule_kpi/home_screen.dart';
import 'package:schedule_kpi/http_response/parse_current_week.dart';
import 'package:schedule_kpi/http_response/parse_groups.dart';
import 'package:schedule_kpi/particles/current_week.dart';
import 'package:schedule_kpi/save_data/language_notifier.dart';
import 'package:schedule_kpi/save_data/notifier.dart';
import 'package:schedule_kpi/save_data/shared_prefs.dart';
import 'package:schedule_kpi/save_data/theme_notifier.dart';
import 'package:schedule_kpi/schedule.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<LanguageNotifier>(create: (_) => LanguageNotifier()),
    ChangeNotifierProvider<Notifier>(create: (_) => Notifier()),
    ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier())
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? groupName;
  List<String> loadedList = [];
  Locale? locale;

  @override
  void initState() {
    super.initState();
    loadSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageNotifier>(
        builder: (context, value, child) => MaterialApp(
              locale: value.language.isNotEmpty
                  ? Locale(value.language, '')
                  : const Locale('en', ''),
              onGenerateTitle: (context) => S.of(context).title,
              debugShowCheckedModeBanner: false,
              //Theme
              theme: AppTheme().lightTheme,
              darkTheme: AppTheme().darkTheme,
              themeMode: context.watch<ThemeNotifier>().themeMode,
              //Localization
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              home: groupName == null || groupName == ''
                  ? (loadedList.isEmpty
                      ? const LoadingFromInternet()
                      : HomeScreen(groups: loadedList))
                  : const Schedule(),
            ));
  }

  void loadSharedPref() {
    SharedPref.loadBool('darkMode').then(
      (value) => setState(() {
        value
            ? Provider.of<ThemeNotifier>(context, listen: false)
                .setThemeMode(ThemeMode.dark)
            : Provider.of<ThemeNotifier>(context, listen: false)
                .setThemeMode(ThemeMode.light);
        Provider.of<ThemeNotifier>(context, listen: false)
            .darkMode(darkMode: value);
      }),
    );
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
          Provider.of<Notifier>(context, listen: false)
              .addCurrentWeek(parseWeek(value == '' ? '1' : value));
        }));
    SharedPref.loadString('language').then((value) => setState(() {
          if (value.isEmpty) {
            locale = Locale(Intl.systemLocale, '');
          } else {
            locale = Locale(value, '');
            Provider.of<LanguageNotifier>(context, listen: false)
                .setLanguage(value);
          }
        }));
  }
}

class LoadingFromInternet extends StatelessWidget {
  const LoadingFromInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = <String>[];
    bool isAdded = false;
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([fetchCurrentWeek(), fetchGroups()]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data[1] as List<Groups>;
            final dataWeek = snapshot.data[0] as int;
            if (!isAdded) {
              for (final value in data) {
                list.add(value.groupFullName);
              }
              //print(list);
              isAdded = true;
              SharedPref.saveListString('list_groups', list);
            }
            SharedPref.saveString('current_week', dataWeek.toString());
            Provider.of<Notifier>(context, listen: false)
                .addCurrentWeek(parseWeek(dataWeek.toString()));
            context.read<Notifier>().setWeek(parseWeek(dataWeek.toString()));
            return HomeScreen(
              groups: list,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Week parseWeek(String value) {
  switch (value) {
    case '1':
      return Week.first;
    case '2':
      return Week.second;
    default:
      throw "Unreachable";
  }
}
