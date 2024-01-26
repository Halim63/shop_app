import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/login_model.dart';

import '../../models/favorites_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}

class ShopLoadingHomeDataState extends ShopStates {}

class ShopSuccessHomeDataState extends ShopStates {}

class ShopErrorHomeDataState extends ShopStates {}

class ShopSuccessCategoryState extends ShopStates {}

class ShopErrorCategoryState extends ShopStates {}

class ShopChangeFavoritesState extends ShopStates {}

class ShopSuccessChangeFavoritesState extends ShopStates {
  final ChangeFavoritesModel model;

  ShopSuccessChangeFavoritesState(this.model);
}

class ShopErrorChangeFavoritesState extends ShopStates {}
class ShopLoadingGetFavoritesState extends ShopStates {}

class ShopSuccessGetFavoritesState extends ShopStates {}

class ShopErrorGetFavoritesState extends ShopStates {}

class ShopLoadingUserDataState extends ShopStates {}

class ShopSuccessUserDataState extends ShopStates {
  final LoginModel loginModel;

  ShopSuccessUserDataState( this.loginModel);
}

class ShopErrorUserDataState extends ShopStates {}



class ShopLoadingUpdateDataState extends ShopStates {}

class ShopSuccessUpdateDataState extends ShopStates {
  final LoginModel loginModel;

  ShopSuccessUpdateDataState( this.loginModel);
}

class ShopErrorUpdateDataState extends ShopStates {}
