import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe/app_providers.dart';
import 'package:swipe/screens/product/product_list.dart';
import 'package:swipe/theme/theme.dart';
import 'package:swipe/theme/view_model/theme_vm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: Consumer<DarkThemeVm>(builder: (context, darkThemeVm, _) {
        return MaterialApp(
          title: 'Swipe Assignment',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: darkThemeVm.darkTheme ? ThemeMode.dark : ThemeMode.light,
          home: ProductListScreen(),
        );
      }),
    );
  }
}
