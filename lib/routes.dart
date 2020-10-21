import 'package:aialuno/conectors/classroom/classroom_list.dart';
import 'package:aialuno/conectors/student/student_list.dart';
import 'package:aialuno/conectors/task/task_edit.dart';
import 'package:aialuno/conectors/task/task_list.dart';
import 'package:aialuno/conectors/task/task_list_open.dart';
import 'package:aialuno/conectors/welcome.dart';
import 'package:aialuno/states/app_state.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class Routes {
  static final welcome = '/';
  static final taskList = '/taskList';
  static final taskListOpen = '/taskListOpen';
  static final taskEdit = '/taskEdit';
  static final classroomList = '/classroomList';
  static final studentList = '/studentList';

  static final routes = {
    welcome: (BuildContext context) => UserExceptionDialog<AppState>(
          child: Welcome(),
        ),
    classroomList: (BuildContext context) => ClassroomList(),
    studentList: (BuildContext context) => StudentList(),
    taskList: (BuildContext context) => TaskList(),
    taskListOpen: (BuildContext context) => TaskListOpen(),
    taskEdit: (BuildContext context) => TaskEdit(),
  };
}

class Keys {
  static final navigatorStateKey = GlobalKey<NavigatorState>();
}
