import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

EdgeInsets paddingGeneric = const EdgeInsets.all(8);

BorderRadius border10 = const BorderRadius.all(Radius.circular(10));

TextInputFormatter decimalCheck =
    FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'));
