package com.mozaiklabs.verrou_multicast

import android.content.Context
import android.net.wifi.WifiManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

/**
 * Le verrou multicast Wi-Fi d'Android.
 *
 * Sans lui, beaucoup de téléphones FILTRENT le multicast reçu en Wi-Fi pour
 * économiser la batterie : le serveur Tune n'entend plus les annonces SSDP
 * (lecteurs DLNA/UPnP) ni les réponses mDNS, et la découverte reste aveugle.
 * L'émulateur ne filtre pas : il ne prouve rien là-dessus.
 *
 * Un greffon plutôt qu'un canal de MainActivity : greffon, il est enregistré
 * dans CHAQUE moteur Flutter, y compris celui du service au premier plan.
 * C'est le service qui prend le verrou en démarrant et le rend en s'arrêtant,
 * même quand l'activité n'existe plus.
 *
 * Le verrou vit dans le processus (objet compagnon) : un seul, quel que soit le
 * moteur qui le demande. Non compté par Android (`setReferenceCounted(false)`) :
 * prendre deux fois puis rendre une fois le rend bien.
 */
class VerrouMulticastPlugin : FlutterPlugin {
    private var canal: MethodChannel? = null

    override fun onAttachedToEngine(liaison: FlutterPlugin.FlutterPluginBinding) {
        val contexte = liaison.applicationContext
        canal = MethodChannel(liaison.binaryMessenger, CANAL).apply {
            setMethodCallHandler { appel, reponse ->
                when (appel.method) {
                    "prendre" -> reponse.success(prendre(contexte))
                    "rendre" -> reponse.success(rendre())
                    "estTenu" -> reponse.success(verrou?.isHeld == true)
                    else -> reponse.notImplemented()
                }
            }
        }
    }

    override fun onDetachedFromEngine(liaison: FlutterPlugin.FlutterPluginBinding) {
        canal?.setMethodCallHandler(null)
        canal = null
    }

    companion object {
        const val CANAL = "com.mozaiklabs.tune/verrou_multicast"
        private const val ETIQUETTE = "tune-serveur:multicast"

        @Volatile
        private var verrou: WifiManager.MulticastLock? = null

        @Synchronized
        fun prendre(contexte: Context): Boolean {
            val v = verrou ?: run {
                val wifi = contexte.getSystemService(Context.WIFI_SERVICE) as? WifiManager
                    ?: return false
                wifi.createMulticastLock(ETIQUETTE).also {
                    it.setReferenceCounted(false)
                    verrou = it
                }
            }
            if (!v.isHeld) v.acquire()
            return v.isHeld
        }

        @Synchronized
        fun rendre(): Boolean {
            verrou?.let { if (it.isHeld) it.release() }
            return verrou?.isHeld != true
        }
    }
}
