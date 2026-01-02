import 'package:validators/validators.dart' as validators;

class PiValidators {
  apiTokenValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "API token is required";
    }
    if (!validators.isLength(value, 5)) {
      return ("API token can be minimum of 5 characters long.");
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

  commentValidator(String? value) {
    if (!validators.isLength(value ?? "", 0, 100)) {
      return ("Comment can be max 100 characters.");
    }
    return null;
  }

  addressValidator(String? value) {
    if (!validators.isURL(value)) {
      return "Invalid URL";
    }
    return null;
  }

  domainValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Domain is required";
    }
    if (!validators.isFQDN(value)) {
      return "Invalid Domain";
    }
    return null;
  }

  groupValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Group is required";
    }
    if (!validators.isLength(value, 0, 50)) {
      return "Group can be max 50 characters.";
    }
    return null;
  }

  clientValidator(String? value) {
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
