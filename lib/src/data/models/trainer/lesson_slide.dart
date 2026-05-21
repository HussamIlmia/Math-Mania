class LessonSlide {
  final int order;
  final String title;
  final String body;

  LessonSlide({
    required this.order,
    required this.title,
    required this.body,
  });

  factory LessonSlide.fromMap(Map<String, dynamic> map) {
    return LessonSlide(
      order: map['order'] as int,
      title: map['title'] as String,
      body: map['body'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'order': order,
      'title': title,
      'body': body,
    };
  }
}
