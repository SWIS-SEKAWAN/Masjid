import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/masjid_provider.dart';
import '../../models/lecture.dart';

class AdminLecturesScreen extends StatefulWidget {
  const AdminLecturesScreen({super.key});

  @override
  State<AdminLecturesScreen> createState() => _AdminLecturesScreenState();
}

class _AdminLecturesScreenState extends State<AdminLecturesScreen> {
  final _titleController = TextEditingController();
  final _speakerController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

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
        title: const Text('Kelola Kajian'),
        backgroundColor: Colors.green[800],
      ),
      body: masjidProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: masjidProvider.lectures.length,
                    itemBuilder: (context, index) {
                      final lecture = masjidProvider.lectures[index];
                      return _buildLectureCard(lecture);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: _showAddLectureDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Tambah Kajian Baru'),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLectureCard(Lecture lecture) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(lecture.title),
        subtitle: Text(
          '${lecture.speaker} - ${lecture.date.toString().split(' ')[0]}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            // TODO: Implement delete functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fitur hapus akan segera hadir')),
            );
          },
        ),
      ),
    );
  }

  void _showAddLectureDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Kajian Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Kajian'),
              ),
              TextField(
                controller: _speakerController,
                decoration: const InputDecoration(labelText: 'Pembicara'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _selectDate,
                      child: Text(
                        'Tanggal: ${_selectedDate.toString().split(' ')[0]}',
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: _selectTime,
                      child: Text('Waktu: ${_selectedTime.format(context)}'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(onPressed: _addLecture, child: const Text('Tambah')),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _addLecture() async {
    final title = _titleController.text.trim();
    final speaker = _speakerController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || speaker.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan pembicara harus diisi')),
      );
      return;
    }

    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final authProvider = context.read<AuthProvider>();
    await context.read<MasjidProvider>().addLecture(
      title,
      speaker,
      dateTime,
      description.isEmpty ? null : description,
      authProvider.token!,
    );

    _titleController.clear();
    _speakerController.clear();
    _descriptionController.clear();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kajian berhasil ditambahkan')),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _speakerController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
