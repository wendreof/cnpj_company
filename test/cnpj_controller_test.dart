import 'package:cnpj_company/models/cnpj.dart';
import 'package:cnpj_company/modules/cnpj_module/cnpj_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final cnjController = CnpjController();

  test('Verity thats fixCnpj function is ok', () async {
    expect(cnjController.fixCNPJ(''), '');
    expect(cnjController.fixCNPJ('05/92-971.400.0100'), '05929714000100');
  });
}
