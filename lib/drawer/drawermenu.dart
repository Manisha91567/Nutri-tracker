import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutri_tracker/login_screens/google_signin/google_signin.dart';
import 'package:nutri_tracker/login_screens/login_page.dart';
import 'package:nutri_tracker/login_screens/user.dart';
import 'package:nutri_tracker/login_screens/user_model.dart';
import 'package:nutri_tracker/screens/home.dart';
import 'package:provider/provider.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  //Displaying data from database
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("user_details")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  final padding = const EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    bool isGoogleSignin = false;
    var name = isGoogleSignin ? '' : '${loggedInUser.name}';
    var email = isGoogleSignin ? '' : '${loggedInUser.email}';
    var mobile = isGoogleSignin ? '' : '${loggedInUser.mobile}';
    var urlImage = isGoogleSignin
        ? ''
        : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROZTgJiqRWL5wWednBz8zyRUhSuEDTzefieg&usqp=CAU';
    user = FirebaseAuth.instance.currentUser!;

    if (user!.providerData[0].providerId == "google.com") {
      final provider =
          Provider.of<GoogleSignInProvider>(context, listen: false);
      isGoogleSignin = true;
      email = provider.userModel!.email!;
      name = provider.userModel!.name!;
      urlImage = provider.userModel!.photoURL!;
    }
    return Drawer(
      child: Material(
        color: Colors.black45,
        child: ListView(
          children: <Widget>[
            Container(
              padding: padding,
              child: Column(
                children: [
                  buildHeader(
                      urlImage: urlImage,
                      name: name,
                      email: email,
                      mobile: mobile,
                      onClicked: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserPage(
                                    name: name,
                                    urlImage: urlImage,
                                  )))),
                  const SizedBox(
                    height: 12,
                  ),
                  buildMenuItem(
                    text: 'People',
                    icon: Icons.people,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(
                    text: 'Favourites',
                    icon: Icons.favorite_border,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(
                    text: 'Workflow',
                    icon: Icons.workspaces_outline,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(
                    text: 'Updates',
                    icon: Icons.update,
                    onClicked: () => selectedItem(context, 3),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(
                    text: 'Logout',
                    icon: Icons.logout,
                    onClicked: () => logout(context),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Divider(
                    color: Colors.white70,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(
                    text: 'Favourites',
                    icon: Icons.favorite_border,
                    onClicked: () => selectedItem(context, 5),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(
                    text: 'Workflow',
                    icon: Icons.workspaces_outline,
                    onClicked: () => selectedItem(context, 6),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(
                    text: 'Updates',
                    icon: Icons.update,
                    onClicked: () => selectedItem(context, 7),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    user = await FirebaseAuth.instance.currentUser!;
    if (user!.providerData[0].providerId == "google.com") {
      final provider =
          Provider.of<GoogleSignInProvider>(context, listen: false);
      provider.googleLogOut();
    }
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}

Widget buildHeader({
  required String urlImage,
  required String name,
  required String email,
  String? mobile,
  required VoidCallback onClicked,
}) =>
    InkWell(
      onTap: onClicked,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
            const SizedBox(width: 20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                name,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                email,
                style: const TextStyle(fontSize: 11, color: Colors.white),
              ),
              Text(
                mobile.toString(),
                style: const TextStyle(fontSize: 14, color: Colors.white),
              )
            ])
          ],
        ),
      ),
    );

Widget buildMenuItem({
  required String text,
  required IconData icon,
  VoidCallback? onClicked,
}) {
  final color = Colors.white;
  final hoverColor = Colors.white70;

  return ListTile(
    leading: Icon(
      icon,
      color: color,
    ),
    title: Text(
      text,
      style: TextStyle(color: color),
    ),
    onTap: onClicked,
    hoverColor: hoverColor,
  );
}

void selectedItem(BuildContext context, int index) {
  Navigator.of(context).pop();
  switch (index) {
    case 0:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const home()));
      break;
    case 1:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const home()));
      break;
    case 2:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const home()));
      break;
    case 3:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const home()));
      break;
    case 5:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const home()));
      break;
    case 6:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const home()));
      break;
    case 7:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const home()));
      break;
  }
}
