import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/styles/colors.dart';

import 'cubit/register_cubit.dart';
import 'cubit/register_states.dart';

class RegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            if (state.loginModel.status == true) {
              print(state.loginModel.data?.token);
              print(state.loginModel.message);
              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data?.token)
                  .then((value) {
                token = state.loginModel.data?.token;
                navigateAndFinish(context, LoginScreen());
              });

              showToast(
                  text: state.loginModel.message ?? "",
                  state: ToastState.SUCCESS);
            } else {
              print(state.loginModel.message);
              showToast(
                  text: state.loginModel.message ?? "",
                  state: ToastState.ERROR);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Register',
                            style: Theme.of(context).textTheme.displayMedium),
                        Text(
                          'register now to browse our hot offers',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultTextFormFiled(
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please enter your name';
                              }
                              return null;
                            },
                            labelText: 'User Name',
                            prefixIcon: Icons.person),
                        SizedBox(
                          height: 15,
                        ),
                        defaultTextFormFiled(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please enter your email address';
                              }
                              return null;
                            },
                            labelText: 'Email Address',
                            prefixIcon: Icons.email),
                        SizedBox(
                          height: 15,
                        ),
                        defaultTextFormFiled(
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'password is to short';
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) {

                            },
                            isPassword: RegisterCubit.get(context).isPassword,
                            labelText: 'Password ',
                            suffixIcon: RegisterCubit.get(context).suffix,
                            suffixPressed: () {
                              RegisterCubit.get(context)
                                  .changePasswordVisibility();
                            },
                            prefixIcon: Icons.lock),
                        SizedBox(
                          height: 15,
                        ),
                        defaultTextFormFiled(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please enter your phone number';
                              }
                              return null;
                            },
                            labelText: 'phone number',
                            prefixIcon: Icons.phone),
                        SizedBox(
                          height: 40,
                        ),
                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState,
                          fallback: (context) => Center(
                              child: CircularProgressIndicator(
                            color: defaultColor,
                          )),
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                RegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            text: 'Register',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
