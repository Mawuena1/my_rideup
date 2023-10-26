import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message) async {
  await Fluttertoast.showToast(msg: message);
}
