import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/redux/action/homeactions/get_active_rotation_list_action.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpcomingCarousalContainer extends StatefulWidget {
  const UpcomingCarousalContainer({Key? key}) : super(key: key);

  @override
  State<UpcomingCarousalContainer> createState() =>
      _UpcomingCarousalContainerState();
}

class _UpcomingCarousalContainerState extends State<UpcomingCarousalContainer> {
  String status = 'Clock In';

  @override
  void initState() {
    store.dispatch(GetStudActiveRotationsListAction());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            // flex: 2,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Color(Hardcoded.white),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '14',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'JAN',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  ),
                  Expanded(
                    // flex: 5,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lorem Ipsum is simply dddd dummy text',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '01:00 - 02:30',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                color: Colors.black54),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(children: [
                            Text(
                              'Hospital site: ',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: Colors.black54
                              ),
                            ),
                            Text(
                              'DR. Vaibhav',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                          ],)

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          // Expanded(child:
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Color(Hardcoded.white),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Text(
                  status,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                FlipCard(
                  flipOnTouch: true,
                  onFlip: () {
                    setState(() {
                      if (status == "Clock In") {
                        status = "Clock Out";
                      } else {
                        status = "Clock In";
                      }
                    });
                  },
                  front: SvgPicture.asset('assets/images/clock_in.svg'),
                  back: SvgPicture.asset('assets/images/clock_out.svg'),
                ),
              ],
            ),
            // )
          )
        ]);
  }
}

//
// class UpcomingCarousalContainer extends StatelessWidget {
//   const UpcomingCarousalContainer({super.key});
//   String status = 'Clock In';
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//           color: Color(Hardcoded.white),
//           borderRadius: BorderRadius.circular(20)),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   '14',
//                   textAlign: TextAlign.start,
//                   style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 19,
//                       ),
//                 ),
//                 Text(
//                   'JAN',
//                   textAlign: TextAlign.start,
//                   style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                         fontWeight: FontWeight.w400,
//                         fontSize: 10,
//                       ),
//                 ),
//                 const SizedBox(
//                   height: 50,
//                 )
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 4,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Lorem Ipsum is simply dummy text',
//                   textAlign: TextAlign.start,
//                   style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 12,
//                       ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   '01:00 - 02:30',
//                   textAlign: TextAlign.start,
//                   style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 9,
//                       color: Colors.black54),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Text(
//                   'DR. Vaibhav',
//                   textAlign: TextAlign.start,
//                   style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 9,
//                       ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                     color: Color(Hardcoded.white),
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Column(
//                   children: [
//                     Text(
//                       status,
//                       textAlign: TextAlign.start,
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleLarge!
//                           .copyWith(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 13,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     FlipCard(
//                       flipOnTouch: true,
//                       onFlip: () {
//                         setState(() {
//                           if (status == "Clock In") {
//                             status = "Clock Out";
//                           } else {
//                             status = "Clock In";
//                           }
//                         });
//                       },
//                       front: SvgPicture.asset(
//                           'assets/images/clock_in.svg'),
//                       back: SvgPicture.asset(
//                           'assets/images/clock_out.svg'),
//                     ),
//                   ],
//                 ),
//               ))
//         ],
//       ),
//     );
//   }
// }
