class CalendarEvent {
  final String id;
  final String title; // adres adı
  final DateTime start; // seçilen gün + saat
  final int durationMinutes; // şimdilik 30 dk
  final RepeatType repeat;

  const CalendarEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.durationMinutes,
    required this.repeat,
  });
}

enum RepeatType { once, weekly, monthly }

extension RepeatTypeText on RepeatType {
  String get label {
    switch (this) {
      case RepeatType.once:
        return 'Tek seferlik';
      case RepeatType.weekly:
        return 'Haftada 1';
      case RepeatType.monthly:
        return 'Ayda 1';
    }
  }
}
