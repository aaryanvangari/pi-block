import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/models/lists_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/lists_update_model.dart';
import 'package:rxdart/subjects.dart';

part 'lists_event.dart';
part 'lists_state.dart';

class ListsBloc extends Bloc<ListsEvent, ListsState> {
  final PiholeRepository piholeRepository;

  late final _listStreamController = BehaviorSubject<List<ListsModel>>.seeded(
    const [],
  );

  ListsBloc(this.piholeRepository) : super(ListsState()) {
    on<LoadLists>(_loadLists);
    on<ListItemToggled>(_onListToggled);
    on<UpdateListsItem>(_updateListsItem);
    on<AddListsItem>(_addListsItem);
    on<DeleteListsItem>(_deleteListsItem);
    on<ResetItemToggleError>(_resetToggleError);
    _listStreamController.add(const []);
  }

  Stream<List<ListsModel>> getLists() =>
      _listStreamController.asBroadcastStream();

  void _loadLists(LoadLists event, Emitter<ListsState> emit) async {
    emit(
      state.copyWith(
        status: ListsStateStatus.loading,
        itemStatus: ListsItemStateStatus.initial,
      ),
    );
    try {
      final lists = await piholeRepository.getListsData();
      _listStreamController.add(lists);
      await emit.forEach<List<ListsModel>>(
        getLists(),
        onData: (lists) =>
            state.copyWith(status: ListsStateStatus.success, lists: lists),
        onError: (_, _) => state.copyWith(status: ListsStateStatus.failure),
      );
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
      final lists = [..._listStreamController.value];
      final listIndex = lists.indexWhere((t) => t.id == event.listsModel.id);
      if (listIndex >= 0) {
        lists[listIndex] = listUpdateModel.lists[0];
      }
      _listStreamController.add(lists);
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
      final lists = [..._listStreamController.value];
      final listIndex = lists.indexWhere((t) => t.id == event.listsModel.id);
      if (listIndex >= 0) {
        lists[listIndex] = listUpdateModel.lists[0];
      }
      _listStreamController.add(lists);
      emit(
        state.copyWith(
          itemStatus: ListsItemStateStatus.success,
          message: "Successfully Updated",
        ),
      );

      /// Notification shows second time if we did not reset it
      emit(state.copyWith(itemStatus: ListsItemStateStatus.initial));
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
      final lists = [..._listStreamController.value];
      lists.add(listUpdateModel.lists[0]);
      _listStreamController.add(lists);
      emit(
        state.copyWith(
          itemStatus: ListsItemStateStatus.success,
          message: "Successfully Added",
        ),
      );

      /// Notification shows second time if we did not reset it
      emit(state.copyWith(itemStatus: ListsItemStateStatus.initial));
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
      if (isDeleted) {
        final lists = [..._listStreamController.value];
        final listIndex = lists.indexWhere((t) => t.id == event.listsModel.id);
        if (listIndex >= 0) {
          lists.removeAt(listIndex);
        }
        _listStreamController.add(lists);
        emit(
          state.copyWith(
            itemStatus: ListsItemStateStatus.success,
            message: "Successfully Deleted",
          ),
        );
      }

      /// Notification shows second time if we did not reset it
      emit(state.copyWith(itemStatus: ListsItemStateStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(
          itemStatus: ListsItemStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _listStreamController.close();
    return super.close();
  }
}
