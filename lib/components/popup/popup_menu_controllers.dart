import 'package:inventory/components/popup/contents/search_user.dart';
import 'package:inventory/components/popup/popup_helper.dart';

class PopupMenuControllers {
  final Function() onDateSelected;

  PopupMenuControllers({required this.onDateSelected});

  // PopupHelper get dateHelper =>
  //     PopupHelper(content: DatePicker(onDateSelected));

  final PopupHelper ownerHelper = PopupHelper(content: SearchUserPopup());
}
