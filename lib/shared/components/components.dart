import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../cubit/cubit.dart';
import '../styles/colors.dart';

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

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  void Function(String)? onSubmit,
  void Function(String)? onChanged,
  void Function()? onTap,
  bool isPassword = false,
  required String Function(String?)? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  void Function()? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      enabled: isClickable,
      onChanged: onChanged,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null ? IconButton(
          onPressed: suffixPressed,
          icon: Icon(
            suffix,
          ),
        ) : null,
        border: const OutlineInputBorder(),
      ),
    );

void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context)=> widget,
  ),
);

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
        (route) => false,
);

Widget defaultButton({
  double width = double.infinity,
  double height = 40.0,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 10.0,
  required void Function() function,
  required String text,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius,),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultTextButton({
  required Function() function,
  required String text,
}) => TextButton(
  onPressed: function,
  child: Text(text.toUpperCase(),),
);

void showToast({
  required String text,
  required ToastStates state,
  int duration = 5,
}) => Toast.show(
  text,
  duration: duration,
  backgroundColor: chooseToastColor(state),
);

enum ToastStates{SUCCESS, ERROR, WARNING}

Color chooseToastColor(ToastStates state){
  Color color;
  switch(state){
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
  }
  return color;
}

Widget buildListProduct(model, context, {bool isOldPrice = true}) => Padding(
padding: const EdgeInsets.all(20.0),
  child: Container(
    height: 120.0,
    child: Row(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage(model.image),
              width: 120.0,
              height: 120.0,
            ),
            if(model.discount != 0 && isOldPrice)
              Container(
                color: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 5.0,),
                child: const Text(
                  'DISCOUNT',
                  style: TextStyle(
                    fontSize: 8.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14.0,
                  height: 1.3,

                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    model.price.toString(),
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: defaultColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  if(model.discount != 0 && isOldPrice)
                    Text(
                      model.oldPrice.toString(),
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  const Spacer(),
                  IconButton(
                    onPressed: (){
                      ShopCubit.get(context).changeFavorites(model.id);
                    },
                    icon: CircleAvatar(
                      radius: 15.0,
                      backgroundColor: ShopCubit.get(context).favorites[model.id]! ? defaultColor : Colors.grey,
                      child: const Icon(
                        Icons.favorite_border,
                        size: 14.0,
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