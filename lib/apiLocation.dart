// To parse this JSON data, do
//
//     final apiLocation = apiLocationFromJson(jsonString);

import 'dart:convert';

ApiLocation apiLocationFromJson(String str) => ApiLocation.fromJson(json.decode(str));

String apiLocationToJson(ApiLocation data) => json.encode(data.toJson());

class ApiLocation {
  String? query;
  String? status;
  String? country;
  String? countryCode;
  String? region;
  String? regionName;
  String? city;
  String? zip;
  double? lat;
  double? lon;
  String? timezone;
  String? isp;
  String? org;
  String? apiLocationAs;

  ApiLocation({
    this.query,
    this.status,
    this.country,
    this.countryCode,
    this.region,
    this.regionName,
    this.city,
    this.zip,
    this.lat,
    this.lon,
    this.timezone,
    this.isp,
    this.org,
    this.apiLocationAs,
  });

  factory ApiLocation.fromJson(Map<String, dynamic> json) => ApiLocation(
    query: json["query"],
    status: json["status"],
    country: json["country"],
    countryCode: json["countryCode"],
    region: json["region"],
    regionName: json["regionName"],
    city: json["city"],
    zip: json["zip"],
    lat: json["lat"]?.toDouble(),
    lon: json["lon"]?.toDouble(),
    timezone: json["timezone"],
    isp: json["isp"],
    org: json["org"],
    apiLocationAs: json["as"],
  );

  Map<String, dynamic> toJson() => {
    "query": query,
    "status": status,
    "country": country,
    "countryCode": countryCode,
    "region": region,
    "regionName": regionName,
    "city": city,
    "zip": zip,
    "lat": lat,
    "lon": lon,
    "timezone": timezone,
    "isp": isp,
    "org": org,
    "as": apiLocationAs,
  };
}
