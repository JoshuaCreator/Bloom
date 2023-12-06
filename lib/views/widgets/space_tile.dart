import '../../utils/imports.dart';

class SpaceTile extends ConsumerWidget {
  const SpaceTile({
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
          padding: EdgeInsets.all(five),
          decoration: BoxDecoration(borderRadius: defaultBorderRadius),
          child: Row(
            mainAxisSize: MainAxisSize.min,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: twenty - 2,
                        color: ColourConfig.grey,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ColourConfig.grey.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
