import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_with_leading.dart';

class AboutHutaf extends StatelessWidget {
  const AboutHutaf({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBarWithLeading(
        title: 'about_hutaf.about_hutaf_title'.tr(),
        handler: () {
          Navigator.pop(context);
        },
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: layoutSize.height * 0.03,
          right: layoutSize.width * 0.035,
          left: layoutSize.width * 0.035,
          bottom: layoutSize.height * 0.03,
        ),
        children: [
          title('المقدمة |\n', layoutSize, context),
          text(
            'هُتاف تطبيق يهدف لنشر ثقافة القراءة واِكساب المستخدمين مهارات مختلفة مكتسبة من تنوع الكتب والبرامج التثقيفية الموجودة بداخلة. يتضمن تطبيق هُتاف عدد كبير من المنتجات الأدبية الثقافية والتعليمية لذلك ينقسم تطبيق هُتاف إلى شقَّين أساسيين فهو يضم نوعين من الإنتاج الثقافي الأدبي فالشق الأول عبارة عن مكتبة شاملة للكتب الصوتية والثاني بذوي الإعاقة السمعية.\n\n',
            layoutSize,
            context,
          ),
          title('هُتاف |\n', layoutSize, context),
          text(
            'يحتوى على مكتبة صوتية كبيرة مكوّنة من آلاف الكتب المختلفة بأصنافها المتفرعة، يقوم طاقم فريق هُتاف بإنتاجها بالتعاون مع الكُتّاب العرب أو المترجمين لكتب غربية حيث ان جميع الكتب هي كتب وجب شرعًا اكتساب حقها القانوني للنشر داخل التطبيق، يقوم الفريق بتسجيل الكتاب وتحويله لكتاب مسموع بطريقة سينمائية روائية ممتعة وستكون حصرية داخل تطبيق هُتاف. سنوفر في هُتاف الكثير من الكتب المختلفة بشتى أنواعها كـ الروايات، القصص والكتب التعليمية وكتب لتحفيز الذات وتطوير الفكر وغيرها الكثير. كذلك هناك جانب مخصصات لذوي الإعاقة السمعية حيث نقوم بالتعاون مع مؤهلين وذوي خبرة وكفاءة عالية في تقديم المحتوى التدريبي التعليمي والبرامج والقصص لذوي الإعاقة السمعية، سنحرص على توفير كل ما يحتاج إليه أصدقاؤنا ذوي الإعاقة السمعية. \n\n',
            layoutSize,
            context,
          ),
          title('توجّه |\n', layoutSize, context),
          text(
            'هُتاف الأول من نوعه في سلطنة عمان، وهو التطبيق الأول الذي يتبنى ويرعى المحتوى الأدبي العربي بشتى ضروبه وهو ايضًا التطبيق الأفضل الذي يهتم بتعليم وتدريب وتقديم محتوى ثقافي أدبي تعليمي لذوي الإعاقة السمعية، واذا تعمقنا بتفاصيله الإنتاجية فهو يختلف اختلاف كبير عن باقي المشاريع المشابهة له، هو تطبيق متفرّد ومختلف في الوطن العربي بأكمله، هُتاف له وجهة أدبية تعليمية مختلفة وهدف اجتماعي عميق غير مسبوق. \n\n',
            layoutSize,
            context,
          ),
          title('أهداف واضحة |\n', layoutSize, context),
          text(
            'رحلة الألف ميل تبدأ بخطوة .. سيساعدك هُتاف في أن تخطوها. وسيكون وسيلتك لقياس تقدمك في رحلة القراءة والتعليم عبر آلية المتابعة وإرسال الإشعارات.\nوسيساعد هُتاف جميع عشاق القراءة والتعليم في تحديد وتحقيق الأهداف المرجوة والمراد الوصول إليها. \n\n',
            layoutSize,
            context,
          ),
          title('لماذا هُتاف |\n', layoutSize, context),
          text(
            'لأن التنمية والتطور يولد من رحم التعليم المستمر والاكتساب الدائم للمعرفة. لهذا قررنا ان نجعل هُتاف بيئة خصبة مملوءة بالكتب والمعرفة، هُتاف فرصة رائعة للتعّلم وإكتساب الثقافة في كل زمان ومكان. \n\n',
            layoutSize,
            context,
          ),
          title('ختاماً |\n', layoutSize, context),
          text(
            'كوننا تطبيق عربي إسلامي فمن الواجب، \n أن نتقيد ببعض المحدودية التي تضمن حق الفرد والمجتمعات العربية هناك بعض الشروط التي يجب التقيد بها والتي تستطيع قراءتها بتمعّن في صفحة الشروط والأحكام. \n\n ــــــــ \n\n',
            layoutSize,
            context,
          ),
          text(
            'للاستفسار أو الإبلاغ عن أي مشكلة نرجو التواصل عبر البريد الإلكتروني الموضح أدناه، \n كما نرجو لكم الاستمتاع والاستفادة من استخدام هُتاف... \n\nالبريد الإلكتروني: ',
            layoutSize,
            context,
          ),
          title('hutaf.app@gmail.com\n\n', layoutSize, context),
        ],
      ),
    );
  }

  Widget text(String text, Size layoutSize, BuildContext context) {
    return Text(
      text,
      textScaleFactor: 1,
      style: Theme.of(context).primaryTextTheme.caption.copyWith(
            fontSize: layoutSize.width * 0.04,
          ),
    );
  }

  Widget title(String text, Size layoutSize, BuildContext context) {
    return Text(
      text,
      textScaleFactor: 1,
      style: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: layoutSize.width * 0.04,
          ),
    );
  }
}
