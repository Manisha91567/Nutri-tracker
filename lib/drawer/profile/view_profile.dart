import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutri_tracker/constants.dart';
import 'package:nutri_tracker/database/user_model.dart';
import 'package:nutri_tracker/drawer/settings/settings.dart';
import 'package:intl/intl.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({Key? key}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  // String name = userData!.name.toString();
  UserModel retrivedData = UserModel();
  User? user = FirebaseAuth.instance.currentUser;
  DateFormat? formatter = DateFormat('yyyy-MM-dd');
  DateTime? creationDate;
  String? displayDate;
  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("user_details")
        .doc(user!.uid)
        .get()
        .then((value) {
      retrivedData = UserModel.fromMap(value.data());
      creationDate = user!.metadata.creationTime;
      displayDate = formatter!.format(creationDate!);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var username = retrivedData.username;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 250,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: MyCustomClipper(),
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(defaultProfileViewingUrl),
                        ),
                      ),
                    ),
                  ),
                  // User PRofile
                  Align(
                    alignment: const Alignment(0, 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            viewProfilePicDialog(
                                context,
                                retrivedData.photoURL ?? defaultProfileUrl,
                                retrivedData.name.toString());
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            child: CircleAvatar(
                              backgroundImage: (retrivedData.photoURL == "" ||
                                      retrivedData.photoURL == null)
                                  ? NetworkImage(defaultProfileUrl)
                                  : NetworkImage(
                                      retrivedData.photoURL.toString()),
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4, color: theme.bottomAppBarColor),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 10)),
                              ],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          username ?? "User-name",
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          retrivedData.email.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Appbar
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios_new),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsPage()));
                          },
                          icon: const Icon(Icons.settings),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            displayData(Icons.face_retouching_natural_sharp,
                retrivedData.name.toString(), retrivedData.gender ?? 'gender'),
            displayData(Icons.mobile_screen_share_outlined,
                retrivedData.mobile ?? "Mobile Number", "Verified"),
            displayData(Icons.local_hospital_outlined, "Date of Birth",
                retrivedData.birthdate ?? "DOB"),
            displayData(
                Icons.height, "Height", retrivedData.height ?? "height"),
            displayData(Icons.monitor_weight_outlined, "Weight",
                retrivedData.weight ?? "weight"),
            displayData(Icons.location_on_outlined, "Place",
                retrivedData.location ?? "location"),
            displayData(
                Icons.timelapse, "Joined Date", displayDate ?? "joined"),
            displayData(
                Icons.health_and_safety_outlined,
                "BMI : ${retrivedData.bmi ?? "BMI"}",
                "BMR : ${retrivedData.bmr ?? "BMR"}"),
            displayData(Icons.code, "About", retrivedData.bio ?? "About"),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  Padding displayData(IconData iconData, String title, String data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              size: 40,
              // color: Colors.blue,
            ),
            const SizedBox(
              width: 25,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  data,
                  style: TextStyle(
                    fontSize: 14.0,
                    // color: Colors.grey[700],
                  ),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 150);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

viewProfilePicDialog(BuildContext context, String photoLink, String name) {
  return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 410,
                child: Image.network(
                  photoLink,
                  width: MediaQuery.of(context).size.width * 0.9,
                  fit: BoxFit.cover,
                  height: 390,
                )),
          ),
        );
      });
}
