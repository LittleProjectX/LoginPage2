import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/pages/add_page.dart';
import 'package:whatsapp/pages/edit_page.dart';
import 'package:whatsapp/pages/home_page.dart';
import 'package:whatsapp/pages/login_page.dart';
import 'package:whatsapp/providers/authn.dart';
import 'package:whatsapp/providers/products.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Authn(),
        ),
        ChangeNotifierProxyProvider<Authn, Products>(
          create: (context) => Products(),
          update: (context, authn, products) {
            return products!..updateData(authn.token ?? '', authn.userId ?? '');
          },
        )
      ],
      child: Consumer<Authn>(
        builder: (context, getAuth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          home: getAuth.isAuth ? const HomePage() : const LoginPage(),
          routes: {
            HomePage.nameRoute: (context) => const HomePage(),
            AddPage.nameRoute: (context) => const AddPage(),
            EditPage.nameRoute: (context) => const EditPage()
          },
          theme: ThemeData(
              primaryColor: const Color(0xffE36414),
              appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xff9A031E),
                  // foregroundColor: Color(0xffFB8B24),
                  iconTheme: IconThemeData(color: Colors.white)),
              textTheme: const TextTheme(
                titleSmall:
                    TextStyle(fontFamily: 'Monserrat_Black', fontSize: 18),
                titleMedium:
                    TextStyle(fontFamily: 'Monserrat_Black', fontSize: 20),
                titleLarge:
                    TextStyle(fontFamily: 'Monserrat_Black', fontSize: 24),
                bodySmall:
                    TextStyle(fontFamily: 'Monserrat_Bold', fontSize: 12),
                bodyMedium:
                    TextStyle(fontFamily: 'Monserrat_Bold', fontSize: 14),
                bodyLarge:
                    TextStyle(fontFamily: 'Monserrat_Bold', fontSize: 24),
              )),
        ),
      ),
    );
  }
}
