import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/shared/styles/colors.dart';

import '../../layout/cubit/shop_cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color backgroundColor = Colors.blue,
  required Function function,
  required String text,
  double radius = 10.0,
}) =>
    Container(
      width: width,
      height: 40,
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(radius)),
      child: MaterialButton(
        onPressed: (){
          function();
        },
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultTextFormFiled({
  required TextEditingController controller,
  required TextInputType keyboardType,
  Function(String)? onFieldSubmitted,
  Function(String)? onChanged,
  required FormFieldValidator validator,
  required String labelText,
  required IconData prefixIcon,
  IconData? suffixIcon,
  bool isPassword = false,
  double radius = 20.0,
  Function()? suffixPressed,
  Function()? onTap,
  bool isClickable=true
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      onTap: onTap,
      onChanged: onChanged,
      enabled: isClickable,


      decoration: InputDecoration(
        labelText: labelText,

        labelStyle: TextStyle(
          color: defaultColor
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(
            color: defaultColor
          )
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),

        ),
        prefixIcon: Icon(
          prefixIcon,
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(
          onPressed: suffixPressed,
          icon: Icon(
            suffixIcon,
          ),
        )
            : null,
      ),
    );




void navigateTo(context,widget)=> Navigator.push(
  context,
  MaterialPageRoute(
      builder: (context) =>widget,
  ),
);
void navigateAndFinish(context,widget)=> Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
      builder: (context) =>widget,
  ),
    (Route<dynamic>route)=>false
);

Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);
void showToast({
  required String text,
required ToastState state
})=> Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

enum ToastState{SUCCESS,ERROR,WARNING}

Color chooseToastColor(ToastState state){
  Color color;
  switch(state)
      {
    case ToastState.SUCCESS:
      color=Colors.green;
      break;
      case ToastState.ERROR:
      color=Colors.red;
      break; case ToastState.WARNING:
      color=Colors.amber;
      break;
  }
  return color;
}

Widget buildListProduct( model , context, { bool isOldPrice = true})=>Padding(
  padding: const EdgeInsets.all(20.0),
  child: Container(
    height: 120,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage(model.image??""),
              width: 120,
              height: 120,
            ),
            if (model.discount != 0&&isOldPrice)
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
        SizedBox(width: 20,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model.name}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    '${model.price}',
                    style: TextStyle(
                      fontSize: 12,
                      color: defaultColor,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  if (model.discount != 0&&isOldPrice)
                    Text(
                      '${model.oldPrice}',
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough),
                    ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      ShopCubit.get(context).changeFavorites(model.id!);
                      print(model.id);
                    },
                    icon: CircleAvatar(
                      backgroundColor:
                      (ShopCubit.get(context).favorites[model.id]) ?? false
                          ? defaultColor:Colors.grey,
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
  ),
);
