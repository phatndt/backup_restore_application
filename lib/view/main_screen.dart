import 'dart:developer';

import 'package:backup_restore_application/view/setting_screen.dart';
import 'package:backup_restore_application/view_models/contact_view_model.dart';
import 'package:backup_restore_application/view_models/main_view_model.dart';
import 'package:backup_restore_application/view_models/phone_view_model.dart';
import 'package:backup_restore_application/view_models/repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../constants/resources.dart';
import '../constants/texts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: R.colors.backgroundColor,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                Navigator.pop(context);
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
              },
              icon: const Icon(Icons.logout),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => const SettingScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: R.colors.secondaryColor,
              tabs: const <Widget>[
                Tab(
                  icon: Icon(Icons.contact_page),
                ),
                Tab(
                  icon: Icon(Icons.phone),
                ),
                Tab(
                  icon: Icon(Icons.sms),
                ),
              ],
            ),
            centerTitle: true,
            title: const Text('Backup history'),
            backgroundColor: R.colors.primaryColor,
            foregroundColor: R.colors.secondaryColor,
          ),
          body: Consumer(
            builder: (BuildContext _context, WidgetRef ref, Widget? child) {
              return TabBarView(
                controller: _tabController,
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      ref.refresh(contactFutureProvider);
                    },
                    child: ref.watch(contactFutureProvider).when(
                          data: (data) {
                            return ListView.builder(
                              itemCount: data.items.length,
                              itemBuilder: (itemBuilder, index) {
                                return BackupWidget(
                                  name: data.items.elementAt(index).name,
                                  backup: (value) {
                                    showDialog(
                                      context: context,
                                      builder: (builder) => CustomAlerDiaLog(
                                        title: T.restoreContacts,
                                        content: T.restoreContactsContent,
                                        onPressed: () {
                                          ref
                                              .watch(contactNotifierProvider
                                                  .notifier)
                                              .restoreInformation(
                                                  data.items
                                                      .elementAt(index)
                                                      .fullPath,
                                                  context)
                                              .then(
                                            (value) {
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                        context: context,
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          error: (e, stack) {
                            return Center(
                              child: LottieBuilder.network(
                                  'https://assets9.lottiefiles.com/packages/lf20_hXHdlx.json'),
                            );
                          },
                          loading: () => Center(
                            child: CircularProgressIndicator(
                              color: R.colors.primaryColor,
                            ),
                          ),
                        ),
                  ),
                  RefreshIndicator(
                    onRefresh: () async {
                      ref.refresh(phoneLogFutureProvider);
                    },
                    child: ref.watch(phoneLogFutureProvider).when(
                          data: (data) {
                            return ListView.builder(
                              itemCount: data.items.length,
                              itemBuilder: (itemBuilderContext, index) {
                                return BackupWidget(
                                  name: data.items.elementAt(index).name,
                                  backup: (value) {
                                    showDialog(
                                      context: context,
                                      builder: (builder) => CustomAlerDiaLog(
                                        title: T.restoreCallLogs,
                                        content: T.restoreCallLogsContent,
                                        onPressed: () {
                                          ref
                                              .watch(phoneNotifierProvider
                                                  .notifier)
                                              .restoreInformation(
                                                data.items
                                                    .elementAt(index)
                                                    .fullPath,
                                                context,
                                              );
                                        },
                                        context: context,
                                      ),
                                    );
                                  },
                                  //delete: (value) {},
                                );
                              },
                            );
                          },
                          error: (e, stack) {
                            return Center(
                              child: LottieBuilder.network(
                                  'https://assets9.lottiefiles.com/packages/lf20_hXHdlx.json'),
                            );
                          },
                          loading: () => Center(
                            child: CircularProgressIndicator(
                              color: R.colors.primaryColor,
                            ),
                          ),
                        ),
                  ),
                  RefreshIndicator(
                    onRefresh: () async {
                      ref.watch(smsLogFutureProvider);
                    },
                    child: ref.watch(smsLogFutureProvider).when(
                          data: (data) {
                            return ListView.builder(
                              itemCount: data.items.length,
                              itemBuilder: (context, index) {
                                return BackupWidget(
                                  name: data.items.elementAt(index).name,
                                  backup: (value) {
                                    showDialog(
                                      context: context,
                                      builder: (builder) => CustomAlerDiaLog(
                                        title: T.restoreSmsLogs,
                                        content: T.restoreSmsLogsContent,
                                        onPressed: () {},
                                        context: context,
                                      ),
                                    );
                                  },
                                  //delete: (value) {},
                                );
                              },
                            );
                          },
                          error: (e, stack) {
                            return Center(
                              child: LottieBuilder.network(
                                  'https://assets9.lottiefiles.com/packages/lf20_hXHdlx.json'),
                            );
                          },
                          loading: () => Center(
                            child: CircularProgressIndicator(
                              color: R.colors.primaryColor,
                            ),
                          ),
                        ),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {},
            foregroundColor: R.colors.secondaryColor,
            backgroundColor: R.colors.primaryColor,
            child: const Icon(Icons.integration_instructions),
          ),
        ),
      ),
    );
  }
}

class BackupWidget extends StatelessWidget {
  const BackupWidget({
    Key? key,
    required this.name,
    //required this.delete,
    required this.backup,
  }) : super(key: key);
  final String name;
  //final Function(BuildContext context)? delete;
  final Function(BuildContext context)? backup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4.h,
        horizontal: 8.w,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.w),
            bottomLeft: Radius.circular(4.w),
          ),
        ),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: backup,
                backgroundColor: const Color(0xFF7BC043),
                foregroundColor: Colors.white,
                icon: Icons.restore,
                label: 'Restore',
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4.w),
                  bottomRight: Radius.circular(4.w),
                ),
              ),
              // SlidableAction(
              //   onPressed: delete,
              //   backgroundColor: Colors.red,
              //   foregroundColor: Colors.white,
              //   icon: Icons.delete,
              //   label: 'Delete',
              //   borderRadius: BorderRadius.only(
              //     topRight: Radius.circular(4.w),
              //     bottomRight: Radius.circular(4.w),
              //   ),
              // ),
            ],
          ),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 8.w),
            height: 70.h,
            child: Text(
              "Backup date: " +
                  DateFormat('dd-MM-yyyy hh:mm:ss').format(
                    DateTime.parse(name),
                  ),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
