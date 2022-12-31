import 'package:Hutaf/ui/widgets/buttons/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final String title;
  final String buttonText;
  final String textButtonText;
  final Function buttonHandler;
  final Function textHandler;

  CustomDialog(
      {Key key,
      this.title,
      this.buttonText,
      this.textButtonText,
      this.buttonHandler,
      this.textHandler})
      : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: layoutSize.height * 0.03),
          Text(
            widget.title,
            textScaleFactor: 1,
            textAlign: TextAlign.start,
            style: Theme.of(context).primaryTextTheme.headline3.copyWith(
                  fontSize: layoutSize.width * 0.052,
                ),
          ),
          Button(
            text: widget.buttonText,
            buttonHeight: layoutSize.width * 0.12,
            buttonWidth: layoutSize.width,
            fontSize: layoutSize.width * 0.045,
            margin: EdgeInsets.only(
              right: layoutSize.width * 0.06,
              left: layoutSize.width * 0.06,
              top: layoutSize.height * 0.04,
              bottom: layoutSize.height * 0.02,
            ),
            handler: widget.buttonHandler,
          ),
          CupertinoButton(
            minSize: 1,
            padding: EdgeInsets.zero,
            child: Text(
              widget.textButtonText,
              textScaleFactor: 1,
              style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                    fontSize: layoutSize.width * 0.045,
                  ),
            ),
            onPressed: widget.textHandler,
          ),
        ],
      ),
    );
  }
}
