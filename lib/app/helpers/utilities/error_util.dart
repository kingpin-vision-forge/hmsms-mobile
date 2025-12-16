import 'package:student_management/app/helpers/global.dart';

class ErrorUtil {
  void handleAppError(
      {String apiName = '',
      required Object error,
      required String displayMessage}) {
    // If apiName is empty, show toast with error message
    if (apiName.isEmpty) {
      botToastError(displayMessage);
      return;
    }
    // TODO: For future use while implementing flavors
    // final isDev = FlavorConfig.instance.flavor == Flavor.dev;
    // final message = isDev ? error.toString() : displayMessage;
    final message = displayMessage;
    /* 
    if apiName is empty or not dev, 
    show toast with message else show toast with apiName and message
    */
    // TODO: For future use while implementing flavors
    // botToastError(
    //     apiName.isEmpty || !isDev ? displayMessage : '$apiName: $message');
    botToastError(displayMessage);
  }
}