import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/main.dart';
import 'package:flutter/material.dart';

class common_green_rotation_card extends StatelessWidget {
  const common_green_rotation_card({
    super.key,
    required this.Index,
    required this.date,
    required this.month,
    required this.text1,
    required this.text2,
    required this.text3,
  });

  final int Index;
  final String date;
  final String month;
  final String text1;
  final String text2;
  final String text3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color:  Colors.white,
          // color: Color(0x1413AD5D),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Color(Hardcoded.primaryGreen)),
          boxShadow: [
            BoxShadow(
                blurRadius: 8,
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                offset: const Offset(0, 3))
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: globalHeight * 0.076,
                width: globalWidth * 0.12,
                decoration: BoxDecoration(
                    color: Color(Hardcoded.primaryGreen),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${date}",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Color(Hardcoded.white),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                        ),
                        Text(
                          "${month}",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Color(Hardcoded.white),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                        ),
                      ],
                    )),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$text1",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Text(
                      '$text2',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      '$text3',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                            color: Color(0xFF868998),
                          ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
