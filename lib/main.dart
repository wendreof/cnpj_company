import 'package:flutter/material.dart';
import 'modules/cnpj/cnpj_page.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    darkTheme: ThemeData.dark().copyWith(
      appBarTheme: AppBarTheme(color: const Color(0xFF253341)),
      scaffoldBackgroundColor: const Color(0xFF15202B),
    ),
    debugShowCheckedModeBanner: false,
    home: CnpjPage(
      title: 'Pesquisa CNPJ',
    ),
  ));
}
