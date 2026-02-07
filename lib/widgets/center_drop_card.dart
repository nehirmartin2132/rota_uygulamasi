import 'package:flutter/material.dart';

class CenterDropCard extends StatelessWidget {
  final String title;

  final String dropdownValue;
  final List<String> dropdownItems;
  final ValueChanged<String> onDropdownChanged;

  final String helperText;

  final ValueChanged<String> onDropAddress;

  const CenterDropCard({
    super.key,
    required this.title,
    required this.dropdownValue,
    required this.dropdownItems,
    required this.onDropdownChanged,
    required this.helperText,
    required this.onDropAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            offset: Offset(0, 8),
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 18),

          // DRAG & DROP ALANI
          DragTarget<String>(
            onWillAccept: (_) => true,
            onAccept: (value) {
              onDropAddress(value);
            },
            builder: (context, candidateData, rejectedData) {
              final isActive = candidateData.isNotEmpty;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFE0F2E5)
                      : const Color(0xFFF7F9F7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isActive ? Colors.green : Colors.black12,
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Adresleri buraya sürükle',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 18),

          _DropdownBox(
            value: dropdownValue,
            items: dropdownItems,
            onChanged: onDropdownChanged,
          ),

          const SizedBox(height: 18),

          Text(
            helperText,
            style: TextStyle(color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DropdownBox extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _DropdownBox({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
