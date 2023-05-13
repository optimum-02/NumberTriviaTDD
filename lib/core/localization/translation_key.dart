import 'package:flutter/cupertino.dart';

import 'app_localization.dart';

enum TKeys {
  appTitle,
  hintEnterNumber,
  buttonSearchTriviaText,
  buttonRandomTriviaText,
  serverFailureText,
  invalidInputFailure,
  transalationFailedFailureText,
  noCachedDataFailureText,
  welcomeText,
  initialInstructionText,
  changeThemeTooltip
}

extension TKeysX on TKeys {
  String get _string => toString().split('.')[1];

  String tr(BuildContext context) {
    return AppLocalization.of(context).translate(_string);
  }
}
