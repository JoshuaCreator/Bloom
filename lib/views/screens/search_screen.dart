import 'package:basic_board/providers/space_providers.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/widgets/b_nav_bar.dart';
import 'package:basic_board/views/widgets/space_card.dart';

// This file is currently not in use
// Until the Search functionality is fixed

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, ''),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Searcher(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Searcher(query);
  }
}

final searchResultProvider =
    StreamProvider.family.autoDispose((ref, String query) {
  final q = query.toLowerCase().trim();
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection('spaces')
      .where('name', isGreaterThanOrEqualTo: q, isLessThanOrEqualTo: q)
      .snapshots()
      .map((snapshot) => snapshot.docs);
});

class Searcher extends ConsumerWidget {
  const Searcher(this.query, {super.key});
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider).value!;
    final result = ref.watch(allSpacesProvider);
    return result.when(
      data: (data) {
        return ListView.builder(
                padding: EdgeInsets.all(ten),
                itemCount: result.value?.length,
                itemBuilder: (context, index) {
                  final data = result.value?[index];
                  final Space space = Space(
                    id: data?.id,
                    name: data?['name'],
                    desc: data?['desc'],
                    image: data?['image'] == null || data?['image']!.isEmpty
                        ? defaultSpaceImg
                        : data?['image'],
                    participants: data?['participants'],
                    creatorId: data?['creatorId'],
                    rooms: data?['rooms'],
                    createdAt: (data?['createdAt']).toDate(),
                    private: data?['private'],
                  );
                  return result.value![index]['name']
                          .toString()
                          .toLowerCase()
                          .trim()
                          .contains(query.toLowerCase().trim())
                      ? SpaceCard(
                          name: space.name,
                          desc: space.desc!,
                          img: space.image,
                          isParticipant: space.participants!.contains(auth.uid),
                          onTap: () {
                            context.push(
                              '${BNavBar.id}/${RoomChatsScreen.id}/${SpaceInfoScreen.id}',
                              extra: space,
                            );
                          },
                          onJoin: () {},
                        )
                      : const SizedBox();
                },
              );
      },
      error: (error, stackTrace) => Center(
        child: Text('Oops! An error occurred: $error'),
      ),
      loading: () => const Center(child: LoadingIndicator()),
    );
  }
}
