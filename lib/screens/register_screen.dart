import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:myrideup/global/global.dart';
import 'package:myrideup/global/utils/functions.dart';
import 'package:myrideup/global/utils/toast.dart';
import 'package:myrideup/screens/login_screen.dart';
import 'package:myrideup/screens/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _passwordVisible = false;
  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmTextEditingController = TextEditingController();

  // //declare a global key
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    //validate all the form fields
    if (_formKey.currentState!.validate()) {
      await firebaseAuth
          .createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      )
          .then((UserCredential auth) async {
        currentUser = auth.user;
        if (currentUser != null) {
          Map userMap = {
            "id": currentUser!.uid,
            "name": nameTextEditingController.text.trim(),
            "email": emailTextEditingController.text.trim(),
            "phone": phoneTextEditingController.text.trim(),
          };
          DatabaseReference userRef =
              FirebaseDatabase.instance.ref().child("users");
          userRef.child(currentUser!.uid).set(userMap);
        }
        showToast("User created successfully");
        // ignore: use_build_context_synchronously

        switchScreen(
          context,
          builder: (context) => const MainScreen(),
        );
      }).catchError((errorMessage) {
        Fluttertoast.showToast(msg: "Error Occured: \n $errorMessage");
      });
    } else {
      Fluttertoast.showToast(msg: "Not all fields are valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              Column(
                children: [
                  Image.asset(darkTheme
                      ? 'assets/images/boat.jpg'
                      : 'assets/images/bluescene.jpg'),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Register',
                    style: TextStyle(
                      color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    decoration: InputDecoration(
                                      hintText: "Name",
                                      hintStyle: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                      filled: true,
                                      fillColor: darkTheme
                                          ? Colors.black45
                                          : Colors.grey.shade200,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: darkTheme
                                            ? Colors.amber.shade400
                                            : Colors.grey,
                                      ),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return "Name can't be empty";
                                      }
                                      if (text.length < 2) {
                                        return "Please enter valid a name";
                                      }
                                      if (text.length > 49) {
                                        return "Name can't be more than 50";
                                      }
                                      return null;
                                    },
                                    onChanged: (text) => setState(() {
                                      nameTextEditingController.text = text;
                                    }),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(100),
                                    ],
                                    decoration: InputDecoration(
                                      hintText: "Email",
                                      hintStyle: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                      filled: true,
                                      fillColor: darkTheme
                                          ? Colors.black45
                                          : Colors.grey.shade200,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: darkTheme
                                            ? Colors.amber.shade400
                                            : Colors.grey,
                                      ),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return "Email can't be empty";
                                      }
                                      if (EmailValidator.validate(text) ==
                                          true) {
                                        return null;
                                      }
                                      if (text.length < 2) {
                                        return "Please enter valid a email";
                                      }
                                      if (text.length > 49) {
                                        return "Email can't be more than 50";
                                      }
                                      return null;
                                    },
                                    onChanged: (text) => setState(() {
                                      emailTextEditingController.text = text;
                                    }),
                                  ),
                                  const SizedBox(height: 10),
                                  IntlPhoneField(
                                    showCountryFlag: true,
                                    dropdownIcon: Icon(
                                      Icons.arrow_drop_down,
                                      color: darkTheme
                                          ? Colors.amber.shade400
                                          : Colors.grey,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Phone",
                                      hintStyle: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                      filled: true,
                                      fillColor: darkTheme
                                          ? Colors.black45
                                          : Colors.grey.shade200,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: darkTheme
                                            ? Colors.amber.shade400
                                            : Colors.grey,
                                      ),
                                    ),
                                    initialCountryCode: 'GH',
                                    onChanged: (text) => setState(() {
                                      phoneTextEditingController.text =
                                          text.completeNumber;
                                    }),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    obscureText: !_passwordVisible,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                        filled: true,
                                        fillColor: darkTheme
                                            ? Colors.black45
                                            : Colors.grey.shade200,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: darkTheme
                                              ? Colors.amber.shade400
                                              : Colors.grey,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: darkTheme
                                                ? Colors.amber.shade400
                                                : Colors.grey,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _passwordVisible =
                                                  !_passwordVisible;
                                            });
                                          },
                                        )),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return "Password can't be empty";
                                      }
                                      if (text.length < 6) {
                                        return "Please enter valid password";
                                      }
                                      if (text.length > 49) {
                                        return "Password can't be more than 50";
                                      }
                                      return null;
                                    },
                                    onChanged: (text) => setState(() {
                                      passwordTextEditingController.text = text;
                                    }),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    obscureText: !_passwordVisible,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    decoration: InputDecoration(
                                        hintText: "Confirm  Password",
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                        filled: true,
                                        fillColor: darkTheme
                                            ? Colors.black45
                                            : Colors.grey.shade200,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: darkTheme
                                              ? Colors.amber.shade400
                                              : Colors.grey,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: darkTheme
                                                ? Colors.amber.shade400
                                                : Colors.grey,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _passwordVisible =
                                                  !_passwordVisible;
                                            });
                                          },
                                        )),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return "Password can't be empty";
                                      }
                                      if (text !=
                                          passwordTextEditingController.text) {
                                        return 'Password do not match';
                                      }
                                      if (text.length < 6) {
                                        return "Please enter valid password";
                                      }
                                      if (text.length > 49) {
                                        return "Password can't be more than 50";
                                      }
                                      return null;
                                    },
                                    onChanged: (text) => setState(() {
                                      confirmTextEditingController.text = text;
                                    }),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: darkTheme
                                            ? Colors.black
                                            : Colors.white,
                                        backgroundColor: darkTheme
                                            ? Colors.amber.shade400
                                            : Colors.blue,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32)),
                                        minimumSize:
                                            const Size(double.infinity, 50)),
                                    onPressed: () {
                                      _submit();
                                    },
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Already have an account?',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (c) =>
                                                      const LoginScreen()));
                                        },
                                        child: Text(
                                          'Sign In',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: darkTheme
                                                  ? Colors.amber.shade400
                                                  : Colors.blue),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
