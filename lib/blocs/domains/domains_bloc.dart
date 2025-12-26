import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/models/domain_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/domain_update_model.dart';
import 'package:rxdart/subjects.dart';

part 'domains_event.dart';
part 'domains_state.dart';

class DomainsBloc extends Bloc<DomainsEvent, DomainsState> {
  final PiholeRepository piholeRepository;

  late final _domainstreamController =
      BehaviorSubject<List<DomainModel>>.seeded(const []);

  DomainsBloc(this.piholeRepository) : super(DomainsState()) {
    on<LoadDomains>(_loadDomains);
    on<DomainItemToggled>(_onDomainToggled);
    on<UpdateDomainsItem>(_updateDomainsItem);
    on<AddDomainsItem>(_addDomainsItem);
    on<DeleteDomainsItem>(_deleteDomainsItem);
    on<ResetItemToggleError>(_resetToggleError);
    _domainstreamController.add(const []);
  }

  Stream<List<DomainModel>> getDomains() =>
      _domainstreamController.asBroadcastStream();

  void _loadDomains(LoadDomains event, Emitter<DomainsState> emit) async {
    emit(
      state.copyWith(
        status: DomainsStateStatus.loading,
        itemStatus: DomainsItemStateStatus.initial,
      ),
    );
    try {
      final domains = await piholeRepository.getDomainsData();
      _domainstreamController.add(domains);
      await emit.forEach<List<DomainModel>>(
        getDomains(),
        onData: (domains) => state.copyWith(
          status: DomainsStateStatus.success,
          domains: domains,
        ),
        onError: (_, _) => state.copyWith(status: DomainsStateStatus.failure),
      );
    } catch (e) {
      emit(
        state.copyWith(status: DomainsStateStatus.failure, error: e.toString()),
      );
    }
  }

  void _resetToggleError(
    ResetItemToggleError event,
    Emitter<DomainsState> emit,
  ) {
    emit(
      state.copyWith(
        itemToggleStatus: DomainsItemToggleStateStatus.initial,
        toggleError: "",
      ),
    );
  }

  Future<void> _onDomainToggled(
    DomainItemToggled event,
    Emitter<DomainsState> emit,
  ) async {
    emit(
      state.copyWith(itemToggleStatus: DomainsItemToggleStateStatus.loading),
    );
    try {
      final newDomain = event.domainModel.copyWith(enabled: event.isEnabled);
      DomainUpdateModel domainUpdateModel = await piholeRepository
          .updateDomainItem(
            newDomain,
            event.domainModel.type,
            event.domainModel.kind,
          );
      final domains = [..._domainstreamController.value];
      final domainIndex = domains.indexWhere(
        (t) => t.id == event.domainModel.id,
      );
      if (domainIndex >= 0) {
        domains[domainIndex] = domainUpdateModel.domains[0];
      }
      _domainstreamController.add(domains);
    } catch (e) {
      emit(
        state.copyWith(
          itemToggleStatus: DomainsItemToggleStateStatus.failure,
          toggleError: e.toString(),
        ),
      );
    }
  }

  Future<void> _updateDomainsItem(
    UpdateDomainsItem event,
    Emitter<DomainsState> emit,
  ) async {
    emit(state.copyWith(itemStatus: DomainsItemStateStatus.loading));
    try {
      final newDomain = event.domainModel.copyWith(
        type: event.type,
        kind: event.kind,
        comment: event.comment,
        enabled: event.enabled,
        groups: event.groups,
      );

      DomainUpdateModel domainUpdateModel = await piholeRepository
          .updateDomainItem(
            newDomain,
            event.domainModel.type,
            event.domainModel.kind,
          );
      final domains = [..._domainstreamController.value];
      final domainIndex = domains.indexWhere(
        (t) => t.id == event.domainModel.id,
      );
      if (domainIndex >= 0) {
        domains[domainIndex] = domainUpdateModel.domains[0];
      }
      _domainstreamController.add(domains);
      emit(
        state.copyWith(
          itemStatus: DomainsItemStateStatus.success,
          message: "Successfully Updated",
        ),
      );

      /// Notification shows second time if we did not reset it
      emit(state.copyWith(itemStatus: DomainsItemStateStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(
          itemStatus: DomainsItemStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _addDomainsItem(
    AddDomainsItem event,
    Emitter<DomainsState> emit,
  ) async {
    emit(state.copyWith(itemStatus: DomainsItemStateStatus.loading));
    try {
      DomainUpdateModel domainUpdateModel = await piholeRepository
          .addDomainsItem(event.domainModel);
      final domains = [..._domainstreamController.value];
      domains.add(domainUpdateModel.domains[0]);
      _domainstreamController.add(domains);
      emit(
        state.copyWith(
          itemStatus: DomainsItemStateStatus.success,
          message: "Successfully Added",
        ),
      );

      /// Notification shows second time if we did not reset it
      emit(state.copyWith(itemStatus: DomainsItemStateStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(
          itemStatus: DomainsItemStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _deleteDomainsItem(
    DeleteDomainsItem event,
    Emitter<DomainsState> emit,
  ) async {
    emit(state.copyWith(itemStatus: DomainsItemStateStatus.loading));
    try {
      bool isDeleted = await piholeRepository.deleteDomainsItem(
        event.domainModel,
      );
      if (isDeleted) {
        final domains = [..._domainstreamController.value];
        final domainIndex = domains.indexWhere(
          (t) => t.id == event.domainModel.id,
        );
        if (domainIndex >= 0) {
          domains.removeAt(domainIndex);
        }
        _domainstreamController.add(domains);
        emit(
          state.copyWith(
            itemStatus: DomainsItemStateStatus.success,
            message: "Successfully Deleted",
          ),
        );
      }

      /// Notification shows second time if we did not reset it
      emit(state.copyWith(itemStatus: DomainsItemStateStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(
          itemStatus: DomainsItemStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _domainstreamController.close();
    return super.close();
  }
}
