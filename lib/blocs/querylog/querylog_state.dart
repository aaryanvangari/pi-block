part of 'querylog_bloc.dart';

enum QuerylogStateStatus { initial, loading, success, failure, empty }

enum QuerylogItemStateStatus { initial, loading, success, failure }

enum QuerylogSearchStatus { idle, searching }

class QuerylogState extends Equatable {
  final List<QueryModel> queries;
  final List<QueryModel> baseQueries; // last non-search data
  final QuerylogStateStatus status;
  final QuerylogItemStateStatus itemStatus;
  final String error;
  final String message;
  final int recordsFiltered;
  final int baseRecordsFiltered;
  final int page;
  final int itemsPerPage;
  final int pagesPerView;
  final QuerylogSearchStatus searchStatus;
  final String searchTerm;
  final bool isClearingSearch;
  const QuerylogState({
    this.queries = const [],
    this.baseQueries = const [],
    this.status = QuerylogStateStatus.initial,
    this.itemStatus = QuerylogItemStateStatus.initial,
    this.error = "",
    this.message = "",
    this.recordsFiltered = 0,
    this.baseRecordsFiltered = 0,
    this.page = 1,
    this.itemsPerPage = 0,
    this.pagesPerView = 2,
    this.searchStatus = QuerylogSearchStatus.idle,
    this.searchTerm = "",
    this.isClearingSearch = false,
  });

  QuerylogState copyWith({
    List<QueryModel>? queries,
    List<QueryModel>? baseQueries,
    QuerylogStateStatus? status,
    QuerylogItemStateStatus? itemStatus,
    String? error,
    String? message,
    int? recordsFiltered,
    int? baseRecordsFiltered,
    int? page,
    int? itemsPerPage,
    int? pagesPerView,
    QuerylogSearchStatus? searchStatus,
    String? searchTerm,
    bool? isClearingSearch,
  }) {
    return QuerylogState(
      queries: queries ?? this.queries,
      baseQueries: baseQueries ?? this.baseQueries,
      status: status ?? this.status,
      itemStatus: itemStatus ?? this.itemStatus,
      error: error ?? this.error,
      message: message ?? this.message,
      recordsFiltered: recordsFiltered ?? this.recordsFiltered,
      baseRecordsFiltered: baseRecordsFiltered ?? this.baseRecordsFiltered,
      page: page ?? this.page,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      pagesPerView: pagesPerView ?? this.pagesPerView,
      searchStatus: searchStatus ?? this.searchStatus,
      searchTerm: searchTerm ?? this.searchTerm,
      isClearingSearch: isClearingSearch ?? this.isClearingSearch,
    );
  }

  @override
  List<Object?> get props => [
    queries,
    baseQueries,
    status,
    itemStatus,
    error,
    message,
    recordsFiltered,
    baseRecordsFiltered,
    page,
    itemsPerPage,
    pagesPerView,
    searchStatus,
    searchTerm,
    isClearingSearch,
  ];
}
