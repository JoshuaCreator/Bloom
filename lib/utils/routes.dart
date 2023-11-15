import 'package:basic_board/models/room.dart';
import 'package:basic_board/views/screens/create_dept_screen.dart';
import 'package:basic_board/views/screens/room_info_screen.dart';
import 'package:basic_board/views/screens/account_screen.dart';
import 'package:basic_board/views/screens/all_rooms_screen.dart';
import 'package:basic_board/views/screens/profile_screen.dart';
import 'package:basic_board/views/screens/create_room_screen.dart';
import 'package:basic_board/views/screens/room_chat_screen.dart';
import 'package:basic_board/views/screens/settings_screen.dart';
import 'package:basic_board/views/screens/theme_selector_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:basic_board/views/screens/auth_checker.dart';
import 'package:basic_board/views/screens/home_screen.dart';
import 'package:basic_board/views/screens/login_screen.dart';
import 'package:basic_board/views/screens/password_reset_screen.dart';
import 'package:basic_board/views/screens/register_screen.dart';

import '../views/screens/verify_email_screen.dart';

GoRouter goRouter = GoRouter(
  initialLocation: AuthChecker.id,
  routes: [
    GoRoute(
      path: AuthChecker.id,
      builder: (context, state) => const AuthChecker(),
    ),
    GoRoute(
      path: HomeScreen.id,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: SettingsScreen.id,
          builder: (context, state) => const SettingsScreen(),
          routes: [
            GoRoute(
              path: ProfileScreen.id,
              builder: (context, state) => const ProfileScreen(),
            ),
            GoRoute(
              path: AccountScreen.id,
              builder: (context, state) => const AccountScreen(),
            ),
            GoRoute(
              path: ThemeSelectorScreen.id,
              builder: (context, state) => const ThemeSelectorScreen(),
            ),
          ],
        ),
        GoRoute(
          path: CreateRoomScreen.id,
          builder: (context, state) => const CreateRoomScreen(),
        ),
        GoRoute(
            path: RoomChatScreen.id,
            builder: (context, state) => RoomChatScreen(
                  room: state.extra as Room,
                ),
            routes: [
              GoRoute(
                path: RoomInfoScreen.id,
                builder: (context, state) => RoomInfoScreen(
                  room: state.extra as Room,
                ),
              ),
            ]),
        GoRoute(
          path: AllRoomsScreen.id,
          builder: (context, state) => const AllRoomsScreen(),
        ),
        GoRoute(
          path: CreateDeptScreen.id,
          builder: (context, state) =>  CreateDeptScreen(),
        ),
      ],
    ),
    GoRoute(
      path: LoginScreen.id,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RegisterScreeen.id,
      builder: (context, state) => const RegisterScreeen(),
    ),
    GoRoute(
      path: PasswordResetScreen.id,
      builder: (context, state) => const PasswordResetScreen(),
    ),
    GoRoute(
      path: VerifyEmailScreen.id,
      builder: (context, state) => const VerifyEmailScreen(),
    ),
  ],
);
