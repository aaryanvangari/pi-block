import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/domain_model.dart';
import 'package:pi_block/models/domain_update_model.dart';
import 'package:pi_block/models/query_model.dart';

part 'querylog_event.dart';
part 'querylog_state.dart';

class QuerylogBloc extends Bloc<QuerylogEvent, QuerylogState> {
  final PiholeRepository piholeRepository;
  QuerylogBloc(this.piholeRepository) : super(QuerylogInitial()) {
    on<LoadQuerylog>(_getQuerylog);
    on<AllowDenyQuerylogDomain>(_allowdenyQuerylogDomain);
  }

  void _getQuerylog(LoadQuerylog event, Emitter<QuerylogState> emit) async {
    emit(QuerylogLoading());
    try {
      QueryListModel queryListModel = await piholeRepository.getQuerylogPage(
        event.start,
        event.pageSize,
      );
      if (queryListModel.queries.isEmpty) {
        emit(QuerylogEmpty());
      } else {
        emit(QuerylogLoaded(queryListModel, event.start));
      }
    } catch (e) {
      emit(QuerylogError(e.toString()));
    }
  }

  void _allowdenyQuerylogDomain(
    AllowDenyQuerylogDomain event,
    Emitter<QuerylogState> emit,
  ) async {
    emit(QuerylogItemOperationLoading());
    try {
      /// #TODO refactor
      DomainModel domainModel = DomainModel.fromJson(
        jsonDecode("{\"groups\":[0]}"),
      );
      DomainModel tempDomainModel = domainModel.copyWith(
        comment: "Added from Query Log",
        domain: event.queryModel.domain,
        kind: "exact",
        type: event.type,
      );

      DomainUpdateModel domainUpdateModel = await piholeRepository
          .addDomainsItem(tempDomainModel);
      if (domainUpdateModel.processed.errors.isNotEmpty) {
        emit(
          QuerylogItemOperationFailure(
            domainUpdateModel.processed.errors[0].error,
          ),
        );
      } else {
        emit(QuerylogItemOperationSuccess("Successfully Added"));
      }
    } catch (e) {
      emit(QuerylogItemOperationFailure(e.toString()));
    }
  }
}
