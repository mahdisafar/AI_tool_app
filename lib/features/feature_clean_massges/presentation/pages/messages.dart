import 'package:ai_app/config/routs/approuting.dart';
import 'package:ai_app/core/widgets/custom_showdeletedialog.dart';
import 'package:ai_app/features/feature_clean_massges/presentation/bloc/state_status.dart';
import 'package:ai_app/features/feature_clean_massges/presentation/widgets/messages_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/widgets/customsnackbar.dart';
import '../../domain/entities/cln_mg_entity.dart' show ClnMgEntity;
import '../bloc/feature_clean_massges_bloc.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  void initState() {
    super.initState();
    context.read<FeatureCleanMassgesBloc>().add(FetchCleanMessagesEvent("1"));
  }

  TextEditingController controller = TextEditingController();
  String _currentStyle = "FORMAL";
  void openChatDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, 
      builder: (BuildContext dialogContext) {
        
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 20), 
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: SizedBox(
                
                width: 300,
                child: chatboxWithStyle(
                  context,
                  controller: controller,
                  selectedStyle: _currentStyle,
                  onStyleChanged: (newStyle) {
                    setDialogState(() => _currentStyle = newStyle);
                  },
                  onTap: () {
                    if (controller.text.isNotEmpty) {
                      
                      this.context.read<FeatureCleanMassgesBloc>().add(
                          CreateCleanMessageEvent(
                              "$_currentStyle: ${controller.text}"));
                      Navigator.pop(dialogContext);
                      controller.clear();
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Constants.backcolor,
      onRefresh: () async {
        final refbloc = context.read<FeatureCleanMassgesBloc>();
        return refbloc.add(FetchCleanMessagesEvent("1"));
      },
      child: Scaffold(
          floatingActionButton: customFAB(
            onPressed: () {
              FocusScope.of(context).unfocus();

              Future.delayed(const Duration(milliseconds: 100), () {
                if (mounted) openChatDialog();
              });
            },
          ),
          backgroundColor: Constants.solidGlassColor,
          body: BlocConsumer<FeatureCleanMassgesBloc, FeatureCleanMassgesState>(
            listener: (BuildContext context, FeatureCleanMassgesState state) {
              if (state.clnStatus == ClnStatus.success) {
                CustomSnackBar.show(context, "تسک شما ثبت شد!");
                context
                    .read<FeatureCleanMassgesBloc>()
                    .add(ResetCleanMessageStatusEvent());
              }

              
              else if (state.clnStatus == ClnStatus.failure) {
                CustomSnackBar.show(
                    context, state.errorMessage ?? "خطایی رخ داد",
                    isError: true);
                context
                    .read<FeatureCleanMassgesBloc>()
                    .add(ResetCleanMessageStatusEvent());
              }
            },
            builder: (context, state) {
              if (state.clnListStatus == ClnListStatus.loading ||
                  state.clnStatus == ClnStatus.loading) {
                if (mounted) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Constants.accentColor,
                  ));
                }
              }
              if (state.clnListStatus == ClnListStatus.failure ||
                  state.clnStatus == ClnStatus.failure) {
                return buildError(
                  error: state.errorMessage ?? "خطای نامشخص",
                  onPressed: () {
                    context
                        .read<FeatureCleanMassgesBloc>()
                        .add(ResetCleanMessageStatusEvent());
                  },
                );
              }
              List<ClnMgEntity> messages = [];
              if (state.clnListStatus != ClnListStatus.failure) {
                messages = state.messages;
              }
              if (messages.isEmpty) {
                return _buildEmptyView();
              }
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsetsGeometry.only(
                        top: 80, right: 20, left: 20, bottom: 10),
                    sliver: SliverGrid.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final item = messages[index];
                        return Directionality(
                            textDirection: TextDirection.rtl,
                            child: squareMessages(
                              context,
                              onPressed: () {
                                showDeleteDialog(context, onPressed: () {
                                  context.read<FeatureCleanMassgesBloc>().add(
                                      DeleteCleanMessageEvent(
                                          item.id ?? "Error"));
                                  AppRouting.back(context);
                                });
                              },
                              title: item.title ?? "error ",
                              description: item.desc ?? "error",
                            ));
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.7),
                    ),
                  )
                ],
              );
            },
          )),
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
