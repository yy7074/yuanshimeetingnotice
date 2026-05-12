import 'package:lpinyin/lpinyin.dart';

/// Pinyin-aware search index for a single string.
///
/// For a Chinese phrase like "Shanghai Conference Center" we precompute three lowercase forms:
///   - the original text
///   - the full pinyin without separators ("shanghaihuiyizhongxin")
///   - the leading initials of each syllable ("shyzx")
///
/// Callers test their (lowercased) query against any of the three. This way
/// users can type Chinese characters, full pinyin, or initials and still hit.
class PinyinIndex {
  PinyinIndex._(this.original, this.pinyin, this.initials);

  final String original;
  final String pinyin;
  final String initials;

  static final Map<String, PinyinIndex> _cache = {};

  factory PinyinIndex.of(String text) {
    if (text.isEmpty) return _empty;
    final key = text;
    final cached = _cache[key];
    if (cached != null) return cached;
    final lower = text.toLowerCase();
    String pinyin = lower;
    String initials = lower;
    if (_containsHan(text)) {
      try {
        pinyin = PinyinHelper.getPinyinE(
          text,
          separator: '',
          defPinyin: '',
          format: PinyinFormat.WITHOUT_TONE,
        ).toLowerCase();
        initials = PinyinHelper.getShortPinyin(text).toLowerCase();
      } catch (_) {
        // Fall back to original text on conversion errors so search still
        // works even when lpinyin chokes on rare characters.
      }
    }
    final index = PinyinIndex._(lower, pinyin, initials);
    if (_cache.length > 2000) _cache.clear();
    _cache[key] = index;
    return index;
  }

  bool matches(String loweredQuery) {
    if (loweredQuery.isEmpty) return true;
    return original.contains(loweredQuery) ||
        pinyin.contains(loweredQuery) ||
        initials.contains(loweredQuery);
  }

  static final PinyinIndex _empty = PinyinIndex._('', '', '');

  static bool _containsHan(String text) {
    for (final code in text.runes) {
      if (code >= 0x4E00 && code <= 0x9FFF) return true;
    }
    return false;
  }
}

/// Convenience: test whether ANY of the supplied texts matches the query in
/// either original or pinyin form.
bool matchesPinyin(String query, Iterable<String> haystacks) {
  if (query.isEmpty) return true;
  final q = query.toLowerCase();
  for (final h in haystacks) {
    if (h.isEmpty) continue;
    if (PinyinIndex.of(h).matches(q)) return true;
  }
  return false;
}
