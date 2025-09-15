class DistrictFormatter {
  static String formatForDisplay(String backendValue) {
    return backendValue
        .split('_')
        .map((word) => word.substring(0, 1) + word.substring(1).toLowerCase())
        .join(' ');
  }
}