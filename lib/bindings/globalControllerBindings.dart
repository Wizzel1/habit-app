import 'package:Marbit/controllers/controllers.dart';
import 'package:get/get.dart';

class GlobalControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NotifyController());
    Get.lazyPut<TutorialController>(() => TutorialController());
    Get.lazyPut<DateController>(() => DateController());
    Get.lazyPut<NotificationTimesController>(
        () => NotificationTimesController(),
        fenix: true);
    Get.lazyPut<ContentController>(() => ContentController());
    Get.lazyPut<EditContentController>(() => EditContentController(),
        fenix: true);
    Get.put<AdController>(AdController());
  }
}
