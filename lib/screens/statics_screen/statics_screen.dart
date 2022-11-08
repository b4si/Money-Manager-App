import 'package:flutter/material.dart';
import 'package:money_manager/screens/settings_screen/settings_screen.dart';
import 'package:money_manager/screens/statics_screen/all_expense_chart.dart';
import 'package:money_manager/screens/statics_screen/all_income_chart.dart';
import 'package:money_manager/screens/statics_screen/all_income_expense_chart.dart';

class StaticsScreen extends StatefulWidget {
  const StaticsScreen({super.key});

  @override
  State<StaticsScreen> createState() => _StaticsScreenState();
}

class _StaticsScreenState extends State<StaticsScreen>
    with SingleTickerProviderStateMixin {
  // List<Color> colorList = [
  //   Colors.red,
  //   Colors.greenAccent,
  //   Colors.blue,
  //   Colors.yellow,
  //   Colors.purpleAccent,
  //   Colors.brown,
  // ];

  late TabController newTabcontroller;
  @override
  void initState() {
    newTabcontroller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            labelColor: Colors.black,
            controller: newTabcontroller,
            tabs: const [
              Tab(
                text: "All",
              ),
              Tab(
                text: 'Income',
              ),
              Tab(
                text: "Expense",
              )
            ]),
        SizedBox(
          width: double.infinity,
          height: 500,
          child: TabBarView(controller: newTabcontroller, children: const [
            PieCahrt(),
            AllIncomeChart(),
            AllExpenseChart(),
          ]),
        ),
      ],
    );
  }
}
