import 'package:flutter/material.dart';
import 'package:ryde_navi_app/screens/dashboard/model/place_suggestion.dart';
import 'package:ryde_navi_app/screens/dashboard/services/location_service.dart';
import 'package:ryde_navi_app/utils/loader.dart';

class LocationSearch extends SearchDelegate<PlaceSuggestionModel?> {
  final String hintText;
  final TextStyle? searchTextStyle;

  LocationSearch({
    required this.hintText,
    this.searchTextStyle,
  }) : super(
          searchFieldLabel: hintText,
          searchFieldStyle: searchTextStyle,
        );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    PlaceSuggestionModel? suggestion;
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, suggestion);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        'Results for: $query',
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.black),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    AppLocationService appLocationService = AppLocationService();

    return FutureBuilder(
      future: appLocationService.searchLocation(query: query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppLoading();
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final PlaceSuggestionModel place = snapshot.data![index];

            return ListTile(
              contentPadding: const EdgeInsets.only(left: 10),
              leading: Image.asset(
                "assets/images/destinationLocation.png",
                width: 40,
                height: 40,
              ),
              title: Text(
                place.structuredFormatting.mainText,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.black),
              ),
              subtitle: Text(
                place.structuredFormatting.secondaryText,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.grey[500], fontSize: 10),
              ),
              onTap: () {
                close(context, place);
              },
            );
          },
        );
      },
    );
  }
}
