import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MovieDB/bloc/auth_bloc/auth_bloc.dart';
import 'package:MovieDB/bloc/auth_bloc/bloc.dart';
import 'package:MovieDB/pages/home.dart';
import 'package:MovieDB/pages/sign_in_page.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: BlocProvider.of<AuthBloc>(context),
      builder: (BuildContext context, AuthState state) {
          if(state is AuthLoginState){
            var firebaseUser = state.user;
            if(firebaseUser!=null){
              return Home();
            }else{
              return Home();
            }
          }
          return SignInPage();
      },
    );
  }
}
