import '../../utils/imports.dart';

class WorkspaceTile extends ConsumerWidget {
  const WorkspaceTile({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    this.onTap,
  });
  final String id, title, subtitle, image;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: five, horizontal: ten),
      child: InkWell(
        onTap: onTap,
        borderRadius: defaultBorderRadius,
        child: Container(
          padding: EdgeInsets.all(ten),
          decoration: BoxDecoration(
            borderRadius: defaultBorderRadius,
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(thirty),
                decoration: BoxDecoration(
                  borderRadius: defaultBorderRadius,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: ten),
              Column(
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
            ],
          ),
        ),
      ),
    );
  }
}
