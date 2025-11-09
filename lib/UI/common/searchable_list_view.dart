import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/common/search_scorer.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';

class _SearchableListview<T> extends State<Searchablelistview<T>> {
  String filter = "";
  final TextEditingController _textEditingController = TextEditingController();

  _SearchableListview();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    var filterScorer = SearchScorer(filter);

    late List<T> showElements;

    if (filter != "") {
      final List<T>? searchElms = widget.elementsOnSearch;
      if (searchElms == null) {
        showElements = widget.elements;
      } else {
        showElements = searchElms;
      }

      showElements.sort((a, b) => ((filterScorer.getScore(widget.elementToTag(b)) - filterScorer.getScore(widget.elementToTag(a))) * 1000).floor());
    } else {
      widget.elements.sort((T a, T b) {
        return widget.elementToTag(a).toLowerCase().compareTo(widget.elementToTag(b).toLowerCase());
      });

      showElements = widget.elements;
    }
    List<ListTile> items = showElements.map((e) => widget.elementToListTile(e, filterScorer.getMatching(widget.elementToTag(e), context))).toList();

    if (widget.newElement != null) {
      if (filter != "" && !widget.elements.map(widget.elementToTag).any((tag) => tag == filter)) {
        items.insert(
          0,
          ListTile(
            title: ElevatedButton(
              child: Text("${appLoc.add} \"$filter\""),
              onPressed: () {
                widget.newElement!(filter);
              },
            ),
          ),
        );
      }
    }
    ScrollController scrollController = ScrollController();

    void onChanged(value) {
      setState(() {
        filter = value;
        if (value != "") {
          scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Easing.emphasizedAccelerate);
        }
      });
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: appLoc.search,
              suffixIcon: IconButton(
                onPressed: () {
                  _textEditingController.clear();
                  onChanged("");
                },
                icon: Icon(Icons.clear),
              ),
            ),
            controller: _textEditingController,
            onChanged: onChanged,
          ),
        ),
        Flexible(
          child: ListView(shrinkWrap: true, controller: scrollController, children: items),
        ),
        if (items.isEmpty)
          Flexible(
            child: Container(margin: EdgeInsets.all(20), child: Text(appLoc.thisListHasNoResults)),
          ),
      ],
    );
  }
}

class Searchablelistview<T> extends StatefulWidget {
  final List<T> elements;
  final List<T>? elementsOnSearch;
  final ListTile Function(T, RichText) elementToListTile;
  final String Function(T) elementToTag;
  final void Function(String)? newElement;

  const Searchablelistview({
    required this.elements,
    required this.elementToListTile,
    required this.elementToTag,
    this.newElement,
    this.elementsOnSearch,
    super.key,
  });

  @override
  createState() => _SearchableListview<T>();
}
