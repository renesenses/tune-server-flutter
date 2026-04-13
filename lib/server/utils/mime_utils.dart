/// Shared MIME type resolution for audio files.
/// Used by DLNAOutput and HttpAudioStreamer.
String mimeTypeForAudioPath(String path) {
  final lower = path.split('?').first.toLowerCase();
  if (lower.endsWith('.flac')) return 'audio/flac';
  if (lower.endsWith('.mp3')) return 'audio/mpeg';
  if (lower.endsWith('.m4a') || lower.endsWith('.aac')) return 'audio/mp4';
  if (lower.endsWith('.ogg')) return 'audio/ogg';
  if (lower.endsWith('.opus')) return 'audio/ogg; codecs=opus';
  if (lower.endsWith('.wav')) return 'audio/wav';
  if (lower.endsWith('.aiff') || lower.endsWith('.aif')) return 'audio/aiff';
  if (lower.endsWith('.dsf') || lower.endsWith('.dff')) return 'audio/x-dsf';
  return 'audio/mpeg';
}
