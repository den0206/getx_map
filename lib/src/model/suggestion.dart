class Suggest {
  final String id;
  final String stationName;
  final String prefacture;
  final String prefactureCode;

  Suggest({
    required this.id,
    required this.stationName,
    required this.prefacture,
    required this.prefactureCode,
  });

  factory Suggest.fromJson(Map<String, dynamic> json) {
    return Suggest(
      id: json['Station']["code"],
      stationName: json['Station']["Name"],
      prefacture: json['Prefecture']["Name"],
      prefactureCode: json['Prefecture']["code"],
    );
  }
}
