import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> interestsList;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.interestsList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];

  _buildChoiceList(Size layoutSize) {
    List<Widget> choices = [];

    widget.interestsList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(3.0),
        child: ChoiceChip(
          label: Text(item),
          backgroundColor: AppColors.lightGrey3,
          selectedColor: AppColors.lightPurple,
          labelStyle: selectedChoices.contains(item)
              ? Theme.of(context).primaryTextTheme.headline2.copyWith(
                    fontSize: layoutSize.width * 0.035,
                  )
              : Theme.of(context).primaryTextTheme.caption.copyWith(
                    fontSize: layoutSize.width * 0.035,
                  ),
          padding: EdgeInsets.only(right: 10, left: 10, top: 2, bottom: 2),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Wrap(
      children: _buildChoiceList(layoutSize),
    );
  }
}
