import 'package:aialuno/models/classroom_model.dart';
import 'package:aialuno/states/types_states.dart';
import 'package:meta/meta.dart';

@immutable
class ClassroomState {
  final ClassroomFilter classroomFilter;
  final List<ClassroomModel> classroomList;
  final ClassroomModel classroomCurrent;
  ClassroomState({
    this.classroomFilter,
    this.classroomList,
    this.classroomCurrent,
  });
  factory ClassroomState.initialState() => ClassroomState(
        classroomFilter: ClassroomFilter.isActive,
        classroomList: <ClassroomModel>[],
        classroomCurrent: null,
      );
  ClassroomState copyWith({
    ClassroomFilter classroomFilter,
    List<ClassroomModel> classroomList,
    ClassroomModel classroomCurrent,
  }) =>
      ClassroomState(
        classroomFilter: classroomFilter ?? this.classroomFilter,
        classroomList: classroomList ?? this.classroomList,
        classroomCurrent: classroomCurrent ?? this.classroomCurrent,
      );
  @override
  int get hashCode =>
      classroomFilter.hashCode ^
      classroomList.hashCode ^
      classroomCurrent.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassroomState &&
          classroomFilter == other.classroomFilter &&
          classroomList == other.classroomList &&
          classroomCurrent == other.classroomCurrent &&
          runtimeType == other.runtimeType;
}
