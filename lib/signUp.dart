import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:roomi/Shared/loadingwidget.dart';
import 'HouseFiles/ListofHouses.dart';
import 'Widget/bezierContainer.dart';
import 'controllers/authentications.dart';
import 'loginPage.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String username;
  bool loading = false;

  void handleSignup() {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      _formKey.currentState.save();
      signUp(email.trim(), password, username, context).then((value) {
        if (value != null) {
          Fluttertoast.showToast(
            msg: "Your Account has been added, Please Login",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ));
        }
      });
      /* Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ListOfHouse(),
          ));*/
    }
  }

  bool validateEmail(String value, {String field}) {
    if (field == "Email id") {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      return (!regex.hasMatch(value)) ? false : true;
    }
    return null;
  }

  String validatePassword(String value) {
    Pattern A = r'^(?=.*[A-Z])';
    Pattern b = r'(?=.*[a-z])';
    Pattern c = r'(?=.*?[0-9])';
    Pattern d = r'(?=.*?[!@#\$&*~]).{8,}$';
    if (!new RegExp(A).hasMatch(value)) {
      return "upper";
    }
    if (!new RegExp(b).hasMatch(value)) {
      return "lower";
    }
    if (!new RegExp(c).hasMatch(value)) {
      return "digit";
    }
    if (!new RegExp(d).hasMatch(value)) {
      return "char";
    }

    return null;
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: buildContainerForInkWellOfBackButton(),
    );
  }

  Container buildContainerForInkWellOfBackButton() {
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

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildTextWidgetForEntryField(title),
          SizedBox(
            height: 10,
          ),
          buildTextFormFieldForEntryFieldWidget(isPassword, title),
        ],
      ),
    );
  }

  TextFormField buildTextFormFieldForEntryFieldWidget(
      bool isPassword, String title) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: Colors.grey.shade200,
          filled: true),
      validator: (value) {
        if (title == "Username") {
          if (value.isEmpty) {
            return "Username can not be Empty";
          }
        }
        if (title == "Email id") {
          if (value.isEmpty) {
            return "Email id can not be Empty";
          }
          if (!validateEmail(value, field: title)) {
            return "Enter a valid Email";
          }
        }
        if (title == "Password") {
          if (value.length <= 5) {
            return "password must contain at least 6 Values";
          }
          if (validatePassword(value) == "upper") {
            return " should contain at least one upper case";
          }
          if (validatePassword(value) == "lower") {
            return "should contain at least one lower case";
          }
          if (validatePassword(value) == "digit") {
            return "should contain at least one digit";
          }
          if (validatePassword(value) == "char") {
            return "should contain at least one Special character";
          }
        }
        return null;
      },
      onChanged: (val) {
        if (title == "Username") {
          username = val;
        }
        if (title == "Email id") {
          email = val;
        }
        if (title == "Password") {
          password = val;
        }
      },
    );
  }

  Text buildTextWidgetForEntryField(String title) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    );
  }

  Widget _signupButton() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState.validate()) {
          handleSignup();
        }
      },
      child: buildContainerForChildOfInkwellOfSignupButton(),
    );
  }

  Container buildContainerForChildOfInkwellOfSignupButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: buildBoxDecorationForContainerOfSignupButton(),
      child: Text(
        'Register Now',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  BoxDecoration buildBoxDecorationForContainerOfSignupButton() {
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

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: buildContainerForChildOfInkwellOfLoginAccountLabel(),
    );
  }

  Container buildContainerForChildOfInkwellOfLoginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Login',
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
      text: buildTextSpanFOrTitle(),
    );
  }

  TextSpan buildTextSpanFOrTitle() {
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
        _entryField("Username"),
        _entryField("Email id"),
        _entryField("Password", isPassword: true),
      ],
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 96,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          SignInButton(
            Buttons.Google,
            onPressed: () {},
          ),
          SignInButton(
            Buttons.FacebookNew,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return loading
        ? Loading()
        : Scaffold(
            body: Form(
              key: _formKey,
//height: ,
              child: buildStackForFormOfBuildWidget(context, height),
            ),
          );
  }

  Stack buildStackForFormOfBuildWidget(BuildContext context, double height) {
    return Stack(
      children: <Widget>[
        buildPositionedWidgetForBezierContainer(context),
        buildContainerForStackOfBuildWidget(height),
        buildPositionedWidgetForBackButton(),
      ],
    );
  }

  Container buildContainerForStackOfBuildWidget(double height) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: height * .1),
            _title(),
            SizedBox(
              height: 50,
            ),
            _emailPasswordWidget(),
            SizedBox(
              height: 20,
            ),
            _signupButton(),
            _facebookButton(),
            _loginAccountLabel(),
          ],
        ),
      ),
    );
  }

  Positioned buildPositionedWidgetForBackButton() =>
      Positioned(top: 40, left: 0, child: _backButton());

  Positioned buildPositionedWidgetForBezierContainer(BuildContext context) {
    return Positioned(
      top: -MediaQuery.of(context).size.height * .15,
      right: -MediaQuery.of(context).size.width * .4,
      child: BezierContainer(),
    );
  }
}
