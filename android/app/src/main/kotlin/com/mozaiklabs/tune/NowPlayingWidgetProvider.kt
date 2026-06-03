package com.mozaiklabs.tune

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class NowPlayingWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (widgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.now_playing_widget)

            val title = widgetData.getString("widgetTrackTitle", null)
            val artist = widgetData.getString("widgetArtistName", null)
            val isPlaying = widgetData.getBoolean("widgetIsPlaying", false)

            if (!title.isNullOrEmpty()) {
                views.setTextViewText(R.id.widget_track_title, title)
                views.setTextViewText(R.id.widget_artist_name, artist ?: "")
            } else {
                views.setTextViewText(R.id.widget_track_title, "Tune")
                views.setTextViewText(R.id.widget_artist_name, "No track playing")
            }

            val iconRes = if (isPlaying) {
                android.R.drawable.ic_media_pause
            } else {
                android.R.drawable.ic_media_play
            }
            views.setImageViewResource(R.id.widget_play_pause, iconRes)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
