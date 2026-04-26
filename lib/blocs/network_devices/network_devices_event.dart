part of 'network_devices_bloc.dart';

sealed class NetworkDevicesEvent extends Equatable {
  const NetworkDevicesEvent();

  @override
  List<Object> get props => [];
}

final class LoadNetworkDevices extends NetworkDevicesEvent {
  final int start;
  final int itemsPerPage;
  const LoadNetworkDevices(this.start, this.itemsPerPage);

  @override
  List<Object> get props => [start, itemsPerPage];
}

final class RefreshNetworkDevices extends NetworkDevicesEvent {
  const RefreshNetworkDevices();

  @override
  List<Object> get props => [];
}

final class SearchNetworkDevices extends NetworkDevicesEvent {
  final String searchTerm;
  final int start;
  final int itemsPerPage;
  const SearchNetworkDevices(this.searchTerm, this.start, this.itemsPerPage);

  @override
  List<Object> get props => [start, itemsPerPage];
}

class ClearNetworkDevicesSearch extends NetworkDevicesEvent {}

class UpdateCurrentPage extends NetworkDevicesEvent {
  final int page;

  const UpdateCurrentPage(this.page);

  @override
  List<Object> get props => [page];
}

final class DeleteNetworkDevice extends NetworkDevicesEvent {
  const DeleteNetworkDevice({required this.networkDevice});

  final Device networkDevice;

  @override
  List<Object> get props => [networkDevice];
}

class UpdateItemsPerPage extends NetworkDevicesEvent {
  final int itemsPerPage;
  const UpdateItemsPerPage(this.itemsPerPage);

  @override
  List<Object> get props => [itemsPerPage];
}

class UpdatePagesPerView extends NetworkDevicesEvent {
  final int pagesPerView;
  const UpdatePagesPerView(this.pagesPerView);

  @override
  List<Object> get props => [pagesPerView];
}
