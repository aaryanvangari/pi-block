part of 'domains_bloc.dart';

@immutable
abstract class DomainsEvent {}

class LoadDomains extends DomainsEvent {}

class AddDomains extends DomainsEvent {
  final DomainModel domainModel;

  AddDomains(this.domainModel);
}

class UpdateDomains extends DomainsEvent {
  final DomainModel domainModel;
  final String previousType;
  final String previousKind;

  UpdateDomains(this.domainModel, this.previousType, this.previousKind);
}

class DeleteDomains extends DomainsEvent {
  final DomainModel domainModel;

  DeleteDomains(this.domainModel);
}
