import 'package:flutter/material.dart';

class LocationSearch extends SearchDelegate<String> {
  final List<String> data = [
    'SM City',
    'Robinsons Galleria - Fuente',
    'Ayala Bloc IT Park',
    'E-Mall Sanciangko St.',
    'Metro Colon',
  ];

  final List<String> recentData = [
    'SM City',
    'Metro Colon',
  ];

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
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
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
    final suggestionList = query.isEmpty
        ? recentData
        : data
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        title: Text(
          suggestionList[index],
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.black),
        ),
        onTap: () {
          // query = suggestionList[index];
          close(context, suggestionList[index]);
        },
      ),
      itemCount: suggestionList.length,
    );
  }
}
