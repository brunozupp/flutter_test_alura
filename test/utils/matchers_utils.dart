import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';

abstract class MatchersUtils {

  static bool featureItemMatcher(Widget widget, String name, IconData icon) {
    if(widget is FeatureItem) {
      return widget.name == name && widget.icon == icon;
    }

    return false;
  }

  static bool textFieldMatcher(Widget widget, String label) {
    if(widget is TextField) {
      return widget.decoration?.labelText == label;
    }

    return false;
  }
}