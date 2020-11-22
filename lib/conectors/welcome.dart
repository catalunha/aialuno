import 'package:aialuno/conectors/classroom/classroom_list.dart';
import 'package:aialuno/conectors/login/login_page.dart';
import 'package:aialuno/states/app_state.dart';
import 'package:aialuno/states/types_states.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';

class ViewModel extends Vm {
  final bool logged;
  ViewModel({
    @required this.logged,
  }) : super(equals: [
          logged,
        ]);
}

class Factory extends VmFactory<AppState, Welcome> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
      logged: state.loggedState.authenticationStatusLogged ==
              AuthenticationStatusLogged.authenticated
          ? true
          : false);
}

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      builder: (BuildContext context, ViewModel viewModel) =>
          // viewModel.logged ? HomePage() : LoginPage(),
          viewModel.logged ? ClassroomList() : LoginPage(),
    );
  }
}
