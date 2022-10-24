import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/catagory_model/category_model.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final double amount;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final CategoryType type;
  @HiveField(3)
  final CategoryModel category;
  @HiveField(4)
  String? id;

  TransactionModel({
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
  }) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
  }
}
