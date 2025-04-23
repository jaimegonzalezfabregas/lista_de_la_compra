import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jhopping_list/recipies/recipe_provider.dart';
import 'package:jhopping_list/schedule/schedule_provider.dart';
import 'package:provider/provider.dart';

const int MILLIS_CORECTION_TO_EPOC = 342000000;
const int MILLIS_IN_A_WEEK = 1000 * 60 * 60 * 24 * 7;
const List<String> WEEK_DAYS = [
  "Lunes",
  "Martes",
  "Miercoles",
  "Jueves",
  "Viernes",
  "Sábado",
  "Domingo",
];
const List<String> MONTHS = [
  "",
  "Enero",
  "Febrero",
  "Marzo",
  "Abril",
  "Mayo",
  "Junio",
  "Juilo",
  "Agosto",
  "Septiembre",
  "Octubre",
  "Noviembre",
  "Diciembre",
];

class _ScheduleView extends State {
  int currentWeek =
      ((DateTime.now().millisecondsSinceEpoch - MILLIS_CORECTION_TO_EPOC) /
              MILLIS_IN_A_WEEK)
          .floor();
  @override
  Widget build(BuildContext context) {
    ScheduleProvider scheduleProvider = context.watch();
    RecipeProvider recipeProvider = context.watch();

    DateTime time = DateTime.fromMillisecondsSinceEpoch(
      currentWeek * MILLIS_IN_A_WEEK + MILLIS_CORECTION_TO_EPOC,
    );

    List<Widget> days = [];
    for (var dayI = 0; dayI < 7; dayI++) {
      var dayTime = time.add(Duration(hours: 24 * dayI));
      var currentDatetime = DateTime.now();
      var isToday =
          dayTime.day == currentDatetime.day &&
          dayTime.year == currentDatetime.year &&
          dayTime.month == currentDatetime.month;
      days.add(
        ListTile(
          tileColor:
              isToday ? Colors.blue.withValues(alpha: 0.3) : Colors.transparent,
          title: Text(
            "${WEEK_DAYS[dayI]} ${dayTime.day} ${MONTHS[dayTime.month]}",
          ),
          subtitle: FutureBuilder(
            future: (() => scheduleProvider.getEntries(currentWeek, dayI))(),
            builder: (context, snapshot) {
              
              if (!snapshot.hasData) {
                return Text("Loading... $snapshot");
              }
              return Column(
                children:
                    snapshot.data!.map((ScheduleEntry entry) {
                      Recipe recipe =
                          recipeProvider.getRecipeById(entry.recipeId)!;
                      return Text(recipe.name);
                    }).toList(),
              );
            },
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 30,
          children: [
            OutlinedButton(
              onPressed: () {
                setState(() {
                  currentWeek--;
                });
              },
              child: Text("Semana anterior"),
            ),
            Text(
              "Semana del ${time.day} de ${MONTHS[time.month]} de ${time.year}",
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  currentWeek++;
                });
              },
              child: Text("Semana siguiente"),
            ),
          ],
        ),
        Expanded(child: ListView(children: days)),
      ],
    );
  }
}

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<StatefulWidget> createState() => _ScheduleView();
}

class ScheduleManager extends StatelessWidget {
  const ScheduleManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agenda")),
      body: ScheduleView(),
    );
  }
}
