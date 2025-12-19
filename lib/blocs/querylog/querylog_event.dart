part of 'querylog_bloc.dart';

sealed class QuerylogEvent extends Equatable {
  const QuerylogEvent();

  @override
  List<Object> get props => [];
}

final class LoadQuerylog extends QuerylogEvent {
  final int start;
  final int pageSize;
  const LoadQuerylog(this.start, this.pageSize);

  @override
  List<Object> get props => [start, pageSize];
}

final class AllowDenyQuerylogDomain extends QuerylogEvent {
  const AllowDenyQuerylogDomain({required this.queryModel, required this.type});

  final QueryModel queryModel;
  final String type;

  @override
  List<Object> get props => [queryModel, type];
}
