import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'model/person_model.dart';

late Box box;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(ContactDetailAdapter());
  box = await Hive.openBox("userBox");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Person> allUser = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  addPerson() {
    Person newPerson = Person(
      nameController.text,
      int.parse(ageController.text),
      ContactDetail(
          emailController.text, double.parse(mobileNumberController.text)),
    );
    if (kDebugMode) {
      print(newPerson);
    }

    box.add(Person(
        nameController.text,
        int.parse(ageController.text),
        ContactDetail(
            emailController.text, double.parse(mobileNumberController.text))));
    if (kDebugMode) {
      print(box.getAt(0));
    }
    for (var element in box.values) {
      allUser.add(element);
      if (kDebugMode) {
        print((element));
      }
    }

    //  box.put(newPerson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            buildSizeBox(10),
            customTextField("name", nameController),
            buildSizeBox(10),
            customTextField("age", ageController),
            buildSizeBox(10),
            customTextField("email", emailController),
            buildSizeBox(10),
            customTextField("mobileNumber", mobileNumberController),
            buildSizeBox(10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder(
                  valueListenable: box.listenable(),
                  builder: (context, Box box, widget) {
                    if (box.isEmpty) {
                      return const Center(
                        child: Text('Empty'),
                      );
                    } else {
                      return ListView.builder(
                           scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: allUser.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                                elevation: 5,
                                child: Column(
                                  children: [
                                    Text(allUser[index].name),
                                    Text(allUser[index].age.toString()),
                                    Text(allUser[index].contactDetail.email),
                                    Text(allUser[index]
                                        .contactDetail
                                        .mobileNumber
                                        .toString()),
                                  ],
                                ));
                          });
                    }
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addPerson(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  SizedBox buildSizeBox(double height) {
    return SizedBox(
      height: height,
    );
  }

  TextFormField customTextField(
    String text,
    TextEditingController controller,
  ) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        if (controller == emailController &&
            !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
          return "Please enter valid email";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: text,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
    );
  }
}
