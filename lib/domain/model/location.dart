class Location {
  final double latitude;
  final double longitude;
  final double heading;

  const Location(this.latitude, this.longitude, this.heading);

  static Location initial() => const Location(0, 0, 0);
}