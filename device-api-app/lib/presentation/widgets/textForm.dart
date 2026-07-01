import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final bool showClearButton;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    this.isPassword = false,
    this.validator,
    this.controller,
    this.keyboardType,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.showClearButton = true,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant CustomTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onTextChanged);
      widget.controller?.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _clearText() {
    widget.controller?.clear();
  }

  bool get _hasText =>
      widget.controller != null && widget.controller!.text.isNotEmpty;

  Widget? _buildClearButton() {
    if (!widget.showClearButton || !widget.enabled || !_hasText) {
      return null;
    }

    return IconButton(
      icon: const Icon(Icons.clear, size: 20),
      tooltip: '입력 지우기',
      onPressed: _clearText,
    );
  }

  Widget? _buildSuffixIcon() {
    final clearButton = _buildClearButton();

    if (clearButton != null && widget.suffixIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [clearButton, widget.suffixIcon!],
      );
    }

    return clearButton ?? widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: const OutlineInputBorder(),
            suffixIcon: _buildSuffixIcon(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}

/// 비밀번호 필드 전용 위젯 (보기/숨기기 + 입력 지우기)
class PasswordTextFormField extends StatefulWidget {
  final String label;
  final String hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final int? maxLength;
  final bool showClearButton;

  const PasswordTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    this.validator,
    this.controller,
    this.maxLength,
    this.showClearButton = true,
  });

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant PasswordTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onTextChanged);
      widget.controller?.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _clearText() {
    widget.controller?.clear();
  }

  bool get _hasText =>
      widget.controller != null && widget.controller!.text.isNotEmpty;

  Widget _buildSuffixIcon() {
    final icons = <Widget>[];

    if (widget.showClearButton && _hasText) {
      icons.add(
        IconButton(
          icon: const Icon(Icons.clear, size: 20),
          tooltip: '입력 지우기',
          onPressed: _clearText,
        ),
      );
    }

    icons.add(
      IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
        ),
        tooltip: _obscureText ? '비밀번호 표시' : '비밀번호 숨기기',
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: icons,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          maxLength: widget.maxLength,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: const OutlineInputBorder(),
            suffixIcon: _buildSuffixIcon(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
