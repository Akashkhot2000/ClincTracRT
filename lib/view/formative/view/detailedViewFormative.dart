import 'dart:developer';

import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/view/formative/models/formative_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QA {
  String? question;
  String? answer;
  QA({this.question, this.answer});
}

class DetailedViewFormative extends StatefulWidget {
  final FormativeEvaluationdetails details;
  final String type;

  DetailedViewFormative({required this.details, required this.type});

  @override
  State<DetailedViewFormative> createState() => _DetailedViewFormativeState();
}

class _DetailedViewFormativeState extends State<DetailedViewFormative> {
  @override
  void initState() {
    setValue();
    super.initState();
  }

  List<QA> list = [];
  void setValue() {
    list = [];

    if (widget.type == 'effectiveness') {
      for (var item in widget.details.data!.formativeSections.last.questions) {
        QA question = QA(question: item['QuestionTitle'] ?? '-', answer: item['QuestionAnswer'] ?? '-');
        list.add(question);
      }
    } else {
      for (var item in widget.details.data!.formativeSections.first.questions) {
        QA question = QA(question: item['QuestionTitle'] ?? '-', answer: item['QuestionAnswer'] ?? '-');
        list.add(question);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 100,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, '');
            },
            child: Container(
              color: Color(0XFFF6F9F9),
              //color: appBarColor != null ? Colors.white : Color(0XFFF6F9F9),
              child: Padding(
                padding: EdgeInsets.only(top: 25, bottom: 55),
                child: SvgPicture.asset(
                  'assets/images/back_arrow.svg',
                ),
              ),
            ),
          ),
          backgroundColor: Color(0XFFF6F9F9),
          titleSpacing: 0,
          title: Text(
            widget.type != 'effectiveness' ? "Formative Evaluation During\nClinical Rotations" : "Student Effectiveness During\nClinical Rotations",
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
          ),
        ),
        body: ListView.separated(
          itemCount: list.length,
          separatorBuilder: (BuildContext context, int index) => Divider(
            thickness: 1,
            height: 0,
          ),
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
            child: Container(
              child: Visibility(
                visible: widget.type != 'effectiveness',
                replacement: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list[index].question!,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      list[index].answer!,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Color(0XFFF6F9F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          (index + 1).toString().length == 1 ? "0${index + 1}" : "${index + 1}",
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Color(0XFF868998),
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            list[index].question!,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/greenTick.svg',
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                list[index].answer!,
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      color: Color(Hardcoded.primaryGreen),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DetailedViewFormativeRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  DetailedViewFormativeRoutingData({
    this.evulation,
    this.type,
  });

  /// to load a particular page at initial time
  final FormativeEvaluationdetails? evulation;
  final String? type;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
    DetailedViewFormativeRoutingData data,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => DetailedViewFormative(
        details: data.evulation!,
        type: data.type!,
      ),
    );
  }
}
