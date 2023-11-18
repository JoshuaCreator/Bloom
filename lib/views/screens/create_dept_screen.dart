import 'package:basic_board/models/dept.dart';
import 'package:basic_board/services/dept_db.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/widgets/user_tile.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class CreateDeptScreen extends ConsumerStatefulWidget {
  static String id = 'create-dept';
  const CreateDeptScreen({super.key});

  @override
  ConsumerState<CreateDeptScreen> createState() =>
      _ConsumerCreateDeptScreenState();
}

class _ConsumerCreateDeptScreenState extends ConsumerState<CreateDeptScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _descController = TextEditingController();

  bool visible = true;

  @override
  Widget build(BuildContext context) {
    final firestore = ref.watch(firestoreProvider);
    final user = ref.watch(authStateProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: Text(visible ? "Create Department" : "Add participants"),
        actions: [
          Visibility(
            visible: !visible,
            child: AppTextButton(
              label: 'Done',
              onPressed: () {
                // Complete
              },
            ),
          ),
        ],
      ),
      body: Column(
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
                      validate: false,
                    ),
                    // height20,

                    height30,
                    AppButton(
                      label: 'Create',
                      onTap: () {
                        if (_nameController.text.trim().isEmpty) return;
                        final Department dept = Department(
                          id: 'id',
                          name: _nameController.text.trim(),
                          desc: _descController.text.trim(),
                          participants: [],
                          creatorId: user!.uid,
                          createdAt: DateTime.now(),
                        );
                        DeptDB().create(context, dept: dept, userId: user.uid);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: !visible,
            child: Flexible(
              child: FutureBuilder(
                  future: firestore.collection('users').get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: LoadingIndicator(label: 'Please wait...'),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Oops! An error occurred"),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                          "There aren't any available users to add to this department",
                        ),
                      );
                    }
                    final data = snapshot.data?.docs;
                    return ListView.builder(
                      padding: EdgeInsets.only(top: twenty),
                      itemCount: data?.length,
                      itemBuilder: (context, index) {
                        return UserTile(
                          title: data?[index]['name'],
                          image: data?[index]['image'],
                          trailing: AppTextButton(
                            label: 'Add',
                            colour: ColourConfig.go,
                            onPressed: () {
                              //Add participant
                            },
                          ),
                        );
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
