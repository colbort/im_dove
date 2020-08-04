import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/utils/comm.dart';
import 'package:app/utils/screen.dart';
import 'package:flutter/material.dart';

Widget buildfamaleItem(
    BuildContext context, String headLink, String name, String id) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pushNamed(page_nvDetailPage, arguments: {"id": id});
    },
    child: Container(
        child: Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 11),
            child: CircleAvatar(
              radius: 34.0,
              backgroundImage: CachedNetworkImageProvider(headLink,
                  cacheManager: ImgCacheMgr()),
              backgroundColor: Colors.transparent,
            ),
            width: s.realW(64),
            height: s.realW(64),
            padding: EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            )),
        Flexible(
          child: Text(
            name,
            style: TextStyle(fontSize: 12),
          ),
        )
      ],
    )),
  );
}
