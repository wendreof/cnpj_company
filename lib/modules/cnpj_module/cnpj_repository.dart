import 'package:dio/dio.dart';

import '../../models/cnpj.dart';
import '../../utils/contants.dart' as constants;

class CnpjRepository {
  Future<Cnpj> getCnpj(dynamic client, String cnpj) async {
    final response = await Dio().get('${constants.url}$cnpj');
    //print('getData2: ${response.data}');
    if (response.statusCode == 200) {
      return Cnpj.fromJson(response.data);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
