import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/catagory_model/category_model.dart';
import 'package:money_manager/db/category_db/category_db.dart';
import 'package:money_manager/db/transaction_db/transaction_db.dart';
import '../../transaction_model/transaction_model.dart';

class StaticsScreen extends StatefulWidget {
  const StaticsScreen({super.key});

  @override
  State<StaticsScreen> createState() => _StaticsScreenState();
}

class _StaticsScreenState extends State<StaticsScreen> {
  List<Color> colorList = [
    Colors.red,
    Colors.greenAccent,
    Colors.blue,
    Colors.yellow,
    Colors.purpleAccent,
    Colors.brown,
  ];

  // List<String> items = [
  //   'Income',
  //   'Expense',
  // ];

  List<TransactionModel> transactions =
      TransactionDB.instance.transactionListNotifier.value;

  List<CategoryModel> expCategories =
      CategoryDB.instance.expenseCategoryListNotifier.value;

  List<CategoryModel> incCategories =
      CategoryDB.instance.incomeCategoryListNotifier.value;
  double? totalIncomeAmount;
  double? totalExpenseAmount;

  @override
  void initState() {
    totalIncomeAmount = TransactionDB.instance.allIncomeAmount();
    totalExpenseAmount = TransactionDB.instance.allExpenseAmount();
    super.initState();
  }

  int value1 = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton(
          borderRadius: BorderRadius.circular(18),
          value: value1,
          items: [
            DropdownMenuItem(
              value: 1,
              onTap: () {
                setState(() {
                  totalIncomeAmount = TransactionDB.instance.allIncomeAmount();
                  totalExpenseAmount =
                      TransactionDB.instance.allExpenseAmount();
                });
              },
              child: const Text('Total'),
            ),
            DropdownMenuItem(
              value: 2,
              onTap: () {
                setState(() {
                  totalIncomeAmount =
                      TransactionDB.instance.alltodayIncomeAmount();
                  totalExpenseAmount =
                      TransactionDB.instance.alltodayExpenseAmount();
                });
              },
              child: const Text('Today'),
            ),
            DropdownMenuItem(
              value: 3,
              onTap: () {},
              child: const Text('Monthly'),
            ),
          ],
          onChanged: (value) {
            value1 = value!;
          },
        ),
        Expanded(
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 70,
              sectionsSpace: 5,
              sections: [
                PieChartSectionData(
                  title: totalIncomeAmount.toString(),
                  value: totalIncomeAmount,
                  color: Colors.greenAccent,
                  radius: 40,
                ),
                PieChartSectionData(
                  title: totalExpenseAmount.toString(),
                  value: totalExpenseAmount,
                  color: Colors.redAccent,
                  radius: 40,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 150),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    backgroundColor: Colors.greenAccent,
                    radius: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Income'),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    radius: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text('Expense'),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
