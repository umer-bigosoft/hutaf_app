import 'package:Hutaf/ui/widgets/app_bar/app_bar_with_leading.dart';
import 'package:Hutaf/ui/widgets/others/empty_result.dart';
import 'package:flutter/material.dart';

class SpeicalNeedsCourses extends StatelessWidget {
  const SpeicalNeedsCourses({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    ///
    return Scaffold(
      appBar: AppBarWithLeading(
        title: 'مخصصات ذوي الإعاقة البصرية',
        handler: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          SizedBox(height: layoutSize.height * 0.06),
          EmptyResult(
            isSizedBox: false,
            text: 'ستتم إضافة العديد من الدورات قريبًا 😍',
          ),
        ],
      ),
    );
  }
}
