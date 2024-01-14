import 'package:basic_board/providers/space_providers.dart';
import 'package:basic_board/services/connection_state.dart';
import 'package:basic_board/services/space_db.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/widgets/b_nav_bar.dart';
import 'package:basic_board/views/widgets/space_card.dart';

class DiscoverSpacesScreen extends ConsumerWidget {
  static String id = 'discover-spaces';
  const DiscoverSpacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider).value!;
    final spaces = ref.watch(allSpacesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Spaces'),
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context,
              delegate: CustomSearchDelegate(),
            ),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: spaces.when(
        data: (data) => data.isEmpty
            ? const Center(child: Text("Nothing to see here"))
            : ListView.builder(
                padding: EdgeInsets.all(ten),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final Space space = Space(
                    id: data[index].id,
                    name: data[index]['name'],
                    desc: data[index]['desc'],
                    image: data[index]['image'] == null ||
                            data[index]['image']!.isEmpty
                        ? defaultSpaceImgPath
                        : data[index]['image'],
                    creatorId: data[index]['creatorId'],
                    createdAt: (data[index]['createdAt']).toDate(),
                    private: data[index]['private'],
                    participants: data[index]['participants'],
                    rooms: data[index]['rooms'],
                  );
                  return SpaceCard(
                    img: space.image!,
                    name: space.name,
                    desc: space.desc!,
                    isParticipant: space.participants!.contains(auth.uid),
                    onTap: () {
                      context.push(
                        '${BNavBar.id}/${RoomChatsScreen.id}/${SpaceInfoScreen.id}',
                        extra: space,
                      );
                    },
                    onJoin: () async {
                      final isConnected = await isOnline();
                      if (!isConnected) {
                        if (context.mounted) {
                          showSnackBar(context, msg: "You're offline'");
                        }
                        return;
                      }
                      if (context.mounted) {
                        SpaceDB().join(
                          context,
                          space: space,
                          userId: auth.uid,
                        );
                      }
                    },
                  );
                },
              ),
        error: (error, stackTrace) => const Center(
          child: Text('Oops! An error occurred'),
        ),
        loading: () => const Center(child: LoadingIndicator()),
      ),
    );
  }
}
