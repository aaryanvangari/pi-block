part of 'querylog_bloc.dart';

enum QuerylogStateStatus { initial, loading, success, failure, empty }

enum QuerylogItemStateStatus { initial, loading, success, failure }

class QuerylogState extends Equatable {
  final List<QueryModel> queries;
  final QuerylogStateStatus status;
  final QuerylogItemStateStatus itemStatus;
  final String error;
  final String message;
  final int recordsFiltered;
  final int page;
  final int itemsPerPage;
  final int pagesPerView;
  const QuerylogState({
    this.queries = const [],
    this.status = QuerylogStateStatus.initial,
    this.itemStatus = QuerylogItemStateStatus.initial,
    this.error = "",
    this.message = "",
    this.recordsFiltered = 0,
    this.page = 1,
    this.itemsPerPage = 0,
    this.pagesPerView = 2,
  });

  QuerylogState copyWith({
    List<QueryModel>? queries,
    QuerylogStateStatus? status,
    QuerylogItemStateStatus? itemStatus,
    String? error,
    String? message,
    int? recordsFiltered,
    int? page,
    int? itemsPerPage,
    int? pagesPerView,
  }) {
    return QuerylogState(
      queries: queries ?? this.queries,
      status: status ?? this.status,
      itemStatus: itemStatus ?? this.itemStatus,
      error: error ?? this.error,
      message: message ?? this.message,
      recordsFiltered: recordsFiltered ?? this.recordsFiltered,
      page: page ?? this.page,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      pagesPerView: pagesPerView ?? this.pagesPerView,
    );
  }

  @override
  List<Object?> get props => [
    queries,
    status,
    itemStatus,
    error,
    message,
    recordsFiltered,
    page,
    itemsPerPage,
    pagesPerView,
  ];
}
