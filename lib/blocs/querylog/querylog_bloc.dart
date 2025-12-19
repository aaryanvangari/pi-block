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
    on<AllowDenyQuerylogDomain>(_allowdenyQuerylogDomain);
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
        event.start,
        event.pageSize,
      );
      final queries = queryListModel.queries;
      _querylogStreamController.add(queries);
      await emit.forEach<List<QueryModel>>(
        getQuerylog(),
        onData: (queries) => state.copyWith(
          status: QuerylogStateStatus.success,
          queries: queries,
          recordsFiltered: queryListModel.recordsFiltered,
          page: event.start,
        ),
        onError: (_, _) => state.copyWith(status: QuerylogStateStatus.failure),
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
