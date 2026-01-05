import 'api_service.dart';
import '../models/lecture.dart';

class LectureService {
  static Future<List<Lecture>> getLectures() async {
    final data = await ApiService.get('/api/lectures');
    return data.map((json) => Lecture.fromJson(json)).toList();
  }

  static Future<Lecture> createLecture(
    String title,
    String speaker,
    DateTime date,
    String? description,
    String token,
  ) async {
    final response = await ApiService.post('/api/lectures', {
      'title': title,
      'speaker': speaker,
      'date': date.toIso8601String(),
      'description': description,
    }, token: token);

    return Lecture.fromJson(response);
  }
}
