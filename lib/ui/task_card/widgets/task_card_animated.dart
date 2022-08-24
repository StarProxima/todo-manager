part of '../task_card.dart';

class _TaskCardAnimated extends ConsumerStatefulWidget {
  const _TaskCardAnimated({Key? key}) : super(key: key);

  @override
  ConsumerState<_TaskCardAnimated> createState() => _TaskCardAnimatedState();
}

class _TaskCardAnimatedState extends ConsumerState<_TaskCardAnimated>
    with TickerProviderStateMixin {
  late final controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final animation = Tween<double>(
    begin: 0,
    end: 0.5,
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: Curves.decelerate,
    ),
  );

  bool isFirstBuild = true;

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
    ref.watch(_currentTaskInTaskCard);

    if (!isFirstBuild) {
      controller.reset();
      controller.forward();
    } else {
      isFirstBuild = false;
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
