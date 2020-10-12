import 'package:aialuno/conectors/task/task_edit.dart';
import 'package:aialuno/conectors/task/task_list.dart';
import 'package:aialuno/conectors/welcome.dart';
import 'package:aialuno/states/app_state.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class Routes {
  static final welcome = '/';
  static final taskList = '/taskList';
  static final taskEdit = '/taskEdit';
  static final routes = {
    welcome: (BuildContext context) => UserExceptionDialog<AppState>(
          child: Welcome(),
        ),
    taskList: (BuildContext context) => TaskList(),
    taskEdit: (BuildContext context) => TaskEdit(),
  };
}

class Keys {
  static final navigatorStateKey = GlobalKey<NavigatorState>();
}
