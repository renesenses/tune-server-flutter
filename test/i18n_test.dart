// Garde-fous de la traduction de l'application serveur.
//
// 1. Les fichiers ARB des 9 langues ont exactement les mêmes clés que la
//    table anglaise (modèle de gen-l10n), aucune valeur vide, et les mêmes
//    paramètres `{nom}`.
// 2. Aucun texte visible n'est écrit en dur dans lib/views : ni chaîne
//    accentuée, ni français sans accent (« Reessayer », « LECTURE »), ni
//    libellé littéral passé à Text(…), tooltip:, labelText:…
//
// Une chaîne qui n'est PAS du texte d'interface (marque, identifiant
// technique) et que ces filets attrapent quand même se marque d'un
// commentaire `// i18n-ok` en fin de ligne.
//
// flutter test test/i18n_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _langues = ['de', 'en', 'es', 'fr', 'hu', 'it', 'ja', 'ko', 'zh'];

Map<String, dynamic> _arb(String langue) =>
    jsonDecode(File('lib/l10n/app_$langue.arb').readAsStringSync())
        as Map<String, dynamic>;

Iterable<String> _cles(Map<String, dynamic> arb) =>
    arb.keys.where((k) => !k.startsWith('@'));

/// Les paramètres `{nom}` d'un message, pluriels ICU compris.
Set<String> _parametres(String message) => RegExp(r'\{(\w+)[,}]')
    .allMatches(message)
    .map((m) => m.group(1)!)
    .where((p) => int.tryParse(p) == null)
    .toSet();

// ---------------------------------------------------------------------------
// Un lecteur de source Dart, réduit à ce que le banc doit voir : les
// identifiants, la ponctuation et les chaînes ; commentaires écartés.
// ---------------------------------------------------------------------------

enum _Genre { ident, chaine, autre }

class _Jeton {
  final _Genre genre;
  final String texte;
  final int ligne;
  const _Jeton(this.genre, this.texte, this.ligne);
}

List<_Jeton> _lire(String src) {
  final sortie = <_Jeton>[];
  var i = 0;
  var ligne = 1;
  bool estIdent(int c) =>
      (c >= 0x30 && c <= 0x39) ||
      (c >= 0x41 && c <= 0x5a) ||
      (c >= 0x61 && c <= 0x7a) ||
      c == 0x5f ||
      c == 0x24;

  // Lit une chaîne à partir de `i` (sur le guillemet ouvrant) et rend sa
  // valeur, les interpolations remplacées par `${…}`.
  String chaine({required bool brute}) {
    final q = src[i];
    final triple = src.startsWith(q * 3, i);
    final fin = triple ? q * 3 : q;
    i += fin.length;
    final b = StringBuffer();
    while (i < src.length && !src.startsWith(fin, i)) {
      final c = src[i];
      if (c == '\n') ligne++;
      if (!brute && c == r'\') {
        b.write(src[i + 1]);
        i += 2;
        continue;
      }
      if (!brute && c == r'$') {
        if (src[i + 1] == '{') {
          var profondeur = 0;
          i++;
          final debut = i + 1;
          final ligneExpr = ligne;
          do {
            final d = src[i];
            if (d == '{') profondeur++;
            if (d == '}') profondeur--;
            if (d == "'" || d == '"') {
              chaine(brute: false);
              continue;
            }
            if (d == '\n') ligne++;
            i++;
          } while (profondeur > 0 && i < src.length);
          // L'expression interpolée est du code : ses chaînes comptent.
          for (final j in _lire(src.substring(debut, i - 1))) {
            sortie.add(_Jeton(j.genre, j.texte, j.ligne + ligneExpr - 1));
          }
          b.write(r'${…}');
          continue;
        }
        i++;
        // `$nom` : un identifiant sans `$`, sinon `$a${b}` se lirait mal.
        while (i < src.length &&
            src[i] != r'$' &&
            estIdent(src.codeUnitAt(i))) {
          i++;
        }
        b.write(r'${…}');
        continue;
      }
      b.write(c);
      i++;
    }
    i += fin.length;
    return b.toString();
  }

  while (i < src.length) {
    final c = src[i];
    if (c == '\n') {
      ligne++;
      i++;
    } else if (c.trim().isEmpty) {
      i++;
    } else if (src.startsWith('//', i)) {
      while (i < src.length && src[i] != '\n') {
        i++;
      }
    } else if (src.startsWith('/*', i)) {
      final f = src.indexOf('*/', i + 2);
      ligne += '\n'.allMatches(src.substring(i, f)).length;
      i = f + 2;
    } else if (c == 'r' &&
        i + 1 < src.length &&
        (src[i + 1] == "'" || src[i + 1] == '"') &&
        (i == 0 || !estIdent(src.codeUnitAt(i - 1)))) {
      final l = ligne;
      i++;
      sortie.add(_Jeton(_Genre.chaine, chaine(brute: true), l));
    } else if (c == "'" || c == '"') {
      final l = ligne;
      sortie.add(_Jeton(_Genre.chaine, chaine(brute: false), l));
    } else if (estIdent(src.codeUnitAt(i))) {
      final debut = i;
      while (i < src.length && estIdent(src.codeUnitAt(i))) {
        i++;
      }
      sortie.add(_Jeton(_Genre.ident, src.substring(debut, i), ligne));
    } else {
      sortie.add(_Jeton(_Genre.autre, c, ligne));
      i++;
    }
  }
  return sortie;
}

