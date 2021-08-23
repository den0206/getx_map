abstract class StationBase {
  final String id = "";
  final String name = "";
}

class Suggest implements StationBase {
  final String id;
  final String name;
  final String prefacture;
  final String prefactureCode;

  Suggest({
    required this.id,
    required this.name,
    required this.prefacture,
    required this.prefactureCode,
  });

  factory Suggest.fromJson(Map<String, dynamic> json) {
    return Suggest(
      id: json['Station']["code"],
      name: json['Station']["Name"],
      prefacture: json['Prefecture']["Name"],
      prefactureCode: json['Prefecture']["code"],
    );
  }
}
