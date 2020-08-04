import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<UniversalPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<UniversalPageState>>{
      SetPageAction.getUniversalData: _getUniversalData,
    },
  );
}

UniversalPageState _getUniversalData(UniversalPageState state, Action action) {
  final UniversalPageState newState = state.clone();
  newState.income = action.payload["income"].toString();
  newState.brokerage = action.payload["brokerage"].toString();
  newState.brokerageDay = action.payload["brokerageDay"].toString();
  newState.incomeDay = action.payload["incomeDay"].toString();
  newState.promotionDay = action.payload["promotionDay"].toString();
  newState.promotion = action.payload["promotion"].toString();
  return newState;
}
