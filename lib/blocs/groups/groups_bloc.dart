import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/groups_model.dart';
import 'package:pi_block/models/groups_update_model.dart';
import 'package:rxdart/subjects.dart';

part 'groups_event.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final PiholeRepository piholeRepository;

  late final _groupstreamController = BehaviorSubject<List<GroupModel>>.seeded(
    const [],
  );

  GroupsBloc(this.piholeRepository) : super(GroupsState()) {
    on<LoadGroups>(_loadGroups);
    on<GroupItemToggled>(_onGroupToggled);
    on<UpdateGroupsItem>(_updateGroupsItem);
    on<AddGroupsItem>(_addGroupsItem);
    on<DeleteGroupsItem>(_deleteGroupsItem);
    on<ResetItemToggleError>(_resetToggleError);
    on<GroupsSelectionChanged>(_groupSelectionChanged);
    on<ResetGroupsSelection>(_resetGroupsSelection);
    _groupstreamController.add(const []);
  }

  Stream<List<GroupModel>> getGroups() =>
      _groupstreamController.asBroadcastStream();

  void _loadGroups(LoadGroups event, Emitter<GroupsState> emit) async {
    emit(
      state.copyWith(
        status: GroupsStateStatus.loading,
        itemStatus: GroupsItemStateStatus.initial,
      ),
    );
    try {
      final groups = await piholeRepository.getGroupsData();
      _groupstreamController.add(groups);
      await emit.forEach<List<GroupModel>>(
        getGroups(),
        onData: (groups) =>
            state.copyWith(status: GroupsStateStatus.success, groups: groups),
        onError: (_, _) => state.copyWith(status: GroupsStateStatus.failure),
      );
    } catch (e) {
      emit(
        state.copyWith(status: GroupsStateStatus.failure, error: e.toString()),
      );
    }
  }

  void _resetToggleError(
    ResetItemToggleError event,
    Emitter<GroupsState> emit,
  ) {
    emit(
      state.copyWith(
        itemToggleStatus: GroupsItemToggleStateStatus.initial,
        toggleError: "",
      ),
    );
  }

  void _groupSelectionChanged(
    GroupsSelectionChanged event,
    Emitter<GroupsState> emit,
  ) {
    emit(state.copyWith(selectedGroups: event.groups));
  }

  void _resetGroupsSelection(
    ResetGroupsSelection event,
    Emitter<GroupsState> emit,
  ) {
    emit(state.copyWith(selectedGroups: []));
  }

  Future<void> _onGroupToggled(
    GroupItemToggled event,
    Emitter<GroupsState> emit,
  ) async {
    emit(state.copyWith(itemToggleStatus: GroupsItemToggleStateStatus.loading));
    try {
      final newGroup = event.groupModel.copyWith(
        enabled: event.isEnabled,

        /// this is not suggested. Ideally backend should supply updated model but
        /// in this case its not, so updating temporary model with necessary data
        date_modified: (DateTime.now().millisecondsSinceEpoch / 1000).toInt(),
      );
      await piholeRepository.updateGroupItem(newGroup, event.groupModel.name);
      final groups = [..._groupstreamController.value];
      final domainIndex = groups.indexWhere((t) => t.id == event.groupModel.id);
      if (domainIndex >= 0) {
        // groupUpdateModel is not having group data so using constructed data
        groups[domainIndex] = newGroup;
      }
      _groupstreamController.add(groups);
    } catch (e) {
      emit(
        state.copyWith(
          itemToggleStatus: GroupsItemToggleStateStatus.failure,
          toggleError: e.toString(),
        ),
      );
    }
  }

  Future<void> _updateGroupsItem(
    UpdateGroupsItem event,
    Emitter<GroupsState> emit,
  ) async {
    emit(state.copyWith(itemStatus: GroupsItemStateStatus.loading));
    try {
      final newGroup = event.groupModel.copyWith(
        comment: event.comment,
        enabled: event.enabled,
        name: event.name,

        /// this is not suggested. Ideally backend should supply updated model but
        /// in this case its not, so updating temporary model with necessary data
        date_modified: (DateTime.now().millisecondsSinceEpoch / 1000).toInt(),
      );

      await piholeRepository.updateGroupItem(newGroup, event.groupModel.name);
      final groups = [..._groupstreamController.value];
      final groupIndex = groups.indexWhere((t) => t.id == event.groupModel.id);
      if (groupIndex >= 0) {
        // groupUpdateModel is not having group data so using constructed data
        groups[groupIndex] = newGroup;
      }
      _groupstreamController.add(groups);
      emit(
        state.copyWith(
          itemStatus: GroupsItemStateStatus.success,
          message: "Successfully Updated",
        ),
      );

      /// Notification shows second time if we did not reset it
      emit(state.copyWith(itemStatus: GroupsItemStateStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(
          itemStatus: GroupsItemStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _addGroupsItem(
    AddGroupsItem event,
    Emitter<GroupsState> emit,
  ) async {
    emit(state.copyWith(itemStatus: GroupsItemStateStatus.loading));
    try {
      GroupUpdateModel groupUpdateModel = await piholeRepository.addGroupsItem(
        event.groupModel,
      );
      final groups = [..._groupstreamController.value];
      groups.add(groupUpdateModel.groups[0]);
      _groupstreamController.add(groups);
      emit(
        state.copyWith(
          itemStatus: GroupsItemStateStatus.success,
          message: "Successfully Added",
        ),
      );

      /// Notification shows second time if we did not reset it
      emit(state.copyWith(itemStatus: GroupsItemStateStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(
          itemStatus: GroupsItemStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _deleteGroupsItem(
    DeleteGroupsItem event,
    Emitter<GroupsState> emit,
  ) async {
    emit(state.copyWith(itemStatus: GroupsItemStateStatus.loading));
    try {
      bool isDeleted = await piholeRepository.deleteGroupsItem(
        event.groupModel,
      );
      if (isDeleted) {
        final groups = [..._groupstreamController.value];
        final groupIndex = groups.indexWhere(
          (t) => t.id == event.groupModel.id,
        );
        if (groupIndex >= 0) {
          groups.removeAt(groupIndex);
        }
        _groupstreamController.add(groups);
        emit(
          state.copyWith(
            itemStatus: GroupsItemStateStatus.success,
            message: "Successfully Deleted",
          ),
        );
      }

      /// Notification shows second time if we did not reset it
      emit(state.copyWith(itemStatus: GroupsItemStateStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(
          itemStatus: GroupsItemStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _groupstreamController.close();
    return super.close();
  }
}
