import 'package:aialuno/states/types_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPageDS extends StatefulWidget {
  final Function(String) sendPasswordResetEmail;
  final Function(String, String) loginEmailPassword;
  final AuthenticationStatusLogged authenticationStatusLogged;
  const LoginPageDS({
    Key key,
    this.loginEmailPassword,
    this.authenticationStatusLogged,
    this.sendPasswordResetEmail,
  }) : super(key: key);
  @override
  LoginPageDSState createState() {
    return LoginPageDSState();
  }
}

class LoginPageDSState extends State<LoginPageDS> {
  final _formKeyLogin = GlobalKey<FormState>();
  String _userName;
  String _password;
  void validateInputsLogin() {
    if (_formKeyLogin.currentState.validate()) {
      _formKeyLogin.currentState.save();
      print(_password);
      if (_password != null && _password.isNotEmpty) {
        widget.loginEmailPassword(
          _userName,
          _password,
        );
      }
    } else {
      setState(() {});
    }
  }

  void validateInputsResetPassword() {
    if (_formKeyLogin.currentState.validate()) {
      _formKeyLogin.currentState.save();
      widget.sendPasswordResetEmail(_userName);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('AI Aluno - Acessar')),
        ),
        body: Center(
          child: Container(
            width: 350,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKeyLogin,
                child: ListView(
                  children: <Widget>[
                    Text('Informe os dados'),
                    TextFormField(
                      // initialValue: 'catalunha@uft.edu.br',
                      decoration: InputDecoration(
                        labelText: 'Email:',
                      ),
                      onSaved: (value) => _userName = value.trim(),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Informe o email.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      // initialValue: 'aialuno',
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha:',
                      ),
                      onSaved: (value) => _password = value,
                    ),
                    Card(
                      child: ListTile(
                        title: Center(
                            child: Text('Acessar com este email e senha')),
                        trailing: Icon(Icons.verified_user),
                        onTap: () {
                          validateInputsLogin();
                        },
                      ),
                    ),
                    ListTile(
                      title: Center(child: Text('Pedir nova senha por email.')),
                      trailing: Icon(Icons.settings_backup_restore),
                      onTap: () {
                        validateInputsResetPassword();
                      },
                    ),
                    widget.authenticationStatusLogged ==
                            AuthenticationStatusLogged.authenticating
                        ? Center(child: CircularProgressIndicator())
                        : Container(),
                    widget.authenticationStatusLogged ==
                            AuthenticationStatusLogged.unAuthenticated
                        ? Center(
                            child: Text(
                                'Obs.: Verifique Email e a Senha por favor.'))
                        : Container(),
                    widget.authenticationStatusLogged ==
                            AuthenticationStatusLogged.unInitialized
                        ? Center(
                            child: Text(
                                'Obs.: Estamos aguardando você informar email e senha.'))
                        : Container(),
                    widget.authenticationStatusLogged ==
                            AuthenticationStatusLogged.authenticated
                        ? Center(child: Text('Obs.: Acesso liberado.'))
                        : Container(),
                    widget.authenticationStatusLogged ==
                            AuthenticationStatusLogged.sendPasswordReset
                        ? Center(
                            child:
                                Text('Obs.: Veja seu email para nova senha.'))
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
