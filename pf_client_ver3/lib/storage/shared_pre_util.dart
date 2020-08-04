import 'package:shared_preferences/shared_preferences.dart';

/*
*@Author: 王也
*@CreateDate: 2020-02-26 12:48
*@Description 本地数据缓存工具类
*/
var sharedPre = SharedPreferencesUtil();

class SharedPreferencesUtil {
  final String version = "1.0"; //当前数据的版本
  final int cacheMaxLength = 50; //缓存数量
  static const String HISTORY_TAG = "HistoryTag"; //电影观影记录缓存

  SharedPreferences prefs;

  //初始化缓存类
  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  //获取缓存搜索记录列表
  List<String> getHistoryTagList() {
    List<String> list = prefs.getStringList(HISTORY_TAG) ?? [];

    return list;
  }

  /*
   * 存储搜索记录
   * keyword  
   */
  Future<List<String>> saveHistoryTag(String keyword) async {
    List<String> list = prefs.getStringList(HISTORY_TAG) ?? [];

    //如果之前已经存在相同的记录
    for (var m in list) {
      //删除指定电影
      if (m == keyword) {
        list.remove(m);
        break;
      }
    }

    //如果已经缓存了最大值电影，先移除第一个再添加新数据
    if (list.length == cacheMaxLength) {
      list.removeAt(0);
    }

    //添加记录
    list.add(keyword);

    await prefs.setStringList(HISTORY_TAG, list);

    return list;
  }

  //删除单个记录,返回删除后列表
  Future<List<String>> deleteSingleHistoryTag(String keyword) async {
    List<String> list = prefs.getStringList(HISTORY_TAG) ?? [];

    for (var m in list) {
      if (m == keyword) {
        list.remove(m);
        break;
      }
    }
    await prefs.setStringList(HISTORY_TAG, list);

    return list;
  }

  //删除所记录
  Future<bool> deleteAllHistoryTags() async {
    return await prefs.setStringList(HISTORY_TAG, []);
  }
}
