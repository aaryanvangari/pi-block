import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class KConstants {
  static const String themeModeKey = "isDarkKey";
  static const String blockingTimer = "blockingTimer";
  static const String blockingTimerAddedAt = "blockingTimerAddedAt";
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
  static final Divider sectionDivider = Divider(
    height: 1,
    thickness: 1,
    indent: 10,
    endIndent: 10,
  );
  static final Map<String, dynamic> queryStatus = {
    "GRAVITY": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (gravity)",
      "blocked": true,
      "colorName": "red",
    },
    "FORWARDED": {
      "color": queryStatusColors["green"],
      "icon": FontAwesomeIcons.cloudArrowDown,
      "fieldtext": '',
      "colorName": "green",
    },
    "CACHE": {
      "color": queryStatusColors["green"],
      "icon": FontAwesomeIcons.database,
      "fieldtext": "Served from cache",
      "colorName": "green",
    },
    "REGEX": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (regex)",
      "blocked": true,
      "colorName": "red",
    },
    "DENYLIST": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (exact)",
      "blocked": true,
      "colorName": "red",
    },
    "EXTERNAL_BLOCKED_IP": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (external, IP)",
      "blocked": true,
      "colorName": "red",
    },
    "EXTERNAL_BLOCKED_NULL": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (external, NULL)",
      "blocked": true,
      "colorName": "red",
    },
    "EXTERNAL_BLOCKED_NXRA": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (external, NXRA)",
      "blocked": true,
      "colorName": "red",
    },
    "QUERY_EXTERNAL_BLOCKED_EDE15": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (external, EDE15)",
      "blocked": true,
      "colorName": "red",
    },
    "GRAVITY_CNAME": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (gravity, CNAME)",
      "isCNAME": true,
      "blocked": true,
      "colorName": "red",
    },
    "REGEX_CNAME": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (regex denied, CNAME)",
      "isCNAME": true,
      "blocked": true,
      "colorName": "red",
    },
    "DENYLIST_CNAME": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (exact denied, CNAME)",
      "isCNAME": true,
      "blocked": true,
      "colorName": "red",
    },
    "RETRIED": {
      "color": queryStatusColors["green"],
      "icon": FontAwesomeIcons.arrowRotateRight, // fa-repeat
      "fieldtext": "Retried",
      "colorName": "green",
    },
    "RETRIED_DNSSEC": {
      "color": queryStatusColors["green"],
      "icon": FontAwesomeIcons.arrowRotateRight, // fa-repeat
      "fieldtext": "Retried (ignored)",
      "colorName": "green",
    },
    "IN_PROGRESS": {
      "color": queryStatusColors["green"],
      "icon": FontAwesomeIcons.hourglassHalf,
      "fieldtext": "Already forwarded, awaiting reply",
      "colorName": "green",
    },
    "CACHE_STALE": {
      "color": queryStatusColors["green"],
      "icon": FontAwesomeIcons.infinity,
      "fieldtext": "Served by cache optimizer",
      "colorName": "green",
    },
    "SPECIAL_DOMAIN": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "",
      "blocked": true,
      "colorName": "red",
    },
    "default": {
      "color": queryStatusColors["orange"],
      "icon": FontAwesomeIcons.question,
      "fieldtext": "",
      "colorName": "orange",
    },
  };
}

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
  static final Divider listDivider = Divider(
    height: 1,
    thickness: 1,
    indent: 10,
    endIndent: 10,
  );
  static const Map<String, Color> listHeaderBackgroundColors = {
    "red": Color(0xFFFF0000),
    "green": Color(0xFF008000),
    "orange": Color(0xFFffa500),
  };
}

class KColors {
  static const List<String> colorSwatches = [
    "#fecd10",
    "#4c8fb9",
    "#968a05",
    "#f79188",
    "#f1057e",
    "#89147c",
    "#f144f0",
    "#bb41b5",
    "#7e4c80",
    "#e6100b",
    "#41cde1",
    "#b3e5b8",
    "#3bc6a6",
    "#9fd85f",
    "#9951ac",
    "#1aa6d6",
    "#d802ac",
    "#3aa2d3",
    "#ab6dac",
    "#b6e312",
  ];
  static const newVersion = Colors.green;
}

class KTimers {
  static const snackbarError = 5;
  static const snackbarInfo = 5;
  static const summary = 15;
  static const system = 15;
  static const session = 1;
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

class PiholeUrls {
  static const update = 'https://discourse.pi-hole.net/c/announcements/5';
  static const core = 'https://github.com/pi-hole/pi-hole/releases';
  static const web = 'https://github.com/pi-hole/web/releases';
  static const ftl = 'https://github.com/pi-hole/FTL/releases';
  static const docker = "https://github.com/pi-hole/docker-pi-hole/releases";
}

class KUrls {
  static const String base = "/api";
  static const String auth = '$base/auth';
  static const String queryTypes = '$base/stats/query_types';
  static const String upStreams = '$base/stats/upstreams';
  static const String topDomains = '$base/stats/top_domains';
  static const String domains = '$base/domains';
  static const String domainsDelete = '$base/domains:batchDelete';
  static const String clients = '$base/stats/top_clients';
  static const String queries = '$base/queries';
  static const String config = '$base/config';
  static const String messages = '$base/info/messages';
  static const String messagesCount = '$base/info/messages/count';
  static const String lists = '$base/lists';
  static const String listsDelete = '$base/lists:batchDelete';
  static const String dns = '$base/dns/blocking';
  static const String summary = '$base/stats/summary';
  static const String system = '$base/info/system';
  static const String hosts = '$base/info/host';
  static const String versions = '$base/info/version';
  static const String history = '$base/history';
  static const String clientsHistory = '$base/history/clients';
}
