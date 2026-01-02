import 'package:equatable/equatable.dart';
import 'package:pi_block/logging/model_log.dart';

/// Container for processed list update results
class Processed extends Equatable {
  /// Successfully processed list items
  final List<SuccessItem> success;

  /// List items that failed to process
  final List<ErrorItem> errors;

  const Processed({required this.success, required this.errors});

  factory Processed.fromJson(Map<String, dynamic> json) {
    ModelLog.fromJson(Processed, json);
    return Processed(
      success: (json['success'] as List)
          .map((e) => SuccessItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      errors: (json['errors'] as List)
          .map((e) => ErrorItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success.map((e) => e.toJson()).toList(),
    "errors": errors.map((e) => e.toJson()).toList(),
  };

  /// Creates a modified copy of this object
  Processed copyWith({List<SuccessItem>? success, List<ErrorItem>? errors}) =>
      Processed(
        success: success ?? this.success,
        errors: errors ?? this.errors,
      );

  @override
  List<Object?> get props => [success, errors];
}

/// Represents a successfully processed list item
class SuccessItem extends Equatable {
  /// Identifier or name of the list item
  final String item;

  const SuccessItem({required this.item});

  factory SuccessItem.fromJson(Map<String, dynamic> json) =>
      SuccessItem(item: json['item'] ?? "");

  Map<String, dynamic> toJson() => {"item": item};

  /// Creates a modified copy of this object
  SuccessItem copyWith({String? item}) => SuccessItem(item: item ?? this.item);

  @override
  List<Object?> get props => [item];
}

/// Represents a list item that failed to process
class ErrorItem extends Equatable {
  /// Identifier or name of the list item
  final String item;

  /// Error message describing the failure
  final String error;

  const ErrorItem({required this.item, required this.error});

  factory ErrorItem.fromJson(Map<String, dynamic> json) =>
      ErrorItem(item: json['item'] ?? "", error: json['error'] ?? "");

  Map<String, dynamic> toJson() => {"item": item, "error": error};

  /// Creates a modified copy of this object
  ErrorItem copyWith({String? item, String? error}) =>
      ErrorItem(item: item ?? this.item, error: error ?? this.error);

  @override
  List<Object?> get props => [item, error];
}
