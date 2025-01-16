import 'package:fluent_ui/fluent_ui.dart';

class DateTextBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const DateTextBox({
    required this.controller,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextBox(
          controller: controller,
          onChanged: onChanged,
          keyboardType: TextInputType.datetime,
          placeholder: 'YYYY-MM-DD',
          textInputAction: TextInputAction.done,
          style: TextStyle(fontSize: 16),
          // validationMessage: validator?.call(controller.text),
        ),
        SizedBox(height: 10),
        if (validator?.call(controller.text) != null)
          Text(
            validator!.call(controller.text)!,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
      ],
    );
  }
}
