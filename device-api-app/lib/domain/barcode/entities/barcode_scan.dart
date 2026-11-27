class BarcodeScan {
  final String? codeType;
  final String? codeText;
  final bool isActive;

  const BarcodeScan({
    this.codeType,
    this.codeText,
    this.isActive = false,
  });

  const BarcodeScan.inactive()
      : codeType = null,
        codeText = null,
        isActive = false;

  bool get hasReading =>
      isActive && codeType != null && codeText != null && codeText!.isNotEmpty;

  BarcodeScan copyWith({
    String? codeType,
    String? codeText,
    bool? isActive,
  }) {
    return BarcodeScan(
      codeType: codeType ?? this.codeType,
      codeText: codeText ?? this.codeText,
      isActive: isActive ?? this.isActive,
    );
  }
}
