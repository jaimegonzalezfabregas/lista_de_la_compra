import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_la_compra/UI/schedule/day_view.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/flutter_providers/flutter_providers.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:device_calendar_plus/device_calendar_plus.dart';

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
  String? selectedHouseId;

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

    final houseProvider = context.watch<FlutterHouseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLoc.planner, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        actions: <Widget>[
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
                PopupMenuItem(
                  child: Row(children: [Icon(Icons.calendar_month), SizedBox(width: 8), Text(appLoc.exportToGoogleCalendar)]),
                  onTap: () => _exportToCalendar(context),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List<House>>(
              future: houseProvider.getHouseList(widget.enviromentId),
              builder: (context, snapshot) {
                final houses = snapshot.data ?? [];
                if (houses.isEmpty) return SizedBox.shrink();

                return DropdownButtonFormField<String>(
                  value: selectedHouseId,
                  decoration: InputDecoration(
                    labelText: appLoc.houses,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: houses.map((h) => DropdownMenuItem(value: h.id, child: Text(h.name))).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedHouseId = val;
                      });
                    }
                  },
                );
              },
            ),
          ),
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
            child: selectedHouseId == null
                ? SizedBox.shrink()
                : ListView.separated(
                    itemCount: 7,
                    itemBuilder: (context, index) => DayView(currentWeek, index, startOfWeekTime, widget.enviromentId, selectedHouseId!),
                    separatorBuilder: (context, index) => Divider(),
                  ),
          ),
        ],
      ),
    );
  }

  bool _checkHouseSelected(BuildContext context){
    if (selectedHouseId == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.noHouseSelected)),
        );
      }
    }
    return selectedHouseId != null;
  }
  
  Future<void> _exportToICS(BuildContext context) async {
    if( !_checkHouseSelected(context) ){
       return;
    };
    final scheduleProvider = context.read<FlutterScheduleProvider>();
    final recipeProvider = context.read<FlutterRecipeProvider>();

    final StringBuffer ics = StringBuffer();
    ics.writeln('BEGIN:VCALENDAR');
    ics.writeln('VERSION:2.0');
    ics.writeln('PRODID:-//Lista de la Compra//EN');

    final houseIds = [selectedHouseId!];

    for (int day = 0; day < 7; day++) {
      for (final houseId in houseIds) {
        final entries = await scheduleProvider.getEntries(currentWeek, day, widget.enviromentId, houseId);
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

  Future<Calendar?> _pickCalendar() async {
    final appLoc = AppLocalizations.of(context);
    if (appLoc == null) return null;

    final plugin = DeviceCalendar.instance;
    final status = await plugin.requestPermissions();
    if (status != CalendarPermissionStatus.granted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appLoc.calendarPermissionDenied)),
        );
      }
      return null;
    }

    final calendars = await plugin.listCalendars();
    if (calendars.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appLoc.noMappingDataAviable)),
        );
      }
      return null;
    }

    if (!context.mounted) return null;
    return showDialog<Calendar>(
      context: context,
      builder: (ctx) {
        String? selectedId;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(appLoc.selectCalendar),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: calendars.map((cal) {
                    return RadioListTile<String>(
                      title: Text(cal.name ?? ''),
                      value: cal.id,
                      groupValue: selectedId,
                      onChanged: (val) {
                        setDialogState(() {
                          selectedId = val;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(appLoc.cancel),
                ),
                FilledButton(
                  onPressed: selectedId == null
                      ? null
                      : () => Navigator.of(ctx).pop(calendars.firstWhere((c) => c.id == selectedId)),
                  child: Text(appLoc.export),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _exportToCalendar(BuildContext context) async {
    if( !_checkHouseSelected(context) ){
       return;
    };
    final appLoc = AppLocalizations.of(context)!;
    final plugin = DeviceCalendar.instance;

    final selected = await _pickCalendar();
    if (selected == null) return;

    final scheduleProvider = context.read<FlutterScheduleProvider>();
    final recipeProvider = context.read<FlutterRecipeProvider>();

    final houseIds = [selectedHouseId!];

    int eventCount = 0;

    for (int day = 0; day < 7; day++) {
      for (final houseId in houseIds) {
        final entries = await scheduleProvider.getEntries(currentWeek, day, widget.enviromentId, houseId);
        for (final entry in entries) {
          final recipe = await recipeProvider.getRecipeById(entry.recipeId);
          if (recipe == null) continue;
          final date = weekAndDayToDateTime(entry.week, entry.day);
          try {
            await plugin.createEvent(
              calendarId: selected.id,
              title: recipe.name,
              startDate: date,
              endDate: date.add(const Duration(days: 1)),
              isAllDay: true,
            );
            eventCount++;
          } on DeviceCalendarException catch (_) {}
        }
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${appLoc.eventsAddedToCalendar(eventCount)} (${selected.name ?? ''})')),
      );
    }
  }

  Future<void> _exportToMarkdownFile(BuildContext context) async {
    if( !_checkHouseSelected(context) ){
       return;
    };
    final scheduleProvider = context.read<FlutterScheduleProvider>();
    final recipeProvider = context.read<FlutterRecipeProvider>();
    final startOfWeek = getStartOfWeek(currentWeek);

    final StringBuffer md = StringBuffer();
    md.writeln('# ${DateFormat('d/M/y').format(startOfWeek)}');

    final houseIds = [selectedHouseId!];

    for (int day = 0; day < 7; day++) {
      final date = startOfWeek.add(Duration(days: day));
      md.writeln('\n## ${DateFormat('EEEE d').format(date)}');
      for (final houseId in houseIds) {
        final entries = await scheduleProvider.getEntries(currentWeek, day, widget.enviromentId, houseId);
        for (final entry in entries) {
          final recipe = await recipeProvider.getRecipeById(entry.recipeId);
          if (recipe == null) continue;
          md.writeln('- ${recipe.name}');
        }
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
