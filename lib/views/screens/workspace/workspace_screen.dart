import 'package:basic_board/providers/workspace_providers.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/widgets/workspace_tile.dart';
import 'package:intl/intl.dart';

class WorkspaceScreen extends ConsumerWidget {
  static String id = '/workspace';
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider).value!;
    final workspaces = ref.watch(myWorkspacesProvider(auth.uid));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspaces'),
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context,
              delegate: CustomSearchDelegate(),
            ),
            icon: const Icon(Icons.workspaces),
          ),
          buildPopupMenu(context)
        ],
      ),
      body: workspaces.when(
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
                  final Workspace wrkspc = Workspace(
                    id: data[index].id,
                    name: data[index]['name'],
                    desc: data[index]['desc'],
                    image: data[index]['image'] == null ||
                            data[index]['image']!.isEmpty
                        ? defaultWorkspaceImg
                        : data[index]['image'],
                    creatorId: data[index]['creatorId'],
                    participants: data[index]['participants'],
                    createdAt: data[index]['createdAt'].toDate(),
                    private: data[index]['private'] ?? true,
                  );
                  String dateTime =
                      DateFormat('dd MMM hh:mm a').format(wrkspc.createdAt);
                  return WorkspaceTile(
                    id: wrkspc.id!,
                    title: wrkspc.name,
                    subtitle: 'Created $dateTime',
                    image: wrkspc.image!,
                    onTap: () {
                      context.go(
                        '${WorkspaceScreen.id}/${RoomChatsScreen.id}',
                        extra: wrkspc,
                      );
                    },
                  );
                },
              ),
        error: (error, stackTrace) => const Center(
          child: Text('An error occurred'),
        ),
        loading: () => const Center(child: Center(child: LoadingIndicator())),
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
