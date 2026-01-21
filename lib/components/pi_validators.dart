import 'package:validators/validators.dart' as validators;

class PiValidators {
  dynamic apiTokenValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "API token is required";
    }
    if (!validators.isLength(value, 5)) {
      return ("API token can be minimum of 5 characters long.");
    }
    return null;
  }

  dynamic serverUrlValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Server URL is required";
    }
    if (!validators.isURL(value)) {
      return "Invalid URL";
    }
    return null;
  }

  dynamic commentValidator(String? value) {
    if (!validators.isLength(value ?? "", 0, 100)) {
      return ("Comment can be max 100 characters.");
    }
    return null;
  }

  dynamic addressValidator(String? value) {
    if (!validators.isURL(value)) {
      return "Invalid URL";
    }
    return null;
  }

  dynamic domainValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Domain is required";
    }
    if (!validators.isFQDN(value)) {
      return "Invalid Domain";
    }
    return null;
  }

  dynamic groupValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Group is required";
    }
    if (!validators.isLength(value, 0, 50)) {
      return "Group can be max 50 characters.";
    }
    return null;
  }

  dynamic clientValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Client is required";
    }

    /// #TODO client validation
    // if (!validators.isFQDN(value)) {
    //   return "Invalid Client";
    // }
    return null;
  }
}
