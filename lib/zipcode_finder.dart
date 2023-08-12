import 'package:flutter/material.dart';
import 'package:flutter_location/resource_selection.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class ZipcodeFinder extends StatefulWidget {
  // Stateful can selfmodify
  const ZipcodeFinder({Key? key}) : super(key: key); // stores/ID's page state
  @override
  State<ZipcodeFinder> createState() => _zipcodeState(); // create a state
}

class _zipcodeState extends State<ZipcodeFinder> {
  String? _currentAddress; // variable for storing address
  Position? _currentPosition;

  get placemarks => null; // variable for storing position

// method to check/request location services
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled; // BUG: WHY IS IT NOT INCREMENTING??????
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if location disabled, ask user to enable, return false

    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enable location services')));
      return false;
    }
    // since location disabled, check if user gave permission for location enabling
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // since permissions are set to denied, request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // since permission explicitly denied, notify user, return false
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions denied')));
        return false;
      }
    }
    // permanent denial of permission, notify user, return false
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location permissions permanently denied'),
      ));
      return false;
    }
    // else, permissions granted, return true :)
    return true;
  }

  // find the current position
  Future<void> _getCurrentPosition() async {
    final hasPermission =
        await _handleLocationPermission(); // check if permission granted

    if (!hasPermission) return;
    // if permission granted, get current location as a Position
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text("Location Page")),
        body: SafeArea(
            child: Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          // fields displaying info when button pressed
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Latitude: ${_currentPosition?.latitude}'),
            Text('Longitude: ${_currentPosition?.longitude}'),
            const SizedBox(height: 32),
            ElevatedButton(
                onPressed: _getCurrentPosition,
                child: const Text('Find my location')),
          ]),

          // button to search for zipcode
          const SizedBox(width: 55),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: ZipcodeSearch(
                          _currentPosition!.latitude,
                          _currentPosition!
                              .longitude)); // sending current location to ZipcodeSearch
                },
                child: const Text('Find my zipcode'))
          ])
        ]))));
  }
}

// creating the class ZipcodeSearch to extend SearchDelegate
class ZipcodeSearch extends SearchDelegate {
  // storing current position passed from _zipcodeState widget
  ZipcodeSearch(this.latnow, this.longnow);
  final double latnow;
  final double longnow;

  // list of all viable zipcodes to query for
  List<String> searchTerms = [
    '94102',
    '94103',
    '94104',
    '94105',
    '94107',
    '94108',
    '94109',
    '94110',
    '94111',
    '94112',
    '94114',
    '94115',
    '94116',
    '94117',
    '94118',
    '94121',
    '94122',
    '94123',
    '94124',
    '94127',
    '94129',
    '94130',
    '94131',
    '94132',
    '94133',
    '94134',
    '94158',
  ];
  // clearing the search bar
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.clear,
          color: Colors.blue,
        ),
      ),
    ];
  }

// navigating out of the search bar
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back, color: Colors.blue),
    );
  }

// show query result
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var zipcode in searchTerms) {
      if (zipcode.contains(query)) {
        matchQuery.add(zipcode);
      }
    }
    // clickable results only after Enter is pressed
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var searchResult = matchQuery[index];
          return ListTile(
              title: Text(searchResult),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResourcePage(
                          specified_search: searchResult,
                          current_lat: latnow,
                          current_long:
                              longnow)))); // sending current position to ResourcePage
        });
  }

// showing query process
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var zipcode in searchTerms) {
      if (zipcode.contains(query)) {
        matchQuery.add(zipcode);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var searchResult = matchQuery[index];
        return ListTile(
          title: Text(searchResult),
        );
      },
    );
  }
}
