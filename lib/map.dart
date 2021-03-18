// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:math' show cos, sqrt, asin;

// import 'package:permission_handler/permission_handler.dart';

// class LiveTracker extends StatefulWidget {
//   @override
//   _LiveTrackerState createState() => _LiveTrackerState();
// }

// class _LiveTrackerState extends State<LiveTracker> {
//   GoogleMapController mapController;
//   CameraPosition cameraPosition = CameraPosition(target: LatLng(0.0, 0.0));
//   Position currentPosition;
//   Position startCoordinates;
//   Position lastCoordinates;
//   Set<Marker> markers = {};
//   PolylinePoints polylinePoints;
//   Position northeastCoordinates;
//   Position southwestCoordinates;
//   List<LatLng> polylineCoordinates = [];
//   Map<PolylineId, Polyline> polylines = {};
//   Geolocator geolocator = Geolocator();
//   double totalDistance = 0;
//   var startLat;
//   var startLong;

//   List checking = [0.0300, 0.09390];
//   @override
//   void initState() {
//     super.initState();
//     enableLocation();
//     getCurrentLocation();
//     getStreamedLocationChanges();
//     // getStreamedLocationChanges()
//     setState(() {});
//   }

//   enableLocation() async {
//     if (!await Permission.location.isGranted) {
//       await Permission.location.request();
//     }
//   }

//   getCurrentLocation() async {
//     await geolocator
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//         .then((Position position) {
//       setState(() {
//         currentPosition = position;
//         startCoordinates = position;
//         // checking.add(num.parse(position.latitude.toStringAsFixed(3)));
//         // checking.add(num.parse(position.longitude.toStringAsFixed(4)));
//         // polylineCoordinates.add(LatLng(position.latitude, position.longitude));
//         print(polylineCoordinates);
//         if (startLat == null && startLong == null) {
//           startLat = position.latitude;
//           startLong = position.longitude;
//         }
//         // print("Lat: ${position.latitude}, Lng : ${position.longitude}");
//       });

//       mapController.animateCamera(
//         CameraUpdate.newCameraPosition(CameraPosition(
//           target: LatLng(startLat, startLong),
//           zoom: 18,
//         )),
//       );

//       // add marker for the starting position of the runner
//       Marker startMarker = Marker(
//           markerId: MarkerId("$currentPosition"),
//           position: LatLng(currentPosition.latitude, currentPosition.longitude),
//           infoWindow: InfoWindow(
//             title: "Start",
//           ),
//           icon: BitmapDescriptor.defaultMarker);
//       markers.add(startMarker);
//     }).catchError((onError) {
//       print(
//           "kkkkkkkkkkkkkkkkkkkkkkkkkkkkkuuuuuuuuuuuuuuuuuuuuukk   \n$onError");
//     });
//   }

//   getStreamedLocationChanges() {
//     geolocator
//         .getPositionStream(LocationOptions(
//             accuracy: LocationAccuracy.high,
//             // distanceFilter: 5,
//             timeInterval: 1000
//             // timeInterval: 5000
//             ))
//         .listen((Position position) {
//       setState(() {
//         lastCoordinates = position;
//         print("${position.longitude} ooooo");
//         print("${checking[checking.length - 1]}");
//         print(
//             " ${position.longitude} ==  ${checking[checking.length - 1]}  $checking  bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
//         if (num.parse(position.latitude.toStringAsFixed(4)) ==
//                 checking[checking.length - 2] &&
//             num.parse(position.longitude.toStringAsFixed(4)) ==
//                 checking[checking.length - 1]) {
//           print(position.longitude);

//           print(polylineCoordinates);
//         } else {
//           print(polylineCoordinates);

//           polylineCoordinates.add(
//             LatLng(position.latitude, position.longitude),
//           );
//           print("checking adding to the list");
//           checking.add(num.parse(position.latitude.toStringAsFixed(7)));
//           checking.add(num.parse(position.longitude.toStringAsFixed(8)));
//           print(checking);
//         }
//         // if(position.latitude != checking[checking.length-2] || position.longitude!=checking[checking.length-1]){
//         //   polylineCoordinates.add(
//         //     LatLng(num.parse(position.latitude.toStringAsFixed(3)), num.parse(position.longitude.toStringAsFixed(4))),
//         //   );
//         // }

