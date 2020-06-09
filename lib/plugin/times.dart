import 'package:flutter/material.dart';

class Times {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime date = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} tahun yang lalu';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 tahun yang lalu' : 'tahun lalu';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} bulan yang lalu';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 bulan yang lalu' : 'bulan lalu';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} minggu yang lalu';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 minggu yang lalu' : 'minggu lalu';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 hari yang lalu' : 'kemarin';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 jam yang lalu' : '1 jam yang lalu';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 menit yang lalu' : '1 menit yang lalu';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} detik yang lalu';
    } else {
      return 'baru saja';
    }
  }

}
