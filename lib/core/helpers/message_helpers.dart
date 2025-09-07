import 'package:bogoballers/core/models/message.dart';
import 'package:flutter/material.dart';

String formatConversationTimestamp(String? timestamp) {
  if (timestamp == null) return '';
  try {
    final dateTime = DateTime.parse(timestamp);
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  } catch (e) {
    return '';
  }
}

String formatChatTimestamp(String? timestamp) {
  if (timestamp == null) return '';
  try {
    final dateTime = DateTime.parse(timestamp);
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays > 0) return '${dateTime.day}/${dateTime.month}';
    if (diff.inHours > 0) {
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'now';
    }
  } catch (e) {
    return '';
  }
}

bool isDuplicateMessage(Message newMsg, List<Message> existing) {
  if (newMsg.messageId != null) {
    return existing.any((m) => m.messageId == newMsg.messageId);
  }
  return existing.any(
    (m) =>
        m.content == newMsg.content &&
        m.sentAt == newMsg.sentAt &&
        m.senderId == newMsg.senderId,
  );
}

void sortMessages(List<Message> messages) {
  messages.sort((a, b) {
    final aTime = a.sentAt;
    final bTime = b.sentAt;

    if (aTime == null && bTime == null) return 0;
    if (aTime == null) return 1;
    if (bTime == null) return -1;

    try {
      final aDate = DateTime.parse(aTime);
      final bDate = DateTime.parse(bTime);
      return aDate.compareTo(bDate);
    } catch (_) {
      return 0;
    }
  });
}

bool shouldShowDateSeparator(List<Message> messages, int index) {
  if (index == 0) return true;
  final currentMsg = messages[index];
  final previousMsg = messages[index - 1];
  if (currentMsg.sentAt == null || previousMsg.sentAt == null) return false;

  try {
    final currentDate = DateTime.parse(currentMsg.sentAt!);
    final previousDate = DateTime.parse(previousMsg.sentAt!);
    return currentDate.day != previousDate.day ||
        currentDate.month != previousDate.month ||
        currentDate.year != previousDate.year;
  } catch (_) {
    return false;
  }
}

Widget buildDateSeparator(String? timestamp) {
  if (timestamp == null) return const SizedBox.shrink();
  try {
    final date = DateTime.parse(timestamp);
    final now = DateTime.now();
    final diff = now.difference(date);

    String dateStr;
    if (diff.inDays == 0) {
      dateStr = 'Today';
    } else if (diff.inDays == 1) {
      dateStr = 'Yesterday';
    } else if (diff.inDays < 7) {
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      dateStr = weekdays[date.weekday - 1];
    } else {
      dateStr = '${date.day}/${date.month}/${date.year}';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            dateStr,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  } catch (_) {
    return const SizedBox.shrink();
  }
}
