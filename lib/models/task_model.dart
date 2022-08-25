// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'importance.dart';

part 'task_model.g.dart';
part 'task_model.freezed.dart';

class TimestampConverter implements JsonConverter<DateTime, int> {
  const TimestampConverter();

  @override
  DateTime fromJson(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  @override
  int toJson(DateTime date) => date.millisecondsSinceEpoch;
}

class TimestampOrNullConverter implements JsonConverter<DateTime?, int?> {
  const TimestampOrNullConverter();

  @override
  DateTime? fromJson(int? timestamp) {
    return timestamp == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  @override
  int? toJson(DateTime? date) => date?.millisecondsSinceEpoch;
}

@Freezed()
class Task with _$Task {
  const Task._();

  @HiveType(typeId: 0)
  const factory Task({
    @HiveField(0) required String id,
    @HiveField(1) required String text,
    @HiveField(2) required bool done,
    @HiveField(3) required Importance importance,
    @TimestampOrNullConverter() @HiveField(4) DateTime? deadline,
    @TimestampConverter()
    @JsonKey(name: 'created_at')
    @HiveField(6)
        required DateTime createdAt,
    @TimestampConverter()
    @JsonKey(name: 'changed_at')
    @HiveField(7)
        required DateTime changedAt,
    @JsonKey(name: 'last_updated_by')
    @HiveField(8)
        required String lastUpdatedBy,
  }) = _Task;

  static int _taskCountInCurrentSession = 0;

  factory Task.fromJson(Map<String, Object?> json) => _$TaskFromJson(json);

  factory Task.create({
    String text = '',
    bool done = false,
    Importance importance = Importance.basic,
    DateTime? deadline,
  }) {
    var now = DateTime.now();
    final id = '${now.millisecondsSinceEpoch}${_taskCountInCurrentSession++}';
    final createdAt = now;
    final changedAt = now;
    const lastUpdatedBy = 'Pacman';
    return Task(
      id: id,
      text: text,
      done: done,
      importance: importance,
      deadline: deadline,
      createdAt: createdAt,
      changedAt: changedAt,
      lastUpdatedBy: lastUpdatedBy,
    );
  }

  factory Task.random() {
    var random = Random();

    String tasks =
        'Сходить на 10 спектаклей. Организовать семейный ужин. Стать донором крови. Провести месяц без алкоголя. Сходить в поход. Вести учет расходов. Запустить свой проект. Сходить в 10 новых музеев. Простить обиду близкому человеку. Провести отпуск с компанией друзей. Попробовать 5 новых видов спорта. Сходить на концерт любимой группы. Открыть накопительный счет. Пройти курс повышения квалификации. Прочитать 40 книг. Устроить совместную велопрогулку по городу на несколько часов с насыщенной программой. Сходить в баню с друзьями. Начать медитировать. Совершить автопутешествие. Накопить на путешествие мечты. Научиться делегировать задачи. Нарисовать картину. Сходить в театр всей семьей. Собрать друзей на домашний ужин. Принимать контрастный душ. Провести Новый год в экзотическом месте. Начать зарабатывать на своем проекте. Инициировать новый проект на работе. Взять уроки танца. Возродить семейную традицию. Сделать другу/подруге неожиданный подарок. Пройти курсы первой помощи. Прыгнуть с парашютом. Закрыть кредиты. Найти себе ментора. Избавиться от лишних вещей. Устроить семейную фотосессию. Стать волонтером. Подводить итоги недели. Подарить себе ЗРА - программу. Научиться инвестировать. Уходить с работы вовремя. Все законы унифицировать в рамках юридической системы мировых судов, использующих один и тот же кодекс законов, за исполнением которого будет следить полиция Единого Мирового Правительства, а объединённые вооружённые силы Единого Мира насильно внедрят законы во все бывшие страны, которые больше не будут разделяться границами. Сделать так, чтобы система была основана на базе благоденствующего государства; кто покорился и служит Единому Мировому Правительству, будет вознаграждён средствами к жизни; кто взбунтуется, будет просто заморен голодом или объявлен вне закона, став мишенью для каждого, кто захочет убить его. Сатанизм, люциферианство и чёрная магия признать законными предметами обучения с запрещением частных или церковных школ. Все христианские церкви разрушить, а само христианство при Едином Мировом Правительстве отодвинуть в прошлое. Сделать так, чтобы сельское хозяйство было исключительно в руках Комитета 300, а производство продуктов питания строго контролировалось. Квалифицированные рабочие переместить в другие города, если город, где они живут, окажется перенаселённым. Неквалифицированные рабочих отобрать наугад и послать в неполностью заселённые города, чтобы заполнить их «квоты». Сделать так, чтобы все информационные службы и средства печати находились под контролем Мирового Правительства. Под видом «развлечений» устраивать регулярные промывания мозгов, что уже практикуется в XXX, где это стало искусством. Сделать так, чтобы после уничтожения таких отраслей промышленности, как строительная, автомобильная, металлургическая, тяжёлое машиностроение, жилищное строительство будет ограничено, а сохранённые отрасли промышленности будут находиться под контролем натовского «Римского клуба», а также все научные и космические исследования, которые будут ограничены и всецело подчинены Комитету 300. Уничтожить космическое оружие бывших стран вместе с ядерным оружием.';

    List<String> taskTextList = tasks.split('.');

    return Task.create(
      text: taskTextList[random.nextInt(taskTextList.length)].trim(),
      done: random.nextInt(100) < 40,
      importance: Importance.values[random.nextInt(3)],
      deadline: random.nextInt(100) < 60
          ? DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch +
                  random.nextInt(120) * 1000 * 60 * 60 * 24 +
                  random.nextInt(24 * 60) * 1000 * 60,
            )
          : null,
    );
  }

  Task edit({
    String? text,
    bool? done,
    Importance? importance,
    DateTime? deadline,
    bool? deleteDeadline,
  }) {
    return Task(
      id: id,
      text: text ?? this.text,
      done: done ?? this.done,
      importance: importance ?? this.importance,
      deadline: deleteDeadline ?? false ? null : deadline ?? this.deadline,
      createdAt: createdAt,
      changedAt: DateTime.now(),
      lastUpdatedBy: 'Pacman',
    );
  }
}
