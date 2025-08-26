/// Торговая точка - минимальная сущность из учетной системы
class TradingPoint {
  final int? id;            // autoincrement primary key
  final String externalId;  // ID во внешней учетной системе
  final String name;
  final String? inn;        // ИНН контрагента
  final DateTime createdAt;
  final DateTime? updatedAt;

  TradingPoint({
    this.id,
    required this.externalId,
    required this.name,
    this.inn,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Создает копию с измененными параметрами
  TradingPoint copyWith({
    int? id,
    String? externalId,
    String? name,
    String? inn,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TradingPoint(
      id: id ?? this.id,
      externalId: externalId ?? this.externalId,
      name: name ?? this.name,
      inn: inn ?? this.inn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'TradingPoint(id: $id, externalId: $externalId, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TradingPoint && other.externalId == externalId;
  }

}
