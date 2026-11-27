import 'dart:async';

import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/ai_chat_think_stripper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class AiChatTranscript extends StatefulWidget {
  final List<AiChatInfo> messages;
  final String pendingQuestion;
  final String pendingQuestionTimestamp;
  final String pendingAnswer;
  final bool isAsking;
  final String emptyText;

  const AiChatTranscript({
    super.key,
    required this.messages,
    this.pendingQuestion = '',
    this.pendingQuestionTimestamp = '',
    this.pendingAnswer = '',
    this.isAsking = false,
    required this.emptyText,
  });

  @override
  State<AiChatTranscript> createState() => _AiChatTranscriptState();
}

class _AiChatTranscriptState extends State<AiChatTranscript> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (_itemCount > 0) {
      _scrollToBottom();
    }
  }

  @override
  void didUpdateWidget(covariant AiChatTranscript oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_itemCount > _countItems(oldWidget) ||
        widget.isAsking != oldWidget.isAsking ||
        widget.pendingAnswer != oldWidget.pendingAnswer) {
      _scrollToBottom();
    }
  }

  int get _itemCount => _countItems(widget);

  int _countItems(AiChatTranscript source) {
    var count = source.messages.length * 2;
    if (source.pendingQuestion.isNotEmpty) {
      count += 1;
    }
    if (source.isAsking) {
      count += 1;
    }
    return count;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }

      final target = _scrollController.position.maxScrollExtent;
      if (target <= 0) {
        return;
      }

      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_itemCount == 0) {
      return Center(
        child: Text(
          widget.emptyText,
          style: EgovText.regular.copyWith(color: EgovColor.gray60),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _itemCount,
      itemBuilder: (context, index) {
        var cursor = 0;
        for (final item in widget.messages) {
          if (index == cursor) {
            return _ChatBubble(
              text: item.question,
              label: l10n.aiChatQuestionLabel,
              timestamp: item.questionTimestamp,
              isMine: true,
            );
          }
          cursor++;
          if (index == cursor) {
            return _ChatBubble(
              text: item.answer,
              label: l10n.aiChatAnswerLabel,
              timestamp: item.displayAnswerTimestamp,
              isMine: false,
              markdown: true,
            );
          }
          cursor++;
        }

        if (widget.pendingQuestion.isNotEmpty) {
          if (index == cursor) {
            return _ChatBubble(
              text: widget.pendingQuestion,
              label: l10n.aiChatQuestionLabel,
              timestamp: widget.pendingQuestionTimestamp,
              isMine: true,
            );
          }
          cursor++;
        }

        final pendingVisible = AiChatThinkStripper.visible(widget.pendingAnswer);
        return pendingVisible.isEmpty
            ? const _TypingBubble()
            : _ChatBubble(
                text: pendingVisible,
                label: l10n.aiChatAnswerLabel,
                isMine: false,
                markdown: true,
              );
      },
    );
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble> {
  int _dotCount = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 400), (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _dotCount = _dotCount % 3 + 1;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ChatBubble(
      text: '.' * _dotCount,
      isMine: false,
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final String label;
  final String timestamp;
  final bool isMine;
  final bool markdown;

  const _ChatBubble({
    required this.text,
    this.label = '',
    this.timestamp = '',
    required this.isMine,
    this.markdown = false,
  });

  String get _caption {
    final time = timestamp.trim();
    if (label.isNotEmpty && time.isNotEmpty) {
      return '$label · $time';
    }
    if (time.isNotEmpty) {
      return time;
    }
    return label;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxBubbleWidth = (screenWidth * (isMine ? 0.72 : 0.82)).clamp(220.0, 640.0);
    final bodyStyle = EgovText.regular.copyWith(
      color: EgovColor.gray90,
      height: 1.5,
    );
    final caption = _caption;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(maxWidth: maxBubbleWidth),
        decoration: BoxDecoration(
          color: isMine ? EgovColor.primary10 : EgovColor.white100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: EgovColor.gray20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (markdown)
              MarkdownBody(
                data: text,
                selectable: true,
                softLineBreak: true,
                styleSheet: MarkdownStyleSheet(
                  p: bodyStyle,
                  strong: EgovText.bold.copyWith(
                    color: EgovColor.gray90,
                    height: 1.5,
                  ),
                  em: bodyStyle.copyWith(fontStyle: FontStyle.italic),
                  listBullet: bodyStyle,
                  h1: EgovText.bold.copyWith(
                    color: EgovColor.gray90,
                    fontSize: 18,
                    height: 1.4,
                  ),
                  h2: EgovText.bold.copyWith(
                    color: EgovColor.gray90,
                    fontSize: 17,
                    height: 1.4,
                  ),
                  h3: EgovText.bold.copyWith(
                    color: EgovColor.gray90,
                    fontSize: 16,
                    height: 1.4,
                  ),
                  code: bodyStyle.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    backgroundColor: EgovColor.gray5,
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: EgovColor.gray5,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  blockSpacing: 8,
                  listIndent: 20,
                  tableBody: bodyStyle.copyWith(fontSize: 13),
                  tableHead: EgovText.bold.copyWith(
                    color: EgovColor.gray90,
                    fontSize: 13,
                  ),
                  tableBorder: TableBorder.all(color: EgovColor.gray20),
                  tableCellsPadding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                ),
              )
            else
              SelectableText(
                text,
                style: bodyStyle,
              ),
            if (caption.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                caption,
                style: EgovText.caption.copyWith(
                  color: EgovColor.gray60,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
