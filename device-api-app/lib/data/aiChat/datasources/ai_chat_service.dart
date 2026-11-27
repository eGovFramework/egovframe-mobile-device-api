import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'dart:async';
import 'dart:convert';

import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:http/http.dart' as http;

/// AI 채팅 서버 HTTP 통신 (device-api-web /aic REST)
class AiChatService {
  static Future<Map<String, dynamic>?> askAiChat(
    Map<String, String> fields, {
    void Function(String token)? onToken,
  }) async {
    final uri = Uri.parse(AppConfig.getAiChatUrl('/askAiChatInfoStream.do'));
    final client = DeviceApiClient.openClient();

    try {
      final request = http.Request('POST', uri)
        ..headers['Accept'] = 'text/event-stream'
        ..bodyFields = fields;

      final resp = await DeviceApiClient.send(client, request, timeout: const Duration(minutes: 10));
      if (resp.statusCode != 200) {
        return null;
      }

      Map<String, dynamic>? donePayload;
      String? errorMessage;
      final buffer = StringBuffer();

      await for (final chunk in resp.stream.transform(utf8.decoder)) {
        buffer.write(chunk.replaceAll('\r\n', '\n'));
        final events = _takeSseEvents(buffer);
        for (final data in events) {
          final decoded = _decodeSseData(data);
          if (decoded == null) {
            continue;
          }
          final type = (decoded['type'] ?? '').toString();
          if (type == 'token') {
            final token = (decoded['token'] ?? '').toString();
            if (token.isNotEmpty) {
              onToken?.call(token);
            }
          } else if (type == 'done') {
            donePayload = decoded;
          } else if (type == 'error') {
            errorMessage = (decoded['resultMessage'] ?? 'ask fail').toString();
          }
        }
      }

      if (errorMessage != null) {
        throw Exception(errorMessage);
      }
      return donePayload;
    } catch (e) {
      appLog('AiChatService.askAiChat failed: $e');
      rethrow;
    } finally {
      client.close();
    }
  }

  static List<String> _takeSseEvents(StringBuffer buffer) {
    final text = buffer.toString();
    final events = <String>[];
    var start = 0;
    while (true) {
      final end = text.indexOf('\n\n', start);
      if (end < 0) {
        break;
      }
      events.add(text.substring(start, end));
      start = end + 2;
    }
    buffer
      ..clear()
      ..write(text.substring(start));
    return events;
  }

  static Map<String, dynamic>? _decodeSseData(String rawEvent) {
    final dataLines = rawEvent
        .split('\n')
        .where((line) => line.startsWith('data:'))
        .map((line) {
          final payload = line.substring(5);
          return payload.startsWith(' ') ? payload.substring(1) : payload;
        })
        .toList();
    if (dataLines.isEmpty) {
      return null;
    }
    try {
      final decoded = json.decode(dataLines.join('\n'));
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (e) {
      appLog('AiChatService SSE parse failed: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> postAiChatInfo(
    Map<String, String> fields,
  ) async {
    final uri = Uri.parse(AppConfig.getAiChatUrl('/insertAiChatInfo.do'));

    try {
      final resp = await DeviceApiClient.post(uri, body: fields);

      if (resp.statusCode != 200) {
        return null;
      }

      return resp.json;
    } catch (e) {
      appLog('AiChatService.postAiChatInfo failed: $e');
      return null;
    }
  }

  /// device-api-web이 egovframe-ai-rag에 닿는지 확인한다.
  /// 웹 서버 자체에 닿지 못하면 null이다.
  static Future<bool?> fetchAiRagConnection() async {
    final uri = Uri.parse(AppConfig.getAiChatUrl('/selectAiRagConnection.do'));

    try {
      final resp = await DeviceApiClient.get(uri, timeout: const Duration(seconds: 5));
      if (resp.statusCode != 200) {
        return null;
      }
      final connected = resp.json?['connected'];
      if (connected is bool) {
        return connected;
      }
      return null;
    } catch (e) {
      appLog('AiChatService.fetchAiRagConnection failed: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAiChatInfoList(
    String uuid,
  ) async {
    if (uuid.isEmpty) {
      return [];
    }
    final uri = Uri.parse(
      AppConfig.getAiChatUrl('/selectAiChatInfoList.do'),
    ).replace(queryParameters: {'uuid': uuid});

    try {
      final resp = await DeviceApiClient.get(uri);

      if (resp.statusCode != 200) {
        return [];
      }

      return resp.list('aiChatInfoList');
    } catch (e) {
      appLog('AiChatService.fetchAiChatInfoList failed: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> deleteAiChatInfo({
    required int sn,
    required String uuid,
  }) async {
    final uri = Uri.parse(
      AppConfig.getAiChatUrl('/deleteAiChatInfo.do'),
    ).replace(queryParameters: {'sn': sn.toString(), 'uuid': uuid});

    try {
      final resp = await DeviceApiClient.delete(uri);

      if (resp.statusCode != 200) {
        return null;
      }

      return resp.json;
    } catch (e) {
      appLog('AiChatService.deleteAiChatInfo failed: $e');
      return null;
    }
  }
}
