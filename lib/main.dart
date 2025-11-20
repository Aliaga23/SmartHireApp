import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_provider.dart';
import 'providers/vacante_provider.dart';
import 'providers/candidato_provider.dart';
import 'screens/login_screen.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF1A1A2E),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const SmartHireApp());
}

class SmartHireApp extends StatelessWidget {
  const SmartHireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => VacanteProvider()),
        ChangeNotifierProvider(create: (_) => CandidatoProvider()),
      ],
      child: MaterialApp(
        title: 'SmartHire Studio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme.copyWith(
          textTheme: GoogleFonts.interTextTheme(
            AppTheme.darkTheme.textTheme,
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
