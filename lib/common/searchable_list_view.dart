import 'package:flutter/material.dart';
import 'package:jhopping_list/common/search_scorer.dart';

class _SearchableListview<T> extends State<Searchablelistview<T>> {
  String filter = "";
  final TextEditingController _textEditingController = TextEditingController();

  _SearchableListview();

  @override
  Widget build(BuildContext context) {
    var filterScorer = SearchScorer(filter);

    widget.elements.sort((T a, T b) {
      return widget
          .elementToTag(a)
          .toLowerCase()
          .compareTo(widget.elementToTag(b).toLowerCase());
    });
    widget.elements.sort(
      (a, b) =>
          filterScorer.getScore(widget.elementToTag(b)) -
          filterScorer.getScore(widget.elementToTag(a)),
    );

    var items =
        widget.elements
            .map(
              (e) => widget.elementToListTile(
                e,
                filterScorer.getMatching(widget.elementToTag(e), context),
              ),
            )
            .toList();

    if (widget.newElement != null) {
      if (filter != "" &&
          !widget.elements
              .map(widget.elementToTag)
              .any((tag) => tag == filter)) {
        items.insert(
          0,
          ListTile(
            title: ElevatedButton(
              child: Text("Add \"$filter\""),
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Buscar',
            ),
            controller: _textEditingController,
            onChanged:
                (value) => setState(() {
                  filter = value;
                }),
          ),
        ),
        Expanded(child: ListView(children: items)),
      ],
    );
  }
}

class Searchablelistview<T> extends StatefulWidget {
  final List<T> elements;
  final ListTile Function(T, RichText) elementToListTile;
  final String Function(T) elementToTag;
  final void Function(String)? newElement;

  const Searchablelistview({
    required this.elements,
    required this.elementToListTile,
    required this.elementToTag,
    this.newElement,
    super.key,
  });

  @override
  createState() => _SearchableListview<T>();
}
