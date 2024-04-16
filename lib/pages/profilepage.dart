import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/employee.dart';
import 'package:flutter_application_1/providers/auth.dart';
import 'package:flutter_application_1/providers/database.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

 Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Profile"),
    ),
    body: StreamBuilder<Employee>(
      stream: dbService.employee.stream, // Assuming dbService.employee is a ValueStream<Employee>
      builder: (BuildContext context, AsyncSnapshot<Employee> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator()); // Display a loading indicator while waiting for data
            default:
              if (!snapshot.hasData) {
                return Text('No data available'); // Handle the case where no data is available
              } else {
                // Access the employee data from snapshot.data
                final employee = snapshot.data!;
                return Container(
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.person,
                            size: 50.0,
                          ),
                          title: Text(employee.name!), // Accessing employee name
                          subtitle: Text(employee.email), // Accessing employee email
                          trailing: IconButton(
                            icon: Icon(Icons.exit_to_app),
                            tooltip: "Logout",
                            onPressed: () {
                              authService.logout().then((_) {
                                Navigator.pushReplacementNamed(context, "/login");
                              }).catchError((error) {
                                if (error.toString().contains("NOINTERNET")) {
                                  const snackbar = SnackBar(
                                    content: Text("No internet connection"),
                                    backgroundColor: Colors.grey,
                                    elevation: 10,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(5),
                                    duration: Durations.short3,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                } else {
                                  print(error);
                                  if (error.toString().contains("NOINTERNET")) {
                                    const snackbar = SnackBar(
                                      content: Text("No internet connection"),
                                      backgroundColor: Colors.grey,
                                      elevation: 10,
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.all(5),
                                      duration: Durations.short3,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                  }
                                }
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
          }
        }
      },
    ),
  );
}
}