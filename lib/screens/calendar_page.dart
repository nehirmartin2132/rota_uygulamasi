import 'package:flutter/material.dart';
import '../models/calendar_event.dart';

class CalendarPage extends StatefulWidget {
  // dışarıdan “sürüklenebilir adres listesi” göndermek istersen diye
  final List<String> addressPool;
  const CalendarPage({super.key, this.addressPool = const []});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Haftanın pazartesi günü
  DateTime weekStart = _startOfWeek(DateTime.now());

  // Takvim event’leri
  final List<CalendarEvent> events = [];

  // Saat aralığı
  final int startHour = 8;
  final int endHour = 18; // dahil değil
  final int slotMinutes = 30;

  @override
  Widget build(BuildContext context) {
    final days = List.generate(7, (i) => weekStart.add(Duration(days: i)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Takvim'),
        actions: [
          IconButton(
            onPressed: () => setState(
              () => weekStart = weekStart.subtract(const Duration(days: 7)),
            ),
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Önceki hafta',
          ),
          IconButton(
            onPressed: () => setState(
              () => weekStart = weekStart.add(const Duration(days: 7)),
            ),
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Sonraki hafta',
          ),
        ],
      ),
      body: Row(
        children: [
          // SOL: Adres havuzu (şimdilik)
          SizedBox(
            width: 220,
            child: _AddressPool(
              items: widget.addressPool.isNotEmpty
                  ? widget.addressPool
                  : const ['Bornova - Ev 1', 'Karşıyaka - Ev 2', 'Buca - Ev 3'],
            ),
          ),
          const VerticalDivider(width: 1),

          // SAĞ: Haftalık saatli grid
          Expanded(
            child: Column(
              children: [
                _WeekHeader(days: days),
                const Divider(height: 1),
                Expanded(
                  child: _TimeGrid(
                    days: days,
                    startHour: startHour,
                    endHour: endHour,
                    slotMinutes: slotMinutes,
                    events: events,
                    onDrop: (addressTitle, slotStart) async {
                      final repeat = await _showRepeatSheet(context);
                      if (repeat == null) return;

                      setState(() {
                        events.add(
                          CalendarEvent(
                            id: DateTime.now().microsecondsSinceEpoch
                                .toString(),
                            title: addressTitle,
                            start: slotStart,
                            durationMinutes: slotMinutes,
                            repeat: repeat,
                          ),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<RepeatType?> _showRepeatSheet(BuildContext context) {
    return showModalBottomSheet<RepeatType>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Kayıt tipi seç',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('Tek seferlik'),
                  onTap: () => Navigator.pop(context, RepeatType.once),
                ),
                ListTile(
                  title: const Text('Haftada 1'),
                  onTap: () => Navigator.pop(context, RepeatType.weekly),
                ),
                ListTile(
                  title: const Text('Ayda 1'),
                  onTap: () => Navigator.pop(context, RepeatType.monthly),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AddressPool extends StatelessWidget {
  final List<String> items;
  const _AddressPool({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F9F7),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Adresler', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final t = items[i];
                return Draggable<String>(
                  data: t,
                  feedback: Material(
                    color: Colors.transparent,
                    child: _addrCard(t, active: true),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.35,
                    child: _addrCard(t),
                  ),
                  child: _addrCard(t),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _addrCard(String t, {bool active = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE0F2E5) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(blurRadius: 6, offset: Offset(0, 3), color: Colors.black12),
        ],
      ),
      child: Text(t, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}

class _WeekHeader extends StatelessWidget {
  final List<DateTime> days;
  const _WeekHeader({required this.days});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          const SizedBox(width: 70), // saat kolonu boşluğu
          ...days.map((d) => Expanded(child: _dayChip(d))),
        ],
      ),
    );
  }

  Widget _dayChip(DateTime d) {
    const names = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final idx = (d.weekday - 1).clamp(0, 6);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(names[idx], style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(
            '${d.day}.${d.month}.${d.year}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _TimeGrid extends StatelessWidget {
  final List<DateTime> days;
  final int startHour;
  final int endHour;
  final int slotMinutes;

  final List<CalendarEvent> events;
  final Future<void> Function(String addressTitle, DateTime slotStart) onDrop;

  const _TimeGrid({
    required this.days,
    required this.startHour,
    required this.endHour,
    required this.slotMinutes,
    required this.events,
    required this.onDrop,
  });

  @override
  Widget build(BuildContext context) {
    final slotsPerHour = 60 ~/ slotMinutes;
    final totalSlots = (endHour - startHour) * slotsPerHour;

    return ListView.builder(
      itemCount: totalSlots,
      itemBuilder: (context, slotIndex) {
        final minutesFromStart = slotIndex * slotMinutes;
        final hour = startHour + (minutesFromStart ~/ 60);
        final minute = minutesFromStart % 60;

        return SizedBox(
          height: 48,
          child: Row(
            children: [
              // saat etiketi
              SizedBox(
                width: 70,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    _hhmm(hour, minute),
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ),

              // 7 gün kolonları
              ...days.map((day) {
                final slotStart = DateTime(
                  day.year,
                  day.month,
                  day.day,
                  hour,
                  minute,
                );
                final ev = _eventAt(slotStart);

                return Expanded(
                  child: DragTarget<String>(
                    onWillAccept: (_) => true,
                    onAccept: (addressTitle) => onDrop(addressTitle, slotStart),
                    builder: (context, candidate, rejected) {
                      final active = candidate.isNotEmpty;
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: active
                              ? const Color(0xFFE0F2E5)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: ev == null
                            ? const SizedBox.expand()
                            : _EventPill(title: ev.title, repeat: ev.repeat),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  CalendarEvent? _eventAt(DateTime slotStart) {
    // şimdilik: aynı slotStart’a event varsa göster
    for (final e in events) {
      if (e.start.year == slotStart.year &&
          e.start.month == slotStart.month &&
          e.start.day == slotStart.day &&
          e.start.hour == slotStart.hour &&
          e.start.minute == slotStart.minute) {
        return e;
      }
    }
    return null;
  }

  String _hhmm(int h, int m) =>
      '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

class _EventPill extends StatelessWidget {
  final String title;
  final RepeatType repeat;
  const _EventPill({required this.title, required this.repeat});

  @override
  Widget build(BuildContext context) {
    final tag = repeat.label;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      alignment: Alignment.centerLeft,
      child: Text(
        '$title • $tag',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

DateTime _startOfWeek(DateTime d) {
  final day = DateTime(d.year, d.month, d.day);
  final diff = day.weekday - DateTime.monday; // 0..6
  return day.subtract(Duration(days: diff));
}
