import 'package:flutter/material.dart';

class NumberPanel extends StatelessWidget {
  NumberPanel({
    Key? key,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  }) : super(key: key);

  // final CreatePinBloc createPinBloc;
  final Function onPressed;
  Color backgroundColor;
  Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              NumberButton(
                textColor: textColor,
                backgroundColor: backgroundColor,
                number: "1",
                onPressed: (value) {
                  onPressed(value);
                },
              ),
              NumberButton(
                textColor: textColor,
                backgroundColor: backgroundColor,
                number: "2",
                onPressed: (value) {
                  onPressed(value);
                },
              ),
              NumberButton(
                textColor: textColor,
                backgroundColor: backgroundColor,
                number: "3",
                onPressed: (value) {
                  onPressed(value);
                },
              ),
            ],
          ),
          Row(
            children: [
              NumberButton(
                textColor: textColor,
                backgroundColor: backgroundColor,
                number: "4",
                onPressed: (value) {
                  onPressed(value);
                },
              ),
              NumberButton(
                textColor: textColor,
                backgroundColor: backgroundColor,
                number: "5",
                onPressed: (value) {
                  onPressed(value);
                },
              ),
              NumberButton(
                textColor: textColor,
                backgroundColor: backgroundColor,
                number: "6",
                onPressed: (value) {
                  onPressed(value);
                },
              ),
            ],
          ),
          Row(
            children: [
              NumberButton(
                textColor: textColor,
                backgroundColor: backgroundColor,
                number: "7",
                onPressed: (value) {
                  onPressed(value);
                },
              ),
              NumberButton(
                textColor: textColor,
                backgroundColor: backgroundColor,
                number: "8",
                onPressed: (value) {
                  onPressed(value);
                },
              ),
              NumberButton(
                textColor: textColor,
                backgroundColor: backgroundColor,
                number: "9",
                onPressed: (value) {
                  onPressed(value);
                },
              ),
            ],
          ),
          Row(
            children: [
              NumberButton(
                textColor: textColor,
                backgroundColor: backgroundColor,
                number: "*",
                icon: Icon(Icons.fingerprint_rounded, color: textColor),
                onPressed: (value) {
                  onPressed(value);
                },
              ),
              NumberButton(
                textColor: textColor,
                backgroundColor: backgroundColor,
                number: "0",
                onPressed: (value) {
                  onPressed(value);
                },
              ),
              IconNumberButton(
                // backgroundColor: backgroundColor,
                iconColor: textColor,
                onPressed: () {
                  onPressed('-');
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  NumberButton({
    Key? key,
    required this.number,
    required this.onPressed,
    this.icon,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  }) : super(key: key);
  String number;
  Function onPressed;
  Color backgroundColor;
  Color textColor;
  Icon? icon;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: backgroundColor,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              onPressed(number);
            },
            child: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: icon != null
                    ? icon
                    : Text(
                        number,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: textColor),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class IconNumberButton extends StatelessWidget {
  IconNumberButton({Key? key, required this.onPressed, this.iconColor = Colors.black}) : super(key: key);
  Color iconColor;
  Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Icon(
            Icons.backspace_outlined,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
