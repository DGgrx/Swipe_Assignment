import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe/network_service.dart';
import 'package:swipe/screens/product/view_model/product_vm.dart';
import 'package:swipe/theme/view_model/theme_vm.dart';

/// This file is responsible for creating the Top-Level Providers of data and all
/// the View Models are instantiated here.
///
/// This is a MultiProvider which is wrapped around our main app.

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DarkThemeVm>(create: (_) => DarkThemeVm()),
        ChangeNotifierProvider<ProductVm>(create: (_) => ProductVm()),
        StreamProvider<ConnectivityStatus>(
          create: (_) =>
              ConnectivityService().connectionStatusController.stream,
          initialData: ConnectivityStatus.WiFi,
        ),
      ],
      child: child,
    );
  }
}
