import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/masjid_provider.dart';
import '../../models/cashflow.dart';

class AdminCashflowScreen extends StatefulWidget {
  const AdminCashflowScreen({super.key});

  @override
  State<AdminCashflowScreen> createState() => _AdminCashflowScreenState();
}

class _AdminCashflowScreenState extends State<AdminCashflowScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedType = 'income';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MasjidProvider>().loadCashflows();
    });
  }

  @override
  Widget build(BuildContext context) {
    final masjidProvider = context.watch<MasjidProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Keuangan'),
        backgroundColor: Colors.green[800],
      ),
      body: masjidProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: masjidProvider.cashflows.length,
                    itemBuilder: (context, index) {
                      final cashflow = masjidProvider.cashflows[index];
                      return _buildCashflowCard(cashflow);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: _showAddCashflowDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Tambah Transaksi Baru'),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCashflowCard(Cashflow cashflow) {
    final isIncome = cashflow.type == 'income';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome ? Colors.green : Colors.red,
          child: Icon(
            isIncome ? Icons.arrow_upward : Icons.arrow_downward,
            color: Colors.white,
          ),
        ),
        title: Text(cashflow.title),
        subtitle: Text(
          '${cashflow.date.day}/${cashflow.date.month}/${cashflow.date.year}',
        ),
        trailing: Text(
          '${isIncome ? '+' : '-'}Rp ${cashflow.amount}',
          style: TextStyle(
            color: isIncome ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showAddCashflowDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Transaksi Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Transaksi'),
              ),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: const InputDecoration(labelText: 'Tipe'),
                items: const [
                  DropdownMenuItem(value: 'income', child: Text('Pemasukan')),
                  DropdownMenuItem(
                    value: 'expense',
                    child: Text('Pengeluaran'),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _selectedType = value!);
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _selectDate,
                child: Text(
                  'Tanggal: ${_selectedDate.toString().split(' ')[0]}',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(onPressed: _addCashflow, child: const Text('Tambah')),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _addCashflow() async {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();

    if (title.isEmpty || amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan jumlah harus diisi')),
      );
      return;
    }

    final amount = int.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah harus berupa angka positif')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    await context.read<MasjidProvider>().addCashflow(
      title,
      amount,
      _selectedType,
      _selectedDate,
      authProvider.token!,
    );

    _titleController.clear();
    _amountController.clear();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaksi berhasil ditambahkan')),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
