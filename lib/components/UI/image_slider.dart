import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
// import 'package:url_launcher/url_launcher.dart';

//routes
import '../../routes/routes_config.dart';

enum Mode { number, dots }

class ImageSlider extends StatefulWidget {
  final List<Map<String, Object>> imageNetworkList;
  final double heightPct;
  final double viewPortFraction; //recommended value: 0.8 - 1
  final bool isAutoPlay;
  final Mode mode;

  const ImageSlider({
    Key key,
    @required this.imageNetworkList,
    @required this.heightPct,
    @required this.mode,
    this.viewPortFraction = 1,
    this.isAutoPlay = false,
  }) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

Widget pageNumBuilder({Mode mode, int length, int activeIndex}) {
  switch (mode) {
    case Mode.number:
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(106, 0, 0, 0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        child: Text(
          '${activeIndex + 1}/$length',
          style: const TextStyle(color: Colors.white),
        ),
      );
      break;
    case Mode.dots:
      return CarouselIndicator(
        count: length,
        index: activeIndex,
        color: const Color.fromARGB(106, 158, 158, 158),
        cornerRadius: 30,
        activeColor: const Color.fromARGB(174, 195, 51, 220),
        animationDuration: 0,
        height: 15,
        width: 15,
        space: 10,
      );
      break;
    default:
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(106, 0, 0, 0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        child: const Text(
          'Error',
          style: TextStyle(color: Colors.white),
        ),
      );
      break;
  }
}

class _ImageSliderState extends State<ImageSlider> {
  int activeIndex = 0;
  List imageNetworkList = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: widget.mode == Mode.dots
          ? Alignment.bottomCenter
          : Alignment.bottomLeft,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: widget.heightPct,
            viewportFraction: widget.viewPortFraction,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            autoPlay: widget.isAutoPlay,
            onPageChanged: (index, reason) =>
                setState(() => activeIndex = index),
          ),
          items: widget.imageNetworkList.map((image) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  // margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: GestureDetector(
                    // ignore: avoid_print
                    onTap: image['action'] ??
                        () => Navigator.of(context).pushNamed(
                              RoutesConfig.zoomImageScreen,
                              arguments: {
                                'imageList': widget.imageNetworkList,
                                'currentIndex': activeIndex,
                              },
                            ),
                    // : () async {
                    //     final Uri url =
                    //         Uri.tryParse(image['link'] as String);
                    //     if (await canLaunchUrl(url)) {
                    //       await launchUrl(url);
                    //     }
                    //   },
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/fading_circles.gif",
                      image: image['imageUrl'],
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        pageNumBuilder(
          mode: widget.mode,
          activeIndex: activeIndex,
          length: widget.imageNetworkList.length,
        ),
      ],
    );
  }
}
