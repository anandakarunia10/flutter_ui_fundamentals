class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    final int itemCodeId = json['id'] as int? ?? 1;
    return Course(
      id: json['id'] as int?,
      code: json['code'] as String? ?? 'MOB0$itemCodeId',
      title: json['title'] as String? ?? 'Course $itemCodeId',
      credits: (json['credits'] as num?)?.toInt() ?? ((itemCodeId % 3) + 2),
      status: (json['status'] as String?) ?? (itemCodeId % 2 == 0 ? 'active' : 'planned'),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'code': code,
        'title': title,
        'credits': credits,
        'status': status,
      };
}