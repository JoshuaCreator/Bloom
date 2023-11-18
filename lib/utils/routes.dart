import 'package:basic_board/models/dept.dart';
import 'package:basic_board/models/room.dart';
import 'package:basic_board/views/screens/create_dept_screen.dart';
import 'package:basic_board/views/screens/dept_info_screen.dart';
import 'package:basic_board/views/screens/dept_screen.dart';
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
      path: DeptScreen.id,
      builder: (context, state) => const DeptScreen(),
      routes: [
        GoRoute(
          path: HomeScreen.id,
          builder: (context, state) => HomeScreen(
            dept: state.extra as Department,
          ),
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
              path: '${CreateRoomScreen.id}/:deptId',
              builder: (context, state) => CreateRoomScreen(
                deptId: state.pathParameters['deptId']!,
              ),
            ),
            GoRoute(
              path: '${RoomChatScreen.id}/:deptId',
              builder: (context, state) => RoomChatScreen(
                room: state.extra as Room,
                deptId: state.pathParameters['deptId']!,
              ),
              routes: [
                GoRoute(
                  path: '${RoomInfoScreen.id}/:depmtId',
                  builder: (context, state) => RoomInfoScreen(
                    depmtId: state.pathParameters['depmtId']!,
                    room: state.extra as Room,
                  ),
                ),
              ],
            ),
            GoRoute(
              path: DeptInfoScreen.id,
              builder: (context, state) => DeptInfoScreen(
                deptData: state.extra as Department,
              ),
            ),
            GoRoute(
              path: "${AllRoomsScreen.id}/:deptId",
              builder: (context, state) => AllRoomsScreen(
                deptId: state.pathParameters['deptId']!,
              ),
            ),
            GoRoute(
              path: CreateDeptScreen.id,
              builder: (context, state) => const CreateDeptScreen(),
            ),
          ],
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
