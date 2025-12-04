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
  static final Map<String, dynamic> queryStatus = {
    "GRAVITY": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (gravity)",
      "blocked": true,
    },
    "FORWARDED": {
      "color": queryStatusColors["green"],
      "icon": FontAwesomeIcons.cloudArrowDown,
      "fieldtext": '',
    },
    "CACHE": {
      "color": queryStatusColors["green"],
      "icon": FontAwesomeIcons.database,
      "fieldtext": "Served from cache",
    },
    "REGEX": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (regex)",
      "blocked": true,
    },
    "DENYLIST": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (exact)",
      "blocked": true,
    },
    "EXTERNAL_BLOCKED_IP": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (external, IP)",
      "blocked": true,
    },
    "EXTERNAL_BLOCKED_NULL": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (external, NULL)",
      "blocked": true,
    },
    "EXTERNAL_BLOCKED_NXRA": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (external, NXRA)",
      "blocked": true,
    },
    "QUERY_EXTERNAL_BLOCKED_EDE15": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (external, EDE15)",
      "blocked": true,
    },
    "GRAVITY_CNAME": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (gravity, CNAME)",
      "isCNAME": true,
      "blocked": true,
    },
    "REGEX_CNAME": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (regex denied, CNAME)",
      "isCNAME": true,
      "blocked": true,
    },
    "DENYLIST_CNAME": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (exact denied, CNAME)",
      "isCNAME": true,
      "blocked": true,
    },
    "RETRIED": {
      "color": queryStatusColors["green"],
      "icon": FontAwesomeIcons.arrowRotateRight, // fa-repeat
      "fieldtext": "Retried",
    },
    "RETRIED_DNSSEC": {
      "color": queryStatusColors["green"],
      "icon": FontAwesomeIcons.arrowRotateRight, // fa-repeat
      "fieldtext": "Retried (ignored)",
    },
    "IN_PROGRESS": {
      "color": queryStatusColors["green"],
      "icon": FontAwesomeIcons.hourglassHalf,
      "fieldtext": "Already forwarded, awaiting reply",
    },
    "CACHE_STALE": {
      "color": queryStatusColors["green"],
      "icon": FontAwesomeIcons.infinity,
      "fieldtext": "Served by cache optimizer",
    },
    "SPECIAL_DOMAIN": {
      "color": queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "",
      "blocked": true,
    },
    "default": {
      "color": queryStatusColors["orange"],
      "icon": FontAwesomeIcons.question,
      "fieldtext": "",
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

class KListStyle {
  static final int lightAlphaIntensity = 20;
  static final int darkAlphaIntensity = 55;
  static final Divider listDivider = Divider(
    height: 2,
    thickness: 1,
    indent: 10,
    endIndent: 10,
    color: Colors.transparent,
    radius: BorderRadius.circular(15),
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

class KUrls {
  static const String base = "/api";
  static const String auth = '$base/auth';
  static const String queryTypes = '$base/stats/query_types';
  static const String upStreams = '$base/stats/upstreams';
  static const String topDomains = '$base/stats/top_domains';
  static const String domains = '$base/domains';
  static const String clients = '$base/stats/top_clients';
  static const String queries = '$base/queries';
  static const String config = '$base/config';
  static const String messages = '$base/info/messages';
  static const String messagesCount = '$base/info/messages/count';
  static const String lists = '$base/lists';
  static const String dns = '$base/dns/blocking';
  static const String summary = '$base/stats/summary';
  static const String system = '$base/info/system';
  static const String hosts = '$base/info/host';
  static const String versions = '$base/info/version';
}
