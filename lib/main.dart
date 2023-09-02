import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:razorpay_upi_integration/modal/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_upi_integration/subscription_list_screen.dart';

void main() {
  runApp(const MyApp());
}

List<Product> _getPlans() {
  return [
    Product(
        name: "item1",
        price: 10,
        currency: "rupees",
        currencySymbol: "₹",
        description: "description1"),
    Product(
        name: "item2",
        price: 20,
        currency: "rupees",
        currencySymbol: "₹",
        description: "description2"),
    Product(
        name: "item3",
        price: 30,
        currency: "rupees",
        currencySymbol: "₹",
        description: "description3"),
  ];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void openRazorpay(Product product) {
    var options = {
      'key': 'rzp_test_j3rO3pgpGMhJfN',
      'amount': product.price *
          100, // amount in the smallest currency unit (e.g., paise for INR)
      'name': product.name,
      'description': product.description,
      'prefill': {
        'contact': '1234567890', // user's phone number
        'email': 'example@example.com', // user's email address
        'upi': '8435720545@ibl', // user's email address
      },
      'external': {
        'wallets': ['upi'],
      }
    };

    // Initialize and open Razorpay
    Razorpay _razorpay = Razorpay();

    void _handleExternalWallet(ExternalWalletResponse response) {
      Fluttertoast.showToast(msg: "External wallet");
    }

    void _handlePaymentSuccess(PaymentSuccessResponse response) {
      Fluttertoast.showToast(msg: "payment success for ${product.name}");
    }

    void _handlePaymentError(PaymentFailureResponse response) {
      Fluttertoast.showToast(msg: "Failed");
    }

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    List<Product> plans = _getPlans();

    return Scaffold(
      appBar: AppBar(
        title: Text('List of Plans'),
      ),
      body: ListView.builder(
        itemCount: plans.length,
        itemBuilder: (context, index) {
          var plan = plans[index];
          return ListTile(
            title: Text(plan.name),
            subtitle: Text("Description: ${plan.description}"),
            trailing: ElevatedButton(
                onPressed: () {
                  openRazorpay(plan);
                },
                child: Text("${plan.currencySymbol} ${plan.price}")),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the SubscriptionListScreen when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubscriptionListScreen(),
            ),
          );
        },
        tooltip: 'Subscriptions',
        child: Icon(Icons.subscriptions),
      ),
    );
  }
}
