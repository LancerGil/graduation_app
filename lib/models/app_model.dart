import 'package:scoped_model/scoped_model.dart';

import 'hw_home.dart';
import 'lesson_home.dart';

mixin LessonCreatingModel on Model {
  Lesson _lessonCreating;
  setLessonCreating(lessonCreating) {
    _lessonCreating = lessonCreating;
  }

  get lessonCreating => _lessonCreating;
}

mixin HwCreatingModel on Model {
  Homework _hwCreating;
  setHwCreating(hwCreating) {
    _hwCreating = hwCreating;
  }

  get hwCreating => _hwCreating;
}

class AppModel extends Model with HwCreatingModel, LessonCreatingModel {
  static AppModel of(context, {rebuildOnChange}) {
    if (rebuildOnChange)
      return ScopedModel.of<AppModel>(context,
          rebuildOnChange: rebuildOnChange);
    else
      return ScopedModel.of<AppModel>(context);
  }
}
