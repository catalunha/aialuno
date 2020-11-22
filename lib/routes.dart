import 'package:aialuno/conectors/classroom/classroom_list.dart';
import 'package:aialuno/conectors/exame/exame_list.dart';
import 'package:aialuno/conectors/student/student_list.dart';
import 'package:aialuno/conectors/task/task_edit.dart';
import 'package:aialuno/conectors/task/task_list.dart';
import 'package:async_redux/async_redux.dart';
import 'package:aialuno/conectors/welcome.dart';
import 'package:aialuno/states/app_state.dart';
import 'package:flutter/material.dart';

class Routes {
  static final welcome = '/';
  static final taskList = '/taskList';
  static final taskEdit = '/taskEdit';
  static final classroomList = '/classroomList';
  static final studentList = '/studentList';
  static final exameList = '/exameList';

  static final routes = {
    welcome: (BuildContext context) => UserExceptionDialog<AppState>(
          child: Welcome(),
        ),
    classroomList: (BuildContext context) => ClassroomList(),
    studentList: (BuildContext context) => StudentList(),
    taskList: (BuildContext context) => TaskList(),
    taskEdit: (BuildContext context) => TaskEdit(),
    exameList: (BuildContext context) => ExameList(),
  };
}

class Keys {
  static final navigatorStateKey = GlobalKey<NavigatorState>();
}
