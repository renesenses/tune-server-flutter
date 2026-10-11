/// L'écran montré pendant que le moteur démarre, et en cas d'échec.
library;

import 'package:flutter/material.dart';

import 'serveur_embarque.dart';

class EcranDemarrage extends StatefulWidget {
  const EcranDemarrage({
    super.key,
    required this.demarrer,
    required this.quandPret,
  });

  final Future<Demarrage> Function() demarrer;
  final Future<void> Function(Pret pret) quandPret;

  @override
  State<EcranDemarrage> createState() => _EcranDemarrageState();
}

class _EcranDemarrageState extends State<EcranDemarrage> {
  Echec? _echec;

  @override
  void initState() {
    super.initState();
    _lancer();
  }

  Future<void> _lancer() async {
    setState(() => _echec = null);
    final d = await widget.demarrer();
    if (!mounted) return;
    switch (d) {
      case Pret():
        await widget.quandPret(d);
      case Echec():
        setState(() => _echec = d);
    }
  }

  @override
  Widget build(BuildContext context) {
    final echec = _echec;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: echec == null
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 24),
                      Text(
                        'Démarrage du serveur Tune…',
                        key: Key('demarrage_en_cours'),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        echec.raison,
                        key: const Key('demarrage_echec'),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _lancer,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
