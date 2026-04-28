import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  // Singleton setup (optional but recommended)
  UrlLauncherService._privateConstructor();
  static final UrlLauncherService instance =
      UrlLauncherService._privateConstructor();

  /// Open any URL
  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  /// Open website in browser
  Future<void> openWebsite(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open website');
    }
  }

  /// Make phone call
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

    if (!await launchUrl(uri)) {
      throw Exception('Could not make call');
    }
  }

  /// Send SMS
  Future<void> sendSMS(String phoneNumber, {String message = ''}) async {
    final Uri uri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': message},
    );

    if (!await launchUrl(uri)) {
      throw Exception('Could not send SMS');
    }
  }

  /// Send Email
  Future<void> sendEmail({
    required String email,
    String subject = '',
    String body = '',
  }) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': subject, 'body': body},
    );

    if (!await launchUrl(uri)) {
      throw Exception('Could not send email');
    }
  }

  /// Open Google Maps location
  Future<void> openMap(double latitude, double longitude) async {
    final Uri uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open map');
    }
  }
}
