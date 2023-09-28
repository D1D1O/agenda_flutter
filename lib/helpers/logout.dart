import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

logout(BuildContext context) {
  SharedPreferences.getInstance().then((value) {
    value.clear();
    Navigator.pushReplacementNamed(context, 'login');
  });
}