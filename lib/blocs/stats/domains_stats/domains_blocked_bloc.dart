import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/models/domains_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';

class DomainsBlockedBloc
    extends Bloc<DomainsBlockedEvent, DomainsBlockedState> {
  final PiholeRepository piholeRepository;
  DomainsBlockedBloc(this.piholeRepository) : super(DomainsBlockedInitial()) {
    on<LoadBlockedDomains>(_getDomainsBlocked);
  }

  void _getDomainsBlocked(
    LoadBlockedDomains event,
    Emitter<DomainsBlockedState> emit,
  ) async {
    emit(DomainsBlockedLoading());
    try {
      final domains = await piholeRepository.getTopDomains(event.blocked);
      if (domains.domains.isEmpty) {
        emit(DomainsBlockedEmpty());
      } else {
        emit(DomainsBlockedLoaded(domains));
      }
    } catch (e) {
      emit(DomainsBlockedError(e.toString()));
    }
  }
}

@immutable
abstract class DomainsBlockedEvent {}

class LoadBlockedDomains extends DomainsBlockedEvent {
  final Map<String, dynamic> blocked;
  LoadBlockedDomains(this.blocked);
}

@immutable
abstract class DomainsBlockedState {}

class DomainsBlockedInitial extends DomainsBlockedState {}

class DomainsBlockedLoading extends DomainsBlockedState {}

class DomainsBlockedLoaded extends DomainsBlockedState {
  final DomainsModel domains;
  DomainsBlockedLoaded(this.domains);
}

class DomainsBlockedEmpty extends DomainsBlockedState {}

class DomainsBlockedError extends DomainsBlockedState {
  final String errorMessage;
  DomainsBlockedError(this.errorMessage);
}
