import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/main.dart';
import 'package:schedule_kpi/save_data/db_lessons.dart';
import 'package:schedule_kpi/save_data/db_notes.dart';
import 'package:schedule_kpi/save_data/db_teacher_schedule.dart';
import 'package:schedule_kpi/save_data/db_teachers.dart';
import 'package:schedule_kpi/save_data/language_notifier.dart';
import 'package:schedule_kpi/save_data/notifier.dart';
import 'package:schedule_kpi/save_data/shared_prefs.dart';
import 'package:schedule_kpi/save_data/theme_notifier.dart';
import 'package:schedule_kpi/schedule.dart';

import 'generated/l10n.dart';
import 'particles/current_week.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<String> language = ["EN", "RU", "UK"];
  String? _value;
  @override
  void initState() {
    super.initState();
    _value = context.read<LanguageNotifier>().language.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CategoryName(name: S.of(context).myGroup, icon: Icons.people_outline),
          const ChangeGroup(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).currentWeek,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  context.read<Notifier>().currentWeek.toStr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                )
              ],
            ),
          ),
          CategoryName(name: S.of(context).colorSettings, icon: Icons.colorize),
          const ChangeTheme(),
          CategoryName(
              name: S.of(context).anotherSettings, icon: Icons.library_books),
          ClearButton(
            text: S.of(context).clearNotes,
            buttonText: S.of(context).clear,
            onPressed: () {
              DBNotes.db.delete();
              DBLessons.db.deleteNotes();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Schedule(
                        onSavedNotes: 2,
                      )));
            },
          ),
          ClearButton(
            text: S.of(context).updateSchedule,
            buttonText: S.of(context).refresh,
            onPressed: () {
              DBLessons.db.delete();
              DBTeacherSchedule.db.delete();
              DBTeachers.db.delete();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Schedule()));
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).languageChange,
                  style: const TextStyle(
                    fontSize: 18,
                    letterSpacing: 1.2,
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _value,
                    items: language
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            ))
                        .toList(),
                    onChanged: (item) {
                      switch (item) {
                        case "EN":
                          setLanguageButton(item);
                          break;
                        case "RU":
                          setLanguageButton(item);
                          break;
                        case "UK":
                          setLanguageButton(item);
                          break;
                        default:
                          throw "Unreacheble";
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  void setLanguageButton(String? item) {
    SharedPref.sharedPref.saveString('language', item!.toLowerCase());
    setState(() {
      _value = item;
      S.load(Locale(item.toLowerCase(), ''));
    });

    context.read<LanguageNotifier>().setLanguage(item.toLowerCase());
  }
}

class ClearButton extends StatelessWidget {
  const ClearButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      required this.buttonText})
      : super(key: key);
  final void Function() onPressed;
  final String text;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              letterSpacing: 1.2,
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).accentColor)),
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 14,
                letterSpacing: 1.2,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ChangeTheme extends StatelessWidget {
  const ChangeTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeMode = context.read<ThemeNotifier>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.of(context).darkTheme,
            style: const TextStyle(fontSize: 18),
          ),
          Switch(
            value: context.watch<ThemeNotifier>().darkModeOn,
            onChanged: (value) {
              themeMode.darkMode(darkMode: value);
              if (value) {
                themeMode.setThemeMode(ThemeMode.dark);
                SharedPref.sharedPref.saveBool('darkMode', value: value);
              } else {
                SharedPref.sharedPref.saveBool('darkMode', value: value);
                themeMode.setThemeMode(ThemeMode.light);
              }
            },
          ),
        ],
      ),
    );
  }
}

class ChangeGroup extends StatelessWidget {
  const ChangeGroup({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.watch<Notifier>().groupName.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                DBLessons.db.delete();
                DBTeacherSchedule.db.delete();
                DBTeachers.db.delete();
                SharedPref.sharedPref.remove('groups');
                context.read<Notifier>().removeGroupName();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MyApp()));
              },
              child: Container(
                alignment: Alignment.centerRight,
                color: Colors.transparent,
                child: Text(
                  S.of(context).change,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryName extends StatelessWidget {
  const CategoryName({Key? key, required this.icon, required this.name})
      : super(key: key);
  final IconData icon;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.card,
      elevation: 1,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(
              icon,
            ),
            const SizedBox(width: 20),
            Text(
              name,
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
