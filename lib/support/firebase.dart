import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hive/hive.dart';
import 'logger.dart';

import '../firebase_options.dart';

final remoteConfig = FirebaseRemoteConfig.instance;

Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(seconds: 10),
    ),
  );
  try {
    await remoteConfig.fetchAndActivate();
    int importanceColor = remoteConfig.getInt("importanceColor");
    if (importanceColor != 0) {
      Hive.box<int>('support').put('importanceColor', importanceColor);
    }
  } catch (e) {
    logger.e('fetchAndActivate - set importanceColor error', e);
  }
  logger.i('initFirebase');
}
