import 'package:flutter/material.dart';
import 'package:flutter_location/zipcode_finder.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const SafetyApp());
}

class SafetyApp extends StatelessWidget {
  const SafetyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, Orientation, DeviceType) {
      return const MaterialApp(title: 'Safety App', home: ZipcodeFinder());
    });
  }
}
