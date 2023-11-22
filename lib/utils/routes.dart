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
      path: WorkspaceScreen.id,
      builder: (context, state) => const WorkspaceScreen(),
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
          path: HomeScreen.id,
          builder: (context, state) => HomeScreen(
            workspace: state.extra as Workspace,
          ),
          routes: [
            GoRoute(
              path: '${RoomChatScreen.id}/:wrkspc',
              builder: (context, state) => RoomChatScreen(
                room: state.extra as Room,
                wrkspc: state.pathParameters['wrkspc']!,
              ),
              routes: [
                GoRoute(
                  path: '${RoomInfoScreen.id}/:wrkspace',
                  builder: (context, state) => RoomInfoScreen(
                    wrkspaceId: state.pathParameters['wrkspace']!,
                    room: state.extra as Room,
                  ),
                  routes: [
                    GoRoute(
                      path: '${UserScreen.id}/:userId',
                      builder: (context, state) => UserScreen(
                        userId: state.pathParameters['userId']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: WorkspaceInfoScreen.id,
              builder: (context, state) => WorkspaceInfoScreen(
                workspace: state.extra as Workspace,
              ),
              routes: [
                GoRoute(
                  path: '${CreateRoomScreen.id}/:wrkspc',
                  builder: (context, state) => CreateRoomScreen(
                    wrkspcId: state.pathParameters['wrkspc']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: CreateWorkspaceScreen.id,
          builder: (context, state) => const CreateWorkspaceScreen(),
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
