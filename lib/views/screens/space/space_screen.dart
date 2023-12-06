import 'package:basic_board/providers/space_providers.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/screens/space/discover_space_screen.dart';
import 'package:basic_board/views/widgets/space_tile.dart';
import 'package:intl/intl.dart';

class SpaceScreen extends ConsumerWidget {
  static String id = '/my-space';
  const SpaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider).value!;
    final myspaces = ref.watch(mySpacesProvider(auth.uid));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Space'),
        actions: [
          IconButton(
            onPressed: () =>
                context.push('${SpaceScreen.id}/${DiscoverSpacesScreen.id}'),
            icon: const Icon(Icons.workspaces),
            tooltip: 'Discover Spaces',
          ),
          buildPopupMenu(context)
        ],
      ),
      body: myspaces.when(
        data: (data) => data.isEmpty
            ? const Center(
                child: Text(
                  "Spaces you join appear here",
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.only(top: ten),
                itemCount: data.length,
                separatorBuilder: (context, index) => const Separator(),
                itemBuilder: (context, index) {
                  final Space space = Space(
                    id: data[index].id,
                    name: data[index]['name'],
                    desc: data[index]['desc'],
                    image: data[index]['image'] == null ||
                            data[index]['image']!.isEmpty
                        ? defaultSpaceImg
                        : data[index]['image'],
                    creatorId: data[index]['creatorId'],
                    participants: data[index]['participants'],
                    createdAt: data[index]['createdAt'].toDate(),
                    private: data[index]['private'] ?? true,
                  );
                  String dateTime =
                      DateFormat('dd MMM hh:mm a').format(space.createdAt);
                  return SpaceTile(
                    id: space.id!,
                    title: space.name,
                    subtitle: 'Created $dateTime',
                    image: space.image!,
                    onTap: () {
                      context.go(
                        '${SpaceScreen.id}/${RoomChatsScreen.id}',
                        extra: space,
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
          label: 'Create Space',
          onTap: () =>
              context.push('${SpaceScreen.id}/${CreateSpaceScreen.id}'),
        ),
        AppPopupMenu.buildPopupMenuItem(
          context,
          label: 'Settings',
          onTap: () => context.push(
            '${SpaceScreen.id}/${SettingsScreen.id}',
          ),
        ),
      ],
    );
  }
}
