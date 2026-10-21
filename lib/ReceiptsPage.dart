import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReceiptsPage extends StatefulWidget {
  @override
  State<ReceiptsPage> createState() => _ReceiptsPageState();
}

class _ReceiptsPageState extends State<ReceiptsPage> {

  final String stripeUrl =
      "https://buy.stripe.com/test_00w4gBc0rdQU1bCa0TbMQ00";

  double unitsConsumed = 225;
  double tariff = 8;             // ₹ per unit

  List<Map<String, dynamic>> billHistory = [
    {"month": "March 2026", "units": 148, "amount": 325, "paid": true},
    {"month": "April 2026", "units": 225, "amount": 100, "paid": false},
  ];

  double get currentBill => (unitsConsumed - 100) * tariff;

  void payNow() async {
    final Uri url = Uri.parse(stripeUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2, // 🔥 CHANGED

      child: Scaffold(

        appBar: AppBar(
          title: Text("Electricity Bills"),

          bottom: TabBar(
            tabs: [
              Tab(text: "History"),
              Tab(text: "Current Bill"),
            ],
          ),
        ),

        body: TabBarView(
          children: [

            /// ---------------- HISTORY TAB ----------------

            ListView.builder(
              itemCount: billHistory.length,

              itemBuilder: (context, index) {

                final bill = billHistory[index];

                return Card(
                  margin: EdgeInsets.all(10),

                  child: ListTile(
                    leading: Icon(Icons.receipt_long),

                    title: Text("₹ ${bill["amount"]}"),

                    subtitle: Text(
                        "${bill["month"]}\nUnits: ${bill["units"]} units"
                    ),

                    trailing: Text(
                      bill["paid"] ? "Paid" : "Pending",
                      style: TextStyle(
                        color: bill["paid"] ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),

            /// ---------------- CURRENT BILL TAB ----------------

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Text(
                    "Current Electricity Bill",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 20),

                  Text(
                      "Units Consumed: ${unitsConsumed.toStringAsFixed(1)} units"
                  ),

                  SizedBox(height: 10),

                  Text(
                    "₹ ${currentBill.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 32,
                        color: Colors.green),
                  ),

                  SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: payNow,
                    child: Text("Pay your Bill"),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}