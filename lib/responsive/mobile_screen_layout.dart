import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super (key: key) ;

  @override
  State<MobileScreenLayout> createState() => _MobilescreenLayoutState();
}
class _MobilescreenLayoutState extends State<MobileScreenLayout>{

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('This is mobile'),),
    );
  }
}
