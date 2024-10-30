import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:flutter/material.dart';

/// Customized Toggle button to give approvals
/// Can be accessed only by PARENTS
class ToggleButton extends StatefulWidget {
  /// Constructor
  const ToggleButton({
    Key? key,
    required this.values,
    required this.onToggleCallback,
    required this.initialPosition,
  }) : super(key: key);

  /// Value for the toggle button[YES, NO]
  final List<String> values;

  /// Functionality when yes or no
  final ValueChanged onToggleCallback;

  /// to prefill yes or no
  final bool initialPosition;

  @override
  _WhatsAppToggleButtonState createState() => _WhatsAppToggleButtonState();
}

class _WhatsAppToggleButtonState extends State<ToggleButton> {
  bool initialPosition = false;
  @override
  void initState() {
    initialPosition = widget.initialPosition;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // AppHelper.log('initialPosition at toggle button $initialPosition');
    // initialPosition = widget.initialPosition;
    // AppHelper.log('widget.initialPosition at toggle button ${widget.initialPosition}',);

    return GestureDetector(
      onTap: () {
        int index = 1;
        if (!initialPosition) {
          index = 0;
        }

        widget.onToggleCallback(index);

        setState(() {
          initialPosition = !initialPosition;
          // AppHelper.log('initialPosition at toggle button $initialPosition',);
          //whatsapp_opt_status = WHATSAPP_OPT_STATUS.inprogress;
        });
      },
      child: Stack(
        children: <Widget>[
          Container(
            width: 100, // height as provide by the UI
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Theme.of(context).primaryColor,
            ),

            // Set the Values
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List<Widget>.generate(
                widget.values.length,
                (int index) => Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    widget.values[index],
                    style: Theme.of(context).textTheme.overline!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: initialPosition
                              ? Color(Hardcoded.white)
                              : Color(Hardcoded.hintColor),
                        ),
                  ),
                ),
              ),
            ),
          ),

          // Toggle Button
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment:
                initialPosition ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                width: 40, // Height and width as given in UI
                height:
                    30, // Needs to specify this else it captures the entire Outer Container
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Color(Hardcoded.white),
                ),
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
