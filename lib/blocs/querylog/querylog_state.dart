part of 'querylog_bloc.dart';

@immutable
abstract class QuerylogState {}

class QuerylogInitial extends QuerylogState {}

class QuerylogLoading extends QuerylogState {}

class QuerylogLoaded extends QuerylogState {
  final QueryListModel queryListModel;
  final int page;

  QuerylogLoaded(this.queryListModel, this.page);
}

class QuerylogEmpty extends QuerylogState {
  QuerylogEmpty();
}

class QuerylogOperationSuccess extends QuerylogState {
  final String message;

  QuerylogOperationSuccess(this.message);
}

class QuerylogItemOperationLoading extends QuerylogState {
  QuerylogItemOperationLoading();
}

class QuerylogItemOperationSuccess extends QuerylogState {
  final String message;

  QuerylogItemOperationSuccess(this.message);
}

class QuerylogItemOperationFailure extends QuerylogState {
  final String errorMessage;

  QuerylogItemOperationFailure(this.errorMessage);
}

class QuerylogError extends QuerylogState {
  final String errorMessage;

  QuerylogError(this.errorMessage);
}
