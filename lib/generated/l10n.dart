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

  /// `My business`
  String get homePageTitle {
    return Intl.message(
      'My business',
      name: 'homePageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Completed - {completedTaskCount}`
  String homePageSubTitle(Object completedTaskCount) {
    return Intl.message(
      'Completed - $completedTaskCount',
      name: 'homePageSubTitle',
      desc: '',
      args: [completedTaskCount],
    );
  }

  /// `New`
  String get addTaskCardHint {
    return Intl.message(
      'New',
      name: 'addTaskCardHint',
      desc: '',
      args: [],
    );
  }

  /// `SAVE`
  String get taskDetailsSave {
    return Intl.message(
      'SAVE',
      name: 'taskDetailsSave',
      desc: '',
      args: [],
    );
  }

  /// `Do before`
  String get deadlineTitle {
    return Intl.message(
      'Do before',
      name: 'deadlineTitle',
      desc: '',
      args: [],
    );
  }

  /// `Not set`
  String get deadlineNotSet {
    return Intl.message(
      'Not set',
      name: 'deadlineNotSet',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get deleteTaskButton {
    return Intl.message(
      'Delete',
      name: 'deleteTaskButton',
      desc: '',
      args: [],
    );
  }

  /// `Importance`
  String get importance {
    return Intl.message(
      'Importance',
      name: 'importance',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get importanceBasic {
    return Intl.message(
      'No',
      name: 'importanceBasic',
      desc: '',
      args: [],
    );
  }

  /// `!! High`
  String get importanceImportant {
    return Intl.message(
      '!! High',
      name: 'importanceImportant',
      desc: '',
      args: [],
    );
  }

  /// `Low`
  String get importanceLow {
    return Intl.message(
      'Low',
      name: 'importanceLow',
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

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `What needs to be done...`
  String get taskDetailsTextFieldHint {
    return Intl.message(
      'What needs to be done...',
      name: 'taskDetailsTextFieldHint',
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
