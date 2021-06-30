// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Are you realy want to delete this note?`
  String get alertBody {
    return Intl.message(
      'Are you realy want to delete this note?',
      name: 'alertBody',
      desc: '',
      args: [],
    );
  }

  /// `Delete note`
  String get alertTitle {
    return Intl.message(
      'Delete note',
      name: 'alertTitle',
      desc: '',
      args: [],
    );
  }

  /// `Another Settings`
  String get anotherSettings {
    return Intl.message(
      'Another Settings',
      name: 'anotherSettings',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Add picture from`
  String get cameraParameters {
    return Intl.message(
      'Add picture from',
      name: 'cameraParameters',
      desc: '',
      args: [],
    );
  }

  /// `Cannot find teacher`
  String get cannotFindTeacher {
    return Intl.message(
      'Cannot find teacher',
      name: 'cannotFindTeacher',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Change group`
  String get changeGroup {
    return Intl.message(
      'Change group',
      name: 'changeGroup',
      desc: '',
      args: [],
    );
  }

  /// `Change notes`
  String get changeNotes {
    return Intl.message(
      'Change notes',
      name: 'changeNotes',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Clear Notes`
  String get clearNotes {
    return Intl.message(
      'Clear Notes',
      name: 'clearNotes',
      desc: '',
      args: [],
    );
  }

  /// `Theme Settings`
  String get colorSettings {
    return Intl.message(
      'Theme Settings',
      name: 'colorSettings',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Problem with connection`
  String get connectionProblem {
    return Intl.message(
      'Problem with connection',
      name: 'connectionProblem',
      desc: '',
      args: [],
    );
  }

  /// `Don't have this data`
  String get correctInputGroup {
    return Intl.message(
      'Don\'t have this data',
      name: 'correctInputGroup',
      desc: '',
      args: [],
    );
  }

  /// `Create Notes`
  String get createNotes {
    return Intl.message(
      'Create Notes',
      name: 'createNotes',
      desc: '',
      args: [],
    );
  }

  /// `Current week`
  String get currentWeek {
    return Intl.message(
      'Current week',
      name: 'currentWeek',
      desc: '',
      args: [],
    );
  }

  /// `Dark Theme`
  String get darkTheme {
    return Intl.message(
      'Dark Theme',
      name: 'darkTheme',
      desc: '',
      args: [],
    );
  }

  /// `Don't know`
  String get dontKnow {
    return Intl.message(
      'Don\'t know',
      name: 'dontKnow',
      desc: '',
      args: [],
    );
  }

  /// `First loading...`
  String get firstLoading {
    return Intl.message(
      'First loading...',
      name: 'firstLoading',
      desc: '',
      args: [],
    );
  }

  /// `You are free`
  String get free {
    return Intl.message(
      'You are free',
      name: 'free',
      desc: '',
      args: [],
    );
  }

  /// `Friday`
  String get friday {
    return Intl.message(
      'Friday',
      name: 'friday',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Groups:`
  String get groups {
    return Intl.message(
      'Groups:',
      name: 'groups',
      desc: '',
      args: [],
    );
  }

  /// `Please input your group\n(like in example)`
  String get homeScreenInput {
    return Intl.message(
      'Please input your group\n(like in example)',
      name: 'homeScreenInput',
      desc: '',
      args: [],
    );
  }

  /// `Images`
  String get images {
    return Intl.message(
      'Images',
      name: 'images',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get languageChange {
    return Intl.message(
      'Change Language',
      name: 'languageChange',
      desc: '',
      args: [],
    );
  }

  /// `Can't load`
  String get loadError {
    return Intl.message(
      'Can\'t load',
      name: 'loadError',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get monday {
    return Intl.message(
      'Monday',
      name: 'monday',
      desc: '',
      args: [],
    );
  }

  /// `my Group`
  String get myGroup {
    return Intl.message(
      'my Group',
      name: 'myGroup',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Note for`
  String get noteFor {
    return Intl.message(
      'Note for',
      name: 'noteFor',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `Double tap on a lesson\n to create a note`
  String get notesMessage {
    return Intl.message(
      'Double tap on a lesson\n to create a note',
      name: 'notesMessage',
      desc: '',
      args: [],
    );
  }

  /// `To create a link put a # sign at the beginning of the link`
  String get notesTooltip {
    return Intl.message(
      'To create a link put a # sign at the beginning of the link',
      name: 'notesTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Rating :`
  String get rating {
    return Intl.message(
      'Rating :',
      name: 'rating',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Room:`
  String get room {
    return Intl.message(
      'Room:',
      name: 'room',
      desc: '',
      args: [],
    );
  }

  /// `Saturday`
  String get saturday {
    return Intl.message(
      'Saturday',
      name: 'saturday',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Schedule`
  String get schedule {
    return Intl.message(
      'Schedule',
      name: 'schedule',
      desc: '',
      args: [],
    );
  }

  /// `Schedule for`
  String get scheduleFor {
    return Intl.message(
      'Schedule for',
      name: 'scheduleFor',
      desc: '',
      args: [],
    );
  }

  /// `Cannot load your schedule.\nPlease check your internet connection.`
  String get scheduleInternetError {
    return Intl.message(
      'Cannot load your schedule.\nPlease check your internet connection.',
      name: 'scheduleInternetError',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Teachers`
  String get teacher {
    return Intl.message(
      'Teachers',
      name: 'teacher',
      desc: '',
      args: [],
    );
  }

  /// `Teacher:`
  String get teacherBlock {
    return Intl.message(
      'Teacher:',
      name: 'teacherBlock',
      desc: '',
      args: [],
    );
  }

  /// `Teacher are free`
  String get teacherFree {
    return Intl.message(
      'Teacher are free',
      name: 'teacherFree',
      desc: '',
      args: [],
    );
  }

  /// `Text`
  String get text {
    return Intl.message(
      'Text',
      name: 'text',
      desc: '',
      args: [],
    );
  }

  /// `Thurday`
  String get thurday {
    return Intl.message(
      'Thurday',
      name: 'thurday',
      desc: '',
      args: [],
    );
  }

  /// `Schedule KPI`
  String get title {
    return Intl.message(
      'Schedule KPI',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday`
  String get tuesday {
    return Intl.message(
      'Tuesday',
      name: 'tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Type:`
  String get type {
    return Intl.message(
      'Type:',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Update Schedule`
  String get updateSchedule {
    return Intl.message(
      'Update Schedule',
      name: 'updateSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Wednesday`
  String get wednesday {
    return Intl.message(
      'Wednesday',
      name: 'wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  String get about {
    return Intl.message(
      'Data from',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Your description`
  String get yourDescription {
    return Intl.message(
      'Your description',
      name: 'yourDescription',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'uk'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
