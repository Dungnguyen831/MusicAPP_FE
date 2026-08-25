/// Đại diện cho một dòng lời bài hát đồng bộ theo thời gian
class LyricLine {
  final Duration time;
  final String text;

  LyricLine({required this.time, required this.text});

  @override
  String toString() => '[${time.inMinutes}:${(time.inSeconds % 60).toString().padLeft(2, '0')}] $text';
}

/// Tiện ích phân tích định dạng LRC (Synced Lyrics)
class LyricParser {
  static List<LyricLine> parse(String lrcContent) {
    final List<LyricLine> lyrics = [];
    final RegExp regExp = RegExp(r'\[(\d+):(\d+\.\d+)\](.*)');

    final lines = lrcContent.split('\n');
    for (var line in lines) {
      final match = regExp.firstMatch(line);
      if (match != null) {
        final minutes = int.parse(match.group(1)!);
        final seconds = double.parse(match.group(2)!);
        final text = match.group(3)!.trim();

        final duration = Duration(
          minutes: minutes,
          milliseconds: (seconds * 1000).toInt(),
        );

        lyrics.add(LyricLine(time: duration, text: text));
      }
    }

    // Đảm bảo lời bài hát được sắp xếp theo thời gian
    lyrics.sort((a, b) => a.time.compareTo(b.time));
    return lyrics;
  }
}
