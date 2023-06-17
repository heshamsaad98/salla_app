import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app.dart';
import 'package:shop_app/modules/on_boarding/on_boarding_screen.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/thems.dart';
import 'modules/login/shop_login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  Widget widget;
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  if(onBoarding != null){
    if(token != null) {
      widget = const ShopLayout();
    } else {
      widget = const ShopLoginScreen();
    }
  }else{
    widget = const OnBoardingScreen();
  }
  runApp(MyApp(startWidget: widget,));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.startWidget,}) : super(key: key);
  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData(),
        ),
      ],
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: lightTheme,
            home: startWidget,
          );
        },
      ),
    );
  }
}


