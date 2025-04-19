import 'package:fluent_ui/fluent_ui.dart';

class InfoPane extends StatelessWidget {
  final String title;
  final Map<String, dynamic> info;

  const InfoPane({super.key, required this.title, required this.info});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: FluentTheme.of(context).typography.subtitle),
            const SizedBox(height: 12),
            ...info.entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('${e.key}: ${e.value}'),
                )),
          ],
        ),
      ),
    );
  }
}
