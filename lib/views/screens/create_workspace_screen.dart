import 'package:basic_board/services/workspace_db.dart';
import 'package:basic_board/utils/imports.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class CreateWorkspaceScreen extends ConsumerStatefulWidget {
  static String id = 'create-workspace';
  const CreateWorkspaceScreen({super.key});

  @override
  ConsumerState<CreateWorkspaceScreen> createState() =>
      _ConsumerCreateWorkspaceScreenState();
}

class _ConsumerCreateWorkspaceScreenState
    extends ConsumerState<CreateWorkspaceScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _descController = TextEditingController();

  bool visible = true;

  @override
  Widget build(BuildContext context) {
    // final firestore = ref.watch(firestoreProvider);
    final user = ref.watch(authStateProvider).value;
    final auth = ref.watch(authStateProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Create Workspace")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Visibility(
                visible: visible,
                child: Padding(
                  padding: EdgeInsets.all(ten),
                  child: Column(
                    children: [
                      SizedBox(width: ten),
                      AppTextField(
                        hintText: 'Name (required)',
                        textInputAction: TextInputAction.next,
                        controller: _nameController,
                        autofocus: true,
                        borderless: true,
                      ),
                      height20,
                      AppTextField(
                        hintText: "Description",
                        maxLines: 5,
                        controller: _descController,
                        borderless: true,
                        validate: false,
                      ),
                      height30,
                      AppButton(
                        label: 'Create',
                        onTap: () {
                          if (_nameController.text.trim().isEmpty) return;
                          final Workspace wrkspc = Workspace(
                            id: 'id',
                            name: _nameController.text.trim(),
                            desc: _descController.text.trim(),
                            participants: [auth.value?.uid],
                            creatorId: user!.uid,
                            createdAt: DateTime.now(),
                          );
                          WorkspaceDB().create(
                            context,
                            wrkspc: wrkspc,
                            userId: user.uid,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
