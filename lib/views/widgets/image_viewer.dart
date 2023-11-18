import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../configs/colour_config.dart';
import '../../configs/consts.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return Center(
      child: Container(
        padding: EdgeInsets.all(twenty),
        margin: EdgeInsets.symmetric(horizontal: twenty),
        height: size * 10,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColourConfig.backgroundColour(brightness),
          borderRadius: BorderRadius.circular(forty),
          border: Border.all(
            width: five,
            color: ColourConfig.backgroundColour(brightness),
          ),
          image: DecorationImage(
            image: CachedNetworkImageProvider(image),
            fit: BoxFit.cover,
          ),
        ),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     CircleAvatar(
        //       radius: size * 4,
        //       backgroundImage: CachedNetworkImageProvider(image),
        //     ),
        //     height20,
        //     Text(
        //       name,
        //       style: TextStyle(
        //         fontSize: twenty,
        //         color: ColourConfig.foregroundColour(brightness),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
