import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../configs/colour_config.dart';
import '../../configs/consts.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key, required this.image, this.onInfoIconPressed});
  final String image;
  final void Function()? onInfoIconPressed;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return Center(
      child: Container(
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
        child: onInfoIconPressed == null
            ? null
            : Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(thirty),
                        bottomLeft: Radius.circular(ten),
                      ),
                    ),
                    child: IconButton(
                      onPressed: onInfoIconPressed,
                      icon: const Icon(Icons.info_outline_rounded),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
