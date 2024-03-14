const googleApiKey = 'AIzaSyBvJ4YZ-lW4s5Flr6rwn-sfEHd-0Ad5KiU';

class LocationUtil {
  static String generateLocationPreviewImage({
    double? latitude,
    double? longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=18&size=600x300&maptype=satellite&key=$googleApiKey';
  }

  static String generateLocationPreviewMapCircleSatellite({
    double? latitude,
    double? longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&maptype=satellite&key=$googleApiKey';
  }

  static String generateLocationPreviewMapCircleTerrain({
    double? latitude,
    double? longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&key=$googleApiKey';
  }
}
