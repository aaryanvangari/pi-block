part of 'lists_bloc.dart';

@immutable
abstract class ListsEvent {}

class LoadLists extends ListsEvent {}

class AddLists extends ListsEvent {
  final ListsModel listsModel;

  AddLists(this.listsModel);
}

class UpdateLists extends ListsEvent {
  final ListsModel listsModel;

  UpdateLists(this.listsModel);
}

class DeleteLists extends ListsEvent {
  final ListsModel listsModel;

  DeleteLists(this.listsModel);
}
