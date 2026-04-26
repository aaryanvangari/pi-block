import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/network_devices.dart';

part 'network_devices_event.dart';
part 'network_devices_state.dart';

class NetworkDevicesBloc
    extends Bloc<NetworkDevicesEvent, NetworkDevicesState> {
  final PiholeRepository piholeRepository;

  NetworkDevicesBloc(this.piholeRepository) : super(NetworkDevicesState()) {
    on<LoadNetworkDevices>(_loadNetworkDevices);
    on<SearchNetworkDevices>(_searchNetworkDevices);
    on<ClearNetworkDevicesSearch>(_clearSearch);
    on<DeleteNetworkDevice>(_deleteNetworkDevice);
    on<UpdateItemsPerPage>(_updateItemsPerPage);
    on<UpdatePagesPerView>(_updatePagesPerView);
    on<UpdateCurrentPage>(_updateCurrentPage);
    on<RefreshNetworkDevices>(_refreshDevices);
  }

  void _refreshDevices(
    RefreshNetworkDevices event,
    Emitter<NetworkDevicesState> emit,
  ) async {
    try {
      NetworkDevicesModel networkDevicesModel = await getDevices(
        state.maxDevices,
        state.maxAddresses,
      );
      emit(state.copyWith(loadedDevices: networkDevicesModel.devices));
      // Resetting to page 1
      add(LoadNetworkDevices(1, state.itemsPerPage));
    } catch (e) {
      rethrow;
    }
  }

  Future<NetworkDevicesModel> getDevices(
    int maxDevices,
    int maxAddresses,
  ) async {
    try {
      NetworkDevicesModel networkDevicesModel = await piholeRepository
          .getNetworkDevices(maxDevices, maxAddresses);
      return networkDevicesModel;
    } catch (e) {
      rethrow;
    }
  }

  void _loadNetworkDevices(
    LoadNetworkDevices event,
    Emitter<NetworkDevicesState> emit,
  ) async {
    final isInitialLoad = state.initialLoad;
    int start = (event.start - 1) * event.itemsPerPage;
    int end = (event.start * event.itemsPerPage).clamp(
      event.start,
      state.loadedDevices.isEmpty
          ? event.itemsPerPage
          : state.loadedDevices.length,
    );
    try {
      if (isInitialLoad) {
        emit(
          state.copyWith(
            status: NetworkDevicesStateStatus.loading,
            initialLoad: false,
          ),
        );
        NetworkDevicesModel networkDevicesModel = await getDevices(
          state.maxDevices,
          state.maxAddresses,
        );
        emit(state.copyWith(loadedDevices: networkDevicesModel.devices));
      }
      emit(
        state.copyWith(
          status: NetworkDevicesStateStatus.success,
          devices: state.loadedDevices.sublist(start, end),
          total: state.loadedDevices.length,
          page: event.start,
          basePage: event.start,
          baseDevices: state.loadedDevices.sublist(start, end),
          baseRecordsTotal: state.loadedDevices.length,
          searchTerm: "",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NetworkDevicesStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  void _updateCurrentPage(
    UpdateCurrentPage event,
    Emitter<NetworkDevicesState> emit,
  ) {
    if (event.page != state.page) {
      emit(state.copyWith(page: event.page));
    }
  }

  void _clearSearch(
    ClearNetworkDevicesSearch event,
    Emitter<NetworkDevicesState> emit,
  ) {
    emit(
      state.copyWith(
        isClearingSearch: true,
        devices: state.baseDevices,
        total: state.baseRecordsTotal,
        searchTerm: "",
        page: state.basePage,
        searchStatus: NetworkDevicesSearchStatus.idle,
        status: NetworkDevicesStateStatus.success,
        searchResults: [],
      ),
    );
  }

  List<Device> searchWithinData(SearchNetworkDevices event) {
    List<Device> searchResults = [];
    for (var device in state.loadedDevices) {
      if (device.hwaddr.contains(event.searchTerm)) {
        searchResults.add(device);
      }
      for (var ip in device.ips) {
        if (ip.name != null && ip.name!.contains(event.searchTerm)) {
          searchResults.add(device);
        }
      }
    }
    return searchResults;
  }

  void _searchNetworkDevices(
    SearchNetworkDevices event,
    Emitter<NetworkDevicesState> emit,
  ) async {
    emit(
      state.copyWith(
        searchStatus: NetworkDevicesSearchStatus.searching,
        searchTerm: event.searchTerm,
        page: event.start,
        devices: state.devices,
      ),
    );
    try {
      List<Device> searchResults = searchWithinData(event);

      // Updating state with search results
      emit(state.copyWith(searchResults: searchResults));

      // calculating start and end for pagination based on search results
      int start = (event.start - 1) * event.itemsPerPage;
      int end = (event.start * event.itemsPerPage).clamp(
        event.start,
        state.searchResults.isEmpty
            ? event.itemsPerPage
            : state.searchResults.length,
      );
      // log(
      //   'DATA: searching: start $start end: $end searchTerm: ${event.searchTerm}',
      // );
      // log('DATA: searchResults: ${searchResults.length}');
      // log(
      //   'DATA: searchResults: subset: ${(searchResults.isNotEmpty) ? searchResults.sublist(start, end) : []}',
      // );

      emit(
        state.copyWith(
          searchStatus: NetworkDevicesSearchStatus.idle,
          devices: (searchResults.isNotEmpty)
              ? searchResults.sublist(start, end)
              : [],
          total: searchResults.length,
          page: event.start,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          searchStatus: NetworkDevicesSearchStatus.idle,
          error: e.toString(),
        ),
      );
    }
  }

  void _updateItemsPerPage(
    UpdateItemsPerPage event,
    Emitter<NetworkDevicesState> emit,
  ) {
    if (event.itemsPerPage != state.itemsPerPage) {
      emit(state.copyWith(itemsPerPage: event.itemsPerPage));

      add(LoadNetworkDevices(state.page, event.itemsPerPage));
    }
  }

  void _updatePagesPerView(
    UpdatePagesPerView event,
    Emitter<NetworkDevicesState> emit,
  ) {
    if (event.pagesPerView != state.pagesPerView) {
      emit(state.copyWith(pagesPerView: event.pagesPerView));
    }
  }

  Future<void> _deleteNetworkDevice(
    DeleteNetworkDevice event,
    Emitter<NetworkDevicesState> emit,
  ) async {
    emit(state.copyWith(itemStatus: NetworkDevicesItemStateStatus.loading));
    try {
      bool isDeleted = await piholeRepository.deleteNetworkDevice(
        event.networkDevice,
      );
      if (!isDeleted) {
        emit(
          state.copyWith(
            itemStatus: NetworkDevicesItemStateStatus.failure,
            error: "Failed to delete",
          ),
        );
        return;
      }

      // ignoring the deleted item
      final updatedDevices = state.devices
          .where((d) => d.id != event.networkDevice.id)
          .toList();
      final updatedLoadedDevices = state.loadedDevices
          .where((d) => d.id != event.networkDevice.id)
          .toList();
      final updatedBaseDevices = state.baseDevices
          .where((d) => d.id != event.networkDevice.id)
          .toList();
      emit(
        state.copyWith(
          devices: updatedDevices,
          loadedDevices: updatedLoadedDevices,
          baseDevices: updatedBaseDevices,
          itemStatus: NetworkDevicesItemStateStatus.success,
          message: "Successfully Deleted",
        ),
      );

      /// Notification shows second time if we did not reset it
      emit(state.copyWith(itemStatus: NetworkDevicesItemStateStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(
          itemStatus: NetworkDevicesItemStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}
