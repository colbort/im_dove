library base;

import 'storage/light_storage.dart';

export 'log/log.dart';
export 'storage/light_storage.dart';
export 'util/text_util.dart';
export 'util/array_util.dart';

Future initBase() async {
  await lightModel.init();
}
