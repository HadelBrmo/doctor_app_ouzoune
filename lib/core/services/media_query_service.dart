import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class MediaQueryHelper {
  final BuildContext context;
  late final MediaQueryData _mediaQuery;

  MediaQueryHelper(this.context) {
    _mediaQuery = MediaQuery.of(context);
  }

  double get height => _mediaQuery.size.height;
  double get width => _mediaQuery.size.width;
  bool get isPortrait => _mediaQuery.orientation == Orientation.portrait;


}
