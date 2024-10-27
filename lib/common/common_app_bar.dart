import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  CommonAppBar(
      {Key? key,
      this.title,
      this.searchEnabeled = false,
      this.isBackArrow = true,
      this.isCenterTitle = false,
      this.onSearchTap,
      this.onTap,
      this.titles,
      this.image,
      this.appBarColor,
      this.isEdit = false,
      this.merge = false,
      this.multiline = false,
      this.onEditTap,
        this.fontSize
      })
      : super(key: key);

  bool? searchEnabeled;
  bool? isBackArrow;
  bool? isCenterTitle;
  void Function()? onSearchTap;
  final String? title;
  bool? isEdit;
  void Function()? onEditTap;
  final void Function()? onTap;
  final Widget? titles;
  final SvgPicture? image;
  final Color? appBarColor;
  bool? merge;
  bool? multiline;
  double? fontSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      // toolbarHeight: 200,
      backgroundColor: merge! ? Color(0XFFF6F9F9) : Colors.white,
      // backgroundColor: appBarColor ?? Color(0XFFF6F9F9),
      leading: Visibility(
        visible: isBackArrow!,
        child: GestureDetector(
          onTap: onTap ??
              () {
                Navigator.pop(context, '');
              },
          child: Container(
            color: merge! ? Color(0XFFF6F9F9) : Colors.white,
            //color: appBarColor != null ? Colors.white : Color(0XFFF6F9F9),
            child: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: SvgPicture.asset(
                'assets/images/back_arrow.svg',
              ),
            ),
          ),
        ),
      ),
      centerTitle: isCenterTitle,
      leadingWidth: isBackArrow == false ? 15 : 50,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.only(top: 5,bottom: 5),
        child: titles ??
            Text(
              title!,
              textAlign: TextAlign.start,
              maxLines: 1,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize == null ? 22: fontSize,
                  ),
            ),
      ),
      actions: [
        Visibility(
          visible: searchEnabeled!,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(onTap: onSearchTap, child: image),
          ),
        ),
        Visibility(
          visible: isEdit!,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: onEditTap,
              child: const Icon(
                Icons.mode_edit_outline_outlined,
                color: Color(0XFF292D32),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}
