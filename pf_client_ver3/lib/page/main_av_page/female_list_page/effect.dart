import 'dart:convert';
import 'package:app/storage/index.dart';
import "package:collection/collection.dart";
import 'package:app/net/net.dart';
import 'package:app/page/main_av_page/female_list_page/action.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/services.dart';
import 'package:lpinyin/lpinyin.dart';
import 'state.dart';

Effect<FemaleListPageState> buildEffect() {
  return combineEffects(<Object, Effect<FemaleListPageState>>{
    Lifecycle.initState: _init,
  });
}

const FAMALE_KEY = 'FAMALE_KEY';

void _init(Action action, Context<FemaleListPageState> ctx) async {
  var _cacheRes = await ls.get(FAMALE_KEY);
  if (_cacheRes != null) {}
  var res = await net
      .request(Routers.VIDEO_NEW_MORE_APPACTORS_POST, args: {'maxId': 17179});

  try {
    if (res?.code == 200) {
      var groupData;
      if (_cacheRes != null && res.data['actorsVideoResp'].length == 0) {
        groupData = json.decode(_cacheRes);
      } else {
        final ByteData actorsJson = await rootBundle.load('assets/actors.json');
        String _jsonContent = utf8.decode(actorsJson.buffer.asUint8List());
        var _jsonData = json.decode(_jsonContent);

        if (res.data['actorsVideoResp'].length > 0) {
          _jsonData.addAll(res.data['actorsVideoResp']);
        }

        _jsonData.sort((a, b) {
          return PinyinHelper.getFirstWordPinyin(a['name'].trim().toLowerCase())
              .compareTo(PinyinHelper.getFirstWordPinyin(
                  b['name'].trim().toLowerCase()));
        });
        groupData = groupBy(
            _jsonData,
            (item) => PinyinHelper.getFirstWordPinyin(item['name'].trim())
                .substring(0, 1)
                .toUpperCase());
        print(groupData.keys);
        ls.save(FAMALE_KEY, json.encode(groupData));
      }

      ctx.dispatch(FemaleListPageActionCreator.saveFamaleList(
          {'list': groupData, 'domain': res.data['domain']}));

      ctx.dispatch(
        FemaleListPageActionCreator.changeLetterList(groupData.keys.toList()),
      );
    }
  } catch (e) {
    print(e);
  }
}
