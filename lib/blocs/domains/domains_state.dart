part of 'domains_bloc.dart';

enum DomainsStateStatus { initial, loading, success, failure, empty }

enum DomainsItemStateStatus { initial, loading, success, failure }

class DomainsState extends Equatable {
  final List<DomainModel> domains;
  final DomainsStateStatus status;
  final DomainsItemStateStatus itemStatus;
  final String error;
  final String message;
  const DomainsState({
    this.domains = const [],
    this.status = DomainsStateStatus.initial,
    this.itemStatus = DomainsItemStateStatus.initial,
    this.error = "",
    this.message = "",
  });

  DomainsState copyWith({
    List<DomainModel>? domains,
    DomainsStateStatus? status,
    DomainsItemStateStatus? itemStatus,
    String? error,
    String? message,
  }) {
    return DomainsState(
      domains: domains ?? this.domains,
      status: status ?? this.status,
      itemStatus: itemStatus ?? this.itemStatus,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [domains, status, itemStatus, error, message];
}
