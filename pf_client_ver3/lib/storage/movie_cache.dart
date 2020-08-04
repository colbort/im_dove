import 'dart:async';
import 'dart:convert';

import 'package:app/pojo/av_data.dart';
import 'package:app/storage/cache.dart';

/*
*@Author: 王也
*@CreateDate: 2020-02-26 12:48
*@Description 观影记录数据缓存工具类
*/

var viewRecord = MovieCache();

class MovieCache {
  final String version = "1.0"; //当前数据的版本
  final int cacheMaxLength = 50; //缓存最大电影数
  static const AV_MINE_VIEW_RECORD = "av_mine_view_record"; //电影观影记录缓存

  ViewRecordsBean _viewRecord = ViewRecordsBean();
  //  bool _fixed = true;

  StreamController<int> _controller = StreamController.broadcast();
  Stream get update => _controller.stream;

  void init() async {
    await getMovieList();
  }

  void dispose() {
    _controller.close();
  }

  //获取缓存电影列表
  Future<ViewRecordsBean> getMovieList() async {
    if (_viewRecord.records.length <= 0) {
      var dataStr = await ls.get(AV_MINE_VIEW_RECORD);
      if (dataStr != null) {
        _viewRecord = ViewRecordsBean.fromJson(json.decode(dataStr));
      }
    }
    // _fixed = false;
    return _viewRecord;
  }

  /*
   * 存储电影记录
   * id         电影id
   * movieName  电影名称
   * movieCover 电影封面
   * playTime   观看时间
   * totalTime  电影总时间
   * isBuy      是否购买
   */
  Future<bool> saveMovie(
    String id,
    String movieName,
    String movieCover,
    int playTime,
    int totalTime,
    bool isBuy,
  ) async {
    // //保存时间
    String createTime = _msFmt(DateTime.now().millisecondsSinceEpoch);
    // //观看百分比
    int totalPercent = 0;
    if (playTime > 0) {
      totalPercent = playTime * 100 ~/ totalTime;
    }
    int index = -1;
    bool exsist = _viewRecord?.records?.any((v) {
      index++;
      return v.id == id;
    });
    if (exsist) {
      _viewRecord.records.removeAt(index);
      var temp = ViewRecordBean(
        id: id,
        movieName: movieName,
        movieCover: movieCover,
        totalTime: totalTime,
        playTime: playTime,
        isBuy: isBuy,
        version: version,
        percent: totalPercent,
        createTime: createTime,
      );
      _viewRecord.records.insert(index, temp);
    } else {
      if ((_viewRecord?.records?.length ?? 0) >= cacheMaxLength) {
        _viewRecord.records.removeAt(0);
      }

      _viewRecord?.records?.add(ViewRecordBean(
        id: id,
        movieName: movieName,
        movieCover: movieCover,
        totalTime: totalTime,
        playTime: playTime,
        isBuy: isBuy,
        version: version,
        percent: totalPercent,
        createTime: createTime,
      ));
    }

    if (_viewRecord == null) {
      return false;
    }
    _controller.add(0);
    var dataStr = json.encode(_viewRecord);
    return await ls.save(AV_MINE_VIEW_RECORD, dataStr);
  }

  //删除单个电影记录,返回删除后的电影观看列表
  Future<ViewRecordsBean> deleteSingleMovie(String id) async {
    _viewRecord.records.removeWhere((data) => data.id == id);
    var dataStr = json.encode(_viewRecord);
    await ls.save(AV_MINE_VIEW_RECORD, dataStr);
    return _viewRecord;
  }

  //删除所有电影记录
  Future<bool> deleteAllMovie(String id) async {
    return await ls.save(AV_MINE_VIEW_RECORD, '');
  }

  //时间戳转年月日时分秒
  String _msFmt(int ms) {
    var date = DateTime.fromMillisecondsSinceEpoch(ms);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
