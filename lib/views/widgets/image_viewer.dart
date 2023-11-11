import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../configs/colour_config.dart';
import '../../configs/consts.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key, required this.image, required this.name});
  final String image, name;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return Center(
      child: Container(
        padding: EdgeInsets.all(twenty),
        decoration: BoxDecoration(
          color: ColourConfig.backgroundColour(brightness),
          borderRadius: BorderRadius.circular(forty),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: size * 4,
              backgroundImage: CachedNetworkImageProvider(image),
            ),
            height20,
            Text(
              name,
              style: TextStyle(
                fontSize: twenty,
                color: ColourConfig.foregroundColour(brightness),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
