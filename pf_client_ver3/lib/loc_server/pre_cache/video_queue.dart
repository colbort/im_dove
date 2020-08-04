import 'package:app/utils/logger.dart';
import 'cache.dart';

///当前正在播放的视频在队列中的位置
int videoPlayingIdx = -1;

///当前正在cache的视频在队列中的位置
int cachingIdx = -1;

///视频从当前播放位置往后缓存5个片源
const int cacheWindow = 5;

///视频源ts缓存多少片
const int tsCacheWindow = 1;

///视频列表
List<VideoElement> videoList = new List<VideoElement>();

///外面推送进来的视频单元结构
class VideoPushElement {
  ///视频id，全局唯一
  int videoId;

  ///视频m3u8播放地址
  String m3u8Url;
}

class VideoElement {
  ///视频id，用于去向数据服请求m3u8播放地址
  int videoId;

  ///视频m3u8播放地址
  String m3u8Url;

  ///m3u8文件是否缓存完毕
  bool m3u8Cached = false;

  ///视频key地址
  String keyUrl;

  ///视频key文件是否缓存完毕
  bool keyCached = false;

  ///需要缓存的ts地址
  List<String> tsUrl = List<String>();

  ///ts文件是否缓存完毕
  List<bool> tsCache = List<bool>();

  ///是否正在缓存
  bool isCaching = false;

  ///该位置视频资源是否缓存完毕
  bool isCahched() {
    // if (!m3u8Cached || !keyCached) {
    //   return false;
    // }
    if (!m3u8Cached) {
      return false;
    }
    if (tsCache == null || tsCache.length == 0) {
      return false;
    }
    // log.i("tsCache length:" + tsCache.length.toString());
    for (int i = 0; i < tsCacheWindow; i++) {
      if (!tsCache[i]) {
        return false;
      }
    }
    return true;
  }
}

///同步视频源数据
pushVideoElements(List<VideoPushElement> newElements) {
  if (newElements == null || newElements.length == 0) {
    return;
  }

  newElements.forEach((e) {
    videoList.add(VideoElement()
      ..videoId = e.videoId
      ..m3u8Url = e.m3u8Url);
  });
}

///重置视频源数据
resetVideoElements() {
  cancelCurCacheTask();
  videoList.clear();
  videoPlayingIdx = -1;
  cachingIdx = -1;
}

///刷新当前视频地址
freshVideoElements(int videoId) {
  log.i("fresh id:" + videoId.toString());
  for (int i = 0; i < videoList.length; i++) {
    if (videoList[i].videoId == videoId) {
      videoPlayingIdx = i;
      break;
    }
  }

  var isNeedCacheNext = false;
  //刷新缓存，如果当前播放视频跟当前缓存视频是同一个，取消当前缓存
  if (cachingIdx == videoPlayingIdx) {
    if (isCaching) {
      cancelCurCacheTask();
    }

    isNeedCacheNext = true;
  }
  //判断下一个视频是否缓存完毕， 或者正在缓存，如果不是，取消当前缓存
  else if (videoPlayingIdx < videoList.length - 1) {
    if (videoPlayingIdx + 1 != cachingIdx &&
        !videoList[videoPlayingIdx + 1].isCahched()) {
      if (isCaching) {
        cancelCurCacheTask();
      }
      isNeedCacheNext = true;
    }
  }

  if (isNeedCacheNext) {
    cacheNextVideoElement();
  }
}

///缓存下一个视频
cacheNextVideoElement() {
  //最后一个视频了，不需要缓存
  if (videoPlayingIdx == videoList.length - 1 || videoPlayingIdx < 0) {
    return;
  }

  //只需要提前缓存窗口内的片源
  for (int i = videoPlayingIdx + 1;
      (i < videoList.length - 1 && i < videoPlayingIdx + cacheWindow);
      i++) {
    if (!videoList[i].isCahched()) {
      cachingIdx = i;
      log.i("缓存 idx:" + cachingIdx.toString());
      cacheVideoElement(videoList[i]);
      return;
    }
  }
}
