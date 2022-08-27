part of '../task_card.dart';

class _TaskCardHidden extends ConsumerStatefulWidget {
  const _TaskCardHidden({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskCardHiddenState();
}

class _TaskCardHiddenState extends ConsumerState<_TaskCardHidden>
    with TickerProviderStateMixin {
  late final controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  )..forward();

  final animationIsCompleted = StateProvider<bool>((ref) {
    return false;
  });

  @override
  void initState() {
    controller.addStatusListener((status) {
      if (controller.isCompleted) {
        ref.read(_currentTaskStatusInTaskCard.notifier).state =
            TaskCardAnimation.empty;
        ref.read(animatedTaskList.notifier).changeAnimation(
              ref.read(_currentTaskInTaskCard),
              TaskCardAnimation.empty,
            );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: Tween<double>(begin: 1, end: 0).animate(controller),
        curve: Curves.easeInOutCubic,
      ),
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: Tween<double>(begin: 1, end: 0).animate(controller),
          curve: Curves.easeOutBack,
        ),
        child: const _TaskCardAnimated(),
      ),
    );
  }
}
