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

BorderRadius defaultBorderRadius = BorderRadius.circular(ten);

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

const String defaultRoomImgPath =
    'https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg';

const String defaultSpaceImgPath =
    'https://images.pexels.com/photos/2387877/pexels-photo-2387877.jpeg';

const String defaultUserImgPath =
    'https://images.pexels.com/photos/60579/pexels-photo-60579.jpeg';
