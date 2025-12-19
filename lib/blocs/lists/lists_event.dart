part of 'lists_bloc.dart';

sealed class ListsEvent extends Equatable {
  const ListsEvent();

  @override
  List<Object> get props => [];
}

final class LoadLists extends ListsEvent {
  const LoadLists();
}

final class ListItemToggled extends ListsEvent {
  const ListItemToggled({required this.listsModel, required this.isEnabled});

  final ListsModel listsModel;
  final bool isEnabled;

  @override
  List<Object> get props => [listsModel, isEnabled];
}

final class UpdateListsItem extends ListsEvent {
  const UpdateListsItem({
    required this.listsModel,
    required this.type,
    required this.comment,
    required this.enabled,
    required this.groups,
  });

  final ListsModel listsModel;
  final String type;
  final String comment;
  final bool enabled;
  final List<int> groups;

  @override
  List<Object> get props => [listsModel, type, comment, enabled, groups];
}

final class AddListsItem extends ListsEvent {
  const AddListsItem({required this.listsModel});

  final ListsModel listsModel;

  @override
  List<Object> get props => [listsModel];
}

final class DeleteListsItem extends ListsEvent {
  const DeleteListsItem({required this.listsModel});

  final ListsModel listsModel;

  @override
  List<Object> get props => [listsModel];
}
