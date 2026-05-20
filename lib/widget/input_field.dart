import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String hintText;
  final String labelText;
  final bool isPassword;
  final IconData? prefixIcon;

  const InputField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.validator,
    required this.hintText,
    required this.labelText,
    this.prefixIcon,
    this.isPassword = false,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      validator: widget.validator,

      // typing text color
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),

      obscureText: widget.isPassword ? _obscureText : false,

      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,

        // box background color
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),

        // hint text color
        hintStyle: TextStyle(
          color: Colors.grey,
        ),

        // label color
        labelStyle: TextStyle(
          color: const Color.fromARGB(255, 0, 0, 0),
          fontWeight: FontWeight.bold,
        ),

        // prefix icon color
        prefixIcon: Icon(
          widget.prefixIcon,
          color: const Color.fromARGB(255, 0, 0, 0),
        ),

        // eye icon color
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,

        // normal border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 0, 0, 0),
            width: 2,
          ),
        ),

        // focused border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 0, 0, 0),
            width: 2.5,
          ),
        ),

        // error border
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
    );
  }
}