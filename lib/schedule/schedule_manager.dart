import 'package:flutter/material.dart';
import 'package:jhopping_list/recipies/recipe_provider.dart';
import 'package:jhopping_list/schedule/day_view.dart';
import 'package:jhopping_list/schedule/schedule_provider.dart';
import 'package:jhopping_list/schedule/utils.dart';
import 'package:provider/provider.dart';

class _ScheduleView extends State {
  int currentWeek;

  _ScheduleView(this.currentWeek);

  @override
  Widget build(BuildContext context) {
    DateTime startOfWeekTime = getStartOfWeek(currentWeek);

    List<Widget> days = [];
    for (var dayI = 0; dayI < 7; dayI++) {
      days.add(DayView(currentWeek, dayI, startOfWeekTime));
    }

    List<Widget> head = [
      Center(
        child: Text(
          "${startOfWeekTime.day} de ${months[startOfWeekTime.month]} de ${startOfWeekTime.year}",
        ),
      ),
    ];

    if (currentWeek != getCurrentWeek()) {
      head.add(
        IconButton(
          icon: Icon(Icons.date_range),
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
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: head,
                ),
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
        Expanded(child: ListView(children: days)),
      ],
    );
  }
}

class ScheduleView extends StatefulWidget {
  final int initial_week;
  const ScheduleView(this.initial_week, {super.key});

  @override
  State<StatefulWidget> createState() => _ScheduleView(initial_week);
}

class ScheduleManager extends StatelessWidget {
  final initial_week;

  const ScheduleManager(this.initial_week, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Agenda",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: ScheduleView(initial_week),
    );
  }
}
