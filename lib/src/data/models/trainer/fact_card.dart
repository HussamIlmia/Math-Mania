class FactCard {
  final String factId;
  final int intervalDays;
  final double easeFactor;
  final int dueAt;
  final int reps;
  final int lapses;
  final int lastLatencyMs;

  FactCard({
    required this.factId,
    required this.intervalDays,
    required this.easeFactor,
    required this.dueAt,
    required this.reps,
    required this.lapses,
    required this.lastLatencyMs,
  });

  factory FactCard.fromMap(Map<String, dynamic> map) {
    return FactCard(
      factId: map['factId'] as String,
      intervalDays: map['intervalDays'] as int,
      easeFactor: (map['easeFactor'] as num).toDouble(),
      dueAt: map['dueAt'] as int,
      reps: map['reps'] as int,
      lapses: map['lapses'] as int,
      lastLatencyMs: map['lastLatencyMs'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'factId': factId,
      'intervalDays': intervalDays,
      'easeFactor': easeFactor,
      'dueAt': dueAt,
      'reps': reps,
      'lapses': lapses,
      'lastLatencyMs': lastLatencyMs,
    };
  }

  FactCard copyWith({
    String? factId,
    int? intervalDays,
    double? easeFactor,
    int? dueAt,
    int? reps,
    int? lapses,
    int? lastLatencyMs,
  }) {
    return FactCard(
      factId: factId ?? this.factId,
      intervalDays: intervalDays ?? this.intervalDays,
      easeFactor: easeFactor ?? this.easeFactor,
      dueAt: dueAt ?? this.dueAt,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      lastLatencyMs: lastLatencyMs ?? this.lastLatencyMs,
    );
  }
}
