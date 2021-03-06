import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutri_tracker/admin/admin_home.dart';
import 'package:nutri_tracker/onbparding_components/onboard.dart';
import 'package:nutri_tracker/sharedPreferences/local_data.dart';
import 'package:nutri_tracker/sharedPreferences/shared_preferences.dart';

import 'homepage/bottom_navigation.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    checkGoogleUser();
  }

  void checkGoogleUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = await auth.currentUser;
    if (user != null) {
      DataConstant.gname = (await UserLocalData.getGName());
      DataConstant.gmail = (await UserLocalData.getGEmail());
      DataConstant.gimg = (await UserLocalData.getGImg());
      DataConstant.name = (await UserLocalData.getName());
      DataConstant.mail = (await UserLocalData.getEmail());
      DataConstant.photo = (await UserLocalData.getImg());

      if (DataConstant.mail == 'nutritracker@admin.in') {
        Timer(
            const Duration(milliseconds: 6000),
            () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => AdminPage())));
      } else {
        Timer(
            const Duration(milliseconds: 6000),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => BottomNavigation())));
      }
    } else {
      Timer(
          const Duration(milliseconds: 6000),
          () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Onboarding())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/images/op.gif'),
        ]),
      ),
    );
  }
}
