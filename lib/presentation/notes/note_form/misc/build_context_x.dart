import 'package:flutter/widgets.dart';
import 'package:kt_dart/kt.dart';
import 'package:provider/provider.dart';

import 'todo_item_presentation_classes.dart';

extension FormTodosX on BuildContext {
  KtList<TodoItemPrimitive> get formTodos =>
      Provider.of<FormTodos>(this, listen: false).value;
  set formTodos(KtList<TodoItemPrimitive> value) =>
      Provider.of<FormTodos>(this, listen: false).value = value;
}
