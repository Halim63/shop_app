import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/register/cubit/register_states.dart';
import '../../../shared/network/end_point.dart';
import '../../../shared/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);
   LoginModel? loginModel;

  void userRegister(
  {
    required String email,
    required String password,
    required String name,
    required String phone,
}
      ){
    emit(RegisterLoadingState());
    DioHelper.postData(
        url: REGISTER,
        data: {
          'name':name,
          'email':email,
          'password':password,
          'phone':phone,
        }
    ).then((value) {
      loginModel=LoginModel.fromJson(value.data);
      print(loginModel?.message);
      print(value.data['message']);
      emit(RegisterSuccessState(loginModel!));
    }).catchError((error){
      print(error.toString());
      emit(RegisterErrorState(error.toString()));
    });
  }


  IconData suffix=Icons.visibility_outlined;
  bool isPassword=true;
  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix = isPassword ?Icons.visibility_outlined:Icons.visibility_off_outlined ;
    emit(RegisterChangePasswordVisibilityState());
  }
}
