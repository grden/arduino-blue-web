import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';
import 'screens/main_screen.dart';
import 'utils/themes/color_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/config/.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    } catch (e) {
      print(e);
    }
  }
  runApp(ProviderScope(child: App()));
}

class App extends StatefulWidget {
  final router = GoRouter(initialLocation: '/', routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
  ]);

  App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: widget.router,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      theme: ThemeData(scaffoldBackgroundColor: ColorManager.background),
    );
  }
}
