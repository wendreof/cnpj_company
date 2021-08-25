import 'package:cnpj_company/models/cnpj.dart';
import 'package:cnpj_company/modules/cnpj_module/cnpj_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cnpj_repository_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  final x = CnpjRepository();
  group('getCnpj', () {
    test('returns an CNPJ if the http call completes successfully', () async {
      final client = MockClient();

      when(await x.getCnpj(client, '05929714000100').then((response) {
        expect(response, isA<Cnpj>());
        expect('OK', response.status);
        expect('05.929.714/0001-00', response.cnpj);
        expect(response.nome, isA<String>());
      }));
    });

    // ignore: lines_longer_than_80_chars
    test('throws an exception if the http call completes with an error',
        () async {
      final client = MockClient();

      expect(x.getCnpj(client, ''), throwsException);
    });
  });
}
