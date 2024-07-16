import 'package:darleyexpress/models/order_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class StaticFunctions {
  double totalAmount(List<OrderModel> list) {
    double x = 0;
    for (var e in list) {
      x = x + e.total;
    }
    return x;
  }

  shareData(link) {
    Share.share(link);
  }

  urlLauncher(Uri uri) async {
    await launchUrl(uri);
  }
}
