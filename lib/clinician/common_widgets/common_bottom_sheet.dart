import 'dart:developer';

import 'package:clinicaltrac/clinician/model/profile_models/user_country_list_model.dart';
import 'package:clinicaltrac/common/common_expansion_comp_widget.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';

class common_bottom_sheet<T> extends StatefulWidget {
  /// Constructor for [common_bottom_sheet]
  final String inputText;
  final String hintText;
  final TextOverflow? overflow;
  final List<BottomsheetItem<T>> listItem;
  final ValueChanged<dynamic>? OnSelection;
  final bool? isSearch;
  final Widget? searchWidget;

  common_bottom_sheet({
    Key? key,
    required this.hintText,
    required this.inputText,
    this.OnSelection,
    this.overflow,
    this.searchWidget,
    this.isSearch = false,
    required this.listItem,
  }) : super(key: key);

  @override
  _common_bottom_sheetState createState() => _common_bottom_sheetState();
}

class _common_bottom_sheetState extends State<common_bottom_sheet> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _bottomsheetcontroller = TextEditingController();
  ScrollController _customController = ScrollController();
  String selectedValue = '';
  final searchFocusNode = FocusNode();

  @override
  void initState() {
    selectedValue = widget.hintText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.inputText}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.cancel,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 14.h,
          ),
          Visibility(
            visible: widget.isSearch! == true,
            child: Padding(
                padding: EdgeInsets.only(left: 2.0, right: 2.0),
                // child: TextFormField(
                //   initialValue: "search",
                // )
                child: widget.searchWidget),
          ),
          Expanded(
            // controller: _customController,
            child: ListView.builder(
              itemCount: widget.listItem.length,
              itemBuilder: (BuildContext context, int index) {
                return
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         dynamic c = widget.listItem[index].value;
                    //         selectedValue = c.title.toString();
                    //         widget.OnSelection!(c);
                    //         Navigator.pop(context);
                    //         log(selectedValue);
                    //       },
                    //       child: Container(
                    //         color: Colors.white,
                    //         width: globalWidth * 0.9,
                    //         child: widget.listItem[index].child,
                    //       ),
                    //     )
                    //   ],
                    // );
                    ListTile(
                  title: Text(widget.listItem[index].value!.title),
                  // subtitle: Text('sample'),
                  onTap: () {
                    dynamic c = widget.listItem[index].value;
                    selectedValue = c.title.toString();
                    widget.OnSelection!(c);
                    Navigator.pop(context);
                    log(selectedValue);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
    // },
    // );
    // }
    //   sufix: Icon(
    //     Icons.keyboard_arrow_down_outlined,
    //     size: 30,
    //     color: Colors.black54,
    //   ),
    //   readOnly: true,
    //   inputText: "Country",
    //   keyboardType: TextInputType.none,
    //   autoFocus: false,
    //   hintText: 'Select Country',
    //   textEditingController: _bottomsheetcontroller,
    // );
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }
}

class BottomsheetItem<T> extends StatelessWidget {
  final T? value;
  final Widget? child;

  const BottomsheetItem({Key? key, this.value, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child!;
  }
}
