import '../entities/map_point.dart';
import '../entities/map_bounds.dart';

/// Абстракция для работы с картами
/// Позволяет легко менять провайдеров (OSM, Google Maps, Apple Maps)
abstract class IMapService {
  /// Получение URL тайла карты
  String getTileUrl(int x, int y, int z);

  /// Получение центра карты для списка точек
  MapPoint getCenterForPoints(List<MapPoint> points);

  /// Получение оптимального уровня масштабирования
  int getOptimalZoom(MapBounds bounds, double mapWidth, double mapHeight);

  /// Конвертация координат в пиксели тайла
  MapPoint coordinatesToTile(MapPoint coordinates, int zoom);

  /// Конвертация пикселей тайла в координаты
  MapPoint tileToCoordinates(MapPoint tile, int zoom);

  /// Построение URL для статической карты (если поддерживается)
  String? getStaticMapUrl(MapBounds bounds, int width, int height);

  /// Получение информации о провайдере
  String get providerName;
  String get attribution;
  int get maxZoom;
  int get minZoom;
}
