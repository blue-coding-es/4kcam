import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/camera_api.dart';
import '../services/camera_api_v1.dart';
import '../services/camera_api_v2.dart';

final cameraProvider = FutureProvider<CameraAPI>((ref) async {
  // Detección automática
  final isV1 = await _detectV1();
  return isV1 ? CameraApiV1() : CameraApiV2();
});

Future<bool> _detectV1() async {
  try {
    final socket = await Socket.connect('192.168.1.254', 80, timeout: Duration(seconds: 2));
    socket.destroy();
    return true;
  } catch (_) {
    return false;
  }
}
