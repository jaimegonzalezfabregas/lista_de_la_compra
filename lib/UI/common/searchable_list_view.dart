import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/common/search_scorer.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';

class _SearchableListview<T> extends State<Searchablelistview<T>> {
  String filter = "";
  final TextEditingController _textEditingController = TextEditingController();

  _SearchableListview();

  Future<List<ListTile>> getShowTilesWithFilter(List<T> searchElms, String filter) async {
    var filterScorer = SearchScorer(filter);

    searchElms.sort((a, b) => widget.elementToTag(a).toLowerCase().compareTo(widget.elementToTag(b).toLowerCase()));

    late List<T> ret = searchElms;

    ret.sort((a, b) => ((filterScorer.getScore(widget.elementToTag(b)) - filterScorer.getScore(widget.elementToTag(a))) * 1000).floor());

    return ret.map((e) => widget.elementToListTile(e, filterScorer.getMatching(widget.elementToTag(e), context))).toList();
  }

  Future<List<ListTile>> getShowTilesWithoutFilter(List<T> elms) async {
    Map<String, List<T>> categoryMap = {};
    Map<String, String> categoryIdToName = {};
    List<T> uncategorizedElements = [];

    elms.sort((a, b) => widget.elementToTag(a).toLowerCase().compareTo(widget.elementToTag(b).toLowerCase()));

    if (widget.elementCategories != null) {
      for (var element in elms) {
        await widget.elementCategories!(element).then((categories) {
          for (var category in categories) {
            categoryIdToName[category.$1] = category.$2;
            if (!categoryMap.containsKey(category.$1)) {
              categoryMap[category.$1] = [];
            }
            categoryMap[category.$1]!.add(element);
          }
          if (categories.isEmpty) {
            uncategorizedElements.add(element);
          }
        });
      }
    } else {
      uncategorizedElements = elms;
    }

    List<ListTile> ret = [];

    if (uncategorizedElements.isNotEmpty) {
      ret.addAll(
        uncategorizedElements.map(
          (e) => widget.elementToListTile(
            e,
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyLarge,
                children: [TextSpan(text: widget.elementToTag(e))],
              ),
            ),
          ),
        ),
      );
    }

    categoryMap.keys.toList()
      ..sort((a, b) => categoryIdToName[a]!.toLowerCase().compareTo(categoryIdToName[b]!.toLowerCase()))
      ..forEach((categoryId) {
        ret.add(
          ListTile(
            title: Center(
              child: Text(categoryIdToName[categoryId]!, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        );
        var items = categoryMap[categoryId]!;
        items.sort((T a, T b) {
          return widget.elementToTag(a).toLowerCase().compareTo(widget.elementToTag(b).toLowerCase());
        });
        ret.addAll(
          items.map(
            (e) => widget.elementToListTile(
              e,
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [TextSpan(text: widget.elementToTag(e))],
                ),
              ),
            ),
          ),
        );
      });

    return ret;
  }

  Future<List<ListTile>> getShowTiles() {
    if (filter != "") {
      return getShowTilesWithFilter(widget.elementsOnSearch ?? widget.elements, filter);
    } else {
      return getShowTilesWithoutFilter(widget.elements);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;

    late Future<List<ListTile>> itemsFuture = getShowTiles();

    ScrollController scrollController = ScrollController();

    void onChanged(value) {
      setState(() {
        filter = value;
        if (value != "") {
          scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Easing.emphasizedAccelerate);
        }
      });
    }

    return FutureBuilder(
      future: itemsFuture,
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final List<ListTile> items = asyncSnapshot.data!;

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
      },
    );
  }
}

class Searchablelistview<T> extends StatefulWidget {
  final List<T> elements;
  final List<T>? elementsOnSearch;
  final ListTile Function(T, RichText) elementToListTile;
  final String Function(T) elementToTag;
  final void Function(String)? newElement;
  final Future<List<(String, String)>> Function(T)? elementCategories;

  const Searchablelistview({
    required this.elements,
    required this.elementToListTile,
    required this.elementToTag,
    this.newElement,
    this.elementsOnSearch,
    this.elementCategories,
    super.key,
  });

  @override
  createState() => _SearchableListview<T>();
}
