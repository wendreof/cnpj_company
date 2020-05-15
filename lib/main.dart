import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:http/http.dart' as http;
import "package:intl/intl.dart";

import 'cnpj.dart';
import 'contants.dart' as constants;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Pesquisa CNPJ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKeyLogin = GlobalKey<FormState>();
  final _logradouroController = TextEditingController();
  final _situacaoCadastralController = TextEditingController();
  final _nomeController = TextEditingController();
  final _naturezaJuridicaController = TextEditingController();
  final _cnaeController = TextEditingController();
  final _capitalSocialController = TextEditingController();
  final _phoneController = TextEditingController();
  final _sociosController = TextEditingController();
  final _cnpjController = MaskedTextController(mask: '00.000.000/0000-00');
  Cnpj cnpj = Cnpj();

  List<String> nomeSocios = [];
  Map mapSocios = {};

  void _initializeFields() {
    _logradouroController.text = "";
    _situacaoCadastralController.text = "";
    _nomeController.text = "";
    _naturezaJuridicaController.text = "";
    _cnaeController.text = "";
    _capitalSocialController.text = "";
    _cnpjController.text = "";
    _phoneController.text = "";
    _sociosController.text = "";
  }

  _showMsg(String message) {
    final snackBar = SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
          message,
        ));
    Scaffold.of(_formKeyLogin.currentState.context).showSnackBar(snackBar);
  }

  void _getData() async {
    http.Response response;
    var cnpjFixed = cnpj.fixCNPJ(_cnpjController.text);

    print('${constants.url}$cnpjFixed');

    response = await http.get('${constants.url}$cnpjFixed');

    print('response.body GET_CNPJ: ${response.body}');

    Map<String, dynamic> res = json.decode(response.body);

    var statusCode = res['status'];

    if (statusCode == 'OK') {
      print('OK, $statusCode');
      _getValues(res);
    } else {
      _showMsg(res["message"]);
      _initializeFields();
      print('Error, $statusCode');
    }
  }

  void _getValues(Map<String, dynamic> res) {
    cnpj.numero = res["numero"];
    cnpj.situacao = res["situacao"];
    cnpj.fantasia = res["fantasia"];
    cnpj.razao = res["nome"];
    cnpj.complemento = res["complemento"];
    cnpj.bairro = res["bairro"];
    cnpj.situacaoCadastral = res["cep"];
    cnpj.nome = res["municipio"];
    cnpj.logradouro = res["logradouro"];
    cnpj.naturezaJuridica = res["natureza_juridica"];
    cnpj.cnae = res["atividade_principal"][0]['text'];
    cnpj.cnae2 = res["atividade_principal"][0]['code'];
    cnpj.capitalSocial = res["capital_social"];
    cnpj.value = double.parse(cnpj.capitalSocial);
    cnpj.telefone = res["telefone"];

    _setValues(cnpj, res);
  }

  void _setValues(Cnpj cnpj, Map<String, dynamic> res) {
    print(NumberFormat.currency(locale: 'pt-br').format(cnpj.value));
    var capitalSocialFixed =
        NumberFormat.currency(locale: 'pt-br').format(cnpj.value).toString();

    var counter = 0;
    var socios;

    List<dynamic> teste = res["qsa"];
    print('teste: $teste, ${teste.length}, (${teste.length - 1})');

    while (counter <= (teste.length - 1)) {
      nomeSocios.add(
          '${res["qsa"][counter]['nome']} (${res["qsa"][counter]['qual']})\n\n');

      counter++;
    }
    print('nomeSocios: $nomeSocios');

    socios = nomeSocios.length > 0 ? nomeSocios : constants.qsaNull;
    // socios = teste.toString();

    _sociosController.text = cnpj.fixSocios(socios.toString());

    _phoneController.text =
        cnpj.telefone.toString().isNotEmpty ? cnpj.telefone : 'N/D';

    _capitalSocialController.text =
        'R\$ ${capitalSocialFixed.replaceAll('BRL', '')}';

    if (!cnpj.cnae.toString().contains("********")) {
      _cnaeController.text =
          'Atividade Principal: ${cnpj.cnae} \nCódigo: ${cnpj.cnae2}';
    } else {
      _cnaeController.text = 'N/D';
    }

    _naturezaJuridicaController.text = cnpj.naturezaJuridica;

    _situacaoCadastralController.text = cnpj.situacao;

    _nomeController.text = cnpj.fantasia.toString().isNotEmpty
        ? 'Razão Social: ${cnpj.razao} \n\nNome Fantasia: ${cnpj.fantasia}'
        : 'Razão Social: ${cnpj.razao}';

    if (cnpj.logradouro.toString().isNotEmpty) {
      _logradouroController.text =
          'Logradouro: ${cnpj.logradouro} \nNº: ${cnpj.numero} \nComplemento: ${cnpj.complemento} \nCEP: ${cnpj.situacaoCadastral} \nBairro: ${cnpj.bairro} \nCidade: ${cnpj.nome}';
    } else {
      _logradouroController.text = 'N/D';
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializeFields();

    var txtLogradouro = TextFormField(
      // key: _formKeyLogin,
      maxLines: null,
      enabled: false,
      controller: _logradouroController,
      decoration: InputDecoration(labelText: 'Endereço'),
    );
    var txtCNPJ = TextField(
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
          hintText: 'Digite um CNPJ'),
    );
    var txtNaturezaJuridica = TextFormField(
      maxLines: null,
      enabled: false,
      controller: _naturezaJuridicaController,
      decoration: InputDecoration(labelText: 'Natureza Jurídica'),
    );
    var txtCNAE = TextFormField(
        maxLines: null,
        enabled: false,
        controller: _cnaeController,
        decoration: InputDecoration(labelText: 'CNAE'));
    var txtCapitalSocial = TextFormField(
      maxLines: null,
      enabled: false,
      controller: _capitalSocialController,
      decoration: InputDecoration(labelText: 'Capital Social'),
    );
    var txtNome = TextFormField(
      maxLines: null,
      enabled: false,
      controller: _nomeController,
      decoration: InputDecoration(labelText: 'Nome'),
    );
    var txtPhone = TextFormField(
      maxLines: null,
      enabled: false,
      controller: _phoneController,
      decoration: InputDecoration(labelText: 'Telefone'),
    );
    var txtSituacaoCadastral = TextFormField(
      enabled: false,
      controller: _situacaoCadastralController,
      //style: TextStyle(color: Colors.green),
      decoration: InputDecoration(labelText: 'Situação Cadastral'),
      // style: TextStyle(color: Colors.blue),
    );
    var txtSocios = TextFormField(
      enabled: false,
      maxLines: null,
      controller: _sociosController,
      //style: TextStyle(color: Colors.green),
      decoration: InputDecoration(labelText: 'Quadro Societário'),
    );
    var scaffold = Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: Text(widget.title),
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
        onPressed: _getData,
        tooltip: 'Pesquisar',
        backgroundColor: Color(0xff1E392A),
        child: Icon(Icons.search),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
    return scaffold;
  }
}
