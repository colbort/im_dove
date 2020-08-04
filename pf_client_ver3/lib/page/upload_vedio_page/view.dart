import 'dart:io';

import 'package:app/lang/lang.dart';
import 'package:app/page/upload_vedio_page/components/loading.dart';
import 'package:app/page/upload_vedio_page/state.dart';
import 'package:app/page/upload_vedio_page/upload/upload_video.dart';
import 'package:app/page/upload_vedio_page/upload_type_view/defaultView.dart';
import 'package:app/page/upload_vedio_page/upload_type_view/image_upload_view.dart';
import 'package:app/page/upload_vedio_page/upload_type_view/video_upload_view.dart';
import 'package:app/storage/cache.dart';
import 'package:app/utils/logger.dart';
import 'package:app/utils/screen.dart';
import 'package:app/utils/video_cmd_helper.dart';
import 'package:app/widget/common/confirm.dart';
import 'package:app/widget/common/toast.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:wakelock/wakelock.dart';
import '../../widget/common/BasePage.dart';
import 'action.dart';
import 'components/label.dart';
import 'components/tag.dart';

class Tag {
  int id;
  String name;
  Tag(this.name, this.id);
}

Widget buildView(
    UploadVedioState state, Dispatch dispatch, ViewService viewService) {
  return _UploadVedioView(
      dispatch: dispatch, state: state, viewService: viewService);
}

// ignore: must_be_immutable
class _UploadVedioView extends BasePage with BasicPage {
  final UploadVedioState state;
  final Dispatch dispatch;
  final ViewService viewService;
  _UploadVedioView({Key key, this.dispatch, this.state, this.viewService})
      : super(key: key);
  String screenName() => '发布话题';

  getAgree() async {
    return await ls.get(StorageKeys.UPDATEVD_AGREE) ?? '';
  }

  void skipToNoticePage() async {
    await Navigator.pushNamed(viewService.context, 'uploadNoticePage');
    final isAgreen = await getAgree();
    dispatch(UploadVedioActionCreator.updateAgree(isAgreen.toString().isEmpty));
  }

  void _tagHandle(bool isSelected, tagItem) {
    if (isSelected) {
      state.selectedtags.removeWhere((ff) => tagItem['name'] == ff.name);
      dispatch(UploadVedioActionCreator.selectedtags(state.selectedtags));
    } else {
      if (state.selectedtags.length >= 5) {
        showToast('最多5個標簽!', type: ToastType.negative);
        return;
      }
      state.selectedtags.add(Tag(tagItem['name'], tagItem['id']));
      dispatch(UploadVedioActionCreator.selectedtags(state.selectedtags));
    }
  }

  Widget _renderUploadType(UploadType type) {
    Map<UploadType, Widget> _view = {
      UploadType.image: imageUploadView(state, dispatch, selectMultiImages),
      UploadType.video:
          videoUploadView(state, dispatch, selectVideoCover, selectPreviewVd)
    };
    if (_view[type] != null) {
      return _view[type];
    } else {
      return defaultUploadView(state,
          selectVd: selectVd, selectImage: selectMultiImages);
    }
  }

