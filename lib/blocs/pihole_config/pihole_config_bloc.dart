import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/pihole_config_model.dart';

part 'pihole_config_event.dart';
part 'pihole_config_state.dart';

class PiholeConfigBloc extends Bloc<PiholeConfigEvent, PiholeConfigState> {
  final PiholeRepository piholeRepository;
  PiholeConfigBloc(this.piholeRepository) : super(PiholeConfigInitial()) {
    on<PiholeConfigFetched>(_getPiholeConfig);
  }

  void _getPiholeConfig(
    PiholeConfigFetched event,
    Emitter<PiholeConfigState> emit,
  ) async {
    emit(PiholeConfigLoading());
    try {
      PiholeConfigModel piholeConfigModel = await piholeRepository
          .getPiholeConfiguration();
      emit(PiholeConfigSuccess(piholeConfigModel: piholeConfigModel));
    } catch (e) {
      addError(e);
      emit(PiholeConfigFailure(e.toString()));
    }
  }
}
