import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService {
  StripeService._();
  static final StripeService instance = StripeService._();

  Future<bool> makePayment(int amount, {String currency = 'usd'}) async {
    try {
      var response = await _createPaymentIntent(amount, currency: currency);
      if (response == null) return false;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: response,
          merchantDisplayName: 'Newsbrief',
        ),
      );

      try {
        await Stripe.instance.presentPaymentSheet();
        return true;
      } catch (e) {
        print("Error presenting payment sheet: $e");
        return false;
      }
    } catch (err, stackTrace) {
      print("Error in makePayment: $err");
      print("Stack trace: $stackTrace");
      return false;
    }
  }

  Future<String?> _createPaymentIntent(int amount,
      {String currency = 'usd'}) async {
    String? clientSecret;
    var url = Uri.parse('https://api.stripe.com/v1/payment_intents');
    print(url);

    try {
      var response = await http.post(url, headers: <String, String>{
        'Authorization':
            'Bearer sk_test_51Q1mPBRrzj49tN1wp5MZ8pM42XOiFKgG55jLyPpLgSZDGJYwhEgzsdy4CuXZM5UF4Eh9SR69IwUzuWmByqw1ZFpc00M8qkfnZn',
        'Content-type': 'application/x-www-form-urlencoded'
      }, body: {
        'amount': (amount * 100).toString(),
        'currency': currency
      }).timeout(Duration(seconds: 10)); // Added timeout

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        if (responseBody['client_secret'] != null) {
          clientSecret = responseBody['client_secret'];
        }
      } else {
        print("Error response: ${response.body}");
      }
    } catch (e, stackTrace) {
      print("Caught error: $e");
      print("Stack trace: $stackTrace");
    }

    return clientSecret;
  }
}
