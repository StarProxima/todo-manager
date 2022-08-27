import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:todo_manager/main.dart';
import 'package:todo_manager/models/importance.dart';
import 'package:todo_manager/models/task_model.dart';
import 'package:todo_manager/providers/task_providers/task_list_provider.dart';
import 'package:todo_manager/repositories/tasks_controller.dart';
import 'package:todo_manager/styles/app_icons.dart';
import 'package:todo_manager/ui/task_card/task_card.dart';
import 'package:todo_manager/ui/task_details_page/widgets/task_details_importance.dart';
import 'package:todo_manager/ui/task_details_page/widgets/task_details_deadline.dart';
import 'package:todo_manager/ui/task_details_page/widgets/task_details_text_field.dart';

import '../mocks/mock_task_local_repository.dart';
import '../mocks/mock_task_remote_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Widget getApp() {
  //   return ProviderScope(
  //     overrides: [
  //       taskList.overrideWithValue(
  //         TaskList(
  //           [],
  //           TaskController(
  //             remote: MockTaskRemoteRepository(),
  //             local: MockTaskLocalRepository(),
  //           ),
  //         ),
  //       ),
  //     ],
  //     child: MyApp(),
  //   );
  // }

  Future<void> getapp() async {
    runZonedGuarded(
      () {
        runApp(
          ProviderScope(
            overrides: [
              taskList.overrideWithValue(
                TaskList(
                  [],
                  TaskController(
                    remote: MockTaskRemoteRepository(),
                    local: MockTaskLocalRepository(),
                  ),
                ),
              ),
            ],
            child: MyApp(
              supportedLocales: const [
                Locale('en', 'US'),
              ],
            ),
          ),
        );
      },
      (_, __) {},
    );
  }

  testWidgets(
    'Adding new Task by TaskDetails and check on HomePage',
    (tester) async {
      await getapp();

      await tester.pumpAndSettle();
      expect(find.byType(TaskCard), findsNothing);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.byType(TaskDetailsTextField), findsOneWidget);
      expect(find.byType(TaskDetailsImportance), findsOneWidget);
      expect(find.byType(TaskDetailsDeadline), findsOneWidget);

      final task = Task.create(
        text: 'Test Task text 123',
        done: false,
        deadline: DateTime.now(),
        importance: Importance.important,
      );

      await tester.enterText(
        find.byType(TaskDetailsTextField),
        task.text,
      );

      await tester.pumpAndSettle();

      expect(find.text(task.text), findsOneWidget);

      await tester.tap(find.byType(TaskDetailsImportance));

      await tester.pumpAndSettle();

      await tester.tap(find.text('!! High'));

      await tester.pumpAndSettle();

      expect(find.text('!! High'), findsOneWidget);

      await tester.tap(find.byType(Switch));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Not set'));

      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, 'OK'));

      await tester.pumpAndSettle();

      expect(find.text('Not set'), findsNothing);

      await tester.tap(find.widgetWithText(TextButton, 'SAVE'));

      await tester.pumpAndSettle();

      expect(find.byType(TaskCard), findsOneWidget);

      expect(
        find.textContaining(task.text, findRichText: true),
        findsOneWidget,
      );

      expect(
        find.text(DateFormat('dd MMMM yyyy').format(task.deadline!)),
        findsOneWidget,
      );

      expect(
        find.byKey(ValueKey(AppSvgIcon.important.toString())),
        findsOneWidget,
      );
    },
  );
}
