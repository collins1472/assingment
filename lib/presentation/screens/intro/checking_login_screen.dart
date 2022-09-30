import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/domain/bloc/blocs.dart';
import 'package:untitled/presentation/components/components.dart';
import 'package:untitled/presentation/screens/client/client_home_screen.dart';
import 'package:untitled/presentation/screens/home/roles.dart';
import 'package:untitled/presentation/screens/login/login_screen.dart';
import 'package:untitled/presentation/themes/colors_frave.dart';

import '../../../domain/bloc/auth/auth_bloc.dart';
import '../../../domain/bloc/user/user_bloc.dart';

class CheckingLoginScreen extends StatefulWidget {
  
  @override
  _CheckingLoginScreenState createState() => _CheckingLoginScreenState();
}


class _CheckingLoginScreenState extends State<CheckingLoginScreen> with TickerProviderStateMixin {

  late AnimationController _animationController;
  
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(_animationController)..addStatusListener((status) {
      if( status == AnimationStatus.completed ){
        _animationController.reverse();
      } else if ( status == AnimationStatus.dismissed ){
        _animationController.forward();
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        
        if( state is LoadingAuthState ){

          Navigator.pushReplacement(context, routeFrave(page: CheckingLoginScreen()));
        
        } else if ( state is LogOutAuthState ){

          Navigator.pushAndRemoveUntil(context, routeFrave(page: LoginScreen()), (route) => false);    
         
        } else if ( state.rolId != '' ){

          userBloc.add( OnGetUserEvent(state.user!) );

          if( state.rolId  == '1' || state.rolId  == '3' ){

            Navigator.pushAndRemoveUntil(context, routeFrave(page: SelectRoleScreen()), (route) => false);
          
           } else if ( state.rolId  == '2' ){

            Navigator.pushAndRemoveUntil(context, routeFrave(page: ClientHomeScreen()), (route) => false);          
          }
        }
      },
      child: Scaffold(
        backgroundColor: ColorsFrave.primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) 
                  => Transform.scale(
                    scale: _scaleAnimation.value,
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.asset('Assets/Logo/logo-white.png'),
                    ),
                  ),
              ),
            )
          ],
        ),
      ),
    );
  }
}