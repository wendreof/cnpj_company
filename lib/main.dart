import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:http/http.dart' as http;

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
  final _numeroController = TextEditingController();
  final _cepController = TextEditingController();
  final _situacaoController = TextEditingController();
  final _municipioController = TextEditingController();
  final _fantasiaController = TextEditingController();
  final _razaoController = TextEditingController();
  final _complementoController = TextEditingController();
  final _cnpjController = MaskedTextController(mask: '00.000.000/0000-00');

  void _initializeFields() {
    _logradouroController.text = "";
    _numeroController.text = "";
    _cepController.text = "";
    _situacaoController.text = "";
    _municipioController.text = "";
    _fantasiaController.text = "";
    _cnpjController.text = "";
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

      var logradouro = res["logradouro"];
      _logradouroController.text = logradouro;

      var numero = res["numero"];
      _numeroController.text = numero;

      var cep = res["cep"];
      _cepController.text = cep;

      var situacao = res["situacao"];

      var municipio = res["municipio"];
      _municipioController.text = municipio;

      var fantasia = res["fantasia"];
      _fantasiaController.text = fantasia;

      var razao = res["nome"];
      _razaoController.text = razao;

      var complemento = res["complemento"];
      _complementoController.text = complemento;

      print('logradouro: $logradouro');
      print('cep: $cep');
      print('numero: $numero');
      print('situacao: $situacao');
      print('municipio: $municipio');
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

    var txtComplemento = TextFormField(
      maxLines: 2,
      enabled: false,
      controller: _complementoController,
      decoration: InputDecoration(labelText: 'Complemento'),
    );
    var txtLogradouro = TextFormField(
      // key: _formKeyLogin,
      enabled: false,
      controller: _logradouroController,
      decoration: InputDecoration(labelText: 'Logradouro'),
    );
    var txtCNPJ = TextField(
      maxLength: 18,
      toolbarOptions: ToolbarOptions(
        cut: true,
        copy: true,
        selectAll: true,
        paste: false,
      ),
      enabled: true,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.numberWithOptions(),
      controller: _cnpjController,
      autofocus: true,
      cursorColor: Colors.amber,
      style: TextStyle(height: 1.5, fontSize: 20),
      cursorWidth: 5.0,
      //increases the height of cursor
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.amber,
              style: BorderStyle.solid,
            ),
          ),
          labelText: 'CNPJ',
          hintText: 'Digite um CNPJ'),
    );
    var txtMunicipio = TextFormField(
      enabled: false,
      controller: _municipioController,
      decoration: InputDecoration(labelText: 'Munícipio'),
    );
    var txtCEP = TextFormField(
      enabled: false,
      controller: _cepController,
      decoration: InputDecoration(labelText: 'CEP'),
    );
    var txtNumber = TextFormField(
      enabled: false,
      controller: _numeroController,
      decoration: InputDecoration(labelText: 'Nº'),
    );
    var txtNomeFantasia = TextFormField(
      enabled: false,
      controller: _fantasiaController,
      decoration: InputDecoration(labelText: 'Nome Fantasia'),
    );
    var txtRazaoSocial = TextFormField(
      maxLines: 2,
      enabled: false,
      controller: _razaoController,
      decoration: InputDecoration(labelText: 'Razão Social'),
    );
    var scaffold = Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: Text(widget.title),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  txtCNPJ,
                  txtLogradouro,
                  txtMunicipio,
                  txtCEP,
                  txtNumber,
                  txtNomeFantasia,
                  txtRazaoSocial,
                  txtComplemento,
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getData,
        tooltip: 'Pesquisar',
        child: Icon(Icons.search),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
    return scaffold;
  }
}
