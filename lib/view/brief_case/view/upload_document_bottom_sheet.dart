
import 'dart:math';

import 'package:clinicaltrac/common/average_circularbar_and_card_page.dart';
import 'package:clinicaltrac/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class UploadDocumentBottomSheet extends StatefulWidget {
  const UploadDocumentBottomSheet({super.key});

  @override
  State<UploadDocumentBottomSheet> createState() => _UploadState();
}

class _UploadState extends State<UploadDocumentBottomSheet> {

  @override
  Widget build(BuildContext context) {
     return Container(
      height: globalHeight * 0.65,
      child: Padding(
        padding: EdgeInsets.only(top: globalHeight*0.03),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.start,
          crossAxisAlignment:
          CrossAxisAlignment.center,
          children: [
            Padding(
              padding:
              const EdgeInsets.only(
                  top: 10,
                  left: 10,bottom: 15),
              child: Text(
                "Uploading document",
                style:
                Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(
                  fontWeight:
                  FontWeight
                      .w600,
                  fontSize:
                  21,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: globalWidth/1.5,
                height: globalHeight/3.7,
                decoration: BoxDecoration(
                  color: Color(0xffE5F4ED).withOpacity(0.6), // Set the yellow color
                  shape: BoxShape.circle, // Set the shape as a circle
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height*0.04,
                          bottom: MediaQuery.of(context).size.height*0.01,
                          right:MediaQuery.of(context).size.width*0.02 ),
                      child: CircularPercentIndicator(
                        addAutomaticKeepAlive: true,
                        linearGradient:  LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          tileMode: TileMode.clamp,
                          stops:[0.5,1.0],
                          colors: <Color>[
                            Colors.transparent,
                            Color(0xFF01A750
                            ),

                          ],
                        ),
                        startAngle: 0,
                        animation: true ,
                        radius: 80.0,
                        percent: 0.6,
                        lineWidth: 7,
                        backgroundWidth: 0,
                        backgroundColor: Colors.transparent,
                        fillColor: Colors.transparent,

                        center: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Container(
                            child: Center(
                              child: Text(
                                "45%",style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF000000),
                                fontFamily: 'Poppins',
                                fontSize: 25,
                              )
                              ),
                            ),
                          width: globalWidth/4.5,
                          height: globalHeight/6.7,// Set the desired height of the circle
                          decoration: BoxDecoration(
                            color: Colors.white, // Set the yellow color
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3), // Shadow color.
                                offset: Offset(0, 0.2), // Shadow offset.
                                blurRadius: 6, // Shadow blur radius.
                                spreadRadius: 0.3, // Shadow spread radius.
                              ),
                            ],// Set the shape as a circle
                          ),
                        ),
                           SizedBox.shrink()
                          ],

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 5,
                  left: 13,
                  right: 5,bottom: 10),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 40),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0,top: 8),
                      child: SvgPicture.asset('assets/file_icon_pdf_'+(((0)%6)+1).toString()+'.svg',height: globalHeight*0.06,width: globalWidth*0.12,),
                    ),
                    Text(
                      "CT3 Student v7 - User Guide",
                      maxLines: 4,
                      overflow:
                      TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF000000),
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
  InkWell(
    onTap: () async {

    },
    child: Padding(
                padding: EdgeInsets.only(
                    top: 10,
                    left: globalWidth * 0.05,
                    right: globalWidth * 0.05,
                    bottom: 10),
                child: Container(

                  decoration: BoxDecoration(
                    color:Color(0xFFFF746A) ,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xFFFF746A),
                    ),
                  ),
                  child: SizedBox(
                    width: globalWidth/2,
                    height: globalHeight/11,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          "Cancel",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color:  Color(0xFFFFFFFF)),
                        ),
                        SizedBox(
                          width: globalWidth * 0.01,
                        ),

                      ],
                    ),
                  ),
                ),
              ),
  ),
          ],
        ),
      ),
    );
  }


}
