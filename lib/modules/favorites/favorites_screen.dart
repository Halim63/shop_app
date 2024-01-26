import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/shop_states.dart';
import 'package:shop_app/models/favorites_model.dart';

import '../../layout/cubit/shop_cubit.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (BuildContext context, ShopStates state) {  },
      builder: (BuildContext context, ShopStates state) {
        return ConditionalBuilder(
          condition: state is! ShopLoadingGetFavoritesState,
          builder: (BuildContext context) =>ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) =>buildListProduct(
                ShopCubit.get(context).favoritesModel!.data!.data![index].product ,context
            ),

            separatorBuilder: (context, index) => myDivider(),
            itemCount: ShopCubit.get(context).favoritesModel?.data?.data?.length??0,
          ),
          fallback: (BuildContext context)=>Center(child: CircularProgressIndicator(color: defaultColor,)),
        );
      },
    );
  }

}
