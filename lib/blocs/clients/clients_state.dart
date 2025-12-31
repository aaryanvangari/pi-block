part of 'clients_bloc.dart';

enum ClientsStateStatus { initial, loading, success, failure, empty }

enum ClientsItemStateStatus { initial, loading, success, failure }

class ClientsState extends Equatable {
  final List<ClientModel> clients;
  final ClientsStateStatus status;
  final ClientsItemStateStatus itemStatus;
  final String error;
  final String message;
  const ClientsState({
    this.clients = const [],
    this.status = ClientsStateStatus.initial,
    this.itemStatus = ClientsItemStateStatus.initial,
    this.error = "",
    this.message = "",
  });

  ClientsState copyWith({
    List<ClientModel>? clients,
    ClientsStateStatus? status,
    ClientsItemStateStatus? itemStatus,
    String? error,
    String? message,
  }) {
    return ClientsState(
      clients: clients ?? this.clients,
      status: status ?? this.status,
      itemStatus: itemStatus ?? this.itemStatus,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    clients,
    status,
    itemStatus,
    error,
    message,
  ];
}
