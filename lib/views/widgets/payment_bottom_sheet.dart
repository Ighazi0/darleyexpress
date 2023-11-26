import 'package:darleyexpress/controller/my_app.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentBottomSheet extends StatefulWidget {
  const PaymentBottomSheet({super.key});

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  CardEditController controller = CardEditController();

  @override
  void initState() {
    controller.addListener(update);
    super.initState();
  }

  void update() => setState(() {});
  @override
  void dispose() {
    controller.removeListener(update);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Center(
          child: Text(
            'Add new card',
            style: TextStyle(fontSize: 25),
          ),
        ),
        Flexible(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: staticWidgets.scrollController,
            children: [
              CardField(
                controller: controller,
                dangerouslyGetFullCardDetails: true,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                child: MaterialButton(
                  onPressed: () async {
                    final paymentIntent =
                        await Stripe.instance.createPaymentIntent(
                      PaymentIntentParams(
                        amount: 100,
                        currency: 'usd',
                      ),
                    );

                    // Confirm the payment
                    final result = await Stripe.instance.confirmPayment(
                      paymentIntent.clientSecret,
                      PaymentMethodParams.card(
                        paymentMethodData: PaymentMethodData(
                          billingDetails: BillingDetails(
                            name: 'John Doe',
                            addressLine1: '123 Main Street',
                            addressLine2: 'Apt. #1',
                            city: 'San Francisco',
                            state: 'CA',
                            postalCode: '94105',
                            country: 'US',
                          ),
                        ),
                      ),
                    );

                    // Handle the payment result
                    if (result.isPending) {
                      print('Payment is pending');
                    } else if (result.isSucceeded) {
                      print('Payment succeeded');
                    } else {
                      print('Payment failed');
                    }
                  },
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  height: 45,
                  textColor: Colors.white,
                  color: primaryColor,
                  child: const Text('Pay'),
                ),
              )
            ],
          ),
        ))
      ],
    );
  }
}
