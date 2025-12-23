part of 'querylog_bloc.dart';

sealed class QuerylogEvent extends Equatable {
  const QuerylogEvent();

  @override
  List<Object> get props => [];
}

final class LoadQuerylog extends QuerylogEvent {
  final int start;
  final int itemsPerPage;
  const LoadQuerylog(this.start, this.itemsPerPage);

  @override
  List<Object> get props => [start, itemsPerPage];
}

final class AllowDenyQuerylogDomain extends QuerylogEvent {
  const AllowDenyQuerylogDomain({required this.queryModel, required this.type});

  final QueryModel queryModel;
  final String type;

  @override
  List<Object> get props => [queryModel, type];
}

class UpdateItemsPerPage extends QuerylogEvent {
  final int itemsPerPage;
  const UpdateItemsPerPage(this.itemsPerPage);

  @override
  List<Object> get props => [itemsPerPage];
}

class UpdatePagesPerView extends QuerylogEvent {
  final int pagesPerView;
  const UpdatePagesPerView(this.pagesPerView);

  @override
  List<Object> get props => [pagesPerView];
}
