import 'package:cnpj_company/modules/cnpj_module/cnpj_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';

void main() {
  final cnjController = CnpjController();
  final screenshotController = ScreenshotController();

  // ignore: unused_local_variable
  final screenshot = Screenshot(
      controller: screenshotController,
      child: TextFormField(
        enabled: false,
        controller: null,
        style: TextStyle(color: Colors.green),
        decoration: InputDecoration(labelText: 'Situação Cadastral'),
      ));

  test('Verity thats fixCnpj function is ok', () async {
    expect(cnjController.fixCNPJ(''), '');
    expect(cnjController.fixCNPJ('05/92-971.400.0100'), '05929714000100');
  });
}
