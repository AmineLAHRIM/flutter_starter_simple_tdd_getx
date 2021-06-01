extension IntExtension on int {
  String? get toFollowersNum {
    if (this != null) {
      if (this > 0 && this < 1000) {
        return '${this}';
      } else if (this >= 1000 && this < 1000000) {
        return "${(this / 1000).toInt().toStringAsFixed(0)}K";
      } else if (this >= 1000000 && this < 1000000000) {
        return "${(this / 1000000).toInt().toStringAsFixed(0)}M";
      }
    }
    return null;
  }
}
