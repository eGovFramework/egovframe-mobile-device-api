import 'dart:convert';

import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/state/iot_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/widgets/iot_connection_status_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_connection_bar.dart';
import 'package:flutter/material.dart';

/// 메인: 연결 상태 + 온습도 텔레메트리 + 전원 제어 명령
class IotOverview extends StatelessWidget {
  final IotMainState mainState;
  final VoidCallback onSendCommand;
  final VoidCallback onToggleMqtt;

  const IotOverview({
    super.key,
    required this.mainState,
    required this.onSendCommand,
    required this.onToggleMqtt,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final config = mainState.config;
    final telemetry = mainState.latestTelemetry;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MqttStatusBar(
          isConnected: mainState.isConnected,
          isConnecting: mainState.isConnecting,
          connectedLabel: l10n.iotConnected,
          connectingLabel: l10n.iotConnecting,
          disconnectedLabel: l10n.iotDisconnected,
          brokerSummary: '${config.host}:${config.port} · ${config.deviceId}',
          hint: l10n.iotMainConnectHint,
          connectLabel: l10n.iotBarConnectButton,
          disconnectLabel: l10n.iotBarDisconnectButton,
          onToggleMqtt: onToggleMqtt,
        ),
        const SizedBox(height: 8),
        const IotConnectionBar(),
        const SizedBox(height: 24),
        _SectionTitle(title: l10n.iotTelemetrySection),
        const SizedBox(height: 8),
        _TelemetryCard(
          temperatureLabel: l10n.iotTemperatureLabel,
          humidityLabel: l10n.iotHumidityLabel,
          temperature: telemetry?.temperatureText ?? '-',
          humidity: telemetry?.humidityText ?? '-',
          rawPayload: telemetry?.rawPayload,
          emptyText: l10n.iotTelemetryEmpty,
          receivedAt: telemetry?.receivedAt,
        ),
        const SizedBox(height: 24),
        _SectionTitle(title: l10n.iotCommandSection),
        const SizedBox(height: 8),
        CustomButton(
          text: l10n.iotSendCommandButton,
          onTap: mainState.isConnected ? onSendCommand : null,
        ),
        const SizedBox(height: 12),
        _LastCommandLine(
          emptyText: l10n.iotLastCommandEmpty,
          payload: mainState.lastCommandPayload,
        ),
        if (!mainState.isConnected) ...[
          const SizedBox(height: 16),
          Text(
            l10n.iotMainConnectHint,
            style: EgovText.caption.copyWith(color: EgovColor.gray60),
          ),
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: EgovText.subtitle.copyWith(color: EgovColor.gray90),
    );
  }
}

class _LastCommandLine extends StatelessWidget {
  final String emptyText;
  final String? payload;

  const _LastCommandLine({
    required this.emptyText,
    required this.payload,
  });

  String _formatPayload(String raw) {
    try {
      final decoded = json.decode(raw);
      if (decoded is Map<String, dynamic>) {
        final action = decoded['action'];
        final value = decoded['value'];
        final requestId = decoded['requestId'];
        return 'action: $action\nvalue: $value\nrequestId: $requestId';
      }
    } catch (_) {
      // fall through
    }
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final text = payload == null ? emptyText : _formatPayload(payload!);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: EgovColor.gray5,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: EgovColor.gray20),
      ),
      child: Text(
        text,
        style: EgovText.caption.copyWith(
          color: payload == null ? EgovColor.gray50 : EgovColor.gray90,
          height: 1.5,
        ),
      ),
    );
  }
}

class _MqttStatusBar extends StatelessWidget {
  final bool isConnected;
  final bool isConnecting;
  final String connectedLabel;
  final String connectingLabel;
  final String disconnectedLabel;
  final String brokerSummary;
  final String hint;
  final String connectLabel;
  final String disconnectLabel;
  final VoidCallback onToggleMqtt;

  const _MqttStatusBar({
    required this.isConnected,
    required this.isConnecting,
    required this.connectedLabel,
    required this.connectingLabel,
    required this.disconnectedLabel,
    required this.brokerSummary,
    required this.hint,
    required this.connectLabel,
    required this.disconnectLabel,
    required this.onToggleMqtt,
  });

  @override
  Widget build(BuildContext context) {
    final color = isConnected
        ? EgovColor.primary50
        : (isConnecting ? EgovColor.secondary50 : EgovColor.gray50);
    final label = isConnected
        ? connectedLabel
        : (isConnecting ? connectingLabel : disconnectedLabel);

    return FeatureConnectionBar(
      title: label,
      detail: brokerSummary,
      statusColor: color,
      hint: hint,
      backgroundColor: EgovColor.primary5,
      borderColor: EgovColor.primary20,
      titleColor: color,
      showTrailingIcon: false,
      trailing: FeatureConnectionActionButton(
        label: isConnected ? disconnectLabel : connectLabel,
        filled: !isConnected,
        isLoading: isConnecting,
        onPressed: onToggleMqtt,
      ),
    );
  }
}

class _TelemetryCard extends StatelessWidget {
  final String temperatureLabel;
  final String humidityLabel;
  final String temperature;
  final String humidity;
  final String? rawPayload;
  final String emptyText;
  final DateTime? receivedAt;

  const _TelemetryCard({
    required this.temperatureLabel,
    required this.humidityLabel,
    required this.temperature,
    required this.humidity,
    required this.rawPayload,
    required this.emptyText,
    required this.receivedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EgovColor.white100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: EgovColor.gray20),
      ),
      child: rawPayload == null
          ? Text(
              emptyText,
              style: EgovText.regular.copyWith(color: EgovColor.gray60),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _Metric(
                        label: temperatureLabel,
                        value: '$temperature °C',
                      ),
                    ),
                    Expanded(
                      child: _Metric(
                        label: humidityLabel,
                        value: '$humidity %',
                      ),
                    ),
                  ],
                ),
                if (receivedAt != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    receivedAt!.toLocal().toString(),
                    style: EgovText.caption.copyWith(color: EgovColor.gray50),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  rawPayload!,
                  style: EgovText.caption.copyWith(color: EgovColor.gray70),
                ),
              ],
            ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;

  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: EgovText.caption.copyWith(color: EgovColor.gray60)),
        const SizedBox(height: 4),
        Text(
          value,
          style: EgovText.title.copyWith(color: EgovColor.primary50),
        ),
      ],
    );
  }
}
