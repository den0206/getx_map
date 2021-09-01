String distanceFormat(int valueInMeters) {
  if (valueInMeters >= 1000) {
    return "${(valueInMeters / 1000).toStringAsFixed(1)}\nkm";
  }
  return "$valueInMeters\nm";
}

String meterFormatKm(double distanceInMeters) {
  if (distanceInMeters >= 1000) {
    return "${(distanceInMeters / 1000).toStringAsFixed(1)}\ km";
  }

  final m = distanceInMeters.toInt();

  return "$m\ m";
}
