import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/models/domain_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/domain_update_model.dart';

part 'domains_event.dart';
part 'domains_state.dart';

class DomainsBloc extends Bloc<DomainsEvent, DomainsState> {
  final PiholeRepository piholeRepository;

  DomainsBloc(this.piholeRepository) : super(DomainsState()) {
    on<LoadDomains>(_loadDomains);
    on<DomainItemToggled>(_onDomainToggled);
    on<UpdateDomainsItem>(_updateDomainsItem);
    on<AddDomainsItem>(_addDomainsItem);
    on<DeleteDomainsItem>(_deleteDomainsItem);
    on<ResetItemToggleError>(_resetToggleError);
  }

  void _loadDomains(LoadDomains event, Emitter<DomainsState> emit) async {
    emit(
      state.copyWith(
        status: DomainsStateStatus.loading,
        itemStatus: DomainsItemStateStatus.initial,
      ),
    );
    try {
      final domains = await piholeRepository.getDomainsData();
      emit(
        state.copyWith(status: DomainsStateStatus.success, domains: domains),
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

      final updatedDomain = domainUpdateModel.domains.first;

      final updatedDomains = state.domains
          .map((d) => d.id == updatedDomain.id ? updatedDomain : d)
          .toList();

      emit(
        state.copyWith(
          domains: updatedDomains,
          itemToggleStatus: DomainsItemToggleStateStatus.success,
          message: "Successfully Updated",
        ),
      );
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

      final updatedDomain = domainUpdateModel.domains.first;

      final updatedDomains = state.domains
          .map((d) => d.id == updatedDomain.id ? updatedDomain : d)
          .toList();

      emit(
        state.copyWith(
          domains: updatedDomains,
          itemStatus: DomainsItemStateStatus.success,
          message: "Successfully Updated",
        ),
      );
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

      final domains = [...state.domains, domainUpdateModel.domains.first];

      emit(
        state.copyWith(
          domains: domains,
          itemStatus: DomainsItemStateStatus.success,
          message: "Successfully Added",
        ),
      );
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
      if (!isDeleted) {
        emit(
          state.copyWith(
            itemStatus: DomainsItemStateStatus.failure,
            error: "Failed to delete",
          ),
        );
        return;
      }

      // ignoring the deleted item
      final updatedDomains = state.domains
          .where((d) => d.id != event.domainModel.id)
          .toList();
      emit(
        state.copyWith(
          domains: updatedDomains,
          itemStatus: DomainsItemStateStatus.success,
          message: "Successfully Deleted",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          itemStatus: DomainsItemStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}
