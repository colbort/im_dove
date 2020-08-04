import 'package:app/config/colors.dart';
import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/lang/lang.dart';
import 'package:app/net/net.dart';
import 'package:app/page/main_av_page/female_list_page/components/vedio_item.dart';
import 'package:app/pojo/av_data.dart';
import 'package:app/utils/comm.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/utils/screen.dart';
import 'package:app/widget/common/pullRefresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewestVideo extends StatefulWidget {
  final int types;

  const NewestVideo({Key key, this.types}) : super(key: key);
  @override
  _NewestVideoState createState() => _NewestVideoState();
}

class _NewestVideoState extends State<NewestVideo> {
  List data = List();
  RefreshController controller = RefreshController();
  Map<String, dynamic> _fetchData;
  var domain;

  @override
  void initState() {
    super.initState();
    _fetchData = {'types': widget.types, 'page': 1, 'pageSize': 10};
    _getList(_fetchData);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    data = [];
    domain = null;
    _fetchData = {};
  }

  _getList(Map<String, dynamic> params) async {
    var reps =
        await net.request(Routers.VIDEO_NEW_APPACTORS_POST, args: _fetchData);
    controller.loadComplete();
    if (reps?.code == 200) {
      if (reps.data['actorsVideoResp'].length == 0) {
        controller.loadNoData();
      }

      var listData = reps.data['actorsVideoResp'];
      domain = reps.data['domain'];
      List _trasformData = listData.map((f) {
        return ActressGroupBean.fromJson(f);
      }).toList();
      if (mounted) {
        this.setState(() {
          data.addAll(_trasformData);
        });
      }
    }
  }

  void _onLoadMore() {
    _fetchData['page'] += 1;
    _getList(_fetchData);
  }

  @override
  Widget build(BuildContext context) {
    return data.length > 0
        ? pullRefresh(
            refreshController: controller,
            enablePullDown: false,
            child: ListView(
              children: List.generate(data.length, (index) {
                return ActressGroup(
                  data: data[index],
                  domain: domain,
                );
              }),
            ),
            onLoading: _onLoadMore,
          )
        : Center(
            child: CupertinoActivityIndicator(),
          );
  }
}

class ActressGroup extends StatefulWidget {
  final ActressGroupBean data;
  final String domain;
  ActressGroup({
    this.data,
    this.domain = '',
  });
  @override
  _ActressGroupState createState() => _ActressGroupState();
}

class _ActressGroupState extends State<ActressGroup> {
  var itemW;
  var itemH;
  @override
  void initState() {
    super.initState();
    itemW = (Dimens.pt360 - 50) / 3;
    itemH = itemW * 3 / 2 - 10;
  }

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.fromLTRB(15, 0, 15, 0);
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Container(
            padding: padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(page_nvDetailPage,
                        arguments: {"id": widget.data.id.toString()});
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimens.pt54 / 2),
                      child: CachedNetworkImage(
                        cacheManager: ImgCacheMgr(),
                        imageUrl: widget.domain + widget.data.headUrl,
                        width: Dimens.pt54,
                        height: Dimens.pt54,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      height: 30,
                      width: s.realW(265),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            widget.data.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: c.c333333,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: Dimens.pt70,
                            height: Dimens.pt22,
                            child: Text(
                              '${widget.data.videonum}${Lang.BUYINGPIAN}',
                              style: TextStyle(
                                fontSize: 14,
                                color: c.c333333,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(Dimens.pt22 / 2),
                                topRight: Radius.circular(Dimens.pt22 / 2),
                                bottomRight: Radius.circular(Dimens.pt22 / 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: s.realW(265),
                      child: Text(
                        widget.data.descript,
                        style: TextStyle(
                          fontSize: 10,
                          color: c.cFFA8A8A8,
                        ),
                        textAlign: TextAlign.start,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
          ),
          Container(
            height: Dimens.pt182,
            padding: padding,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(widget.data.videos.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: VideoPreview(
                    width: itemW,
                    height: itemH,
                    domain: widget.domain,
                    timeVisible: true,
                    data: widget.data.videos[index],
                  ),
                );
              }),
            ),
          ),
          Divider(
            color: c.cFFF0F0F0,
            height: 10,
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
