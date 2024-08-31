import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final Color color;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool isDatePicker;

  const CustomTextField({
    required this.hint,
    required this.color,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.isDatePicker = false,
    super.key,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        widget.controller.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final padding = mediaQuery.size.width * 0.05;
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      obscureText: widget.isPassword && _obscureText,
      keyboardType: widget.isDatePicker ? TextInputType.none : widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: padding * 0.98,
          vertical: padding,
        ),
        fillColor: const Color.fromARGB(255, 235, 235, 235),
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: widget.hint,
        hintStyle: const TextStyle(
          color: Colors.black45,
          fontSize: 19,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: widget.color,
                ),
                onPressed: _togglePasswordVisibility,
              )
            : null,
      ),
      onTap: widget.isDatePicker ? () => _selectDate(context) : null,
      readOnly: widget.isDatePicker, 
    );
  }
}
