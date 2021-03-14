import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roomi/Shared/loadingwidget.dart';
import 'package:roomi/forgotPasswordPage.dart';
import 'package:roomi/signUp.dart';

import 'HouseFiles/ListofHouses.dart';
import 'Widget/bezierContainer.dart';
import 'controllers/authentications.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;
  bool loading = false;
  final focus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void login() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      signin(email, password, context).then((value) {
        if (value != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ListOfHouse(),
              ));
        } else {
          Fluttertoast.showToast(
            msg: "Wrong Password or Check our internet connection",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      });
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: buildContainerForInkwellOfBackButton(),
    );
  }

  Container buildContainerForInkwellOfBackButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
            child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
          ),
          Text('Back',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
        ],
      ),
    );
  }

  Widget _loginButton() {
    return InkWell(
      onTap: () {
        login();
      },
      child: buildContainerForInkWellOfLoginButton(),
    );
  }

  Container buildContainerForInkWellOfLoginButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: buildBoxDecorationForContainerOfLoginButton(),
      child: Text(
        'Login',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  BoxDecoration buildBoxDecorationForContainerOfLoginButton() {
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2)
        ],
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xfffbb448), Color(0xfff7892b)]));
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          SignInButton(
            Buttons.Google,
            onPressed: () => googleSignIn().whenComplete(() async {
              FirebaseUser user = await FirebaseAuth.instance.currentUser();

              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ListOfHouse()));
            }),
          ),
          SignInButton(
            Buttons.FacebookNew,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: buildContainerForInkwellOfCreaeAccountLabel(),
    );
  }

  Container buildContainerForInkwellOfCreaeAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Register',
            style: TextStyle(
                color: Color(0xfff79c4f),
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: buildTextSpanForTitleWidget(),
    );
  }

  TextSpan buildTextSpanForTitleWidget() {
    return TextSpan(
        text: 'R',
        style: GoogleFonts.portLligatSans(
          // ignore: deprecated_member_use
          textStyle: Theme.of(context).textTheme.display1,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Color(0xffe46b10),
        ),
        children: [
          TextSpan(
            text: 'oo',
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
          TextSpan(
            text: 'mi',
            style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
          ),
        ]);
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        containerOfEmail(),
        containerOfPassword(),
      ],
    );
  }

  Container containerOfPassword() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Password",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 13,
          ),
          textFormFieldForPassword()
        ],
      ),
    );
  }

  TextFormField textFormFieldForPassword() {
    return TextFormField(
      focusNode: focus,
      obscureText: true,
      textInputAction: TextInputAction.done,
      inputFormatters: [],
      decoration: InputDecoration(
        hintText: 'Enter Password',
        border: InputBorder.none,
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }

        return null;
      },
      onChanged: (val) {
        password = val;
      },
    );
  }

  Container containerOfEmail() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Email Id",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 13,
          ),
          textFormFieldForEmail()
        ],
      ),
    );
  }

  TextFormField textFormFieldForEmail() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      autofocus: true,
      obscureText: false,
      inputFormatters: [],
      decoration: InputDecoration(
        hintText: 'Enter Email Id',
        border: InputBorder.none,
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }

        return null;
      },
      onChanged: (val) {
        email = val;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return loading
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            body: Form(
              key: _formKey,

              //height: height,
              child: Stack(
                children: <Widget>[
                  Positioned(
                      top: -height * .15,
                      right: -MediaQuery.of(context).size.width * .4,
                      child: BezierContainer()),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: height * .1),
                          _title(),
                          SizedBox(height: 30),
                          _emailPasswordWidget(),
                          SizedBox(height: 20),
                          _loginButton(),
                          forgetPasswordContainer(),

                          _divider(),
                          _facebookButton(),
                          // SizedBox(height: height * .01),
                          _createAccountLabel(),
                        ],
                      ),
                    ),
                  ),
                  Positioned(top: 40, left: 0, child: _backButton()),
                ],
              ),
            ));
  }

  Container forgetPasswordContainer() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.centerRight,
      child: FlatButton(
        child: Text('Forgot Password ?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgotPassword()));
        },
      ),
    );
  }
}
