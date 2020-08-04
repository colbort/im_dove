import 'package:app/lang/lang.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widget/common/toast.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/services.dart';
import 'action.dart';
import 'state.dart';
import 'pw_key_board_component/action.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:app/event/index.dart';
import 'package:app/config/defs.dart';
import 'package:app/utils/passcode.dart';

Effect<BootPwState> buildEffect() {
  return combineEffects(<Object, Effect<BootPwState>>{
    PwKeyBoardAction.keyTyped: _onKeyTypePwAction,
    Lifecycle.initState: _onStateInitAction,
  });
}

void _onStateInitAction(Action action, Context<BootPwState> ctx) async {
  print(ctx.state);
  if (ctx.state.inputTitle == Lang.INPUTPWD) {
    appPausedEventBus.on().listen((event) async {
      String cachePw = await passcode.request();
      if (cachePw != null && cachePw.isNotEmpty) {
        ctx.dispatch(BootPwActionCreator.onChgShowingAction(true));
      }
    });
  } else {
    ctx.state.isShow = true;
  }
}

typedef _pwControlFn = dynamic Function();

void _onKeyTypePwAction(Action action, Context<BootPwState> ctx) async {
  ctx.dispatch(BootPwActionCreator.onAddTypedPwAction(action.payload));
  var state = ctx.state;
  final Map<PwPageType, _pwControlFn> _pwControlMapFn = {
    PwPageType.setPw: () {
      Navigator.of(ctx.context).pushNamed('bootPw', arguments: {
        'inputTitle': Lang.REINPUTPWD,
        'appBarTitle': Lang.ENSUREPASSOCDE,
        'isShowAppBar': true,
        'pwType': PwPageType.setPwConfirm,
        'cachePw': state.typedPw
      });
    },
    PwPageType.setPwConfirm: () async {
      /// FiXED: 设置密码锁储存唯一标识
      final String cachePw = state.cachePw;
      if (cachePw == state.typedPw) {
        showToast(Lang.SETSUCC, type: ToastType.positive);
        await passcode.save(code: cachePw);
        Navigator.of(ctx.context).pop();
        Navigator.of(ctx.context).pop();
      } else {
        vibrate();
        showToast(Lang.NOTTHESAME, type: ToastType.negative);
        ctx.dispatch(BootPwActionCreator.onResetPwAction(true));
        return;
      }
    },
    PwPageType.delPw: () async {
      final String cachePw = await passcode.request();
      if (cachePw == state.typedPw) {
        showToast(Lang.DELSUCC, type: ToastType.positive);
        await passcode.save();
        Navigator.of(ctx.context).pop();
      } else {
        showToast(Lang.SAFECODEERR, type: ToastType.negative);
        vibrate();
        ctx.dispatch(BootPwActionCreator.onResetPwAction(true));
      }
    },
    PwPageType.pwConfirm: () async {
      String cachePw = await passcode.request();
      if (cachePw == state.typedPw) {
        //state.sucDel(Navigator.of(ctx.context));
        ctx.dispatch(BootPwActionCreator.onChgShowingAction(false));
        if (freshBootPageEventBus != null) {
          freshBootPageEventBus.fire(null);
        }
      } else {
        showToast(Lang.SAFECODEERR, type: ToastType.negative);
        HapticFeedback.mediumImpact();
        ctx.dispatch(BootPwActionCreator.onResetPwAction(true));
      }
    }
  };

  if (state.typedPw.length == 4) {
    _pwControlMapFn[state.type]();
  }
}
