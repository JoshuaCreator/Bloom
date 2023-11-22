import '../../utils/imports.dart';

class WorkspaceTile extends StatelessWidget {
  const WorkspaceTile({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
  final String id, title, subtitle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ten, vertical: ten),
        // margin: EdgeInsets.symmetric(horizontal: ten, vertical: five),
        decoration: BoxDecoration(
          // color: Colors.red,
          borderRadius: defaultBorderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: twenty - 2, color: Colors.grey),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.withOpacity(0.4)),
            ),
          ],
        ),
      ),
    );
  }
}
