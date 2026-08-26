import 'package:ai_app/config/routs/approuting.dart';
import 'package:ai_app/core/widgets/write_inpute_text_widget.dart';
import 'package:ai_app/features/feature_maketaks/domain/entities/task_list_entity.dart';
import 'package:ai_app/features/feature_maketaks/presentation/bloc/feature_tasks_bloc.dart';
import 'package:ai_app/features/feature_maketaks/presentation/bloc/mt_status.dart';
import 'package:ai_app/features/feature_maketaks/presentation/bloc/tl_status.dart';
import 'package:ai_app/features/feature_maketaks/presentation/widgets/tasks_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/widgets/customsnackbar.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TextEditingController _makeTaskController = TextEditingController();
  final _fabKey = GlobalKey<ExpandableFabState>();
  @override
  void initState() {
    super.initState();
    // Load tasks once when page is first shown.
    context.read<FeatureTasksBloc>().add(FetchAllTasksEvent(id: "1"));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Constants.backcolor,
      onRefresh: () async {
        final refBloc = context.read<FeatureTasksBloc>();
        return refBloc.add(FetchAllTasksEvent(id: 1.toString()));
      },
      child: Scaffold(
        floatingActionButton: MicOnhold(
          fabKey: _fabKey,
          onAddPressed: () {
            final tasksBloc = context.read<FeatureTasksBloc>();
            showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return BlocProvider.value(
                    value: tasksBloc,
                    child: Center(
                        child: chatbox(
                      context,
                      controller: _makeTaskController,
                      onTap: () {
                        tasksBloc.add(MaketaskEvent(
                          message: _makeTaskController.text,
                        ));

                        _makeTaskController.clear();
                        AppRouting.back(dialogContext);
                        //    AppRouting.back(context);
                      },
                    )),
                  );
                });
          },
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        backgroundColor: Constants.solidGlassColor,
        body: BlocConsumer<FeatureTasksBloc, FeatureTasksState>(
          listener: (BuildContext context, FeatureTasksState state) {
            if (state.mtStatus is MtCompleted) {
              CustomSnackBar.show(context, "تسک شما ثبت شد!");
              context.read<FeatureTasksBloc>().add(ResetMtStatusEvent());
            }

            // اصلاح این بخش:
            else if (state.mtStatus is MtError) {
              String errorMessage = "خطایی رخ داد";
              // چک کنید که آیا واقعا tlStatus خطا دارد یا خود mtStatus
              if (state.tlStatus is TlError) {
                errorMessage = (state.tlStatus as TlError).message;
              }

              CustomSnackBar.show(context, errorMessage, isError: true);
              context.read<FeatureTasksBloc>().add(ResetMtStatusEvent());
            }
          },
          builder: (context, state) {
            if (state.tlStatus is TlLoading ||
                state.mtStatus is MtLoading ||
                state.tlStatus is TlInitial) {
              return Center(
                  child: CircularProgressIndicator(
                color: Constants.accentColor,
              ));
            }
            if (state.tlStatus is TlCompleted) {
              final taskList =
                  (state.tlStatus as TlCompleted).data as TaskListEntity;
              debugPrint("sized of List ${taskList.tasks.length}");

              if (taskList.tasks.isEmpty) {
                debugPrint("sized of List ${taskList.tasks.length}");
                return _buildEmptyView();
              }

              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsetsGeometry.only(
                        top: 80, right: 10, left: 10, bottom: 10),
                    sliver: SliverList.builder(
                        itemCount: taskList.tasks.length,
                        itemBuilder: (tasksBuildContext, index) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: TaskDetailBox(
                              title: taskList.tasks[index].title ?? "Error",
                              description:
                                  taskList.tasks[index].desc ?? "Error",
                              onDismissed: (DismissDirection p1) async {
                                debugPrint("Attempting to add event...");
                                BlocProvider.of<FeatureTasksBloc>(
                                        tasksBuildContext)
                                    .add(DeleteTaskEvent(
                                        id: taskList.tasks[index].id ??
                                            "Error"));
                                CustomSnackBar.show(
                                    tasksBuildContext, "حذف شد! ");
                              },
                              keydismis:
                                  Key(taskList.tasks[index].id ?? "Error"),
                            ),
                          );
                        }),
                  )
                ],
              );
            }
            return _buildErrorView(error: (state.tlStatus as TlError).message);
          },
        ),
      ),
    );
  }
}

Widget _buildEmptyView() {
  return CustomScrollView(
    physics: AlwaysScrollableScrollPhysics(),
    slivers: [
      SliverFillRemaining(
        child: Center(
            child: Text(
          "لیست خالی است",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 40),
        )),
      )
    ],
  );
}

Widget _buildErrorView({required String error}) {
  return CustomScrollView(
    physics: AlwaysScrollableScrollPhysics(),
    slivers: [
      SliverFillRemaining(
        child: Center(
            child: Text(
          error,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 40),
        )),
      )
    ],
  );
}
