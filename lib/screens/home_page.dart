import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFEAF6EC), Color(0xFFDDEEE0)],
            ),
          ),
          child: Column(
            children: [
              // Üst aksiyon bar (Adresler dropdown + Dosya Yükleme + Takvim)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    // Adresler dropdown (placeholder)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: 'Adresler',
                          items: const [
                            DropdownMenuItem(
                              value: 'Adresler',
                              child: Text('Adresler'),
                            ),
                          ],
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                    const Spacer(),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: cs.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // sonraki adım: excel import
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Dosya Yükleme (yakında)')),
                        );
                      },
                      child: const Text('Dosya Yükleme'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.black12),
                        ),
                      ),
                      onPressed: () {
                        // sonraki adım: takvim ekranı
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Takvim (yakında)')),
                        );
                      },
                      child: const Text('Takvim'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Orta kart (Adres Sürükle + Adres Seç dropdown)
              Expanded(
                child: Center(
                  child: Container(
                    width: 520,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.black12),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 18,
                          offset: Offset(0, 8),
                          color: Colors.black12,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Adres Sürükle',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: 'Adres Seç',
                              items: const [
                                DropdownMenuItem(
                                  value: 'Adres Seç',
                                  child: Text('Adres Seç'),
                                ),
                              ],
                              onChanged: (_) {},
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Burayı bir sonraki adımda Drag & Drop alanına çevireceğiz.',
                          style: TextStyle(color: Colors.grey.shade700),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
