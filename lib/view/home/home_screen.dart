import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbase/model/note_model.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:farmbase/utils.dart';
import 'package:farmbase/model/weather_model.dart';
import 'package:farmbase/controller/weather_controller.dart';
import 'package:farmbase/controller/note_controller.dart';

class HomeScreen extends StatefulWidget {
  // ketambahan uid
  final String uid;
  const HomeScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Widget _weatherIconWidget(String weatherCode) {
  IconData weatherIcon = WeatherIcons.day_sunny;
  switch (weatherCode) {
    case "01d":
      weatherIcon = WeatherIcons.day_sunny;
      break;
    case "01n":
      weatherIcon = WeatherIcons.night_clear;
      break;
    case "02d":
      weatherIcon = WeatherIcons.day_cloudy;
      break;
    case "02n":
      weatherIcon = WeatherIcons.night_cloudy;
      break;
    case "03d":
    case "03n":
    case "04d":
    case "04n":
      weatherIcon = WeatherIcons.cloudy;
      break;
    case "09d":
    case "09n":
      weatherIcon = WeatherIcons.showers;
      break;
    case "10d":
      weatherIcon = WeatherIcons.day_rain;
      break;
    case "10n":
      weatherIcon = WeatherIcons.night_rain;
      break;
    case "11d":
    case "11n":
      weatherIcon = WeatherIcons.thunderstorm;
      break;
    case "13d":
    case "13n":
      weatherIcon = WeatherIcons.snow;
      break;
    case "50d":
    case "50n":
      weatherIcon = WeatherIcons.fog;
      break;
    default:
      weatherIcon = WeatherIcons.na;
  }

  return Icon(
    weatherIcon,
    size: 100,
    color: AppStyle.bgColor,
  );
}

class _HomeScreenState extends State<HomeScreen> {
  Weather? weather;
  String? message;
  NoteController noteController = NoteController();
  List<NoteModel> notes = [];

  // ketambahan ini juga buat akses collection
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<Map<String, dynamic>> _users;

  void _loadUserData(String uid) async {
    final docSnapshot = await _firestore.collection('users').doc(uid).get();
    final userData = docSnapshot.data() as Map<String, dynamic>;
    setState(() {
      _users.add(userData);
    });
  }

  @override
  void initState() {
    super.initState();
    _users = [];
    _loadUserData(widget.uid);
    getNotes();
    _requestLocationPermission();
  }

  void getNotes() async {
    List<NoteModel> notes = await noteController.getNotes(widget.uid);
    setState(() {
      this.notes = notes;
    });
  }

  Future<void> _requestLocationPermission() async {
    final permissionStatus = await Permission.location.request();
    if (permissionStatus == PermissionStatus.granted) {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final controller = WeatherController();
      final newWeather = await controller.getWeather(position);
      setState(
        () {
          weather = newWeather;
        },
      );
    } else {
      setState(() {
        message = 'Akses lokasi tidak diberikan';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(weather);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   message,
                          //   style: AppStyle.mainContent,
                          // ),
                          Text(
                            'Selamat Datang',
                            style: AppStyle.mainContent,
                          ),
                          Text(
                            // _users[0]['name'],
                            _users.isNotEmpty ? _users[0]['name'] : '',
                            style: AppStyle.mainTitle,
                          )
                        ],
                      ),
                      Image.asset('assets/images/logo.png', height: 50),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppStyle.primaryColor.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: const Offset(0, 0),
                      )
                    ],
                    color: AppStyle.mainColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: weather != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              // decoration: BoxDecoration(
                              //     border:
                              //         Border.all(color: AppStyle.accentColor)),
                              child: _weatherIconWidget(weather!.iconCode),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  weather!.location,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: AppStyle.bgColor,
                                  ),
                                ),
                                Text(
                                  '${weather!.temperature}℃',
                                  style: GoogleFonts.poppins(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: AppStyle.bgColor,
                                  ),
                                ),
                                Text(
                                  weather!.description,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: AppStyle.bgColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Center(
                          child: message != null
                              ? Text(
                                  'Akses lokasi tidak diizinkan',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: AppStyle.bgColor,
                                  ),
                                )
                              : CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppStyle.bgColor),
                                ),
                        ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppStyle.primaryColor.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: const Offset(0, 0),
                      )
                    ],
                    color: AppStyle.bgColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Catatan Anda',
                          style: AppStyle.mainTitle,
                        ),
                      ),
                      SizedBox(
                        height: 310,
                        child: notes.isNotEmpty
                            ? ListView.builder(
                                itemCount: notes.length,
                                itemBuilder: (context, index) {
                                  final note = notes[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/images/img-example.png'),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            note.title,
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                              color: AppStyle.mainColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Column(
                                  children: [
                                    Image.asset('assets/images/not_found.png',
                                        height: 280),
                                    Text(
                                      'Belum ada catatan',
                                      style: AppStyle.mainDescription,
                                    ),
                                  ],
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
