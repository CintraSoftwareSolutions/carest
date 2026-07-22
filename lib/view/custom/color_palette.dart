// import 'package:flutter/material.dart';

// class ColorPalette extends StatelessWidget {
//   const ColorPalette({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Define the color palette
//     final List<Color> colors = [
//       Colors.red,
//       Colors.orange,
//       Colors.yellow,
//       Colors.purple,
//       Colors.pink,
//       Colors.brown.shade300,
//       Colors.lime,
//       Colors.brown,
//       Colors.blueGrey.shade900,
//       Colors.deepPurple,
//       Colors.green.shade700,
//       Colors.teal,
//     ];

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // Top row of colors
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: colors.sublist(0, 7).map((color) {
//             return Container(
//               margin: const EdgeInsets.all(4),
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: color,
//                 shape: BoxShape.circle,
//               ),
//             );
//           }).toList(),
//         ),
//         // Bottom row of colors
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: colors.sublist(7).map((color) {
//             return Container(
//               margin: const EdgeInsets.all(4),
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: color,
//                 shape: BoxShape.circle,
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class ColorPaletteWidget extends StatelessWidget {
  final List<Color> colors;

  const ColorPaletteWidget({
    super.key,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Top row of colors
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: colors.sublist(0, 8).map((color) {
            return Container(
              margin: const EdgeInsets.all(4),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            );
          }).toList(),
        ),
        // Bottom row of colors
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: colors.sublist(8).map((color) {
            return Container(
              margin: const EdgeInsets.all(4),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
