import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/modules/settings/setting_screen.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../models/categories_model.dart';
import '../../models/change_favorites_model.dart';
import '../../models/favorites_model.dart';
import '../../models/home_model.dart';
import '../../modules/favorites/favorites_screen.dart';

class ShopCubit extends Cubit<ShopStates>{
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  void changeBottom(int index){
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;

  Map<int, bool> favorites = {};

  void getHomeData(){
    emit(ShopLoadingHomeDataState());
    
    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      //printFullText(homeModel.data.banners[0].image);
      //print(homeModel.status);
      for (var element in homeModel!.data!.products!) {
        favorites.addAll({
          element.id!: element.inFavorites!
        });
      }
      print(favorites.toString());
      emit(ShopSuccessHomeDataState());
      }).catchError((error){
        print(error.toString());
        emit(ShopErrorHomeDataState());
      });
  }

  CategoriesModel? categoriesModel;

  void getCategories(){
    DioHelper.getData(
      url: GET_CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      printFullText(homeModel!.data!.banners![0].image.toString());
      print(homeModel!.status);
      emit(ShopSuccessCategoriesState());
    }).catchError((error){
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId){
    favorites[productId] = !favorites[productId]!;

    emit(ShopChangeFavoritesState());

    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id' : productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJso(value.data);
      print(value.data);

      if(!changeFavoritesModel!.status!){
        favorites[productId] = !favorites[productId]!;
      }else{
        getFavorites();
      }

      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error){
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorChangeFavoriteState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites(){
    emit(ShopLoadingChangeFavoriteState());

    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      printFullText(value.data.toString());
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error){
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel? userModel;

  void getUserData(){
    emit(ShopLoadingUserDataState());

    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      print(userModel!.data!.name);
      emit(ShopSuccessUserDataState(userModel!));
    }).catchError((error){
      print(error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }){
    emit(ShopLoadingUpdateUserState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name' : name,
        'email' : email,
        'phone' : phone,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      print(userModel!.data!.name);
      emit(ShopSuccessUpdateUserState(userModel!));
    }).catchError((error){
      print(error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }
}