import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/models/domains_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';

class DomainsPermittedBloc
    extends Bloc<DomainsPermittedEvent, DomainsPermittedState> {
  final PiholeRepository piholeRepository;
  DomainsPermittedBloc(this.piholeRepository)
    : super(DomainsPermittedInitial()) {
    on<LoadPermittedDomains>(_getDomainsPermitted);
  }

  void _getDomainsPermitted(
    LoadPermittedDomains event,
    Emitter<DomainsPermittedState> emit,
  ) async {
    emit(DomainsPermittedLoading());
    try {
      final domains = await piholeRepository.getTopDomains(event.blocked);
      if (domains.domains.isEmpty) {
        emit(DomainsPermittedEmpty());
      } else {
        emit(DomainsPermittedLoaded(domains));
      }
    } catch (e) {
      emit(DomainsPermittedError(e.toString()));
    }
  }
}

@immutable
abstract class DomainsPermittedEvent {}

class LoadPermittedDomains extends DomainsPermittedEvent {
  final Map<String, dynamic> blocked;
  LoadPermittedDomains(this.blocked);
}

@immutable
abstract class DomainsPermittedState {}

class DomainsPermittedInitial extends DomainsPermittedState {}

class DomainsPermittedLoading extends DomainsPermittedState {}

class DomainsPermittedLoaded extends DomainsPermittedState {
  final DomainsModel domains;
  DomainsPermittedLoaded(this.domains);
}

class DomainsPermittedEmpty extends DomainsPermittedState {}

class DomainsPermittedError extends DomainsPermittedState {
  final String errorMessage;
  DomainsPermittedError(this.errorMessage);
}
