import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ryde_navi_app/screens/auth/repository/auth_repository.dart';
import 'package:ryde_navi_app/screens/dashboard/model/destination_model.dart';
import 'package:ryde_navi_app/screens/dashboard/model/place_suggestion.dart';
import 'package:ryde_navi_app/screens/dashboard/utils/map_screen.dart';
import 'package:ryde_navi_app/screens/dashboard/services/location_service.dart';
import 'package:ryde_navi_app/screens/dashboard/utils/location_search.dart';
import 'package:ryde_navi_app/screens/drawer/drawer.dart';
import 'package:ryde_navi_app/utils/loader.dart';

class Dashboard extends StatefulWidget {
  final Function onSignOut;

  const Dashboard({Key? key, required this.onSignOut}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final AuthRepository authRepo = AuthRepository();
  LocationData? currentLocation;
  final destinationController = StreamController<DestinationModel?>.broadcast();
  Set<Marker> markers = {};
  AppLocationService appLocationService = AppLocationService();
  Future<void>? _mapSetupFuture;
  @override
  void initState() {
    super.initState();
    _mapSetupFuture = mapSetup();
  }

  @override
  void dispose() {
    destinationController.close();
    super.dispose();
  }

  Future<void> mapSetup() async {
    if (await appLocationService.checkService()) {
      final location = await appLocationService.getLocation();
      setState(() {
        currentLocation = location;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showLocationSearch(context),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: FutureBuilder(
          future: _mapSetupFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading();
            }

            return currentLocation != null
                ? MapScreen(
                    currentLocation: currentLocation!,
                    destinationStream: destinationController.stream,
                  )
                : const AppLoading();
          },
        ),
      ),
    );
  }

  Future<void> _showLocationSearch(BuildContext context) async {
    final searchResult = await showSearch(
      context: context,
      delegate: LocationSearch(
        hintText: "Where to?",
        searchTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.grey[500],
            ),
      ),
    );

    _handleSearchResult(searchResult);
  }

  void _handleSearchResult(PlaceSuggestionModel? searchResult) async {
    if (searchResult != null) {
      final DestinationModel? destinationModel =
          await appLocationService.destination(searchResult.placeId);
      destinationController.add(destinationModel);
    }
  }
}
