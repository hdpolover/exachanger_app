import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/model/metadata_model.dart';
import 'package:exachanger_get_app/app/data/repository/metadata/metadata_repository.dart';
import 'package:get/get.dart';

class WelcomeController extends BaseController {
  final MetadataRepository _metadataRepository =
      Get.find(tag: (MetadataRepository).toString());

  final Rx<MetaDataModel?> metaData = Rx<MetaDataModel?>(null);

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getWelcomeInfo() {
    var service = _metadataRepository.getPageContent('onboarding-page');

    callDataService(service, onSuccess: (data) {
      metaData.value = data;
    }, onError: (error) {
      print(error);
    });
  }
}
