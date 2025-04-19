import 'package:flutter/material.dart';

class SearchScorer {
  String filter;

  SearchScorer(this.filter);

  void _engine(String filter, String data, onMatch, onSkipChar) {
    while (filter.isNotEmpty && data.isNotEmpty) {
      if (filter[0].toLowerCase() == data[0].toLowerCase()) {
        onMatch(data[0]);
        data = data.substring(1);
        filter = filter.substring(1);
      } else {
        onSkipChar(data[0]);
        data = data.substring(1);
      }
    }
    while (data.isNotEmpty) {
      onSkipChar(data[0]);
      data = data.substring(1);
    }
  }

  int getScore(String data) {
    int score = 0;

    _engine(filter, data, (_) {
      score++;
    }, (_) {});

    return score;
  }

  RichText getMatching(String data) {
    List<TextSpan> children = [];

    _engine(
      filter,
      data,
      (c) {
        children.add(
          TextSpan(
            text: c,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
      (c) {
        children.add(TextSpan(text: c));
      },
    );

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14.0, color: Colors.black),
        children: children,
      ),
    );
  }
}
