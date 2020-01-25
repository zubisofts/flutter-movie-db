import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_challenge/bloc/bloc.dart';
import 'package:flutter_ui_challenge/pages/home.dart';
import 'package:flutter_ui_challenge/widgets/loading_button.dart';

import 'sign_up_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  AuthBloc _authBloc = AuthBloc();

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
                SizedBox(height: 40),
                Text(
                  "Sign In",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Endless Partying possible awaits you. Kindly fill in your email and password",
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
                      TextFormField(
                        maxLines: 1,
                        onChanged: (email) {
                          _authBloc.add(OnEmailChangeEvent(email: email));
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
                        onChanged: (password) {
                          _authBloc
                              .add(OnPasswordChangeEvent(password: password));
                        },
                        decoration: InputDecoration(
                            labelText: "Pasword",
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            suffixIcon: Icon(Icons.remove_red_eye)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BlocListener(
                        bloc: _authBloc,
                        listener: (BuildContext context, state) {
                          if (state is LoggedInState) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => Home()));
                          }
                        },
                        child: BlocBuilder<AuthBloc, AuthState>(
                          bloc: _authBloc,
                          builder: (BuildContext context, AuthState state) {
                            if (state is LoggedInState) {
                              // return Center(
                              //     child: Text(
                              //   "${state.user.email}",
                              //   style: TextStyle(fontWeight: FontWeight.bold),
                              // ));
                              //   Navigator.of(context).push(
                              // MaterialPageRoute(builder: (BuildContext context)=>SignUpPage()));

                              return SizedBox.shrink();
                            }

                            if (state is ErrorState) {
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
                          if (state is LoadingState) {
                            return LoadingButton(
                              text: "Signing in...",
                            );
                          } else {
                            return InkWell(
                              onTap: () {
                                _authBloc.add(LoginEvent());
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(color: Colors.blue),
                                child: Center(
                                  child: Text(
                                    "Sign In",
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
                    Text(
                      "Reset Password?",
                      style: TextStyle(
                          color: Colors.grey[700], fontWeight: FontWeight.w500),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => SignUpPage()));
                        },
                        child: Container(
                            child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500),
                        )))
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                Center(
                    child: Text(
                  "Parte After Perte.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
