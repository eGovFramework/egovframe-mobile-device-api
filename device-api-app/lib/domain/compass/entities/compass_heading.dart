class CompassHeading {
  final double? magneticHeading;
  final String? headingAccuracy;
  final bool isActive;

  const CompassHeading({
    this.magneticHeading,
    this.headingAccuracy,
    this.isActive = false,
  });

  const CompassHeading.inactive()
      : magneticHeading = null,
        headingAccuracy = null,
        isActive = false;

  CompassHeading copyWith({
    double? magneticHeading,
    String? headingAccuracy,
    bool? isActive,
  }) {
    return CompassHeading(
      magneticHeading: magneticHeading ?? this.magneticHeading,
      headingAccuracy: headingAccuracy ?? this.headingAccuracy,
      isActive: isActive ?? this.isActive,
    );
  }

  int get roundedHeading {
    if (magneticHeading == null) return 0;
    final rounded = magneticHeading!.round() % 360;
    return rounded < 0 ? rounded + 360 : rounded;
  }
}
