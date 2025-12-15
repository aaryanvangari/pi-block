import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/models/upstreams_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';

class UpstreamsPiechartBloc
    extends Bloc<UpstreamsPiechartEvent, UpstreamsPiechartState> {
  final PiholeRepository piholeRepository;
  UpstreamsPiechartBloc(this.piholeRepository)
    : super(UpstreamsPiechartInitial()) {
    on<LoadUpstreamsPiechart>(_getUpstreamsPiechart);
  }

  void _getUpstreamsPiechart(
    LoadUpstreamsPiechart event,
    Emitter<UpstreamsPiechartState> emit,
  ) async {
    emit(UpstreamsPiechartLoading());
    try {
      final upstreamsModel = await piholeRepository.getUpstreams();
      emit(UpstreamsPiechartLoaded(upstreamsModel));
    } catch (e) {
      emit(UpstreamsPiechartError(e.toString()));
    }
  }
}

@immutable
abstract class UpstreamsPiechartEvent {}

class LoadUpstreamsPiechart extends UpstreamsPiechartEvent {
  LoadUpstreamsPiechart();
}

@immutable
abstract class UpstreamsPiechartState {}

class UpstreamsPiechartInitial extends UpstreamsPiechartState {}

class UpstreamsPiechartLoading extends UpstreamsPiechartState {}

class UpstreamsPiechartLoaded extends UpstreamsPiechartState {
  final UpstreamsModel upstreamsModel;
  UpstreamsPiechartLoaded(this.upstreamsModel);
}

class UpstreamsPiechartEmpty extends UpstreamsPiechartState {}

class UpstreamsPiechartError extends UpstreamsPiechartState {
  final String errorMessage;
  UpstreamsPiechartError(this.errorMessage);
}
