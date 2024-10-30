import 'dart:developer';

import 'package:clinicaltrac/common/expansion_widget.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// [ExpansionWidget] is a custom Expansion tile card created for faq section due to its uniqueness in design
class ExpansionWidget<T> extends StatefulWidget {
  /// Constructor for [ExpansionWidget]
  ExpansionWidget({
    Key? key,
    this.bodyList,
    // required this.child,
    this.trailIcon,
    this.OnSelection,
    required this.hintText,
    this.inputText,
    this.textColor,
    this.enabled = true,
    this.isReset = false,
    this.decoration,
    this.isSearch = false,
    this.isSubString = false,
    this.onSearchTap,
    this.image,
    this.searchWidget,
    required this.items,
    this.onChange,
    // this.onTap,

    ///this.leadingImage = false,
    //required this.leadingImagePath,
  }) : super(key: key);

  // /// Leading Image to be displayed or hidden?
  // final bool leadingImage;

  /// [body] would act as a description
  /// kept body as a separate widget because of different design than the expansion tile
  final List<String>? bodyList;
  final bool? enabled;
  final bool? isReset;
  final bool? isSearch;
  final bool? isSubString;

  // final Widget child;
  void Function()? onSearchTap;
  final SvgPicture? image;
  final Widget? searchWidget;
  final void Function(T)? onChange;

  // final Function(dynamic t)? onTap;

  /// In [trailIcon] two strings would be passed for representing two different icons.
  /// 0 index represents when tile is not opened and 1 index for when tile is opened.
  /// it is compulsory to pass both icons in this [trailIcon] variable
  final String? trailIcon;

  final ValueChanged<dynamic>? OnSelection;
  final String hintText;
  final String? inputText;
  final Color? textColor;
  final Decoration? decoration;
  final List<DropdownItem<T>> items;

  /// Leading Image Path
  // String leadingImagePath;

  @override
  _ExpansionWidgetState createState() => _ExpansionWidgetState();
}

class _ExpansionWidgetState extends State<ExpansionWidget> {
  /// [initialExpandState] will keep track if the user has pressed on the expansion tile or not
  //bool expand = true;

  String selectedValue = '';
  int _currentIndex = -1;
  bool initialExpandState = false;
  List<Widget> removeAll =[];

  final GlobalKey<ExpansionTileCardState> expansionTile = GlobalKey();

  ScrollController _customController = ScrollController();

