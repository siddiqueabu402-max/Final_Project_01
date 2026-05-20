import 'package:final_project/home_page.dart';
import 'package:final_project/register_page.dart';
import 'package:final_project/widget/input_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ConverterPageState();
  }
}

class _ConverterPageState extends State<ConverterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _supabase = Supabase.instance.client;

  bool _isLoading = false;

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(content: Text("Login Successful")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }

    setState(() {
      _isLoading = false;
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
        backgroundColor:Colors.blueGrey,
      ),

      body: Center(
        child: SizedBox(
          height: 400,
          width: 300,

          child: Card(
            color: const Color.fromARGB(255, 254, 254, 254),

            child: Padding(
              padding: const EdgeInsets.all(20.0),

              child: Form(
                key: _formKey,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      "Log Into Pets.co",

                      style: GoogleFonts.montserrat(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

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

                    InputField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,

                      validator: (value) =>
                          value!.isEmpty ? "Enter password" : null,

                      hintText: "Enter Password",
                      labelText: "Password",
                      prefixIcon: Icons.lock,
                      isPassword: true,
                    ),

                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          login();
                        }
                      },

                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text("Login",
                          style: GoogleFonts.montserrat(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "You are not registered yet? Create your account",

                      style: GoogleFonts.montserrat(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 8,
                        fontWeight: FontWeight.w500
                      ),
                    ),

                    SizedBox(height: 10),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Registerpage(),
                          ),
                        );
                      },

                      child: Text(
                        "Sign Up",

                        style: GoogleFonts.montserrat(
                          color: const Color.fromARGB(255, 43, 84, 145),
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
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