import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:snack/snack.dart';

import '../../controllers/cnpj_controller.dart';
import '../model/cnpj.dart';
import '../util/contants.dart' as constants;

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title, Key? key}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = CnpjController();
  final _formKeyLogin = GlobalKey<FormState>();
  final _logradouroController = TextEditingController();
  final _situacaoCadastralController = TextEditingController();
  final _nomeController = TextEditingController();
  final _naturezaJuridicaController = TextEditingController();
  final _cnaeController = TextEditingController();
  final _capitalSocialController = TextEditingController();
  final _phoneController = TextEditingController();
  final _sociosController = TextEditingController();
  final _cnpjController = TextEditingController();
  final maskFormatter = MaskTextInputFormatter(
      mask: '##.###.###/####-##', filter: {'#': RegExp(r'[0-9]')});

  bool isDarkModeEnabled = false;

  List<String> nomeSocios = [];
  Map mapSocios = {};

  var _validate = false;

  void _getData() async {
    final cnpj = await _controller.getData(_cnpjController.text);

    if (cnpj.status == 'OK') {
      _setValues(cnpj);
    } else {
      _error(cnpj.message, context);
    }
  }

  void _error(String errorMsg, context) {
    final message = SnackBar(content: Text(errorMsg));
    message.show(context);
  }

  void _setValues(Cnpj cnpj) {
    var socios;
    final capitalSocial =
        NumberFormat.currency(locale: 'pt-br').format(cnpj.capitalSocial);

    //List<dynamic> teste = res["qsa"];
    //print('teste: $teste, ${teste.length}, (${teste.length - 1})');

    // while (counter <= (teste.length - 1)) {
    //   nomeSocios.add(
    //       '${res["qsa"][counter]['nome']} (${res["qsa"][counter]['qual']})\n\n');

    //   counter++;
    // }
    //  print('nomeSocios: $nomeSocios');
    socios = nomeSocios.isNotEmpty ? nomeSocios : constants.qsaNull;
    // socios = teste.toString();

    _sociosController.text = cnpj.fixSocios(socios.toString());

    _phoneController.text = 'Telefone: ${cnpj.telefone}\nE-mail: ${cnpj.email}';

    _capitalSocialController.text =
        'R\$ ${capitalSocial.replaceAll('BRL', '')}';

    if (cnpj.atividadePrincipal.isNotEmpty) {
      if (cnpj.atividadePrincipal[0].text != '********') {
        _cnaeController.text =
            // ignore: lines_longer_than_80_chars
            'Atividade Principal: ${cnpj.atividadePrincipal[0].text} \nCódigo: ${cnpj.atividadePrincipal[0].code}';
      } else {
        _cnaeController.text = '-';
      }
    } else {
      _cnaeController.text = '-';
    }

    _naturezaJuridicaController.text = cnpj.naturezaJuridica;

    _situacaoCadastralController.text = cnpj.situacao;

    _nomeController.text =
        'Razão Social: ${cnpj.nome} \nNome Fantasia: ${cnpj.fantasia}';

    _logradouroController.text =
        // ignore: lines_longer_than_80_chars
        'Logradouro: ${cnpj.logradouro} \nNº: ${cnpj.numero} \nComplemento: ${cnpj.complemento} \nCEP: ${cnpj.cep} \nBairro: ${cnpj.bairro} \nCidade: ${cnpj.municipio}';

    _cnpjController.text = cnpj.cnpj;
  }

  @override
  Widget build(BuildContext context) {
    final txtLogradouro = TextFormField(
      // key: _formKeyLogin,
      maxLines: null,
      enabled: false,
      controller: _logradouroController,
      decoration: InputDecoration(labelText: 'Endereço'),
    );
    final txtCNPJ = TextField(
      inputFormatters: [maskFormatter],
      maxLength: 18,
      toolbarOptions: ToolbarOptions(
        cut: true,
        copy: true,
        selectAll: true,
        paste: true,
      ),
      enabled: true,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.numberWithOptions(),
      controller: _cnpjController,
      autofocus: true,
      cursorColor: Color(0xff3CC37E), //Colors.amber,
      style: TextStyle(
          height: 1.5,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xff3CC37E)),
      cursorWidth: 5.0,
      //increases the height of cursor
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Color(0xff3CC37E), //Colors.amber,
              style: BorderStyle.solid,
            ),
          ),
          labelText: 'CNPJ',
          errorText:
              _validate == true ? 'Informe um CNPJ válido por favor!' : null,
          hintText: 'Digite um CNPJ'),
    );
    final txtNaturezaJuridica = TextFormField(
      maxLines: null,
      enabled: false,
      controller: _naturezaJuridicaController,
      decoration: InputDecoration(labelText: 'Natureza Jurídica'),
    );
    final txtCNAE = TextFormField(
        maxLines: null,
        enabled: false,
        controller: _cnaeController,
        decoration: InputDecoration(labelText: 'CNAE'));
    final txtCapitalSocial = TextFormField(
      maxLines: null,
      enabled: false,
      controller: _capitalSocialController,
      decoration: InputDecoration(labelText: 'Capital Social'),
    );
    final txtNome = TextFormField(
      maxLines: null,
      enabled: false,
      controller: _nomeController,
      decoration: InputDecoration(labelText: 'Nome'),
    );
    final txtPhone = TextFormField(
      maxLines: null,
      enabled: false,
      controller: _phoneController,
      decoration: InputDecoration(labelText: 'Contato'),
    );
    final txtSituacaoCadastral = TextFormField(
      enabled: false,
      controller: _situacaoCadastralController,
      //style: TextStyle(color: Colors.green),
      decoration: InputDecoration(labelText: 'Situação Cadastral'),
      // style: TextStyle(color: Colors.blue),
    );
    final txtSocios = TextFormField(
      enabled: false,
      maxLines: null,
      controller: _sociosController,
      //style: TextStyle(color: Colors.green),
      decoration: InputDecoration(labelText: 'Quadro Societário'),
    );

    final scaffold = Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.print,
              color: Colors.white,
            ),
            onPressed: () {
              DayNightSwitcherIcon(
                isDarkModeEnabled: isDarkModeEnabled,
                onStateChanged: (isDarkModeEnabled) {
                  setState(() {
                    this.isDarkModeEnabled = isDarkModeEnabled;
                  });
                },
              );
            },
          )
        ],
        backgroundColor: Color(0xff1E392A),
      ),
      body: Container(
        // decoration: BoxDecoration(color: Colors.white),
        //  padding: EdgeInsets.all(16),
        child: Form(
          key: _formKeyLogin,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  txtCNPJ,
                  txtSituacaoCadastral,
                  txtNome,
                  txtNaturezaJuridica,
                  txtCNAE,
                  txtCapitalSocial,
                  txtLogradouro,
                  txtPhone,
                  txtSocios
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_cnpjController.text.isEmpty ||
                _cnpjController.text.length != 18) {
              _validate = true;
            } else {
              _validate = false;
              _getData();
            }
          });
        },
        tooltip: 'Pesquisar',
        backgroundColor: Color(0xff1E392A),
        child: Icon(Icons.search),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
    return scaffold;
  }
}