class _Chaine {
  final String fichier;
  final int ligne;
  final String texte;

  /// Le jeton qui précède : `Text` + `(`, ou un argument nommé `tooltip` + `:`.
  final String? porteur;
  const _Chaine(this.fichier, this.ligne, this.texte, this.porteur);

  @override
  String toString() => '$fichier:$ligne  ${jsonEncode(texte)}';
}

/// Les chaînes de lib/views, hors lignes marquées `// i18n-ok`, hors
/// plages `// i18n-ok-debut` … `// i18n-ok-fin`, et hors imports.
List<_Chaine> _chainesDesVues() {
  final sortie = <_Chaine>[];
  final fichiers = Directory('lib/views')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  for (final f in fichiers) {
    final src = f.readAsStringSync();
    final lignes = src.split('\n');
    final jetons = _lire(src);
    final exemptes = <int>{};
    int? debut;
    for (var k = 0; k < lignes.length; k++) {
      if (lignes[k].contains('i18n-ok-debut')) debut = k + 1;
      if (lignes[k].contains('i18n-ok-fin') && debut != null) {
        for (var m = debut; m <= k + 1; m++) {
          exemptes.add(m);
        }
        debut = null;
      }
    }
    for (var n = 0; n < jetons.length; n++) {
      final j = jetons[n];
      if (j.genre != _Genre.chaine) continue;
      final texteLigne = lignes[j.ligne - 1];
      if (texteLigne.contains('i18n-ok') || exemptes.contains(j.ligne)) {
        continue;
      }
      if (RegExp(r'^\s*(import|export|part)\b').hasMatch(texteLigne)) continue;
      String? porteur;
      if (n >= 2 && jetons[n - 2].genre == _Genre.ident) {
        final p = jetons[n - 1].texte;
        if (p == '(' || p == ':') porteur = '${jetons[n - 2].texte}$p';
      }
      sortie.add(_Chaine(f.path, j.ligne, j.texte, porteur));
    }
  }
  return sortie;
}

final _accents = RegExp(r'[À-ÿŒœ«»]');

/// Des mots qui n'existent qu'en français (ou presque) : une chaîne qui en
/// porte un est du texte français écrit en dur, accents oubliés ou non.
final _motsFrancais = RegExp(
  r'\b(le|la|les|des|du|une|aux|est|sont|pas|aucun|aucune|avec|pour|sur|'
  r'dans|votre|vos|ce|cette|ces|ou|et|en cours|impossible de|erreur|'
  r'serveur|bibliotheque|lecture|systeme|aide|suivant|precedent|passer|'
  r'reessayer|annuler|fermer|supprimer|enregistrer|ajouter|modifier|'
  r'chargement|echec|reussi|termine|terminee|piste|pistes|morceaux|titres|'
  r'reglages|parametres|dossier|fichier|fichiers|connexion|deconnecte|'
  r'demarrer|arreter|lancer|rechercher|aucune?|ecoute|sante|lire|'
  r'enceinte|sortie|appareil|appareils)\b',
  caseSensitive: false,
);

