import 'package:flutter/material.dart';

class ScrollWidget extends StatefulWidget {
  const ScrollWidget({super.key});

  @override
  State<ScrollWidget> createState() => _ScrollWidgetState();
}

// The scroll widget is used with a ListView.builder to
// display a list of items that are discovered by scrolling
// horizontally. This is also achieved by PageView with a
// screen width percentage however this implementation has
// better, smoother scrolling without clipping each item
// when the user swipes and scrolls.
class _ScrollWidgetState extends State<ScrollWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(
      children: [
        SizedBox(
          // The height of this scrollable list is 20%
          // the width of the screen. This can be an arbitrary
          // value however it should be chosen to be sufficiently
          // large as to avoid making the items too compact,
          // to avoid clutter and visual inconsistency.
          height: MediaQuery.of(context).size.height * 0.2,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 25,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                  width: MediaQuery.of(context).size.width - 200,
                  child: ListTile(title: Text('Item $index')));
            },
          ),
        ),
        // This is another list but this section can be replaced with any
        // widget based on your app's design.
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 25,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  child: ListTile(title: Text('Item $index')));
            },
          ),
        ),
      ],
    )));
  }
}
