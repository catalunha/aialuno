import 'package:flutter/material.dart';
import 'package:aialuno/plataforma/recursos.dart';
import 'package:aialuno/naosuportato/url_launcher.dart' if (dart.library.io) 'package:url_launcher/url_launcher.dart';

class Versao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Versão & Suporte'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Versão Android: 1.0.1 (2). Versão Chrome: 20200213"),
          ),
          // ListTile(
          //   title: Text("Suporte via WhatsApp pelo número +55 63 984495507"),
          //   trailing: Icon(Icons.phonelink_ring),
          // ),
          // ListTile(
          //   title: Text("Suporte via email em brintec.education@gmail.com"),
          //   trailing: Icon(Icons.email),
          // ),
          ListTile(
            title: Text('Click aqui para ir ao tutorial'),
            trailing: Icon(Icons.help),
            onTap: () {
              try {
                launch('https://drive.google.com/open?id=1xQXXs0rrlbU7MtwwTTNCIU46VsOI4v2g2dHY4xqcwI0');
              } catch (e) {}
            },
          ),
          // Container(
          //   alignment: Alignment.center,
          //   child: Image.asset('assets/imagem/logo2.png'),
          // ),
        ],
      ),
    );
  }
}
