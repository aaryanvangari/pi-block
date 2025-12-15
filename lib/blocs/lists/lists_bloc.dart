import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/models/lists_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';

part 'lists_event.dart';
part 'lists_state.dart';

class ListsBloc extends Bloc<ListsEvent, ListsState> {
  final PiholeRepository piholeRepository;
  ListsBloc(this.piholeRepository) : super(ListsInitial()) {
    on<LoadLists>(_getLists);
    on<UpdateLists>(_updateLists);
    on<DeleteLists>(_deleteLists);
    on<AddLists>(_addLists);
  }

  void _getLists(LoadLists event, Emitter<ListsState> emit) async {
    emit(ListsLoading());
    try {
      final lists = await piholeRepository.getListsData();
      emit(ListsLoaded(lists));
    } catch (e) {
      emit(ListsError(e.toString()));
    }
  }

  void _updateLists(UpdateLists event, Emitter<ListsState> emit) async {
    emit(ListsLoading());
    try {
      await piholeRepository.updateListsItem(event.listsModel);
      emit(ListsItemOperationSuccess("Successfully Updated"));

      /// #TODO update item inline without loading whole list again
      emit(ListsOperationSuccess(""));
    } catch (e) {
      emit(ListsError(e.toString()));
    }
  }

  void _deleteLists(DeleteLists event, Emitter<ListsState> emit) async {
    emit(ListsLoading());
    try {
      await piholeRepository.deleteListsItem(event.listsModel);
      emit(ListsItemOperationSuccess("Successfully Deleted"));
      emit(ListsOperationSuccess(""));
    } catch (e) {
      emit(ListsError(e.toString()));
    }
  }

  void _addLists(AddLists event, Emitter<ListsState> emit) async {
    emit(ListsLoading());
    try {
      await piholeRepository.addListsItem(event.listsModel);
      emit(ListsItemOperationSuccess("Successfully Added"));
      emit(ListsOperationSuccess(""));
    } catch (e) {
      emit(ListsError(e.toString()));
    }
  }
}

/*
class ListsBloc extends Bloc<ListsEvent, ListsState> {
  final PiholeRepository piholeRepository;
  List<ListsModel> lists = [];
  ListsBloc(this.piholeRepository) : super(ListsState()) {
    on<ListsFetched>(_getLists);
    on<ListItemEnableDisable>(_updateList);
  }

  void _getLists(ListsFetched event, Emitter<ListsState> emit) async {
    emit(state.copyWith(status: ListsStateStatus.loading));
    try {
      lists = await piholeRepository.getListsData();
      if (lists.isEmpty) {
        emit(state.copyWith(lists: [], status: ListsStateStatus.empty));
      } else {
        emit(state.copyWith(lists: lists, status: ListsStateStatus.success));
      }
    } catch (e) {
      addError(e);
      emit(
        state.copyWith(status: ListsStateStatus.failure, error: e.toString()),
      );
    }
  }

  void _updateList(
    ListItemEnableDisable event,
    Emitter<ListsState> emit,
  ) async {
    // emit(ListsLoading());
    try {
      final listUpdate = await piholeRepository.onListStateChanged(
        event.value,
        event.item,
      );
      final newLists = state.lists.asMap().forEach((index, value) {
        if (value.id == event.item.id) {
          state.lists[index] = listUpdate.lists[0];
        }
      });
      // final newLists = state.lists;
      // emit(ListsModified(lists: state.lists, status: ListsStateStatus.success));
      emit(
        ListsModified(
          lists: state.copyWith(lists: newLists),
          status: ListsStateStatus.success,
        ),
      );
      // state.copyWith(status: ListsStateStatus.success, lists: state.lists),
      // );
      // state.lists.emit(ListsModified(listUpdateModel: listUpdate));
    } catch (e) {
      addError(e);
      emit(
        state.copyWith(status: ListsStateStatus.failure, error: e.toString()),
      );
    }
  }
}
*/
