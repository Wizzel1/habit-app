import 'package:Marbit/controllers/controllers.dart';
import 'package:get/get.dart';

class GlobalControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TutorialController>(() => TutorialController());
    Get.lazyPut<DateController>(() => DateController());
    Get.lazyPut<ContentController>(() => ContentController());
    Get.lazyPut<EditContentController>(() => EditContentController(),
        fenix: true);
    Get.lazyPut<AdController>(() => AdController());
  }
}
