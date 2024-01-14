import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/screens/academics/academics_home_screen.dart';
import '../../providers/space_providers.dart';

class BNavBar extends ConsumerStatefulWidget {
  static String id = '/b-nav-bar';
  const BNavBar({super.key, this.space});
  final Space? space;

  @override
  ConsumerState<BNavBar> createState() => _BNavBarState();
}

class _BNavBarState extends ConsumerState<BNavBar> {
  int currentPage = 1;
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider).value;
    final myspaces = ref.watch(mySpacesProvider(auth!.uid));
    final firstSpace = myspaces.value?.first;
    final Space space = Space(
      name: firstSpace?['name'] ?? '',
      id: firstSpace?.id ?? '',
      desc: firstSpace?['desc'] ?? '',
      image: firstSpace?['image'] ?? '',
      private: firstSpace?['private'] ?? true,
      participants: firstSpace?['participants'] ?? [],
      createdAt: (firstSpace?['createdAt'].toDate()) ?? DateTime.now(),
      creatorId: firstSpace?['creatorId'] ?? '',
    );
    return Scaffold(
      body: [
        RoomChatsScreen(space: widget.space ?? space),
        const AcademicsHomeScreen(),
        const SettingsScreen(),
      ][currentPage],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            currentPage = value;
          });
        },
        selectedIndex: currentPage,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_rounded),
            label: 'Chat',
            tooltip: 'Space',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_rounded),
            label: 'Me',
            tooltip: 'My academics',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
            tooltip: 'Settings',
          ),
        ],
      ),
    );
  }
}
