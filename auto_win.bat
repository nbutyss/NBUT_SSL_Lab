copy "3rdParty\protobuf\bin\protoc.exe" "Medusa\share\proto\" /y
copy "3rdParty\lua\bin\lua5.1.dll" "ZBin\" /y
copy "3rdParty\tolua++\bin\lua5.1.dll" "Medusa\src\LuaModule\" /y
copy "3rdParty\tolua++\bin\tolua++.dll" "Medusa\src\LuaModule\" /y
copy "3rdParty\tolua++\bin\tolua++.exe" "Medusa\src\LuaModule\" /y
cd Medusa\share\proto
mkdir cpp
.\protoc.exe --cpp_out=cpp .\grSim_Commands.proto .\grSim_Packet.proto .\grSim_Replacement.proto .\grSimMessage.proto .\log_labeler_data.proto .\log_labels.proto .\messages_robocup_ssl_detection.proto .\messages_robocup_ssl_geometry.proto .\messages_robocup_ssl_geometry_legacy.proto .\messages_robocup_ssl_refbox_log.proto .\messages_robocup_ssl_wrapper.proto .\messages_robocup_ssl_wrapper_legacy.proto .\ssl_game_controller_auto_ref.proto .\ssl_game_controller_common.proto .\ssl_game_controller_team.proto .\ssl_game_event.proto .\ssl_game_event_2019.proto .\ssl_referee.proto .\vision_detection.proto .\zss_cmd.proto .\zss_debug.proto .\zss_rec_old.proto
cd ..\..\src\LuaModule
.\tolua++.exe -n zeus -o lua_zeus.cpp zeus.pkg