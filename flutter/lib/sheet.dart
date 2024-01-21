import 'dart:ui';

import 'package:flutter/material.dart';

class Sheet extends StatefulWidget {
  const Sheet({super.key});

  @override
  State<Sheet> createState() => _SheetState();
}

class _SheetState extends State<Sheet> {
  double minChild = 0.5;
  double maxChild = 0.85;
  double blurX = 0.0;
  double blurY = 0.0;
  double opa = 1.0;
  late double diff;

  @override
  void initState() {
    super.initState();
    diff = maxChild - minChild;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox.expand(
            child: Stack(children: [
      Stack(alignment: Alignment.center, children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5 + 32,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: blurX,
              sigmaY: blurY,
            ),
            child: Image.asset(
              'assets/forest.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          left: 32,
          top: 32,
          child: CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: const Icon(Icons.chevron_left),
          ),
        ),
        Opacity(
          opacity: opa,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: Colors.blue[100]!.withOpacity(0.7)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: blurX, sigmaY: blurY),
                  child: const Text(
                    'The Shire',
                    style: TextStyle(color: Colors.black, fontSize: 32),
                  ),
                ),
              )),
        ),
        Positioned(
            left: 16,
            bottom: 36,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: blurX,
                sigmaY: blurY,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Calgary',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'mike@email.com',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            )),
      ]),
      NotificationListener<DraggableScrollableNotification>(
        onNotification: (notification) {
          var p = notification.extent - 0.5;
          // Blur the image and the contents of the header in
          // proportion to the user scrolling the DraggableScrollableSheet
          setState(() {
            blurX = 16 * p;
            blurY = 16 * p;
            opa = 1 - p / diff;
          });

          return true;
        },
        child: DraggableScrollableSheet(
          minChildSize: minChild,
          maxChildSize: maxChild,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32))),
              child: ListView.builder(
                controller: scrollController,
                itemCount: 25,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(title: Text('Item $index'));
                },
              ),
            );
          },
        ),
      )
    ])));
  }
}
