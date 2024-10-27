import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AverageCircularBarAndCardPage extends StatefulWidget {
  int? progressValue =1;
  int? startProgressValue =0;
  int? stopProgressValue =100;
  Widget? circleTitleWidget=null;
  Widget? circleSubtitleWidget=null;
  String? cardTitleWidget=null;
  String? cardSubtitleWidget=null;
  List<Color>? circleColorList = null;
  List<double>? circleColorStopList=null;

  AverageCircularBarAndCardPage({ Key? key, this.progressValue=1,this.stopProgressValue=100,this.startProgressValue=0,this.circleTitleWidget,this.circleSubtitleWidget,this.cardTitleWidget="Card Title",this.cardSubtitleWidget="Card Subtitle",this.circleColorList,this.circleColorStopList}) :super(key: key) {
  if (circleColorList != null && circleColorStopList == null || circleColorList == null && circleColorStopList != null) {
  throw ArgumentError(
  'provide both circleColorList and circleColorStopList');
  }

  }
  @override
  _AverageCircularBarAndCardPageState createState() => _AverageCircularBarAndCardPageState();
}

class _AverageCircularBarAndCardPageState extends State<AverageCircularBarAndCardPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child : Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding:  EdgeInsets.only(top:  MediaQuery.of(context).size.height*0.05),
              child: Material(
                color: Colors.transparent  ,
                child: ListTile(
                  title: SizedBox(child: Text(widget.cardTitleWidget!,style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0))),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0,right: 14),
                    child: Text(widget.cardSubtitleWidget!,style:  TextStyle(fontWeight: FontWeight.w600, fontSize: 12.0),maxLines: 3,),
                  ),
                ),
              ),
            ),
          ),
          Stack(
              children: [
                Positioned(child: Text(widget.startProgressValue.toString(),style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.0,color:Color(0xFFF06768) ),),top: MediaQuery.of(context).size.height*0.165,left: MediaQuery.of(context).size.width/26.1,),
                Positioned(child: Text(widget.stopProgressValue.toString(),style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.0,color:Color(0xFF01A750))),top: MediaQuery.of(context).size.height*0.165,left: MediaQuery.of(context).size.width/3.70),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02,bottom: MediaQuery.of(context).size.height*0.01,right:MediaQuery.of(context).size.width*0.04 ),
                      child: CircularPercentIndicator(
                        linearGradient:  LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          tileMode: TileMode.clamp,
                          stops: widget.circleColorStopList??[0.4, 1.0],
                          colors:widget.circleColorList?? <Color>[
                            Color(0xFFF06768),
                            Color(0xFF01A750
                            ),

                          ],
                        ),
                        startAngle: 0,
                        animation: true ,
                        radius: 60.0,
                        percent: widget.progressValue!/widget.stopProgressValue!,
                        lineWidth: 7,
                        backgroundWidth: 15,
                        fillColor: Colors.transparent,
                        circularStrokeCap: CircularStrokeCap.round,
                        arcBackgroundColor: Color(0xFFE4EEEE),
                        arcType: ArcType.FULL,
                        center: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           widget.circleTitleWidget?? Text(
                              widget.progressValue.toString(),
                              style:
                              TextStyle(fontWeight: FontWeight.w700, fontSize: 28.0),
                            ),
                             widget.circleSubtitleWidget??SizedBox.shrink()
                          ],

                        ),
                      ),
                    ),
                  ],
                ),
              ]
          ),
        ],
      ),


    );
  }
}
