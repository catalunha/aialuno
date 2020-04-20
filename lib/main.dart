import 'package:aialuno/paginas/login/login.dart';
import 'package:flutter/material.dart';
import 'package:aialuno/bootstrap.dart';
import 'package:aialuno/paginas/avaliacao/avaliacao_list_page.dart';
import 'package:aialuno/paginas/desenvolvimento/desenvolvimento_page.dart';
import 'package:aialuno/paginas/login/home.dart';
import 'package:aialuno/paginas/login/versao.dart';
import 'package:aialuno/paginas/tarefa/tarefa_aberta_list_page.dart';
import 'package:aialuno/paginas/tarefa/tarefa_aberta_responder_page.dart';
import 'package:aialuno/paginas/tarefa/tarefa_list_page.dart';
import 'package:aialuno/paginas/turma/turma_list_page.dart';
import 'package:aialuno/paginas/upload/uploader_page.dart';
import 'package:aialuno/paginas/usuario/perfil_page.dart';
import 'package:aialuno/plataforma/recursos.dart';
import 'package:aialuno/web.dart';

void main() {
  webSetUp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = Bootstrap.instance.authBloc;
    Recursos.initialize(Theme.of(context).platform);
  // Intl.defaultLocale = 'pt_br';

    return MaterialApp(
      title: 'AI - Aluno',
      theme: ThemeData.dark(),
      // initialRoute: "/tarefa/aberta",
      initialRoute: "/",
      routes: {
        //homePage
        "/": (context) => TarefaAbertaListPage(authBloc),
        "/sair": (context) => LoginPage(authBloc),

        //upload
        "/upload": (context) => UploaderPage(authBloc),

        //desenvolvimento
        "/desenvolvimento": (context) => Desenvolvimento(),

        //tarefa
        "/tarefa/aberta": (context) => TarefaAbertaListPage(authBloc),
        "/tarefa/responder": (context) {
          final settings = ModalRoute.of(context).settings;
          return TarefaAbertaResponderPage(settings.arguments);
        },
        "/tarefa/list": (context) {
          final settings = ModalRoute.of(context).settings;
          return TarefaListPage(authBloc, settings.arguments);
        },
        // "/tarefa": (context) {
        //   final settings = ModalRoute.of(context).settings;
        //   return TarefaPage(authBloc, settings.arguments);
        // },

        //turma
        "/turma/list": (context) => TurmaListPage(authBloc),

        //avaliacao
        "/avaliacao/list": (context) {
          final settings = ModalRoute.of(context).settings;
          return AvaliacaoListPage(authBloc, settings.arguments);
        },

        //questao
        // "/questao/list": (context) {
        //   final settings = ModalRoute.of(context).settings;
        //   return QuestaoListPage(settings.arguments);
        // },

        //EndDrawer
        //perfil
        "/perfil": (context) => PerfilPage(authBloc),
        //Versao
        "/versao": (context) => Versao(),
      },
    );
  }
}
