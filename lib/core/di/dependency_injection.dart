import 'package:dio/dio.dart';
import 'package:flutter_complete_project/core/networking/api_service.dart';
import 'package:flutter_complete_project/core/networking/dio_factory.dart';
import 'package:flutter_complete_project/features/home/data/apis/home_api_service.dart';
import 'package:flutter_complete_project/features/venues/data/venue_api.dart';
import 'package:flutter_complete_project/features/venues/data/venue_repository.dart';
import 'package:get_it/get_it.dart';
import '../../features/home/data/repos/home_repo.dart';
import '../../features/home/logic/home_cubit.dart';
import '../../features/login/data/repos/login_repo.dart';
import '../../features/login/logic/cubit/login_cubit.dart';
import '../../features/sign_up/data/repos/sign_up_repo.dart';
import '../../features/sign_up/logic/sign_up_cubit.dart';
import '../../features/venues/logic/venues_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Dio & ApiService - using DioFactory to ensure correct baseUrl and interceptors
  Dio dio = DioFactory.getDio();
  print('🔧 Dio registered with baseUrl: ${dio.options.baseUrl}'); // للتأكد
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  // login
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));

  // signup
  getIt.registerLazySingleton<SignupRepo>(() => SignupRepo(getIt()));
  getIt.registerFactory<SignupCubit>(() => SignupCubit(getIt()));

  // home
  getIt.registerLazySingleton<HomeApiService>(() => HomeApiService(dio));
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(getIt()));
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt()));

  // venues
  getIt.registerLazySingleton<VenueApi>(() => VenueApi(dio));
  getIt.registerLazySingleton<VenueRepository>(() => VenueRepository(getIt()));
  getIt.registerFactory<VenuesCubit>(() => VenuesCubit(getIt()));

  // Payment
  getIt.registerLazySingleton<Dio>(() => DioFactory.getDio());
}