import 'package:flutter/material.dart';
import 'package:fyp2/Navigation.dart';
import 'signup.dart';
import 'globalVar.dart';
import 'package:http/http.dart';
import 'dart:convert';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void showErrorMessage(message) {
    SnackBar snackBarMessage = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red[200],
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBarMessage);
  }

  void logInAPi(String email, password) async {
    Response response = await post(Uri.parse(liveURL + 'api/userSignIn'),
        body: {'emailAddress': email, 'password': password});
    var body = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      token = body['token'];
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    } else {
      setState(() {
        isLoading = false;
      });
      showErrorMessage(body['message']);
    }
  }

  bool isVisible = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return Scaffold(
        body: Center(
            child: SizedBox(
      width: 500,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: EdgeInsets.only(bottom: height * 0.03),
          child: const Text('Login', style: TextStyle(fontSize: 40)),
        ),
        SizedBox(
            width: width * 0.85,
            height: height * 0.09,
            child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) {
                  if (val != null) {
                    if (RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val)) {
                      return null;
                    } else {
                      return 'Enter a valid email address';
                    }
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                  labelText: AutofillHints.email,
                  labelStyle: TextStyle(
                      color: Color.fromRGBO(242, 140, 40, 5), fontSize: 20),
                  border: UnderlineInputBorder(),
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 25))),
        SizedBox(
            width: width * 0.85,
            height: height * 0.09,
            child: TextField(
                controller: passwordController,
                obscureText: isVisible,
                decoration: InputDecoration(
                    labelText: AutofillHints.password,
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(242, 140, 40, 5), fontSize: 20),
                    border: UnderlineInputBorder(),
                    isDense: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isVisible ? Icons.visibility : Icons.visibility_off,
                        color: Color.fromARGB(255, 255, 115, 0),
                      ),
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                    )),
                style: const TextStyle(fontSize: 25))),
        Padding(
            padding: EdgeInsets.only(top: height * 0.05, bottom: height * 0.03),
            child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 255, 115, 0)),
                  foregroundColor: MaterialStatePropertyAll(Colors.black),
                  fixedSize: MaterialStatePropertyAll(Size.fromWidth(200)),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                        color: Colors.black,
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(fontSize: 30),
                      ),
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  logInAPi(emailController.text.toString(),
                      passwordController.text.toString());
                })),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Center(
              child: Text(
            'Donot have Account?',
            style: TextStyle(color: Colors.black),
          )),
          GestureDetector(
              child: const Text(' Sign Up'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignUpScreen())))
        ]),
      ]),
    )));
  }
}
