import 'package:basic_board/configs/consts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RoomInfoScreen extends StatelessWidget {
  static String id = 'room-info';
  const RoomInfoScreen({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: size * 8,
            // pinned: true,
            // floating: true,
            // snap: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(image, scale: 1.5),
                // child: Image.network(image),
              ),
              // background: Image(image: CachedNetworkImageProvider(image)),
            ),
          )
        ],
      ),
    );
  }
}
