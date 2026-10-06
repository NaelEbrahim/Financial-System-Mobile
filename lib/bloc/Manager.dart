import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/main.dart';
import 'package:novabank/models/AccountInfoModel.dart';
import 'package:novabank/models/DailyTotalsModel.dart';
import 'package:novabank/models/LoginModel.dart';
import 'package:novabank/models/NotificationModel.dart';
import 'package:novabank/models/ProfileModel.dart';
import 'package:novabank/models/TransactionModel.dart';
import 'package:novabank/modules/Auth/Login.dart';
import 'package:novabank/remote/DioHelper.dart';
import 'package:novabank/remote/Routes.dart';
import 'package:novabank/shared/SecureStorage.dart';

import 'States.dart';

class Manager extends Cubit<BlocState> {
  Manager() : super(InitialState());

  static Manager get(BuildContext context) => BlocProvider.of(context);

  void reset() {
    isProfileLoaded = false;
    isAccountInfoLoaded = false;
  }

  void login(Map<String, dynamic> data) {
    emit(Login_LoadingState());
    DioHelper.postData(url: LOGIN, data: data)
        .then((value) async {
          LoginModel loginModel = LoginModel.fromJson(value.data);
          await TokenStorage.writeAccessToken(loginModel.access_token);
          await TokenStorage.writeRefreshToken(loginModel.refresh_token);
          emit(Login_SuccessState());
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Login_ErrorState(errorMessage));
        });
  }

  String handleDioError(dynamic error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return 'Request timeout, try again';
      }
      final response = error.response;
      if (response != null) {
        final data = response.data;
        if (data is Map && data['message'] != null) {
          return data['message'].toString();
        }
        if (data is Map) {
          return data.values.join('\n');
        }
        return 'Error code (${response.statusCode})';
      }
      if (error.type == DioExceptionType.connectionError) {
        return 'No internet connection or server unreachable';
      }
    }
    return 'Unexpected error, try again later';
  }

  void register(Map<String, dynamic> data) {
    emit(Register_LoadingState());
    DioHelper.postData(url: REGISTER, data: data)
        .then((value) async {
          emit(Register_SuccessState());
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Register_ErrorState(errorMessage));
        });
  }

  void registerVerifyOTP(Map<String, dynamic> data) {
    emit(Register_Verify_OTP_LoadingState());
    DioHelper.postData(url: REGISTER_VERIFY_OTP, data: data)
        .then((value) async {
          emit(Register_Verify_OTP_SuccessState());
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Register_Verify_OTP_ErrorState(errorMessage));
        });
  }

  void reSendRegisterVerifyOTP(Map<String, dynamic> data) {
    emit(Resend_Register_Verify_OTP_LoadingState());
    DioHelper.postData(url: RESEND_REGISTER_VERIFY_OTP, data: data)
        .then((value) async {
          emit(Resend_Register_Verify_OTP_SuccessState());
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Resend_Register_Verify_OTP_ErrorState(errorMessage));
        });
  }

  void forgotPassword(Map<String, dynamic> data) {
    emit(Forgot_Password_LoadingState());
    DioHelper.postData(url: FORGOT_PASSWORD, data: data)
        .then((value) async {
          emit(Forgot_Password_SuccessState());
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Forgot_Password_ErrorState(errorMessage));
        });
  }

  void resetForgotPassword(Map<String, dynamic> data) {
    emit(Reset_Forgot_Password_LoadingState());
    DioHelper.putData(url: RESET_FORGOT_PASSWORD, data: data)
        .then((value) async {
          emit(Reset_Forgot_Password_SuccessState());
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Reset_Forgot_Password_ErrorState(errorMessage));
        });
  }

  late ProfileModel profileModel;
  bool isProfileLoaded = false;

  Future<void> getProfile() async {
    if (isProfileLoaded) return;
    emit(Get_Profile_LoadingState());
    return DioHelper.getData(url: GET_USER_PROFILE)
        .then((value) {
          profileModel = ProfileModel.fromJson(value.data);
          isProfileLoaded = true;
          emit(Get_Profile_SuccessState());
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Get_Profile_ErrorState(errorMessage));
        });
  }

  Future<bool> refreshToken(String refreshToken) async {
    try {
      final value = await DioHelper.postData(
        url: REFRESH_TOKEN,
        data: {'refreshtoken': refreshToken},
      );
      final loginModel = LoginModel.fromJson(value.data);

      await TokenStorage.writeAccessToken(loginModel.access_token);
      await TokenStorage.writeRefreshToken(loginModel.refresh_token);
      return true;
    } catch (error) {
      await TokenStorage.deleteAccessToken();
      await TokenStorage.deleteRefreshToken();
      performLogout();
      return false;
    }
  }

  void logout() {
    emit(Logout_LoadingState());
    DioHelper.postData(url: LOGOUT)
        .then((value) {
          emit(Logout_SuccessState());
          performLogout();
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Logout_ErrorState(errorMessage));
        });
  }

  void performLogout() async {
    await TokenStorage.deleteAccessToken();
    await TokenStorage.deleteRefreshToken();
    Future.delayed(Duration(milliseconds: 50), () {
      final navigator = MyApp.navigatorKey.currentState;
      if (navigator != null) {
        reset();
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => Login()),
          (route) => false,
        );
      }
    });
  }

  late AccountInfoModel accountInfoModel;
  bool isAccountInfoLoaded = false;

  Future<void> getAccountInfo() async {
    if (isAccountInfoLoaded) return;
    emit(Get_Account_Info_LoadingState());
    return await DioHelper.getData(url: GET_ACCOUNT_INFO)
        .then((value) {
          accountInfoModel = AccountInfoModel.fromJson(value.data);
          isAccountInfoLoaded = true;
          emit(Get_Account_Info_SuccessState());
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Get_Account_Info_ErrorState(errorMessage));
        });
  }

  void updateProfile(Map<String, dynamic> data) {
    emit(Update_Profile_LoadingState());
    DioHelper.putData(url: UPDATE_USER_PROFILE, data: data)
        .then((value) {
          emit(Update_Profile_SuccessState());
          isProfileLoaded = false;
          getProfile();
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Update_Profile_ErrorState(errorMessage));
        });
  }

  void updatePassword(Map<String, dynamic> data) {
    emit(Update_Password_LoadingState());
    DioHelper.putData(url: UPDATE_USER_PASSWORD, data: data)
        .then((value) {
          emit(Update_Password_SuccessState());
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Update_Password_ErrorState(errorMessage));
        });
  }

  void requestUpdateEmail(Map<String, dynamic> data) {
    emit(Request_Update_Email_LoadingState());
    DioHelper.postData(url: REQUEST_UPDATE_EMAIL, data: data)
        .then((value) {
          emit(Request_Update_Email_SuccessState());
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Request_Update_Email_ErrorState(errorMessage));
        });
  }

  void updateEmail(Map<String, dynamic> data) {
    emit(Update_Email_LoadingState());
    DioHelper.putData(url: UPDATE_USER_EMAIL, data: data)
        .then((value) {
          emit(Update_Email_SuccessState());
          isProfileLoaded = false;
          getProfile();
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Update_Email_ErrorState(errorMessage));
        });
  }

  void reSendRequestUpdateEmail(Map<String, dynamic> data) {
    emit(Resend_Request_Update_Email_LoadingState());
    DioHelper.postData(url: REQUEST_UPDATE_EMAIL, data: data)
        .then((value) {
          emit(Resend_Request_Update_Email_SuccessState());
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Resend_Request_Update_Email_ErrorState(errorMessage));
        });
  }

  void transferMoney(Map<String, dynamic> data) {
    emit(Transfer_Money_LoadingState());
    DioHelper.postData(url: TRANSFER_MONEY, data: data)
        .then((value) {
          emit(Transfer_Money_SuccessState());
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Transfer_Money_ErrorState(errorMessage));
        });
  }

  List<NotificationModel> notifications = [];

  Future<void> getNotifications(int page) async {
    emit(Get_Notifications_LoadingState());
    return await DioHelper.getData(
          url: GET_NOTIFICATIONS,
          params: {'page': page, 'size': 10},
        )
        .then((value) {
          final newNotifications = NotificationModel.parseList(value.data);
          if (page == 0) {
            notifications = newNotifications;
          } else {
            notifications.addAll(newNotifications);
          }
          emit(Get_Notifications_SuccessState());
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Get_Notifications_ErrorState(errorMessage));
        });
  }

  List<TransactionModel> transactions = [];

  Future<void> getTransactions(int page) async {
    emit(Get_Transactions_LoadingState());
    return await DioHelper.getData(
          url: GET_TRANSACTIONS,
          params: {'page': page, 'size': 10},
        )
        .then((value) {
          final newTransactions = TransactionModel.parseList(value.data);
          if (page == 0) {
            transactions = newTransactions;
          } else {
            transactions.addAll(newTransactions);
          }
          emit(Get_Transactions_SuccessState());
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Get_Transactions_ErrorState(errorMessage));
        });
  }

  void deleteNotification(int id) {
    emit(Delete_Notification_LoadingState());
    DioHelper.deleteData(url: DELETE_NOTIFICATION + id.toString())
        .then((value) {
          notifications.removeWhere((item) => item.id == id);
          emit(Delete_Notification_SuccessState());
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Delete_Notification_ErrorState(errorMessage));
        });
  }

  void markNotificationRead(int id) {
    emit(Mark_Notification_Read_LoadingState());
    DioHelper.putData(url: MARK_NOTIFICATION_READ + id.toString())
        .then((value) {
          final index = notifications.indexWhere((item) => item.id == id);
          if (index != -1) {
            notifications[index].isRead = true;
          }
          emit(Mark_Notification_Read_SuccessState());
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Mark_Notification_Read_ErrorState(errorMessage));
        });
  }

  DailyTotalsModel? dailyTotals;

  Future<void> getTodayTotals() async {
    emit(Get_Today_Totals_LoadingState());
    await DioHelper.getData(url: GET_DAILY_TOTALS)
        .then((value) {
          dailyTotals = DailyTotalsModel.fromJson(value.data);
          emit(Get_Today_Totals_SuccessState());
        })
        .catchError((error) {
          String errorMessage = handleDioError(error);
          emit(Get_Today_Totals_ErrorState(errorMessage));
        });
  }

  //ZSDPCXCT - HESKLQ3G
}
