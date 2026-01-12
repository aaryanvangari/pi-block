import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/logging/app_logger.dart';
import 'package:pi_block/models/metrics_model.dart';

class MetricsBloc extends Bloc<MetricsEvent, MetricsState> {
  final PiholeRepository piholeRepository;
  Timer? _timer;
  final _log = AppLogger.get('MetricsBloc');

  MetricsBloc(this.piholeRepository)
    : super(
        MetricsState(
          cache: SectionState.initial(),
          replies: const SectionState.initial(),
          dhcp: const SectionState.initial(),
        ),
      ) {
    on<LoadMetrics>(_onLoadMetrics);
    on<MetricsTick>(_onMetricsTick);
    on<StartPolling>(_startPolling);
    on<StopPolling>(_stopPolling);
    pollingState.addListener(() => _onPollingState(pollingState.value));
    _log.fine('PollAgent: MetricsBloc hash=${identityHashCode(this)}');
  }

  void _onPollingState(bool shouldPoll) {
    if (shouldPoll) {
      _log.fine('PollAgent: _onPollingState shouldPoll $shouldPoll');
      add(StartPolling());
    } else {
      _log.fine('PollAgent: _onPollingState shouldPoll $shouldPoll');
      add(StopPolling());
    }
  }

  Future<void> _onLoadMetrics(
    LoadMetrics event,
    Emitter<MetricsState> emit,
  ) async {
    emit(
      state.copyWith(
        cache: const SectionState.loading(),
        replies: const SectionState.loading(),
        dhcp: const SectionState.loading(),
      ),
    );

    try {
      MetricsModel metricsModel = await piholeRepository.getMetrics();

      emit(
        state.copyWith(
          cache: metricsModel.metrics.dns.cache.isEmpty
              ? const SectionState.empty()
              : SectionState.success(metricsModel.metrics.dns.cache),
          replies: metricsModel.metrics.dns.replies.isEmpty
              ? const SectionState.empty()
              : SectionState.success(metricsModel.metrics.dns.replies),
          dhcp: metricsModel.metrics.dhcp.isEmpty
              ? const SectionState.empty()
              : SectionState.success(metricsModel.metrics.dhcp),
          version: state.version + 1,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          cache: SectionState.failure(e.toString()),
          replies: SectionState.failure(e.toString()),
          dhcp: SectionState.failure(e.toString()),
        ),
      );
    }
  }

  /// Runs every 15 seconds
  Future<void> _onMetricsTick(
    MetricsTick event,
    Emitter<MetricsState> emit,
  ) async {
    try {
      _log.fine('PollAgent: _onMetricsTick');
      MetricsModel metricsModel = await piholeRepository.getMetrics();
      emit(
        state.copyWith(
          cache: metricsModel.metrics.dns.cache.isEmpty
              ? const SectionState.empty()
              : SectionState.success(metricsModel.metrics.dns.cache),
          replies: metricsModel.metrics.dns.replies.isEmpty
              ? const SectionState.empty()
              : SectionState.success(metricsModel.metrics.dns.replies),
          dhcp: metricsModel.metrics.dhcp.isEmpty
              ? const SectionState.empty()
              : SectionState.success(metricsModel.metrics.dhcp),
          version: state.version + 1,
        ),
      );
      _log.fine(
        'PollAgent: _onMetricsTick insertions: ${metricsModel.metrics.dns.cache.inserted} status: ${state.cache.status} version: ${state.version}',
      );
    } catch (_) {
      // Optional: keep last success instead of failing UI
    }
  }

  void _startPolling(StartPolling event, Emitter<MetricsState> emit) {
    _log.fine('PollAgent: _startPolling');
    // Prevent duplicate timers
    if (_timer != null) return;

    // Immediate refresh when polling starts
    add(MetricsTick());

    // Next set of refresh based on timer
    _timer = Timer.periodic(
      const Duration(seconds: KTimers.metrics),
      (_) => add(MetricsTick()),
    );
  }

  void _stopPolling(StopPolling event, Emitter<MetricsState> emit) {
    _log.fine('PollAgent: _stopPolling');
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() {
    _log.fine('PollAgent: dispose');
    _timer?.cancel();
    return super.close();
  }
}

sealed class MetricsEvent extends Equatable {
  const MetricsEvent();

  @override
  List<Object> get props => [];
}

final class LoadMetrics extends MetricsEvent {
  const LoadMetrics();
}

final class MetricsTick extends MetricsEvent {
  const MetricsTick();
}

final class StartPolling extends MetricsEvent {}

final class StopPolling extends MetricsEvent {}

enum VersionStateStatus { initial, loading, success, failure, empty }

class MetricsState extends Equatable {
  final SectionState<DnsCache> cache;
  final SectionState<DnsReplies> replies;
  final SectionState<DhcpMetrics> dhcp;
  final int version;
  const MetricsState({
    this.cache = const SectionState(),
    this.replies = const SectionState(),
    this.dhcp = const SectionState(),
    this.version = 0,
  });

  MetricsState copyWith({
    SectionState<DnsCache>? cache,
    SectionState<DnsReplies>? replies,
    SectionState<DhcpMetrics>? dhcp,
    int? version,
  }) {
    return MetricsState(
      cache: cache ?? this.cache,
      replies: replies ?? this.replies,
      dhcp: dhcp ?? this.dhcp,
      version: version ?? this.version,
    );
  }

  @override
  List<Object?> get props => [cache, replies, dhcp, version];
}

enum SectionStatus { initial, loading, success, empty, failure }

class SectionState<T> extends Equatable {
  final SectionStatus status;
  final T? data;
  final String? error;

  const SectionState({
    this.status = SectionStatus.initial,
    this.data,
    this.error,
  });

  const SectionState.initial() : this(status: SectionStatus.initial);
  const SectionState.loading() : this(status: SectionStatus.loading);
  const SectionState.failure(String error)
    : this(status: SectionStatus.failure, error: error);
  const SectionState.empty() : this(status: SectionStatus.empty);
  const SectionState.success(T data)
    : this(status: SectionStatus.success, data: data);

  @override
  List<Object?> get props => [status, data, error];
}
