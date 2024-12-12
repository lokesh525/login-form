import 'package:flutter/material.dart';
class UiHelper {
  static Widget customTextField({
    required TextEditingController controller,
    required String text,
    required bool toHide,
    required IconData iconData,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(

              labelText: text,
              hintText: text,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                  borderSide: BorderSide(

                  )
              ),
              prefixIcon: Icon(iconData),
            ),
            obscureText: toHide,
            validator: validator,

          ),
        ],
      ),
    );
  }

}