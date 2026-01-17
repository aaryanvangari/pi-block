part of 'network_devices_bloc.dart';

enum NetworkDevicesStateStatus { initial, loading, success, failure, empty }

enum NetworkDevicesItemStateStatus { initial, loading, success, failure }

enum NetworkDevicesSearchStatus { idle, searching }

class NetworkDevicesState extends Equatable {
  final List<Device> devices;
  final List<Device> baseDevices; // last non-search data
  final NetworkDevicesStateStatus status;
  final NetworkDevicesItemStateStatus itemStatus;
  final String error;
  final String message;
  final int total;
  final int baseRecordsTotal;
  final int page;
  final int itemsPerPage;
  final int pagesPerView;
  final NetworkDevicesSearchStatus searchStatus;
  final String searchTerm;
  final bool isClearingSearch;
  final int maxDevices;
  final int maxAddresses;
  final bool initialLoad;
  final List<Device> loadedDevices;
  final List<Device> searchResults;
  final int basePage;
  const NetworkDevicesState({
    this.devices = const [],
    this.baseDevices = const [],
    this.status = NetworkDevicesStateStatus.initial,
    this.itemStatus = NetworkDevicesItemStateStatus.initial,
    this.error = "",
    this.message = "",
    this.total = 0,
    this.baseRecordsTotal = 0,
    this.page = 1,
    this.itemsPerPage = 0,
    this.pagesPerView = 2,
    this.searchStatus = NetworkDevicesSearchStatus.idle,
    this.searchTerm = "",
    this.isClearingSearch = false,
    this.maxDevices = 100,
    this.maxAddresses = 25,
    this.initialLoad = true,
    this.loadedDevices = const [],
    this.searchResults = const [],
    this.basePage = 1,
  });

  NetworkDevicesState copyWith({
    List<Device>? devices,
    List<Device>? baseDevices,
    NetworkDevicesStateStatus? status,
    NetworkDevicesItemStateStatus? itemStatus,
    String? error,
    String? message,
    int? total,
    int? baseRecordsTotal,
    int? page,
    int? itemsPerPage,
    int? pagesPerView,
    NetworkDevicesSearchStatus? searchStatus,
    String? searchTerm,
    bool? isClearingSearch,
    int? maxDevices,
    int? maxAddresses,
    bool? initialLoad,
    List<Device>? loadedDevices,
    List<Device>? searchResults,
    int? basePage,
  }) {
    return NetworkDevicesState(
      devices: devices ?? this.devices,
      baseDevices: baseDevices ?? this.baseDevices,
      status: status ?? this.status,
      itemStatus: itemStatus ?? this.itemStatus,
      error: error ?? this.error,
      message: message ?? this.message,
      total: total ?? this.total,
      baseRecordsTotal: baseRecordsTotal ?? this.baseRecordsTotal,
      page: page ?? this.page,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      pagesPerView: pagesPerView ?? this.pagesPerView,
      searchStatus: searchStatus ?? this.searchStatus,
      searchTerm: searchTerm ?? this.searchTerm,
      isClearingSearch: isClearingSearch ?? this.isClearingSearch,
      maxDevices: maxDevices ?? this.maxDevices,
      maxAddresses: maxAddresses ?? this.maxAddresses,
      initialLoad: initialLoad ?? this.initialLoad,
      loadedDevices: loadedDevices ?? this.loadedDevices,
      searchResults: searchResults ?? this.searchResults,
      basePage: basePage ?? this.basePage
    );
  }

  @override
  List<Object?> get props => [
    devices,
    baseDevices,
    status,
    itemStatus,
    error,
    message,
    total,
    baseRecordsTotal,
    page,
    itemsPerPage,
    pagesPerView,
    searchStatus,
    searchTerm,
    isClearingSearch,
    maxDevices,
    maxAddresses,
    initialLoad,
    loadedDevices,
    searchResults,
    basePage
  ];
}
