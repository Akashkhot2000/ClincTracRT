import 'package:flutter/material.dart';

enum FlexibleListViewChildDirection { leftside, rightside }

class FlexibleListViewChild {
  String title;
  String subTitle;
  FlexibleListViewChildDirection direction;

  FlexibleListViewChild(
      {required this.title, required this.subTitle, required this.direction});
}

class FlexibleListView extends StatefulWidget {
  FlexibleListView({super.key, required this.children});
  List<FlexibleListViewChild> children;
  @override
  State<FlexibleListView> createState() => _FlexibleListViewState();
}

class _FlexibleListViewState extends State<FlexibleListView> {
  @override
  Widget build(BuildContext context) {
    return FlexibleListViewFunction(widget.children);
  }

  Widget FlexibleListViewFunction(List<FlexibleListViewChild> children) {
    int leftcount = 0;
    int rightcount = 0;
    List<FlexibleListViewChild?> leftSideList = [];
    List<FlexibleListViewChild?> rightSideList = [];
    for (int i = 0; i < children.length; i++) {
      if (children[i].direction == FlexibleListViewChildDirection.leftside) {
        leftcount++;
        leftSideList.add(children[i]);
      } else {
        rightcount++;
        rightSideList.add(children[i]);
      }
    }
    int maxcount = (leftcount > rightcount) ? leftcount : rightcount;
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return
               Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            left: 4.0, right: 4.0, top: 2.0, bottom: 2.0),
                        child: leftSideList.isEmpty
                            ? SizedBox.shrink()
                            : index + 1 > leftSideList.length
                                ? SizedBox.shrink()
                                : leftSideList[index] == null
                                    ? SizedBox.shrink()
                                    : Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                2.1),
                                        child: ListTile(
                                          title: Text(
                                            leftSideList[index]!.title!,
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: Color(0xFF868998)),
                                          ),
                                          subtitle: Text(
                                            leftSideList[index]!.subTitle!,
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: Color(0xFF1A203D)),
                                          ),
                                        ))),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 4.0, right: 4.0, top: 2.0, bottom: 2.0),
                      child: rightSideList.isEmpty
                          ? SizedBox.shrink()
                          : index + 1 > rightSideList.length
                              ? SizedBox.shrink()
                              : rightSideList[index] == null
                                  ? SizedBox.shrink()
                                  : Container(
                                      width: (MediaQuery.of(context).size.width /
                                          2.3),
                                      child: ListTile(
                                        title: Text(
                                          rightSideList[index]!.title!,
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: Color(0xFF868998)),
                                        ),
                                        subtitle: Text(
                                          rightSideList[index]!.subTitle!,
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: Color(0xFF1A203D)),
                                        ),
                                      )),
                    ),
                  ],
                );
        },
        shrinkWrap: true,
        itemCount: maxcount,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
