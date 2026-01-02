part of 'groups_bloc.dart';

enum GroupsStateStatus { initial, loading, success, failure, empty }

enum GroupsItemStateStatus { initial, loading, success, failure }

enum GroupsItemToggleStateStatus { initial, loading, success, failure }

class GroupsState extends Equatable {
  final List<GroupModel> groups;
  final GroupsStateStatus status;
  final GroupsItemStateStatus itemStatus;
  final GroupsItemToggleStateStatus itemToggleStatus;
  final String toggleError;
  final String error;
  final String message;
  final List<GroupModel> selectedGroups;
  const GroupsState({
    this.groups = const [],
    this.status = GroupsStateStatus.initial,
    this.itemStatus = GroupsItemStateStatus.initial,
    this.itemToggleStatus = GroupsItemToggleStateStatus.initial,
    this.error = "",
    this.toggleError = "",
    this.message = "",
    this.selectedGroups = const [],
  });

  GroupsState copyWith({
    List<GroupModel>? groups,
    GroupsStateStatus? status,
    GroupsItemStateStatus? itemStatus,
    GroupsItemToggleStateStatus? itemToggleStatus,
    String? error,
    String? toggleError,
    String? message,
    List<GroupModel>? selectedGroups,
  }) {
    return GroupsState(
      groups: groups ?? this.groups,
      status: status ?? this.status,
      itemStatus: itemStatus ?? this.itemStatus,
      itemToggleStatus: itemToggleStatus ?? this.itemToggleStatus,
      error: error ?? this.error,
      toggleError: toggleError ?? this.toggleError,
      message: message ?? this.message,
      selectedGroups: selectedGroups ?? this.selectedGroups,
    );
  }

  @override
  List<Object?> get props => [
    groups,
    status,
    itemStatus,
    itemToggleStatus,
    error,
    toggleError,
    message,
    selectedGroups,
  ];
}
