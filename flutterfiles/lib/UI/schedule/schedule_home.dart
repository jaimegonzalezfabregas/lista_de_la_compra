import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_la_compra/UI/AI/ai_home.dart';
import 'package:lista_de_la_compra/UI/schedule/day_view.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/flutter_providers/flutter_providers.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

class ScheduleHome extends StatefulWidget {
  final int initialWeek;
  final String enviromentId;

  const ScheduleHome(this.initialWeek, this.enviromentId, {super.key});

  @override
  State<ScheduleHome> createState() => _ScheduleHomeState();
}

class _ScheduleHomeState extends State<ScheduleHome> {
  late int currentWeek;

  @override
  void initState() {
    super.initState();
    currentWeek = widget.initialWeek;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    DateTime startOfWeekTime = getStartOfWeek(currentWeek);

    List<Widget> head = [];

    if (currentWeek > getCurrentWeek()) {
      head.add(
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              currentWeek = getCurrentWeek();
            });
          },
        ),
      );
    }

    head.add(Center(child: Text(DateFormat('yMMMd').format(startOfWeekTime))));

    if (currentWeek < getCurrentWeek()) {
      head.add(
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            setState(() {
              currentWeek = getCurrentWeek();
            });
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appLoc.planner, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AiHome(widget.enviromentId);
                  },
                ),
              );
            },
            icon: Icon(Icons.bubble_chart),
          ),
          PopupMenuButton<String>(
            onSelected: (s) {},
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Row(children: [Icon(Icons.output), SizedBox(width: 8), Text(appLoc.exportToMarkdownFile)]),
                  onTap: () => _exportToMarkdownFile(context),
                ),
                PopupMenuItem(
                  child: Row(children: [Icon(Icons.edit_calendar), SizedBox(width: 8), Text(appLoc.exportToICS)]),
                  onTap: () => _exportToICS(context),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 30,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      currentWeek--;
                    });
                  },
                  child: Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: head),
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      currentWeek++;
                    });
                  },
                  child: Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: 7,
              itemBuilder: (context, index) => DayView(currentWeek, index, startOfWeekTime, widget.enviromentId),
              separatorBuilder: (context, index) => Divider(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportToICS(BuildContext context) async {
    final scheduleProvider = context.read<FlutterScheduleProvider>();
    final recipeProvider = context.read<FlutterRecipeProvider>();

    final StringBuffer ics = StringBuffer();
    ics.writeln('BEGIN:VCALENDAR');
    ics.writeln('VERSION:2.0');
    ics.writeln('PRODID:-//Lista de la Compra//EN');

    for (int day = 0; day < 7; day++) {
      final entries = await scheduleProvider.getEntries(currentWeek, day, widget.enviromentId);
      for (final entry in entries) {
        final recipe = await recipeProvider.getRecipeById(entry.recipeId);
        if (recipe == null) continue;
        final date = weekAndDayToDateTime(entry.week, entry.day);
        final dateStr = DateFormat('yyyyMMdd').format(date);
        ics.writeln('BEGIN:VEVENT');
        ics.writeln('DTSTART;VALUE=DATE:$dateStr');
        ics.writeln('DTEND;VALUE=DATE:$dateStr');
        ics.writeln('SUMMARY:${recipe.name}');
        ics.writeln('END:VEVENT');
      }
    }

    ics.writeln('END:VCALENDAR');

    final startOfWeek = getStartOfWeek(currentWeek);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(utf8.encode(ics.toString()), mimeType: 'text/calendar')],
        fileNameOverrides: ['schedule_week_${DateFormat('d_M_y').format(startOfWeek)}.ics'],
        downloadFallbackEnabled: true,
      ),
    );
  }

  Future<void> _exportToMarkdownFile(BuildContext context) async {
    final scheduleProvider = context.read<FlutterScheduleProvider>();
    final recipeProvider = context.read<FlutterRecipeProvider>();
    final startOfWeek = getStartOfWeek(currentWeek);

    final StringBuffer md = StringBuffer();
    md.writeln('# ${DateFormat('d/M/y').format(startOfWeek)}');

    for (int day = 0; day < 7; day++) {
      final date = startOfWeek.add(Duration(days: day));
      md.writeln('\n## ${DateFormat('EEEE d').format(date)}');
      final entries = await scheduleProvider.getEntries(currentWeek, day, widget.enviromentId);
      for (final entry in entries) {
        final recipe = await recipeProvider.getRecipeById(entry.recipeId);
        if (recipe == null) continue;
        md.writeln('- ${recipe.name}');
      }
    }

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(utf8.encode(md.toString()), mimeType: 'text/calendar')],
        fileNameOverrides: ['schedule_week_${DateFormat('y_M_d').format(startOfWeek)}.md'],
        downloadFallbackEnabled: true,
      ),
    );
  }
}
