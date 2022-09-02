part of '../task_card.dart';

class _TaskCardAnimated extends ConsumerStatefulWidget {
  const _TaskCardAnimated({Key? key}) : super(key: key);

  @override
  ConsumerState<_TaskCardAnimated> createState() => _TaskCardAnimatedState();
}

class _TaskCardAnimatedState extends ConsumerState<_TaskCardAnimated>
    with TickerProviderStateMixin {
  late final controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  late final animation = Tween<double>(
    begin: 0,
    end: 0.5,
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutQuad,
    ),
  );

  bool isFirstBuild = true;

  Task? lastTask;

  @override
  void initState() {
    super.initState();
    controller.addStatusListener((status) {
      if (controller.isCompleted) {
        controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final task = ref.watch(_currentTaskInTaskCard);

    final lastTaskInTaskList = ref.read(taskList.notifier).lastTask;

    final bool isEditedTask = lastTaskInTaskList?.id == task.id &&
        lastTask?.changedAt != task.changedAt &&
        !isFirstBuild;

    lastTask = lastTaskInTaskList;
    isFirstBuild = false;

    if (isEditedTask) {
      controller.reset();
      controller.forward();
    }

    return AnimatedBuilder(
      animation: animation,
      child: const _TaskCardDismissible(),
      builder: (context, child) {
        return Transform(
          alignment: Alignment.topCenter,
          transform: Matrix4.rotationX(animation.value),
          child: child,
        );
      },
    );
  }
}
