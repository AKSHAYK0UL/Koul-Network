//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <local_auth_windows/local_auth_plugin.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <sim_card_info/sim_card_info_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  LocalAuthPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("LocalAuthPlugin"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  SimCardInfoPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SimCardInfoPluginCApi"));
}
