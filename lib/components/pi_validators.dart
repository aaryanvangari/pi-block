import 'package:validators/validators.dart' as validators;

class PiValidators {
  apiTokenValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "API token is required";
    }
    if (!validators.isLength(value, 5)) {
      return ("API token is short. Consider changing it.");
    }
    return null;
  }

  serverUrlValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Server URL is required";
    }
    if (!validators.isURL(value)) {
      return "Invalid URL";
    }
    return null;
  }
}
