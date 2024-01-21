import 'package:flutter/material.dart';

@immutable
class ExampleDragAndDrop extends StatefulWidget {
  const ExampleDragAndDrop({super.key});

  @override
  State<ExampleDragAndDrop> createState() => _ExampleDragAndDropState();
}

class _ExampleDragAndDropState extends State<ExampleDragAndDrop> {
  var angle = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        SafeArea(
          child: _buildMenuItem(),
        ),
      ],
    );
  }

  Widget _buildMenuItem() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Draggable(
                  dragAnchorStrategy: childDragAnchorStrategy,
                  feedback: Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    color: Colors.orange,
                  ),
                  childWhenDragging: Container(),
                  child: Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    color: Colors.orange,
                  ),
                );
              },
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Draggable(
                  dragAnchorStrategy: childDragAnchorStrategy,
                  feedback: Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    color: Colors.green,
                  ),
                  childWhenDragging: Container(),
                  child: Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    color: Colors.green,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
