import 'package:flutter/material.dart';
class ScoringCriteriaListData{
  String? key;
  String? value;
  ScoringCriteriaListData({required this.key,required this.value});
}
class ScoringCriteriaList extends StatefulWidget {
  String title;
  List<ScoringCriteriaListData> children ;
  ScoringCriteriaList({required this.children, required this.title});
  @override
  _ScoringCriteriaListState createState() => _ScoringCriteriaListState();
}

class _ScoringCriteriaListState extends State<ScoringCriteriaList> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      color: Colors.white,
      child :widget.children.isEmpty?
      Center(
        child: Text("No Record"),
      ):
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.only(left: 16.0,top: 0),
            child: Text(widget.title,style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A203D),
              fontFamily: 'Poppins',
              fontSize: 16,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.children.length,
              itemBuilder: (context, index) {
                return keyValueWidget(widget.children[index]);
              },
            ),
          ),
        ],
      )


    );
  }

  Widget keyValueWidget(ScoringCriteriaListData criteriaListData) {
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 6),
       child: Row(
          children: [
            Text(criteriaListData.key!,style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF000000),
              fontFamily: 'Poppins',
              fontSize: 12,
            )),
            Text(criteriaListData.value!,style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF868998),
              fontFamily: 'Poppins',
              fontSize: 12,
            )),
          ],
       ),
     );
  }
}
