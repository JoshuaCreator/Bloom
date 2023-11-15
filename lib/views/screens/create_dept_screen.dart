import 'package:flutter/material.dart';

import '../../configs/consts.dart';
import '../widgets/app_text_field.dart';

class CreateDeptScreen extends StatelessWidget {
  static String id = 'create-dept';
  CreateDeptScreen({super.key});
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Department"),
        actions: [
          IconButton(
            onPressed: () {
              // Done
            },
            icon: const Icon(Icons.done, color: Colors.green),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ten),
        child: Column(
          children: [
            SizedBox(width: ten),
            AppTextField(
              hintText: 'Dept name (required)',
              textInputAction: TextInputAction.next,
              controller: _nameController,
              borderless: true,
            ),
            height20,
            AppTextField(
              hintText: "Dept description",
              maxLines: 5,
              controller: _descController,
              borderless: true,
            ),
            height20,

            height30,
            // AppButton(
            //   label: 'Create',
            //   onTap: () {

            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
