
 import 'package:hive/hive.dart';
 part 'person_model.g.dart';

 @HiveType(typeId: 1)
 class Person {
   @HiveField(0)
   String name;

   @HiveField(1)
   int age;

   @HiveField(2)
   ContactDetail contactDetail;

   Person(this.name, this.age, this.contactDetail);
 }


@HiveType(typeId: 2)
class ContactDetail{
    @HiveField(0)
   String email;
    @HiveField(1)
   double mobileNumber;

    ContactDetail(this.email, this.mobileNumber);

 }