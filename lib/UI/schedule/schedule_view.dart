import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_la_compra/UI/schedule/day_view.dart';
import '../../../packages/lista_de_la_compra_backend/lib/src/utils.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';

class _ScheduleView extends State<ScheduleViewContents> {
  late int currentWeek;

  _ScheduleView(this.currentWeek);

  @override
  Widget build(BuildContext context) {
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

    return Column(
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
              Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: head)),
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
    );
  }
}

class ScheduleViewContents extends StatefulWidget {
  final int initialWeek;
  final String enviromentId;
  const ScheduleViewContents(this.initialWeek, this.enviromentId, {super.key});

  @override
  State<StatefulWidget> createState() => _ScheduleView(initialWeek);
}

class ScheduleView extends StatelessWidget {
  final int initialWeek;
  final String enviromentId;

  const ScheduleView(this.initialWeek, this.enviromentId, {super.key});


  @override
  Widget build(BuildContext context) {
        final AppLocalizations appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLoc.planner, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: ScheduleViewContents(initialWeek, enviromentId),
    );
  }
}
