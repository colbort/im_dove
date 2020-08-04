import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class UploadVedioPage extends Page<UploadVedioState, Map<String, dynamic>> {
  UploadVedioPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<UploadVedioState>(
                adapter: null,
                slots: <String, Dependent<UploadVedioState>>{
                }),
            middleware: <Middleware<UploadVedioState>>[
            ],);

}
