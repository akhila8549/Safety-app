import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

// gas company
// water company
// directions to hospital
// poison control
// put in an actual phone number for the ambulance/hospital/911 buttons
// card/list with Other Resources Nearby

// recieving the searched-for zipcode via ss
class HospitalPage extends StatefulWidget {
  const HospitalPage({required this.ss, Key? key}) : super(key: key);
  final String ss;

  @override
  State<HospitalPage> createState() => HospitalPageState();
}

// creating a state
class HospitalPageState extends State<HospitalPage> {
  List _hospitals = []; // a list to store data in

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('safety_data.json');
    final data = await json.decode(response);
    setState(() {
      _hospitals =
          data["Hospitals"]; // putting the all the data into _hospitals list
    });
  }

  //reading the json
  @override
  void initState() {
    readJson();
  }

  void _callNumber() async {
    // loads the page, only breaks when icon is clicked, maybe calling-from-chrome issue?
    await FlutterPhoneDirectCaller.callNumber("4158573933");
  }

// widget displays hospital card based on zipcode selected in previous page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Nearest Hospital'),
      ),
      body: Column(
        children: [
          _hospitals.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      var setZipcode = widget.ss;
                      int i = _hospitals
                          .indexWhere((item) => item['Zipcode'] == setZipcode);
                      var nfs = _hospitals[i]['Nearest Fire Station'];
                      return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.blue,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 200, vertical: 50),
                          child: SizedBox(
                            height: 300,
                            // setting up each zipcode as a key to access the rest of each hospital's info
                            key: ValueKey(_hospitals[i]["Zipcode"]),
                            // indexing info vs listtile, e.g. 1st listtile contains 1st hospital's info
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_hospitals[i]['Nearest Hospital'],
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                  Text(_hospitals[i]['Hospital Phone Number'],
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                  Text(_hospitals[i]['Hospital Address'],
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                  const SizedBox(height: 50),
                                  Text('Nearest Fire Station: $nfs',
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                  const Text(
                                      'Fire stations provide ambulances, medical services',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white)),
                                  const Text(
                                      'and supplies from trained personnel',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white)),
                                  const Divider(
                                    height: 50,
                                    color: Colors.white,
                                    thickness: 1,
                                    indent: 50,
                                    endIndent: 50,
                                  ),
                                  const Row(
                                    children: [
                                      SizedBox(width: 75),
                                      Icon(
                                        Icons.call,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 15),
                                      Text(
                                        'Call',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    children: [
                                      const SizedBox(width: 80),
                                      SizedBox(
                                          height: 30,
                                          width: 130,
                                          child: OutlinedButton(
                                              onPressed: _callNumber,
                                              style: OutlinedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50))),
                                              child: const Text("Ambulance",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 18)))),
                                      const SizedBox(width: 15),
                                      SizedBox(
                                          height: 30,
                                          width: 120,
                                          child: OutlinedButton(
                                              onPressed: _callNumber,
                                              style: OutlinedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50))),
                                              child: const Text(
                                                "Hospital",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 18),
                                              ))),
                                      const SizedBox(width: 15),
                                      SizedBox(
                                          height: 30,
                                          width: 90,
                                          child: OutlinedButton(
                                              onPressed: _callNumber,
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                              ),
                                              child: const Text("911",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 18))))
                                    ],
                                  )
                                ]),
                          ));
                    },
                  ),
                )
              : const SizedBox(height: 0),
        ],
      ),
    );
  }
}

_callSomeone(String phoneNumber) {
  // does not load the page at all, breaks before that
  String number = phoneNumber;
  FlutterPhoneDirectCaller.callNumber(number);
}
