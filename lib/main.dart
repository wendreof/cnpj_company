import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:http/http.dart' as http;
import "package:intl/intl.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
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
  // MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final _phoneController = TextEditingController();
  final _sociosController = TextEditingController();
  final _cnpjController = MaskedTextController(mask: '00.000.000/0000-00');

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

  String _fixCNPJ(String cnpj) {
    cnpj = cnpj.replaceAll('.', '');
    cnpj = cnpj.replaceAll('/', '');
    cnpj = cnpj.replaceAll('-', '');
    cnpj = cnpj.replaceAll(',', '');
    return cnpj;
  }

  void _getData() async {
    print("************************************************************");
    print("************************ GET_CNPJ *********************");
    print("************************************************************");

    http.Response response;
    var cnpjFixed = _fixCNPJ(_cnpjController.text);
    print('_cnpjController.text: ${_cnpjController.text}');
    print('http://www.receitaws.com.br/v1/cnpj/$cnpjFixed');
    response = await http.get('http://www.receitaws.com.br/v1/cnpj/$cnpjFixed');

    print('response.body GET_CNPJ: ${response.body}');

    Map<String, dynamic> res = json.decode(response.body);

    var statusCode = res['status'];

    if (statusCode == 'OK') {
      print('OK, $statusCode');

      var numero = res["numero"];

      var situacao = res["situacao"];

      var fantasia = res["fantasia"];

      var razao = res["nome"];

      var complemento = res["complemento"];

      var bairro = res["bairro"];

      var situacaoCadastral = res["cep"];

      var nome = res["municipio"];

      var logradouro = res["logradouro"];

      var naturezaJuridica = res["natureza_juridica"];

      var cnae = res["atividade_principal"][0]['text'];
      var cnae2 = res["atividade_principal"][0]['code'];

      var capitalSocial = res["capital_social"];

      var value = double.parse(capitalSocial);
      // capitalSocial = value

      print(NumberFormat.currency(locale: 'pt-br').format(value));
      var capitalSocialFixed =
          NumberFormat.currency(locale: 'pt-br').format(value).toString();

      var telefone = res["telefone"];

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

      socios = nomeSocios.toString();
      // socios = teste.toString();

      _sociosController.text = socios
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "")
          .replaceAll("-", " ")
          .replaceAll(",", "");

      _phoneController.text = telefone;

      _capitalSocialController.text =
          'R\$ ${capitalSocialFixed.replaceAll('BRL', '')}';

      _cnaeController.text = 'Atividade Principal: $cnae \nCódigo: $cnae2';

      _naturezaJuridicaController.text = naturezaJuridica;

      _situacaoCadastralController.text = situacao;

      _nomeController.text =
          'Razão Social: $razao \n\nNome Fantasia: $fantasia';

      _logradouroController.text =
          'Logradouro: $logradouro \nNº: $numero \nComplemento: $complemento \nCEP: $situacaoCadastral \nBairro: $bairro \nCidade: $nome';

      print('logradouro: $logradouro');
      print('cep: $situacaoCadastral');
      print('numero: $numero');
      print('situacao: $situacao');
      print('municipio: $nome');
      print('fantasia: $fantasia');
    } else {
      _showMsg(res["message"]);
      _initializeFields();
      print('Error, $statusCode');
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
      decoration: InputDecoration(labelText: 'CNAE'),
    );
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
    var txtCEP = TextFormField(
      enabled: false,
      controller: _situacaoCadastralController,
      //style: TextStyle(color: Colors.green),
      decoration: InputDecoration(labelText: 'Situação Cadastral'),
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
                  txtCEP,
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
