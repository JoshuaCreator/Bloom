import 'package:flutter/material.dart';
import 'package:basic_board/configs/sizes.dart';

double size = Sizes.defaultSize!;

double five = size - 31;
double ten = size - 26;
double twenty = size - 16;
double thirty = size - 6;
double forty = size + 4;

int animationDuration = 500;
double circularAvatarRadius = twenty + five;

SizedBox height40 = SizedBox(height: forty);
SizedBox height30 = SizedBox(height: thirty);
SizedBox height20 = SizedBox(height: twenty);
SizedBox height10 = SizedBox(height: ten);
SizedBox height5 = SizedBox(height: five);

BorderRadius defaultBorderRadius = BorderRadius.circular(five);

BorderRadius myBorderRadius = BorderRadius.only(
  topLeft: Radius.circular(twenty),
  bottomLeft: Radius.circular(twenty),
  bottomRight: Radius.circular(twenty),
);

BorderRadius yourBorderRadius = BorderRadius.only(
  topRight: Radius.circular(twenty),
  bottomLeft: Radius.circular(twenty),
  bottomRight: Radius.circular(twenty),
);

const String defaultRoomImg =
    'https://images.pexels.com/photos/919278/pexels-photo-919278.jpeg';
