import 'package:dio/dio.dart';

import '../src/model/cnpj.dart';
import '../src/util/contants.dart' as constants;

class CnpjRepository {
  Future<Cnpj> getData(dynamic cnpj) async {
    final response = await Dio().get('${constants.url}$cnpj');
    print('response.body GET_CNPJ: ${response.data}');
    final json = Cnpj.fromJson(response.data);
    return json;
  }
}
