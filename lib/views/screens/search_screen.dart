import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/widgets/workspace_tile.dart';
import 'package:intl/intl.dart';

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
      onPressed: () => context.pop(),
      icon: const Icon(Icons.arrow_back),
    );
  }

  // Future<List<DocumentSnapshot>> fetchWorkspaces(String query) async {
  //   final CollectionReference ref =
  //       FirebaseFirestore.instance.collection('workspaces');
  //   final snapshot = await ref.where('name', isEqualTo: query).get();
  //   return snapshot.docs;
  // }

  @override
  Widget buildResults(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    return FutureBuilder(
      future: firestore
          .collection('workspaces')
          .where('name'.toLowerCase(), arrayContains: query)
          .get(),
      // .asBroadcastStream(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(child: LoadingIndicator());
        // }
        final data = snapshot.data?.docs;
        return ListView.builder(
          padding: EdgeInsets.only(top: ten),
          itemCount: data?.length,
          itemBuilder: (context, index) {
            final timeStamp = data?[index]['createdAt'] == null
                ? DateTime.now()
                : (data?[index]['createdAt']).toDate();
            String dateTime = DateFormat('dd MMM hh:mm a').format(timeStamp);
            return WorkspaceTile(
              id: data?[index].id ?? '',
              title: data?[index]['name'] ?? '',
              subtitle: dateTime,
              image: data?[index]['image'] == null ||
                      data?[index]['image']!.isEmpty
                  ? defaultWorkspaceImg
                  : data?[index]['image'],
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    // final FirebaseAuth auth = FirebaseAuth.instance;
    return FutureBuilder(
      future: firestore
          .collection('workspaces')
          // .where('name'.toLowerCase(), isEqualTo: query)
          .get(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(child: LoadingIndicator());
        // }
        final data = snapshot.data?.docs;
        return ListView.builder(
          padding: EdgeInsets.only(top: ten),
          itemCount: data?.length,
          itemBuilder: (context, index) {
            final timeStamp = data?[index]['createdAt'] == null
                ? DateTime.now()
                : (data?[index]['createdAt']).toDate();
            String dateTime = DateFormat('dd MMM hh:mm a').format(timeStamp);
            return WorkspaceTile(
              id: data?[index].id ?? '',
              title: data?[index]['name'] ?? '',
              subtitle: dateTime,
              image: data?[index]['image'] == null ||
                      data?[index]['image']!.isEmpty
                  ? defaultWorkspaceImg
                  : data?[index]['image'],
            );
          },
        );
      },
    );
  }
}
