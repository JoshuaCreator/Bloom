import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/widgets/workspace_tile.dart';
import 'package:intl/intl.dart';

class WorkspaceScreen extends ConsumerWidget {
  static String id = '/workspace';
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final depts = ref.watch(wrkspcsProvider);
    return RefreshIndicator(
      onRefresh: () => ref.refresh(wrkspcsProvider.future),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Workspaces'),
          actions: [buildPopupMenu(context)],
        ),
        body: depts.when(
          data: (data) => data.isEmpty
              ? const Center(
                  child: Text(
                    "There're no Workspaces here yet",
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(top: ten),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final Workspace dept = Workspace(
                      id: data[index].id,
                      name: data[index]['name'],
                      desc: data[index]['desc'],
                      creatorId: data[index]['creatorId'],
                      participants: data[index]['participants'],
                      createdAt: data[index]['createdAt'].toDate(),
                    );
                    String dateTime =
                        DateFormat('dd MMM hh:mm a').format(dept.createdAt);
                    return WorkspaceTile(
                      id: dept.id!,
                      title: dept.name,
                      subtitle: 'Created $dateTime',
                      onTap: () {
                        context.go(
                          '${WorkspaceScreen.id}/${HomeScreen.id}',
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
      ),
    );
  }

  AppPopupMenu buildPopupMenu(BuildContext context) {
    return AppPopupMenu(
      items: [
        AppPopupMenu.buildPopupMenuItem(
          context,
          label: 'Create Workspace',
          onTap: () => context.push(
            '${WorkspaceScreen.id}/${CreateWorkspaceScreen.id}',
          ),
        ),
        AppPopupMenu.buildPopupMenuItem(
          context,
          label: 'Settings',
          onTap: () => context.push(
            '${WorkspaceScreen.id}/${SettingsScreen.id}',
          ),
        ),
      ],
    );
  }
}
