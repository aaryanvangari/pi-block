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
