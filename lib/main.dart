import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'modules/cnpj_module/cnpj_page.dart';

Future<void> main() async {
  await SentryFlutter.init((options) {
    options.dsn =
        'https://aeccb06d38c4425b98ee1e6daeae73c3@o1069294.ingest.sentry.io/6063716';
    // ignore: lines_longer_than_80_chars
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
    // We recommend adjusting this value in production.
    // options.tracesSampleRate = 1.0;
  },
      appRunner: () => runApp(MaterialApp(
            navigatorObservers: [
              SentryNavigatorObserver(),
            ],
            theme: ThemeData.dark(),
            darkTheme: ThemeData.dark().copyWith(
              appBarTheme: AppBarTheme(color: const Color(0xFF253341)),
              scaffoldBackgroundColor: const Color(0xFF15202B),
            ),
            debugShowCheckedModeBanner: false,
            home: CnpjPage(
              title: 'Pesquisa CNPJ',
            ),
          )
          ));

          
}