  @override
  void initState() {
    selectedValue = widget.hintText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: widget.decoration,
      // BoxDecoration(
      //   color: Color(Hardcoded.textFieldBg),
      //   borderRadius: BorderRadius.circular(30),
      //   // border: Border.all(color: Colors.transparent),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black12,
      //       offset: const Offset(
      //         0.0,
      //         5.0,
      //       ),
      //       blurRadius: 7.0,
      //       spreadRadius: 2.0,
      //     ),
      //   ],
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.inputText == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(left: 3, bottom: 3),
                  child: Text(
                    "${widget.inputText}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                  ),
                ),
          ExpansionTileCard(
            key: expansionTile,
            enabled: widget.enabled,
            baseColor: widget.enabled!
                ? Color(Hardcoded.textFieldBg)
                : Color(Hardcoded.textFieldBgDisabled),
            expandedColor: Color(Hardcoded.white),
            initialElevation: 0,
            trailing: Icon(
              // Icons.keyboard_arrow_down_rounded,
              initialExpandState == false
                  ? Icons.keyboard_arrow_down_rounded
                  : Icons.keyboard_arrow_up_rounded,
              size: 30,
              color: widget.enabled!
                  ? Color(Hardcoded.greyText)
                  : Color(Hardcoded.textFieldBgDisabled),
            ),
            contentPadding: const EdgeInsets.only(
              left: 20,
              right: 10,
            ),
            borderRadius: BorderRadius.circular(12),
            finalPadding: EdgeInsets.zero,
            animateTrailing: true,
            initiallyExpanded: initialExpandState,
            onExpansionChanged: (bool value) {
              setState(() {
                initialExpandState = value;
              });
            },
            title: Text(
                widget.isReset == false
                    ? selectedValue
                    : widget.items.elementAt(0).value,
                // widget.hintText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: widget.textColor
                    // Color(Hardcoded.greyText)
                    )),
            //    subtitle:  widget.isSearch! == true && initialExpandState == true ? Visibility(
            //       visible: initialExpandState,
            //       child:
            //
            //         Padding(
            //             padding: EdgeInsets.only(
            //               top: 5,
            //             ),
            //             // child: TextFormField(
            //             //   initialValue: "search",
            //             // )
            //             child: widget.searchWidget
            //         ),
            //
            // ): null,
            children: <Widget>[
              widget.isSearch! == true && initialExpandState == true
                  ? Visibility(
                      visible: initialExpandState,
                      child: Padding(
                          padding: EdgeInsets.only(left: 2.0, right: 2.0),
                          // child: TextFormField(
                          //   initialValue: "search",
                          // )
                          child: widget.searchWidget),
                    )
                  : Container(),
              // Children list for expansion
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ), //circular(20.0),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 0.8,
                    right: 0.8,
                  ),
                  child: Container(
                    height: widget.items.isNotEmpty
                        ? widget.items.length == 1
                            ? 53
                            : widget.items.length == 2
                                ? 95
                                : widget.items.length == 3
                                    ? 150
                                    : 200
                        : 45,
                    // height: widget.bodyList.length == 1 ? 58:widget.bodyList.length == 2 ? 128 : 200,
                    // color: Colors.white,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: const Offset(
                              0.0,
                              5.0,
                            ),
                            blurRadius: 7.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                        border: Border(
                          left: BorderSide(
                            color: Color(Hardcoded.textFieldBg),
                            // width: 2.0,
                          ),
                          right: BorderSide(
                            color: Color(Hardcoded.textFieldBg),
                            // width: 2.0,
                          ),
                        )),
                    child: Scrollbar(
                      // backgroundColor: Colors.red,
                      controller: _customController,
                      // child: ListView.builder(
                      //   controller: _customController,
                      //   itemCount: widget.items.length,
                      //   itemBuilder: (context, index) => Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.only(
                      //         bottomLeft: index == widget.items.length - 1
                      //             ? const Radius.circular(12)
                      //             : Radius.zero,
                      //         bottomRight: index == widget.items.length - 1
                      //             ? const Radius.circular(12)
                      //             : Radius.zero,
                      //       ),
                      //     ),
                      child: widget.items.isNotEmpty
                          ? ListView.builder(
                              itemCount: widget.items.length,
                              itemBuilder: (BuildContext context, index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      // onTap: widget.onTap(widget.items.elementAt(item.key).),
                                      onTap: () {
                                        expansionTile.currentState!.collapse();
                                        setState(() {
                                          initialExpandState = !initialExpandState;
                                          // _currentIndex = item;
                                          if (initialExpandState) {
                                            initialExpandState = false;
                                          } else {
                                            initialExpandState = true;
                                          }
                                        });
                                        dynamic c = widget.items[index].value;
                                        selectedValue = c.title.toString();
                                        // widget.onChange!(item.value.value );
                                        widget.OnSelection!(c);
                                        // _toggleDropdown();
                                      },
                                      child: Container(
                                        color: Colors.white,
                                        width: globalWidth * 0.9,
                                        child: widget.items[index].child,
                                      ),
                                    ),
                                    if (index != widget.items.length - 1)
                                      Divider()
                                  ],
                                );
                              })
                          : Container(
                              width: globalWidth * 0.9,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 8.0,
                                    left: globalWidth * 0.06,
                                    right: globalWidth * 0.06,
                                    bottom: 8.0),
                                child: Text("No data found",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Colors.black,
                                        )),
                              )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // @override
  // void setState(VoidCallback fn) {
  //   // TODO: implement setState
  //   super.setState(fn);
  //   selectedValue=widget.hintText;
  // }
}

class DropdownItem<T> extends StatelessWidget {
  final T? value;
  final Widget? child;

  const DropdownItem({Key? key, this.value, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child!;
  }
}
