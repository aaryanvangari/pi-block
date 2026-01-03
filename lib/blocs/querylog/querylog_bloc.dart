import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/domain_model.dart';
import 'package:pi_block/models/domain_update_model.dart';
import 'package:pi_block/models/query_model.dart';
import 'package:rxdart/subjects.dart';

part 'querylog_event.dart';
part 'querylog_state.dart';

class QuerylogBloc extends Bloc<QuerylogEvent, QuerylogState> {
  final PiholeRepository piholeRepository;
  late final _querylogStreamController =
      BehaviorSubject<List<QueryModel>>.seeded(const []);

  QuerylogBloc(this.piholeRepository) : super(QuerylogState()) {
    on<LoadQuerylog>(_loadQuerylog);
    on<SearchQuerylog>(_searchQuerylog);
    on<ClearQuerylogSearch>(_clearSearch);
    on<AllowDenyQuerylogDomain>(_allowdenyQuerylogDomain);
    on<UpdateItemsPerPage>(_updateItemsPerPage);
    on<UpdatePagesPerView>(_updatePagesPerView);
    _querylogStreamController.add(const []);
  }

  Stream<List<QueryModel>> getQuerylog() =>
      _querylogStreamController.asBroadcastStream();

  void _loadQuerylog(LoadQuerylog event, Emitter<QuerylogState> emit) async {
    emit(
      state.copyWith(
        status: QuerylogStateStatus.loading,
        itemStatus: QuerylogItemStateStatus.initial,
      ),
    );
    try {
      QueryListModel queryListModel = await piholeRepository.getQuerylogPage(
        "",
        event.start,
        event.itemsPerPage,
      );
      final queries = queryListModel.queries;
      _querylogStreamController.add(queries);
      final queriesFromStream = await getQuerylog().first;

      emit(
        state.copyWith(
          status: QuerylogStateStatus.success,
          queries: queriesFromStream,
          recordsFiltered: queryListModel.recordsFiltered,
          page: event.start,
          baseQueries: queriesFromStream,
          baseRecordsFiltered: queryListModel.recordsFiltered,
          searchTerm: "",
        ),
      );
      // await emit.forEach<List<QueryModel>>(
      //   getQuerylog(),
      //   onData: (queries) {
      //     if (state.isClearingSearch) {
      //       return state.copyWith(isClearingSearch: false);
      //     }
      //     return state.copyWith(
      //       status: QuerylogStateStatus.success,
      //       queries: queries,
      //       recordsFiltered: queryListModel.recordsFiltered,
      //       page: event.start,
      //       // If searching then keep the old results so that
      //       // we can restore when search is cleared/completed
      //       // if not searching then keep the results for the next time
      //       // baseQueries: state.searchTerm.isEmpty ? queries : state.baseQueries,
      //       baseQueries: queries,
      //       // baseRecordsFiltered: state.searchTerm.isEmpty
      //       //     ? queryListModel.recordsFiltered
      //       //     : state.baseRecordsFiltered,
      //       baseRecordsFiltered: queryListModel.recordsFiltered,
      //       searchTerm: "",
      //     );
      //   },
      //   onError: (_, _) => state.copyWith(status: QuerylogStateStatus.failure),
      // );
    } catch (e) {
      emit(
        state.copyWith(
          status: QuerylogStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  void _clearSearch(ClearQuerylogSearch event, Emitter<QuerylogState> emit) {
    // RESET STREAM FIRST
    _querylogStreamController.add(state.baseQueries);
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
      ),
    );
    try {
      QueryListModel queryListModel = await piholeRepository.getQuerylogPage(
        event.searchTerm,
        event.start,
        event.itemsPerPage,
      );
      final queries = queryListModel.queries;
      _querylogStreamController.add(queries);
      final queriesFromStream = await getQuerylog().first;

      emit(
        state.copyWith(
          searchStatus: QuerylogSearchStatus.idle,
          queries: queriesFromStream,
          recordsFiltered: queryListModel.recordsFiltered,
          page: event.start,
        ),
      );
      // await emit.forEach<List<QueryModel>>(
      //   getQuerylog(),
      //   onData: (queries) {
      //     if (state.isClearingSearch) {
      //       return state.copyWith(isClearingSearch: false);
      //     }
      //     return state.copyWith(
      //       searchStatus: QuerylogSearchStatus.idle,
      //       queries: queries,
      //       recordsFiltered: queryListModel.recordsFiltered,
      //       page: event.start,
      //       searchTerm: "",
      //     );
      //   },
      //   onError: (_, _) =>
      //       state.copyWith(searchStatus: QuerylogSearchStatus.idle),
      // );
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
            error: domainUpdateModel.processed.errors[0].error,
          ),
        );
      } else {
        final queries = [..._querylogStreamController.value];
        _querylogStreamController.add(queries);

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
