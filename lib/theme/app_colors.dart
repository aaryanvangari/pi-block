import 'package:flutter/material.dart';

class KColors {
  static const welcomeScreenBackground = Color(0xFF8198d3);
  static const newVersion = Colors.green;
  static const snackbarDivider = Colors.grey;
  static const transparent = Colors.transparent;
  static const flutterSwitch = Colors.green;
  static const deny = Colors.red;
  static const block = Colors.red;
  static const allow = Colors.green;
  static const download = Colors.green;
  static const switchOn = Colors.green;
  static const switchOff = Colors.grey;
  static const blockingTimesTitles = Colors.white;
  static const systemLoadLow = Colors.green;
  static const systemLoadMedium = Colors.orange;
  static const systemLoadHigh = Colors.red;
  static const links = Colors.blue;

  /// Dynamic colors
  static Color welcomeCircle1 = Colors.white.withAlpha(10);
  static Color welcomeCircle2 = Colors.white.withAlpha(15);
  static Color welcomeCircle3 = Colors.white.withAlpha(20);
  static Color welcomeCircle4 = Colors.white.withAlpha(30);
  static Color linearProgressbarBackground = Colors.grey.withAlpha(40);
  static Color listHeaderTitleAllowDark = Colors.green.withAlpha(200);
  static Color listHeaderTitleAllowLight = Colors.green.withAlpha(220);
  static Color listHeaderTitleBlockDark = Colors.red.withAlpha(170);
  static Color listHeaderTitleBlockLight = Colors.red.withAlpha(220);
}

class KProgressBarColors {
  static const Color blocked = Color(0xFFb00000);
  static const Color permitted = Color(0xFF00a65a);
}

class KBarChartQueryColors {
  static const Color blocked = Color(0xFFD35148);
  static const Color cached = Color(0xFF23B0F1);
  static const Color forwarded = Color(0xFFA0CD6D);
  static const Color others = Colors.grey;
}

class KSummaryStatsColors {
  static const Color totalQueries = Color(0xFF00c0ef);
  static const Color queriesBlocked = Color(0xFFdd4b39);
  static const Color percentBlocked = Color(0xFFf39c12);
  static const Color domainsOnList = Color(0xFF00a65a);
  static const summaryStatIcons = Colors.white;
}

class KBarChartColors {
  /// Colors for Light Backgrounds
  static const Map<String, Color> lightBackgroundColors = {
    'blue': Color(0xFF1F77B4),
    'orange': Color(0xFFFF7F0E),
    'green': Color(0xFF2CA02C),
    'red': Color(0xFFD62728),
    'purple': Color(0xFF9467BD),
    'brown': Color(0xFF8C564B),
    'pink': Color(0xFFE377C2),
    'gray': Color(0xFF7F7F7F),
    'olive': Color(0xFFBCBD22),
    'cyan': Color(0xFF17BECF),
    'darkBlue': Color(0xFF393B79),
    'darkGreen': Color(0xFF637939),
    'darkBrown': Color(0xFF8C6D31),
    'darkRed': Color(0xFF843C39),
    'darkPurple': Color(0xFF7B4173),
    'mediumBlue': Color(0xFF3182BD),
    'mediumGreen': Color(0xFF31A354),
    'mediumPurple': Color(0xFF756BB1),
    'brightOrange': Color(0xFFE6550D),
    'burntOrange': Color(0xFFD94801),
    'lightBlue': Color(0xFF6BAED6),
    'lavender': Color(0xFF9E9AC8),
    'peach': Color(0xFFFDD0A2),
    'salmon': Color(0xFFFC9272),
    'lightGreen': Color(0xFFA1D99B),
    'skyBlue': Color(0xFFBFD3E6),
    'sand': Color(0xFFE7CB94),
    'yellow': Color(0xFFFCCE6F),
    'nearWhite': Color(0xFFF7F7F7),
    'darkGray': Color(0xFF636363),
  };

  /// Colors for Dark Backgrounds
  static const Map<String, Color> darkBackgroundColors = {
    'blue': Color(0xFF4E79A7),
    'orange': Color(0xFFFFB347),
    'green': Color(0xFF76B041),
    'red': Color(0xFFEF5350),
    'purple': Color(0xFF9C7AC3),
    'brown': Color(0xFFA6786D),
    'pink': Color(0xFFE991D0),
    'gray': Color(0xFFB0B0B0),
    'olive': Color(0xFFD7D738),
    'cyan': Color(0xFF3BCFCF),
    'darkBlue': Color(0xFF5A5FA8),
    'darkGreen': Color(0xFF7AA663),
    'darkBrown': Color(0xFFB07A4A),
    'darkRed': Color(0xFFB25A5A),
    'darkPurple': Color(0xFF935AA8),
    'mediumBlue': Color(0xFF5392D6),
    'mediumGreen': Color(0xFF56B67B),
    'mediumPurple': Color(0xFF8C75C1),
    'brightOrange': Color(0xFFFF863D),
    'burntOrange': Color(0xFFE36B3D),
    'lightBlue': Color(0xFF86B9E7),
    'lavender': Color(0xFFC0B3E0),
    'peach': Color(0xFFFFD7B0),
    'salmon': Color(0xFFFFB0A3),
    'lightGreen': Color(0xFFB8E4A7),
    'skyBlue': Color(0xFFC0DDF0),
    'sand': Color(0xFFEFDAB3),
    'yellow': Color(0xFFFFE57F),
    'nearWhite': Color(0xFFEAEAEA),
    'darkGray': Color(0xFF8C8C8C),
  };
}

class KQueryLogColors {
  static const Map<String, Color> queryStatusColors = {
    "red": Color(0xFFFF0000),
    "green": Color(0xFF008000),
    "orange": Color(0xFFffa500),
  };
  static Map<String, dynamic> queryLogColors = {
    "red": {
      "light": Colors.red.withAlpha(220),
      "dark": Colors.red.withAlpha(170),
    },
    "green": {
      "light": Colors.green.withAlpha(220),
      "dark": Colors.green.withAlpha(200),
    },
    "orange": {
      "light": Colors.orange.withAlpha(220),
      "dark": Colors.orange.withAlpha(170),
    },
  };
}

class KLogsColors {
  static const Color info = Colors.green;
  static const Color warning = Colors.orange;
  static const Color error = Colors.red;
}
