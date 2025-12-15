part of 'domains_bloc.dart';

@immutable
abstract class DomainsState {}

class DomainsInitial extends DomainsState {}

class DomainsLoading extends DomainsState {}

class DomainsLoaded extends DomainsState {
  final List<DomainModel> domains;

  DomainsLoaded(this.domains);
}

class DomainsOperationSuccess extends DomainsState {
  final String message;

  DomainsOperationSuccess(this.message);
}

class DomainsItemOperationSuccess extends DomainsState {
  final String message;

  DomainsItemOperationSuccess(this.message);
}

class DomainsError extends DomainsState {
  final String errorMessage;

  DomainsError(this.errorMessage);
}
