import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ActiveChatCubit extends Cubit<String?> {
  ActiveChatCubit() : super(null); 

  
  void selectChat(String id) => emit(id);

  
  void createNewChat() => emit(null);
}
