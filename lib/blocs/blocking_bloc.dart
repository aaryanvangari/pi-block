import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/models/blocking_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockingBloc extends Bloc<BlockingEvent, BlockingState> {
  final PiholeRepository piholeRepository;

  final _blockingController = StreamController<bool>();
  Stream<bool> get blockingStream => _blockingController.stream;

  BlockingBloc(this.piholeRepository) : super(BlockingInitial()) {
    on<LoadBlocking>(_getBlocking);
    on<OnBlockingChanged>(_onBlockingChanged);
  }

  void _getBlocking(LoadBlocking event, Emitter<BlockingState> emit) async {
    emit(BlockingLoading());
    try {
      BlockingModel blockingModel = await piholeRepository.getBlockingStatus();
      bool isBlockingEnabled = false;
      switch (blockingModel.blocking) {
        case BlockingStatus.enabled:
          isBlockingEnabled = true;
          break;
        case BlockingStatus.disabled:
          isBlockingEnabled = false;
          break;
        default:
          isBlockingEnabled = false;
      }

      final prefs = await SharedPreferences.getInstance();
      int blockingTimer = prefs.getInt(KConstants.blockingTimer) ?? 0;
      int blockingTimerAddedAt =
          prefs.getInt(KConstants.blockingTimerAddedAt) ?? 0;
      // Add 1 more second to make sure it's really done with blocking
      // reducing seconds from the time since it's added so that it gives
      // updated timer when coming from other pages
      int blockingTimerValidTill =
          blockingTimerAddedAt + 1000 + (blockingTimer * 1000);
      int currentMilliSeconds = DateTime.now().millisecondsSinceEpoch;
      double differenceInSeconds =
          (blockingTimerValidTill - currentMilliSeconds) / 1000;
      log(
        "differenceInSeconds $differenceInSeconds",
        level: Level.FINE.value,
        name: "DashboardPage.handleBlockingTimer",
      );
      if (blockingTimerValidTill > currentMilliSeconds) {
        blockedTimerNotifier.value = Duration(
          seconds: differenceInSeconds.toInt(),
        );
      } else {
        log(
          "blockingTimer Invalidated",
          level: Level.FINE.value,
          name: "DashboardPage.handleBlockingTimer",
        );
        // Resetting blockingTimer as its invalidated
        await prefs.setInt(KConstants.blockingTimer, 0);
        await prefs.setInt(KConstants.blockingTimerAddedAt, 0);
      }
      emit(BlockingLoaded(isBlockingEnabled));
    } catch (e) {
      emit(BlockingError(e.toString()));
    }
  }

  void _onBlockingChanged(
    OnBlockingChanged event,
    Emitter<BlockingState> emit,
  ) async {
    emit(BlockingChangeLoading());
    try {
      BlockingModel blockingModel = await piholeRepository.onBlockingChanged(
        event.status,
        event.timer,
      );
      bool isBlockingEnabled = false;
      switch (blockingModel.blocking) {
        case BlockingStatus.enabled:
          isBlockingEnabled = true;
          break;
        case BlockingStatus.disabled:
          isBlockingEnabled = false;
          break;
        default:
          isBlockingEnabled = false;
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (blockingModel.timer > 0) {
        await prefs.setInt(
          KConstants.blockingTimer,
          Duration(seconds: blockingModel.timer.toInt()).inSeconds,
        );
        await prefs.setInt(
          KConstants.blockingTimerAddedAt,
          DateTime.now().millisecondsSinceEpoch,
        );
      }

      isBlockedEnabledNotifier.value =
          (blockingModel.blocking == BlockingStatus.enabled) ? true : false;

      // if blocking is enabled then resetting timer in local and in preferences
      if (isBlockedEnabledNotifier.value) {
        blockedTimerNotifier.value = Duration();
        await prefs.setInt(KConstants.blockingTimer, Duration().inSeconds);
      } else {
        // Add 1 more second to make sure it's timer mismatch doesn't occur. Research on it thoroughly
        blockedTimerNotifier.value = Duration(
          seconds: blockingModel.timer.toInt() + 1,
        );
      }
      emit(BlockingChangeLoaded(isBlockingEnabled));
    } catch (e) {
      emit(BlockingChangeError(e.toString()));
    }
  }
}

@immutable
abstract class BlockingEvent {}

class LoadBlocking extends BlockingEvent {
  LoadBlocking();
}

class OnBlockingChanged extends BlockingEvent {
  final bool status;
  final dynamic timer;
  OnBlockingChanged(this.status, this.timer);
}

@immutable
abstract class BlockingState {}

class BlockingInitial extends BlockingState {}

class BlockingLoading extends BlockingState {}

class BlockingLoaded extends BlockingState {
  final bool isBlockingEnabled;
  BlockingLoaded(this.isBlockingEnabled);
}

class BlockingEmpty extends BlockingState {}

class BlockingError extends BlockingState {
  final String errorMessage;
  BlockingError(this.errorMessage);
}

class BlockingChangeInitial extends BlockingState {}

class BlockingChangeLoading extends BlockingState {}

class BlockingChangeLoaded extends BlockingState {
  final bool isBlockingEnabled;
  BlockingChangeLoaded(this.isBlockingEnabled);
}

class BlockingChangeEmpty extends BlockingState {}

class BlockingChangeError extends BlockingState {
  final String errorMessage;
  BlockingChangeError(this.errorMessage);
}
