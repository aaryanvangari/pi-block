part of 'clients_bloc.dart';

enum ClientsStateStatus { initial, loading, success, failure, empty }

enum ClientsSuggestionsStateStatus { initial, loading, success, failure, empty }

enum ClientsItemStateStatus { initial, loading, success, failure }

class ClientsState extends Equatable {
  final List<ClientModel> clients;
  final List<ClientSuggestionModel> suggestions;
  final ClientsSuggestionsStateStatus suggestionStatus;
  final ClientsStateStatus status;
  final ClientsItemStateStatus itemStatus;
  final String error;
  final String message;
  const ClientsState({
    this.clients = const [],
    this.suggestions = const [],
    this.status = ClientsStateStatus.initial,
    this.itemStatus = ClientsItemStateStatus.initial,
    this.suggestionStatus = ClientsSuggestionsStateStatus.initial,
    this.error = "",
    this.message = "",
  });

  ClientsState copyWith({
    List<ClientModel>? clients,
    List<ClientSuggestionModel>? suggestions,
    ClientsStateStatus? status,
    ClientsSuggestionsStateStatus? suggestionStatus,
    ClientsItemStateStatus? itemStatus,
    String? error,
    String? message,
  }) {
    return ClientsState(
      clients: clients ?? this.clients,
      suggestions: suggestions?? this.suggestions,
      status: status ?? this.status,
      suggestionStatus: suggestionStatus ?? this.suggestionStatus,
      itemStatus: itemStatus ?? this.itemStatus,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    clients,
    suggestions,
    suggestionStatus,
    status,
    itemStatus,
    error,
    message,
  ];
}
