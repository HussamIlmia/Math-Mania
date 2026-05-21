import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/src/ui/magicTriangle/magic_triangle_provider.dart';
import '/src/ui/magicTriangle/triangle_input_button.dart';
import 'package:provider/provider.dart';
import '/src/utility/tuple.dart';

class Triangle4x4 extends StatelessWidget {
  final double radius;
  final double padding;
  final double triangleHeight;
  final double triangleWidth;
  final Tuple2<Color, Color> colorTuple;

  const Triangle4x4({
    super.key,
    required this.radius,
    required this.padding,
    required this.triangleHeight,
    required this.triangleWidth,
    required this.colorTuple,
  });

  @override
  Widget build(BuildContext context) {
    final magicTriangleProvider = Provider.of<MagicTriangleProvider>(context);
    return SizedBox(
      width: triangleWidth,
      height: triangleHeight,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: padding,
            left: triangleWidth / 2 - radius,
            height: (radius * 2),
            width: (radius * 2),
            child: TriangleInputButton(
              input: magicTriangleProvider.currentState.listTriangle[0],
              index: 0,
              colorTuple: colorTuple,
            ),
          ), // first
          Positioned(
            top: (triangleHeight - ((radius + padding) * 2)) / 3 + padding,
            left: (triangleWidth - ((radius + padding) * 2)) / 3 + padding,
            height: (radius * 2),
            width: (radius * 2),
            child: TriangleInputButton(
              input: magicTriangleProvider.currentState.listTriangle[1],
              index: 1,
              colorTuple: colorTuple,
            ),
          ), // second one
          Positioned(
            top: (triangleHeight - ((radius + padding) * 2)) / 3 + padding,
            right: (triangleWidth - ((radius + padding) * 2)) / 3 + padding,
            height: (radius * 2),
            width: (radius * 2),
            child: TriangleInputButton(
              input: magicTriangleProvider.currentState.listTriangle[2],
              index: 2,
              colorTuple: colorTuple,
            ),
          ), // third
          Positioned(
            bottom: (triangleHeight - ((radius + padding) * 2)) / 3 + padding,
            left: (triangleWidth - ((radius + padding) * 2)) / 6 + padding,
            height: (radius * 2),
            width: (radius * 2),
            child: TriangleInputButton(
              input: magicTriangleProvider.currentState.listTriangle[3],
              index: 3,
              colorTuple: colorTuple,
            ),
          ), // fourth one
          Positioned(
            bottom: (triangleHeight - ((radius + padding) * 2)) / 3 + padding,
            right: (triangleWidth - ((radius + padding) * 2)) / 6 + padding,
            height: (radius * 2),
            width: (radius * 2),
            child: TriangleInputButton(
              input: magicTriangleProvider.currentState.listTriangle[4],
              index: 4,
              colorTuple: colorTuple,
            ),
          ), // fifth
          Positioned(
            bottom: padding,
            left: padding,
            height: (radius * 2),
            width: (radius * 2),
            child: TriangleInputButton(
              input: magicTriangleProvider.currentState.listTriangle[5],
              index: 5,
              colorTuple: colorTuple,
            ),
          ), // fourth
          Positioned(
            bottom: padding,
            left: (triangleWidth - ((radius + padding) * 2)) / 3 + padding,
            height: (radius * 2),
            width: (radius * 2),
            child: TriangleInputButton(
              input: magicTriangleProvider.currentState.listTriangle[6],
              index: 6,
              colorTuple: colorTuple,
            ),
          ), // sixth
          Positioned(
            bottom: padding,
            right: (triangleWidth - ((radius + padding) * 2)) / 3 + padding,
            height: (radius * 2),
            width: (radius * 2),
            child: TriangleInputButton(
              input: magicTriangleProvider.currentState.listTriangle[7],
              index: 7,
              colorTuple: colorTuple,
            ),
          ), // seventh
          Positioned(
            bottom: padding,
            right: padding,
            height: (radius * 2),
            width: (radius * 2),
            child: TriangleInputButton(
              input: magicTriangleProvider.currentState.listTriangle[8],
              index: 8,
              colorTuple: colorTuple,
            ),
          ), //ninth
        ],
      ),
    );
  }
}