  @override
  Widget body() {
    return GestureDetector(
        onTap: () {
          FocusScope.of(viewService.context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        tipLabel(
                          text: '標題',
                          subtitle: '',
                        ),
                        Container(
                          width: s.realW(340),
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/common/textbox.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: TextField(
                            maxLines: 3,
                            controller: state.titleController,
                            autofocus: false,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "請輸入话題内容",
                              contentPadding: EdgeInsets.only(
                                left: s.realH(10),
                                bottom: s.realH(8),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Color(0xffd0d0d0), width: 0.5)),
                            ),
                          ),
                        ),
                        tipLabel(
                          text: '添加標簽',
                          subtitle: '(用戶最多可選擇5個標簽)',
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child:
                              Wrap(spacing: 8.0, runSpacing: 10.0, children: [
                            ...state.tags.map((f) {
                              bool isSelected = state.selectedtags
                                      .indexWhere((s) => s.name == f['name']) >=
                                  0;
                              return buildTag(f['name'], isSelected,
                                  onTapHandle: () {
                                _tagHandle(isSelected, f);
                              });
                            }).toList(),
                            BuildcustomTag('#自定义标签', true, (v) {
                              var _newTag = [
                                ...state.tags,
                                {'name': v, 'isCustom': true}
                              ];
                              dispatch(UploadVedioActionCreator.selectedtags(
                                  [...state.selectedtags, Tag(v, -1)]));
                              dispatch(
                                  UploadVedioActionCreator.onSaveTags(_newTag));
                            }),
                          ]),
                        ),
                        tipLabel(
                          text: state.uploadType == UploadType.image
                              ? '上傳图片'
                              : state.uploadType == UploadType.video
                                  ? '上傳视频'
                                  : '选择',
                          subtitle: state.uploadType == UploadType.image
                              ? '(最多可以选择9张图片)'
                              : state.uploadType == UploadType.video
                                  ? '(视频格式：MP4)'
                                  : '',
                        ),
                        _renderUploadType(state.uploadType),
                        tipLabel(
                          text: '設置價格',
                          subtitle: '(價格為整數人民幣 0～10元)',
                        ),
                        Row(children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: s.realW(20), right: s.realW(12)),
                            child: GestureDetector(
                              onTap: () {
                                state.moneyLabe -= 1;
                                if (state.moneyLabe <= 0) {
                                  state.moneyLabe = 0;
                                }
                                dispatch(UploadVedioActionCreator.moneyLabe(
                                    state.moneyLabe));
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: SvgPicture.asset(
                                    'assets/common/remove.svg'),
                              ),
                            ),
                          ),
                          Stack(
                              alignment:
                                  Alignment.center, //指定未定位或部分定位widget的對齊方式
                              children: <Widget>[
                                Container(
                                  child: SvgPicture.asset(
                                    'assets/common/moneybox.svg',
                                    height: s.realH(30),
                                  ),
                                ),
                                Positioned(
                                  child: Text(
                                    state.moneyLabe.toString(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ]),
                          Padding(
                            padding: EdgeInsets.only(left: s.realW(10)),
                            child: GestureDetector(
                              onTap: () {
                                state.moneyLabe += 1;
                                if (state.moneyLabe >= 10) {
                                  state.moneyLabe = 10;
                                  dispatch(UploadVedioActionCreator.moneyLabe(
                                      state.moneyLabe));
                                } else {
                                  dispatch(UploadVedioActionCreator.moneyLabe(
                                      state.moneyLabe));
                                }
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child:
                                    SvgPicture.asset('assets/common/add.svg'),
                              ),
                            ),
                          ),
                        ]),
                        SizedBox(
                          height: s.realH(5),
                        ),
                        Container(
                          width: s.realW(350),
                          padding: EdgeInsets.only(left: s.realW(15)),
                          alignment: Alignment.topLeft,
                          child: Text(
                            Lang.SHEZHIJIAGE,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ]),
                ),
                Container(
                  height: s.realH(130),
                  margin: EdgeInsets.only(top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                              width: s.realW(156),
                              height: s.realH(42),
                              child: FlatButton(
                                child: Text(
                                  "取消",
                                ),
                                color: Colors.grey.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                onPressed: () {
                                  Navigator.of(viewService.context).pop();
                                },
                              )),
                          Container(
                              width: s.realW(156),
                              height: s.realH(42),
                              child: FlatButton(
                                child: Text("发布"),
                                color: Colors.yellow,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                onPressed: () {
                                  if (state.isAgree) {
                                    if (state.uploadType == UploadType.image) {
                                      uploadImageTopic();
                                    } else {
                                      uploadVdTopic();
                                    }
                                  } else {
                                    skipToNoticePage();
                                  }
                                },
                              )),
                        ],
                      ),
                      SizedBox(height: s.realH(10)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              await ls.save(StorageKeys.UPDATEVD_AGREE,
                                  state.isAgree ? 'agree' : '');
                              dispatch(UploadVedioActionCreator.updateAgree(
                                  !state.isAgree));
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: s.realH(3)),
                              child: SvgPicture.asset(
                                state.isAgree
                                    ? 'assets/common/checkmark.svg'
                                    : 'assets/common/checkmarkbg.svg',
                                width: s.realW(10),
                                height: s.realH(10),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              child: Text('已閱讀並同意上傳須知',
                                  style: TextStyle(
                                      fontSize: 10,
                                      decoration: TextDecoration.underline)),
                            ),
                            onTap: () {
                              skipToNoticePage();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Function progressCallBack;
  void setProgressCallBack(Function _progressCallBack) {
    this.progressCallBack = _progressCallBack;
  }

  void onCompressCallback(double progress) {
    if (this.progressCallBack != null) {
      this.progressCallBack(
          Lang.UPLOAD_COMPRESS_PROGRESS, (progress * 100).toInt());
    }
  }

  void onUploadCallback(double progress) {
    if (this.progressCallBack != null) {
      this.progressCallBack(
          Lang.UPLOAD_UPLOAD_PROGRESS, (progress * 100).toInt());
    }
  }

  void onPreVideoUploadCallback(double progress) {
    if (this.progressCallBack != null) {
      this.progressCallBack(
          Lang.UPLOAD_PRE_UPLOAD_PROGRESS, (progress * 100).toInt());
    }
  }

  bool _checkFormVoild() {
    if (state.titleController.value.text.isEmpty) {
      showToast('標題不能為空', type: ToastType.negative);
      return false;
    }

    if (state.selectedtags.length > 5) {
      showToast('標簽數量不能大於5個', type: ToastType.negative);
      return false;
    }

    if (state.uploadType == null) {
      showToast('请选择上传图片或者视频', type: ToastType.negative);
      return false;
    }

    if (state.uploadType == UploadType.video) {
      if (state.videoPath == null) {
        showToast('視頻不能為空', type: ToastType.negative);
        return false;
      }
      if (state.updateLocalImage == null) {
        showToast('視頻封面不能為空', type: ToastType.negative);
        return false;
      }
    }

    if (state.uploadType == UploadType.image) {
      if (state.selectedImages.length == 0) {
        showToast('图片至少大于一张', type: ToastType.negative);
        return false;
      }
    }

    return true;
  }

  //上傳图片话题
  void uploadImageTopic() async {
    if (!_checkFormVoild()) return;
    List _tags = state.selectedtags.map((f) => f.name).toList();

    Map<String, dynamic> params = {};
    //上傳類型: 1 -> pics    2 -> video,
    params['type'] = 1;
    params['tags'] = _tags;
    params['text'] = state.titleController.value.text;

    String price = state.moneyLabe.toString();
    if (price == null || price.isEmpty) {
      params['price'] = 0;
    } else {
      params['price'] = int.parse(price);
    }

    // 图片列表发布
    ProgressDialog.show(viewService.context, (Function updateTip) {
      if (updateTip != null) {
        updateTip('图片上传中……', 0);
      }
    });
    Wakelock.enable();
    List<Asset> _paths = state.selectedImages;
    List _imgs = await Future.wait(List.generate(_paths.length, (int i) async {
      ByteData byteData = await _paths[i].getByteData(quality: 50);
      File _file = await writeToFile(byteData, _paths[i].name.split('/')[0]);
      return uploadImage(
        _file.path,
      );
    }));
    log.i("图片返回的id:" + _imgs.toString());
    params['pics'] = _imgs;
    ProgressDialog.dismiss(viewService.context);
    ProgressDialog.show(viewService.context, (Function updateTip) {
      if (updateTip != null) {
        updateTip('话题发布中……', 0);
      }
    });
    var rlt = await confirmPublish(viewService.context, params);
    Wakelock.disable();
    if (!rlt) {
      ProgressDialog.dismiss(viewService.context);
      showConfirm(viewService.context,
          child: Text(Lang.UPLOAD_VIDEO_PUBLISHFAIL + params['errmsg']));
      return;
    }

    ProgressDialog.dismiss(viewService.context);
    await showConfirm(viewService.context,
        child: Text(Lang.UPLOAD_VIDEO_PUBLISHSUC));
    Navigator.of(viewService.context).pop();
  }

  //上傳視頻话题
  void uploadVdTopic() async {
    if (!_checkFormVoild()) return;
    List _tags = state.selectedtags.map((f) => f.name).toList();

    Map<String, dynamic> params = {};
    //上傳類型: 1 -> pics    2 -> video,
    params['type'] = 2;
    params['tags'] = _tags;
    params['text'] = state.titleController.value.text;

    String price = state.moneyLabe.toString();
    if (price == null || price.isEmpty) {
      params['price'] = 0;
    } else {
      params['price'] = int.parse(price);
    }

    //數據加載loading
    Wakelock.enable();
    ProgressDialog.show(viewService.context, setProgressCallBack);
    //ios不需要壓縮，安卓需要壓縮，分��處理
    var videoPath = state.videoPath;
    if (Platform.isAndroid) {
      VideoCmdHelper().setCompressCallBack(this.onCompressCallback);
      videoPath = await VideoCmdHelper().compress(state.videoPath);

      if (videoPath == null || videoPath.isEmpty) {
        Wakelock.disable();
        showToast(Lang.UPLOAD_COMPRESS_FAILED);
        return;
      }
    }

    // 视频发布
    var _videoUrl = await uploadVideo(videoPath, onUploadCallback);
    log.i("視頻返回的id:" + _videoUrl);
    params['videoUrl'] = _videoUrl;
    this.progressCallBack(Lang.UPLOAD_VIDEO_PUBLISH, 0);
    bool rlt = await videoOk(viewService.context, params);
    if (!rlt) {
      ProgressDialog.dismiss(viewService.context);
      Wakelock.disable();
      showConfirm(viewService.context,
          child: Text(Lang.UPLOAD_VIDEO_PUBLISHFAIL + params['errmsg']));
      return;
    }

    // 视频封面发布
    this.progressCallBack(Lang.UPLOAD_UPLOAD_COVER, 0);
    var coverPath = state.updateLocalImage;
    var _coverImg = await uploadImage(coverPath);
    log.i("图片返回的id:" + _coverImg);
    params['videoPic'] = _coverImg;

    // 预览视频发布
    if (state.previewVideoPath != null) {
      var _videoPreviewUrl =
          await uploadVideo(state.previewVideoPath, onPreVideoUploadCallback);
      log.i("预览視頻返回的id:" + _videoPreviewUrl);
      params['videoPreviewUrl'] = _videoPreviewUrl;
      this.progressCallBack(Lang.UPLOAD_PRE_VIDEO_PUBLISH, 0);
      bool rlt = await videoOk(viewService.context, params);
      if (!rlt) {
        ProgressDialog.dismiss(viewService.context);
        Wakelock.disable();
        showConfirm(viewService.context,
            child: Text(Lang.UPLOAD_PRE_VIDEO_PUBLISHFAIL + params['errmsg']));
        return;
      }
    }

    rlt = await confirmPublish(viewService.context, params);
    if (!rlt) {
      ProgressDialog.dismiss(viewService.context);
      Wakelock.disable();
      showConfirm(viewService.context,
          child: Text(Lang.UPLOAD_VIDEO_PUBLISHFAIL + params['errmsg']));
      return;
    }

    //success
    ProgressDialog.dismiss(viewService.context);
    Wakelock.disable();
    await showConfirm(viewService.context,
        child: Text(Lang.UPLOAD_VIDEO_PUBLISHSUC));
    Navigator.of(viewService.context).pop();

    //清理臨���視頻和圖片
    File videoFile = File(videoPath);
    videoFile.delete();
    File coverFile = File(coverPath);
    coverFile.delete();
  }

  //選擇視頻
  void selectVd() async {
    var video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      var fileSize = await video.length();
      var maxFileSize = 250;
      if (Platform.operatingSystem == "ios") {
        maxFileSize = 99;
      }
      if (fileSize ~/ (1024 * 1024) > maxFileSize) {
        showToast(
            Lang.val(Lang.UPLOAD_SELECT_VIDEO_TOOBIG, args: [maxFileSize]));
      } else {
        dispatch(UploadVedioActionCreator.updateVdFile(video.path));
        VideoCmdHelper().getPic(video.path).then((data) {
          dispatch(UploadVedioActionCreator.updateVdImage(data));
        });
      }
    }
  }

