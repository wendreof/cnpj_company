import 'package:cnpj_company/models/cnpj.dart';
import 'package:cnpj_company/modules/cnpj_module/cnpj_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  final x = CnpjRepository();
  group('getCnpj', () {
    test('returns CNPJ if the http call completes ok', () async {
      when(await x.getCnpj('05929714000100').then((response) {
        expect(response, isA<Cnpj>());
        expect('OK', response.status);
        expect('05.929.714/0001-00', response.cnpj);
        expect(response.nome, isA<String>());
      }));
    });

    test('throws an exception if the http call returns an error', () async {
      expect(x.getCnpj(''), throwsException);
    });
  });
}
