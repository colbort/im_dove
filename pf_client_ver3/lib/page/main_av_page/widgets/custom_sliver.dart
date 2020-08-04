import 'package:app/pojo/av_data.dart';
import 'package:app/utils/dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSliver extends StatefulWidget implements PreferredSizeWidget {
  final ScrollController scrollController;
  final DataController dataController;
  final VisibleController visibleController;
  CustomSliver({
    this.scrollController,
    this.dataController,
    this.visibleController,
  });

  @override
  _CustomSliverState createState() => _CustomSliverState();

  @override
  Size get preferredSize => Size.fromHeight(Dimens.pt44);
}

class _CustomSliverState extends State<CustomSliver> {
  var _position = 0.0;
  List<ClassifyBean> _data;


  void _update(List<ClassifyBean> data) {
    setState(() {
      _data = data;
    });
  }


  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_listener);
    widget.dataController.update = this._update;
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
     var position = widget.scrollController.position.pixels;
     var maxScrollExtent=widget.scrollController.position.maxScrollExtent;
     if (position < 0.0 ||
         position > maxScrollExtent) {
       return;
     }

    if (_position-position>0) {

      setState(() {
        widget.visibleController..visible = false;
      });

    }  else if (_position-position<0) {

      setState(() {
        widget.visibleController..visible = true;
      });

    }
     _position = position;
  }


  @override
  Widget build(BuildContext context) {
    var position = widget.scrollController.position.pixels;
    if (position==0) {
      widget.visibleController..visible = false;
    }
    return Visibility(
      visible: widget.visibleController.visible,
      child: Container(
        height: Dimens.pt44,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _data?.length ?? 0,
            (index) {
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.yellow,
                  ),
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Text(
                    _data[index].name,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

typedef _DataChanged = void Function(List<ClassifyBean>);

class DataValue {
  const DataValue({
    // this.data,
    this.update,
  });

  DataValue copyWith(_DataChanged update) {
    return DataValue(update: update);
  }

  // final T data;
  final _DataChanged update;
}

typedef Visible = void Function(bool);

class DataController extends ValueNotifier<DataValue> {
  DataController({_DataChanged update}) : super(DataValue(update: update));
  _DataChanged get update => value.update;
  set update(_DataChanged update) => value = value.copyWith(update);
}

class VisibleValue {
  const VisibleValue({
    this.visible,
  });

  VisibleValue copyWith(bool visible) {
    return VisibleValue(visible: visible);
  }

  final bool visible;
}

class VisibleController extends ValueNotifier<VisibleValue> {
  VisibleController({bool visible}) : super(VisibleValue(visible: visible));
  bool get visible => value.visible;
  set visible(bool visible) => value = value.copyWith(visible);
}
