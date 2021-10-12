import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:load/load.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:snack/snack.dart';

import '../../models/cnpj.dart';
import '../../utils/contants.dart' as constants;
import 'cnpj_controller.dart';

class CnpjPage extends StatefulWidget {
  CnpjPage({required this.title, Key? key}) : super(key: key);

  final String title;

  @override
  _CnpjPageState createState() => _CnpjPageState();
}

class _CnpjPageState extends State<CnpjPage> {
  ScreenshotController screenshotController = ScreenshotController();
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
  final _maskFormatter = MaskTextInputFormatter(
      mask: '##.###.###/####-##', filter: {'#': RegExp(r'[0-9]')});

  List<String> nomeSocios = [];
  Map mapSocios = {};

  var _validate = false;

  void _getData() async {
    showLoadingDialog(tapDismiss: false);
    final cnpj = await _controller.getData(_cnpjController.text);
    hideLoadingDialog();
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
    final style = ElevatedButton.styleFrom(
        primary: Color(0xff1E392A), textStyle: const TextStyle(fontSize: 20));
    final txtLogradouro = TextFormField(
      maxLines: null,
      enabled: false,
      controller: _logradouroController,
      decoration: InputDecoration(labelText: 'Endereço'),
    );
    final txtCNPJ = TextField(
      inputFormatters: [_maskFormatter],
      maxLength: 18,
      maxLines: 1,
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
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xff3CC37E)),
      cursorWidth: 5.0,
      //increases the height of cursor
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 3.0),
          ),
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
              Icons.share,
              color: Colors.white,
            ),
            onPressed: _share,
          )
        ],
        backgroundColor: Color(0xff1E392A),
      ),
      body: Container(
        child: Screenshot(
          controller: screenshotController,
          child: Form(
            key: _formKeyLogin,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: double.infinity, child: txtCNPJ),
                    SizedBox(
                      width: double.infinity,
                      height: 10 * 5,
                      child: ElevatedButton(
                        style: style,
                        onPressed: _search,
                        child: const Text('Pesquisar'),
                      ),
                    ),
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
      ),
    );
    return scaffold;
  }

  void _search() {
    setState(() {
      if (_cnpjController.text.isEmpty || _cnpjController.text.length != 18) {
        _validate = true;
      } else {
        _validate = false;
        _getData();
      }
    });
  }

  void _share() async {
    await _controller.share(screenshotController);
  }
}
