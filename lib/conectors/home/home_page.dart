import 'package:aialuno/models/user_model.dart';
import 'package:aialuno/states/app_state.dart';
import 'package:aialuno/uis/home/home_page_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  UserModel userModel;

  ViewModel();
  ViewModel.build({
    @required this.userModel,
  }) : super(equals: [
          userModel,
        ]);

  @override
  ViewModel fromStore() => ViewModel.build(
        userModel: state.loggedState.userModelLogged,
      );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      builder: (BuildContext context, ViewModel viewModel) => HomePageDS(
        userModel: viewModel.userModel,
      ),
    );
  }
}
