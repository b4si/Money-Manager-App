// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import '../../catagory_model/category_model.dart';

const categoryDbName = 'category-database';

abstract class CategoryDbFunctons {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryID);
}

class CategoryDB implements CategoryDbFunctons {
  CategoryDB._internal();

  static CategoryDB instance = CategoryDB._internal();

  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategoryListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListNotifier =
      ValueNotifier([]);
  @override
  Future<void> insertCategory(CategoryModel value) async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    categoryDB.put(value.id, value);
    refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    return categoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    final allCategories = await getCategories();
    incomeCategoryListNotifier.value.clear();
    expenseCategoryListNotifier.value.clear();
    await Future.forEach(
      allCategories,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          incomeCategoryListNotifier.value.add(category);
        } else {
          expenseCategoryListNotifier.value.add(category);
        }
      },
    );

    incomeCategoryListNotifier.notifyListeners();
    expenseCategoryListNotifier.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    // ignore: no_leading_underscores_for_local_identifiers
    final _categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    await _categoryDB.delete(categoryID);
    refreshUI();
  }
}
