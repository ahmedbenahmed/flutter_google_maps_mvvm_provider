class Utils {
  static String getURL(String keyword, double lat, double lng) {
    return "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=$keyword&location=$lat%2C$lng&radius=1500&key=AIzaSyAN1J2Ccdzuk7r_bTBCZmrgcyC0h08d9xI";
  }
}
