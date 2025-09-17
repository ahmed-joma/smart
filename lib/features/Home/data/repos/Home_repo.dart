import '../models/home_models.dart';

abstract class HomeRepo {
  Future<HomeData> getHomeData();
}
