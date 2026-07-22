import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SelectRoleController extends GetxController {
  RxString selectedRole = "User".obs;

  void setRole(String role) {
    selectedRole.value = role;
  }
}
