import 'package:clinicaltrac/clinician/common_widgets/common_dropdown_widget.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


/// This is search text field class.
class AppTextField extends StatefulWidget {
  final DropDown dropDown;
  final Function(String) onTextChanged;

  // [searchHintText] is use to show the hint text into the search widget.
  /// by default it is [Search] text.
  final String? searchHintText;

  const AppTextField({
    required this.dropDown,
    required this.onTextChanged,
    this.searchHintText,
    Key? key,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: _editingController,
        cursorColor: Colors.black,
        onChanged: (value) {
          widget.onTextChanged(value);
        },
        decoration: InputDecoration(
          filled: true,
          fillColor:Color(Hardcoded.textFieldBgDisabled),
          contentPadding:
          const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 15),
          hintText: widget.searchHintText,
          hintStyle: Theme.of(context).textTheme.headline6?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: widget.searchHintText !="Search" ? Colors.black:Color(Hardcoded.greyText)
        ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(11.0),
            child: SvgPicture.asset(
              'assets/images/search.svg',
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              widget.onTextChanged("");
              _editingController.clear();
            },
            child: const Icon(
              Icons.clear_rounded,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

}
