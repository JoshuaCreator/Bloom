import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../configs/colour_config.dart';
import '../../../../configs/consts.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.studentId,
    required this.name,
    required this.intake,
    required this.image,
    this.onTap,
  });
  final String studentId, name, intake, image;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: defaultBorderRadius,
      child: Ink(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: ColourConfig.white,
          borderRadius: defaultBorderRadius,
          boxShadow: [
            BoxShadow(
              color: ColourConfig.lightGrey.withOpacity(0.2),
              spreadRadius: 2.0,
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: size,
                  backgroundImage: CachedNetworkImageProvider(image),
                ),
                const Gap(10.0),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: ColourConfig.black,
                      ),
                    ),
                    Text(intake, style: TextStyle(color: ColourConfig.black)),
                  ],
                ),
              ],
            ),
            Flexible(
              child: QrImageView(
                data: studentId,
                backgroundColor: ColourConfig.white,
                size: size * 2,
                gapless: true,
                padding: const EdgeInsets.all(5.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
