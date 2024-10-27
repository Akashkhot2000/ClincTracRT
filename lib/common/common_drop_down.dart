import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/main.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CoomonDropDown extends StatefulWidget {
  CoomonDropDown(
      {super.key,
      required this.items,
      required this.title,
      this.inputText,
      required this.isEdit,
      this.selectedValue,
      required this.onChanged,
      required this.width});

  final List<String> items;
  final String title;
  final String? inputText;
  final bool isEdit;
  String? selectedValue;
  final void Function(String?) onChanged;
  final double width;

  @override
  State<CoomonDropDown> createState() => _CoomonDropDownState();
}

class _CoomonDropDownState extends State<CoomonDropDown> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.inputText != null ? Text(
          "${widget.inputText}",
          overflow: TextOverflow.visible,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: Color(Hardcoded.textColor),
            overflow: TextOverflow.ellipsis,
          ),
        ): Container(),
          SizedBox(
            height: 3,
          ),
        DropdownButton2(
          disabledHint: Row(
            children: [
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4F625F),
                  ),
                ),
              ),
            ],
          ),
          isExpanded: true,
          onMenuStateChange: (value) {
            setState(() {
              isOpen = value;
            });
          },
          hint: Row(
            children: [
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 14,
                    // color: Color(0xFF4F625F),
                  ),
                ),
              ),
            ],
          ),
          items: widget.items
              .map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ))
              .toList(),
          value: widget.selectedValue ?? '',
          onChanged: widget.isEdit ? widget.onChanged : null,
          buttonStyleData: ButtonStyleData(
            height: 50,
            padding: const EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: isOpen ? Radius.zero : Radius.circular(12),
                  bottomRight: isOpen ? Radius.zero : Radius.circular(12)),
              color: Color(Hardcoded.textFieldBg),
                // color: Colors.orange
            ),
            elevation: 0,
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down,
            ),
            iconSize: 24,
            iconEnabledColor: Colors.black,
            iconDisabledColor: Color(Hardcoded.primaryGreen),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: widget.width,
            padding: EdgeInsets.all(00),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
              color: Color(Hardcoded.textFieldBg),
            ),
            elevation: 0,
            offset: const Offset(-0, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ],)
    );
  }
}
