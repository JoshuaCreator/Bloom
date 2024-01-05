import 'package:basic_board/configs/sizes.dart';
import 'package:basic_board/providers/space_providers.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/screens/space/discover_space_screen.dart';
import 'package:basic_board/views/widgets/b_nav_bar.dart';
import 'package:basic_board/views/widgets/space_tile.dart';
import 'package:intl/intl.dart';

class SpaceScreen extends ConsumerWidget {
  const SpaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider).value!;
    final myspaces = ref.watch(mySpacesProvider(auth.uid));
    return SizedBox(
      width: Sizes.width! / 1.05,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Space'),
          actions: [
            IconButton(
              onPressed: () {
                context.pop();
                context.push('${BNavBar.id}/${DiscoverSpacesScreen.id}');
              },
              icon: const Icon(Icons.workspaces),
              tooltip: 'Discover Spaces',
            ),
            IconButton(
              onPressed: () {
                context.pop();
                context.push('${BNavBar.id}/${CreateSpaceScreen.id}');
              },
              icon: const Icon(Icons.add_rounded),
              tooltip: 'Create SPace',
            ),
          ],
        ),
        body: myspaces.when(
          data: (data) => data.isEmpty
              ? const Center(
                  child: Text(
                    "Spaces you join will appear here",
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
                      name: data[index]['name'] ?? '',
                      desc: data[index]['desc'] ?? '',
                      image: data[index]['image'] == null ||
                              data[index]['image']!.isEmpty
                          ? defaultSpaceImg
                          : data[index]['image'],
                      creatorId: data[index]['creatorId'] ?? '',
                      participants: data[index]['participants'] ?? [],
                      createdAt:
                          data[index]['createdAt'].toDate() ?? DateTime.now(),
                      private: data[index]['private'] ?? true,
                    );
                    String dateTime =
                        DateFormat('dd MMM hh:mm a').format(space.createdAt);
                    return SpaceTile(
                      id: space.id!,
                      title: space.name,
                      subtitle: 'Created $dateTime',
                      image: space.image ?? '',
                      onTap: () {
                        context.pop();
                        context.go(BNavBar.id, extra: space);
                      },
                    );
                  },
                ),
          error: (error, stackTrace) => const Center(
            child: Text('An error occurred'),
          ),
          loading: () => const Center(child: Center(child: LoadingIndicator())),
        ),
      ),
    );
  }
}
