part of 'domains_bloc.dart';

sealed class DomainsEvent extends Equatable {
  const DomainsEvent();

  @override
  List<Object> get props => [];
}

final class LoadDomains extends DomainsEvent {
  const LoadDomains();
}

final class DomainItemToggled extends DomainsEvent {
  const DomainItemToggled({required this.domainModel, required this.isEnabled});

  final DomainModel domainModel;
  final bool isEnabled;

  @override
  List<Object> get props => [domainModel, isEnabled];
}

final class UpdateDomainsItem extends DomainsEvent {
  const UpdateDomainsItem({
    required this.domainModel,
    required this.type,
    required this.kind,
    required this.comment,
    required this.enabled,
    required this.groups,
  });

  final DomainModel domainModel;
  final String type;
  final String kind;
  final String comment;
  final bool enabled;
  final List<int> groups;

  @override
  List<Object> get props => [domainModel, type, kind, comment, enabled, groups];
}

final class AddDomainsItem extends DomainsEvent {
  const AddDomainsItem({required this.domainModel});

  final DomainModel domainModel;

  @override
  List<Object> get props => [domainModel];
}

final class DeleteDomainsItem extends DomainsEvent {
  const DeleteDomainsItem({required this.domainModel});

  final DomainModel domainModel;

  @override
  List<Object> get props => [domainModel];
}

final class ResetItemToggleError extends DomainsEvent {}
