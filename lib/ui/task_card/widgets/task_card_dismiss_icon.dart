part of '../task_card.dart';

class _TaskCardDismissIcon extends StatelessWidget {
  const _TaskCardDismissIcon({
    Key? key,
    required this.direction,
    required this.progress,
    required this.icon,
  }) : super(key: key);

  final DismissDirection direction;
  final double progress;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).size.width * progress - 47;

    return Padding(
      padding: EdgeInsets.only(
        left: direction == DismissDirection.startToEnd
            ? padding > 24
                ? padding
                : 24
            : 0,
        right: direction == DismissDirection.endToStart
            ? padding > 24
                ? padding
                : 24
            : 0,
      ),
      child: icon,
    );
  }
}
