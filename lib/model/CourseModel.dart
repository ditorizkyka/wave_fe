// Interface Scoreable

// Class Modules
import 'package:wave_education/model/Quiz.dart';
import 'package:wave_education/model/Scoreable.dart';

class Modules implements Scoreable {
  int materiID;
  String title;
  String description;
  String content;
  // DateTime createdAt;
  Quiz? quiz;

  Modules({
    this.quiz,
    required this.materiID,
    required this.title,
    required this.description,
    required this.content,
    // required this.createdAt,
  });

  // FACTORY
  factory Modules.fromJson(Map<String, dynamic> json) {
    return Modules(
      materiID: json['moduleId'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
      quiz: json['quiz'],
      // createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Methods
  void showMateri() {
    print("Materi: $title\nDescription: $description\nContent: $content");
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

  // void setCreatedAt(DateTime date) {
  //   createdAt = date;
  // }

  // DateTime getCreatedAt() => createdAt;

  String getContent() => content;

  String getTitle() => title;

  int getMateriID() => materiID;

  @override
  int calculateScore() {
    // Contoh implementasi score (bisa diganti dengan logika lain)
    return content.length * 10; // Skor berdasarkan panjang konten
  }
}
