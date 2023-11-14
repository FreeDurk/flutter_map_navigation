import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ryde_navi_app/constants/theme_data.dart';
import 'package:ryde_navi_app/screens/auth/repository/auth_repository.dart';
import 'package:ryde_navi_app/screens/dashboard/map_screen.dart';
import 'package:ryde_navi_app/screens/dashboard/services/location_service.dart';
import 'package:ryde_navi_app/utils/loader.dart';

class Dashboard extends StatefulWidget {
  final Function onSignOut;
  const Dashboard({super.key, required this.onSignOut});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final AuthRepository authRepo = AuthRepository();
  LocationData? currentLocation;
  Set<Marker> markers = {};
  AppLocationService appLocationService = AppLocationService();

  @override
  void initState() {
    mapSetup();
    super.initState();
  }

  mapSetup() {
    appLocationService.checkService().then(
          (value) => {
            if (value)
              {
                appLocationService.getLocation().then((location) {
                  setState(() {
                    currentLocation = location;
                  });
                })
              }
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: currentLocation != null ? const MapScreen() : const AppLoading(),
      ),
    );
  }
}
