import 'package:flutter/material.dart';
import 'package:basic_board/configs/sizes.dart';

double size = Sizes.defaultSize!;

double five = size - 31;
double ten = size - 26;
double twenty = size - 16;
double thirty = size - 6;
double forty = size + 4;

int animationDuration = 500;

SizedBox height40 = SizedBox(height: forty);
SizedBox height30 = SizedBox(height: thirty);
SizedBox height20 = SizedBox(height: twenty);
SizedBox height10 = SizedBox(height: ten);
SizedBox height5 = SizedBox(height: five);

BorderRadius defaultBorderRadius = BorderRadius.circular(five);
