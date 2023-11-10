import 'package:basic_board/models/room.dart';
import 'package:basic_board/providers/auth_provider.dart';
import 'package:basic_board/providers/firestore_provider.dart';
import 'package:basic_board/services/room_db.dart';
import 'package:basic_board/views/dialogues/image_picker_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/views/widgets/app_button.dart';
import 'package:basic_board/views/widgets/app_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRoomScreen extends ConsumerStatefulWidget {
  static String id = 'create-room';
  const CreateRoomScreen({super.key});

  @override
  ConsumerState<CreateRoomScreen> createState() =>
      _ConsumerCreateRoomScreenState();
}

class _ConsumerCreateRoomScreenState extends ConsumerState<CreateRoomScreen> {
  bool value = false;
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider).value;
    final auth = ref.watch(authStateProvider).value;
    final theme = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      appBar: AppBar(title: const Text('Create Room')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ten),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => imagePickerDialogue(
                    context,
                    onStorageTapped: () {
                      //! Pick Image From Device Storage
                    },
                    onCameraTapped: () {
                      //! Pick Image From Camera
                    },
                  ),
                  child: CircleAvatar(
                    radius: size,
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: theme == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: ten),
                Expanded(
                  child: AppTextField(
                    hintText: 'Room name (required)',
                    textInputAction: TextInputAction.next,
                    controller: _nameController,
                    borderless: true,
                  ),
                ),
              ],
            ),
            height20,
            AppTextField(
              hintText: "Room description",
              maxLines: 5,
              controller: _descController,
              borderless: true,
            ),
            height20,
            PrivacySwitch(
              value: value,
              onChanged: (newValue) {
                setState(() {
                  value = newValue;
                });
              },
            ),
            height30,
            AppButton(
              label: 'Create',
              onTap: () {
                if (_nameController.text.trim().isEmpty) return;
                final Room room = Room(
                  name: _nameController.text.trim(),
                  desc: _descController.text.trim(),
                  creator:
                      user?['fName'] + ' ' + user?['lName'].toString().trim(),
                  creatorId: auth!.uid,
                  private: value,
                  createdAt: DateTime.now(),
                  participants: [auth.uid],
                );
                RoomDB().create(room, context, user: user);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacySwitch extends StatelessWidget {
  const PrivacySwitch({super.key, required this.value, this.onChanged});
  final bool value;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Make this Room private?', style: TextStyle(fontSize: 16.0)),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
