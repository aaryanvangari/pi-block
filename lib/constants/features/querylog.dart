import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pi_block/theme/app_colors.dart';

class QuerylogConstants {
  static final Map<String, dynamic> queryStatus = {
    "GRAVITY": {
      "color": KQueryLogColors.queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (gravity)",
      "blocked": true,
      "colorName": "red",
    },
    "FORWARDED": {
      "color": KQueryLogColors.queryStatusColors["green"],
      "icon": FontAwesomeIcons.cloudArrowDown,
      "fieldtext": '',
      "colorName": "green",
    },
    "CACHE": {
      "color": KQueryLogColors.queryStatusColors["green"],
      "icon": FontAwesomeIcons.database,
      "fieldtext": "Served from cache",
      "colorName": "green",
    },
    "REGEX": {
      "color": KQueryLogColors.queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (regex)",
      "blocked": true,
      "colorName": "red",
    },
    "DENYLIST": {
      "color": KQueryLogColors.queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (exact)",
      "blocked": true,
      "colorName": "red",
    },
    "EXTERNAL_BLOCKED_IP": {
      "color": KQueryLogColors.queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (external, IP)",
      "blocked": true,
      "colorName": "red",
    },
    "EXTERNAL_BLOCKED_NULL": {
      "color": KQueryLogColors.queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (external, NULL)",
      "blocked": true,
      "colorName": "red",
    },
    "EXTERNAL_BLOCKED_NXRA": {
      "color": KQueryLogColors.queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (external, NXRA)",
      "blocked": true,
      "colorName": "red",
    },
    "QUERY_EXTERNAL_BLOCKED_EDE15": {
      "color": KQueryLogColors.queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (external, EDE15)",
      "blocked": true,
      "colorName": "red",
    },
    "GRAVITY_CNAME": {
      "color": KQueryLogColors.queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (gravity, CNAME)",
      "isCNAME": true,
      "blocked": true,
      "colorName": "red",
    },
    "REGEX_CNAME": {
      "color": KQueryLogColors.queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (regex denied, CNAME)",
      "isCNAME": true,
      "blocked": true,
      "colorName": "red",
    },
    "DENYLIST_CNAME": {
      "color": KQueryLogColors.queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "Blocked (exact denied, CNAME)",
      "isCNAME": true,
      "blocked": true,
      "colorName": "red",
    },
    "RETRIED": {
      "color": KQueryLogColors.queryStatusColors["green"],
      "icon": FontAwesomeIcons.arrowRotateRight, // fa-repeat
      "fieldtext": "Retried",
      "colorName": "green",
    },
    "RETRIED_DNSSEC": {
      "color": KQueryLogColors.queryStatusColors["green"],
      "icon": FontAwesomeIcons.arrowRotateRight, // fa-repeat
      "fieldtext": "Retried (ignored)",
      "colorName": "green",
    },
    "IN_PROGRESS": {
      "color": KQueryLogColors.queryStatusColors["green"],
      "icon": FontAwesomeIcons.hourglassHalf,
      "fieldtext": "Already forwarded, awaiting reply",
      "colorName": "green",
    },
    "CACHE_STALE": {
      "color": KQueryLogColors.queryStatusColors["green"],
      "icon": FontAwesomeIcons.infinity,
      "fieldtext": "Served by cache optimizer",
      "colorName": "green",
    },
    "SPECIAL_DOMAIN": {
      "color": KQueryLogColors.queryStatusColors["red"],
      "icon": FontAwesomeIcons.ban,
      "fieldtext": "",
      "blocked": true,
      "colorName": "red",
    },
    "default": {
      "color": KQueryLogColors.queryStatusColors["orange"],
      "icon": FontAwesomeIcons.question,
      "fieldtext": "",
      "colorName": "orange",
    },
  };
}