/// Les porteurs d'un texte affiché : `Text('…')`, `tooltip: '…'`…
const _porteursAffiches = {
  'Text(',
  'SelectableText(',
  'Tooltip(',
  '_SectionHeader(',
  'tooltip:',
  'labelText:',
  'hintText:',
  'helperText:',
  'errorText:',
  'semanticLabel:',
  'semanticsLabel:',
  'title:',
  'subtitle:',
  'label:',
  'message:',
};

/// Marques et sigles qu'on n'affiche jamais traduits.
final _marque = RegExp(
  r'^(Tune|Tune Server|Tune Master|Qobuz|TIDAL|Tidal|Deezer|Spotify|'
  r'Spotify Connect|YouTube|YouTube Music|Apple Music|Last\.fm|ListenBrainz|'
  r'MusicBrainz|Discogs|DLNA|UPnP|AirPlay|Chromecast|SMB|NFS|HTTP|HTTPS|'
  r'FLAC|MP3|AAC|ALAC|DSD|PCM|WAV|EQ|DJ|AI|IA|API|OK|ID|IP|MBID|ISRC|'
  r'Bluetooth|Wi-Fi|WiFi|SoundCloud|Bandcamp|Podcast Index|ReplayGain|'
  r'Radio Browser|TuneIn|Roon|Smart AutoPlay|Master Profiler|'
  r'Last\.fm Scrobble|CHROMECAST|CPU|RAM|DNS|Internet|Multicast / SSDP|'
  r'Rock|Jazz)$',
);

/// Une chaîne qui contient des lettres une fois les `${…}` et les unités
/// (dB, kHz, min…) retirées.
bool _aDuTexte(String s) => RegExp(r'[A-Za-z]{2}').hasMatch(s
    .replaceAll(r'${…}', '')
    .replaceAll(RegExp(r'\b(dB|kHz|Hz|bit|ms|min|s|h)\b'), ''));

void main() {
  group('les fichiers de traduction', () {
    final en = _arb('en');

    test('existent pour les 9 langues', () {
      for (final l in _langues) {
        expect(File('lib/l10n/app_$l.arb').existsSync(), isTrue, reason: l);
      }
    });

    test('ont exactement les clés de la table anglaise', () {
      final attendues = _cles(en).toSet();
      for (final l in _langues) {
        final cles = _cles(_arb(l)).toSet();
        expect(attendues.difference(cles), isEmpty,
            reason: 'clés manquantes en $l');
        expect(cles.difference(attendues), isEmpty,
            reason: 'clés en trop en $l');
      }
    });

    test('ne laissent aucune traduction vide', () {
      for (final l in _langues) {
        final arb = _arb(l);
        final vides = _cles(arb)
            .where((k) => (arb[k] as String).trim().isEmpty)
            .toList();
        expect(vides, isEmpty, reason: l);
      }
    });

    test('gardent les mêmes paramètres {nom} que l\'anglais', () {
      for (final l in _langues) {
        final arb = _arb(l);
        for (final k in _cles(en)) {
          expect(_parametres(arb[k] as String),
              _parametres(en[k] as String),
              reason: '$k en $l');
        }
      }
    });
  });

  group('lib/views', () {
    final chaines = _chainesDesVues();

    test('ne montre aucun texte accentué écrit en dur', () {
      final fautifs =
          chaines.where((c) => _accents.hasMatch(c.texte)).toList();
      expect(fautifs, isEmpty, reason: fautifs.join('\n'));
    });

    test('ne montre aucun texte français écrit en dur', () {
      final fautifs = chaines
          .where((c) => _motsFrancais.hasMatch(c.texte.replaceAll(r'${…}', '')))
          .toList();
      expect(fautifs, isEmpty, reason: fautifs.join('\n'));
    });

    test('ne passe aucun libellé littéral à un widget de texte', () {
      final fautifs = chaines
          .where((c) => _porteursAffiches.contains(c.porteur))
          .where((c) => _aDuTexte(c.texte))
          .where((c) => !_marque.hasMatch(c.texte.trim()))
          .toList();
      expect(fautifs, isEmpty, reason: fautifs.join('\n'));
    });
  });
}
