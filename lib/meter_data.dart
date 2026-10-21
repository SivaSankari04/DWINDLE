class MeterData {
  final DateTime timestamp;
  final double pt;
  final double bill;
  final double carbonEmission;

  MeterData({
    required this.timestamp,
    required this.pt,
    required this.bill,
  }) : carbonEmission = (pt / 1000.0) * 0.85;
}
