import 'package:flutter/material.dart';
import 'package:money_manager/db/category_db/category_db.dart';
import '../catagory_model/category_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<String> items = [
    'Income',
    'Expense',
  ];
  String? selectedItem;
  @override
  void initState() {
    CategoryDB().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
            ],
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: (selectedItem == items[1]
                  ? CategoryDB().expenseCategoryListNotifier
                  : CategoryDB().incomeCategoryListNotifier),
              builder:
                  (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: newList.length,
                  itemBuilder: (ctx, index) {
                    final category = newList[index];
                    return Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(category.name),
                          ),
                          IconButton(
                              onPressed: () {
                                CategoryDB.instance.deleteCategory(category.id);
                              },
                              icon: const Icon(Icons.delete))
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
