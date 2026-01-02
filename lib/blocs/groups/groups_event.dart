part of 'groups_bloc.dart';

sealed class GroupsEvent extends Equatable {
  const GroupsEvent();

  @override
  List<Object> get props => [];
}

final class LoadGroups extends GroupsEvent {
  const LoadGroups();
}

final class GroupItemToggled extends GroupsEvent {
  const GroupItemToggled({required this.groupModel, required this.isEnabled});

  final GroupModel groupModel;
  final bool isEnabled;

  @override
  List<Object> get props => [groupModel, isEnabled];
}

final class UpdateGroupsItem extends GroupsEvent {
  const UpdateGroupsItem({
    required this.groupModel,
    required this.comment,
    required this.enabled,
    required this.name,
  });

  final GroupModel groupModel;
  final String comment;
  final bool enabled;
  final String name;

  @override
  List<Object> get props => [groupModel, comment, enabled, name];
}

final class AddGroupsItem extends GroupsEvent {
  const AddGroupsItem({required this.groupModel});

  final GroupModel groupModel;

  @override
  List<Object> get props => [groupModel];
}

final class DeleteGroupsItem extends GroupsEvent {
  const DeleteGroupsItem({required this.groupModel});

  final GroupModel groupModel;

  @override
  List<Object> get props => [groupModel];
}

final class ResetItemToggleError extends GroupsEvent {}

final class GroupsSelectionChanged extends GroupsEvent {
  final List<GroupModel> groups;
  const GroupsSelectionChanged(this.groups);
}

class ResetGroupsSelection extends GroupsEvent {}

class PreSelectedGroupsSelection extends GroupsEvent {}
