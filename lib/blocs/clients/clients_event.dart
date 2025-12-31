part of 'clients_bloc.dart';

sealed class ClientsEvent extends Equatable {
  const ClientsEvent();

  @override
  List<Object> get props => [];
}

final class LoadClients extends ClientsEvent {
  const LoadClients();
}

final class UpdateClientsItem extends ClientsEvent {
  const UpdateClientsItem({
    required this.clientModel,
    required this.comment,
    required this.groups,
  });

  final ClientModel clientModel;
  final String comment;
  final List<int> groups;

  @override
  List<Object> get props => [clientModel, comment, groups];
}

final class AddClientsItem extends ClientsEvent {
  const AddClientsItem({required this.clientModel});

  final ClientModel clientModel;

  @override
  List<Object> get props => [clientModel];
}

final class DeleteClientsItem extends ClientsEvent {
  const DeleteClientsItem({required this.clientModel});

  final ClientModel clientModel;

  @override
  List<Object> get props => [clientModel];
}
