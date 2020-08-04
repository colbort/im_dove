import 'dart:io';
import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 加载图片和svg的处理函数
enum ImageType {
  IMAGE_FILE,
  IMAGE_ASSETS,
  IMAGE_SVG,
  IMAGE_NETWORK_HTTP,
  IMAGE_NETWORK_SOCKET, // 使用IMsocket下载网络图片
  IMAGE_PHOTO,
  IMAGE_PRECACHE_SVG_ASSETS, // 预加载asset下面的svg图片;
}

class ImageLoader {
  ImageLoader.withP(
    this.type,
    this.address, {
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.colorBlendMode,
  });

  final String address;
  final double width;
  final double height;
  final BoxFit fit;
  final ImageType type;
  final Color color;
  final BlendMode colorBlendMode;

  Widget load() {
    switch (this.type) {
      case ImageType.IMAGE_FILE:
        if (TextUtil.isNotEmpty(address)) {
          // precacheImage();
          return Image.file(
            File(address),
            width: width,
            height: height,
            fit: fit,
            color: color,
          );
        }
        break;
      case ImageType.IMAGE_ASSETS:
        if (TextUtil.isNotEmpty(address)) {
          return Image.asset(
            address,
            width: width,
            height: height,
            fit: fit,
            color: color,
          );
        }
        break;
      case ImageType.IMAGE_NETWORK_HTTP:
        if (TextUtil.isNotEmpty(address)) {
          return CachedNetworkImage(
            errorWidget: (context, url, error) => Icon(
              Icons.error,
            ),
            cacheManager: ImgCacheMgr(),
            imageUrl: address,
            width: width,
            height: height,
            fit: fit,
            color: color,
            colorBlendMode: colorBlendMode,
            fadeOutDuration: Duration(milliseconds: 100),
            // placeholder: (context, url) => SpinKitFadingCircle(
            //   size: width,
            //   color: Colors.black,
            // ),
          );
        }
        break;

      case ImageType.IMAGE_SVG:
        if (TextUtil.isNotEmpty(address)) {
          return SvgPicture.asset(
            address,
            width: width,
            height: height,
            fit: fit,
            // placeholderBuilder: (context) =>
            //     SpinKitFadingCircle(size: width, color: Colors.black),
            color: color,
          );
        }
        break;
      case ImageType.IMAGE_PHOTO:
        break;
      default:
        break;
    }
    return Container();
  }

  /// 预加载图片
  preload(BuildContext context) {
    switch (type) {
      case ImageType.IMAGE_PRECACHE_SVG_ASSETS:
        var picProvider = ExactAssetPicture(
            SvgPicture.svgStringDecoder, address,
            colorFilter: getColorFilter(color, BlendMode.srcIn));
        precachePicture(picProvider, context);
        break;
      default:
        break;
    }
  }
}

ColorFilter getColorFilter(Color color, BlendMode colorBlendMode) =>
    color == null
        ? null
        : ColorFilter.mode(color, colorBlendMode ?? BlendMode.srcIn);
