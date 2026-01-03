import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/masjid_provider.dart';
import '../models/cashflow.dart';
import '../widgets/custom_drawer.dart';

class CashflowScreen extends StatefulWidget {
  const CashflowScreen({super.key});

  @override
  State<CashflowScreen> createState() => _CashflowScreenState();
}

class _CashflowScreenState extends State<CashflowScreen> {
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
    final cashflows = masjidProvider.cashflows;

    final totalIncome = cashflows
        .where((c) => c.type == 'income')
        .fold(0, (sum, c) => sum + c.amount);

    final totalExpense = cashflows
        .where((c) => c.type == 'expense')
        .fold(0, (sum, c) => sum + c.amount);

    final balance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Keuangan'),
        backgroundColor: Colors.green[800],
      ),
      drawer: const CustomDrawer(),
      body: masjidProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Pemasukan',
                          totalIncome,
                          Colors.green,
                          Icons.arrow_upward,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          'Pengeluaran',
                          totalExpense,
                          Colors.red,
                          Icons.arrow_downward,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryCard(
                    'Saldo',
                    balance,
                    balance >= 0 ? Colors.blue : Colors.red,
                    Icons.account_balance,
                  ),
                  const SizedBox(height: 24),

                  // Transactions List
                  const Text(
                    'Riwayat Transaksi',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cashflows.length,
                    itemBuilder: (context, index) {
                      final cashflow = cashflows[index];
                      return _buildCashflowCard(cashflow);
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    int amount,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp ',
                decimalDigits: 0,
              ).format(amount),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
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
          '${isIncome ? '+' : '-'}${NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp ',
                decimalDigits: 0,
              ).format(cashflow.amount)}',
          style: TextStyle(
            color: isIncome ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
