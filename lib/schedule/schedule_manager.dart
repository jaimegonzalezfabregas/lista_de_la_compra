import 'package:flutter/material.dart';
import 'package:jhopping_list/recipies/recipe_provider.dart';
import 'package:jhopping_list/schedule/schedule_provider.dart';
import 'package:provider/provider.dart';

const int millisCorrectionToEpoc = 342000000;
const int millisInAWeek = 1000 * 60 * 60 * 24 * 7;
const List<String> weekDays = [
  "Lunes",
  "Martes",
  "Miercoles",
  "Jueves",
  "Viernes",
  "Sábado",
  "Domingo",
];
const List<String> months = [
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
      ((DateTime.now().millisecondsSinceEpoch - millisCorrectionToEpoc) /
              millisInAWeek)
          .floor();
  @override
  Widget build(BuildContext context) {
    ScheduleProvider scheduleProvider = context.watch();
    RecipeProvider recipeProvider = context.watch();

    DateTime time = DateTime.fromMillisecondsSinceEpoch(
      currentWeek * millisInAWeek + millisCorrectionToEpoc,
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
            "${weekDays[dayI]} ${dayTime.day} ${months[dayTime.month]}",
          ),
          subtitle: FutureBuilder(
            future: (() => scheduleProvider.getEntries(currentWeek, dayI))(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("Loading... $snapshot");
              }
              return Column(
                children:
                    snapshot.data!.map((entry) {
                      return FutureBuilder(
                        future: recipeProvider.getRecipeById(entry.recipeId),

                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text("Loading...");
                          }
                          if (snapshot.data == null) {
                            return Text("Error");
                          }
                          return Text(snapshot.data!.name);
                        },
                      );
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
              "Semana del ${time.day} de ${months[time.month]} de ${time.year}",
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
