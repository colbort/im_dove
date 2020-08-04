import 'package:app/page/main_pao_page/widget/main_pao_item_component/component.dart';
import 'package:app/page/main_pao_page/widget/main_pao_list_component/state.dart';
import 'package:app/utils/comm.dart';
import 'package:fish_redux/fish_redux.dart';

import 'reducer.dart';

class MainPaoAdapter extends SourceFlowAdapter<MainPaoListState> {
  MainPaoAdapter()
      : super(
          pool: <String, Component<Object>>{
            paoPostItem: MainPaoItemComponent(),
          },
          reducer: buildReducer(),
        );
}
