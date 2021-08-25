import '../../models/cnpj.dart';
import 'cnpj_repository.dart';

class CnpjController {
  final _repository = CnpjRepository();
  Future<Cnpj> getData(String cnpj) async {
    final response = await _repository.getData(null, fixCNPJ(cnpj));
    return response;
  }
}

String fixCNPJ(String cnpj) {
  cnpj = cnpj
      .replaceAll('.', '')
      .replaceAll('/', '')
      .replaceAll('-', '')
      .replaceAll(',', '');
  return cnpj;
}
