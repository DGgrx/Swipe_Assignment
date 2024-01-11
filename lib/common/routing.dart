import 'package:flutter/cupertino.dart';
import '../screens/product/product_list.dart';

class RouteName {
  static const productScreen = "productScreen";

}

class Routes {
  static cupertinoRoute(
      String name, Widget Function(BuildContext) widgetProvider) =>
      CupertinoPageRoute(
        settings: RouteSettings(name: name),
        builder: (context) => widgetProvider(context),
      );

  static Route landingScreen() =>
      cupertinoRoute(RouteName.productScreen, (ctx) => ProductListScreen());

}
