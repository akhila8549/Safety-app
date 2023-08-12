import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class FoodbankPage extends StatefulWidget {
  const FoodbankPage({required this.zipcode, Key? key}) : super(key: key);
  final String zipcode;
  @override
  State<FoodbankPage> createState() => _FoodbankPageState();
}

// creating a state
class _FoodbankPageState extends State<FoodbankPage> {
  List _foodbanks = []; // a list to store foodbank data

// reading the json file containing foodbank data
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('food_pantries.json');
    final data = await json.decode(response);
    setState(() {
      _foodbanks =
          data['Pantries']; // putting all the data into the _foodbanks list
    });
  }

// calling the function, reading the json
  @override
  void initState() {
    readJson();
  }

// widget displays foodbank card based on zipcode selected in previous page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Local Food Pantry'),
        ),
        body: Column(children: [
          _foodbanks.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        var setZip = widget.zipcode;
                        int ind = _foodbanks
                            .indexWhere((item) => item['Zipcode'] == setZip);

                        return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: Colors.blue,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 200, vertical: 50),
                            child: SizedBox(
                                height: 300,
                                // setting up each zipcode as a key to access the rest of each hospital's info
                                key: ValueKey(_foodbanks[ind]["Zipcode"]),
                                // indexing info vs listtile, e.g. 1st listtile contains 1st hospital's info
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(_foodbanks[ind]['Name'],
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                      Text(_foodbanks[ind]['Address'],
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white)),
                                      const SizedBox(height: 25),
                                      const Text('Pantry Hours:',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white)),
                                      Text(_foodbanks[ind]['Hours'],
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white)),
                                      const SizedBox(height: 50),
                                      const Divider(
                                          height: 50,
                                          color: Colors.white,
                                          thickness: 1,
                                          indent: 50,
                                          endIndent: 50),
                                      const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                'This app does its best to find pantries that',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white)),
                                            Text(
                                                'DO NOT require income verification.',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white)),
                                            Text(
                                                'However, pantries may require a picture ID with',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white)),
                                            Text(
                                                'your current address to sign up.',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white)),
                                            Text(
                                                'If your ID has an old address, please bring',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white)),
                                            Text(
                                                '1 piece of mail no older than 3 months.',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white)),
                                          ])
                                    ])));
                      }))
              : const SizedBox(height: 0)
        ]));
  }
}
