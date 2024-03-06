import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_flutter/home_screen.dart';
import 'package:sudoku_flutter/data_to_screen/auth.dart';
import 'firebase_options.dart';
import '/router/router.dart' show router;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        dividerTheme: const DividerThemeData(
            thickness: 1,
            color: Color.fromARGB(100, 0, 0, 0),
            indent: 10,
            endIndent: 10),
        canvasColor: Colors.black,
        colorScheme: const ColorScheme(
          primary: Color.fromARGB(255, 48, 56, 232),
          onPrimary: Color.fromARGB(255, 255, 255, 255),
          secondary: Color.fromRGBO(4, 15, 255, 0.35),
          onSecondary: Color.fromARGB(255, 0, 0, 0),
          tertiary: Color.fromRGBO(4, 15, 255, 0.15),
          onTertiary: Color.fromARGB(255, 0, 0, 0),
          brightness: Brightness.light,
          error: Color.fromARGB(255, 234, 90, 90),
          onError: Color.fromARGB(255, 255, 255, 255),
          surface: Color.fromARGB(255, 0, 0, 0),
          onSurface: Color.fromARGB(255, 255, 255, 255),
          background: Color.fromARGB(255, 245, 245, 245),
          onBackground: Color.fromARGB(255, 0, 0, 0),
        ),
        textTheme:
            GoogleFonts.spaceGroteskTextTheme(Theme.of(context).textTheme)
                .copyWith(
          bodyMedium: TextStyle(
              color: Colors.black,
              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
              fontSize: 20,
              fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(
              color: Colors.black,
              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
              fontWeight: FontWeight.w600,
              fontSize: 35),
          titleLarge: TextStyle(
              color: Colors.black,
              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
              fontWeight: FontWeight.w600,
              fontSize: 40),
          labelMedium: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 17,
              fontFamily: GoogleFonts.spaceGrotesk().fontFamily),
          headlineMedium: TextStyle(
              color: Colors.white,
              fontFamily: GoogleFonts.spaceGrotesk().fontFamily),
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
      builder: (context, child) {
        return ChangeNotifierProvider(
            create: (context) => Auth(), child: HomeScreen(child: child!));
      },
    );
  }
}
