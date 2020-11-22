import 'package:aialuno/actions/logged_action.dart';
import 'package:aialuno/routes.dart';
import 'package:aialuno/states/app_state.dart';
import 'package:aialuno/uis/components/logout_button_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends Vm {
  final void Function() logout;

  ViewModel({
    @required this.logout,
  }) : super(equals: []);
}

class Factory extends VmFactory<AppState, LogoutButton> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        logout: () {
          dispatch(LogoutAsyncLoggedAction());
          dispatch(NavigateAction.pushNamedAndRemoveAll(Routes.welcome));
        },
      );
}

class LogoutButton extends StatelessWidget {
  LogoutButton({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      builder: (BuildContext context, ViewModel viewModel) {
        return LogoutButtonDS(
          logout: viewModel.logout,
        );
      },
    );
  }
}
