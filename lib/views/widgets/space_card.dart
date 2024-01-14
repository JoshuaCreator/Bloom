import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/widgets/app_button.dart';
import 'package:basic_board/views/widgets/show_more_text.dart';

class SpaceCard extends StatelessWidget {
  const SpaceCard({
    super.key,
    required this.img,
    required this.name,
    required this.desc,
    required this.isParticipant,
    this.onTap,
    this.onJoin,
  });
  final String? img;
  final String name, desc;
  final bool isParticipant;
  final void Function()? onTap, onJoin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ten),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(twenty),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(twenty),
            border: Border.all(color: ColourConfig.grey),
          ),
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(maxHeight: size * 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(twenty),
                    topRight: Radius.circular(twenty),
                  ),
                  image: DecorationImage(
                    image:
                        CachedNetworkImageProvider(img ?? defaultSpaceImgPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(ten),
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: twenty + five,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              desc.isNotEmpty
                  ? AppShowMoreText(text: desc, trimLines: 3)
                  : const SizedBox(),
              SizedBox(height: ten),
              !isParticipant
                  ? Padding(
                      padding: EdgeInsets.all(ten),
                      child: SizedBox(
                        width: double.infinity,
                        child: AppButton(label: 'Join', onTap: onJoin),
                      ),
                    )
                  : SizedBox(height: five),
            ],
          ),
        ),
      ),
    );
  }
}
