import 'package:basic_board/utils/imports.dart';
import 'package:readmore/readmore.dart';

class AppShowMoreText extends StatelessWidget {
  const AppShowMoreText({
    super.key,
    required this.text,
    this.textAlign,
  });

  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      text,
      textAlign: textAlign,
      moreStyle: const TextStyle(
        fontSize: 12.0,
        color: Colors.amber,
      ),
      lessStyle: const TextStyle(
        fontSize: 12.0,
        color: Colors.amber,
      ),
      trimMode: TrimMode.Line,
      trimLines: 3,
      trimExpandedText: '\t\tless',
      trimCollapsedText: 'more',
    );
  }
}
