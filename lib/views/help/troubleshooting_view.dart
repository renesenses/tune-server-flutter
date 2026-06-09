import 'package:flutter/material.dart';

import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// TroubleshootingView — FAQ depannage avec sections extensibles.
// Accessible depuis Reglages > Aide > Depannage.
// ---------------------------------------------------------------------------

class TroubleshootingView extends StatelessWidget {
  const TroubleshootingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Depannage', style: TuneFonts.title3),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: const [
          _SectionHeader('QUESTIONS FREQUENTES'),
          _FaqItem(
            icon: Icons.wifi_off_rounded,
            title: 'Je ne vois pas mon serveur',
            steps: [
              'Verifiez que le serveur Tune est demarre et accessible.',
              'Assurez-vous que votre appareil est connecte au meme reseau Wi-Fi que le serveur.',
              'Si vous utilisez un VPN, desactivez-le ou activez la decouverte LAN (ex: nordvpn set lan-discovery on).',
              'Essayez de scanner le reseau depuis Reglages > Mode > Scanner le reseau.',
              'Verifiez que le port du serveur (par defaut 8888) n\'est pas bloque par un pare-feu.',
              'Redemarrez le serveur et l\'application.',
            ],
          ),
          _FaqItem(
            icon: Icons.music_off_rounded,
            title: 'La musique ne joue pas',
            steps: [
              'Verifiez qu\'une zone de lecture est selectionnee (barre en bas de l\'ecran).',
              'Si aucune zone n\'existe, creez-en une dans Reglages > Audio > Zones > Creer.',
              'Verifiez que l\'appareil de sortie (enceinte, DAC) est allume et sur le meme reseau.',
              'Pour les appareils DLNA, attendez quelques secondes apres la decouverte avant de lancer la lecture.',
              'Essayez un autre fichier — le format du fichier actuel n\'est peut-etre pas supporte.',
              'Redemarrez l\'application si le probleme persiste.',
            ],
          ),
          _FaqItem(
            icon: Icons.broken_image_rounded,
            title: 'Les pochettes ne s\'affichent pas',
            steps: [
              'Lancez un scan de la bibliotheque depuis Reglages > Bibliotheque > Sources.',
              'Verifiez que les fichiers contiennent des pochettes embarquees (tags ID3/Vorbis).',
              'Placez un fichier cover.jpg ou folder.jpg dans le dossier de l\'album.',
              'Activez la recuperation automatique des pochettes dans Reglages > Bibliotheque > Metadonnees.',
              'Purgez le cache images en redemarrant l\'application.',
            ],
          ),
          _FaqItem(
            icon: Icons.hourglass_top_rounded,
            title: 'Le scan est bloque',
            steps: [
              'Un scan initial peut prendre plusieurs minutes selon la taille de la bibliotheque.',
              'Verifiez que les dossiers musicaux sont accessibles (permissions, montages SMB).',
              'Fermez et relancez l\'application pour interrompre un scan bloque.',
              'Verifiez les logs du serveur pour identifier un fichier problematique.',
              'Essayez de reduire le nombre de dossiers sources pour isoler le probleme.',
            ],
          ),
          _FaqItem(
            icon: Icons.cast_rounded,
            title: 'Comment connecter un appareil DLNA/AirPlay',
            steps: [
              'DLNA : l\'appareil doit etre allume et sur le meme reseau. Il apparait automatiquement dans la liste des sorties.',
              'Si l\'appareil n\'apparait pas, verifiez que le multicast fonctionne sur votre routeur.',
              'Certains routeurs bloquent le trafic SSDP entre les clients Wi-Fi — activez le relais multicast.',
              'BluOS : les enceintes Bluesound sont detectees automatiquement.',
              'Chromecast : les appareils Google Cast apparaissent dans les sorties disponibles.',
              'Apres la detection, creez une zone et assignez-y l\'appareil comme sortie.',
            ],
          ),
          _FaqItem(
            icon: Icons.cloud_off_rounded,
            title: 'Problemes de streaming',
            steps: [
              'Verifiez que vos identifiants de service (Tidal, Qobuz, Deezer) sont corrects dans Reglages > Streaming.',
              'Si la session a expire, deconnectez puis reconnectez le service.',
              'Verifiez votre connexion Internet.',
              'Certains titres peuvent etre indisponibles dans votre region.',
              'Pour les problemes de qualite, verifiez les reglages de qualite streaming dans Reglages > Audio avance.',
              'Si le probleme persiste, envoyez un rapport de bug depuis Reglages > Aide.',
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header — matches settings_view.dart style
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        title.toUpperCase(),
        style: TuneFonts.footnote.copyWith(
          color: TuneColors.textTertiary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// FAQ item — expandable tile with numbered steps
// ---------------------------------------------------------------------------

class _FaqItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> steps;

  const _FaqItem({
    required this.icon,
    required this.title,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TuneColors.surface,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(icon, color: TuneColors.accent, size: 22),
          title: Text(title, style: TuneFonts.body),
          iconColor: TuneColors.textTertiary,
          collapsedIconColor: TuneColors.textTertiary,
          childrenPadding: const EdgeInsets.fromLTRB(56, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: steps.asMap().entries.map((entry) {
            final idx = entry.key + 1;
            final step = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 22,
                    child: Text(
                      '$idx.',
                      style: TuneFonts.footnote.copyWith(
                        color: TuneColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      step,
                      style: TuneFonts.footnote.copyWith(
                        color: TuneColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
