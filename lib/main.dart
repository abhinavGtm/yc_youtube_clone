import 'package:flutter/material.dart';
import 'package:yellowclass_assignment/View/HomeView.dart';

void main() {
  runApp( MaterialApp(
      debugShowCheckedModeBanner:false,
      theme: ThemeData(
        secondaryHeaderColor: Colors.white,
        primarySwatch: Colors.amber,
      ),
      home: HomePage()
  )
  );
}