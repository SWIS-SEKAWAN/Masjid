import 'api_service.dart';
import '../models/cashflow.dart';

class CashflowService {
  static Future<List<Cashflow>> getCashflows() async {
    final data = await ApiService.get('/api/cashflows');
    return data.map((json) => Cashflow.fromJson(json)).toList();
  }

  static Future<Cashflow> createCashflow(
    String title,
    int amount,
    String type,
    DateTime date,
    String token,
  ) async {
    final response = await ApiService.post('/api/cashflows', {
      'title': title,
      'amount': amount,
      'type': type,
      'date': date.toIso8601String(),
    }, token: token);

    return Cashflow.fromJson(response);
  }
}
