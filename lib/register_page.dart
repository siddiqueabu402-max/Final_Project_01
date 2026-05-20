import 'package:final_project/converter_page.dart';
import 'package:final_project/widget/input_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Registerpage();
  }
}

class _Registerpage extends State<Registerpage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

  bool _isloading = false;

  final _supabase = Supabase.instance.client;

  // PASSWORD REGEX
  final RegExp passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@()$!%*?&])[A-Za-z\d@()$!%*?&]{8,}$',
  );

  void register() async {
    String name = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    setState(() {
      _isloading = true;
    });

    try {
      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = authResponse.user;

      if (user != null) {
        await _supabase.from('profiles').insert({
          'id': user.id,
          'name': name,
          'email': email,
        });
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(content: Text("Registered")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConverterPage(),
        ),
      );
    } on AuthApiException catch (e) {
      setState(() {
        _isloading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }

    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmpasswordController.clear();

    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Pets.co",
          style: GoogleFonts.montserrat(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: SizedBox(
          height: 400,
          width: 300,
          child: Card(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign Up",
                      style: GoogleFonts.montserrat(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    InputField(
                      controller: usernameController,
                      keyboardType: TextInputType.text,
                      validator: (value) =>
                          value!.isEmpty ? "Enter username" : null,
                      hintText: "Name",
                      labelText: "Username",
                      
                      prefixIcon: Icons.account_circle,
                    ),

                    SizedBox(height: 10),

                    InputField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value!.isEmpty ? "Enter email" : null,
                      hintText: "Enter Email",
                      labelText: "Email",
                      prefixIcon: Icons.email,
                    ),

                    SizedBox(height: 10),

                    // PASSWORD FIELD
                    InputField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter password";
                        }

                        if (!passwordRegex.hasMatch(value)) {
                          return "Min 8 char, Upper, Lower, Number & Special";
                        }

                        return null;
                      },
                      hintText: "Enter Password",
                      labelText: "Password",
                      prefixIcon: Icons.lock,
                      isPassword: true,
                    ),

                    SizedBox(height: 10),

                    // CONFIRM PASSWORD FIELD
                    InputField(
                      controller: confirmpasswordController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Confirm Password";
                        }

                        if (value != passwordController.text) {
                          return "Password does not match";
                        }

                        return null;
                      },
                      hintText: "Confirm Password",
                      labelText: "Confirm Password",
                      prefixIcon: Icons.lock,
                      isPassword: true,
                    ),

                    SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          register();
                        }
                      },
                      child: _isloading
                          ? CircularProgressIndicator()
                          : Text(
                              "Sign Up",
                              style: GoogleFonts.montserrat(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),

                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}