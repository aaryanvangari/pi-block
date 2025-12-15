part of 'lists_bloc.dart';

@immutable
abstract class ListsState {}

class ListsInitial extends ListsState {}

class ListsLoading extends ListsState {}

class ListsLoaded extends ListsState {
  final List<ListsModel> lists;

  ListsLoaded(this.lists);
}

class ListsOperationSuccess extends ListsState {
  final String message;

  ListsOperationSuccess(this.message);
}

class ListsItemOperationSuccess extends ListsState {
  final String message;

  ListsItemOperationSuccess(this.message);
}

class ListsError extends ListsState {
  final String errorMessage;

  ListsError(this.errorMessage);
}

// enum ListsStateStatus { initial, loading, success, failure, empty }

// class ListsState extends Equatable {
//   final List<ListsModel> lists;
//   final ListsStateStatus status;
//   final String error;
//   const ListsState({
//     this.lists = const [],
//     this.status = ListsStateStatus.initial,
//     this.error = ""
//   });

//   ListsState copyWith({
//     List<ListsModel>? lists,
//     ListsStateStatus? status,
//     String? error,
//   }) {
//     return ListsState(
//       lists: lists ?? this.lists,
//       status: status ?? this.status,
//       error: error ?? this.error
//     );
//   }

//   @override
//   List<Object?> get props => [lists, status, error];
// }

// final class ListsModified extends ListsState {
//   const ListsModified({required super.lists, required super.status});
// }

// @immutable
// sealed class ListsState {}

// class ListsInitial extends ListsState {
//   const ListsInitial({required super.lists});

//   @override
//   List<Object?> get props => [lists];
// }

// final class ListsLoading extends ListsState {}

// class ListsSuccess extends ListsState {
//   // @override
//   // final List<ListsModel> lists;

//   // const ListsSuccess({required this.lists});
//   const ListsSuccess({required super.lists});
// }

// final class ListsFailure extends ListsState {
//   final String error;

//   const ListsFailure(this.error);
// }

// final class ListsEmpty extends ListsState {
//   // final List<ListsModel> lists;

//   const ListsEmpty({required super.lists});
// }

/// Lists Item
// final class ListsItemLoading extends ListsState {}

// final class ListsItemSuccess extends ListsState {
//   final ListUpdateModel listUpdateModel;

//   ListsItemSuccess({required this.listUpdateModel});
// }

// final class ListsItemFailure extends ListsState {
//   final String error;

//   ListsItemFailure(this.error);
// }
