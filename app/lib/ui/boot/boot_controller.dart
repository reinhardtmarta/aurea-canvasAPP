import '../../core/boot/boot_engine.dart';
import '../../core/boot/boot_intent.dart';

class BootController {
  final BootEngine _engine = BootEngine();

  BootIntent? lastIntent;

  BootIntent handleInput(String text) {
    final intent = _engine.parseInput(text);
    lastIntent = intent;
    return intent;
  }
}
