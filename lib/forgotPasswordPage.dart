import 'package:flutter/material.dart';
import 'package:roomi/Widget/bezierContainer.dart';
import 'package:roomi/loginPage.dart';
import 'package:roomi/controllers/authentications.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        sendPasswordResetEmail(email);
        showDialogForMessage();
      },
      child: buildContainerForInkWellOfLoginButton(),
    );
  }

  showDialogForMessage() {
    Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        });

    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: Text("A pssword reset link has been sent to $email"),
      actions: [
        okButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  Container buildContainerForInkWellOfLoginButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: buildBoxDecorationForContainerOfLoginButton(),
      child: Text(
        'Submit',
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

  TextFormField textFormFieldForEmail() {
    return TextFormField(
      autofocus: true,
      focusNode: FocusNode(),
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
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
                  children: [
                    SizedBox(height: height * .1),
                    _title(),
                    SizedBox(height: 30),
                    containerOfEmail(),
                    SizedBox(height: 30),
                    _submitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
