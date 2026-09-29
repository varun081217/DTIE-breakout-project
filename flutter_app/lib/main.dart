import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/circle_provider.dart';
import 'providers/item_provider.dart';
import 'screens/passcode_entry_screen.dart';

void main() {
  runApp(const UniFindApp());
}

class UniFindApp extends StatelessWidget {
  const UniFindApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CircleProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
      ],
      child: MaterialApp(
        title: 'UniFind - Campus Lost & Found',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        home: const PasscodeEntryScreen(),
      ),
    );
  }
}
