import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

// ---------------------------------------------------------------------------
// PodcastService — récupère les podcasts Radio France + iTunes search + RSS.
// Miroir de la logique TuneAPIClient.getRadioFrancePodcasts() (iOS)
// ---------------------------------------------------------------------------

class PodcastShow {
  final String id;
  final String name;
  final String artist;
  final String coverUrl;
  final String description;
  final String feedUrl;
  final String? showUrl;
  final int episodeCount;

  const PodcastShow({
    required this.id,
    required this.name,
    required this.artist,
    required this.coverUrl,
    required this.description,
    this.feedUrl = '',
    this.showUrl,
    this.episodeCount = 0,
  });
}

class PodcastEpisodeItem {
  final String id;
  final String title;
  final String description;
  final String audioUrl;
  final String coverUrl;
  final String published;
  final int durationMs;

  const PodcastEpisodeItem({
    required this.id,
    required this.title,
    required this.description,
    required this.audioUrl,
    required this.coverUrl,
    required this.published,
    required this.durationMs,
  });
}

// ---------------------------------------------------------------------------
// Service
// ---------------------------------------------------------------------------

class PodcastService {
  static const _timeout = Duration(seconds: 15);
  static const _userAgent =
      'Mozilla/5.0 (compatible; TuneServer/1.0)';

  // -------------------------------------------------------------------------
  // Radio France — GraphQL public
  // -------------------------------------------------------------------------

  static const _radioFranceUrl =
      'https://www.radiofrance.fr/api/v1.6/graphql';

  static const _radioFrancePodcastsQuery = r'''
{
  "query": "query { getAllBrandsPodcastsAndSeries(pagination: { first: 60 }) { edges { node { id title ... on PodcastSeries { seriesType } ... on Brand { podcastSeries { id title squareVisual { src } standFirst } } } } } }"
}
''';

  // Fallback: liste statique des émissions Radio France connues
  static const List<PodcastShow> _radioFranceFallback = [
    PodcastShow(
      id: 'rf-franceculture-series',
      name: 'Les Nuits de France Culture',
      artist: 'France Culture',
      coverUrl: 'https://cdn.radiofrance.fr/s3/cruiser-production/2021/10/d22bceab-8e40-413b-b012-c92d04b7cc8b/1200x1200_fc_nuits.jpg',
      description: 'Les grandes nuits de France Culture.',
      feedUrl: 'https://radiofrance-podcast.net/podcast09/rss_10183.xml',
    ),
    PodcastShow(
      id: 'rf-franceinter-grand-charivari',
      name: 'Le Grand Charivari',
      artist: 'France Inter',
      coverUrl: 'https://cdn.radiofrance.fr/s3/cruiser-production/2023/09/23d9c83e-95f3-4e89-a4bd-0e2e75f62d3e/1200x1200_le-grand-charivari.jpg',
      description: 'Le magazine musical du samedi.',
      feedUrl: 'https://radiofrance-podcast.net/podcast09/rss_14506.xml',
    ),
    PodcastShow(
      id: 'rf-musique',
      name: 'France Musique Live',
      artist: 'France Musique',
      coverUrl: 'https://cdn.radiofrance.fr/s3/cruiser-production/2021/06/cfbbf7f7-4284-4bfb-ab69-f22b4ae99a26/1200x1200_france-musique.jpg',
      description: 'Les concerts et émissions de France Musique.',
      feedUrl: 'https://radiofrance-podcast.net/podcast09/rss_13529.xml',
    ),
    PodcastShow(
      id: 'rf-franceinter-carnets',
      name: 'Carnets de campagne',
      artist: 'France Inter',
      coverUrl: 'https://cdn.radiofrance.fr/s3/cruiser-production/2022/08/a8ca2f50-7fae-4f49-9b1b-a1fbc6fb0891/1200x1200_carnets-de-campagne.jpg',
      description: 'Philippe Bertrand part à la rencontre de la France rurale.',
      feedUrl: 'https://radiofrance-podcast.net/podcast09/rss_14227.xml',
    ),
  ];

  Future<List<PodcastShow>> getRadioFrancePodcasts() async {
    try {
      final resp = await http
          .post(
            Uri.parse(_radioFranceUrl),
            headers: {
              'Content-Type': 'application/json',
              'User-Agent': _userAgent,
            },
            body: _radioFrancePodcastsQuery.trim(),
          )
          .timeout(_timeout);

      if (resp.statusCode != 200) return _radioFranceFallback;

      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final edges = (data['data']?['getAllBrandsPodcastsAndSeries']?['edges'] as List?) ?? [];

      final shows = <PodcastShow>[];
      for (final edge in edges) {
        final node = edge['node'] as Map<String, dynamic>?;
        if (node == null) continue;

        final id = node['id']?.toString() ?? '';
        final title = node['title']?.toString() ?? '';

        // Traite les Brand (avec podcastSeries imbriqués)
        final series = node['podcastSeries'] as List?;
        if (series != null) {
          for (final s in series) {
            final cover = (s['squareVisual'] as Map?)?['src']?.toString() ?? '';
            shows.add(PodcastShow(
              id: s['id']?.toString() ?? id,
              name: s['title']?.toString() ?? title,
              artist: 'Radio France',
              coverUrl: cover,
              description: s['standFirst']?.toString() ?? '',
              feedUrl: '',
            ));
          }
        } else {
          shows.add(PodcastShow(
            id: id,
            name: title,
            artist: 'Radio France',
            coverUrl: '',
            description: '',
            feedUrl: '',
          ));
        }
      }

      return shows.isEmpty ? _radioFranceFallback : shows;
    } catch (_) {
      return _radioFranceFallback;
    }
  }

