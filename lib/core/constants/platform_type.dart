enum PlatformType {
  mobile,
  tablet,
  web;

  const PlatformType();

  static PlatformType getByDelimiter(double width, double height) {
    if (width < 600) {
      return PlatformType.mobile;
    } else if (width >= 600 && width < 1200) {
      return PlatformType.tablet;
    } else {
      return PlatformType.web;
    }
  }
}
