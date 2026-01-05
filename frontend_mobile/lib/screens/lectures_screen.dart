import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/masjid_provider.dart';
import '../models/lecture.dart';
import '../widgets/custom_drawer.dart';

class LecturesScreen extends StatefulWidget {
  const LecturesScreen({super.key});

  @override
  State<LecturesScreen> createState() => _LecturesScreenState();
}

class _LecturesScreenState extends State<LecturesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MasjidProvider>().loadLectures();
    });
  }

  @override
  Widget build(BuildContext context) {
    final masjidProvider = context.watch<MasjidProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Kajian'),
        backgroundColor: Colors.green[800],
      ),
      drawer: const CustomDrawer(),
      body: masjidProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : masjidProvider.errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    masjidProvider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<MasjidProvider>().loadLectures(),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            )
          : masjidProvider.lectures.isEmpty
          ? const Center(child: Text('Tidak ada jadwal kajian tersedia'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: masjidProvider.lectures.length,
              itemBuilder: (context, index) {
                final lecture = masjidProvider.lectures[index];
                return _buildLectureCard(lecture);
              },
            ),
    );
  }

  Widget _buildLectureCard(Lecture lecture) {
    final isUpcoming = lecture.date.isAfter(DateTime.now());

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    lecture.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isUpcoming)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Akan Datang',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('Pembicara: ${lecture.speaker}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${lecture.date.day}/${lecture.date.month}/${lecture.date.year} '
                  '${lecture.date.hour}:${lecture.date.minute.toString().padLeft(2, '0')}',
                ),
              ],
            ),
            if (lecture.description != null &&
                lecture.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                lecture.description!,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
