import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppColors {
  static const Color backgroundColor = Color(0xFFF3F4F6);
  static const Color primaryColor = Color(0xFF0b4b79);
  static const Color secondaryColor = Color(0xFFFFFFFF);
  static const Color selectionColor = Color(0x400055BB); // example white color
  static const Color accentColor = Color(0xFFFF5722);
  static const Color resendColor = Color(0xff5C5C5C);
  static const Color disableColor = Color(0xFF8DACDA);
  static const Color normalTextColor = Color(0xff5C5C5C);
  static const Color mainTextColor = Color(0xff636363);
  static const Color placeholderTextColor = Color(0xff4D4D4D);
  static const Color defaultBorderColor = Color(0xffD4D4D4);
  static const Color errorColor = Color(0xFFD12020);
  static const Color cancelColor = Color(0xFFFF382D);
  static const Color redColorDonut = Color(0xFFc22e20);
  static const Color borderColor = Color(0xFFc9c9c9);
  static const Color inputBorderColor = Color(0xFF0157C8);
  static const Color inputDisbleColor = Color(0xFFF3F3F3);
  static const Color successColor = Color(0xff2FB856);
  static const Color blueColor = Colors.blue;
  static const Color lightGray = Color(0xFFe5e6e8);
  static const Color darkGray = Color(0xff444444);
  static const Color gray100 = Color(0xFF7C7C7C);
  static const Color gray500 = Color(0xFF403E41);
  static const Color gray800 = Color(0xff444444);
  static const Color gray900 = Color(0xff383838);
  static const Color starColor = Color(0xffF0B51C);
  static const Color alarmRed = Color(0xffE43901);
  static const Color callBtn = Color(0xFF0a6e30);
  static const Color green800 = Color(0xFF1ab05e);
  static const Color cardBg = Color(0xFFEFF4F9);
  static const Color green500 = Color(0xFF00B894);
  static const Color green100 = Color(0xFFEe5ffef);
  static const Color chipColor = Color(0xFFe4ecf9);
  static const Color chipBorder = Color(0xFF747474);
  static const Color greenChip = Color(0xFFe2f6f4);
  static const Color blueBorder = Color(0xff125FA8);
  static const Color skyBorder = Color(0xff72AFEB);
  static const Color grayBorder = Color(0x66A2A1A8);
  static const Color btnTextColor = Color(0xff484848);
  static const Color purple100 = Color(0xFFF7F2FF);
  static const Color purple800 = Color(0xFF740DB5);
  static const Color orange800 = Color(0xFFfc7011);
  static const Color orange100 = Color(0xFFffe9db);
  static const Color red800 = Color(0xFFE94646);
  static const Color red900 = Color(0xFF991B1B);
  static const Color newDarkGray = Color(0xFF808080);
  static const Color tableHeader = Color(0xFFF2F2F2);
  static const Color calendarBg = Color(0xFFEDF4FB);
  static const Color calendarEventDate = Color(0xFF1A7CA0);
  static const Color badgeColor = Color(0xFFfedd91);
  static const Color iconColor = Color(0xFF0157C8);
  static const Color iconColorLight = Color(0xFF64748B);
  static const Color cardColor = Color(0xFFEFF4F9);
  static const Color cardBorder = Color(0xFF74A6E0);
  static const Color cardBorderColor = Color(0xFFBEBEBE);
  static const Color red200 = Color(0xFFffd9d7);
  static const Color blue200 = Color(0xFFCBE4FF);
  static const Color chipBg = Color(0xFFECF0FF);
  static const Color navbarColor = Color(0xff0157C8);
  static const Color gray200 = Color(0xFF656268);
  static const Color gray50 = Color(0xFFedf1f4);
  static const Color dashBorder = Color(0xFF0095FF);
  static const Color dashBg = Color(0xFFEAEDF3);
  static const Color paymentCardBg = Color(0xFFF6F8FC);
  static const Color black = Color(0xFF393E46);
  static const Color grayColor = Color(0xFF737373);
  static const Color backgroundListColor = Color(0xFFf0eff5);
  static const Color dashboardColor = Color(0xFFf6fafd);
  static const Color notificationText = Color(0xFF777b7e);
  static const Color notificationTextTitle = Color(0xFF55595c);
  static const Color yellow = Color(0xFFFDCB6E);
}

