import 'dart:convert';

class PlaceSuggestionModel {
  String placeId;
  String reference;
  StructuredFormatting structuredFormatting;

  PlaceSuggestionModel({
    required this.placeId,
    required this.reference,
    required this.structuredFormatting,
  });

  factory PlaceSuggestionModel.fromRawJson(String str) =>
      PlaceSuggestionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlaceSuggestionModel.fromJson(Map<String, dynamic> json) =>
      PlaceSuggestionModel(
        placeId: json["place_id"],
        reference: json["reference"],
        structuredFormatting:
            StructuredFormatting.fromJson(json["structured_formatting"]),
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "reference": reference,
        "structured_formatting": structuredFormatting.toJson(),
      };
}

class StructuredFormatting {
  String mainText;
  List<MainTextMatchedSubstring> mainTextMatchedSubstrings;
  String secondaryText;

  StructuredFormatting({
    required this.mainText,
    required this.mainTextMatchedSubstrings,
    required this.secondaryText,
  });

  factory StructuredFormatting.fromRawJson(String str) =>
      StructuredFormatting.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json["main_text"],
        mainTextMatchedSubstrings: List<MainTextMatchedSubstring>.from(
            json["main_text_matched_substrings"]
                .map((x) => MainTextMatchedSubstring.fromJson(x))),
        secondaryText: json["secondary_text"],
      );

  Map<String, dynamic> toJson() => {
        "main_text": mainText,
        "main_text_matched_substrings": List<dynamic>.from(
            mainTextMatchedSubstrings.map((x) => x.toJson())),
        "secondary_text": secondaryText,
      };
}

class MainTextMatchedSubstring {
  int length;
  int offset;

  MainTextMatchedSubstring({
    required this.length,
    required this.offset,
  });

  factory MainTextMatchedSubstring.fromRawJson(String str) =>
      MainTextMatchedSubstring.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MainTextMatchedSubstring.fromJson(Map<String, dynamic> json) =>
      MainTextMatchedSubstring(
        length: json["length"],
        offset: json["offset"],
      );

  Map<String, dynamic> toJson() => {
        "length": length,
        "offset": offset,
      };
}
