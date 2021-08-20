import 'package:dio/dio.dart';

import '../../models/cnpj.dart';
import '../../utils/contants.dart' as constants;

class CnpjRepository {
  Future<Cnpj> getData(dynamic cnpj) async {
    final response = await Dio().get('${constants.url}$cnpj');
   // print('response.body GET_CNPJ: ${response.data}');
    return Cnpj.fromJson(response.data);
  }
}
