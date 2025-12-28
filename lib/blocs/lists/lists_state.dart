part of 'lists_bloc.dart';

enum ListsStateStatus { initial, loading, success, failure, empty }

enum ListsItemStateStatus { initial, loading, success, failure }

enum ListsItemToggleStateStatus { initial, loading, success, failure }

class ListsState extends Equatable {
  final List<ListsModel> lists;
  final ListsStateStatus status;
  final ListsItemStateStatus itemStatus;
  final ListsItemToggleStateStatus itemToggleStatus;
  final String toggleError;
  final String error;
  final String message;
  const ListsState({
    this.lists = const [],
    this.status = ListsStateStatus.initial,
    this.itemStatus = ListsItemStateStatus.initial,
    this.itemToggleStatus = ListsItemToggleStateStatus.initial,
    this.toggleError = "",
    this.error = "",
    this.message = "",
  });

  ListsState copyWith({
    List<ListsModel>? lists,
    ListsStateStatus? status,
    ListsItemStateStatus? itemStatus,
    ListsItemToggleStateStatus? itemToggleStatus,
    String? toggleError,
    String? error,
    String? message,
  }) {
    return ListsState(
      lists: lists ?? this.lists,
      status: status ?? this.status,
      itemStatus: itemStatus ?? this.itemStatus,
      itemToggleStatus: itemToggleStatus ?? this.itemToggleStatus,
      toggleError: toggleError ?? this.toggleError,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    lists,
    status,
    itemStatus,
    itemToggleStatus,
    error,
    toggleError,
    message,
  ];
}