class Constants {
  static const double radiusSm = 8.0;
  static const double radiusMd = 10.0;
  static const double radiusXmd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 18.0;

  static ThemeData theme = ThemeData(
    fontFamily: "Montserrat",
    // Faster page transitions using Cupertino style for smoother animations
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
      },
    ),
    datePickerTheme: DatePickerThemeData(
      todayForegroundColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.secondaryColor; // Color when selected
        }
        return AppColors.gray800; // Default color for unselected years
      }),
      todayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.black; // Background color when selected
        }
        return Colors.transparent; // Default background for unselected years
      }),
      yearForegroundColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.secondaryColor; // Selected year color
        }
        return AppColors.gray800; // Unselected year color
      }),
      yearBackgroundColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.black; // Background color when year is selected
        }
        return Colors.transparent; // Background for unselected year
      }),
    ),
    dividerColor: Colors.transparent,
    expansionTileTheme: const ExpansionTileThemeData(
      backgroundColor: Colors.transparent,
      collapsedBackgroundColor: Colors.transparent,
      collapsedIconColor: AppColors.normalTextColor,
      iconColor: AppColors.normalTextColor,
      textColor: AppColors.normalTextColor,
      collapsedTextColor: Colors.black,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: AppColors.normalTextColor),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.black,
      selectionColor: AppColors.selectionColor,
      selectionHandleColor: AppColors.black,
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(
        AppColors.secondaryColor.withValues(alpha: 0.5),
      ),
    ),
  );

  static const Map<String, String> STRINGS = {
    'STUDENT': 'Student Management',
    'UNAUTHORIZED': 'Unauthorized',
    'NEW_CLIENT': 'New Client',
    'NEW_INVOICE': 'New Invoice',
    'NEW_JOB': 'New Job',
    'NEW_SERVICE': 'New Service',
    'DEFAULT_COUNTRY_CODE': 'AU',
    'DEFAULT_DIAL_CODE': '+61',
    'RESIDENTIAL': 'Residential',
    'ASC': 'ASC',
    'DESC': 'DESC',
    'CLIENT': 'Client',
    'CLIENTS': 'Clients',
    'BANK_TRANSFER': 'Bank Transfer',
    'JOB': 'Job',
    'JOBS': 'Jobs',
    'QUOTE': 'Quote',
    'INVOICES': 'Invoices',
    'INVOICE': 'Invoice',
    'PAYMENTS': 'Payments',
    'TODAY': 'Today',
    'THIS_WEEK': 'This Week',
    'THIS_MONTH': 'This Month',
    'THIS_YEAR': 'This Year',
    'CUSTOM_DATE': 'Custom Date',
    'CUSTOM': 'Custom',
    'CLEAR': 'Clear',
    'SELECT_END_DATE': 'Select an End Date',
    'SELECT_DATE_RANGE': 'Select Date Range',
    'INVALID_SELECTION': 'Invalid Selection',
    'EMAIL': 'email',
    'SENT_SUCCESSFULLY': 'Sent Successfully!',
    'DONE': 'Done',
    'FIRST_NAME': 'first_name',
    'COMMERCIAL': 'Commercial',
    'PICKUP': 'Pickup',
    'IS_TRUE': 'true',
    'NAME': 'Name',
    'RATING': 'Rating',
    'CLIENT_RATING': 'client_rating',
    'TAX_EXCLUSIVE': 'Tax Exclusive',
    'TAX_INCLUSIVE': 'Tax Inclusive',
    'NO_TAX': 'No Tax',
    'FIFTY_PERCENT': '50%',
    'DEFAULT_THEME': 'Default',
    'DEFAULT_EXPIRY': 'In 30 days',
    'PERCENT_SIGN': '%',
    'UPDATED_SUCCESSFULLY': 'Updated Successfully!',
    'SAVED_SUCCESSFULLY': 'Saved Successfully!',
    'DUE': 'Due',
    'PAID': 'Paid',
    'OVERDUE': 'Overdue',
    'CANCELLED': 'Cancelled',
    'DRAFT': 'Draft',
    'INVOICE_DATE': 'invoice_date',
    'INVOICE_EXPIRY_DATE': 'invoice_expiry_date',
    'PAYMENT_DATE': 'payment_date',
    'AMOUNT': 'total_amount',
    'NO_PREVIOUS_QUOTE': 'No quote',
    'NO_PREVIOUS_INVOICE': 'No invoice',
    'NO_PREVIOUS_SERVICES': 'No services',
    'GL_REVENUE_ACCOUNT': 'GL Revenue Account',
    'RECEIPT': 'Receipt',
    'DATED_TODAY': 'Dated Today',
    'SERVICES': 'Services',
    'CASH': 'Cash',
    'CREDIT_CARD': 'Credit Card',
    'DEBIT_CARD': 'Debit Card',
    'CONTINUE': 'Continue',
    'SESSION_ERROR_TITLE': 'Looks like your session expired.',
    'SESSION_ERROR_DESCRIPTION': "Let's get you signed back in.",
    'ALL': 'All',
    'FAVORITE': 'Favorite',
    'GROUPS': 'Groups',
    'MONTH': 'month',
    'WEEK': 'week',
    'NOT_DONE': 'Not Done',
    'PERSONAL': 'Personal',
    'REPEAT': 'Never',
    'EVERY_DAY': 'Every Day',
    'EVERY_WEEK': 'Every Week',
    'EVERY_FORTNIGHT': 'Every Fortnight',
    'EVERY_MONTH': 'Every Month',
    'EVERY_YEAR': 'Every Year',
    'ONE_DAY_BEFORE': '1 day before',
    'TWO_DAY_BEFORE': '2 days before',
    'THREE_DAY_BEFORE': '3 days before',
    'FOUR_DAY_BEFORE': '4 days before',
    'FIVE_DAY_BEFORE': '5 days before',
    'ONE_HOUR_BEFORE': '1 hour before',
    'TWO_HOUR_BEFORE': '2 hours before',
    'THIRTY_MIN_BEFORE': '30 minutes before',
    'NO_PREVIOUS_JOB': 'No job',
    'EMPLOYEE_NAME': 'Employee Name',
    'NONE': 'None',
  };

  static Map<String, dynamic> ENUMS = {
    'INVOICE_STATUS': [
      STRINGS['PAID'],
      STRINGS['DUE'],
      STRINGS['OVERDUE'],
      STRINGS['DRAFT'],
      STRINGS['CANCELLED'],
    ],
    'PAYMENT_MODES': [
      STRINGS['BANK_TRANSFER'],
      STRINGS['CASH'],
      STRINGS['CREDIT_CARD'],
      STRINGS['DEBIT_CARD'],
    ],
    'PROPERTY_TYPES': [
      STRINGS['RESIDENTIAL'],
      STRINGS['COMMERCIAL'],
      STRINGS['PICKUP'],
    ],
    'TAB_TYPES': [STRINGS['ALL'], STRINGS['FAVORITE'], STRINGS['GROUPS']],
    'DATE_FILTERS': [
      STRINGS['TODAY'],
      STRINGS['THIS_WEEK'],
      STRINGS['THIS_MONTH'],
      STRINGS['THIS_YEAR'],
      STRINGS['CUSTOM_DATE'],
      STRINGS['CLEAR'],
    ],
    'EXTENSIONS': [
      'jpg', 'jpeg', 'png', // All image formats
      'pdf', // PDF files
      'doc', 'docx', 'txt', // Word and text documents
      'csv', 'xlsx', // Spreadsheet files
    ],
    'TAX_TYPES': [
      STRINGS['TAX_EXCLUSIVE'],
      STRINGS['TAX_INCLUSIVE'],
      STRINGS['NO_TAX'],
    ],
    'PERCENTAGES': [
      '10%',
      '20%',
      '30%',
      '40%',
      '50%',
      '60%',
      '70%',
      '80%',
      '90%',
    ],
    'JOB_TYPES': [STRINGS['QUOTE'], STRINGS['JOB'], STRINGS['PERSONAL']],
    'REPEAT_VALUES': [
      STRINGS['REPEAT'],
      STRINGS['EVERY_DAY'],
      STRINGS['EVERY_WEEK'],
      STRINGS['EVERY_FORTNIGHT'],
      STRINGS['EVERY_MONTH'],
      STRINGS['EVERY_YEAR'],
      STRINGS['CUSTOM'],
    ],
    'JOB_STATUS': [STRINGS['NOT_DONE'], STRINGS['DONE'], STRINGS['CANCELLED']],
    'JOB_FILTERS': [
      STRINGS['QUOTE']!,
      STRINGS['JOB']!,
      STRINGS['PERSONAL']!,
      STRINGS['CLEAR']!,
    ],
  };

  static Map<String, dynamic> CONFIG = {
    'DEFAULT_EXPIRY': 30,
    'DEFAULT_GST': 10,
    'DEFAULT_TIMEZONE': 'Australia/Sydney',
    'PAGE': 1,
    'LIMIT': 5,
    'MAX_FILE_SIZE': 25 * 1024 * 1024, // 25 MB
    'INITIAL_QUANTITY': '1',
    'INITIAL_PRICE': '0.00',
    'S3_FOLDER_NAME': 'Profile_Pictures',
    'MAX_EXPIRY_YEAR': DateTime(2100),
    'MAX_ALLOWED_DATE': DateTime(2099, 12, 31),
    'MAX_COMPARISION_DATE': DateTime(2100, 1, 1),
    'MIN_ALLOWED_DATE': DateTime(2000, 1, 1),
    'DATE_FORMAT_1': DateFormat('dd MMM yyyy'),
    'DATE_FORMAT_2': DateFormat('yMMMd'),
    'DATE_FORMAT_3': DateFormat('yyyy-MM-dd'),
    'DATE_FORMAT_4': DateFormat('dd MMMM yyyy'),
    'DATE_FORMAT_5': DateFormat('dd/MM/yyyy'),
    'DATE_FORMAT_6': DateFormat("d MMM, hh:mma"),
    'DATE_FORMAT_7': DateFormat('EEEE, MMMM d'),
    'DATE_FORMAT_8': DateFormat('d MMM y'),
    'DOWNLOAD_PATH': '/storage/emulated/0/Download',
    'ALERT': 1,
    'JOD_ID': 0,
    'FSE_ALERT': 0,
    'TEXT_MIN_SCALE_FACTOR': 0.8,
    'TEXT_MAX_SCALE_FACTOR': 1.25,
    'FONT_FAMILY': 'Inter',
    'REFRESH_TOKEN_ENDPOINT': '/auth/refresh',
    'ANDROID_DOWNLOAD_DIRECTORY': '/storage/emulated/0/Download',
    'START_TIME': const TimeOfDay(hour: 0, minute: 0),
    'END_TIME': const TimeOfDay(hour: 23, minute: 59),
    'CONNECTION_TIMEOUT': const Duration(seconds: 10),
    'DEFAULT_ACCESS_TOKEN_EXPIRY': 3600,
    'DEFAULT_ACCOUNT_TYPE': 'REVENUE',
  };

  static Map<String, String> BOT_TOAST_MESSAGES = {
    'REQ_FIELDS': 'Please fill in all required fields',
    'TERMS_CHECK': 'Please accept terms and conditions',
    'SUCCESS_SIGN_IN': 'Signed in successfully',
    'FAILED_SIGN_IN': 'Failed to sign in',
    'SERVER_PROBLEM':
        'Our servers are currently unavailable. Please try again later',
    "FAILED_LOCATION_AUTO_COMPLETE": "Failed to fetch location",
    'CLIENT_CREATE_ERROR': 'Failed to create client',
    'CLIENT_UPDATE_SUCCESS': 'Client updated successfully',
    'CLIENT_UPDATE_ERROR': 'Failed to update client',
    "FAILED_FETCH_CLIENT_DETAIL": "Failed to fetch client detail",
    "FAILED_FETCH_CLIENT_OVERVIEW": "Failed to fetch client overview",
    'FAILED_UPDATE_PROPERTY': 'Failed to update default property',
    "FAILED_GLOBAL_SEARCH": "Failed to perform global search",
    'PLATFORM_NOT_SUPPORTED': 'Platform not supported',
    'DOWNLOAD_FAILED': 'Download Failed',
    'FAILED_LAUNCH_CALL': 'Failed to launch call',
    'FAILED_LAUNCH_SMS': 'Failed to launch SMS',
    'FAILED_LAUNCH_EMAIL': 'Failed to launch email',
    'FAILED_LAUNCH_URL': 'Failed to launch URL',
    'FAILED_FETCH_ADDRESS': 'Address not found',
    'SEND_EMAIL_FAILED': 'Failed to send email',
    "REQUEST_TIMED_OUT": "Request timed out. Please try again",
    'LOCATION_DENIED':
        'Location permission is denied, Please enable from device settings',
    'FAILED_FETCH_COORDINATES': 'Failed to fetch coordinates from address',
    "PLEASE_CHECK_INTERNET": "Please check your internet and try again",
    'TO_FIELD_EDITING':
        'You are currently editing an email in the To field. Please complete or clear it before sending.',
    'TO_FIELD_FINISH_EDITING':
        'You are currently editing an email in the To field. Please finish editing before sending.',
    'CC_FIELD_NOT_ADDED':
        'You have entered an email in the Cc field but haven\'t added it. Please add the email before sending.',
    'CC_FIELD_EDITING':
        'You are currently editing an email in the Cc field. Please complete or clear it before sending.',
    'CC_FIELD_FINISH_EDITING':
        'You are currently editing an email in the Cc field. Please finish editing before sending.',
    'NO_TO_RECIPIENT': 'Please add at least one recipient in the To field.',
    'TO_FIELD_NOT_ADDED':
        'You have entered an email in the To field but haven\'t added it. Please add the email before sending.',
    'FAILED_CLIENT_FETCH': 'Failed to fetch clients',
    'NO_MAP': 'No map available',
    'CLIENT_CREATE_SUCCESS': 'Client created successfully',
    'FILE_SIZE_LIMIT':
        'One or more files exceed the 25 MB size limit. Please select smaller files',
    'FILE_NOT_FOUND': 'File does not exist',
    'FILE_UPLOAD_FAILED': 'Failed to upload file',
    'NO_APP_TO_OPEN': 'No app to open the file',
    'FILE_OPENING_ERROR': 'Error opening the file',
    'FILE_DOWNLOAD_ERROR': 'Failed to download file',
    "FAILED_FETCH_TEMPLATE_STATUS": "Failed to fetch template status",
    "FAILED_FETCH_RESEND_TEMPLATE": "Failed to fetch resend template",
    "FAILED_FETCH_INVOICE_DETAIL": "Failed to fetch invoice detail",
    "FAILED_GENERATE_INVOICE_NUMBER": "Failed to generate invoice number",
    "FAILED_FETCH_TERMS": "Failed to fetch terms and conditions",
    "FAILED_FETCH_SERVICE": "Failed to fetch services",
    "FAILED_FETCH_SERVICE_DETAILS": "Failed to fetch service details",
    'SELECT_CLIENT': 'Please select a client',
    'INVOICE_CANCELLED': 'Invoice cancelled successfully',
    'INVOICE_PAID': 'Invoice paid successfully',
    'NO_PREVIOUS_QUOTE': 'No previous quotes found for selected client',
    "FAILED_FETCH_PREVIOUS_SERVICES": "Failed to fetch previous services",
    "FAILED_CANCEL_INVOICE": "Failed to cancel invoice",
    "FAILED_MARK_INVOICE_PAID": "Failed to mark invoice as paid",
    "FAILED_RESEND_INVOICE": "Failed to send invoice",
    "FAILED_SEND_INVOICE_RECEIPT": "Failed to send invoice receipt",
    "FAILED_FETCH_INVOICES": "Failed to fetch invoices",
    'INVOICE_RESENT': 'Invoice Resent Successfully',
    'RECEIPT_RESENT': 'Receipt Resent Successfully',
    'SUCCESS_DELETE_DRAFT_INVOICE': 'Draft invoice deleted successfully',
    'FAILED_DELETE_DRAFT_INVOICE': 'Failed to delete draft invoice',
    'INVOICE_NUMBER_ERROR': 'Please enter a valid invoice number',
    'CLIENT_SERVICE_REQUIRED':
        'Please select a client and add at least one service',
    'CLIENT_REQUIRED': 'Please select a client',
    'SERVICE_REQUIRED': 'Please add at least one service',
    'SERVICE_CODE_ERROR':
        'Please enter service code without spaces or special characters',
    "FAILED_FETCH_CHART_OF_ACCOUNTS": "Failed to fetch chart of accounts",
    'UNIT_PRICE_TOO_HIGH': 'Unit Price is too high',
    'UNIT_PRICE_INVALID': 'Please enter a valid Amount',
    'UNIT_PRICE_ZERO': 'Price must be greater than 0',
    'SERVICE_CREATE_SUCCESS': 'Service created successfully',
    'SERVICE_CREATE_ERROR': 'Failed to create service',
    'SERVICE_UPDATE_SUCCESS': 'Service updated successfully',
    'SERVICE_UPDATE_ERROR': 'Failed to update service',
    'SERVICE_DELETE_SUCCESS': 'Service deleted successfully',
    'SERVICE_DELETE_ERROR': 'Failed to delete service',
    "FAILED_CREATE_SERVICE": "Failed to create service",
    "FAILED_SAVE_SERVICE": "Failed to save service",
    "FAILED_UPDATE_SERVICE": "Failed to update service",
    "FAILED_DELETE_SERVICE": "Failed to delete service",
    'NO_CHANGES_MADE': 'No changes were made to update the service',
    'NO_INTERNET': 'No Internet Connection',
    'RECONNECT': 'Try reconnecting or switching to a different network.',
    'NO_INTERNET_DESCRIPTION':
        'Looks like there\'s no internet. Try reconnecting or switching to a different network.',
    'CONNECTION_RESTORED': 'Connection Restored',
    'TOKEN_REFRESH_FAILED': 'Token Refresh Failed',
    'SIGNED_OUT': 'You have successfully signed out. Thank you!',
    'PERMISSION_ERROR':
        'An error occurred while requesting permissions. Please try again',
    'CAMERA_PERMISSION': 'Please enable Camera permission in App Settings',
    'NOTIFICATION_PERMISSION':
        'Please enable Notification permission in App Settings',
    'PHOTO_DENIED': 'Please allow photo access from the device settings',
    'CAMERA_DENIED': 'Please allow camera access from the device settings',
    'FAILED_TO_FETCH_KPI': 'Failed to fetch dashboard',
    'FAILED_TO_CREATE_TAB': 'Failed to create tab',
    'FAILED_TO_FETCH_TABS': 'Failed to fetch tabs',
    'FAILED_TO_UPDATE_TAB': 'Failed to update tab',
    'FAILED_TO_DELETE_TAB': 'Failed to delete tab',
    'FAILED_TO_ADD_CLIENT_TO_TAB': 'Failed to add client to tab',
    "FAILED_FETCH_JOB_DETAIL": "Failed to fetch job detail",
    "FAILED_MARK_JOB_DONE": "Failed to mark job as done",
    "FAILED_CANCEL_JOB": "Failed to cancel job",
    "FAILED_FETCH_JOBS": "Failed to fetch jobs",
    "FAILED_FETCH_JOB_DATES": "Failed to fetch job dates",
    "FAILED_UPDATE_JOB": "Failed to update job",
    'NO_PREVIOUS_INVOICE': 'No previous invoices found for selected client',
    'NO_PREVIOUS_JOB': 'No previous jobs found for selected client',
    'NO_PREVIOUS_SERVICES': 'No services found for selected client',
    'QUOTE_VISIT_BOOK': 'Quote visit booked successfully',
    'JOB_BOOKED': 'Job booked successfully',
    'JOB_UPDATED': 'Job updated successfully',
    'JOB_DONE': 'Job done successfully',
    'SELECT_CLIENT_JOB':
        'Please select a client and type before booking the job',
    'START_END_TIME':
        'Please set both start and end times before booking the job',
    'JOB_CANCELLED': 'Job cancelled successfully',
    "FAILED_BOOK_JOB": "Failed to book job",
    "FAILED_BOOK_QUOTE_VISIT": "Failed to book quote visit",
    'END_TIME_ERROR': 'start time should be lesser than end time',
    'ADD_CLIENT': 'Please add a client before proceeding',
    'ADD_TYPE_CLIENT': 'Please select a client and type before booking the job',
    'QUANTITY_HIGH': 'Quantity is too high',
    'NOT_ADDRESS': 'Not a Proper destination address',
    'LAUNCH_ERROR': 'Could not launch',
    'CLASS_CREATED': 'Class created successfully',
    'FAILED_CREATE_CLASS': 'Failed to create class',
    'FAILED_FETCH_CLASSES': 'Failed to fetch classes',
    'SECTION_CREATED': 'Section created successfully',
    'FAILED_CREATE_SECTION': 'Failed to create section',
    'FAILED_FETCH_SECTIONS': 'Failed to fetch sections',
    'FAILED_FETCH_CLASS_DETAIL': 'Failed to fetch class detail',
    'FAILED_FETCH_SECTION_DETAIL': 'Failed to fetch section detail',
    'SECTION_UPDATED': 'Section updated successfully',
    'FAILED_UPDATE_SECTION': 'Failed to update section',
    'CLASS_UPDATED': 'Class updated successfully',
    'FAILED_UPDATE_CLASS': 'Failed to update class',
    'STUDENT_CREATED': 'Student created successfully',
    'FAILED_CREATE_STUDENT': 'Failed to create student',
    'FAILED_FETCH_PARENT': 'Failed to fetch parents',
    'FAILED_FETCH_STUDENTS': 'Failed to fetch students',
    'FAILED_FETCH_STUDENT_DETAIL': 'Failed to fetch student detail',
    'STUDENT_UPDATED': 'Student updated successfully',
    'FAILED_UPDATE_STUDENT': 'Failed to update student',
    'PARENT_CREATED': 'Parent created successfully',
    'FAILED_CREATE_PARENT': 'Failed to create parent',
    'PARENT_UPDATED': 'Parent updated successfully',
    'FAILED_UPDATE_PARENT': 'Failed to update parent',
    'FAILED_FETCH_PARENTS': 'Failed to fetch parents',
    'FAILED_FETCH_PARENT_DETAIL': 'Failed to fetch parent detail',
    'PASSWORD_RESET_EMAIL_SENT':
        'Password reset email sent successfully',
    'FAILED_SEND_PASSWORD_RESET_EMAIL':
        'Failed to send password reset email',
    'SUBJECT_CREATED': 'Subject created successfully',
    'FAILED_CREATE_SUBJECT': 'Failed to create subject',
    'FAILED_FETCH_SUBJECTS': 'Failed to fetch subjects',
    'FAILED_FETCH_SUBJECT_DETAIL': 'Failed to fetch subject detail',
    'FAILED_UPDATE_SUBJECT': 'Failed to update subject',
    'SUBJECT_UPDATED': 'Subject updated successfully',
    
  };

  static Map<String, String> STATUS_CODE_MESSAGES = {
    '400': 'Bad Request',
    '401': 'Unauthorized',
    '403': 'Forbidden',
    '404': 'Not Found',
    '500': 'Internal Server Error',
    '502': 'Bad Gateway',
    '503': 'Service Unavailable',
    '504': 'Gateway Timeout',
  };

  static Map<String, String> STORAGE_KEYS = {
    'REMEMBER_ME': 'rememberMe',
    'FCM_TOKEN': 'fCMToken',
    'USERNAME': 'username',
    'DEVICE_ID': 'device_id',
    'REFRESH_TOKEN': 'refreshToken',
    'ACCESS_TOKEN': 'accessToken',
    'ID_TOKEN': 'idToken',
    'CURRENCY': 'currency',
    'COUNTRY_DIAL_CODE': 'country_dial_code',
    'CLIENT_NAME': 'billedTo',
    'LATITUDE': 'latitude',
    'LONGITUDE': 'longitude',
    'EXPIRES_IN': 'expiresIn',
    'PERMISSION_PAGE_SHOWN': 'permission_page_shown',
    'USER_DATA': 'user_data',
    'SIGNED_URL': 'signedUrl',
  };

  static Map<String, String> ASSETS = {
    'EZIYO_SPLASH_LOGO': 'assets/gifs/Book_gif.gif',
    'LOGIN_LOGO': 'assets/images/logo.png',
    'ERROR_SCREEN': 'assets/images/error_screen.svg',
    'BACKGROUND_IMAGE': 'assets/images/login_background.jpg',
  };

  static Map<String, String> LINKS = {
    'FORGOT_PASSWORD': '',
    'PLAYSTORE': '',
    'APPSTORE_FOR_UPDATE': '',
    'PLAYSTORE_FOR_UPDATE': '',
    'TERMS_CONDITION': '',
    'SUPPORT': '',
    'PRIVACY_POLICY': '',
  };
}
