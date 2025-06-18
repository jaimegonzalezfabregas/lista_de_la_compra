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

    widget.elements.sort((T a, T b) {
      return widget.elementToTag(a).toLowerCase().compareTo(widget.elementToTag(b).toLowerCase());
    });
    widget.elements.sort((a, b) => filterScorer.getScore(widget.elementToTag(b)) - filterScorer.getScore(widget.elementToTag(a)));

    var items = widget.elements.map((e) => widget.elementToListTile(e, filterScorer.getMatching(widget.elementToTag(e), context))).toList();

    if (widget.newElement != null) {
      if (filter != "" && !widget.elements.map(widget.elementToTag).any((tag) => tag == filter)) {
        items.insert(
          0,
          ListTile(
            title: ElevatedButton(
              child: Text("${appLoc.add} \"$filter\""),
              onPressed: () {
                widget.newElement!(filter);
                setState(() {
                  filter = "";
                  _textEditingController.text = "";
                });
              },
            ),
          ),
        );
      }
    }
    ScrollController scrollController = ScrollController();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(border: OutlineInputBorder(), labelText: appLoc.search),
            controller: _textEditingController,
            onChanged:
                (value) => setState(() {
                  filter = value;
                  if (value != "") {
                    scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Easing.emphasizedAccelerate);
                  }
                }),
          ),
        ),
        Expanded(child: ListView(children: items, controller: scrollController)),
      ],
    );
  }
}

class Searchablelistview<T> extends StatefulWidget {
  final List<T> elements;
  final ListTile Function(T, RichText) elementToListTile;
  final String Function(T) elementToTag;
  final void Function(String)? newElement;
  final void Function(T)? elementToSubtitle;

  const Searchablelistview({
    required this.elements,
    required this.elementToListTile,
    required this.elementToTag,
    this.elementToSubtitle,
    this.newElement,
    super.key,
  });

  @override
  createState() => _SearchableListview<T>();
}
