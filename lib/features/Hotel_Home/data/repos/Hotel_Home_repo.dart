import '../models/hotel_models.dart';

abstract class HotelHomeRepo {
  Future<HotelData> getHotelData();
}
