import 'package:basic_board/views/screens/academics/academics_home_screen.dart';
import 'package:basic_board/views/screens/academics/courses_screen.dart';
import 'package:basic_board/views/screens/academics/courseworks_screen.dart';
import 'package:basic_board/views/screens/academics/events_screen.dart';
import 'package:basic_board/views/screens/academics/lectures_screen.dart';
import 'package:basic_board/views/screens/academics/performance_report_screen.dart';
import 'package:basic_board/views/screens/user_screen.dart';
import 'package:basic_board/views/screens/space/discover_space_screen.dart';
import 'package:basic_board/views/screens/space/space_settings_screen.dart';
import 'package:basic_board/views/widgets/b_nav_bar.dart';

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
      path: BNavBar.id,
      builder: (context, state) => BNavBar(space: state.extra as Space),
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
          path: RoomChatsScreen.id,
          builder: (context, state) => RoomChatsScreen(
            space: state.extra as Space,
          ),
          routes: [
            GoRoute(
              path: '${RoomMsgScreen.id}/:spaceId',
              builder: (context, state) => RoomMsgScreen(
                room: state.extra as Room,
                spaceId: state.pathParameters['spaceId']!,
              ),
              routes: [
                GoRoute(
                  path: '${RoomInfoScreen.id}/:spcId',
                  builder: (context, state) => RoomInfoScreen(
                    spcId: state.pathParameters['spcId']!,
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
              path: SpaceInfoScreen.id,
              builder: (context, state) => SpaceInfoScreen(
                space: state.extra as Space,
              ),
              routes: [
                GoRoute(
                  path: SpaceSettingsScreen.id,
                  builder: (context, state) => SpaceSettingsScreen(
                    space: state.extra as Space,
                  ),
                ),
                GoRoute(
                  path: '${CreateRoomScreen.id}/:spaceID',
                  builder: (context, state) => CreateRoomScreen(
                    spaceID: state.pathParameters['spaceID']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AcademicsHomeScreen.id,
          builder: (context, state) => const AcademicsHomeScreen(),
          routes: [
            GoRoute(
              path: CoursesScreen.id,
              builder: (context, state) => CoursesScreen(),
            ),
            GoRoute(
              path: LecturesScreen.id,
              builder: (context, state) => const LecturesScreen(),
            ),
            GoRoute(
              path: CourseworksScreen.id,
              builder: (context, state) => const CourseworksScreen(),
            ),
            GoRoute(
              path: PerformanceReportScreen.id,
              builder: (context, state) => const PerformanceReportScreen(),
            ),
            GoRoute(
              path: EventsScreen.id,
              builder: (context, state) => const EventsScreen(),
            ),
          ],
        ),
        GoRoute(
          path: CreateSpaceScreen.id,
          builder: (context, state) => const CreateSpaceScreen(),
        ),
        GoRoute(
          path: DiscoverSpacesScreen.id,
          builder: (context, state) => const DiscoverSpacesScreen(),
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