  // -------------------------------------------------------------------------
  // Recherche iTunes / Podcast Index
  // -------------------------------------------------------------------------

  Future<List<PodcastShow>> searchPodcasts(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final uri = Uri.https(
        'itunes.apple.com',
        '/search',
        {
          'term': query.trim(),
          'media': 'podcast',
          'limit': '25',
          'country': 'FR',
        },
      );

      final resp = await http
          .get(uri, headers: {'User-Agent': _userAgent})
          .timeout(_timeout);

      if (resp.statusCode != 200) return [];

      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final results = (data['results'] as List?) ?? [];

      return results.map((r) {
        final m = r as Map<String, dynamic>;
        return PodcastShow(
          id: m['collectionId']?.toString() ?? '',
          name: m['collectionName']?.toString() ?? '',
          artist: m['artistName']?.toString() ?? '',
          coverUrl: (m['artworkUrl600'] ?? m['artworkUrl100'] ?? '').toString(),
          description: m['description']?.toString() ?? '',
          feedUrl: m['feedUrl']?.toString() ?? '',
          episodeCount: (m['trackCount'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  // -------------------------------------------------------------------------
  // Épisodes depuis le flux RSS
  // -------------------------------------------------------------------------

  Future<List<PodcastEpisodeItem>> getPodcastEpisodes({
    required String feedUrl,
    String showUrl = '',
  }) async {
    if (feedUrl.isEmpty) return [];

    try {
      final resp = await http
          .get(Uri.parse(feedUrl), headers: {'User-Agent': _userAgent})
          .timeout(_timeout);

      if (resp.statusCode != 200) return [];

      return _parseRss(resp.body);
    } catch (_) {
      return [];
    }
  }

  List<PodcastEpisodeItem> _parseRss(String xmlContent) {
    try {
      final doc = XmlDocument.parse(xmlContent);
      final items = doc.findAllElements('item');
      final episodes = <PodcastEpisodeItem>[];

      for (final item in items.take(50)) {
        final title = item.findElements('title').firstOrNull?.innerText ?? '';
        final guid = item.findElements('guid').firstOrNull?.innerText ??
            item.findElements('link').firstOrNull?.innerText ??
            title;

        // URL audio : enclosure ou media:content
        String audioUrl = '';
        final enclosure = item.findElements('enclosure').firstOrNull;
        if (enclosure != null) {
          audioUrl = enclosure.getAttribute('url') ?? '';
        }
        if (audioUrl.isEmpty) {
          final mediaContent = item.findAllElements('content').firstOrNull;
          audioUrl = mediaContent?.getAttribute('url') ?? '';
        }

        // Pochette de l'épisode (itunes:image ou media:thumbnail)
        String coverUrl = '';
        final itunesImage = item.findAllElements('image').firstOrNull;
        if (itunesImage != null) {
          coverUrl = itunesImage.getAttribute('href') ??
              itunesImage.innerText;
        }
        if (coverUrl.isEmpty) {
          final mediaThumbnail =
              item.findAllElements('thumbnail').firstOrNull;
          coverUrl = mediaThumbnail?.getAttribute('url') ?? '';
        }

        // Date de publication
        final pubDate =
            item.findElements('pubDate').firstOrNull?.innerText ?? '';

        // Durée (itunes:duration)
        final durationStr =
            item.findAllElements('duration').firstOrNull?.innerText ?? '';
        final durationMs = _parseDuration(durationStr);

        // Description
        final description =
            item.findAllElements('summary').firstOrNull?.innerText ??
            item.findElements('description').firstOrNull?.innerText ??
            '';

        episodes.add(PodcastEpisodeItem(
          id: guid,
          title: title,
          description: description,
          audioUrl: audioUrl,
          coverUrl: coverUrl,
          published: pubDate,
          durationMs: durationMs,
        ));
      }

      return episodes;
    } catch (_) {
      return [];
    }
  }

  int _parseDuration(String s) {
    if (s.isEmpty) return 0;
    final parts = s.split(':');
    try {
      if (parts.length == 3) {
        return ((int.parse(parts[0]) * 3600 +
                int.parse(parts[1]) * 60 +
                int.parse(parts[2])) *
            1000);
      }
      if (parts.length == 2) {
        return (int.parse(parts[0]) * 60 + int.parse(parts[1])) * 1000;
      }
      return int.parse(s) * 1000;
    } catch (_) {
      return 0;
    }
  }
}
