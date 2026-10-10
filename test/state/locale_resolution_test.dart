import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tune_server/l10n/app_localizations.dart';
import 'package:tune_server/state/settings_state.dart';

void main() {
  const prises = AppLocalizations.supportedLocales;

  test('suit la langue du téléphone quand elle est prise en charge', () {
    expect(resoudreLocale(const [Locale('en', 'US')], prises), const Locale('en'));
    expect(resoudreLocale(const [Locale('fr', 'FR')], prises), const Locale('fr'));
    expect(resoudreLocale(const [Locale('ko', 'KR')], prises), const Locale('ko'));
  });

  test('prend la première langue du téléphone prise en charge', () {
    expect(
      resoudreLocale(const [Locale('nl'), Locale('it'), Locale('en')], prises),
      const Locale('it'),
    );
  });

  test('retombe sur l\'anglais, ni le français ni la première de la liste', () {
    // Sans rappel, Flutter rendait supportedLocales.first, c.-à-d. `de`.
    expect(prises.first, isNot(const Locale('en')));
    expect(resoudreLocale(const [Locale('nl', 'NL')], prises), const Locale('en'));
    expect(resoudreLocale(const [Locale('pt', 'BR')], prises), const Locale('en'));
    expect(resoudreLocale(const [], prises), const Locale('en'));
    expect(resoudreLocale(null, prises), const Locale('en'));
  });

  test('l\'anglais est bien une langue prise en charge', () {
    expect(prises, contains(localeDeRepli));
  });
}
