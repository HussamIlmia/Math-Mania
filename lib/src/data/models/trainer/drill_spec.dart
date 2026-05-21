class DrillSpec {
  final String trickId;
  final int count;
  final int targetLatencyMs;

  DrillSpec({
    required this.trickId,
    required this.count,
    required this.targetLatencyMs,
  });
}
