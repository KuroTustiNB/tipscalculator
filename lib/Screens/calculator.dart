import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tip_calculator/Screens/settings_screen.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final controllerAmount = TextEditingController();
  final controllerpercent = TextEditingController();
  double tip = 0;

  void setDefaultValues(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('percent', value);
  }

  getDefaultValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final double percent = prefs.getDouble('percent') ?? 15;

    return percent;
  }

  @override
  Widget build(BuildContext context) {
    getDefaultValues()
        .then((value) => {controllerpercent.text = value.toString()});
    return Scaffold(
      backgroundColor: Color.fromARGB(200, 230, 230, 230),
      appBar: AppBar(
        title: const Text('Tip Calculator'),
        elevation: 3,
        backgroundColor: Color.fromARGB(255, 96, 3, 139),
      ),
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 96, 3, 139)),
              child: Text(
                'Options',
                style: TextStyle(color: Colors.white, fontSize: 25),
              )),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              final route =
                  MaterialPageRoute(builder: ((context) => const Settings()));
              Navigator.push(context, route);
            },
          ),
        ]),
      ),
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: TextFormField(
              controller: controllerAmount,
              decoration: const InputDecoration(
                  labelText: "Amount", border: UnderlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: TextFormField(
              controller: controllerpercent,
              decoration: const InputDecoration(
                  labelText: "Percent", border: UnderlineInputBorder()),
            ),
          ),
          Text("Tip to pay \$$tip"),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  double amount = double.parse(controllerAmount.text);
                  double percent = double.parse(controllerpercent.text);

                  tip = amount * percent / 100;
                  setDefaultValues(percent);
                });
              },
              child: const Text("Calculate"))
        ]),
      ),
    );
  }
}
