class Lecture {
  final int id;
  final String title;
  final String speaker;
  final DateTime date;
  final String? description;
  final DateTime createdAt;

  Lecture({
    required this.id,
    required this.title,
    required this.speaker,
    required this.date,
    this.description,
    required this.createdAt,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['id'],
      title: json['title'],
      speaker: json['speaker'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'speaker': speaker,
      'date': date.toIso8601String(),
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}