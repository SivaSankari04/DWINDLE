import 'package:flutter/material.dart';
import '../c02sense.dart';

class SetupPage extends StatefulWidget {
  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {

  String? selectedState;
  String? selectedDistrict;
  String? sector;

  /// ALL INDIAN STATES / UT
  List<String> states = [
    "Andhra Pradesh","Arunachal Pradesh","Assam","Bihar","Chhattisgarh",
    "Goa","Gujarat","Haryana","Himachal Pradesh","Jharkhand","Karnataka",
    "Kerala","Madhya Pradesh","Maharashtra","Manipur","Meghalaya",
    "Mizoram","Nagaland","Odisha","Punjab","Rajasthan","Sikkim",
    "Tamil Nadu","Telangana","Tripura","Uttar Pradesh","Uttarakhand",
    "West Bengal","Delhi","Jammu & Kashmir","Ladakh"
  ];

  /// TAMIL NADU DISTRICTS
  List<String> tnDistricts = [
    "Ariyalur","Chengalpattu","Chennai","Coimbatore","Cuddalore",
    "Dharmapuri","Dindigul","Erode","Kallakurichi","Kanchipuram",
    "Kanyakumari","Karur","Krishnagiri","Madurai","Mayiladuthurai",
    "Nagapattinam","Namakkal","Nilgiris","Perambalur","Pudukkottai",
    "Ramanathapuram","Ranipet","Salem","Sivaganga","Tenkasi",
    "Thanjavur","Theni","Thoothukudi","Tiruchirappalli","Tirunelveli",
    "Tirupattur","Tiruppur","Tiruvallur","Tiruvannamalai",
    "Tiruvarur","Vellore","Viluppuram","Virudhunagar"
  ];

  /// SECTOR TYPES
  final List<String> sectors = [
    "Domestic",
    "Private Institution",
    "Government Institution"
  ];

  void _saveSettings() {

    if (selectedState == null) {
      _showError("Please select a state");
      return;
    }

    if (selectedState == "Tamil Nadu" && selectedDistrict == null) {
      _showError("Please select a district");
      return;
    }

    if (sector == null) {
      _showError("Please select sector type");
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Co2SensePage()),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("User Setup"),
        backgroundColor: Color(0xFF339966),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),

          child: Column(
            children: [

              /// STATE DROPDOWN
              DropdownButtonFormField<String>(
                value: selectedState,
                hint: Text("Select State"),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: states.map((state) {
                  return DropdownMenuItem(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedState = value;
                    selectedDistrict = null;
                  });
                },
              ),

              SizedBox(height: 20),

              /// DISTRICT DROPDOWN (ONLY FOR TAMIL NADU)
              if (selectedState == "Tamil Nadu")
                DropdownButtonFormField<String>(
                  value: selectedDistrict,
                  hint: Text("Select District"),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: tnDistricts.map((district) {
                    return DropdownMenuItem(
                      value: district,
                      child: Text(district),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDistrict = value;
                    });
                  },
                ),

              SizedBox(height: 20),

              /// SECTOR TYPE
              DropdownButtonFormField<String>(
                value: sector,
                hint: Text("Select Sector"),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: sectors.map((sec) {
                  return DropdownMenuItem(
                    value: sec,
                    child: Text(sec),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    sector = value;
                  });
                },
              ),

              SizedBox(height: 40),

              /// SAVE BUTTON
              ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF339966),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                child: Text(
                  "Save & Continue",
                  style: TextStyle(fontSize: 18),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}