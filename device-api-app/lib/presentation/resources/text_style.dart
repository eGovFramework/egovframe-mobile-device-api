import "package:flutter/cupertino.dart";
abstract class EgovText{
  static final regular = TextStyle(
    fontSize: 16,
    fontFamily: "Pretendard GOV"
  );

  static final medium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: "Pretendard GOV"
  );

  static final bold = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      fontFamily: "Pretendard GOV"
  );

  // Number
  static const int number_0 = 0;
  static const int number_1 = 1;
  static const int number_2 = 2;
  static const int number_3 = 4;
  static const int number_4 = 6;
  static const int number_5 = 8;
  static const int number_6 = 10;
  static const int number_7 = 12;
  static const int number_8 = 16;
  static const int number_9 = 20;
  static const int number_10 = 24;
  static const int number_11 = 28;
  static const int number_12 = 32;
  static const int number_13 = 36;
  static const int number_14 = 40;
  static const int number_15 = 44;
  static const int number_16 = 48;
  static const int number_17 = 56;
  static const int number_18 = 64;
  static const int number_19 = 72;
  static const int number_20 = 80;
  static const int number_21 = 96;
  static const int number_max = 100;

  // Spacing
  static const int padding_small = number_3;
  static const int padding_medium = number_8;
  static const int padding_large = number_10;

  // Title styles
  static final title = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
  fontFamily: "Pretendard GOV",
  color: Color(0xFF1E2124),
  );

  static final subtitle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  fontFamily: "Pretendard GOV",
  color: Color(0xFF1E2124),
  );

  // Caption styles
  static final caption = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  fontFamily: "Pretendard GOV",
  color: Color(0xFF58616A),
  );

  static final captionBold = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  fontFamily: "Pretendard GOV",
  color: Color(0xFF1E2124),
  );

  // Button text
  static final buttonText = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w400,
  fontFamily: "Pretendard GOV",
  color: Color(0xFFFFFFFF),
  height: 1.50,
  );

  // Body styles (Material Design 호환)
  static final bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: "Pretendard GOV",
    color: Color(0xFF1E2124),
    height: 1.5,
  );

  static final bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: "Pretendard GOV",
    color: Color(0xFF1E2124),
    height: 1.5,
  );

  static final bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: "Pretendard GOV",
    color: Color(0xFF58616A),
    height: 1.5,
  );

  // Label styles
  static final labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: "Pretendard GOV",
    color: Color(0xFF1E2124),
    height: 1.5,
  );

  static final labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: "Pretendard GOV",
    color: Color(0xFF1E2124),
    height: 1.5,
  );

  static final labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    fontFamily: "Pretendard GOV",
    color: Color(0xFF58616A),
    height: 1.5,
  );

  // Headline styles
  static final headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    fontFamily: "Pretendard GOV",
    color: Color(0xFF1E2124),
    height: 1.2,
  );

  static final headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    fontFamily: "Pretendard GOV",
    color: Color(0xFF1E2124),
    height: 1.2,
  );

  static final headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: "Pretendard GOV",
    color: Color(0xFF1E2124),
    height: 1.3,
  );

  // Display styles
  static final displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    fontFamily: "Pretendard GOV",
    color: Color(0xFF1E2124),
    height: 1.2,
  );

  static final displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    fontFamily: "Pretendard GOV",
    color: Color(0xFF1E2124),
    height: 1.2,
  );

  static final displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    fontFamily: "Pretendard GOV",
    color: Color(0xFF1E2124),
    height: 1.2,
  );
}
