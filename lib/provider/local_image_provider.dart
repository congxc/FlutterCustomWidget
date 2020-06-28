import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class NativeImageProvider extends ImageProvider<NativeImageProvider> {
  final String imageUrl;

  /// Scale of the image
  final double scale;

  const NativeImageProvider(this.imageUrl, {this.scale: 1.0});

  @override
  ImageStreamCompleter load(NativeImageProvider key, decode) {
    // TODO: implement load
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      informationCollector: () sync* {
        yield DiagnosticsProperty<ImageProvider>('Image provider', this);
        yield DiagnosticsProperty<NativeImageProvider>('Image key', key);
      },
    );
  }

  Future<ui.Codec> _loadAsync(NativeImageProvider key, decode) async {
    if (key.imageUrl == null) {
      return null;
    }
    assert(key == this);
    File file = File(key.imageUrl);
    bool exist = await file.exists();
    if(!exist){
      throw new Exception("File was not exist");
//      print("flutter========= 读不到SD图片 ========= ");
//      AssetBundle assetBundle = PlatformAssetBundle();
//      ByteData byteData = await assetBundle.load("resources/drawable/map_0310.png");
//      return await ui.instantiateImageCodec(byteData.buffer.asUint8List());
    }
    final Uint8List bytes = await file.readAsBytes();
    if (bytes.lengthInBytes == 0) {
      throw new Exception("File was empty");
    }
    return await ui.instantiateImageCodec(bytes);
  }

  @override
  Future<NativeImageProvider> obtainKey(ImageConfiguration configuration) {
    // TODO: implement obtainKey
    return new SynchronousFuture<NativeImageProvider>(this);
  }
}
