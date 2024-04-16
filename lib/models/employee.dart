
import 'package:flutter_application_1/models/role.dart';
import 'package:flutter_application_1/models/shop.dart';

class Employee{
  final String? name;
  final List<Shop>? shops;
  final String email;
  final Role? roles;
  final bool? active;


  const Employee({
    required this.name,
    required this.shops,
    required this.email,
    required this.active,
    this.roles,
  });
}