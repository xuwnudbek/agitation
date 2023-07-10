import 'package:get/get.dart';
import 'ru.dart';

import 'uz.dart';

class Language extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ru': ru,
        'uz': uz,
      };
}
