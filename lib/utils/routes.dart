import 'package:basic_board/views/screens/user_screen.dart';

import '../views/screens/verify_email_screen.dart';
import '../utils/imports.dart';

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
              //! TODO Let Settings be directly under Departments screen
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
                  routes: [
                    GoRoute(
                      path: '${UserScreen.id}/:userId',
                      builder: (context, state) => UserScreen(userId: state.pathParameters['userId']!,),
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: DeptInfoScreen.id,
              builder: (context, state) => DeptInfoScreen(
                deptData: state.extra as Department,
              ),
            ),
          ],
        ),
        GoRoute(
          path: CreateDeptScreen.id,
          builder: (context, state) => const CreateDeptScreen(),
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
