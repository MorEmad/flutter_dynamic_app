// lib/models/content.dart

class Content {
  final int id;
  final String title;
  final Map<String, dynamic> body; // Changed from String to Map

  Content({required this.id, required this.title, required this.body});

  // Deserialize JSON to Content object
  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'],
      title: json['title'],
      body: json['body'], // Ensure this is a Map
    );
  }

  // Serialize Content object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }
}
