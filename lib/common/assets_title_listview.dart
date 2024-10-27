import 'package:clinicaltrac/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SignoffCardListViewChild {
  String assetsUrl;
  String title;
  void Function()? onTap;
  SignoffCardListViewChild(
      {required this.title, required this.assetsUrl,required this.onTap});
}

class SignoffCardListView extends StatelessWidget {
  SignoffCardListView({super.key, required this.children});

  List<SignoffCardListViewChild> children;

  @override
  Widget build(BuildContext context) {
    return SignoffCardListViewFunction(children);
  }

  Widget SignoffCardListViewFunction(List<SignoffCardListViewChild> children) {

    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemBuilder: (context, index) {

          return Column(
            children: [
              index == 0? SizedBox(height: globalHeight*0.02,):SizedBox.shrink(),
              Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 25, right: 25),
                          child: GestureDetector(
                            onTap: children[index].onTap,
                            child: Material(
                              elevation: 5,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                child: Container(
                                  width: globalWidth*0.77,
                                  child: Row(children: [
                                    SvgPicture.asset(
                                      children[index].assetsUrl,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        children[index].title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      'assets/images/arrow_frwd.svg',
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
            ],
          );
        },
        shrinkWrap: true,
        itemCount: children.length,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