//         // print(LatLng(position.latitude, position.longitude) == polylineCoordinates[polylineCoordinates.length-1]);
//         print("object");
//         print(position.longitude.toStringAsFixed(4));
//         print(num.parse(position.longitude.toStringAsFixed(4)));
//       });
//       // n = num.parse(n.toStringAsFixed(2));
//       print(polylineCoordinates);
//       print("33333333333333333333333333333");
//       addMarkerToMap(polylineCoordinates);
//     });
//     createPolyLine();
//     print(" after the stream");
//   }

//   addMarkerToMap(List<LatLng> streamedData) {
//     var lastIndex = markers.last;
//     var firstElement = markers.first;
//     markers.retainWhere((element) => element == firstElement);
//     var polyLength = streamedData.length - 1;
//     if (streamedData.length > 1) {
//       Marker movingMarker = Marker(
//           markerId: MarkerId("${streamedData[polyLength]}"),
//           position: LatLng(streamedData[polyLength].latitude,
//               streamedData[polyLength].longitude),
//           infoWindow: InfoWindow(
//             title: "Your Present Location",
//           ),
//           icon: BitmapDescriptor.defaultMarker);
//       // add marker for the current position of the runner;
//       markers.add(movingMarker);
//       if (startCoordinates.latitude < streamedData[polyLength].latitude) {
//         southwestCoordinates = startCoordinates;
//         northeastCoordinates = lastCoordinates;
//       } else {
//         southwestCoordinates = lastCoordinates;
//         northeastCoordinates = startCoordinates;
//       }
//       mapController.animateCamera(CameraUpdate.newLatLngBounds(
//           LatLngBounds(
//             northeast: LatLng(
//                 northeastCoordinates.latitude, northeastCoordinates.longitude),
//             southwest: LatLng(
//                 southwestCoordinates.latitude, southwestCoordinates.longitude),
//           ),
//           100));

//       for (int i = 0; i < polylineCoordinates.length - 1; i++) {
//         totalDistance += _coordinateDistance(
//             polylineCoordinates[i].latitude,
//             polylineCoordinates[i].longitude,
//             polylineCoordinates[i + 1].latitude,
//             polylineCoordinates[i + 1].longitude);
//       }
//       setState(() {});
//     }
//   }

//   double _coordinateDistance(lat1, lon1, lat2, lon2) {
//     var p = 0.017453292519943295;
//     var c = cos;
//     var a = 0.5 -
//         c((lat2 - lat1) * p) / 2 +
//         c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
//     return 12742 * asin(sqrt(a));
//   }

//   createPolyLine() {
//     PolylineId id = PolylineId("poly");
//     Polyline polyline = Polyline(
//         polylineId: id,
//         color: Colors.red,
//         points: polylineCoordinates,
//         width: 3);
//     polylines[id] = polyline;
//   }

// //   var geolocator = Geolocator();
// // var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

// // StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions).listen(
// //     (Position position) {
// //         print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
// //     });

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(children: [
//         GoogleMap(
//           initialCameraPosition: cameraPosition,
//           mapType: MapType.normal,
//           onMapCreated: (GoogleMapController controller) {
//             mapController = controller;
//           },
//           zoomGesturesEnabled: true,
//           zoomControlsEnabled: true,
//           markers: markers != null ? Set<Marker>.from(markers) : null,
//           polylines: Set<Polyline>.of(polylines.values),
//         ),
//         // markers: markers != null ? Set<Marker>.from(markers) : null,
//         Align(
//           alignment: Alignment.bottomLeft,
//           child: Container(
//             width: MediaQuery.of(context).size.width * .8,
//             color: Colors.white,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 // mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Text("${totalDistance.toStringAsFixed(2)} /KM",
//                       style: TextStyle(
//                           color: Colors.orange,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold)),
//                   Text(
//                       "${lastCoordinates != null ? lastCoordinates.speedAccuracy : "0"} /ms",
//                       style: TextStyle(
//                           color: Colors.orange,
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold))
//                 ],
//               ),
//             ),
//           ),
//         )
//       ]),
//     );
//   }
// }
