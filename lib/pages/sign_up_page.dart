import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MovieDB/bloc/auth_bloc/bloc.dart';
import 'package:MovieDB/widgets/loading_button.dart';

import 'home.dart';
import 'sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String fname = "", lname = "", email = "", password = "", cpassword = "";

  AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = AuthBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  "Create Account",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Endless Partying possible awaits you. Kindly fill in your details to join the parte",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Form(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLines: 1,
                        onChanged: (val) {
                          fname = val;
                          _authBloc.add(OnRegDetailsChangedEvent(
                              firstname: fname,
                              lastname: lname,
                              email: email,
                              password: password,
                              confirmPassword: cpassword));
                        },
                        decoration: InputDecoration(
                            labelText: "Firstname",
                            labelStyle: TextStyle(color: Colors.grey[700])),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLines: 1,
                        onChanged: (val) {
                          lname = val;
                          _authBloc.add(OnRegDetailsChangedEvent(
                              firstname: fname,
                              lastname: lname,
                              email: email,
                              password: password,
                              confirmPassword: cpassword));
                        },
                        decoration: InputDecoration(
                            labelText: "Lastname",
                            labelStyle: TextStyle(color: Colors.grey[700])),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLines: 1,
                        onChanged: (val) {
                          email = val;
                          _authBloc.add(OnRegDetailsChangedEvent(
                              firstname: fname,
                              lastname: lname,
                              email: email,
                              password: password,
                              confirmPassword: cpassword));
                        },
                        decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.grey[700])),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLines: 1,
                        obscureText: true,
                        onChanged: (val) {
                          password = val;
                          _authBloc.add(OnRegDetailsChangedEvent(
                              firstname: fname,
                              lastname: lname,
                              email: email,
                              password: password,
                              confirmPassword: cpassword));
                        },
                        decoration: InputDecoration(
                            labelText: "Pasword",
                            labelStyle: TextStyle(color: Colors.grey[700])),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLines: 1,
                        onChanged: (val) {
                          cpassword = val;
                          _authBloc.add(OnRegDetailsChangedEvent(
                              firstname: fname,
                              lastname: lname,
                              email: email,
                              password: password,
                              confirmPassword: cpassword));
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Confirm Pasword",
                            labelStyle: TextStyle(color: Colors.grey[700])),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BlocListener(
                        bloc: _authBloc,
                        listener: (BuildContext context, state) {
                          if (state is RegisteredState) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => Home()));
                          }
                        },
                        child: BlocBuilder<AuthBloc, AuthState>(
                          bloc: _authBloc,
                          builder: (BuildContext context, AuthState state) {
                            if (state is RegisteredState) {
                              // return Center(
                              //     child: Text(
                              //   "${state.user.email}",
                              //   style: TextStyle(fontWeight: FontWeight.bold),
                              // ));
                              //   Navigator.of(context).push(
                              // MaterialPageRoute(builder: (BuildContext context)=>SignUpPage()));

                              return SizedBox.shrink();
                            }

                            if (state is AuthErrorState) {
                              return Center(
                                  child: Text(
                                "${state.error}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ));
                            }

                            return Text("");
                          },
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      BlocBuilder(
                        bloc: _authBloc,
                        builder: (BuildContext context, state) {
                          if (state is AuthLoadingState) {
                            return LoadingButton(
                              text: "Creating Account...",
                            );
                          } else {
                            return InkWell(
                              onTap: () {
                                _authBloc.add(RegisterEvent());
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(color: Colors.blue),
                                child: Center(
                                  child: Text(
                                    "Create Account",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => SignInPage()));
                        },
                        child: Container(
                            child: Text(
                          "Already have an acccount? Sign In",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500),
                        )))
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                // Center(child: Text("Parte After Perte.",style: TextStyle(fontWeight: FontWeight.bold),))
              ],
            ),
          )
        ],
      ),
    );
  }
}
