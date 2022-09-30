import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/domain/bloc/blocs.dart';
import 'package:untitled/domain/services/push_notification.dart';
import 'package:untitled/presentation/screens/intro/checking_login_screen.dart';

import 'domain/bloc/auth/auth_bloc.dart';
import 'domain/bloc/cart/cart_bloc.dart';
import 'domain/bloc/delivery/delivery_bloc.dart';
import 'domain/bloc/general/general_bloc.dart';
import 'domain/bloc/map_client/mapclient_bloc.dart';
import 'domain/bloc/map_delivery/mapdelivery_bloc.dart';
import 'domain/bloc/my_location/mylocationmap_bloc.dart';
import 'domain/bloc/orders/orders_bloc.dart';
import 'domain/bloc/payments/payments_bloc.dart';
import 'domain/bloc/products/products_bloc.dart';
import 'domain/bloc/user/user_bloc.dart';

PushNotification pushNotification = PushNotification();

Future<void> _firebaseMessagingBackground( RemoteMessage message ) async {

  await Firebase.initializeApp();

}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackground);
  pushNotification.initNotifacion();
  runApp(MyApp());
}



class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    pushNotification.onMessagingListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark ));

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()..add(CheckLoginEvent())),
        BlocProvider(create: (context) => GeneralBloc()),
        BlocProvider(create: (context) => ProductsBloc()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(create: (context) => MylocationmapBloc()),
        BlocProvider(create: (context) => PaymentsBloc()),
        BlocProvider(create: (context) => OrdersBloc()),
        BlocProvider(create: (context) => DeliveryBloc()),
        BlocProvider(create: (context) => MapdeliveryBloc()),
        BlocProvider(create: (context) => MapclientBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Food - Fraved',
        home: CheckingLoginScreen(),
      ),
    );
  }
}