import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/network_gateway_model.dart';

class InterfacesBloc extends Bloc<InterfacesEvent, InterfacesState> {
  final PiholeRepository piholeRepository;
  InterfacesBloc(this.piholeRepository) : super(InterfacesInitial()) {
    on<InterfacesFetched>(_getInterfaces);
  }

  void _getInterfaces(
    InterfacesFetched event,
    Emitter<InterfacesState> emit,
  ) async {
    emit(InterfacesLoading());
    try {
      NetworkGatewayModel networkGatewayModel = await piholeRepository
          .getNetworkGateway();
      emit(InterfacesSuccess(networkGatewayModel: networkGatewayModel));
    } catch (e) {
      addError(e);
      emit(InterfacesFailure(e.toString()));
    }
  }
}

@immutable
sealed class InterfacesEvent {}

final class InterfacesFetched extends InterfacesEvent {}

@immutable
sealed class InterfacesState {}

final class InterfacesInitial extends InterfacesState {}

final class InterfacesLoading extends InterfacesState {}

final class InterfacesSuccess extends InterfacesState {
  final NetworkGatewayModel networkGatewayModel;

  InterfacesSuccess({required this.networkGatewayModel});
}

final class InterfacesFailure extends InterfacesState {
  final String error;

  InterfacesFailure(this.error);
}
