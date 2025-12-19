part of 'lists_bloc.dart';

enum ListsStateStatus { initial, loading, success, failure, empty }

enum ListsItemStateStatus { initial, loading, success, failure }

class ListsState extends Equatable {
  final List<ListsModel> lists;
  final ListsStateStatus status;
  final ListsItemStateStatus itemStatus;
  final String error;
  final String message;
  const ListsState({
    this.lists = const [],
    this.status = ListsStateStatus.initial,
    this.itemStatus = ListsItemStateStatus.initial,
    this.error = "",
    this.message = "",
  });

  ListsState copyWith({
    List<ListsModel>? lists,
    ListsStateStatus? status,
    ListsItemStateStatus? itemStatus,
    String? error,
    String? message,
  }) {
    return ListsState(
      lists: lists ?? this.lists,
      status: status ?? this.status,
      itemStatus: itemStatus ?? this.itemStatus,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [lists, status, itemStatus, error, message];
}
