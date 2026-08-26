import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ActiveChatCubit extends Cubit<String?> {
  ActiveChatCubit() : super(null); // در ابتدا هیچ چتی انتخاب نشده

  // وقتی کاربر روی یک چت در سایدبار کلیک میکنه
  void selectChat(String id) => emit(id);

  // وقتی کاربر دکمه "چت جدید" رو میزنه
  void createNewChat() => emit(null);
}
