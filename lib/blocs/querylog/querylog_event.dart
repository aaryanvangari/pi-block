part of 'querylog_bloc.dart';

@immutable
abstract class QuerylogEvent {}

class LoadQuerylog extends QuerylogEvent {
  final int start;
  final int pageSize;
  LoadQuerylog(this.start, this.pageSize);
}

class AllowDenyQuerylogDomain extends QuerylogEvent {
  final QueryModel queryModel;
  final String type;
  AllowDenyQuerylogDomain(this.queryModel, this.type);
}
