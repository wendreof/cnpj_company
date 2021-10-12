import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/cnpj.dart';
import 'cnpj_repository.dart';

class CnpjController {
  final _repository = CnpjRepository();
  Future<Cnpj> getData(String cnpj) async {
    final response = await _repository.getCnpj(fixCNPJ(cnpj));
    return response;
  }

  String fixCNPJ(String cnpj) {
    cnpj = cnpj
        .replaceAll('.', '')
        .replaceAll('/', '')
        .replaceAll('-', '')
        .replaceAll(',', '');
    return cnpj;
  }

  Future<String?> share(ScreenshotController controller) async {
    if (!kIsWeb) {
      await controller
          .capture(delay: const Duration(milliseconds: 10))
          .then((image) async {
        if (image != null) {
          final directory = await getApplicationDocumentsDirectory();
          final imagePath = await File('${directory.path}/image.png').create();
          await imagePath.writeAsBytes(image);

          await Share.shareFiles([imagePath.path]);
          return imagePath;
        } else {
          return '';
        }
      });
    }
    return '';
  }
}
