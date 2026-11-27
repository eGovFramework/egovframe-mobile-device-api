import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/format_utils.dart';
import 'package:flutter/material.dart';

class DeviceInfoOverview extends StatelessWidget {
  final DeviceInfo deviceInfo;
  final Widget? footer;

  const DeviceInfoOverview({
    super.key,
    required this.deviceInfo,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _DeviceInfoStatusBadge(),
        const SizedBox(height: 12),
        _DeviceSummaryCard(deviceInfo: deviceInfo),
        const SizedBox(height: 12),
        _DeviceUuidCard(deviceInfo: deviceInfo),
        const SizedBox(height: 8),
        _DeviceNetworkCard(deviceInfo: deviceInfo),
        const SizedBox(height: 12),
        _DeviceStatChipsRow(deviceInfo: deviceInfo),
        if (footer != null) ...[
          const SizedBox(height: 16),
          footer!,
        ],
      ],
    );
  }
}

class _DeviceInfoStatusBadge extends StatelessWidget {
  const _DeviceInfoStatusBadge();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: EgovColor.success50,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          l10n.deviceInfoQueryComplete,
          style: EgovText.caption.copyWith(
            color: EgovColor.gray60,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DeviceSummaryCard extends StatelessWidget {
  final DeviceInfo deviceInfo;

  const _DeviceSummaryCard({required this.deviceInfo});

  IconData get _platformIcon {
    final os = deviceInfo.os.toLowerCase();
    if (os.contains('android')) return Icons.android;
    if (os.contains('ios') || os.contains('iphone') || os.contains('ipad')) {
      return Icons.phone_iphone;
    }
    return Icons.smartphone;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EgovColor.primary5,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EgovColor.primary20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: EgovColor.primary50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_platformIcon, color: EgovColor.white100, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceInfo.deviceNm,
                  style: EgovText.title.copyWith(
                    color: EgovColor.gray90,
                    fontSize: 18,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  deviceInfo.os,
                  style: EgovText.regular.copyWith(color: EgovColor.gray70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceDetailRowCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool selectable;

  const _DeviceDetailRowCard({
    required this.icon,
    required this.label,
    required this.value,
    this.selectable = false,
  });

  @override
  Widget build(BuildContext context) {
    final valueStyle = EgovText.medium.copyWith(
      color: EgovColor.gray90,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: EgovColor.white100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: EgovColor.gray20),
        boxShadow: [
          BoxShadow(
            color: EgovColor.black10,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: EgovColor.primary50),
          const SizedBox(width: 8),
          Text(
            label,
            style: EgovText.caption.copyWith(
              color: EgovColor.gray60,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: selectable
                ? SelectableText(value, style: valueStyle)
                : Text(
                    value,
                    style: valueStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ],
      ),
    );
  }
}

class _DeviceUuidCard extends StatelessWidget {
  final DeviceInfo deviceInfo;

  const _DeviceUuidCard({required this.deviceInfo});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _DeviceDetailRowCard(
      icon: Icons.fingerprint_outlined,
      label: l10n.deviceInfoUuid,
      value: deviceInfo.uuid,
      selectable: true,
    );
  }
}

class _DeviceNetworkCard extends StatelessWidget {
  final DeviceInfo deviceInfo;

  const _DeviceNetworkCard({required this.deviceInfo});

  IconData get _networkIcon {
    final network = deviceInfo.ntwrkDeviceInfo.toLowerCase();
    if (network.contains('wifi') || network.contains('wi-fi')) {
      return Icons.wifi;
    }
    if (network.contains('mobile') ||
        network.contains('lte') ||
        network.contains('5g') ||
        network.contains('4g')) {
      return Icons.signal_cellular_alt;
    }
    return Icons.language;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _DeviceDetailRowCard(
      icon: _networkIcon,
      label: l10n.deviceInfoNetworkInfo,
      value: deviceInfo.ntwrkDeviceInfo,
    );
  }
}

class _DeviceStatChipsRow extends StatelessWidget {
  final DeviceInfo deviceInfo;

  const _DeviceStatChipsRow({required this.deviceInfo});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: _DeviceStatChip(
            label: l10n.deviceInfoStorage,
            value: FormatUtils.formatFileSize(deviceInfo.strgeInfo),
            icon: Icons.sd_storage_outlined,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _DeviceStatChip(
            label: l10n.deviceInfoContacts,
            value: deviceInfo.telno ?? '-',
            icon: Icons.contacts_outlined,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _DeviceStatChip(
            label: l10n.deviceInfoVersion,
            value: deviceInfo.pgVer,
            icon: Icons.info_outline,
          ),
        ),
      ],
    );
  }
}

class _DeviceStatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DeviceStatChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: EgovColor.white100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: EgovColor.gray20),
        boxShadow: [
          BoxShadow(
            color: EgovColor.black10,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: EgovColor.primary50),
          const SizedBox(height: 8),
          Text(
            label,
            style: EgovText.caption.copyWith(color: EgovColor.gray60),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: EgovText.medium.copyWith(
              color: EgovColor.gray90,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
