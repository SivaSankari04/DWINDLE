import 'package:flutter/material.dart';
import 'co2sense_page.dart';
import '../accounts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  int _index = 0;

  final List<Widget> _pages = [
    CO2SensePage(),
    CO2SensePage(),
    Center(child: Text('Receipts', style: TextStyle(fontSize: 24))),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _pages[_index],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,

        selectedItemColor: const Color(0xFF339966),
        unselectedItemColor: Colors.black54,

        currentIndex: _index,

        onTap: (index) {
          setState(() {
            _index = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Readings',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.eco),
            label: 'CO2Sense',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Receipts',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}