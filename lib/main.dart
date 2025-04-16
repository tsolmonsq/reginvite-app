import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/login_screen.dart';
import 'screens/event_list_screen.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart'; // ← нэмсэн

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('mn', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> getInitialScreen() async {
    final user = await AuthService.getLoggedInUser();
    if (user != null) {
      return EventListScreen(staffName: user);
    } else {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ирц бүртгэл',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme, // ← theme-г энд авна
      home: FutureBuilder(
        future: getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data!;
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
