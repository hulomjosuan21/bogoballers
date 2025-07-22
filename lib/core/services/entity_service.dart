// import 'package:bogoballers/core/app_routes.dart';
// import 'package:bogoballers/core/dio_client.dart';
// import 'package:bogoballers/core/enums/user_enum.dart';
// import 'package:bogoballers/core/helpers/api_reponse.dart';
// import 'package:bogoballers/core/models/user_model.dart';
// import 'package:flutter/material.dart';
// import 'dart:io' show Platform;
// import 'package:flutter/foundation.dart' show kIsWeb;

// class EntityServices<T> {
//   Future<ApiResponse> login({
//     required BuildContext context,
//     required UserModel user,
//     bool stayLoggedIn = true,
//   }) async {
//     final api = DioClient().client;

//     try {
//       final response = await api.post(
//         '/entity/login',
//         data: user.toFormDataForLogin(),
//         queryParameters: {'stay_login': stayLoggedIn},
//       );
//       final apiResponse = ApiResponse.fromJsonNoPayload(response.data);

//       final redirect = apiResponse.redirect;
//       if (!appRoutes.containsKey(redirect)) {
//         throw Exception("Unknown redirect route: $redirect");
//       }

//       final payload = apiResponse.payload;
//       AccountTypeEnum? accountType = AccountTypeEnum.fromValue(
//         payload['account_type'],
//       );

//       String? userId = payload['user_id'];
//       if (userId == null) {
//         throw Exception("User ID is missing in the response payload.");
//       }
//       if (accountType == AccountTypeEnum.LOCAL_ADMINISTRATOR ||
//           accountType == AccountTypeEnum.LGU_ADMINISTRATOR) {
//         if (kIsWeb || Platform.isIOS || Platform.isAndroid) {
//           throw Exception(
//             "Administrator accounts are not supported on this platform.",
//           );
//         }
//       } else if (accountType == AccountTypeEnum.PLAYER ||
//           accountType == AccountTypeEnum.TEAM_CREATOR) {
//         if (Platform.isWindows || Platform.isMacOS) {
//           throw Exception(
//             "Player and Team Creator accounts are not supported on desktop platforms.",
//           );
//         }
//       }

//       AccessToken? accessToken;

//       switch (accountType) {
//         case AccountTypeEnum.PLAYER:
//           final loginResponse = LoginResponse<PlayerModel>.fromJson(
//             payload,
//             (json) => PlayerModel.fromJson(json),
//           );

//           if (loginResponse.access_token != null) {
//             accessToken = AccessToken(
//               access_token: loginResponse.access_token!,
//             );
//           }
//           getIt<EntityState<PlayerModel>>().setEntity(loginResponse.entity);
//           break;

//         case AccountTypeEnum.TEAM_CREATOR:
//           final loginResponse = LoginResponse<UserModel>.fromJson(
//             payload,
//             (json) => UserModel.fromJson(json),
//           );

//           if (loginResponse.access_token != null) {
//             accessToken = AccessToken(
//               access_token: loginResponse.access_token!,
//             );
//           }

//           getIt<EntityState<UserModel>>().setEntity(loginResponse.entity);
//           break;

//         case AccountTypeEnum.LOCAL_ADMINISTRATOR:
//         case AccountTypeEnum.LGU_ADMINISTRATOR:
//           final loginResponse =
//               LoginResponse<LeagueAdministratorModel>.fromJson(
//                 payload,
//                 (json) => LeagueAdministratorModel.fromJson(json),
//               );

//           if (loginResponse.access_token != null) {
//             accessToken = AccessToken(
//               access_token: loginResponse.access_token!,
//             );
//           }

//           getIt<EntityState<LeagueAdministratorModel>>().setEntity(
//             loginResponse.entity,
//           );
//           break;

//         default:
//           throw Exception("Unknown account type: $accountType");
//       }

//       if (accessToken != null) {
//         AppBox.accessTokenBox.put('access_token', accessToken);
//         debugPrint("Token Stored");
//       } else {
//         debugPrint(
//           "Access token not saved (user may not be staying logged in)",
//         );
//       }

//       getIt<AppState>().setUserId = userId;

//       return apiResponse;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> fetch(BuildContext context, String user_id) async {
//     final api = DioClient().client;
//     try {
//       final response = await api.get('/entity/fetch/${user_id}');
//       final apiResponse = ApiResponse.fromJsonNoPayload(response.data);

//       final payload = apiResponse.payload;
//       AccountTypeEnum? accountType = AccountTypeEnum.fromValue(
//         payload['account_type'],
//       );

//       if (accountType == AccountTypeEnum.LOCAL_ADMINISTRATOR ||
//           accountType == AccountTypeEnum.LGU_ADMINISTRATOR) {
//         if (kIsWeb || Platform.isIOS || Platform.isAndroid) {
//           throw Exception(
//             "Administrator accounts are not supported on this platform.",
//           );
//         }
//       } else if (accountType == AccountTypeEnum.PLAYER ||
//           accountType == AccountTypeEnum.TEAM_CREATOR) {
//         if (Platform.isWindows || Platform.isMacOS) {
//           throw Exception(
//             "Player and Team Creator accounts are not supported on desktop platforms.",
//           );
//         }
//       }

//       switch (accountType) {
//         case AccountTypeEnum.PLAYER:
//           final player = PlayerModel.fromJson(payload['entity']);
//           getIt<EntityState<PlayerModel>>().setEntity(player);
//           break;

//         case AccountTypeEnum.TEAM_CREATOR:
//           final user = UserModel.fromJson(payload['entity']);
//           getIt<EntityState<UserModel>>().setEntity(user);
//           break;

//         case AccountTypeEnum.LOCAL_ADMINISTRATOR:
//         case AccountTypeEnum.LGU_ADMINISTRATOR:
//           final administrator = LeagueAdministratorModel.fromJson(
//             payload['entity'],
//           );
//           getIt<EntityState<LeagueAdministratorModel>>().setEntity(
//             administrator,
//           );

//         default:
//           throw Exception("Unknown account type: $accountType");
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
