const functions = require("firebase-functions");
const stripe = require("stripe")("sk_test_51JT7jkCTAUDjRNFV9VYB4FO4lDI",
"xe1hXhO5lC0UhNiuED1RByuak7wSE05aWBwvXDI41Pd4LGBxjHxj9rTUdCkMf00BEPkBRsg");

exports.stripePaymentIntentRequest = 
functions.https.onRequest(async (req, res) => {
    try {
        let customerId;

        // Gets the customer whose email id matches the one sent by the client
        const customerList = await stripe.customers.list({
            email: req.body.email,
            limit: 1
        });

        // Checks if the customer exists, if not, creates a new customer
        if (customerList.data.length !== 0) {
            customerId = customerList.data[0].id;
        } else {
            const customer = await stripe.customers.create({
                email: req.body.email
            });
            customerId = customer.id;
        }

        // Creates a temporary secret key linked with the customer
        const ephemeralKey = await stripe.ephemeralKeys.create(
            { customer: customerId },
            { apiVersion: '2023-11-26' }
        );

        // Creates a new payment intent with the amount passed in from the client
        const paymentIntent = await stripe.paymentIntents.create({
            amount: parseInt(req.body.amount),
            currency: 'AED',
            customer: customerId,
        });

        res.status(200).json({
            paymentIntent: paymentIntent.client_secret,
            ephemeralKey: ephemeralKey.secret,
            customer: customerId,
            success: true,
        });

    } catch (error) {
        console.error(error);
        res.status(404).json({ success: false, error: error.message });
    }
});
