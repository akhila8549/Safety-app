import 'package:flutter/material.dart';
import 'package:flutter_location/data/foodbank_model.dart';
import 'package:flutter_location/data/hospital_model.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

// put in an acutal number for the suicide hotline button

class ResourcePage extends StatefulWidget {
  // Stateful can selfmodify

  const ResourcePage(
      {required this.specified_search,
      required this.current_lat,
      required this.current_long,
      Key? key})
      : super(key: key); // stores/ID's page state
  final String specified_search;
  final double current_lat;
  final double current_long;

  @override
  State<ResourcePage> createState() => _ResourcePageState(); // create a state
}

class _ResourcePageState extends State<ResourcePage> {
  void _callNumber() async {
    // loads the page, only breaks when icon is clicked, maybe calling-from-chrome issue?
    await FlutterPhoneDirectCaller.callNumber("4158573933");
  }

  List h_data = []; // a list to store data in

// loading hospital data
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('safety_data.json');
    final data = await json.decode(response);
    setState(() {
      h_data = data["Hospitals"];
    });
  }

// converting a given address to latlong coordinates and storing as a list

  List location_list = [];

  findLocation(geoAddress) async {
    List<Location> locations = await locationFromAddress('337 Hamilton Street');
    print('$locations');
    setState(() {
      location_list.add('loc');
    });
  }

  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    // the zipcode selected by the user in previous page (zipcode_finder.dart)
    var sS = widget.specified_search;
    var latnow = widget.current_lat;
    var longnow = widget.current_long;
    int i = h_data.indexWhere((item) => item["Zipcode"] == sS);
    print(i);

    var hAddress = h_data[i]
        ['Hospital Address']; // the hospital relevant to user's zipcode
    @override
    void initState() {
      findLocation(hAddress);
    }

    // var h_lat = location_list[0];
    //var h_long = location_list[1];

// a button to find location
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text("Resource Page")),
        body: SafeArea(
            child: Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: initState, child: Text(location_list.toString())),
          SizedBox(
              height: 400,
              width: 300,
              child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition:
                      CameraPosition(target: LatLng(latnow, longnow), zoom: 15),
                  markers: {
                    Marker(
                        markerId: const MarkerId('You'),
                        position: LatLng(latnow, longnow),
                        infoWindow: const InfoWindow(title: 'You')),

                    //Marker(
                    //markerId: MarkerId('Hospital'),
                    //position: LatLng(h_lat, h_long),
                    //infoWindow: InfoWindow(title: 'Hospital')),
                  })),

          // button to find hospitals near zipcode
          const SizedBox(width: 55),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    iconSize: 100,
                    icon: const Icon(Icons.local_hospital_outlined,
                        color: Colors.blue),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HospitalPage(
                                  ss: sS,
                                )))),
                Text('$location_list'),
                const Text('near my zipcode'),
                const SizedBox(height: 45),
              ]),
          const SizedBox(width: 55),

          // button to call suicide crisis hotline
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 100,
                icon: const Icon(Icons.emergency_outlined, color: Colors.blue),
                onPressed: _callNumber,
              ),
              const SizedBox(height: 10),
              const Text('Suicide & Crisis Hotline'),
              const SizedBox(height: 40),
            ],
          ),
          const SizedBox(width: 55),

          // button to find food pantry near zipcode
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  iconSize: 100,
                  icon: const Icon(Icons.food_bank_rounded, color: Colors.blue),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FoodbankPage(zipcode: sS)))),
              const SizedBox(height: 10),
              const Text('Find a food pantry'),
              const Text('near my zipcode'),
              const SizedBox(height: 48),
            ],
          ),
        ]))));
  }
}
