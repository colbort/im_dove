import 'package:app/page/search_page/av_component/component.dart';
import 'package:app/page/search_page/paoba_component/component.dart';
import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'state.dart';
import 'view.dart';
import 'reducer.dart';

/*
*@Author: 王也
*@CreateDate: 2020-02-19 14:34
*@Description 泡吧，AV搜索页面
*/
class SearchPage extends Page<SearchMainPageState, Map<String, dynamic>> {
  SearchPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<SearchMainPageState>(
            adapter: null,
            slots: <String, Dependent<SearchMainPageState>>{
              'paoba': PaoBaConnector() + PaoBaComponent(),
              'av': AvConnector() + AvComponent(),
            },
          ),
        );
}
