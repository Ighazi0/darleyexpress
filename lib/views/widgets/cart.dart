import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/cubit/user_cubit.dart';
import 'package:darleyexpress/models/cart_model.dart';
import 'package:darleyexpress/views/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Container(
            width: dWidth,
            height: dHeight,
            color: Colors.white,
            child: Center(
              child: userCubit.cartList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/empty_cart.png'),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Your cart is empty',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    )
                  : ListView.builder(
                      itemCount: userCubit.cartList.length,
                      itemBuilder: (context, index) {
                        CartModel cart =
                            userCubit.cartList.values.toList()[index];
                        return ListTile(
                          title: Text(cart.productData.titleEn),
                          trailing: Text(cart.count.toString()),
                        );
                      }),
            ));
      },
    );
  }
}
