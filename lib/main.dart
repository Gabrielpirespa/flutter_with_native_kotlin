import 'package:flutter/material.dart';
import 'package:flutter_with_native_kotlin/app/provider/locations_provider.dart';
import 'package:flutter_with_native_kotlin/app/screens/actual_location_screen.dart';
import 'package:flutter_with_native_kotlin/app/screens/location_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocationsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        'home': (context) => const ActualLocationScreen(),
        'list': (context) => const LocationListScreen()
      },
      initialRoute: 'home',
    );
  }
}
