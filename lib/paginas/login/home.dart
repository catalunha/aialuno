import 'package:aialuno/paginas/login/bemvindo_page.dart';
import 'package:flutter/material.dart';
import 'package:aialuno/auth_bloc.dart';
import 'package:aialuno/componentes/login_required.dart';
import 'package:aialuno/paginas/tarefa/tarefa_aberta_list_page.dart';


class HomePage extends StatefulWidget {
final AuthBloc authBloc;
  HomePage(this.authBloc);

  _HomePageState createState() => _HomePageState(this.authBloc);
}

class _HomePageState extends State<HomePage> {
  final AuthBloc authBloc;
  _HomePageState(this.authBloc);

  @override
  Widget build(BuildContext context) {
    print('homepage');
    return DefaultLoginRequired(
      // child: BemVindoPage(widget.authBloc),
      child: TarefaAbertaListPage(widget.authBloc),
      authBloc: this.authBloc,
    );
  }
}
