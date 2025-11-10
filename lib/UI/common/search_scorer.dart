import 'package:flutter/material.dart';

class SearchScorer {
  String filter;

  SearchScorer(this.filter);

  void _engine(String filter, String data, void Function(String) onMatch, void Function(String) onSkipSegment) {
    Characters filterChars = filter.characters;
    Characters dataChars = data.characters;

    while (filterChars.isNotEmpty && dataChars.isNotEmpty) {
      if (filterChars.first.toLowerCase() == dataChars.first.toLowerCase()) {
        onMatch(dataChars.first);
        filterChars = filterChars.skip(1);
      } else {
        onSkipSegment(dataChars.first);
      }
      dataChars = dataChars.skip(1);
    }
    if (dataChars.isNotEmpty) {
      onSkipSegment(dataChars.string);
    }
  }

  double getScore(String data) {
    int score = 0;

    _engine(filter, data, (_) {
      score++;
    }, (_) {});

    return score / (data.characters.length+1);
  }

  // TODO improve fuzzy search

  RichText getMatching(String data, BuildContext context) {
    List<TextSpan> children = [];

    _engine(
      filter,
      data,
      (c) {
        children.add(
          TextSpan(
            text: c,
            style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
          ),
        );
      },
      (c) {
        children.add(TextSpan(text: c));
      },
    );

    return RichText(
      text: TextSpan(style: Theme.of(context).textTheme.bodyLarge, children: children),
    );
  }
}
