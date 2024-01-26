import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/shop_cubit.dart';
import 'package:shop_app/layout/cubit/shop_states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/styles/colors.dart';

class SettingsScreen extends StatelessWidget {
  var formkey=GlobalKey<FormState>();
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, ShopStates state) {
        if (state is ShopSuccessUserDataState) {}
      },
      builder: (BuildContext context, ShopStates state) {
        var model = ShopCubit.get(context).userModel;
        nameController.text = model?.data?.name ?? '';
        emailController.text = model?.data?.email ?? '';
        phoneController.text = model?.data?.phone ?? '';
        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key:formkey ,
                child: Column(
                  children: [
                    if(state is ShopLoadingUpdateDataState)
                      LinearProgressIndicator(color: defaultColor,),
                    SizedBox(height: 15,),
                    defaultTextFormFiled(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'must not be empty';
                          }
                          return null;
                        },
                        labelText: 'Name',
                        prefixIcon: Icons.person),
                    SizedBox(
                      height: 20,
                    ),
                    defaultTextFormFiled(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'must not be empty';
                          }
                          return null;
                        },
                        labelText: 'Email',
                        prefixIcon: Icons.email),
                    SizedBox(
                      height: 20,
                    ),
                    defaultTextFormFiled(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'must not be empty';
                          }
                          return null;
                        },
                        labelText: 'Phone Number',
                        prefixIcon: Icons.phone),
                    SizedBox(
                      height: 20,
                    ),
                    defaultButton(
                        function: () {
                         if(formkey.currentState!.validate()){
                           ShopCubit.get(context).updateUserData(
                               name: nameController.text,
                               email: emailController.text,
                               phone: phoneController.text,
                           );
                         }
                        },
                        text: 'UPDATE'),
                    SizedBox(
                      height: 20,
                    ),
                    defaultButton(
                        function: () {
                          signOut(context);
                        },
                        text: 'LOGOUT'),
                  ],
                ),
              ),
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
