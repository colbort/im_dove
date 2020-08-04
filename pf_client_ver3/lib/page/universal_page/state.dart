import 'package:fish_redux/fish_redux.dart';

class UniversalPageState implements Cloneable<UniversalPageState> {
 String income;//总业绩
 String brokerage;//总收益
 String brokerageDay;//当日收益
 String incomeDay;//当日业绩
 String promotionDay;//当日推广人数
 String promotion;//总推广人数
  @override
  UniversalPageState clone() {
    return UniversalPageState()
      ..income = income
      ..brokerage = brokerage
      ..brokerageDay = brokerageDay
      ..incomeDay = incomeDay
      ..promotionDay=promotionDay
      ..promotion=promotion;
  }
}

UniversalPageState initState(Map<String, dynamic> args) {
  return UniversalPageState()
    ..income =  '00.00'
    ..brokerage =  '00.00'
    ..brokerageDay = '00.00'
    ..incomeDay =  '00.00'
    ..promotionDay =  '0'
    ..promotion =  '0';
}
