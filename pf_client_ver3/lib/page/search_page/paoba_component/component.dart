import 'package:app/page/main_pao_page/widget/main_pao_list_component/component.dart';

import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'state.dart';
import 'view.dart';

class PaoBaComponent extends Component<PaoBaState> {
  PaoBaComponent()
      : super(
          effect: buildEffect(),
          view: buildView,
          dependencies: Dependencies<PaoBaState>(
              adapter: null,
              slots: <String, Dependent<PaoBaState>>{
                'paobaList': MainPaoViewConnector() + MainPaoListComponent(),
              }),
        );
}
