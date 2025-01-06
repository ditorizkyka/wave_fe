import 'package:wave_fe/model/Quiz.dart';

class Modules {
  int materiID;
  String title;
  String description;
  String content;
  Quiz? quiz;

  Modules({
    this.quiz,
    required this.materiID,
    required this.title,
    required this.description,
    required this.content,
  });

  // FACTORY
  factory Modules.fromJson(Map<String, dynamic> json) {
    return Modules(
      materiID: json['moduleId'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
      quiz: json['quiz'],
    );
  }

  void setMateriID(int id) {
    materiID = id;
  }

  void setTitle(String title) {
    this.title = title;
  }

  void setContent(String content) {
    this.content = content;
  }

  String getContent() => content;

  String getTitle() => title;

  int getMateriID() => materiID;

  @override
  int calculateScore() {
    // Contoh implementasi score (bisa diganti dengan logika lain)
    return content.length * 10; // Skor berdasarkan panjang konten
  }
}