  // 选择预览视频
  void selectPreviewVd() async {
    var video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      var fileSize = await video.length();
      var maxFileSize = 250;
      if (Platform.operatingSystem == "ios") {
        maxFileSize = 99;
      }
      if (fileSize ~/ (1024 * 1024) > maxFileSize) {
        showToast(
            Lang.val(Lang.UPLOAD_SELECT_VIDEO_TOOBIG, args: [maxFileSize]));
      } else {
        dispatch(UploadVedioActionCreator.updatePreviewVdFile(video.path));
        VideoCmdHelper().getPic(video.path).then((data) {
          dispatch(UploadVedioActionCreator.updatePreviewVdImage(data));
        });
      }
    }
  }

  Future<void> selectMultiImages() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: true,
        selectedAssets: state.selectedImages,
        cupertinoOptions: CupertinoOptions(
            takePhotoIcon: "chat", selectionFillColor: '#ffe300'),
        materialOptions: MaterialOptions(
          actionBarColor: "#ffe300",
          allViewTitle: "选择照片",
          statusBarColor: "#000000",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }
    if (resultList.length != state.selectedImages.length) {
      dispatch(UploadVedioActionCreator.updateImageList(resultList));
    }
  }

  // void selectImage() async {
  //   var file = await ImagePicker.pickImage(
  //       source: ImageSource.gallery, imageQuality: 30);
  //   if (file != null) {
  //     List newImageList = state.selectedImages;
  //     newImageList.add(file.path);
  //     dispatch(UploadVedioActionCreator.updateImageList(newImageList));
  //   }
  // }

  //選擇視頻封面
  void selectVideoCover() {
    // print("選擇視頻封面");
    FocusScope.of(viewService.context).requestFocus(FocusNode());
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: viewService.context,
        builder: (BuildContext context) {
          return GestureDetector(
              onTap: () {
                Navigator.pop(viewService.context);
              },
              child: Container(
                  color: Colors.transparent,
                  height: s.realH(200),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 15,
                        right: 15,
                        bottom: s.realH(80),
                        // height: s.realH(150),
                        child: Container(
                            child: Column(children: <Widget>[
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              height: s.realH(40),
                              child: Text("��頻截取封面"),
                            ),
                            onTap: () {
                              Navigator.pop(viewService.context);
                              if (state.updateVdImage != null) {
                                state.updateLocalImage = state.updateVdImage;
                                dispatch(
                                    UploadVedioActionCreator.updateLocalImage(
                                        state.updateLocalImage));
                              } else {
                                showToast('請先上傳視頻', type: ToastType.negative);
                              }
                            },
                          ),
                          SizedBox(
                            height: s.realH(5),
                          ),
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              height: s.realH(40),
                              child: Text("本地上傳封面"),
                            ),
                            onTap: () async {
                              Navigator.pop(viewService.context);
                              var coverFile = await ImagePicker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 30);
                              if (coverFile != null) {
                                state.updateLocalImage = coverFile.path;
                                dispatch(
                                    UploadVedioActionCreator.updateLocalImage(
                                        state.updateLocalImage));
                              }
                            },
                          ),
                        ])),
                      )
                    ],
                  )));
        });
  }
}
