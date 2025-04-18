import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
//import '../../services/change_page.dart';
import '../../components/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import '../../services/auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController userController = new TextEditingController();
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

              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0,30,0,15),
                      child: Text(
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle( //todo match theme
                          fontSize: 40,
                          color: const Color(0xFF404040),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    /*Username*/
                    RoundedInputField(
                      controller: userController,
                      icon: Icons.person,
                      hintText: "Username",
                      onChanged: (value) {}, textInputType: TextInputType.text,
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
                          text: "Sign Up",
                          press: () {registration(context,userController.text.toString(),emailController.text.toString(), passwordController.text.toString());}
                      ),
                    ),

                    ///Unsed facebook, apple and google login - for later implementation
                    /*
                    /* Or Divider*/
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Expanded(child:
                          Padding(padding: const EdgeInsets.only(left: 50), child:
                          Divider(
                            color: Color(0xAA000000),
                            height: 1.5,
                          )
                          )
                          ),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child:
                          Text(
                              "OR",
                              style: TextStyle(
                                color: Color(0xAA000000),
                                fontWeight: FontWeight.w600,
                              )
                          ),
                          ),
                          Expanded(child:
                          Padding(padding: const EdgeInsets.only(right: 50), child:
                          Divider(
                            color: Color(0xAA000000),
                            height: 1.5,
                          )
                          )
                          ),
                        ],
                      ),
                    ),
*/
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                         /* Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child:
                              SocialButton(color: Colors.white,icon: "google")
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child:
                              SocialButton(color: Colors.white,icon: "facebook")
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child:
                              SocialButton(color: Colors.white,icon: "apple")
                          ),*/
                        ]
                    ),

                  ]),
            ]
        )
    );
  }
}

