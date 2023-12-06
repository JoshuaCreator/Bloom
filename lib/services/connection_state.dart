import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> isOnline() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

// class AppConnectionState {
//   Future<bool> _isOnline() async {
//     final connectivityResult = await Connectivity().checkConnectivity();
//     return connectivityResult != ConnectivityResult.none;
//   }

//   Future checkConnectionState(BuildContext context) async {
//     bool isConnected = await _isOnline();
//     if (!isConnected) {
//       if (context.mounted) showSnackBar(context, msg: "You're offline");
//       return;
//     }
//   }
// }
