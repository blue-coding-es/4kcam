import 'dart:io';
import 'package:media_kit/media_kit.dart';

/// Interfaz común para V1 y V2
abstract class CameraAPI {
  Future<void> connect();
  Future<void> startPreview(Player player);
  Future<void> startRecord();
  Future<void> stopRecord();
}
