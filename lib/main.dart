import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:promorey/config/routes.dart';
import 'package:promorey/config/theme.dart';
import 'package:promorey/firebase_options.dart';
import 'package:promorey/providers/auth_provider.dart';
import 'package:promorey/providers/promotion_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PromoReyApp());
}

class PromoReyApp extends StatelessWidget {
  const PromoReyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PromotionProvider()),
      ],
      child: Builder(
        builder: (context) {
          final authProvider = context.watch<AuthProvider>();
          final router = createRouter(authProvider);
          return MaterialApp.router(
            title: 'PromoRey',
            theme: appTheme,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
