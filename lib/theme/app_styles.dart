import 'package:flutter/material.dart';

class KTextStyle {
  static const TextStyle drawerEntryItemTitle = TextStyle(
    // fontWeight: FontWeight.w500,
    // color: Colors.grey.shade800,
  );
  static const TextStyle listExpandedValue = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );
  static const TextStyle listExpandedTitle = TextStyle(fontSize: 12);
  static const TextStyle listHeaderTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle listHeaderSubTitle = TextStyle(fontSize: 12);
  static const TextStyle listHeaderTimeTitle = TextStyle(fontSize: 10);
}

class KInputStyle {
  static final InputBorder inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
  );
  static final InputBorder focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
  );
  static final InputBorder enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
  );
}

class KCardStyle {
  static final EdgeInsets cardPadding = EdgeInsets.all(8);
  static final EdgeInsets dashboardCardPadding = EdgeInsets.all(12);
}

class KBottomSheetStyle {
  static final shape = RoundedRectangleBorder(
    borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(10)),
  );
}

class KListStyle {
  static final int lightAlphaIntensity = 20;
  static final int darkAlphaIntensity = 55;
  static final int lightAlphaIntensityTitle = 220;
  static final int darkAlphaIntensityTitle = 170;
}

class KDivider {
  static final Divider sectionDivider = Divider(
    height: 1,
    thickness: 1,
    indent: 10,
    endIndent: 10,
  );
  static final Divider listDivider = Divider(
    height: 1,
    thickness: 1,
    indent: 10,
    endIndent: 10,
  );
}

// class KTextField {
//   static OutlineInputBorder focusedBorder = OutlineInputBorder(
//     borderRadius: BorderRadius.circular(10),
//     borderSide: BorderSide(color: Colors.grey),
//   );
//   enabledBorder: OutlineInputBorder(
//     borderRadius: BorderRadius.circular(10),
//     borderSide: BorderSide(color: Colors.grey),
//   ),
// }
