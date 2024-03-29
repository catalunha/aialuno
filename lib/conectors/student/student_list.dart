import 'package:aialuno/actions/student_action.dart';
import 'package:aialuno/uis/student/student_list_ds.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:aialuno/models/user_model.dart';
import 'package:aialuno/states/app_state.dart';

class ViewModel extends BaseModel<AppState> {
  List<UserModel> studentList;
  ViewModel();
  ViewModel.build({
    @required this.studentList,
  }) : super(equals: [
          studentList,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        studentList: state.studentState.studentList,
      );
}

class StudentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      onInit: (store) => store.dispatch(GetDocsStudentListAsyncStudentAction()),
      builder: (context, viewModel) => StudentListDS(
        studentList: viewModel.studentList,
      ),
    );
  }
}
