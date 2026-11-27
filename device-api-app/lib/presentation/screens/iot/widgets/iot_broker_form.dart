import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/state/iot_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 브로커 설정 폼
class IotBrokerForm extends StatelessWidget {
  final IotMainState mainState;
  final TextEditingController hostController;
  final TextEditingController portController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController deviceIdController;
  final ValueChanged<String> onHostChanged;
  final ValueChanged<String> onPortChanged;
  final ValueChanged<String> onUsernameChanged;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onDeviceIdChanged;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const IotBrokerForm({
    super.key,
    required this.mainState,
    required this.hostController,
    required this.portController,
    required this.usernameController,
    required this.passwordController,
    required this.deviceIdController,
    required this.onHostChanged,
    required this.onPortChanged,
    required this.onUsernameChanged,
    required this.onPasswordChanged,
    required this.onDeviceIdChanged,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final config = mainState.config;
    final fieldsEnabled = !mainState.isConnected && !mainState.isConnecting;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.iotBrokerSection,
          style: EgovText.subtitle.copyWith(color: EgovColor.gray90),
        ),
        const SizedBox(height: 12),
        _Field(
          label: l10n.iotHostLabel,
          controller: hostController,
          enabled: fieldsEnabled,
          onChanged: onHostChanged,
          hint: '127.0.0.1 / 10.0.2.2',
        ),
        _Field(
          label: l10n.iotPortLabel,
          controller: portController,
          enabled: fieldsEnabled,
          onChanged: onPortChanged,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        _Field(
          label: l10n.iotUsernameLabel,
          controller: usernameController,
          enabled: fieldsEnabled,
          onChanged: onUsernameChanged,
        ),
        _Field(
          label: l10n.iotPasswordLabel,
          controller: passwordController,
          enabled: fieldsEnabled,
          onChanged: onPasswordChanged,
          obscureText: true,
        ),
        _Field(
          label: l10n.iotDeviceIdLabel,
          controller: deviceIdController,
          enabled: fieldsEnabled,
          onChanged: onDeviceIdChanged,
        ),
        const SizedBox(height: 8),
        Text(
          '${l10n.iotTelemetryTopicLabel}: ${config.telemetryTopic}',
          style: EgovText.caption.copyWith(color: EgovColor.gray60),
        ),
        const SizedBox(height: 4),
        Text(
          '${l10n.iotCommandTopicLabel}: ${config.commandTopic}',
          style: EgovText.caption.copyWith(color: EgovColor.gray60),
        ),
        const SizedBox(height: 16),
        if (mainState.isConnected)
          CustomButton(
            text: l10n.iotDisconnectButton,
            onTap: onDisconnect,
            icon: const Icon(
              Icons.link_off,
              color: EgovColor.white100,
              size: 20,
            ),
          )
        else
          CustomButton(
            text: l10n.iotConnectButton,
            isLoading: mainState.isConnecting,
            onTap: onConnect,
            icon: const Icon(Icons.link, color: EgovColor.white100, size: 20),
          ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _Field({
    required this.label,
    required this.controller,
    required this.enabled,
    required this.onChanged,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: EgovText.caption.copyWith(color: EgovColor.gray70)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            enabled: enabled,
            onChanged: onChanged,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: enabled ? EgovColor.white100 : EgovColor.gray5,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: EgovColor.gray20),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: EgovColor.gray20),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
