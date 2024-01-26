
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/shop_cubit.dart';
import 'package:shop_app/layout/cubit/shop_states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if(state is ShopSuccessChangeFavoritesState){
          if(state.model.status ==false){
            showToast(text: state.model.message??"", state: ToastState.ERROR);
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).homeModel != null&&ShopCubit.get(context).categoriesModel!=null,
          builder: (context) =>
              builderWidget(ShopCubit.get(context).homeModel!,ShopCubit.get(context).categoriesModel!,context),
          fallback: (context) => Center(
            child: CircularProgressIndicator(color: defaultColor),
          ),
        );
      },
    );
  }

  Widget builderWidget(HomeModel model, CategoriesModel categoriesModel,context) => SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model.data?.banners
                      ?.map(
                        (e) => Image(
                          image: NetworkImage('${e.image}'),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                      .toList() ??
                  List.empty(),
              options: CarouselOptions(
                height: 200,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                scrollDirection: Axis.horizontal,
                viewportFraction: 1.0,
                autoPlayAnimationDuration: Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlayInterval: Duration(seconds: 3),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  Container(
                    height: 100,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index)=>buildCategoryItem(categoriesModel.data!.data![index]),
                        separatorBuilder: (context,index)=>SizedBox(width: 10,),
                        itemCount: categoriesModel.data?.data?.length??0,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Text(
                    'New Product',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),

            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childAspectRatio: 1 / 1.8,
                children: List.generate(model.data!.products!.length,
                    (index) => buildGridProduct(model.data!.products![index],context)),
              ),
            ),
          ],
        ),
      );

  Widget buildGridProduct(ProductModel productModel,context) => Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(productModel.image!),
                  width: double.infinity,
                  height: 200,
                ),
                if (productModel.discount != 0)
                  Container(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'DISCOUNT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productModel.name ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${productModel.price}',
                        style: TextStyle(
                          fontSize: 12,
                          color: defaultColor,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      if (productModel.discount != 0)
                        Text(
                          '${productModel.oldPrice}',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough),
                        ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context).changeFavorites(productModel.id??0);
                          print(productModel.id);
                        },
                        icon: CircleAvatar(
                          backgroundColor:
                          ShopCubit.get(context).favorites[productModel.id]!
                              ? defaultColor
                              : Colors.grey,
                          radius: 15,
                          child: Icon(
                            Icons.favorite_border,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),

                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );


  Widget buildCategoryItem(DataModel dataModel) =>  Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Image(
        image: NetworkImage(
            '${dataModel.image}'),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
      Container(
        color: Colors.black.withOpacity(
          .8,
        ),
        width: 100,
        child: Text(
         '${dataModel.name}',
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ],
  );

}
