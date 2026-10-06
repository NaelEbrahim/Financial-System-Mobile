abstract class BlocState {}

class InitialState extends BlocState {}

class ErrorState extends BlocState {
  final String error;

  ErrorState(this.error);
}

//-------------- LOGIN --------------//
class Login_LoadingState extends BlocState {}

class Login_SuccessState extends BlocState {}

class Login_ErrorState extends ErrorState {
  Login_ErrorState(super.error);
}

//-------------- REGISTER --------------//
class Register_LoadingState extends BlocState {}

class Register_SuccessState extends BlocState {}

class Register_ErrorState extends ErrorState {
  Register_ErrorState(super.error);
}

//-------------- REGISTER-VERIFY-OTP --------------//
class Register_Verify_OTP_LoadingState extends BlocState {}

class Register_Verify_OTP_SuccessState extends BlocState {}

class Register_Verify_OTP_ErrorState extends ErrorState {
  Register_Verify_OTP_ErrorState(super.error);
}

//-------------- RESEND-REGISTER-VERIFY-OTP --------------//
class Resend_Register_Verify_OTP_LoadingState extends BlocState {}

class Resend_Register_Verify_OTP_SuccessState extends BlocState {}

class Resend_Register_Verify_OTP_ErrorState extends ErrorState {
  Resend_Register_Verify_OTP_ErrorState(super.error);
}

//-------------- FORGOT-PASSWORD --------------//
class Forgot_Password_LoadingState extends BlocState {}

class Forgot_Password_SuccessState extends BlocState {}

class Forgot_Password_ErrorState extends ErrorState {
  Forgot_Password_ErrorState(super.error);
}

//-------------- RESET-FORGOT-PASSWORD --------------//
class Reset_Forgot_Password_LoadingState extends BlocState {}

class Reset_Forgot_Password_SuccessState extends BlocState {}

class Reset_Forgot_Password_ErrorState extends ErrorState {
  Reset_Forgot_Password_ErrorState(super.error);
}

//-------------- GET-USER-PROFILE --------------//
class Get_Profile_LoadingState extends BlocState {}

class Get_Profile_SuccessState extends BlocState {}

class Get_Profile_ErrorState extends ErrorState {
  Get_Profile_ErrorState(super.error);
}

//-------------- UPDATE-USER-PROFILE --------------//
class Update_Profile_LoadingState extends BlocState {}

class Update_Profile_SuccessState extends BlocState {}

class Update_Profile_ErrorState extends ErrorState {
  Update_Profile_ErrorState(super.error);
}

//-------------- GET-ACCOUNT-INFO --------------//
class Get_Account_Info_LoadingState extends BlocState {}

class Get_Account_Info_SuccessState extends BlocState {}

class Get_Account_Info_ErrorState extends ErrorState {
  Get_Account_Info_ErrorState(super.error);
}

//-------------- UPDATE-USER-PASSWORD --------------//
class Update_Password_LoadingState extends BlocState {}

class Update_Password_SuccessState extends BlocState {}

class Update_Password_ErrorState extends ErrorState {
  Update_Password_ErrorState(super.error);
}

//-------------- REQUEST-UPDATE-USER-EMAIL --------------//
class Request_Update_Email_LoadingState extends BlocState {}

class Request_Update_Email_SuccessState extends BlocState {}

class Request_Update_Email_ErrorState extends ErrorState {
  Request_Update_Email_ErrorState(super.error);
}

//-------------- RESEND-REQUEST-UPDATE-USER-EMAIL --------------//
class Resend_Request_Update_Email_LoadingState extends BlocState {}

class Resend_Request_Update_Email_SuccessState extends BlocState {}

class Resend_Request_Update_Email_ErrorState extends ErrorState {
  Resend_Request_Update_Email_ErrorState(super.error);
}

//-------------- UPDATE-USER-EMAIL --------------//
class Update_Email_LoadingState extends BlocState {}

class Update_Email_SuccessState extends BlocState {}

class Update_Email_ErrorState extends ErrorState {
  Update_Email_ErrorState(super.error);
}

//-------------- LOGOUT --------------//
class Logout_LoadingState extends BlocState {}

class Logout_SuccessState extends BlocState {}

class Logout_ErrorState extends ErrorState {
  Logout_ErrorState(super.error);
}

//-------------- TRANSFER-MONEY --------------//
class Transfer_Money_LoadingState extends BlocState {}

class Transfer_Money_SuccessState extends BlocState {}

class Transfer_Money_ErrorState extends ErrorState {
  Transfer_Money_ErrorState(super.error);
}

//-------------- GET-NOTIFICATIONS --------------//
class Get_Notifications_LoadingState extends BlocState {}

class Get_Notifications_SuccessState extends BlocState {}

class Get_Notifications_ErrorState extends ErrorState {
  Get_Notifications_ErrorState(super.error);
}

//-------------- GET-TRANSACTIONS --------------//
class Get_Transactions_LoadingState extends BlocState {}

class Get_Transactions_SuccessState extends BlocState {}

class Get_Transactions_ErrorState extends ErrorState {
  Get_Transactions_ErrorState(super.error);
}

//-------------- DELETE-NOTIFICATION --------------//
class Delete_Notification_LoadingState extends BlocState {}

class Delete_Notification_SuccessState extends BlocState {}

class Delete_Notification_ErrorState extends ErrorState {
  Delete_Notification_ErrorState(super.error);
}

//-------------- MARK-NOTIFICATION-READ --------------//
class Mark_Notification_Read_LoadingState extends BlocState {}

class Mark_Notification_Read_SuccessState extends BlocState {}

class Mark_Notification_Read_ErrorState extends ErrorState {
  Mark_Notification_Read_ErrorState(super.error);
}

//-------------- GET-TODAY-TOTALS --------------//
class Get_Today_Totals_LoadingState extends BlocState {}

class Get_Today_Totals_SuccessState extends BlocState {}

class Get_Today_Totals_ErrorState extends ErrorState {
  Get_Today_Totals_ErrorState(super.error);
}