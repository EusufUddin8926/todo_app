import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/theme.dart';
import '../colors/app_color.dart';

class InputField extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final String hint;
  final Widget? widget;

  const InputField(
      {required this.title, this.controller, required this.hint, this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 14.0),
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColor.gray.withOpacity(0.3),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: false,
                      cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
                      readOnly: widget == null ? false : true,
                      controller: controller,
                      style: subTitleTextStle,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        fillColor: AppColor.transparent,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        hintText: hint,
                        hintStyle: const TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  widget == null ? Container() : widget!,
                ],
              ),
            )
          ],
        ));
  }
}
