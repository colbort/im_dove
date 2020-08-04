final defs = _Defs();

class _Defs {
  /// 女优专题 人气女优数量
  var ztNvSize = 10;

  /// 最大ids数量
  var idsMaxLen = 50;

  /// //////////////////////////////////////常量////////////////////////////////////// ///
  var ztNvId = 999;

  ///女优位置索引
  var frmaleIdx = 0;
}

enum PwPageType { setPw, setPwConfirm, delPw, pwConfirm }

enum MainSVPageType {
  videoSv,
  searchSv,
  collectionSv,
  thematicSv,
  buyVideoSv,
  portfolioSv
}
