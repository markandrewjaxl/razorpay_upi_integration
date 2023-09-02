// subscription_list.dart
import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:razorpay_upi_integration/modal/product.dart';

class SubscriptionListScreen extends StatefulWidget {
  @override
  _SubscriptionListScreenState createState() => _SubscriptionListScreenState();
}

class _SubscriptionListScreenState extends State<SubscriptionListScreen> {
  List<dynamic> subscriptions = [];

  // Function to fetch subscriptions (simulated data)
  Future<List> fetchSubscriptions() async {
    const String apiKey = 'rzp_test_A576OMM4Uf3RhE';
    const String apiSecret = 'nMRcbBdAygdFDDGIUke8dkLC';

    final response = await http.get(
      Uri.parse('https://api.razorpay.com/v1/subscriptions'),
      headers: {
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$apiKey:$apiSecret')),
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        subscriptions = jsonDecode(response.body)["items"];
      });
      return subscriptions;
    } else {
      throw Exception('Failed to load subscriptions');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch subscriptions when the screen initializes (you should replace this with actual API calls)
    fetchSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Subscriptions'),
      ),
      body: ListView.builder(
        itemCount: subscriptions.length,
        itemBuilder: (context, index) {
          var subscription = subscriptions[index];
          return ListTile(
              title: Text(subscription["item"]["name"]),
              subtitle:
                  Text("Description: ${subscription["item"]["description"]}"),
              trailing: ElevatedButton(
                onPressed: () {

                },
                child: Text(
                    "${subscription["item"]["currency"]} ${subscription["item"]["amount"]}"),
              ));
        },
      ),
    );
  }
}
