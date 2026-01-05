import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/domain_model.dart';
import 'package:pi_block/models/domain_update_model.dart';
import 'package:pi_block/models/query_model.dart';

part 'querylog_event.dart';
part 'querylog_state.dart';

class QuerylogBloc extends Bloc<QuerylogEvent, QuerylogState> {
  final PiholeRepository piholeRepository;

  QuerylogBloc(this.piholeRepository) : super(QuerylogState()) {
    on<LoadQuerylog>(_loadQuerylog);
    on<SearchQuerylog>(_searchQuerylog);
    on<ClearQuerylogSearch>(_clearSearch);
    on<AllowDenyQuerylogDomain>(_allowdenyQuerylogDomain);
    on<UpdateItemsPerPage>(_updateItemsPerPage);
    on<UpdatePagesPerView>(_updatePagesPerView);
    on<UpdateCurrentPage>(_updateCurrentPage);
  }

  void _loadQuerylog(LoadQuerylog event, Emitter<QuerylogState> emit) async {
    final isInitialLoad = state.queries.isEmpty;
    if (isInitialLoad) {
      emit(state.copyWith(status: QuerylogStateStatus.loading));
    }
    try {
      QueryListModel queryListModel = await piholeRepository.getQuerylogPage(
        "",
        event.start,
        event.itemsPerPage,
      );

      emit(
        state.copyWith(
          status: QuerylogStateStatus.success,
          queries: queryListModel.queries,
          recordsFiltered: queryListModel.recordsFiltered,
          page: event.start,
          baseQueries: queryListModel.queries,
          baseRecordsFiltered: queryListModel.recordsFiltered,
          searchTerm: "",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: QuerylogStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  void _updateCurrentPage(
    UpdateCurrentPage event,
    Emitter<QuerylogState> emit,
  ) {
    if (event.page != state.page) {
      emit(state.copyWith(page: event.page));
    }
  }

  void _clearSearch(ClearQuerylogSearch event, Emitter<QuerylogState> emit) {
    emit(
      state.copyWith(
        isClearingSearch: true,
        queries: state.baseQueries,
        recordsFiltered: state.baseRecordsFiltered,
        searchTerm: "",
        page: 1,
        searchStatus: QuerylogSearchStatus.idle,
        status: QuerylogStateStatus.success,
      ),
    );
  }

  void _searchQuerylog(
    SearchQuerylog event,
    Emitter<QuerylogState> emit,
  ) async {
    emit(
      state.copyWith(
        searchStatus: QuerylogSearchStatus.searching,
        searchTerm: event.searchTerm,
        page: event.start,
        // queries: [],
        queries: state.queries,
      ),
    );
    try {
      QueryListModel queryListModel = await piholeRepository.getQuerylogPage(
        event.searchTerm,
        event.start,
        event.itemsPerPage,
      );

      emit(
        state.copyWith(
          searchStatus: QuerylogSearchStatus.idle,
          queries: queryListModel.queries,
          recordsFiltered: queryListModel.recordsFiltered,
          page: event.start,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          searchStatus: QuerylogSearchStatus.idle,
          error: e.toString(),
        ),
      );
    }
  }

  void _updateItemsPerPage(
    UpdateItemsPerPage event,
    Emitter<QuerylogState> emit,
  ) {
    if (event.itemsPerPage != state.itemsPerPage) {
      emit(state.copyWith(itemsPerPage: event.itemsPerPage));

      add(LoadQuerylog(state.page, event.itemsPerPage));
    }
  }

  void _updatePagesPerView(
    UpdatePagesPerView event,
    Emitter<QuerylogState> emit,
  ) {
    if (event.pagesPerView != state.pagesPerView) {
      emit(state.copyWith(pagesPerView: event.pagesPerView));
    }
  }

  Future<void> _allowdenyQuerylogDomain(
    AllowDenyQuerylogDomain event,
    Emitter<QuerylogState> emit,
  ) async {
    emit(state.copyWith(itemStatus: QuerylogItemStateStatus.loading));
    try {
      DomainModel domainModel = DomainModel(
        comment: "Added from Query Log",
        domain: event.queryModel.domain,
        kind: "exact",
        type: event.type,
      );
      DomainUpdateModel domainUpdateModel = await piholeRepository
          .addDomainsItem(domainModel);

      if (domainUpdateModel.processed.errors.isNotEmpty) {
        emit(
          state.copyWith(
            itemStatus: QuerylogItemStateStatus.failure,
            error: domainUpdateModel.processed.errors.first.error,
          ),
        );
      } else {
        emit(
          state.copyWith(
            itemStatus: QuerylogItemStateStatus.success,
            message: "Successfully Updated",
          ),
        );

        /// Notification shows second time if we did not reset it
        emit(state.copyWith(itemStatus: QuerylogItemStateStatus.initial));
      }
    } catch (e) {
      emit(
        state.copyWith(
          itemStatus: QuerylogItemStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}
