part of '../task_card.dart';

class _TaskCardCreated extends ConsumerStatefulWidget {
  const _TaskCardCreated({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TaskCardCreatedState();
}

class _TaskCardCreatedState extends ConsumerState<_TaskCardCreated>
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
        ref.read(_currentTaskStatusInTaskCard.notifier).state = TaskStatus.none;
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
    log('_TaskCardCreated');
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutCubic,
      ),
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutBack,
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(
            CurvedAnimation(
              parent: controller,
              curve: Curves.easeOutBack,
            ),
          ),
          child: const _TaskCardAnimated(),
        ),
      ),
    );
  }
}
