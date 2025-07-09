import 'dart:io';
import 'package:media_kit/media_kit.dart';
import 'camera_api.dart';

class CameraApiV1 implements CameraAPI {
  final httpClient = HttpClient();
  final String host = '192.168.1.254';

  @override
  Future<void> connect() async {
    final uri = Uri.http(host, '/', {'custom':'1','cmd':'1001'});
    final res = await httpClient.getUrl(uri).then((r) => r.close());
    if (res.statusCode != 200) {
      throw Exception('No response from Camera V1');
    }
  }

  @override
  Future<void> startPreview(Player player) async {
    await player.open(
      Media(
        'rtsp://$host:554/live',
        extras: {'rtsp_transport': 'udp'},
      ),
    );
  }

  @override
  Future<void> startRecord() async {
    await _sendCmd(2001);
  }

  @override
  Future<void> stopRecord() async {
    await _sendCmd(2002);
  }

  Future<void> _sendCmd(int id) async {
    final uri = Uri.http(host, '/', {'custom':'1','cmd':'$id'});
    await httpClient.getUrl(uri).then((r) => r.close());
  }
}
