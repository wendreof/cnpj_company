import '../repositories/cnpj_repository.dart';
import '../src/model/cnpj.dart';

class CnpjController {
  final _repository = CnpjRepository();
  Future<Cnpj> getData(String cnpj) async {
    final response = await _repository.getData(fixCNPJ(cnpj));
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
