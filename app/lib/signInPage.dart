import 'package:app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
  ]);

  Future<void> _handleSignIn() async {
    try {
      print('starting');
      final FirebaseAuth _auth = FirebaseAuth.instance;

      GoogleSignInAccount user = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await user.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser fbUser =
          (await _auth.signInWithCredential(credential)).user;

      Navigator.of(context).push(
        platformPageRoute(
          context: context,
          builder: (c) => BigBoi(),
        ),
      );
    } catch (error) {
      print(error);
    }
  }

  bool signedIn = false;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: signedIn
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlineButton(
                    onPressed: () {
                      // gooleSignout();
                    },
                    child: Text("Logout"),
                  ),
                ],
              ),
            )
          : Center(
              child: OutlineButton(
                onPressed: () {
                  _handleSignIn();
                },
                child: Text("Sign In with Google"),
              ),
            ),
    );
  }
}
