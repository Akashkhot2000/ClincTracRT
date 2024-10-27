import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/expansion_widget.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';

/// [Expansion] is a custom Expansion tile card created for faq section due to its uniqueness in design
class Expansion extends StatefulWidget {
  /// Constructor for [Expansion]
  Expansion({
    Key? key,
    required this.bodyList,
    required this.trailIcon,
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

    ///this.leadingImage = false,
    //required this.leadingImagePath,
  }) : super(key: key);

  // /// Leading Image to be displayed or hidden?
  // final bool leadingImage;

  /// [body] would act as a description
  /// kept body as a separate widget because of different design than the expansion tile
  final List<dynamic> bodyList;
  final bool? enabled;
  final bool? isReset;
  final bool? isSearch;
  final bool? isSubString;
  void Function()? onSearchTap;
  final SvgPicture? image;
  final Widget? searchWidget;

  /// In [trailIcon] two strings would be passed for representing two different icons.
  /// 0 index represents when tile is not opened and 1 index for when tile is opened.
  /// it is compulsory to pass both icons in this [trailIcon] variable
  final String trailIcon;

  final ValueChanged<String>? OnSelection;
  final String hintText;
  final String? inputText;
  final Color? textColor;
  final Decoration? decoration;

  /// Leading Image Path
  // String leadingImagePath;

  @override
  _ExpansionState createState() => _ExpansionState();
}

class _ExpansionState extends State<Expansion> {
  /// [initialExpandState] will keep track if the user has pressed on the expansion tile or not
  //bool expand = true;

  String selectedValue = '';

  bool initialExpandState = false;

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
                    : widget.bodyList.elementAt(0),
                // widget.hintText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: widget.textColor)
                // : Theme.of(context)
                //     .textTheme
                //     .titleLarge
                //     ?.copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                ),
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
                          padding: EdgeInsets.only(top: 0),
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
                child: Container(
                  height: widget.bodyList.length == 1
                      ? 58
                      : widget.bodyList.length == 2
                          ? 128
                          : 200,
                  // height: widget.bodyList.length == 1 ? 58:widget.bodyList.length == 2 ? 128 : 200,
                  child: Scrollbar(
                    // backgroundColor: Colors.red,
                    controller: _customController,
                    child: ListView.builder(
                        controller: _customController,
                        itemCount: widget.bodyList.length,
                        itemBuilder: (context, index) {
                          String text = widget.bodyList.elementAt(index);
                          List<String> title = text.split("(");
                          String subText = title[0].toString();
                          List<String> subTitle = subText.split(")");
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: index == widget.bodyList.length - 1
                                    ? const Radius.circular(12)
                                    : Radius.zero,
                                bottomRight: index == widget.bodyList.length - 1
                                    ? const Radius.circular(12)
                                    : Radius.zero,
                              ),
                            ),
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                expansionTile.currentState!.collapse();
                                setState(
                                  () {
                                    if (initialExpandState) {
                                      initialExpandState = false;
                                    } else {
                                      initialExpandState = true;
                                    }
                                    selectedValue =
                                        widget.bodyList.elementAt(index);
                                  },
                                );
                                widget.OnSelection!(
                                    widget.bodyList.elementAt(index));
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      widget.isSubString == true
                                          ? title[0]
                                          : widget.bodyList.elementAt(index),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    subtitle: widget.isSubString == true
                                        ? Text(
                                            subTitle[0],
                                            // widget.hintText,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: Color(
                                                        Hardcoded.greyText)),
                                          )
                                        : null,
                                  ),
                                  if (index != widget.bodyList.length - 1)
                                    const Divider()
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
