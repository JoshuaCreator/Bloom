import 'package:basic_board/models/dept.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/screens/create_dept_screen.dart';
import 'package:intl/intl.dart';

import 'dept_tile.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final depts = ref.watch(deptsProvider);
    return Drawer(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: size + ten, left: ten, right: ten),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Departments',
                  style: TextStyle(fontSize: twenty + five),
                ),
                AppTextButton(
                  label: 'Create',
                  onPressed: () {
                    context.pop();
                    context.push('${HomeScreen.id}/${CreateDeptScreen.id}');
                  },
                ),
              
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: depts.when(
                    data: (data) => data.isEmpty
                        ? const Center(
                            child: Text(
                              "You haven't been added to any Departments yet.\n Contact your supervisor.",
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(top: ten),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final Department dept = Department(
                                id: data[index].id,
                                name: data[index]['name'],
                                desc: data[index]['desc'],
                                participants: data[index]['participants'],
                                createdAt: data[index]['createdAt'].toDate(),
                              );
                              String dateTime = DateFormat('dd MMM hh:mm a')
                                  .format(dept.createdAt);

                              // bool visible = roomData.private;
                              // return Visibility(
                              //   visible: true,
                              //   child: RoomTile(
                              //     name: roomData.name,
                              //     subtitle: '',
                              //     image: roomData.image ?? '',
                              //   ),
                              // );
                              return DepartmentTile(
                                id: dept.id!,
                                title: dept.name,
                                subtitle: 'Created $dateTime',
                                onTap: () {
                                  context.pop();
                                  context.go(
                                    HomeScreen.id,
                                    extra: dept,
                                  );
                                },
                              );
                            },
                          ),
                    error: (error, stackTrace) => const Center(
                      child: Text('An error occurred'),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),

                // Padding(
                //   padding: EdgeInsets.all(ten),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       AppTextButtonIcon(
                //         label: 'Settings',
                //         icon: Icons.settings_rounded,
                //         onPressed: () {
                //           context.pop();
                //           context.push(
                //             '${HomeScreen.id}/${SettingsScreen.id}',
                //           );
                //         },
                //       ),
                //       Visibility(
                //         visible: visible,
                //         child: AppTextButtonIcon(
                //           label: 'Create Room',
                //           icon: Icons.add_rounded,
                //           onPressed: () {
                //             context.pop();
                //             context.push(
                //               '${HomeScreen.id}/${CreateRoomScreen.id}',
                //             );
                //           },
                //         ),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          
          )
        
        ],
      ),
    );
  }
}
