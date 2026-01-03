import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/models/lists_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/lists_update_model.dart';

part 'lists_event.dart';
part 'lists_state.dart';

class ListsBloc extends Bloc<ListsEvent, ListsState> {
  final PiholeRepository piholeRepository;

  ListsBloc(this.piholeRepository) : super(ListsState()) {
    on<LoadLists>(_loadLists);
    on<ListItemToggled>(_onListToggled);
    on<UpdateListsItem>(_updateListsItem);
    on<AddListsItem>(_addListsItem);
    on<DeleteListsItem>(_deleteListsItem);
    on<ResetItemToggleError>(_resetToggleError);
  }

  void _loadLists(LoadLists event, Emitter<ListsState> emit) async {
    emit(
      state.copyWith(
        status: ListsStateStatus.loading,
        itemStatus: ListsItemStateStatus.initial,
      ),
    );
    try {
      final lists = await piholeRepository.getListsData();
      emit(state.copyWith(status: ListsStateStatus.success, lists: lists));
    } catch (e) {
      emit(
        state.copyWith(status: ListsStateStatus.failure, error: e.toString()),
      );
    }
  }

  void _resetToggleError(ResetItemToggleError event, Emitter<ListsState> emit) {
    emit(
      state.copyWith(
        itemToggleStatus: ListsItemToggleStateStatus.initial,
        toggleError: "",
      ),
    );
  }

  Future<void> _onListToggled(
    ListItemToggled event,
    Emitter<ListsState> emit,
  ) async {
    emit(state.copyWith(itemToggleStatus: ListsItemToggleStateStatus.loading));
    try {
      final newList = event.listsModel.copyWith(enabled: event.isEnabled);
      ListUpdateModel listUpdateModel = await piholeRepository.updateListsItem(
        newList,
      );

      final updatedListsModel = listUpdateModel.lists.first;

      final updatedLists = state.lists
          .map((d) => d.id == updatedListsModel.id ? updatedListsModel : d)
          .toList();

      emit(
        state.copyWith(
          lists: updatedLists,
          itemToggleStatus: ListsItemToggleStateStatus.success,
          message: "Successfully Updated",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          itemToggleStatus: ListsItemToggleStateStatus.failure,
          toggleError: e.toString(),
        ),
      );
    }
  }

  Future<void> _updateListsItem(
    UpdateListsItem event,
    Emitter<ListsState> emit,
  ) async {
    emit(state.copyWith(itemStatus: ListsItemStateStatus.loading));
    try {
      final newList = event.listsModel.copyWith(
        type: event.type,
        comment: event.comment,
        enabled: event.enabled,
        groups: event.groups,
      );

      ListUpdateModel listUpdateModel = await piholeRepository.updateListsItem(
        newList,
      );

      final updatedListsModel = listUpdateModel.lists.first;

      final updatedLists = state.lists
          .map((d) => d.id == updatedListsModel.id ? updatedListsModel : d)
          .toList();

      emit(
        state.copyWith(
          lists: updatedLists,
          itemStatus: ListsItemStateStatus.success,
          message: "Successfully Updated",
        ),
      );
      emit(
        state.copyWith(
          itemStatus: ListsItemStateStatus.success,
          message: "Successfully Updated",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          itemStatus: ListsItemStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _addListsItem(
    AddListsItem event,
    Emitter<ListsState> emit,
  ) async {
    emit(state.copyWith(itemStatus: ListsItemStateStatus.loading));
    try {
      ListUpdateModel listUpdateModel = await piholeRepository.addListsItem(
        event.listsModel,
      );
      final lists = [...state.lists, listUpdateModel.lists.first];

      emit(
        state.copyWith(
          lists: lists,
          itemStatus: ListsItemStateStatus.success,
          message: "Successfully Added",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          itemStatus: ListsItemStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _deleteListsItem(
    DeleteListsItem event,
    Emitter<ListsState> emit,
  ) async {
    emit(state.copyWith(itemStatus: ListsItemStateStatus.loading));
    try {
      bool isDeleted = await piholeRepository.deleteListsItem(event.listsModel);
      if (!isDeleted) {
        emit(
          state.copyWith(
            itemStatus: ListsItemStateStatus.failure,
            error: "Failed to delete",
          ),
        );
        return;
      }

      // ignoring the deleted item
      final updatedLists = state.lists
          .where((d) => d.id != event.listsModel.id)
          .toList();
      emit(
        state.copyWith(
          lists: updatedLists,
          itemStatus: ListsItemStateStatus.success,
          message: "Successfully Deleted",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          itemStatus: ListsItemStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}
