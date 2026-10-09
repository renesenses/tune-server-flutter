package com.mozaiklabs.tune

import io.flutter.embedding.android.FlutterActivity

/**
 * L'activité de l'application « Tune serveur ».
 *
 * Les anciens canaux (`library` : lecture des étiquettes par
 * MediaMetadataRetriever ; `bluetooth`) servaient le moteur Dart, retiré :
 * le moteur Rust lit lui-même les fichiers.
 */
class MainActivity : FlutterActivity()
