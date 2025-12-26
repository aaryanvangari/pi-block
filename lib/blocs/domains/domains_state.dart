part of 'domains_bloc.dart';

enum DomainsStateStatus { initial, loading, success, failure, empty }

enum DomainsItemStateStatus { initial, loading, success, failure }

enum DomainsItemToggleStateStatus { initial, loading, success, failure }

class DomainsState extends Equatable {
  final List<DomainModel> domains;
  final DomainsStateStatus status;
  final DomainsItemStateStatus itemStatus;
  final DomainsItemToggleStateStatus itemToggleStatus;
  final String toggleError;
  final String error;
  final String message;
  const DomainsState({
    this.domains = const [],
    this.status = DomainsStateStatus.initial,
    this.itemStatus = DomainsItemStateStatus.initial,
    this.itemToggleStatus = DomainsItemToggleStateStatus.initial,
    this.error = "",
    this.toggleError = "",
    this.message = "",
  });

  DomainsState copyWith({
    List<DomainModel>? domains,
    DomainsStateStatus? status,
    DomainsItemStateStatus? itemStatus,
    DomainsItemToggleStateStatus? itemToggleStatus,
    String? error,
    String? toggleError,
    String? message,
  }) {
    return DomainsState(
      domains: domains ?? this.domains,
      status: status ?? this.status,
      itemStatus: itemStatus ?? this.itemStatus,
      itemToggleStatus: itemToggleStatus ?? this.itemToggleStatus,
      error: error ?? this.error,
      toggleError: toggleError ?? this.toggleError,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    domains,
    status,
    itemStatus,
    itemToggleStatus,
    error,
    toggleError,
    message,
  ];
}
