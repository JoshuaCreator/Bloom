import 'package:basic_board/models/dept.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/screens/create_dept_screen.dart';
import 'package:basic_board/views/widgets/dept_tile.dart';
import 'package:intl/intl.dart';

class DeptScreen extends ConsumerWidget {
  static String id = '/dept-screen';
  const DeptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final depts = ref.watch(deptsProvider);
    return RefreshIndicator(
      onRefresh: () => ref.refresh(deptsProvider.future),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Departments'),
          actions: [buildPopupMenu(context)],
        ),
        body: depts.when(
          data: (data) => data.isEmpty
              ? const Center(
                  child: Text(
                    "You haven't been added to any Departments yet.\n Contact your supervisor.",
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(top: ten),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final Department dept = Department(
                      id: data[index].id,
                      name: data[index]['name'],
                      desc: data[index]['desc'],
                      creatorId: data[index]['creatorId'],
                      participants: data[index]['participants'],
                      createdAt: data[index]['createdAt'].toDate(),
                    );
                    String dateTime =
                        DateFormat('dd MMM hh:mm a').format(dept.createdAt);
                    return DepartmentTile(
                      id: dept.id!,
                      title: dept.name,
                      subtitle: 'Created $dateTime',
                      onTap: () {
                        context.go(
                          '${DeptScreen.id}/${HomeScreen.id}',
                          extra: dept,
                        );
                      },
                    );
                  },
                ),
          error: (error, stackTrace) => Center(
            child: Text('An error occurred: $error. Tap to refresh'),
          ),
          loading: () => const Center(child: Center(child: LoadingIndicator())),
        ),
        floatingActionButton: depts.value == null
            ? null
            : FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  context.push(
                    '${DeptScreen.id}/${CreateDeptScreen.id}',
                  );
                },
              ),
      ),
    );
  }

  AppPopupMenu buildPopupMenu(BuildContext context) {
    return AppPopupMenu(
      items: [
        AppPopupMenu.buildPopupMenuItem(
          context,
          label: 'Settings',
          onTap: () => context.push(
            '${DeptScreen.id}/${HomeScreen.id}/${SettingsScreen.id}',
          ),
        ),
      ],
    );
  }
}
