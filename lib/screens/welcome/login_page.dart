import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import '../../components/platform_dialog.dart';
import '../../components/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import '../../services/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/parchment_background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0,30,0,15),
                        child: Text(
                          "Login",
                          textAlign: TextAlign.center,
                          style: TextStyle( //todo match theme
                            fontSize: 40,
                            color: const Color(0xFF404040),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      /*Email*/
                      RoundedInputField(
                        icon: Icons.email,
                        controller: emailController,
                        textInputType: TextInputType.emailAddress,
                        hintText: "Email",
                        onChanged: (value) {},
                      ),

                      /*Password*/
                      RoundedInputField(
                        controller: passwordController,
                        isPassword: true,
                        icon: Icons.lock,
                        hintText: "Your Password",
                        onChanged: (value) {}, textInputType: TextInputType.text,
                      ),


                      Padding(
                        padding: const EdgeInsets.only(top:10.0),
                        child: RoundedButton(
                            text: "Login",
                            press: () {login(context,emailController.text.toString(), passwordController.text.toString());}
                        ),
                      ),

                      ///Go to sign up///
                      Container(
                          padding: const EdgeInsets.only(top:25.0),
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(context, "/SignUpPage"),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Don\'t have an Account? ',
                                    style: TextStyle(
                                      color: Color(0xAA000000),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: TextStyle(
                                      color: Color(0xAA000000),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ),

                      ///Reset Password///
                      Container(
                        padding: const EdgeInsets.only(top:25.0),
                        child: GestureDetector(
                          onTap: () => resetPassword(context),
                          child: RichText(
                            text:
                            TextSpan(
                              text: 'Forgot Password? ',
                              style: TextStyle(
                                color: Color(0xAA000000),
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      )

                    ]),
              ),
            ]
        )
    );
  }
}