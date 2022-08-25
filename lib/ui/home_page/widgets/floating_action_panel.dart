// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../models/task_model.dart';
import '../../../router/app_router_delegate.dart';

class FloatingActionPanel extends ConsumerWidget {
  const FloatingActionPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //if (kDebugMode)
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: FloatingActionButton(
            heroTag: null,
            mini: true,
            onPressed: () {
              ref.watch(taskList.notifier).updateFromRemoteServer();
            },
            child: const Icon(
              Icons.update,
              size: 25,
            ),
          ),
        ),
        //if (kDebugMode)
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: FloatingActionButton(
            heroTag: null,
            mini: true,
            onPressed: () {
              ref.watch(appThemeMode.notifier).switchTheme();
            },
            child: const Icon(
              Icons.color_lens,
              size: 25,
            ),
          ),
        ),
        //if (kDebugMode)
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: FloatingActionButton(
            heroTag: null,
            mini: true,
            onPressed: () {
              var task = Task.random();
              ref.watch(taskList.notifier).add(task);
            },
            child: const Icon(
              Icons.casino,
              size: 25,
            ),
          ),
        ),
        //if (kDebugMode)
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: FloatingActionButton(
            heroTag: null,
            mini: true,
            onPressed: () {
              throw Exception('Test crash by button in HomePage');
            },
            child: const Icon(
              Icons.warning,
              size: 25,
            ),
          ),
        ),
        FloatingActionButton(
          heroTag: null,
          onPressed: () {
            (Router.of(context).routerDelegate as AppRouterDelegate)
                .gotoTaskDetails();
          },
          child: const Icon(
            Icons.add,
            size: 35,
          ),
        ),
      ],
    );
  }
}
