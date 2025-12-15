import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/models/domain_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';

part 'domains_event.dart';
part 'domains_state.dart';

class DomainsBloc extends Bloc<DomainsEvent, DomainsState> {
  final PiholeRepository piholeRepository;
  DomainsBloc(this.piholeRepository) : super(DomainsInitial()) {
    on<LoadDomains>(_getDomains);
    on<UpdateDomains>(_updateDomains);
    on<DeleteDomains>(_deleteDomains);
    on<AddDomains>(_addDomains);
  }

  void _getDomains(LoadDomains event, Emitter<DomainsState> emit) async {
    emit(DomainsLoading());
    try {
      final domains = await piholeRepository.getDomainsData();
      emit(DomainsLoaded(domains));
    } catch (e) {
      emit(DomainsError(e.toString()));
    }
  }

  void _updateDomains(UpdateDomains event, Emitter<DomainsState> emit) async {
    emit(DomainsLoading());
    try {
      await piholeRepository.updateDomainItem(
        event.domainModel,
        event.previousType,
        event.previousKind,
      );
      emit(DomainsItemOperationSuccess("Successfully Updated"));

      /// #TODO update item inline without loading whole list again
      emit(DomainsOperationSuccess(""));
    } catch (e) {
      emit(DomainsError(e.toString()));
    }
  }

  void _deleteDomains(DeleteDomains event, Emitter<DomainsState> emit) async {
    emit(DomainsLoading());
    try {
      await piholeRepository.deleteDomainsItem(event.domainModel);
      emit(DomainsItemOperationSuccess("Successfully Deleted"));
      emit(DomainsOperationSuccess(""));
    } catch (e) {
      emit(DomainsError(e.toString()));
    }
  }

  void _addDomains(AddDomains event, Emitter<DomainsState> emit) async {
    emit(DomainsLoading());
    try {
      await piholeRepository.addDomainsItem(event.domainModel);
      emit(DomainsItemOperationSuccess("Successfully Added"));
      emit(DomainsOperationSuccess(""));
    } catch (e) {
      emit(DomainsError(e.toString()));
    }
  }
}
