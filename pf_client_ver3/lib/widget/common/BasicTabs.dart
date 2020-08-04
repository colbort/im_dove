import 'package:flutter/material.dart';
import 'package:app/widget/custom_tab_indicator.dart';

class BasicTabs extends StatefulWidget {
  final List<String> tabItems;
  final Function tabHandle;
  BasicTabs({Key key, this.tabItems, this.tabHandle}) : super(key: key);

  @override
  BasicTabsState createState() => BasicTabsState(tabItems, tabHandle);
}

class BasicTabsState extends State<BasicTabs>
    with SingleTickerProviderStateMixin {
  final List<String> _tabItems;
  final Function _tabHandle;
  BasicTabsState(this._tabItems, this._tabHandle) : super();
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: _tabItems.length);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: _tabHandle,
      isScrollable: true,
      controller: tabController,
      labelPadding: EdgeInsets.only(right: 8.0, left: 8.0),
      indicatorPadding: EdgeInsets.only(bottom: 10),
      indicatorSize: TabBarIndicatorSize.label,
      unselectedLabelColor: Colors.black54,
      labelColor: Colors.black87,
      tabs: _tabItems
          .map((f) => Container(
                alignment: Alignment.center,
                width: 60,
                height: 20,
                child: Text(f, style: TextStyle(fontSize: 14)),
              ))
          .toList(),
      indicator: CustomBoxDecoration(
        color: Colors.yellow[500],
        borderRadius: BorderRadius.circular(20.0),
        tmpHeigth: 23,
        tempTop: 0,
      ),
    );
  }
}
