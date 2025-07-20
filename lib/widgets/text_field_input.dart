// import 'package:flutter/material.dart';

// class TextFieldInput extends StatelessWidget {
//   final TextEditingController textEditingController;
//   final bool isPass;
//   final String hintText;
//   final TextInputType textInputType;
//   const TextFieldInput({Key? key, 
//   required this.textEditingController,
//   this.isPass = false,
//   required this.hintText,
//   required this.textInputType,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final inputBorder = OutlineInputBorder(
//           borderSide: Divider.createBorderSide(context)
//         );
//     return TextField(
//       controller: textEditingController,
//       decoration: InputDecoration(
//         hintText: hintText,
//         border: inputBorder,
//         contentPadding: EdgeInsets.all(8),
//       ),
//       keyboardType: textInputType,
//       obscureText: isPass,
//     );
//   }
// }


import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final Widget? suffixIcon;
  final bool enabled;

  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
    this.suffixIcon,
    this.enabled = true, // ✅ Default to true for editable
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      controller: textEditingController,
      keyboardType: textInputType,
      obscureText: isPass,
      enabled: enabled, // ✅ makes the field read-only when false
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: Colors.deepPurple),
        ),
        disabledBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: Colors.grey),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        suffixIcon: suffixIcon,
        filled: !enabled, // Gray background if disabled
        fillColor: Colors.grey[200],
      ),
      style: TextStyle(
        color: enabled ? Colors.black : Colors.grey[700],
      ),
    );
  }
}
