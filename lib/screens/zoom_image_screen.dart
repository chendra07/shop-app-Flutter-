import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../components/UI/app_bar.dart';

class ZoomImageScreen extends StatefulWidget {
  const ZoomImageScreen({Key key}) : super(key: key);

  @override
  State<ZoomImageScreen> createState() => _ZoomImageScreenState();
}

class _ZoomImageScreenState extends State<ZoomImageScreen> {
  bool updateIndexState = false;
  int indexKu = 0;

  final PreferredSizeWidget appBar = CustomAppBar.adaptiveAppBar(
    "",
    [],
  );

  @override
  Widget build(BuildContext context) {
    final listOfNetworkImage =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;

    //unpack arguments
    final List imageList = (listOfNetworkImage['imageList'] as List)
        .map((e) => e['imageUrl'])
        .toList();
    int currIndex = listOfNetworkImage['currentIndex'] as int;
    final PageController pageController =
        PageController(initialPage: currIndex);

    setState(() {
      if (!updateIndexState) {
        indexKu = currIndex;
        updateIndexState = true;
      }
    });

    return Scaffold(
      appBar: appBar,
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          PhotoViewGallery.builder(
            itemCount: imageList.length,
            pageController: pageController,
            builder: (context, index) {
              final urlImage = imageList[index];

              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(urlImage),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.contained * 4,
              );
            },
            onPageChanged: (index) => setState(() => indexKu = index),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Image ${indexKu + 1}/${imageList.length}",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
