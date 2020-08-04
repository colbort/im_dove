import 'package:app/config/image_cfg.dart';
import 'package:app/image_cache/image_loader.dart';
import 'package:app/pojo/av_data.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/utils/screen.dart';
import 'package:app/widget/swiper_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Carousel extends StatelessWidget {
  final Carouses datas;
  final BuildContext context;
  final ValueChanged onClicked;
  Carousel({
    @required this.datas,
    @required this.context,
    @required this.onClicked,
  });
  @override
  Widget build(BuildContext context) {
    var unIcon = Container(
      width: 12,
      height: 6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImgCfg.MAIN_UNBANNER),
        ),
      ),
    );

    var icon = Container(
      width: 26,
      height: 6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImgCfg.MAIN_BANNER),
        ),
      ),
    );

    List<Widget> list = ((datas?.carouses?.length ?? 0) <= 0)
        ? []
        : datas.carouses.map((data) {
            return ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: ImageLoader.withP(
                  ImageType.IMAGE_NETWORK_HTTP,
                  data?.linkImg,
                  width: s.realW(360),
                  height: s.realH(250),
                  fit: BoxFit.cover,
                ).load());
          }).toList();

    return Container(
      alignment: Alignment.topCenter,
      height: Dimens.pt145,
      child: Swiper(
        outer: false,
        scale: 0.94,
        itemBuilder: (BuildContext context, int index) {
          if (list.length > index) return list[index];
          return Container();
        },
        viewportFraction: 0.92,
        layout: SwiperLayout.DEFAULT,
        itemCount: datas?.carouses?.length ?? 0,
        pagination: SwiperPagination(
          builder: SwiperBuilder(
            activeW: icon,
            normalW: unIcon,
            space: 10.0,
          ),
        ),
        control: SwiperControl(
          iconPrevious: null,
          iconNext: null,
        ),
        onTap: (index) => onClicked(datas.carouses[index]),
        autoplay: list.length > 0,
      ),
    );
  }
}
