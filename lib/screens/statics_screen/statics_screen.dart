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

  List<String> items = [
    'Income',
    'Expense',
  ];

  List<TransactionModel> transactions =
      TransactionDB.instance.transactionListNotifier.value;

  List<CategoryModel> expCategories =
      CategoryDB.instance.expenseCategoryListNotifier.value;

  List<CategoryModel> incCategories =
      CategoryDB.instance.incomeCategoryListNotifier.value;

  String? selectedItem;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton(
          borderRadius: BorderRadius.circular(18),
          hint: const Text(
            'Income',
            style: TextStyle(color: Colors.black),
          ),
          value: selectedItem,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (item) {
            setState(() {
              selectedItem = item;
            });
          },
        ),
        Expanded(
            child: selectedItem == items[1]
                ? PieChart(
                    swapAnimationCurve: Curves.linear,
                    PieChartData(
                      centerSpaceRadius: 70,
                      sectionsSpace: 5,
                      sections: [
                        for (var i = 0; i < incCategories.length; i++)
                          PieChartSectionData(
                            title: TransactionDB.instance
                                .incomeTransactionNotifier.value[i].amount
                                .toString(),
                            color: colorList[i],
                            value: TransactionDB.instance
                                .incomeTransactionNotifier.value[i].amount,
                            radius: 40,
                          ),
                      ],
                    ),
                  )
                : PieChart(
                    PieChartData(
                      centerSpaceRadius: 70,
                      sectionsSpace: 5,
                      sections: [
                        for (var i = 0; i < expCategories.length; i++)
                          PieChartSectionData(
                            title: TransactionDB.instance
                                .allIncomeAmount()
                                .toString(),
                            value: TransactionDB.instance.allIncomeAmount(),
                            color: Colors.greenAccent,
                            radius: 40,
                          ),
                        PieChartSectionData(
                          title: TransactionDB.instance
                              .allExpenseAmount()
                              .toString(),
                          value: TransactionDB.instance.allExpenseAmount(),
                          color: Colors.red,
                          radius: 40,
                        ),
                      ],
                    ),
                  )),
      ],
    );
  }
}
