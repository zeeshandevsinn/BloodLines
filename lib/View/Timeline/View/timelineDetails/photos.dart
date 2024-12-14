import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class TimelinePhotos extends StatelessWidget {
  TimelinePhotos({Key? key,required this.gallery}) : super(key: key);
  List<Gallery> gallery;

  @override
  Widget build(BuildContext context) {
    return GridView.custom(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        repeatPattern: QuiltedGridRepeatPattern.inverted,
        pattern: [
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(2, 2),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          // QuiltedGridTile(1, 1),
        ],
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        childCount: gallery.length,
        (context, index) => InkWell(
          onTap: () {
            Get.toNamed(Routes.photo,
                arguments: {"image": gallery[index].photo!,"type":"network"});
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: OptimizedCacheImage(
              imageUrl: gallery[index].photo!,
              fit: BoxFit.cover,
            )
          ),
        ),
      ),
    );
  }
}
