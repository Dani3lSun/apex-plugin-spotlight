set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.4.00.08'
,p_default_workspace_id=>1880351014913940
,p_default_application_id=>600
,p_default_owner=>'APEX_PLUGIN'
);
end;
/
 
prompt APPLICATION 600 - APEX Plugins
--
-- Application Export:
--   Application:     600
--   Name:            APEX Plugins
--   Date and Time:   11:57 Friday October 25, 2019
--   Exported By:     APEX_PLUGIN
--   Flashback:       0
--   Export Type:     Application Export
--   Version:         5.1.4.00.08
--   Instance ID:     218293662590390
--

-- Application Statistics:
--   Pages:                     25
--     Items:                   25
--     Validations:              1
--     Processes:                5
--     Regions:                 74
--     Buttons:                 25
--     Dynamic Actions:         43
--   Shared Components:
--     Logic:
--       Processes:              4
--     Navigation:
--       Lists:                  2
--       Breadcrumbs:            1
--         Entries:             22
--     Security:
--       Authentication:         2
--       Authorization:          2
--     User Interface:
--       Themes:                 1
--       Templates:
--         Page:                 9
--         Region:              15
--         Label:                5
--         List:                11
--         Popup LOV:            1
--         Calendar:             1
--         Breadcrumb:           1
--         Button:               3
--         Report:               9
--       Plug-ins:              26
--     Globalization:
--     Reports:
--   Supporting Objects:  Included
--     Install scripts:          5

prompt --application/shared_components/plugins/dynamic_action/de_danielh_apexspotlight
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(4530505245571775)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'DE.DANIELH.APEXSPOTLIGHT'
,p_display_name=>'APEX Spotlight Search'
,p_category=>'INIT'
,p_supported_ui_types=>'DESKTOP'
,p_image_prefix => nvl(wwv_flow_application_install.get_static_plugin_file_prefix('DYNAMIC ACTION','DE.DANIELH.APEXSPOTLIGHT'),'')
,p_javascript_file_urls=>'#PLUGIN_FILES#js/apexspotlight#MIN#.js'
,p_css_file_urls=>'#PLUGIN_FILES#css/apexspotlight#MIN#.css'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*-------------------------------------',
' * APEX Spotlight Search',
' * Version: 1.6.1',
' * Author:  Daniel Hochleitner',
' *-------------------------------------',
'*/',
'',
'--',
'-- Plug-in Render Function',
'-- #param p_dynamic_action',
'-- #param p_plugin',
'-- #return apex_plugin.t_dynamic_action_render_result',
'FUNCTION render_apexspotlight(p_dynamic_action IN apex_plugin.t_dynamic_action,',
'                              p_plugin         IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_dynamic_action_render_result IS',
'  --',
'  l_result apex_plugin.t_dynamic_action_render_result;',
'  --',
'  -- plugin attributes',
'  l_placeholder_text           p_plugin.attribute_01%TYPE := nvl(p_dynamic_action.attribute_12,',
'                                                                 p_plugin.attribute_01);',
'  l_more_chars_text            p_plugin.attribute_02%TYPE := p_plugin.attribute_02;',
'  l_no_match_text              p_plugin.attribute_03%TYPE := p_plugin.attribute_03;',
'  l_one_match_text             p_plugin.attribute_04%TYPE := p_plugin.attribute_04;',
'  l_multiple_matches_text      p_plugin.attribute_05%TYPE := p_plugin.attribute_05;',
'  l_inpage_search_text         p_plugin.attribute_06%TYPE := p_plugin.attribute_06;',
'  l_search_history_delete_text p_plugin.attribute_07%TYPE := p_plugin.attribute_07;',
'  --',
'  l_enable_keyboard_shortcuts    VARCHAR2(5) := nvl(p_dynamic_action.attribute_01,',
'                                                    ''N'');',
'  l_keyboard_shortcuts           p_dynamic_action.attribute_02%TYPE := p_dynamic_action.attribute_02;',
'  l_submit_items                 p_dynamic_action.attribute_04%TYPE := p_dynamic_action.attribute_04;',
'  l_enable_inpage_search         VARCHAR2(5) := nvl(p_dynamic_action.attribute_05,',
'                                                    ''Y'');',
'  l_max_display_results          NUMBER := to_number(p_dynamic_action.attribute_06);',
'  l_width                        p_dynamic_action.attribute_07%TYPE := p_dynamic_action.attribute_07;',
'  l_enable_data_cache            VARCHAR2(5) := nvl(p_dynamic_action.attribute_08,',
'                                                    ''N'');',
'  l_theme                        p_dynamic_action.attribute_09%TYPE := nvl(p_dynamic_action.attribute_09,',
'                                                                           ''STANDARD'');',
'  l_enable_prefill_selected_text VARCHAR2(5) := nvl(p_dynamic_action.attribute_10,',
'                                                    ''N'');',
'  l_show_processing              VARCHAR2(5) := nvl(p_dynamic_action.attribute_11,',
'                                                    ''N'');',
'  l_placeholder_icon             p_dynamic_action.attribute_13%TYPE := nvl(p_dynamic_action.attribute_13,',
'                                                                           ''DEFAULT'');',
'  l_escape_special_chars         VARCHAR2(5) := nvl(p_dynamic_action.attribute_14,',
'                                                    ''Y'');',
'  l_enable_search_history        VARCHAR2(5) := nvl(p_dynamic_action.attribute_15,',
'                                                    ''N'');',
'  --',
'  l_component_config_json CLOB := empty_clob();',
'  --',
'  -- Get DA internal event name',
'  FUNCTION get_da_event_name(p_action_id IN NUMBER) RETURN VARCHAR2 IS',
'    --',
'    l_da_event_name apex_application_page_da.when_event_internal_name%TYPE;',
'    --',
'    CURSOR l_cur_da_event IS',
'      SELECT aapd.when_event_internal_name',
'        FROM apex_application_page_da      aapd,',
'             apex_application_page_da_acts aapda',
'       WHERE aapd.dynamic_action_id = aapda.dynamic_action_id',
'         AND aapd.application_id = (SELECT nv(''APP_ID'')',
'                                      FROM dual)',
'         AND aapda.action_id = p_action_id;',
'    --',
'  BEGIN',
'    --',
'    OPEN l_cur_da_event;',
'    FETCH l_cur_da_event',
'      INTO l_da_event_name;',
'    CLOSE l_cur_da_event;',
'    --',
'    RETURN nvl(l_da_event_name,',
'               ''ready'');',
'    --',
'  END get_da_event_name;',
'  --',
'  -- Get DA Fire on Initialization property',
'  FUNCTION get_da_fire_on_init(p_action_id IN NUMBER) RETURN VARCHAR2 IS',
'    --',
'    l_da_fire_on_init apex_application_page_da_acts.execute_on_page_init%TYPE;',
'    --',
'    CURSOR l_cur_da_fire_on_init IS',
'      SELECT decode(aapda.execute_on_page_init,',
'                    ''Yes'',',
'                    ''Y'',',
'                    ''No'',',
'                    ''N'') AS execute_on_page_init',
'        FROM apex_application_page_da_acts aapda',
'       WHERE aapda.application_id = (SELECT nv(''APP_ID'')',
'                                       FROM dual)',
'         AND aapda.action_id = p_action_id;',
'    --',
'  BEGIN',
'    --',
'    OPEN l_cur_da_fire_on_init;',
'    FETCH l_cur_da_fire_on_init',
'      INTO l_da_fire_on_init;',
'    CLOSE l_cur_da_fire_on_init;',
'    --',
'    RETURN nvl(l_da_fire_on_init,',
'               ''N'');',
'    --',
'  END get_da_fire_on_init;',
'  --',
'BEGIN',
'  -- Debug',
'  IF apex_application.g_debug THEN',
'    apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin,',
'                                          p_dynamic_action => p_dynamic_action);',
'  END IF;',
'  --',
'  -- add mousetrap.js & mark.js libs & tippy libs',
'  IF l_enable_keyboard_shortcuts = ''Y'' THEN',
'    apex_javascript.add_library(p_name                  => ''mousetrap'',',
'                                p_directory             => p_plugin.file_prefix || ''js/'',',
'                                p_version               => NULL,',
'                                p_skip_extension        => FALSE,',
'                                p_check_to_add_minified => TRUE);',
'  END IF;',
'  --',
'  IF l_enable_inpage_search = ''Y'' THEN',
'    apex_javascript.add_library(p_name                  => ''jquery.mark'',',
'                                p_directory             => p_plugin.file_prefix || ''js/'',',
'                                p_version               => NULL,',
'                                p_skip_extension        => FALSE,',
'                                p_check_to_add_minified => TRUE);',
'  END IF;',
'  --',
'  IF l_enable_search_history = ''Y'' THEN',
'    apex_javascript.add_library(p_name                  => ''tippy.all'',',
'                                p_directory             => p_plugin.file_prefix || ''js/'',',
'                                p_version               => NULL,',
'                                p_skip_extension        => FALSE,',
'                                p_check_to_add_minified => TRUE);',
'  END IF;',
'  -- escape input',
'  IF l_escape_special_chars = ''Y'' THEN',
'    l_placeholder_text           := apex_escape.html(l_placeholder_text);',
'    l_more_chars_text            := apex_escape.html(l_more_chars_text);',
'    l_no_match_text              := apex_escape.html(l_no_match_text);',
'    l_one_match_text             := apex_escape.html(l_one_match_text);',
'    l_multiple_matches_text      := apex_escape.html(l_multiple_matches_text);',
'    l_inpage_search_text         := apex_escape.html(l_inpage_search_text);',
'    l_search_history_delete_text := apex_escape.html(l_search_history_delete_text);',
'    l_placeholder_icon           := apex_escape.html(l_placeholder_icon);',
'  END IF;',
'  -- build component config json',
'  apex_json.initialize_clob_output;',
'  apex_json.open_object();',
'  -- general',
'  apex_json.write(''dynamicActionId'',',
'                  p_dynamic_action.id);',
'  apex_json.write(''ajaxIdentifier'',',
'                  apex_plugin.get_ajax_identifier);',
'  apex_json.write(''eventName'',',
'                  get_da_event_name(p_action_id => p_dynamic_action.id));',
'  apex_json.write(''fireOnInit'',',
'                  get_da_fire_on_init(p_action_id => p_dynamic_action.id));',
'  -- app wide attributes',
'  apex_json.write(''placeholderText'',',
'                  l_placeholder_text);',
'  apex_json.write(''moreCharsText'',',
'                  l_more_chars_text);',
'  apex_json.write(''noMatchText'',',
'                  l_no_match_text);',
'  apex_json.write(''oneMatchText'',',
'                  l_one_match_text);',
'  apex_json.write(''multipleMatchesText'',',
'                  l_multiple_matches_text);',
'  apex_json.write(''inPageSearchText'',',
'                  l_inpage_search_text);',
'  apex_json.write(''searchHistoryDeleteText'',',
'                  l_search_history_delete_text);',
'  -- component attributes',
'  apex_json.write(''enableKeyboardShortcuts'',',
'                  l_enable_keyboard_shortcuts);',
'  apex_json.write(''keyboardShortcuts'',',
'                  l_keyboard_shortcuts);',
'  apex_json.write(''submitItems'',',
'                  l_submit_items);',
'  apex_json.write(''enableInPageSearch'',',
'                  l_enable_inpage_search);',
'  apex_json.write(''maxNavResult'',',
'                  l_max_display_results);',
'  apex_json.write(''width'',',
'                  l_width);',
'  apex_json.write(''enableDataCache'',',
'                  l_enable_data_cache);',
'  apex_json.write(''spotlightTheme'',',
'                  l_theme);',
'  apex_json.write(''enablePrefillSelectedText'',',
'                  l_enable_prefill_selected_text);',
'  apex_json.write(''showProcessing'',',
'                  l_show_processing);',
'  apex_json.write(''placeHolderIcon'',',
'                  l_placeholder_icon);',
'  apex_json.write(''enableSearchHistory'',',
'                  l_enable_search_history);',
'  apex_json.close_object();',
'  --',
'  l_component_config_json := apex_json.get_clob_output;',
'  apex_json.free_output;',
'  -- init keyboard shortcut',
'  IF l_enable_keyboard_shortcuts = ''Y'' THEN',
'    apex_javascript.add_inline_code(p_code => ''function apexSpotlightInitKeyboardShortcuts'' || p_dynamic_action.id ||',
'                                              ''() { apex.da.apexSpotlight.initKeyboardShortcuts('' ||',
'                                              l_component_config_json || ''); }'');',
'    apex_javascript.add_onload_code(p_code => ''apexSpotlightInitKeyboardShortcuts'' || p_dynamic_action.id || ''();'');',
'  END IF;',
'  -- DA javascript function',
'  l_result.javascript_function := ''function() { apex.da.apexSpotlight.pluginHandler('' || l_component_config_json ||',
'                                  ''); }'';',
'  --',
'  RETURN l_result;',
'  --',
'END render_apexspotlight;',
'--',
'-- Plug-in AJAX Function',
'-- #param p_dynamic_action',
'-- #param p_plugin',
'-- #return apex_plugin.t_dynamic_action_ajax_result',
'FUNCTION ajax_apexspotlight(p_dynamic_action IN apex_plugin.t_dynamic_action,',
'                            p_plugin         IN apex_plugin.t_plugin) RETURN apex_plugin.t_dynamic_action_ajax_result IS',
'  --',
'  l_result apex_plugin.t_dynamic_action_ajax_result;',
'  --',
'  l_request_type VARCHAR2(50);',
'  --',
'  -- Execute Spotlight GET_DATA Request',
'  PROCEDURE exec_get_data_request(p_dynamic_action IN apex_plugin.t_dynamic_action,',
'                                  p_plugin         IN apex_plugin.t_plugin) IS',
'    l_data_source_sql_query p_dynamic_action.attribute_03%TYPE := p_dynamic_action.attribute_03;',
'    l_escape_special_chars  VARCHAR2(5) := nvl(p_dynamic_action.attribute_14,',
'                                               ''Y'');',
'    l_data_type_list        apex_application_global.vc_arr2;',
'    l_column_value_list     apex_plugin_util.t_column_value_list2;',
'    l_row_count             NUMBER;',
'    l_name                  VARCHAR2(4000);',
'    l_description           VARCHAR2(4000);',
'    l_link                  VARCHAR2(4000);',
'    l_icon                  VARCHAR2(4000);',
'    l_icon_color            VARCHAR2(4000);',
'  BEGIN',
'    -- Data Types of SQL Source Columns',
'    l_data_type_list(1) := apex_plugin_util.c_data_type_varchar2;',
'    l_data_type_list(2) := apex_plugin_util.c_data_type_varchar2;',
'    l_data_type_list(3) := apex_plugin_util.c_data_type_varchar2;',
'    l_data_type_list(4) := apex_plugin_util.c_data_type_varchar2;',
'    l_data_type_list(5) := apex_plugin_util.c_data_type_varchar2;',
'    -- Get Data from SQL Source',
'    l_column_value_list := apex_plugin_util.get_data2(p_sql_statement  => l_data_source_sql_query,',
'                                                      p_min_columns    => 4,',
'                                                      p_max_columns    => 5,',
'                                                      p_data_type_list => l_data_type_list,',
'                                                      p_component_name => p_dynamic_action.action);',
'    -- loop over SQL Source results and write json',
'    apex_json.open_array();',
'    --',
'    l_row_count := l_column_value_list(1).value_list.count;',
'    --',
'    FOR i IN 1 .. l_row_count LOOP',
'      -- escape input',
'      IF l_escape_special_chars = ''Y'' THEN',
'        l_name        := apex_escape.html(l_column_value_list(1).value_list(i).varchar2_value);',
'        l_description := apex_escape.html(l_column_value_list(2).value_list(i).varchar2_value);',
'        l_link        := l_column_value_list(3).value_list(i).varchar2_value;',
'        l_icon        := apex_escape.html(l_column_value_list(4).value_list(i).varchar2_value);',
'        IF l_column_value_list.last = 5 THEN',
'          l_icon_color := apex_escape.html(l_column_value_list(5).value_list(i).varchar2_value);',
'        END IF;',
'      ELSE',
'        l_name        := l_column_value_list(1).value_list(i).varchar2_value;',
'        l_description := l_column_value_list(2).value_list(i).varchar2_value;',
'        l_link        := l_column_value_list(3).value_list(i).varchar2_value;',
'        l_icon        := l_column_value_list(4).value_list(i).varchar2_value;',
'        IF l_column_value_list.last = 5 THEN',
'          l_icon_color := l_column_value_list(5).value_list(i).varchar2_value;',
'        END IF;',
'      END IF;',
'      -- write json',
'      apex_json.open_object;',
'      -- name / title',
'      apex_json.write(''n'',',
'                      l_name);',
'      -- description',
'      apex_json.write(''d'',',
'                      l_description);',
'      -- link / URL',
'      apex_json.write(''u'',',
'                      l_link);',
'      -- icon',
'      apex_json.write(''i'',',
'                      l_icon);',
'      -- icon color (optional)',
'      IF l_column_value_list.last = 5 THEN',
'        apex_json.write(''ic'',',
'                        nvl(l_icon_color,',
'                            ''DEFAULT''));',
'      END IF;',
'      -- if URL contains ~SEARCH_VALUE~, make list entry static',
'      IF instr(l_link,',
'               ''~SEARCH_VALUE~'') > 0 THEN',
'        apex_json.write(''s'',',
'                        TRUE);',
'      ELSE',
'        apex_json.write(''s'',',
'                        FALSE);',
'      END IF;',
'      -- type',
'      apex_json.write(''t'',',
'                      ''redirect'');',
'      apex_json.close_object;',
'    END LOOP;',
'    --',
'    apex_json.close_array;',
'  END exec_get_data_request;',
'  --',
'  -- Execute Spotlight GET_URL Request',
'  PROCEDURE exec_get_url_request(p_dynamic_action IN apex_plugin.t_dynamic_action,',
'                                 p_plugin         IN apex_plugin.t_plugin) IS',
'    l_search_value VARCHAR2(1000);',
'    l_url          VARCHAR2(4000);',
'    l_url_new      VARCHAR2(4000);',
'  BEGIN',
'    -- get values from AJAX call X02/X03',
'    l_search_value := apex_application.g_x02;',
'    l_url          := apex_application.g_x03;',
'    -- Check for f?p URL and if URL contains ~SEARCH_VALUE~ substitution string',
'    IF instr(l_url,',
'             ''f?p='') > 0',
'       AND instr(l_url,',
'                 ''~SEARCH_VALUE~'') > 0 THEN',
'      -- replace substitution string with real search value',
'      l_url := REPLACE(l_url,',
'                       ''~SEARCH_VALUE~'',',
'                       l_search_value);',
'      -- if input URL already contains a checksum > remove checksum',
'      IF instr(l_url,',
'               ''&cs='') > 0 THEN',
'        l_url := substr(l_url,',
'                        1,',
'                        instr(l_url,',
'                              ''&cs='') - 1);',
'      END IF;',
'      -- get SSP URL',
'      l_url_new := apex_util.prepare_url(p_url => l_url);',
'      --',
'      apex_json.open_object;',
'      apex_json.write(''url'',',
'                      l_url_new);',
'      apex_json.close_object;',
'      -- if checks don''t succeed return input URL back',
'    ELSE',
'      apex_json.open_object;',
'      apex_json.write(''url'',',
'                      l_url);',
'      apex_json.close_object;',
'    END IF;',
'  END exec_get_url_request;',
'  --',
'BEGIN',
'  -- Check request type in X01',
'  l_request_type := apex_application.g_x01;',
'  -- GET_DATA Request',
'  IF l_request_type = ''GET_DATA'' THEN',
'    exec_get_data_request(p_dynamic_action => p_dynamic_action,',
'                          p_plugin         => p_plugin);',
'    -- GET_URL Request',
'  ELSIF l_request_type = ''GET_URL'' THEN',
'    exec_get_url_request(p_dynamic_action => p_dynamic_action,',
'                         p_plugin         => p_plugin);',
'    --',
'  END IF;',
'  --',
'  RETURN l_result;',
'  --',
'END ajax_apexspotlight;'))
,p_api_version=>2
,p_render_function=>'render_apexspotlight'
,p_ajax_function=>'ajax_apexspotlight'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'<p>APEX Spotlight Search is a powerful search feature (like on MacOS) to search. It provides quick navigation and unified search experience across an APEX application.</p>'
,p_version_identifier=>'1.6.1'
,p_about_url=>'https://github.com/Dani3lSun/apex-plugin-spotlight'
,p_files_version=>1738
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4563098924697023)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Search Placeholder Text'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Search'
,p_is_translatable=>true
,p_help_text=>'<p>Text that is displayed in the spotlight search input field as an placeholder</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4563867390704257)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'More Characters Text'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Please enter at least two letters to search'
,p_is_translatable=>true
,p_help_text=>'<p>Text that is displayed when not enough characters are entered to activate search feature</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4564312834713979)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'No Match Found Text'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'No match found'
,p_is_translatable=>true
,p_help_text=>'<p>Text that is displayed when no search result was found</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4564835998718016)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'1 Match Found Text'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'1 match found'
,p_is_translatable=>true
,p_help_text=>'<p>Text that is displayed when 1 search result was found</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4565357323725375)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Multiple Matches Found Text'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'matches found'
,p_is_translatable=>true
,p_help_text=>'<p>Text that is displayed when multiple search results were found</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4589989761224450)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'In-Page Search Text'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Search on current Page'
,p_is_translatable=>true
,p_help_text=>'<p>Text that is displayed in the spotlight search list for in-page search feature</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(6144554665397796)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Search History Delete Text'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Clear Search History'
,p_is_translatable=>true
,p_help_text=>'<p>Text that is displayed in the spotlight search history list to delete local search history. Only valid when you enabled search history feature.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4561364883150494)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Enable Keyboard Shortcuts'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>'<p>Enables you to add custom keyboard shortcuts to open spotlight search</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4561674678185410)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Keyboard Shortcuts'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'ctrl+k,command+k'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(4561364883150494)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>You can specify multiple keyboard shortcuts, just separate the different shortcuts by a comma!</p>',
'<p>In the background a JavaScript library called "Mousetrap" is handling all keyboard shortcut things, if you will learn more about possible shortcuts or want to read some docs, just visit their site: https://craig.is/killing/mice</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4561921951357097)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Data Source SQL'
,p_attribute_type=>'SQL'
,p_is_required=>true
,p_sql_min_column_count=>4
,p_sql_max_column_count=>5
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'SELECT ''My Homepage'' AS title',
'      ,''This is my awesome homepage'' AS description',
'      ,''https://danielhochleitner.de'' AS link',
'      ,''fa-home'' AS icon',
'  FROM dual',
'</pre>',
'<pre>',
'SELECT aap.page_title AS title',
'      ,''Go to page > '' || aap.page_title AS description',
'      ,apex_page.get_url(p_page => aap.page_id) AS link',
'      ,''fa-arrow-right'' AS icon',
'  FROM apex_application_pages aap',
' WHERE aap.application_id = :app_id',
'   AND aap.page_mode = ''Normal''',
'   AND aap.page_requires_authentication = ''Yes''',
'   AND aap.page_id != 0',
' ORDER BY aap.page_id',
'</pre>',
'<strong>Set Item with search term using substitution string "~SEARCH_VALUE~" in your link</strong>',
'<pre>',
'SELECT aap.page_title AS title',
'      ,''Set item with search keyword'' AS description',
'      ,apex_page.get_url(p_page   => aap.page_id',
'                        ,p_items  => ''P1_ITEM''',
'                        ,p_values => ''~SEARCH_VALUE~'') AS link',
'      ,''fa-home'' AS icon',
'      ,''#479d9d'' AS icon_color',
'  FROM apex_application_pages aap',
' WHERE aap.application_id = :app_id',
'   AND aap.page_id = 1',
'</pre>',
'<pre>',
'SELECT ''Set a item'' AS title',
'      ,''Set item with search keyword on client side'' AS description',
'      ,''javascript:$s(''''P1_ITEM'''',''''~SEARCH_VALUE~'''');'' AS link',
'      ,''fa-home'' AS icon',
'      ,''#479d9d'' AS icon_color',
'  FROM dual',
'</pre>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>SQL Query which returns the data which can be searched through spotlight search</p>',
'<p>',
'<strong>Column 1:</strong> Title<br>',
'<strong>Column 2:</strong> Description<br>',
'<strong>Column 3:</strong> Link / URL<br>',
'<strong>Column 4:</strong> Icon<br>',
'<strong>Column 5:</strong> Icon Background Color (optional)',
'</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4562768402680579)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Page Items to Submit'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'<p>Enter page or application items to be set into session state when the SQL query is executed via an AJAX request</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4562278866662697)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Enable In-Page Search'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_help_text=>'<p>Enable in-page search to highlight found results on the current page depending on the search keyword</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4637527129097868)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Max. Search Display Results'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'50'
,p_is_translatable=>false
,p_help_text=>'<p>The maximum allowed search results displayed at once</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4640149013134348)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Width'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'650'
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Pixels:<br>',
'650',
'400',
'800',
'</p>',
'<p>Percentage:<br>',
'100%',
'50%',
'80%',
'</p>'))
,p_help_text=>'<p>Width of the Spotlight search dialog. Enter either numbers for pixel values or percentage values</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4661395550109614)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>48
,p_prompt=>'Enable Local Data Cache'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Enable data cache to save the complete server response (from Data Source AJAX call) in session storage of browser. This helps to reduce calls from browser to server side.</p>',
'<p>The storage is valid until the APEX session ends or a user closes the active browser window</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4790632924577894)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Theme'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'STANDARD'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>If you would like to use you own CSS for Spotlight Search, have a look at the included CSS file "apexspotlight.css" and override the classes e.g. with Theme Roller.<br>',
'Example:</p>',
'<pre>',
'/* APEX Spotlight Search Orange Theme */',
'.apx-Spotlight-result-orange.is-active .apx-Spotlight-link {',
'  background-color: #f59e33;',
'  color: #fff;',
'}',
'',
'.apx-Spotlight-icon-orange {',
'  background-color: #79787e;',
'  color: #fff;',
'}',
'</pre>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Choose the Spotlight Search theme which best matches your current UI</p>',
'<p>Possible options:<br>',
'- Standard: Should be used in most cases, fits very well to Vita theme of UT<br>',
'- Orange: Orange list entries with white font and grey icons<br>',
'- Red: Red list entries with white font and light grey icons, fits well to Vita Red theme of UT<br></p>',
'- Dark: Dark grey list entries with white font and light grey icons, fits well to Vita Dark theme of UT</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(4791973575578684)
,p_plugin_attribute_id=>wwv_flow_api.id(4790632924577894)
,p_display_sequence=>10
,p_display_value=>'Standard'
,p_return_value=>'STANDARD'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(4792319056579318)
,p_plugin_attribute_id=>wwv_flow_api.id(4790632924577894)
,p_display_sequence=>20
,p_display_value=>'Orange'
,p_return_value=>'ORANGE'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(4808424884914231)
,p_plugin_attribute_id=>wwv_flow_api.id(4790632924577894)
,p_display_sequence=>30
,p_display_value=>'Red'
,p_return_value=>'RED'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(4792790189579859)
,p_plugin_attribute_id=>wwv_flow_api.id(4790632924577894)
,p_display_sequence=>40
,p_display_value=>'Dark'
,p_return_value=>'DARK'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4910263260697702)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>55
,p_prompt=>'Enable Prefill Selected Text'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>'<p>Enable prefill selected text to automatically set the spotlight search input to your selected / marked text when it opens</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(5017022816616753)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>44
,p_prompt=>'Show Processing'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Specify whether a waiting / processing indicator is displayed or not. This will replace the default search icon with an spinner as long as data is fetched from database.</p>',
'<p>Additionally a waiting spinner is displayed when a user selects a search result and get redirected to a APEX target page.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(5920706366322438)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>120
,p_prompt=>'Search Placeholder Text'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'<p>Text that is displayed in the spotlight search input field as an placeholder. Overrides application wide plugin setting.</p>'
);
end;
/
begin
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(5922469473330213)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>130
,p_prompt=>'Search Placeholder Icon'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'<p>Icon that is displayed in the spotlight search input field as an placeholder</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(5950238600964659)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>140
,p_prompt=>'Escape Special Characters'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_help_text=>'<p>To prevent Cross-Site Scripting (XSS) attacks, always set this attribute to <strong>Yes</strong>. If you need to render HTML tags stored in the page item or in the entries of a list of values, you can set this flag to No. In such cases, you should'
||' take additional precautions to ensure any user input to such fields are properly escaped when entered and before saving.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(6020847740463204)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>15
,p_display_sequence=>135
,p_prompt=>'Enable Search History'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Enable search history to show a popover (on mouse hover of main search icon next to spotlight input field) which contains the last 20 search terms of the user.</p>',
'<p>It uses browsers local storage to store the entered search terms.</p>'))
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(4637111000086027)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_name=>'apexspotlight-ajax-error'
,p_display_name=>'Get Server Data Error'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(4636715649086026)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_name=>'apexspotlight-ajax-success'
,p_display_name=>'Get Server Data Success'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(4635908239086026)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_name=>'apexspotlight-close-dialog'
,p_display_name=>'On Close'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(4636316282086026)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_name=>'apexspotlight-inpage-search'
,p_display_name=>'Executed In-Page Search'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(4635668649086025)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_name=>'apexspotlight-open-dialog'
,p_display_name=>'On Open'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E6170782D53706F746C696768747B646973706C61793A666C65783B6F766572666C6F773A68696464656E3B6865696768743A6175746F21696D706F7274616E747D2E6170782D53706F746C696768742D626F64797B666C65782D67726F773A313B6469';
wwv_flow_api.g_varchar2_table(2) := '73706C61793A666C65783B666C65782D646972656374696F6E3A636F6C756D6E3B2D7765626B69742D666F6E742D736D6F6F7468696E673A616E7469616C69617365643B6F766572666C6F773A68696464656E7D626F64792E617065782D73706F746C69';
wwv_flow_api.g_varchar2_table(3) := '6768742D6163746976657B6F766572666C6F773A68696464656E7D2E6170782D53706F746C696768742D726573756C74737B6261636B67726F756E642D636F6C6F723A72676261283235352C3235352C3235352C2E3938293B666C65782D67726F773A31';
wwv_flow_api.g_varchar2_table(4) := '3B6F766572666C6F773A6175746F3B6D61782D6865696768743A353076687D2E6170782D53706F746C696768742D726573756C74733A656D7074797B646973706C61793A6E6F6E657D2E6170782D53706F746C696768742D726573756C74734C6973747B';
wwv_flow_api.g_varchar2_table(5) := '6C6973742D7374796C653A6E6F6E653B6D617267696E3A303B70616464696E673A307D2E6170782D53706F746C696768742D726573756C743A6E6F74283A6C6173742D6368696C64297B626F726465722D626F74746F6D3A31707820736F6C6964207267';
wwv_flow_api.g_varchar2_table(6) := '626128302C302C302C2E3035297D2E6170782D53706F746C696768742D726573756C74202E6170782D53706F746C696768742D6C696E6B3A686F7665727B746578742D6465636F726174696F6E3A6E6F6E657D2E6170782D53706F746C696768742D7265';
wwv_flow_api.g_varchar2_table(7) := '73756C742E69732D616374697665202E6170782D53706F746C696768742D6C696E6B7B746578742D6465636F726174696F6E3A6E6F6E653B6261636B67726F756E642D636F6C6F723A233035373263653B636F6C6F723A236666667D2E6170782D53706F';
wwv_flow_api.g_varchar2_table(8) := '746C696768742D726573756C742E69732D616374697665202E6170782D53706F746C696768742D6C696E6B202E6170782D53706F746C696768742D646573632C2E6170782D53706F746C696768742D726573756C742E69732D616374697665202E617078';
wwv_flow_api.g_varchar2_table(9) := '2D53706F746C696768742D6C696E6B202E6170782D53706F746C696768742D73686F72746375742C612E73706F746C696768742D686973746F72792D64656C6574652C612E73706F746C696768742D686973746F72792D6C696E6B7B636F6C6F723A2366';
wwv_flow_api.g_varchar2_table(10) := '66667D2E6170782D53706F746C696768742D726573756C742E69732D616374697665202E6170782D53706F746C696768742D6C696E6B202E6170782D53706F746C696768742D73686F72746375747B6261636B67726F756E642D636F6C6F723A72676261';
wwv_flow_api.g_varchar2_table(11) := '283235352C3235352C3235352C2E3135297D2E6170782D53706F746C696768742D7365617263687B70616464696E673A313670783B666C65782D736872696E6B3A303B646973706C61793A666C65783B706F736974696F6E3A72656C61746976653B626F';
wwv_flow_api.g_varchar2_table(12) := '726465722D626F74746F6D3A31707820736F6C6964207267626128302C302C302C2E3035293B6D617267696E2D626F74746F6D3A2D3170787D2E6170782D53706F746C696768742D736561726368202E6170782D53706F746C696768742D69636F6E7B70';
wwv_flow_api.g_varchar2_table(13) := '6F736974696F6E3A72656C61746976653B7A2D696E6465783A313B6261636B67726F756E642D636F6C6F723A236264633363377D2E6170782D53706F746C696768742D6669656C647B666C65782D67726F773A313B706F736974696F6E3A6162736F6C75';
wwv_flow_api.g_varchar2_table(14) := '74653B746F703A303B6C6566743A303B72696768743A303B626F74746F6D3A307D2E6170782D53706F746C696768742D696E7075747B666F6E742D73697A653A3230707821696D706F7274616E743B6C696E652D6865696768743A333270783B68656967';
wwv_flow_api.g_varchar2_table(15) := '68743A363470783B70616464696E673A313670782031367078203136707820363470783B626F726465722D77696474683A303B646973706C61793A626C6F636B3B77696474683A313030253B6261636B67726F756E642D636F6C6F723A72676261283235';
wwv_flow_api.g_varchar2_table(16) := '352C3235352C3235352C2E3938297D2E6170782D53706F746C696768742D696E7075743A666F6375732C2E6170782D53706F746C696768742D6C696E6B3A666F6375737B6F75746C696E653A307D2E6170782D53706F746C696768742D6C696E6B7B6469';
wwv_flow_api.g_varchar2_table(17) := '73706C61793A626C6F636B3B646973706C61793A666C65783B70616464696E673A313670783B636F6C6F723A233230323032303B616C69676E2D6974656D733A63656E7465727D2E6170782D53706F746C696768742D69636F6E7B6D617267696E2D7269';
wwv_flow_api.g_varchar2_table(18) := '6768743A313670783B70616464696E673A3870783B77696474683A333270783B6865696768743A333270783B626F782D736861646F773A30203020302031707820236666663B626F726465722D7261646975733A3270783B6261636B67726F756E642D63';
wwv_flow_api.g_varchar2_table(19) := '6F6C6F723A233339396265613B636F6C6F723A236666667D2E6170782D53706F746C696768742D726573756C742D2D617070202E6170782D53706F746C696768742D69636F6E7B6261636B67726F756E642D636F6C6F723A236635346232317D2E617078';
wwv_flow_api.g_varchar2_table(20) := '2D53706F746C696768742D726573756C742D2D7773202E6170782D53706F746C696768742D69636F6E7B6261636B67726F756E642D636F6C6F723A233234636237667D2E6170782D53706F746C696768742D696E666F7B666C65782D67726F773A313B64';
wwv_flow_api.g_varchar2_table(21) := '6973706C61793A666C65783B666C65782D646972656374696F6E3A636F6C756D6E3B6A7573746966792D636F6E74656E743A63656E7465727D2E6170782D53706F746C696768742D6C6162656C7B666F6E742D73697A653A313470783B666F6E742D7765';
wwv_flow_api.g_varchar2_table(22) := '696768743A3530307D2E6170782D53706F746C696768742D646573637B666F6E742D73697A653A313170783B636F6C6F723A7267626128302C302C302C2E3635297D2E6170782D53706F746C696768742D73686F72746375747B6C696E652D6865696768';
wwv_flow_api.g_varchar2_table(23) := '743A313670783B666F6E742D73697A653A313270783B636F6C6F723A7267626128302C302C302C2E3635293B70616464696E673A34707820313270783B626F726465722D7261646975733A323470783B6261636B67726F756E642D636F6C6F723A726762';
wwv_flow_api.g_varchar2_table(24) := '6128302C302C302C2E303235297D626F6479202E75692D6469616C6F672E75692D6469616C6F672D2D6170657873706F746C696768747B626F726465722D77696474683A303B626F782D736861646F773A30203870782031367078207267626128302C30';
wwv_flow_api.g_varchar2_table(25) := '2C302C2E3235292C302031707820327078207267626128302C302C302C2E3135292C302030203020317078207267626128302C302C302C2E3035293B6261636B67726F756E642D636F6C6F723A7472616E73706172656E747D626F6479202E75692D6469';
wwv_flow_api.g_varchar2_table(26) := '616C6F672E75692D6469616C6F672D2D6170657873706F746C69676874202E75692D6469616C6F672D7469746C656261727B646973706C61793A6E6F6E657D406D65646961206F6E6C792073637265656E20616E6420286D61782D6865696768743A3736';
wwv_flow_api.g_varchar2_table(27) := '387078297B2E6170782D53706F746C696768742D726573756C74737B6D61782D6865696768743A33393070787D7D756C2E73706F746C696768742D686973746F72792D6C6973747B746578742D616C69676E3A6C6566747D2E6170782D53706F746C6967';
wwv_flow_api.g_varchar2_table(28) := '68742D726573756C742D6F72616E67652E69732D616374697665202E6170782D53706F746C696768742D6C696E6B7B6261636B67726F756E642D636F6C6F723A236635396533333B636F6C6F723A236666667D2E6170782D53706F746C696768742D6963';
wwv_flow_api.g_varchar2_table(29) := '6F6E2D6F72616E67657B6261636B67726F756E642D636F6C6F723A233739373837653B636F6C6F723A236666667D2E6170782D53706F746C696768742D726573756C742D7265642E69732D616374697665202E6170782D53706F746C696768742D6C696E';
wwv_flow_api.g_varchar2_table(30) := '6B7B6261636B67726F756E642D636F6C6F723A236461316231623B636F6C6F723A236666667D2E6170782D53706F746C696768742D69636F6E2D7265647B6261636B67726F756E642D636F6C6F723A233630363036303B636F6C6F723A236666667D2E61';
wwv_flow_api.g_varchar2_table(31) := '70782D53706F746C696768742D726573756C742D6461726B2E69732D616374697665202E6170782D53706F746C696768742D6C696E6B7B6261636B67726F756E642D636F6C6F723A233332333333363B636F6C6F723A236666667D2E6170782D53706F74';
wwv_flow_api.g_varchar2_table(32) := '6C696768742D69636F6E2D6461726B7B6261636B67726F756E642D636F6C6F723A236536653665363B636F6C6F723A233430343034303B626F782D736861646F773A30203020302031707820233430343034307D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(4531040302582687)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_file_name=>'css/apexspotlight.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A2A0A202A20415045582053706F746C69676874205365617263680A202A20417574686F723A2044616E69656C20486F63686C6569746E65720A202A20437265646974733A204150455820446576205465616D3A202F692F617065785F75692F637373';
wwv_flow_api.g_varchar2_table(2) := '2F636F72652F53706F746C696768742E6373730A202A2056657273696F6E3A20312E362E310A202A2F0A2E6170782D53706F746C69676874207B0A2020646973706C61793A20666C65783B0A20206F766572666C6F773A2068696464656E3B0A20206865';
wwv_flow_api.g_varchar2_table(3) := '696768743A206175746F2021696D706F7274616E743B0A7D0A0A2E6170782D53706F746C696768742D626F6479207B0A2020666C65782D67726F773A20313B0A2020646973706C61793A20666C65783B0A2020666C65782D646972656374696F6E3A2063';
wwv_flow_api.g_varchar2_table(4) := '6F6C756D6E3B0A20202D7765626B69742D666F6E742D736D6F6F7468696E673A20616E7469616C69617365643B0A20206F766572666C6F773A2068696464656E3B0A7D0A0A2F2A20426F647920436C61737320746F2070726576656E74207363726F6C6C';
wwv_flow_api.g_varchar2_table(5) := '696E67207768656E2073706F746C69676874206973206F70656E202A2F0A626F64792E617065782D73706F746C696768742D616374697665207B0A20206F766572666C6F773A2068696464656E3B0A7D0A0A2F2A2053706F746C6967687420526573756C';
wwv_flow_api.g_varchar2_table(6) := '7473202A2F0A2E6170782D53706F746C696768742D726573756C7473207B0A20206261636B67726F756E642D636F6C6F723A2072676261283235352C203235352C203235352C20302E3938293B0A2020666C65782D67726F773A20313B0A20206F766572';
wwv_flow_api.g_varchar2_table(7) := '666C6F773A206175746F3B0A20206D61782D6865696768743A20353076683B0A7D0A0A2E6170782D53706F746C696768742D726573756C74733A656D707479207B0A2020646973706C61793A206E6F6E653B0A7D0A0A2F2A2053706F746C696768742052';
wwv_flow_api.g_varchar2_table(8) := '6573756C7473204C697374202A2F0A2E6170782D53706F746C696768742D726573756C74734C697374207B0A20206C6973742D7374796C653A206E6F6E653B0A20206D617267696E3A20303B0A202070616464696E673A20303B0A7D0A0A2F2A204C6973';
wwv_flow_api.g_varchar2_table(9) := '74204974656D202A2F0A2E6170782D53706F746C696768742D726573756C743A6E6F74283A6C6173742D6368696C6429207B0A2020626F726465722D626F74746F6D3A2031707820736F6C6964207267626128302C20302C20302C20302E3035293B0A7D';
wwv_flow_api.g_varchar2_table(10) := '0A0A2E6170782D53706F746C696768742D726573756C74202E6170782D53706F746C696768742D6C696E6B3A686F766572207B0A2020746578742D6465636F726174696F6E3A206E6F6E653B0A7D0A0A2E6170782D53706F746C696768742D726573756C';
wwv_flow_api.g_varchar2_table(11) := '742E69732D616374697665202E6170782D53706F746C696768742D6C696E6B207B0A2020746578742D6465636F726174696F6E3A206E6F6E653B0A20206261636B67726F756E642D636F6C6F723A20233035373243453B0A2020636F6C6F723A20236666';
wwv_flow_api.g_varchar2_table(12) := '663B0A7D0A0A2E6170782D53706F746C696768742D726573756C742E69732D616374697665202E6170782D53706F746C696768742D6C696E6B202E6170782D53706F746C696768742D646573632C202E6170782D53706F746C696768742D726573756C74';
wwv_flow_api.g_varchar2_table(13) := '2E69732D616374697665202E6170782D53706F746C696768742D6C696E6B202E6170782D53706F746C696768742D73686F7274637574207B0A2020636F6C6F723A20236666663B0A7D0A0A2E6170782D53706F746C696768742D726573756C742E69732D';
wwv_flow_api.g_varchar2_table(14) := '616374697665202E6170782D53706F746C696768742D6C696E6B202E6170782D53706F746C696768742D73686F7274637574207B0A20206261636B67726F756E642D636F6C6F723A2072676261283235352C203235352C203235352C20302E3135293B0A';
wwv_flow_api.g_varchar2_table(15) := '7D0A0A2F2A20536561726368204669656C64202A2F0A2E6170782D53706F746C696768742D736561726368207B0A202070616464696E673A20313670783B0A2020666C65782D736872696E6B3A20303B0A2020646973706C61793A20666C65783B0A2020';
wwv_flow_api.g_varchar2_table(16) := '706F736974696F6E3A2072656C61746976653B0A2020626F726465722D626F74746F6D3A2031707820736F6C6964207267626128302C20302C20302C20302E3035293B0A20206D617267696E2D626F74746F6D3A202D3170783B0A7D0A0A2E6170782D53';
wwv_flow_api.g_varchar2_table(17) := '706F746C696768742D736561726368202E6170782D53706F746C696768742D69636F6E207B0A2020706F736974696F6E3A2072656C61746976653B0A20207A2D696E6465783A20313B0A20206261636B67726F756E642D636F6C6F723A20236264633363';
wwv_flow_api.g_varchar2_table(18) := '373B0A7D0A0A2E6170782D53706F746C696768742D6669656C64207B0A2020666C65782D67726F773A20313B0A2020706F736974696F6E3A206162736F6C7574653B0A2020746F703A20303B0A20206C6566743A20303B0A202072696768743A20303B0A';
wwv_flow_api.g_varchar2_table(19) := '2020626F74746F6D3A20303B0A7D0A0A2E6170782D53706F746C696768742D696E707574207B0A2020666F6E742D73697A653A20323070782021696D706F7274616E743B0A20206C696E652D6865696768743A20333270783B0A20206865696768743A20';
wwv_flow_api.g_varchar2_table(20) := '363470783B0A202070616464696E673A20313670782031367078203136707820363470783B0A2020626F726465722D77696474683A20303B0A2020646973706C61793A20626C6F636B3B0A202077696474683A20313030253B0A20206261636B67726F75';
wwv_flow_api.g_varchar2_table(21) := '6E642D636F6C6F723A2072676261283235352C203235352C203235352C20302E3938293B0A7D0A0A2E6170782D53706F746C696768742D696E7075743A666F637573207B0A20206F75746C696E653A206E6F6E653B0A7D0A0A2F2A20526573756C74204C';
wwv_flow_api.g_varchar2_table(22) := '696E6B202A2F0A2E6170782D53706F746C696768742D6C696E6B207B0A2020646973706C61793A20626C6F636B3B0A2020646973706C61793A20666C65783B0A202070616464696E673A20313670783B0A2020636F6C6F723A20233230323032303B0A20';
wwv_flow_api.g_varchar2_table(23) := '20616C69676E2D6974656D733A2063656E7465723B0A7D0A0A2E6170782D53706F746C696768742D6C696E6B3A666F637573207B0A20206F75746C696E653A206E6F6E653B0A7D0A0A2E6170782D53706F746C696768742D69636F6E207B0A20206D6172';
wwv_flow_api.g_varchar2_table(24) := '67696E2D72696768743A20313670783B0A202070616464696E673A203870783B0A202077696474683A20333270783B0A20206865696768743A20333270783B0A2020626F782D736861646F773A2030203020302031707820236666663B0A2020626F7264';
wwv_flow_api.g_varchar2_table(25) := '65722D7261646975733A203270783B0A20206261636B67726F756E642D636F6C6F723A20233339396265613B0A2020636F6C6F723A20236666663B0A7D0A0A2E6170782D53706F746C696768742D726573756C742D2D617070202E6170782D53706F746C';
wwv_flow_api.g_varchar2_table(26) := '696768742D69636F6E207B0A20206261636B67726F756E642D636F6C6F723A20236635346232313B0A7D0A0A2E6170782D53706F746C696768742D726573756C742D2D7773202E6170782D53706F746C696768742D69636F6E207B0A20206261636B6772';
wwv_flow_api.g_varchar2_table(27) := '6F756E642D636F6C6F723A20233234636237663B0A7D0A0A2E6170782D53706F746C696768742D696E666F207B0A2020666C65782D67726F773A20313B0A2020646973706C61793A20666C65783B0A2020666C65782D646972656374696F6E3A20636F6C';
wwv_flow_api.g_varchar2_table(28) := '756D6E3B0A20206A7573746966792D636F6E74656E743A2063656E7465723B0A7D0A0A2E6170782D53706F746C696768742D6C6162656C207B0A2020666F6E742D73697A653A20313470783B0A2020666F6E742D7765696768743A203530303B0A7D0A0A';
wwv_flow_api.g_varchar2_table(29) := '2E6170782D53706F746C696768742D64657363207B0A2020666F6E742D73697A653A20313170783B0A2020636F6C6F723A207267626128302C20302C20302C20302E3635293B0A7D0A0A2E6170782D53706F746C696768742D73686F7274637574207B0A';
wwv_flow_api.g_varchar2_table(30) := '20206C696E652D6865696768743A20313670783B0A2020666F6E742D73697A653A20313270783B0A2020636F6C6F723A207267626128302C20302C20302C20302E3635293B0A202070616464696E673A2034707820313270783B0A2020626F726465722D';
wwv_flow_api.g_varchar2_table(31) := '7261646975733A20323470783B0A20206261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E303235293B0A7D0A0A2F2A2053706F746C69676874204469616C6F67202A2F0A626F6479202E75692D6469616C6F672E7569';
wwv_flow_api.g_varchar2_table(32) := '2D6469616C6F672D2D6170657873706F746C69676874207B0A2020626F726465722D77696474683A20303B0A2020626F782D736861646F773A2030203870782031367078207267626128302C20302C20302C20302E3235292C2030203170782032707820';
wwv_flow_api.g_varchar2_table(33) := '7267626128302C20302C20302C20302E3135292C20302030203020317078207267626128302C20302C20302C20302E3035293B0A20206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B0A7D0A0A626F6479202E75692D646961';
wwv_flow_api.g_varchar2_table(34) := '6C6F672E75692D6469616C6F672D2D6170657873706F746C69676874202E75692D6469616C6F672D7469746C65626172207B0A2020646973706C61793A206E6F6E653B0A7D0A0A406D65646961206F6E6C792073637265656E20616E6420286D61782D68';
wwv_flow_api.g_varchar2_table(35) := '65696768743A20373638707829207B0A20202E6170782D53706F746C696768742D726573756C7473207B0A202020206D61782D6865696768743A2033393070783B0A20207D0A7D0A0A2F2A20546970707920486973746F727920506F706F766572202A2F';
wwv_flow_api.g_varchar2_table(36) := '0A756C2E73706F746C696768742D686973746F72792D6C697374207B0A2020746578742D616C69676E3A206C6566743B0A7D0A0A612E73706F746C696768742D686973746F72792D6C696E6B2C0A612E73706F746C696768742D686973746F72792D6465';
wwv_flow_api.g_varchar2_table(37) := '6C657465207B0A2020636F6C6F723A20236666663B0A7D0A0A2F2A20415045582053706F746C6967687420536561726368204F72616E6765205468656D65202A2F0A2E6170782D53706F746C696768742D726573756C742D6F72616E67652E69732D6163';
wwv_flow_api.g_varchar2_table(38) := '74697665202E6170782D53706F746C696768742D6C696E6B207B0A20206261636B67726F756E642D636F6C6F723A20236635396533333B0A2020636F6C6F723A20236666663B0A7D0A0A2E6170782D53706F746C696768742D69636F6E2D6F72616E6765';
wwv_flow_api.g_varchar2_table(39) := '207B0A20206261636B67726F756E642D636F6C6F723A20233739373837653B0A2020636F6C6F723A20236666663B0A7D0A0A2F2A20415045582053706F746C696768742053656172636820526564205468656D65202A2F0A2E6170782D53706F746C6967';
wwv_flow_api.g_varchar2_table(40) := '68742D726573756C742D7265642E69732D616374697665202E6170782D53706F746C696768742D6C696E6B207B0A20206261636B67726F756E642D636F6C6F723A20236461316231623B0A2020636F6C6F723A20236666663B0A7D0A0A2E6170782D5370';
wwv_flow_api.g_varchar2_table(41) := '6F746C696768742D69636F6E2D726564207B0A20206261636B67726F756E642D636F6C6F723A20233630363036303B0A2020636F6C6F723A20236666663B0A7D0A0A2F2A20415045582053706F746C6967687420536561726368204461726B205468656D';
wwv_flow_api.g_varchar2_table(42) := '65202A2F0A2E6170782D53706F746C696768742D726573756C742D6461726B2E69732D616374697665202E6170782D53706F746C696768742D6C696E6B207B0A20206261636B67726F756E642D636F6C6F723A20233332333333363B0A2020636F6C6F72';
wwv_flow_api.g_varchar2_table(43) := '3A20236666663B0A7D0A0A2E6170782D53706F746C696768742D69636F6E2D6461726B207B0A20206261636B67726F756E642D636F6C6F723A20236536653665363B0A2020636F6C6F723A20233430343034303B0A2020626F782D736861646F773A2030';
wwv_flow_api.g_varchar2_table(44) := '203020302031707820233430343034303B0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(4531482201582697)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_file_name=>'css/apexspotlight.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A676C6F62616C20646566696E653A66616C7365202A2F0A2F2A2A0A202A20436F7079726967687420323031322D323031372043726169672043616D7062656C6C0A202A0A202A204C6963656E73656420756E6465722074686520417061636865204C';
wwv_flow_api.g_varchar2_table(2) := '6963656E73652C2056657273696F6E20322E30202874686520224C6963656E736522293B0A202A20796F75206D6179206E6F742075736520746869732066696C652065786365707420696E20636F6D706C69616E6365207769746820746865204C696365';
wwv_flow_api.g_varchar2_table(3) := '6E73652E0A202A20596F75206D6179206F627461696E206120636F7079206F6620746865204C6963656E73652061740A202A0A202A20687474703A2F2F7777772E6170616368652E6F72672F6C6963656E7365732F4C4943454E53452D322E300A202A0A';
wwv_flow_api.g_varchar2_table(4) := '202A20556E6C657373207265717569726564206279206170706C696361626C65206C6177206F722061677265656420746F20696E2077726974696E672C20736F6674776172650A202A20646973747269627574656420756E64657220746865204C696365';
wwv_flow_api.g_varchar2_table(5) := '6E7365206973206469737472696275746564206F6E20616E20224153204953222042415349532C0A202A20574954484F55542057415252414E54494553204F5220434F4E444954494F4E53204F4620414E59204B494E442C206569746865722065787072';
wwv_flow_api.g_varchar2_table(6) := '657373206F7220696D706C6965642E0A202A2053656520746865204C6963656E736520666F7220746865207370656369666963206C616E677561676520676F7665726E696E67207065726D697373696F6E7320616E640A202A206C696D69746174696F6E';
wwv_flow_api.g_varchar2_table(7) := '7320756E64657220746865204C6963656E73652E0A202A0A202A204D6F7573657472617020697320612073696D706C65206B6579626F6172642073686F7274637574206C69627261727920666F72204A61766173637269707420776974680A202A206E6F';
wwv_flow_api.g_varchar2_table(8) := '2065787465726E616C20646570656E64656E636965730A202A0A202A204076657273696F6E20312E362E330A202A204075726C2063726169672E69732F6B696C6C696E672F6D6963650A202A2F0A2866756E6374696F6E2877696E646F772C20646F6375';
wwv_flow_api.g_varchar2_table(9) := '6D656E742C20756E646566696E656429207B0A0A202020202F2F20436865636B206966206D6F75736574726170206973207573656420696E736964652062726F777365722C206966206E6F742C2072657475726E0A20202020696620282177696E646F77';
wwv_flow_api.g_varchar2_table(10) := '29207B0A202020202020202072657475726E3B0A202020207D0A0A202020202F2A2A0A20202020202A206D617070696E67206F66207370656369616C206B6579636F64657320746F20746865697220636F72726573706F6E64696E67206B6579730A2020';
wwv_flow_api.g_varchar2_table(11) := '2020202A0A20202020202A2065766572797468696E6720696E20746869732064696374696F6E6172792063616E6E6F7420757365206B65797072657373206576656E74730A20202020202A20736F2069742068617320746F206265206865726520746F20';
wwv_flow_api.g_varchar2_table(12) := '6D617020746F2074686520636F7272656374206B6579636F64657320666F720A20202020202A206B657975702F6B6579646F776E206576656E74730A20202020202A0A20202020202A204074797065207B4F626A6563747D0A20202020202A2F0A202020';
wwv_flow_api.g_varchar2_table(13) := '20766172205F4D4150203D207B0A2020202020202020383A20276261636B7370616365272C0A2020202020202020393A2027746162272C0A202020202020202031333A2027656E746572272C0A202020202020202031363A20277368696674272C0A2020';
wwv_flow_api.g_varchar2_table(14) := '20202020202031373A20276374726C272C0A202020202020202031383A2027616C74272C0A202020202020202032303A2027636170736C6F636B272C0A202020202020202032373A2027657363272C0A202020202020202033323A20277370616365272C';
wwv_flow_api.g_varchar2_table(15) := '0A202020202020202033333A2027706167657570272C0A202020202020202033343A202770616765646F776E272C0A202020202020202033353A2027656E64272C0A202020202020202033363A2027686F6D65272C0A202020202020202033373A20276C';
wwv_flow_api.g_varchar2_table(16) := '656674272C0A202020202020202033383A20277570272C0A202020202020202033393A20277269676874272C0A202020202020202034303A2027646F776E272C0A202020202020202034353A2027696E73272C0A202020202020202034363A202764656C';
wwv_flow_api.g_varchar2_table(17) := '272C0A202020202020202039313A20276D657461272C0A202020202020202039333A20276D657461272C0A20202020202020203232343A20276D657461270A202020207D3B0A0A202020202F2A2A0A20202020202A206D617070696E6720666F72207370';
wwv_flow_api.g_varchar2_table(18) := '656369616C206368617261637465727320736F20746865792063616E20737570706F72740A20202020202A0A20202020202A20746869732064696374696F6E617279206973206F6E6C79207573656420696E6361736520796F752077616E7420746F2062';
wwv_flow_api.g_varchar2_table(19) := '696E6420610A20202020202A206B65797570206F72206B6579646F776E206576656E7420746F206F6E65206F66207468657365206B6579730A20202020202A0A20202020202A204074797065207B4F626A6563747D0A20202020202A2F0A202020207661';
wwv_flow_api.g_varchar2_table(20) := '72205F4B4559434F44455F4D4150203D207B0A20202020202020203130363A20272A272C0A20202020202020203130373A20272B272C0A20202020202020203130393A20272D272C0A20202020202020203131303A20272E272C0A202020202020202031';
wwv_flow_api.g_varchar2_table(21) := '3131203A20272F272C0A20202020202020203138363A20273B272C0A20202020202020203138373A20273D272C0A20202020202020203138383A20272C272C0A20202020202020203138393A20272D272C0A20202020202020203139303A20272E272C0A';
wwv_flow_api.g_varchar2_table(22) := '20202020202020203139313A20272F272C0A20202020202020203139323A202760272C0A20202020202020203231393A20275B272C0A20202020202020203232303A20275C5C272C0A20202020202020203232313A20275D272C0A202020202020202032';
wwv_flow_api.g_varchar2_table(23) := '32323A20275C27270A202020207D3B0A0A202020202F2A2A0A20202020202A20746869732069732061206D617070696E67206F66206B65797320746861742072657175697265207368696674206F6E2061205553206B65797061640A20202020202A2062';
wwv_flow_api.g_varchar2_table(24) := '61636B20746F20746865206E6F6E207368696674206571756976656C656E74730A20202020202A0A20202020202A207468697320697320736F20796F752063616E20757365206B65797570206576656E74732077697468207468657365206B6579730A20';
wwv_flow_api.g_varchar2_table(25) := '202020202A0A20202020202A206E6F7465207468617420746869732077696C6C206F6E6C7920776F726B2072656C6961626C79206F6E205553206B6579626F617264730A20202020202A0A20202020202A204074797065207B4F626A6563747D0A202020';
wwv_flow_api.g_varchar2_table(26) := '20202A2F0A20202020766172205F53484946545F4D4150203D207B0A2020202020202020277E273A202760272C0A20202020202020202721273A202731272C0A20202020202020202740273A202732272C0A20202020202020202723273A202733272C0A';
wwv_flow_api.g_varchar2_table(27) := '20202020202020202724273A202734272C0A20202020202020202725273A202735272C0A2020202020202020275E273A202736272C0A20202020202020202726273A202737272C0A2020202020202020272A273A202738272C0A20202020202020202728';
wwv_flow_api.g_varchar2_table(28) := '273A202739272C0A20202020202020202729273A202730272C0A2020202020202020275F273A20272D272C0A2020202020202020272B273A20273D272C0A2020202020202020273A273A20273B272C0A2020202020202020275C22273A20275C27272C0A';
wwv_flow_api.g_varchar2_table(29) := '2020202020202020273C273A20272C272C0A2020202020202020273E273A20272E272C0A2020202020202020273F273A20272F272C0A2020202020202020277C273A20275C5C270A202020207D3B0A0A202020202F2A2A0A20202020202A207468697320';
wwv_flow_api.g_varchar2_table(30) := '69732061206C697374206F66207370656369616C20737472696E677320796F752063616E2075736520746F206D61700A20202020202A20746F206D6F646966696572206B657973207768656E20796F75207370656369667920796F7572206B6579626F61';
wwv_flow_api.g_varchar2_table(31) := '72642073686F7274637574730A20202020202A0A20202020202A204074797065207B4F626A6563747D0A20202020202A2F0A20202020766172205F5350454349414C5F414C4941534553203D207B0A2020202020202020276F7074696F6E273A2027616C';
wwv_flow_api.g_varchar2_table(32) := '74272C0A202020202020202027636F6D6D616E64273A20276D657461272C0A20202020202020202772657475726E273A2027656E746572272C0A202020202020202027657363617065273A2027657363272C0A202020202020202027706C7573273A2027';
wwv_flow_api.g_varchar2_table(33) := '2B272C0A2020202020202020276D6F64273A202F4D61637C69506F647C6950686F6E657C695061642F2E74657374286E6176696761746F722E706C6174666F726D29203F20276D65746127203A20276374726C270A202020207D3B0A0A202020202F2A2A';
wwv_flow_api.g_varchar2_table(34) := '0A20202020202A207661726961626C6520746F2073746F72652074686520666C69707065642076657273696F6E206F66205F4D41502066726F6D2061626F76650A20202020202A206E656564656420746F20636865636B2069662077652073686F756C64';
wwv_flow_api.g_varchar2_table(35) := '20757365206B65797072657373206F72206E6F74207768656E206E6F20616374696F6E0A20202020202A206973207370656369666965640A20202020202A0A20202020202A204074797065207B4F626A6563747C756E646566696E65647D0A2020202020';
wwv_flow_api.g_varchar2_table(36) := '2A2F0A20202020766172205F524556455253455F4D41503B0A0A202020202F2A2A0A20202020202A206C6F6F70207468726F756768207468652066206B6579732C20663120746F2066313920616E6420616464207468656D20746F20746865206D61700A';
wwv_flow_api.g_varchar2_table(37) := '20202020202A2070726F6772616D61746963616C6C790A20202020202A2F0A20202020666F7220287661722069203D20313B2069203C2032303B202B2B6929207B0A20202020202020205F4D41505B313131202B20695D203D20276627202B20693B0A20';
wwv_flow_api.g_varchar2_table(38) := '2020207D0A0A202020202F2A2A0A20202020202A206C6F6F70207468726F75676820746F206D6170206E756D62657273206F6E20746865206E756D65726963206B65797061640A20202020202A2F0A20202020666F72202869203D20303B2069203C3D20';
wwv_flow_api.g_varchar2_table(39) := '393B202B2B6929207B0A0A20202020202020202F2F2054686973206E6565647320746F20757365206120737472696E67206361757365206F74686572776973652073696E636520302069732066616C7365790A20202020202020202F2F206D6F75736574';
wwv_flow_api.g_varchar2_table(40) := '7261702077696C6C206E65766572206669726520666F72206E756D706164203020707265737365642061732070617274206F662061206B6579646F776E0A20202020202020202F2F206576656E742E0A20202020202020202F2F0A20202020202020202F';
wwv_flow_api.g_varchar2_table(41) := '2F20407365652068747470733A2F2F6769746875622E636F6D2F6363616D7062656C6C2F6D6F757365747261702F70756C6C2F3235380A20202020202020205F4D41505B69202B2039365D203D20692E746F537472696E6728293B0A202020207D0A0A20';
wwv_flow_api.g_varchar2_table(42) := '2020202F2A2A0A20202020202A2063726F73732062726F7773657220616464206576656E74206D6574686F640A20202020202A0A20202020202A2040706172616D207B456C656D656E747C48544D4C446F63756D656E747D206F626A6563740A20202020';
wwv_flow_api.g_varchar2_table(43) := '202A2040706172616D207B737472696E677D20747970650A20202020202A2040706172616D207B46756E6374696F6E7D2063616C6C6261636B0A20202020202A204072657475726E7320766F69640A20202020202A2F0A2020202066756E6374696F6E20';
wwv_flow_api.g_varchar2_table(44) := '5F6164644576656E74286F626A6563742C20747970652C2063616C6C6261636B29207B0A2020202020202020696620286F626A6563742E6164644576656E744C697374656E657229207B0A2020202020202020202020206F626A6563742E616464457665';
wwv_flow_api.g_varchar2_table(45) := '6E744C697374656E657228747970652C2063616C6C6261636B2C2066616C7365293B0A20202020202020202020202072657475726E3B0A20202020202020207D0A0A20202020202020206F626A6563742E6174746163684576656E7428276F6E27202B20';
wwv_flow_api.g_varchar2_table(46) := '747970652C2063616C6C6261636B293B0A202020207D0A0A202020202F2A2A0A20202020202A2074616B657320746865206576656E7420616E642072657475726E7320746865206B6579206368617261637465720A20202020202A0A20202020202A2040';
wwv_flow_api.g_varchar2_table(47) := '706172616D207B4576656E747D20650A20202020202A204072657475726E207B737472696E677D0A20202020202A2F0A2020202066756E6374696F6E205F63686172616374657246726F6D4576656E74286529207B0A0A20202020202020202F2F20666F';
wwv_flow_api.g_varchar2_table(48) := '72206B65797072657373206576656E74732077652073686F756C642072657475726E20746865206368617261637465722061732069730A202020202020202069662028652E74797065203D3D20276B657970726573732729207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(49) := '20202076617220636861726163746572203D20537472696E672E66726F6D43686172436F646528652E7768696368293B0A0A2020202020202020202020202F2F20696620746865207368696674206B6579206973206E6F74207072657373656420746865';
wwv_flow_api.g_varchar2_table(50) := '6E206974206973207361666520746F20617373756D650A2020202020202020202020202F2F20746861742077652077616E74207468652063686172616374657220746F206265206C6F776572636173652E202074686973206D65616E732069660A202020';
wwv_flow_api.g_varchar2_table(51) := '2020202020202020202F2F20796F75206163636964656E74616C6C7920686176652063617073206C6F636B206F6E207468656E20796F7572206B65792062696E64696E67730A2020202020202020202020202F2F2077696C6C20636F6E74696E75652074';
wwv_flow_api.g_varchar2_table(52) := '6F20776F726B0A2020202020202020202020202F2F0A2020202020202020202020202F2F20746865206F6E6C792073696465206566666563742074686174206D69676874206E6F74206265206465736972656420697320696620796F750A202020202020';
wwv_flow_api.g_varchar2_table(53) := '2020202020202F2F2062696E6420736F6D657468696E67206C696B652027412720636175736520796F752077616E7420746F207472696767657220616E0A2020202020202020202020202F2F206576656E74207768656E206361706974616C2041206973';
wwv_flow_api.g_varchar2_table(54) := '20707265737365642063617073206C6F636B2077696C6C206E6F206C6F6E6765720A2020202020202020202020202F2F207472696767657220746865206576656E742E202073686966742B612077696C6C2074686F7567682E0A20202020202020202020';
wwv_flow_api.g_varchar2_table(55) := '20206966202821652E73686966744B657929207B0A20202020202020202020202020202020636861726163746572203D206368617261637465722E746F4C6F7765724361736528293B0A2020202020202020202020207D0A0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(56) := '2072657475726E206368617261637465723B0A20202020202020207D0A0A20202020202020202F2F20666F72206E6F6E206B65797072657373206576656E747320746865207370656369616C206D61707320617265206E65656465640A20202020202020';
wwv_flow_api.g_varchar2_table(57) := '20696620285F4D41505B652E77686963685D29207B0A20202020202020202020202072657475726E205F4D41505B652E77686963685D3B0A20202020202020207D0A0A2020202020202020696620285F4B4559434F44455F4D41505B652E77686963685D';
wwv_flow_api.g_varchar2_table(58) := '29207B0A20202020202020202020202072657475726E205F4B4559434F44455F4D41505B652E77686963685D3B0A20202020202020207D0A0A20202020202020202F2F206966206974206973206E6F7420696E20746865207370656369616C206D61700A';
wwv_flow_api.g_varchar2_table(59) := '0A20202020202020202F2F2077697468206B6579646F776E20616E64206B65797570206576656E74732074686520636861726163746572207365656D7320746F20616C776179730A20202020202020202F2F20636F6D6520696E20617320616E20757070';
wwv_flow_api.g_varchar2_table(60) := '65726361736520636861726163746572207768657468657220796F7520617265207072657373696E672073686966740A20202020202020202F2F206F72206E6F742E202077652073686F756C64206D616B65207375726520697420697320616C77617973';
wwv_flow_api.g_varchar2_table(61) := '206C6F7765726361736520666F7220636F6D70617269736F6E730A202020202020202072657475726E20537472696E672E66726F6D43686172436F646528652E7768696368292E746F4C6F7765724361736528293B0A202020207D0A0A202020202F2A2A';
wwv_flow_api.g_varchar2_table(62) := '0A20202020202A20636865636B732069662074776F206172726179732061726520657175616C0A20202020202A0A20202020202A2040706172616D207B41727261797D206D6F64696669657273310A20202020202A2040706172616D207B41727261797D';
wwv_flow_api.g_varchar2_table(63) := '206D6F64696669657273320A20202020202A204072657475726E73207B626F6F6C65616E7D0A20202020202A2F0A2020202066756E6374696F6E205F6D6F646966696572734D61746368286D6F64696669657273312C206D6F646966696572733229207B';
wwv_flow_api.g_varchar2_table(64) := '0A202020202020202072657475726E206D6F64696669657273312E736F727428292E6A6F696E28272C2729203D3D3D206D6F64696669657273322E736F727428292E6A6F696E28272C27293B0A202020207D0A0A202020202F2A2A0A20202020202A2074';
wwv_flow_api.g_varchar2_table(65) := '616B65732061206B6579206576656E7420616E642066696775726573206F7574207768617420746865206D6F64696669657273206172650A20202020202A0A20202020202A2040706172616D207B4576656E747D20650A20202020202A20407265747572';
wwv_flow_api.g_varchar2_table(66) := '6E73207B41727261797D0A20202020202A2F0A2020202066756E6374696F6E205F6576656E744D6F64696669657273286529207B0A2020202020202020766172206D6F64696669657273203D205B5D3B0A0A202020202020202069662028652E73686966';
wwv_flow_api.g_varchar2_table(67) := '744B657929207B0A2020202020202020202020206D6F646966696572732E707573682827736869667427293B0A20202020202020207D0A0A202020202020202069662028652E616C744B657929207B0A2020202020202020202020206D6F646966696572';
wwv_flow_api.g_varchar2_table(68) := '732E707573682827616C7427293B0A20202020202020207D0A0A202020202020202069662028652E6374726C4B657929207B0A2020202020202020202020206D6F646966696572732E7075736828276374726C27293B0A20202020202020207D0A0A2020';
wwv_flow_api.g_varchar2_table(69) := '20202020202069662028652E6D6574614B657929207B0A2020202020202020202020206D6F646966696572732E7075736828276D65746127293B0A20202020202020207D0A0A202020202020202072657475726E206D6F646966696572733B0A20202020';
wwv_flow_api.g_varchar2_table(70) := '7D0A0A202020202F2A2A0A20202020202A2070726576656E74732064656661756C7420666F722074686973206576656E740A20202020202A0A20202020202A2040706172616D207B4576656E747D20650A20202020202A204072657475726E7320766F69';
wwv_flow_api.g_varchar2_table(71) := '640A20202020202A2F0A2020202066756E6374696F6E205F70726576656E7444656661756C74286529207B0A202020202020202069662028652E70726576656E7444656661756C7429207B0A202020202020202020202020652E70726576656E74446566';
wwv_flow_api.g_varchar2_table(72) := '61756C7428293B0A20202020202020202020202072657475726E3B0A20202020202020207D0A0A2020202020202020652E72657475726E56616C7565203D2066616C73653B0A202020207D0A0A202020202F2A2A0A20202020202A2073746F7073207072';
wwv_flow_api.g_varchar2_table(73) := '6F706F676174696F6E20666F722074686973206576656E740A20202020202A0A20202020202A2040706172616D207B4576656E747D20650A20202020202A204072657475726E7320766F69640A20202020202A2F0A2020202066756E6374696F6E205F73';
wwv_flow_api.g_varchar2_table(74) := '746F7050726F7061676174696F6E286529207B0A202020202020202069662028652E73746F7050726F7061676174696F6E29207B0A202020202020202020202020652E73746F7050726F7061676174696F6E28293B0A2020202020202020202020207265';
wwv_flow_api.g_varchar2_table(75) := '7475726E3B0A20202020202020207D0A0A2020202020202020652E63616E63656C427562626C65203D20747275653B0A202020207D0A0A202020202F2A2A0A20202020202A2064657465726D696E657320696620746865206B6579636F64652073706563';
wwv_flow_api.g_varchar2_table(76) := '69666965642069732061206D6F646966696572206B6579206F72206E6F740A20202020202A0A20202020202A2040706172616D207B737472696E677D206B65790A20202020202A204072657475726E73207B626F6F6C65616E7D0A20202020202A2F0A20';
wwv_flow_api.g_varchar2_table(77) := '20202066756E6374696F6E205F69734D6F646966696572286B657929207B0A202020202020202072657475726E206B6579203D3D2027736869667427207C7C206B6579203D3D20276374726C27207C7C206B6579203D3D2027616C7427207C7C206B6579';
wwv_flow_api.g_varchar2_table(78) := '203D3D20276D657461273B0A202020207D0A0A202020202F2A2A0A20202020202A20726576657273657320746865206D6170206C6F6F6B757020736F20746861742077652063616E206C6F6F6B20666F72207370656369666963206B6579730A20202020';
wwv_flow_api.g_varchar2_table(79) := '202A20746F2073656520776861742063616E20616E642063616E277420757365206B657970726573730A20202020202A0A20202020202A204072657475726E207B4F626A6563747D0A20202020202A2F0A2020202066756E6374696F6E205F6765745265';
wwv_flow_api.g_varchar2_table(80) := '76657273654D61702829207B0A202020202020202069662028215F524556455253455F4D415029207B0A2020202020202020202020205F524556455253455F4D4150203D207B7D3B0A202020202020202020202020666F722028766172206B657920696E';
wwv_flow_api.g_varchar2_table(81) := '205F4D415029207B0A0A202020202020202020202020202020202F2F2070756C6C206F757420746865206E756D65726963206B65797061642066726F6D2068657265206361757365206B657970726573732073686F756C640A2020202020202020202020';
wwv_flow_api.g_varchar2_table(82) := '20202020202F2F2062652061626C6520746F2064657465637420746865206B6579732066726F6D20746865206368617261637465720A20202020202020202020202020202020696620286B6579203E203935202626206B6579203C2031313229207B0A20';
wwv_flow_api.g_varchar2_table(83) := '20202020202020202020202020202020202020636F6E74696E75653B0A202020202020202020202020202020207D0A0A20202020202020202020202020202020696620285F4D41502E6861734F776E50726F7065727479286B65792929207B0A20202020';
wwv_flow_api.g_varchar2_table(84) := '202020202020202020202020202020205F524556455253455F4D41505B5F4D41505B6B65795D5D203D206B65793B0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020207D0A2020202020202020726574';
wwv_flow_api.g_varchar2_table(85) := '75726E205F524556455253455F4D41503B0A202020207D0A0A202020202F2A2A0A20202020202A207069636B7320746865206265737420616374696F6E206261736564206F6E20746865206B657920636F6D62696E6174696F6E0A20202020202A0A2020';
wwv_flow_api.g_varchar2_table(86) := '2020202A2040706172616D207B737472696E677D206B6579202D2063686172616374657220666F72206B65790A20202020202A2040706172616D207B41727261797D206D6F646966696572730A20202020202A2040706172616D207B737472696E673D7D';
wwv_flow_api.g_varchar2_table(87) := '20616374696F6E2070617373656420696E0A20202020202A2F0A2020202066756E6374696F6E205F7069636B42657374416374696F6E286B65792C206D6F646966696572732C20616374696F6E29207B0A0A20202020202020202F2F206966206E6F2061';
wwv_flow_api.g_varchar2_table(88) := '6374696F6E20776173207069636B656420696E2077652073686F756C642074727920746F207069636B20746865206F6E650A20202020202020202F2F2074686174207765207468696E6B20776F756C6420776F726B206265737420666F72207468697320';
wwv_flow_api.g_varchar2_table(89) := '6B65790A20202020202020206966202821616374696F6E29207B0A202020202020202020202020616374696F6E203D205F676574526576657273654D617028295B6B65795D203F20276B6579646F776E27203A20276B65797072657373273B0A20202020';
wwv_flow_api.g_varchar2_table(90) := '202020207D0A0A20202020202020202F2F206D6F646966696572206B65797320646F6E277420776F726B2061732065787065637465642077697468206B657970726573732C0A20202020202020202F2F2073776974636820746F206B6579646F776E0A20';
wwv_flow_api.g_varchar2_table(91) := '2020202020202069662028616374696F6E203D3D20276B6579707265737327202626206D6F646966696572732E6C656E67746829207B0A202020202020202020202020616374696F6E203D20276B6579646F776E273B0A20202020202020207D0A0A2020';
wwv_flow_api.g_varchar2_table(92) := '20202020202072657475726E20616374696F6E3B0A202020207D0A0A202020202F2A2A0A20202020202A20436F6E76657274732066726F6D206120737472696E67206B657920636F6D62696E6174696F6E20746F20616E2061727261790A20202020202A';
wwv_flow_api.g_varchar2_table(93) := '0A20202020202A2040706172616D20207B737472696E677D20636F6D62696E6174696F6E206C696B652022636F6D6D616E642B73686966742B6C220A20202020202A204072657475726E207B41727261797D0A20202020202A2F0A2020202066756E6374';
wwv_flow_api.g_varchar2_table(94) := '696F6E205F6B65797346726F6D537472696E6728636F6D62696E6174696F6E29207B0A202020202020202069662028636F6D62696E6174696F6E203D3D3D20272B2729207B0A20202020202020202020202072657475726E205B272B275D3B0A20202020';
wwv_flow_api.g_varchar2_table(95) := '202020207D0A0A2020202020202020636F6D62696E6174696F6E203D20636F6D62696E6174696F6E2E7265706C616365282F5C2B7B327D2F672C20272B706C757327293B0A202020202020202072657475726E20636F6D62696E6174696F6E2E73706C69';
wwv_flow_api.g_varchar2_table(96) := '7428272B27293B0A202020207D0A0A202020202F2A2A0A20202020202A204765747320696E666F20666F722061207370656369666963206B657920636F6D62696E6174696F6E0A20202020202A0A20202020202A2040706172616D20207B737472696E67';
wwv_flow_api.g_varchar2_table(97) := '7D20636F6D62696E6174696F6E206B657920636F6D62696E6174696F6E202822636F6D6D616E642B7322206F7220226122206F7220222A22290A20202020202A2040706172616D20207B737472696E673D7D20616374696F6E0A20202020202A20407265';
wwv_flow_api.g_varchar2_table(98) := '7475726E73207B4F626A6563747D0A20202020202A2F0A2020202066756E6374696F6E205F6765744B6579496E666F28636F6D62696E6174696F6E2C20616374696F6E29207B0A2020202020202020766172206B6579733B0A2020202020202020766172';
wwv_flow_api.g_varchar2_table(99) := '206B65793B0A202020202020202076617220693B0A2020202020202020766172206D6F64696669657273203D205B5D3B0A0A20202020202020202F2F2074616B6520746865206B6579732066726F6D2074686973207061747465726E20616E6420666967';
wwv_flow_api.g_varchar2_table(100) := '757265206F75742077686174207468652061637475616C0A20202020202020202F2F207061747465726E20697320616C6C2061626F75740A20202020202020206B657973203D205F6B65797346726F6D537472696E6728636F6D62696E6174696F6E293B';
wwv_flow_api.g_varchar2_table(101) := '0A0A2020202020202020666F72202869203D20303B2069203C206B6579732E6C656E6774683B202B2B6929207B0A2020202020202020202020206B6579203D206B6579735B695D3B0A0A2020202020202020202020202F2F206E6F726D616C697A65206B';
wwv_flow_api.g_varchar2_table(102) := '6579206E616D65730A202020202020202020202020696620285F5350454349414C5F414C49415345535B6B65795D29207B0A202020202020202020202020202020206B6579203D205F5350454349414C5F414C49415345535B6B65795D3B0A2020202020';
wwv_flow_api.g_varchar2_table(103) := '202020202020207D0A0A2020202020202020202020202F2F2069662074686973206973206E6F742061206B65797072657373206576656E74207468656E2077652073686F756C640A2020202020202020202020202F2F20626520736D6172742061626F75';
wwv_flow_api.g_varchar2_table(104) := '74207573696E67207368696674206B6579730A2020202020202020202020202F2F20746869732077696C6C206F6E6C7920776F726B20666F72205553206B6579626F6172647320686F77657665720A20202020202020202020202069662028616374696F';
wwv_flow_api.g_varchar2_table(105) := '6E20262620616374696F6E20213D20276B6579707265737327202626205F53484946545F4D41505B6B65795D29207B0A202020202020202020202020202020206B6579203D205F53484946545F4D41505B6B65795D3B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(106) := '2020206D6F646966696572732E707573682827736869667427293B0A2020202020202020202020207D0A0A2020202020202020202020202F2F2069662074686973206B65792069732061206D6F646966696572207468656E2061646420697420746F2074';
wwv_flow_api.g_varchar2_table(107) := '6865206C697374206F66206D6F646966696572730A202020202020202020202020696620285F69734D6F646966696572286B65792929207B0A202020202020202020202020202020206D6F646966696572732E70757368286B6579293B0A202020202020';
wwv_flow_api.g_varchar2_table(108) := '2020202020207D0A20202020202020207D0A0A20202020202020202F2F20646570656E64696E67206F6E207768617420746865206B657920636F6D62696E6174696F6E2069730A20202020202020202F2F2077652077696C6C2074727920746F20706963';
wwv_flow_api.g_varchar2_table(109) := '6B207468652062657374206576656E7420666F722069740A2020202020202020616374696F6E203D205F7069636B42657374416374696F6E286B65792C206D6F646966696572732C20616374696F6E293B0A0A202020202020202072657475726E207B0A';
wwv_flow_api.g_varchar2_table(110) := '2020202020202020202020206B65793A206B65792C0A2020202020202020202020206D6F646966696572733A206D6F646966696572732C0A202020202020202020202020616374696F6E3A20616374696F6E0A20202020202020207D3B0A202020207D0A';
wwv_flow_api.g_varchar2_table(111) := '0A2020202066756E6374696F6E205F62656C6F6E6773546F28656C656D656E742C20616E636573746F7229207B0A202020202020202069662028656C656D656E74203D3D3D206E756C6C207C7C20656C656D656E74203D3D3D20646F63756D656E742920';
wwv_flow_api.g_varchar2_table(112) := '7B0A20202020202020202020202072657475726E2066616C73653B0A20202020202020207D0A0A202020202020202069662028656C656D656E74203D3D3D20616E636573746F7229207B0A20202020202020202020202072657475726E20747275653B0A';
wwv_flow_api.g_varchar2_table(113) := '20202020202020207D0A0A202020202020202072657475726E205F62656C6F6E6773546F28656C656D656E742E706172656E744E6F64652C20616E636573746F72293B0A202020207D0A0A2020202066756E6374696F6E204D6F75736574726170287461';
wwv_flow_api.g_varchar2_table(114) := '72676574456C656D656E7429207B0A20202020202020207661722073656C66203D20746869733B0A0A2020202020202020746172676574456C656D656E74203D20746172676574456C656D656E74207C7C20646F63756D656E743B0A0A20202020202020';
wwv_flow_api.g_varchar2_table(115) := '2069662028212873656C6620696E7374616E63656F66204D6F757365747261702929207B0A20202020202020202020202072657475726E206E6577204D6F7573657472617028746172676574456C656D656E74293B0A20202020202020207D0A0A202020';
wwv_flow_api.g_varchar2_table(116) := '20202020202F2A2A0A2020202020202020202A20656C656D656E7420746F20617474616368206B6579206576656E747320746F0A2020202020202020202A0A2020202020202020202A204074797065207B456C656D656E747D0A2020202020202020202A';
wwv_flow_api.g_varchar2_table(117) := '2F0A202020202020202073656C662E746172676574203D20746172676574456C656D656E743B0A0A20202020202020202F2A2A0A2020202020202020202A2061206C697374206F6620616C6C207468652063616C6C6261636B7320736574757020766961';
wwv_flow_api.g_varchar2_table(118) := '204D6F757365747261702E62696E6428290A2020202020202020202A0A2020202020202020202A204074797065207B4F626A6563747D0A2020202020202020202A2F0A202020202020202073656C662E5F63616C6C6261636B73203D207B7D3B0A0A2020';
wwv_flow_api.g_varchar2_table(119) := '2020202020202F2A2A0A2020202020202020202A20646972656374206D6170206F6620737472696E6720636F6D62696E6174696F6E7320746F2063616C6C6261636B73207573656420666F72207472696767657228290A2020202020202020202A0A2020';
wwv_flow_api.g_varchar2_table(120) := '202020202020202A204074797065207B4F626A6563747D0A2020202020202020202A2F0A202020202020202073656C662E5F6469726563744D6170203D207B7D3B0A0A20202020202020202F2A2A0A2020202020202020202A206B656570732074726163';
wwv_flow_api.g_varchar2_table(121) := '6B206F662077686174206C6576656C20656163682073657175656E63652069732061742073696E6365206D756C7469706C650A2020202020202020202A2073657175656E6365732063616E207374617274206F75742077697468207468652073616D6520';
wwv_flow_api.g_varchar2_table(122) := '73657175656E63650A2020202020202020202A0A2020202020202020202A204074797065207B4F626A6563747D0A2020202020202020202A2F0A2020202020202020766172205F73657175656E63654C6576656C73203D207B7D3B0A0A20202020202020';
wwv_flow_api.g_varchar2_table(123) := '202F2A2A0A2020202020202020202A207661726961626C6520746F2073746F7265207468652073657454696D656F75742063616C6C0A2020202020202020202A0A2020202020202020202A204074797065207B6E756C6C7C6E756D6265727D0A20202020';
wwv_flow_api.g_varchar2_table(124) := '20202020202A2F0A2020202020202020766172205F726573657454696D65723B0A0A20202020202020202F2A2A0A2020202020202020202A2074656D706F726172792073746174652077686572652077652077696C6C2069676E6F726520746865206E65';
wwv_flow_api.g_varchar2_table(125) := '7874206B657975700A2020202020202020202A0A2020202020202020202A204074797065207B626F6F6C65616E7C737472696E677D0A2020202020202020202A2F0A2020202020202020766172205F69676E6F72654E6578744B65797570203D2066616C';
wwv_flow_api.g_varchar2_table(126) := '73653B0A0A20202020202020202F2A2A0A2020202020202020202A2074656D706F726172792073746174652077686572652077652077696C6C2069676E6F726520746865206E657874206B657970726573730A2020202020202020202A0A202020202020';
wwv_flow_api.g_varchar2_table(127) := '2020202A204074797065207B626F6F6C65616E7D0A2020202020202020202A2F0A2020202020202020766172205F69676E6F72654E6578744B65797072657373203D2066616C73653B0A0A20202020202020202F2A2A0A2020202020202020202A206172';
wwv_flow_api.g_varchar2_table(128) := '652077652063757272656E746C7920696E73696465206F6620612073657175656E63653F0A2020202020202020202A2074797065206F6620616374696F6E2028226B6579757022206F7220226B6579646F776E22206F7220226B65797072657373222920';
wwv_flow_api.g_varchar2_table(129) := '6F722066616C73650A2020202020202020202A0A2020202020202020202A204074797065207B626F6F6C65616E7C737472696E677D0A2020202020202020202A2F0A2020202020202020766172205F6E6578744578706563746564416374696F6E203D20';
wwv_flow_api.g_varchar2_table(130) := '66616C73653B0A0A20202020202020202F2A2A0A2020202020202020202A2072657365747320616C6C2073657175656E636520636F756E746572732065786365707420666F7220746865206F6E65732070617373656420696E0A2020202020202020202A';
wwv_flow_api.g_varchar2_table(131) := '0A2020202020202020202A2040706172616D207B4F626A6563747D20646F4E6F7452657365740A2020202020202020202A204072657475726E7320766F69640A2020202020202020202A2F0A202020202020202066756E6374696F6E205F726573657453';
wwv_flow_api.g_varchar2_table(132) := '657175656E63657328646F4E6F74526573657429207B0A202020202020202020202020646F4E6F745265736574203D20646F4E6F745265736574207C7C207B7D3B0A0A2020202020202020202020207661722061637469766553657175656E636573203D';
wwv_flow_api.g_varchar2_table(133) := '2066616C73652C0A202020202020202020202020202020206B65793B0A0A202020202020202020202020666F7220286B657920696E205F73657175656E63654C6576656C7329207B0A2020202020202020202020202020202069662028646F4E6F745265';
wwv_flow_api.g_varchar2_table(134) := '7365745B6B65795D29207B0A202020202020202020202020202020202020202061637469766553657175656E636573203D20747275653B0A2020202020202020202020202020202020202020636F6E74696E75653B0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(135) := '20207D0A202020202020202020202020202020205F73657175656E63654C6576656C735B6B65795D203D20303B0A2020202020202020202020207D0A0A202020202020202020202020696620282161637469766553657175656E63657329207B0A202020';
wwv_flow_api.g_varchar2_table(136) := '202020202020202020202020205F6E6578744578706563746564416374696F6E203D2066616C73653B0A2020202020202020202020207D0A20202020202020207D0A0A20202020202020202F2A2A0A2020202020202020202A2066696E647320616C6C20';
wwv_flow_api.g_varchar2_table(137) := '63616C6C6261636B732074686174206D61746368206261736564206F6E20746865206B6579636F64652C206D6F646966696572732C0A2020202020202020202A20616E6420616374696F6E0A2020202020202020202A0A2020202020202020202A204070';
wwv_flow_api.g_varchar2_table(138) := '6172616D207B737472696E677D206368617261637465720A2020202020202020202A2040706172616D207B41727261797D206D6F646966696572730A2020202020202020202A2040706172616D207B4576656E747C4F626A6563747D20650A2020202020';
wwv_flow_api.g_varchar2_table(139) := '202020202A2040706172616D207B737472696E673D7D2073657175656E63654E616D65202D206E616D65206F66207468652073657175656E636520776520617265206C6F6F6B696E6720666F720A2020202020202020202A2040706172616D207B737472';
wwv_flow_api.g_varchar2_table(140) := '696E673D7D20636F6D62696E6174696F6E0A2020202020202020202A2040706172616D207B6E756D6265723D7D206C6576656C0A2020202020202020202A204072657475726E73207B41727261797D0A2020202020202020202A2F0A2020202020202020';
wwv_flow_api.g_varchar2_table(141) := '66756E6374696F6E205F6765744D617463686573286368617261637465722C206D6F646966696572732C20652C2073657175656E63654E616D652C20636F6D62696E6174696F6E2C206C6576656C29207B0A20202020202020202020202076617220693B';
wwv_flow_api.g_varchar2_table(142) := '0A2020202020202020202020207661722063616C6C6261636B3B0A202020202020202020202020766172206D617463686573203D205B5D3B0A20202020202020202020202076617220616374696F6E203D20652E747970653B0A0A202020202020202020';
wwv_flow_api.g_varchar2_table(143) := '2020202F2F20696620746865726520617265206E6F206576656E74732072656C6174656420746F2074686973206B6579636F64650A202020202020202020202020696620282173656C662E5F63616C6C6261636B735B6368617261637465725D29207B0A';
wwv_flow_api.g_varchar2_table(144) := '2020202020202020202020202020202072657475726E205B5D3B0A2020202020202020202020207D0A0A2020202020202020202020202F2F2069662061206D6F646966696572206B657920697320636F6D696E67207570206F6E20697473206F776E2077';
wwv_flow_api.g_varchar2_table(145) := '652073686F756C6420616C6C6F772069740A20202020202020202020202069662028616374696F6E203D3D20276B6579757027202626205F69734D6F646966696572286368617261637465722929207B0A202020202020202020202020202020206D6F64';
wwv_flow_api.g_varchar2_table(146) := '696669657273203D205B6368617261637465725D3B0A2020202020202020202020207D0A0A2020202020202020202020202F2F206C6F6F70207468726F75676820616C6C2063616C6C6261636B7320666F7220746865206B657920746861742077617320';
wwv_flow_api.g_varchar2_table(147) := '707265737365640A2020202020202020202020202F2F20616E642073656520696620616E79206F66207468656D206D617463680A202020202020202020202020666F72202869203D20303B2069203C2073656C662E5F63616C6C6261636B735B63686172';
wwv_flow_api.g_varchar2_table(148) := '61637465725D2E6C656E6774683B202B2B6929207B0A2020202020202020202020202020202063616C6C6261636B203D2073656C662E5F63616C6C6261636B735B6368617261637465725D5B695D3B0A0A202020202020202020202020202020202F2F20';
wwv_flow_api.g_varchar2_table(149) := '696620612073657175656E6365206E616D65206973206E6F74207370656369666965642C20627574207468697320697320612073657175656E63652061740A202020202020202020202020202020202F2F207468652077726F6E67206C6576656C207468';
wwv_flow_api.g_varchar2_table(150) := '656E206D6F7665206F6E746F20746865206E657874206D617463680A20202020202020202020202020202020696620282173657175656E63654E616D652026262063616C6C6261636B2E736571202626205F73657175656E63654C6576656C735B63616C';
wwv_flow_api.g_varchar2_table(151) := '6C6261636B2E7365715D20213D2063616C6C6261636B2E6C6576656C29207B0A2020202020202020202020202020202020202020636F6E74696E75653B0A202020202020202020202020202020207D0A0A202020202020202020202020202020202F2F20';
wwv_flow_api.g_varchar2_table(152) := '69662074686520616374696F6E20776520617265206C6F6F6B696E6720666F7220646F65736E2774206D617463682074686520616374696F6E20776520676F740A202020202020202020202020202020202F2F207468656E2077652073686F756C64206B';
wwv_flow_api.g_varchar2_table(153) := '65657020676F696E670A2020202020202020202020202020202069662028616374696F6E20213D2063616C6C6261636B2E616374696F6E29207B0A2020202020202020202020202020202020202020636F6E74696E75653B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(154) := '20202020207D0A0A202020202020202020202020202020202F2F20696620746869732069732061206B65797072657373206576656E7420616E6420746865206D657461206B657920616E6420636F6E74726F6C206B65790A202020202020202020202020';
wwv_flow_api.g_varchar2_table(155) := '202020202F2F20617265206E6F7420707265737365642074686174206D65616E732074686174207765206E65656420746F206F6E6C79206C6F6F6B206174207468650A202020202020202020202020202020202F2F206368617261637465722C206F7468';
wwv_flow_api.g_varchar2_table(156) := '65727769736520636865636B20746865206D6F646966696572732061732077656C6C0A202020202020202020202020202020202F2F0A202020202020202020202020202020202F2F206368726F6D652077696C6C206E6F7420666972652061206B657970';
wwv_flow_api.g_varchar2_table(157) := '72657373206966206D657461206F7220636F6E74726F6C20697320646F776E0A202020202020202020202020202020202F2F207361666172692077696C6C20666972652061206B65797072657373206966206D657461206F72206D6574612B7368696674';
wwv_flow_api.g_varchar2_table(158) := '20697320646F776E0A202020202020202020202020202020202F2F2066697265666F782077696C6C20666972652061206B65797072657373206966206D657461206F7220636F6E74726F6C20697320646F776E0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(159) := '6966202828616374696F6E203D3D20276B65797072657373272026262021652E6D6574614B65792026262021652E6374726C4B657929207C7C205F6D6F646966696572734D61746368286D6F646966696572732C2063616C6C6261636B2E6D6F64696669';
wwv_flow_api.g_varchar2_table(160) := '6572732929207B0A0A20202020202020202020202020202020202020202F2F207768656E20796F752062696E64206120636F6D62696E6174696F6E206F722073657175656E63652061207365636F6E642074696D652069740A2020202020202020202020';
wwv_flow_api.g_varchar2_table(161) := '2020202020202020202F2F2073686F756C64206F766572777269746520746865206669727374206F6E652E2020696620612073657175656E63654E616D65206F720A20202020202020202020202020202020202020202F2F20636F6D62696E6174696F6E';
wwv_flow_api.g_varchar2_table(162) := '2069732073706563696669656420696E20746869732063616C6C20697420646F6573206A75737420746861740A20202020202020202020202020202020202020202F2F0A20202020202020202020202020202020202020202F2F2040746F646F206D616B';
wwv_flow_api.g_varchar2_table(163) := '652064656C6574696E6720697473206F776E206D6574686F643F0A20202020202020202020202020202020202020207661722064656C657465436F6D626F203D202173657175656E63654E616D652026262063616C6C6261636B2E636F6D626F203D3D20';
wwv_flow_api.g_varchar2_table(164) := '636F6D62696E6174696F6E3B0A20202020202020202020202020202020202020207661722064656C65746553657175656E6365203D2073657175656E63654E616D652026262063616C6C6261636B2E736571203D3D2073657175656E63654E616D652026';
wwv_flow_api.g_varchar2_table(165) := '262063616C6C6261636B2E6C6576656C203D3D206C6576656C3B0A20202020202020202020202020202020202020206966202864656C657465436F6D626F207C7C2064656C65746553657175656E636529207B0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(166) := '202020202020202073656C662E5F63616C6C6261636B735B6368617261637465725D2E73706C69636528692C2031293B0A20202020202020202020202020202020202020207D0A0A20202020202020202020202020202020202020206D6174636865732E';
wwv_flow_api.g_varchar2_table(167) := '707573682863616C6C6261636B293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A0A20202020202020202020202072657475726E206D6174636865733B0A20202020202020207D0A0A20202020202020202F2A2A0A';
wwv_flow_api.g_varchar2_table(168) := '2020202020202020202A2061637475616C6C792063616C6C73207468652063616C6C6261636B2066756E6374696F6E0A2020202020202020202A0A2020202020202020202A20696620796F75722063616C6C6261636B2066756E6374696F6E2072657475';
wwv_flow_api.g_varchar2_table(169) := '726E732066616C736520746869732077696C6C2075736520746865206A71756572790A2020202020202020202A20636F6E76656E74696F6E202D2070726576656E742064656661756C7420616E642073746F702070726F706F676174696F6E206F6E2074';
wwv_flow_api.g_varchar2_table(170) := '6865206576656E740A2020202020202020202A0A2020202020202020202A2040706172616D207B46756E6374696F6E7D2063616C6C6261636B0A2020202020202020202A2040706172616D207B4576656E747D20650A2020202020202020202A20407265';
wwv_flow_api.g_varchar2_table(171) := '7475726E7320766F69640A2020202020202020202A2F0A202020202020202066756E6374696F6E205F6669726543616C6C6261636B2863616C6C6261636B2C20652C20636F6D626F2C2073657175656E636529207B0A0A2020202020202020202020202F';
wwv_flow_api.g_varchar2_table(172) := '2F2069662074686973206576656E742073686F756C64206E6F742068617070656E2073746F7020686572650A2020202020202020202020206966202873656C662E73746F7043616C6C6261636B28652C20652E746172676574207C7C20652E737263456C';
wwv_flow_api.g_varchar2_table(173) := '656D656E742C20636F6D626F2C2073657175656E63652929207B0A2020202020202020202020202020202072657475726E3B0A2020202020202020202020207D0A0A2020202020202020202020206966202863616C6C6261636B28652C20636F6D626F29';
wwv_flow_api.g_varchar2_table(174) := '203D3D3D2066616C736529207B0A202020202020202020202020202020205F70726576656E7444656661756C742865293B0A202020202020202020202020202020205F73746F7050726F7061676174696F6E2865293B0A2020202020202020202020207D';
wwv_flow_api.g_varchar2_table(175) := '0A20202020202020207D0A0A20202020202020202F2A2A0A2020202020202020202A2068616E646C6573206120636861726163746572206B6579206576656E740A2020202020202020202A0A2020202020202020202A2040706172616D207B737472696E';
wwv_flow_api.g_varchar2_table(176) := '677D206368617261637465720A2020202020202020202A2040706172616D207B41727261797D206D6F646966696572730A2020202020202020202A2040706172616D207B4576656E747D20650A2020202020202020202A204072657475726E7320766F69';
wwv_flow_api.g_varchar2_table(177) := '640A2020202020202020202A2F0A202020202020202073656C662E5F68616E646C654B6579203D2066756E6374696F6E286368617261637465722C206D6F646966696572732C206529207B0A2020202020202020202020207661722063616C6C6261636B';
wwv_flow_api.g_varchar2_table(178) := '73203D205F6765744D617463686573286368617261637465722C206D6F646966696572732C2065293B0A20202020202020202020202076617220693B0A20202020202020202020202076617220646F4E6F745265736574203D207B7D3B0A202020202020';
wwv_flow_api.g_varchar2_table(179) := '202020202020766172206D61784C6576656C203D20303B0A2020202020202020202020207661722070726F63657373656453657175656E636543616C6C6261636B203D2066616C73653B0A0A2020202020202020202020202F2F2043616C63756C617465';
wwv_flow_api.g_varchar2_table(180) := '20746865206D61784C6576656C20666F722073657175656E63657320736F2077652063616E206F6E6C79206578656375746520746865206C6F6E676573742063616C6C6261636B2073657175656E63650A202020202020202020202020666F7220286920';
wwv_flow_api.g_varchar2_table(181) := '3D20303B2069203C2063616C6C6261636B732E6C656E6774683B202B2B6929207B0A202020202020202020202020202020206966202863616C6C6261636B735B695D2E73657129207B0A20202020202020202020202020202020202020206D61784C6576';
wwv_flow_api.g_varchar2_table(182) := '656C203D204D6174682E6D6178286D61784C6576656C2C2063616C6C6261636B735B695D2E6C6576656C293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A0A2020202020202020202020202F2F206C6F6F70207468';
wwv_flow_api.g_varchar2_table(183) := '726F756768206D61746368696E672063616C6C6261636B7320666F722074686973206B6579206576656E740A202020202020202020202020666F72202869203D20303B2069203C2063616C6C6261636B732E6C656E6774683B202B2B6929207B0A0A2020';
wwv_flow_api.g_varchar2_table(184) := '20202020202020202020202020202F2F206669726520666F7220616C6C2073657175656E63652063616C6C6261636B730A202020202020202020202020202020202F2F2074686973206973206265636175736520696620666F72206578616D706C652079';
wwv_flow_api.g_varchar2_table(185) := '6F752068617665206D756C7469706C652073657175656E6365730A202020202020202020202020202020202F2F20626F756E64207375636820617320226720692220616E64202267207422207468657920626F7468206E65656420746F20666972652074';
wwv_flow_api.g_varchar2_table(186) := '68650A202020202020202020202020202020202F2F2063616C6C6261636B20666F72206D61746368696E672067206361757365206F746865727769736520796F752063616E206F6E6C7920657665720A202020202020202020202020202020202F2F206D';
wwv_flow_api.g_varchar2_table(187) := '6174636820746865206669727374206F6E650A202020202020202020202020202020206966202863616C6C6261636B735B695D2E73657129207B0A0A20202020202020202020202020202020202020202F2F206F6E6C7920666972652063616C6C626163';
wwv_flow_api.g_varchar2_table(188) := '6B7320666F7220746865206D61784C6576656C20746F2070726576656E740A20202020202020202020202020202020202020202F2F2073756273657175656E6365732066726F6D20616C736F20666972696E670A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(189) := '202020202F2F0A20202020202020202020202020202020202020202F2F20666F72206578616D706C65202761206F7074696F6E2062272073686F756C64206E6F7420636175736520276F7074696F6E20622720746F20666972650A202020202020202020';
wwv_flow_api.g_varchar2_table(190) := '20202020202020202020202F2F206576656E2074686F75676820276F7074696F6E2062272069732070617274206F6620746865206F746865722073657175656E63650A20202020202020202020202020202020202020202F2F0A20202020202020202020';
wwv_flow_api.g_varchar2_table(191) := '202020202020202020202F2F20616E792073657175656E636573207468617420646F206E6F74206D6174636820686572652077696C6C206265206469736361726465640A20202020202020202020202020202020202020202F2F2062656C6F7720627920';
wwv_flow_api.g_varchar2_table(192) := '746865205F726573657453657175656E6365732063616C6C0A20202020202020202020202020202020202020206966202863616C6C6261636B735B695D2E6C6576656C20213D206D61784C6576656C29207B0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(193) := '20202020202020636F6E74696E75653B0A20202020202020202020202020202020202020207D0A0A202020202020202020202020202020202020202070726F63657373656453657175656E636543616C6C6261636B203D20747275653B0A0A2020202020';
wwv_flow_api.g_varchar2_table(194) := '2020202020202020202020202020202F2F206B6565702061206C697374206F662077686963682073657175656E6365732077657265206D61746368657320666F72206C617465720A2020202020202020202020202020202020202020646F4E6F74526573';
wwv_flow_api.g_varchar2_table(195) := '65745B63616C6C6261636B735B695D2E7365715D203D20313B0A20202020202020202020202020202020202020205F6669726543616C6C6261636B2863616C6C6261636B735B695D2E63616C6C6261636B2C20652C2063616C6C6261636B735B695D2E63';
wwv_flow_api.g_varchar2_table(196) := '6F6D626F2C2063616C6C6261636B735B695D2E736571293B0A2020202020202020202020202020202020202020636F6E74696E75653B0A202020202020202020202020202020207D0A0A202020202020202020202020202020202F2F2069662074686572';
wwv_flow_api.g_varchar2_table(197) := '652077657265206E6F2073657175656E6365206D6174636865732062757420776520617265207374696C6C20686572650A202020202020202020202020202020202F2F2074686174206D65616E732074686973206973206120726567756C6172206D6174';
wwv_flow_api.g_varchar2_table(198) := '636820736F2077652073686F756C64206669726520746861740A20202020202020202020202020202020696620282170726F63657373656453657175656E636543616C6C6261636B29207B0A20202020202020202020202020202020202020205F666972';
wwv_flow_api.g_varchar2_table(199) := '6543616C6C6261636B2863616C6C6261636B735B695D2E63616C6C6261636B2C20652C2063616C6C6261636B735B695D2E636F6D626F293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A0A20202020202020202020';
wwv_flow_api.g_varchar2_table(200) := '20202F2F20696620746865206B657920796F752070726573736564206D617463686573207468652074797065206F662073657175656E636520776974686F75740A2020202020202020202020202F2F206265696E672061206D6F64696669657220286965';
wwv_flow_api.g_varchar2_table(201) := '20226B6579757022206F7220226B657970726573732229207468656E2077652073686F756C640A2020202020202020202020202F2F20726573657420616C6C2073657175656E63657320746861742077657265206E6F74206D6174636865642062792074';
wwv_flow_api.g_varchar2_table(202) := '686973206576656E740A2020202020202020202020202F2F0A2020202020202020202020202F2F207468697320697320736F2C20666F72206578616D706C652C20696620796F752068617665207468652073657175656E6365202268206120742220616E';
wwv_flow_api.g_varchar2_table(203) := '6420796F750A2020202020202020202020202F2F207479706520226820652061207220742220697420646F6573206E6F74206D617463682E2020696E2074686973206361736520746865202265222077696C6C0A2020202020202020202020202F2F2063';
wwv_flow_api.g_varchar2_table(204) := '61757365207468652073657175656E636520746F2072657365740A2020202020202020202020202F2F0A2020202020202020202020202F2F206D6F646966696572206B657973206172652069676E6F726564206265636175736520796F752063616E2068';
wwv_flow_api.g_varchar2_table(205) := '61766520612073657175656E63650A2020202020202020202020202F2F207468617420636F6E7461696E73206D6F6469666965727320737563682061732022656E746572206374726C2B73706163652220616E6420696E206D6F73740A20202020202020';
wwv_flow_api.g_varchar2_table(206) := '20202020202F2F20636173657320746865206D6F646966696572206B65792077696C6C2062652070726573736564206265666F726520746865206E657874206B65790A2020202020202020202020202F2F0A2020202020202020202020202F2F20616C73';
wwv_flow_api.g_varchar2_table(207) := '6F20696620796F75206861766520612073657175656E6365207375636820617320226374726C2B62206122207468656E207072657373696E67207468650A2020202020202020202020202F2F20226222206B65792077696C6C2074726967676572206120';
wwv_flow_api.g_varchar2_table(208) := '226B657970726573732220616E64206120226B6579646F776E220A2020202020202020202020202F2F0A2020202020202020202020202F2F2074686520226B6579646F776E22206973206578706563746564207768656E2074686572652069732061206D';
wwv_flow_api.g_varchar2_table(209) := '6F6469666965722C20627574207468650A2020202020202020202020202F2F20226B657970726573732220656E6473207570206D61746368696E6720746865205F6E6578744578706563746564416374696F6E2073696E6365206974206F63637572730A';
wwv_flow_api.g_varchar2_table(210) := '2020202020202020202020202F2F20616674657220616E64207468617420636175736573207468652073657175656E636520746F2072657365740A2020202020202020202020202F2F0A2020202020202020202020202F2F2077652069676E6F7265206B';
wwv_flow_api.g_varchar2_table(211) := '65797072657373657320696E20612073657175656E63652074686174206469726563746C7920666F6C6C6F772061206B6579646F776E0A2020202020202020202020202F2F20666F72207468652073616D65206368617261637465720A20202020202020';
wwv_flow_api.g_varchar2_table(212) := '20202020207661722069676E6F7265546869734B65797072657373203D20652E74797065203D3D20276B6579707265737327202626205F69676E6F72654E6578744B657970726573733B0A20202020202020202020202069662028652E74797065203D3D';
wwv_flow_api.g_varchar2_table(213) := '205F6E6578744578706563746564416374696F6E20262620215F69734D6F6469666965722863686172616374657229202626202169676E6F7265546869734B6579707265737329207B0A202020202020202020202020202020205F726573657453657175';
wwv_flow_api.g_varchar2_table(214) := '656E63657328646F4E6F745265736574293B0A2020202020202020202020207D0A0A2020202020202020202020205F69676E6F72654E6578744B65797072657373203D2070726F63657373656453657175656E636543616C6C6261636B20262620652E74';
wwv_flow_api.g_varchar2_table(215) := '797065203D3D20276B6579646F776E273B0A20202020202020207D3B0A0A20202020202020202F2A2A0A2020202020202020202A2068616E646C65732061206B6579646F776E206576656E740A2020202020202020202A0A2020202020202020202A2040';
wwv_flow_api.g_varchar2_table(216) := '706172616D207B4576656E747D20650A2020202020202020202A204072657475726E7320766F69640A2020202020202020202A2F0A202020202020202066756E6374696F6E205F68616E646C654B65794576656E74286529207B0A0A2020202020202020';
wwv_flow_api.g_varchar2_table(217) := '202020202F2F206E6F726D616C697A6520652E776869636820666F72206B6579206576656E74730A2020202020202020202020202F2F204073656520687474703A2F2F737461636B6F766572666C6F772E636F6D2F7175657374696F6E732F3432383536';
wwv_flow_api.g_varchar2_table(218) := '32372F6A6176617363726970742D6B6579636F64652D76732D63686172636F64652D75747465722D636F6E667573696F6E0A20202020202020202020202069662028747970656F6620652E776869636820213D3D20276E756D6265722729207B0A202020';
wwv_flow_api.g_varchar2_table(219) := '20202020202020202020202020652E7768696368203D20652E6B6579436F64653B0A2020202020202020202020207D0A0A20202020202020202020202076617220636861726163746572203D205F63686172616374657246726F6D4576656E742865293B';
wwv_flow_api.g_varchar2_table(220) := '0A0A2020202020202020202020202F2F206E6F2063686172616374657220666F756E64207468656E2073746F700A202020202020202020202020696620282163686172616374657229207B0A2020202020202020202020202020202072657475726E3B0A';
wwv_flow_api.g_varchar2_table(221) := '2020202020202020202020207D0A0A2020202020202020202020202F2F206E65656420746F20757365203D3D3D20666F72207468652063686172616374657220636865636B206265636175736520746865206368617261637465722063616E2062652030';
wwv_flow_api.g_varchar2_table(222) := '0A20202020202020202020202069662028652E74797065203D3D20276B6579757027202626205F69676E6F72654E6578744B65797570203D3D3D2063686172616374657229207B0A202020202020202020202020202020205F69676E6F72654E6578744B';
wwv_flow_api.g_varchar2_table(223) := '65797570203D2066616C73653B0A2020202020202020202020202020202072657475726E3B0A2020202020202020202020207D0A0A20202020202020202020202073656C662E68616E646C654B6579286368617261637465722C205F6576656E744D6F64';
wwv_flow_api.g_varchar2_table(224) := '6966696572732865292C2065293B0A20202020202020207D0A0A20202020202020202F2A2A0A2020202020202020202A2063616C6C656420746F2073657420612031207365636F6E642074696D656F7574206F6E20746865207370656369666965642073';
wwv_flow_api.g_varchar2_table(225) := '657175656E63650A2020202020202020202A0A2020202020202020202A207468697320697320736F2061667465722065616368206B657920707265737320696E207468652073657175656E636520796F7520686176652031207365636F6E640A20202020';
wwv_flow_api.g_varchar2_table(226) := '20202020202A20746F20707265737320746865206E657874206B6579206265666F726520796F75206861766520746F207374617274206F7665720A2020202020202020202A0A2020202020202020202A204072657475726E7320766F69640A2020202020';
wwv_flow_api.g_varchar2_table(227) := '202020202A2F0A202020202020202066756E6374696F6E205F726573657453657175656E636554696D65722829207B0A202020202020202020202020636C65617254696D656F7574285F726573657454696D6572293B0A2020202020202020202020205F';
wwv_flow_api.g_varchar2_table(228) := '726573657454696D6572203D2073657454696D656F7574285F726573657453657175656E6365732C2031303030293B0A20202020202020207D0A0A20202020202020202F2A2A0A2020202020202020202A2062696E64732061206B65792073657175656E';
wwv_flow_api.g_varchar2_table(229) := '636520746F20616E206576656E740A2020202020202020202A0A2020202020202020202A2040706172616D207B737472696E677D20636F6D626F202D20636F6D626F2073706563696669656420696E2062696E642063616C6C0A2020202020202020202A';
wwv_flow_api.g_varchar2_table(230) := '2040706172616D207B41727261797D206B6579730A2020202020202020202A2040706172616D207B46756E6374696F6E7D2063616C6C6261636B0A2020202020202020202A2040706172616D207B737472696E673D7D20616374696F6E0A202020202020';
wwv_flow_api.g_varchar2_table(231) := '2020202A204072657475726E7320766F69640A2020202020202020202A2F0A202020202020202066756E6374696F6E205F62696E6453657175656E636528636F6D626F2C206B6579732C2063616C6C6261636B2C20616374696F6E29207B0A0A20202020';
wwv_flow_api.g_varchar2_table(232) := '20202020202020202F2F207374617274206F666620627920616464696E6720612073657175656E6365206C6576656C207265636F726420666F72207468697320636F6D62696E6174696F6E0A2020202020202020202020202F2F20616E64207365747469';
wwv_flow_api.g_varchar2_table(233) := '6E6720746865206C6576656C20746F20300A2020202020202020202020205F73657175656E63654C6576656C735B636F6D626F5D203D20303B0A0A2020202020202020202020202F2A2A0A202020202020202020202020202A2063616C6C6261636B2074';
wwv_flow_api.g_varchar2_table(234) := '6F20696E637265617365207468652073657175656E6365206C6576656C20666F7220746869732073657175656E636520616E642072657365740A202020202020202020202020202A20616C6C206F746865722073657175656E6365732074686174207765';
wwv_flow_api.g_varchar2_table(235) := '7265206163746976650A202020202020202020202020202A0A202020202020202020202020202A2040706172616D207B737472696E677D206E657874416374696F6E0A202020202020202020202020202A204072657475726E73207B46756E6374696F6E';
wwv_flow_api.g_varchar2_table(236) := '7D0A202020202020202020202020202A2F0A20202020202020202020202066756E6374696F6E205F696E63726561736553657175656E6365286E657874416374696F6E29207B0A2020202020202020202020202020202072657475726E2066756E637469';
wwv_flow_api.g_varchar2_table(237) := '6F6E2829207B0A20202020202020202020202020202020202020205F6E6578744578706563746564416374696F6E203D206E657874416374696F6E3B0A20202020202020202020202020202020202020202B2B5F73657175656E63654C6576656C735B63';
wwv_flow_api.g_varchar2_table(238) := '6F6D626F5D3B0A20202020202020202020202020202020202020205F726573657453657175656E636554696D657228293B0A202020202020202020202020202020207D3B0A2020202020202020202020207D0A0A2020202020202020202020202F2A2A0A';
wwv_flow_api.g_varchar2_table(239) := '202020202020202020202020202A20777261707320746865207370656369666965642063616C6C6261636B20696E73696465206F6620616E6F746865722066756E6374696F6E20696E206F726465720A202020202020202020202020202A20746F207265';
wwv_flow_api.g_varchar2_table(240) := '73657420616C6C2073657175656E636520636F756E7465727320617320736F6F6E20617320746869732073657175656E636520697320646F6E650A202020202020202020202020202A0A202020202020202020202020202A2040706172616D207B457665';
wwv_flow_api.g_varchar2_table(241) := '6E747D20650A202020202020202020202020202A204072657475726E7320766F69640A202020202020202020202020202A2F0A20202020202020202020202066756E6374696F6E205F63616C6C6261636B416E645265736574286529207B0A2020202020';
wwv_flow_api.g_varchar2_table(242) := '20202020202020202020205F6669726543616C6C6261636B2863616C6C6261636B2C20652C20636F6D626F293B0A0A202020202020202020202020202020202F2F2077652073686F756C642069676E6F726520746865206E657874206B65792075702069';
wwv_flow_api.g_varchar2_table(243) := '662074686520616374696F6E206973206B657920646F776E0A202020202020202020202020202020202F2F206F72206B657970726573732E20207468697320697320736F20696620796F752066696E69736820612073657175656E636520616E640A2020';
wwv_flow_api.g_varchar2_table(244) := '20202020202020202020202020202F2F2072656C6561736520746865206B6579207468652066696E616C206B65792077696C6C206E6F7420747269676765722061206B657975700A2020202020202020202020202020202069662028616374696F6E2021';
wwv_flow_api.g_varchar2_table(245) := '3D3D20276B657975702729207B0A20202020202020202020202020202020202020205F69676E6F72654E6578744B65797570203D205F63686172616374657246726F6D4576656E742865293B0A202020202020202020202020202020207D0A0A20202020';
wwv_flow_api.g_varchar2_table(246) := '2020202020202020202020202F2F207765697264207261636520636F6E646974696F6E20696620612073657175656E636520656E6473207769746820746865206B65790A202020202020202020202020202020202F2F20616E6F74686572207365717565';
wwv_flow_api.g_varchar2_table(247) := '6E636520626567696E7320776974680A2020202020202020202020202020202073657454696D656F7574285F726573657453657175656E6365732C203130293B0A2020202020202020202020207D0A0A2020202020202020202020202F2F206C6F6F7020';
wwv_flow_api.g_varchar2_table(248) := '7468726F756768206B657973206F6E6520617420612074696D6520616E642062696E642074686520617070726F7072696174652063616C6C6261636B0A2020202020202020202020202F2F2066756E6374696F6E2E2020666F7220616E79206B6579206C';
wwv_flow_api.g_varchar2_table(249) := '656164696E6720757020746F207468652066696E616C206F6E652069742073686F756C640A2020202020202020202020202F2F20696E637265617365207468652073657175656E63652E206166746572207468652066696E616C2C2069742073686F756C';
wwv_flow_api.g_varchar2_table(250) := '6420726573657420616C6C2073657175656E6365730A2020202020202020202020202F2F0A2020202020202020202020202F2F20696620616E20616374696F6E2069732073706563696669656420696E20746865206F726967696E616C2062696E642063';
wwv_flow_api.g_varchar2_table(251) := '616C6C207468656E20746861742077696C6C0A2020202020202020202020202F2F2062652075736564207468726F7567686F75742E20206F74686572776973652077652077696C6C20706173732074686520616374696F6E2074686174207468650A2020';
wwv_flow_api.g_varchar2_table(252) := '202020202020202020202F2F206E657874206B657920696E207468652073657175656E63652073686F756C64206D617463682E20207468697320616C6C6F777320612073657175656E63650A2020202020202020202020202F2F20746F206D697820616E';
wwv_flow_api.g_varchar2_table(253) := '64206D61746368206B6579707265737320616E64206B6579646F776E206576656E747320646570656E64696E67206F6E2077686963680A2020202020202020202020202F2F206F6E657320617265206265747465722073756974656420746F2074686520';
wwv_flow_api.g_varchar2_table(254) := '6B65792070726F76696465640A202020202020202020202020666F7220287661722069203D20303B2069203C206B6579732E6C656E6774683B202B2B6929207B0A2020202020202020202020202020202076617220697346696E616C203D2069202B2031';
wwv_flow_api.g_varchar2_table(255) := '203D3D3D206B6579732E6C656E6774683B0A20202020202020202020202020202020766172207772617070656443616C6C6261636B203D20697346696E616C203F205F63616C6C6261636B416E645265736574203A205F696E6372656173655365717565';
wwv_flow_api.g_varchar2_table(256) := '6E636528616374696F6E207C7C205F6765744B6579496E666F286B6579735B69202B20315D292E616374696F6E293B0A202020202020202020202020202020205F62696E6453696E676C65286B6579735B695D2C207772617070656443616C6C6261636B';
wwv_flow_api.g_varchar2_table(257) := '2C20616374696F6E2C20636F6D626F2C2069293B0A2020202020202020202020207D0A20202020202020207D0A0A20202020202020202F2A2A0A2020202020202020202A2062696E647320612073696E676C65206B6579626F61726420636F6D62696E61';
wwv_flow_api.g_varchar2_table(258) := '74696F6E0A2020202020202020202A0A2020202020202020202A2040706172616D207B737472696E677D20636F6D62696E6174696F6E0A2020202020202020202A2040706172616D207B46756E6374696F6E7D2063616C6C6261636B0A20202020202020';
wwv_flow_api.g_varchar2_table(259) := '20202A2040706172616D207B737472696E673D7D20616374696F6E0A2020202020202020202A2040706172616D207B737472696E673D7D2073657175656E63654E616D65202D206E616D65206F662073657175656E63652069662070617274206F662073';
wwv_flow_api.g_varchar2_table(260) := '657175656E63650A2020202020202020202A2040706172616D207B6E756D6265723D7D206C6576656C202D20776861742070617274206F66207468652073657175656E63652074686520636F6D6D616E642069730A2020202020202020202A2040726574';
wwv_flow_api.g_varchar2_table(261) := '75726E7320766F69640A2020202020202020202A2F0A202020202020202066756E6374696F6E205F62696E6453696E676C6528636F6D62696E6174696F6E2C2063616C6C6261636B2C20616374696F6E2C2073657175656E63654E616D652C206C657665';
wwv_flow_api.g_varchar2_table(262) := '6C29207B0A0A2020202020202020202020202F2F2073746F7265206120646972656374206D6170706564207265666572656E636520666F72207573652077697468204D6F757365747261702E747269676765720A20202020202020202020202073656C66';
wwv_flow_api.g_varchar2_table(263) := '2E5F6469726563744D61705B636F6D62696E6174696F6E202B20273A27202B20616374696F6E5D203D2063616C6C6261636B3B0A0A2020202020202020202020202F2F206D616B652073757265206D756C7469706C652073706163657320696E20612072';
wwv_flow_api.g_varchar2_table(264) := '6F77206265636F6D6520612073696E676C652073706163650A202020202020202020202020636F6D62696E6174696F6E203D20636F6D62696E6174696F6E2E7265706C616365282F5C732B2F672C20272027293B0A0A2020202020202020202020207661';
wwv_flow_api.g_varchar2_table(265) := '722073657175656E6365203D20636F6D62696E6174696F6E2E73706C697428272027293B0A20202020202020202020202076617220696E666F3B0A0A2020202020202020202020202F2F2069662074686973207061747465726E20697320612073657175';
wwv_flow_api.g_varchar2_table(266) := '656E6365206F66206B657973207468656E2072756E207468726F7567682074686973206D6574686F640A2020202020202020202020202F2F20746F20726570726F636573732065616368207061747465726E206F6E65206B657920617420612074696D65';
wwv_flow_api.g_varchar2_table(267) := '0A2020202020202020202020206966202873657175656E63652E6C656E677468203E203129207B0A202020202020202020202020202020205F62696E6453657175656E636528636F6D62696E6174696F6E2C2073657175656E63652C2063616C6C626163';
wwv_flow_api.g_varchar2_table(268) := '6B2C20616374696F6E293B0A2020202020202020202020202020202072657475726E3B0A2020202020202020202020207D0A0A202020202020202020202020696E666F203D205F6765744B6579496E666F28636F6D62696E6174696F6E2C20616374696F';
wwv_flow_api.g_varchar2_table(269) := '6E293B0A0A2020202020202020202020202F2F206D616B65207375726520746F20696E697469616C697A652061727261792069662074686973206973207468652066697273742074696D650A2020202020202020202020202F2F20612063616C6C626163';
wwv_flow_api.g_varchar2_table(270) := '6B20697320616464656420666F722074686973206B65790A20202020202020202020202073656C662E5F63616C6C6261636B735B696E666F2E6B65795D203D2073656C662E5F63616C6C6261636B735B696E666F2E6B65795D207C7C205B5D3B0A0A2020';
wwv_flow_api.g_varchar2_table(271) := '202020202020202020202F2F2072656D6F766520616E206578697374696E67206D61746368206966207468657265206973206F6E650A2020202020202020202020205F6765744D61746368657328696E666F2E6B65792C20696E666F2E6D6F6469666965';
wwv_flow_api.g_varchar2_table(272) := '72732C207B747970653A20696E666F2E616374696F6E7D2C2073657175656E63654E616D652C20636F6D62696E6174696F6E2C206C6576656C293B0A0A2020202020202020202020202F2F2061646420746869732063616C6C206261636B20746F207468';
wwv_flow_api.g_varchar2_table(273) := '652061727261790A2020202020202020202020202F2F20696620697420697320612073657175656E6365207075742069742061742074686520626567696E6E696E670A2020202020202020202020202F2F206966206E6F74207075742069742061742074';
wwv_flow_api.g_varchar2_table(274) := '686520656E640A2020202020202020202020202F2F0A2020202020202020202020202F2F207468697320697320696D706F7274616E7420626563617573652074686520776179207468657365206172652070726F63657373656420657870656374730A20';
wwv_flow_api.g_varchar2_table(275) := '20202020202020202020202F2F207468652073657175656E6365206F6E657320746F20636F6D652066697273740A20202020202020202020202073656C662E5F63616C6C6261636B735B696E666F2E6B65795D5B73657175656E63654E616D65203F2027';
wwv_flow_api.g_varchar2_table(276) := '756E736869667427203A202770757368275D287B0A2020202020202020202020202020202063616C6C6261636B3A2063616C6C6261636B2C0A202020202020202020202020202020206D6F646966696572733A20696E666F2E6D6F646966696572732C0A';
wwv_flow_api.g_varchar2_table(277) := '20202020202020202020202020202020616374696F6E3A20696E666F2E616374696F6E2C0A202020202020202020202020202020207365713A2073657175656E63654E616D652C0A202020202020202020202020202020206C6576656C3A206C6576656C';
wwv_flow_api.g_varchar2_table(278) := '2C0A20202020202020202020202020202020636F6D626F3A20636F6D62696E6174696F6E0A2020202020202020202020207D293B0A20202020202020207D0A0A20202020202020202F2A2A0A2020202020202020202A2062696E6473206D756C7469706C';
wwv_flow_api.g_varchar2_table(279) := '6520636F6D62696E6174696F6E7320746F207468652073616D652063616C6C6261636B0A2020202020202020202A0A2020202020202020202A2040706172616D207B41727261797D20636F6D62696E6174696F6E730A2020202020202020202A20407061';
wwv_flow_api.g_varchar2_table(280) := '72616D207B46756E6374696F6E7D2063616C6C6261636B0A2020202020202020202A2040706172616D207B737472696E677C756E646566696E65647D20616374696F6E0A2020202020202020202A204072657475726E7320766F69640A20202020202020';
wwv_flow_api.g_varchar2_table(281) := '20202A2F0A202020202020202073656C662E5F62696E644D756C7469706C65203D2066756E6374696F6E28636F6D62696E6174696F6E732C2063616C6C6261636B2C20616374696F6E29207B0A202020202020202020202020666F722028766172206920';
wwv_flow_api.g_varchar2_table(282) := '3D20303B2069203C20636F6D62696E6174696F6E732E6C656E6774683B202B2B6929207B0A202020202020202020202020202020205F62696E6453696E676C6528636F6D62696E6174696F6E735B695D2C2063616C6C6261636B2C20616374696F6E293B';
wwv_flow_api.g_varchar2_table(283) := '0A2020202020202020202020207D0A20202020202020207D3B0A0A20202020202020202F2F207374617274210A20202020202020205F6164644576656E7428746172676574456C656D656E742C20276B65797072657373272C205F68616E646C654B6579';
wwv_flow_api.g_varchar2_table(284) := '4576656E74293B0A20202020202020205F6164644576656E7428746172676574456C656D656E742C20276B6579646F776E272C205F68616E646C654B65794576656E74293B0A20202020202020205F6164644576656E7428746172676574456C656D656E';
wwv_flow_api.g_varchar2_table(285) := '742C20276B65797570272C205F68616E646C654B65794576656E74293B0A202020207D0A0A202020202F2A2A0A20202020202A2062696E647320616E206576656E7420746F206D6F757365747261700A20202020202A0A20202020202A2063616E206265';
wwv_flow_api.g_varchar2_table(286) := '20612073696E676C65206B65792C206120636F6D62696E6174696F6E206F66206B657973207365706172617465642077697468202B2C0A20202020202A20616E206172726179206F66206B6579732C206F7220612073657175656E6365206F66206B6579';
wwv_flow_api.g_varchar2_table(287) := '7320736570617261746564206279207370616365730A20202020202A0A20202020202A206265207375726520746F206C69737420746865206D6F646966696572206B65797320666972737420746F206D616B6520737572652074686174207468650A2020';
wwv_flow_api.g_varchar2_table(288) := '2020202A20636F7272656374206B657920656E64732075702067657474696E6720626F756E642028746865206C617374206B657920696E20746865207061747465726E290A20202020202A0A20202020202A2040706172616D207B737472696E677C4172';
wwv_flow_api.g_varchar2_table(289) := '7261797D206B6579730A20202020202A2040706172616D207B46756E6374696F6E7D2063616C6C6261636B0A20202020202A2040706172616D207B737472696E673D7D20616374696F6E202D20276B65797072657373272C20276B6579646F776E272C20';
wwv_flow_api.g_varchar2_table(290) := '6F7220276B65797570270A20202020202A204072657475726E7320766F69640A20202020202A2F0A202020204D6F757365747261702E70726F746F747970652E62696E64203D2066756E6374696F6E286B6579732C2063616C6C6261636B2C2061637469';
wwv_flow_api.g_varchar2_table(291) := '6F6E29207B0A20202020202020207661722073656C66203D20746869733B0A20202020202020206B657973203D206B65797320696E7374616E63656F66204172726179203F206B657973203A205B6B6579735D3B0A202020202020202073656C662E5F62';
wwv_flow_api.g_varchar2_table(292) := '696E644D756C7469706C652E63616C6C2873656C662C206B6579732C2063616C6C6261636B2C20616374696F6E293B0A202020202020202072657475726E2073656C663B0A202020207D3B0A0A202020202F2A2A0A20202020202A20756E62696E647320';
wwv_flow_api.g_varchar2_table(293) := '616E206576656E7420746F206D6F757365747261700A20202020202A0A20202020202A2074686520756E62696E64696E672073657473207468652063616C6C6261636B2066756E6374696F6E206F662074686520737065636966696564206B657920636F';
wwv_flow_api.g_varchar2_table(294) := '6D626F0A20202020202A20746F20616E20656D7074792066756E6374696F6E20616E642064656C657465732074686520636F72726573706F6E64696E67206B657920696E207468650A20202020202A205F6469726563744D617020646963742E0A202020';
wwv_flow_api.g_varchar2_table(295) := '20202A0A20202020202A20544F444F3A2061637475616C6C792072656D6F766520746869732066726F6D20746865205F63616C6C6261636B732064696374696F6E61727920696E73746561640A20202020202A206F662062696E64696E6720616E20656D';
wwv_flow_api.g_varchar2_table(296) := '7074792066756E6374696F6E0A20202020202A0A20202020202A20746865206B6579636F6D626F2B616374696F6E2068617320746F2062652065786163746C79207468652073616D652061730A20202020202A2069742077617320646566696E65642069';
wwv_flow_api.g_varchar2_table(297) := '6E207468652062696E64206D6574686F640A20202020202A0A20202020202A2040706172616D207B737472696E677C41727261797D206B6579730A20202020202A2040706172616D207B737472696E677D20616374696F6E0A20202020202A2040726574';
wwv_flow_api.g_varchar2_table(298) := '75726E7320766F69640A20202020202A2F0A202020204D6F757365747261702E70726F746F747970652E756E62696E64203D2066756E6374696F6E286B6579732C20616374696F6E29207B0A20202020202020207661722073656C66203D20746869733B';
wwv_flow_api.g_varchar2_table(299) := '0A202020202020202072657475726E2073656C662E62696E642E63616C6C2873656C662C206B6579732C2066756E6374696F6E2829207B7D2C20616374696F6E293B0A202020207D3B0A0A202020202F2A2A0A20202020202A2074726967676572732061';
wwv_flow_api.g_varchar2_table(300) := '6E206576656E7420746861742068617320616C7265616479206265656E20626F756E640A20202020202A0A20202020202A2040706172616D207B737472696E677D206B6579730A20202020202A2040706172616D207B737472696E673D7D20616374696F';
wwv_flow_api.g_varchar2_table(301) := '6E0A20202020202A204072657475726E7320766F69640A20202020202A2F0A202020204D6F757365747261702E70726F746F747970652E74726967676572203D2066756E6374696F6E286B6579732C20616374696F6E29207B0A20202020202020207661';
wwv_flow_api.g_varchar2_table(302) := '722073656C66203D20746869733B0A20202020202020206966202873656C662E5F6469726563744D61705B6B657973202B20273A27202B20616374696F6E5D29207B0A20202020202020202020202073656C662E5F6469726563744D61705B6B65797320';
wwv_flow_api.g_varchar2_table(303) := '2B20273A27202B20616374696F6E5D287B7D2C206B657973293B0A20202020202020207D0A202020202020202072657475726E2073656C663B0A202020207D3B0A0A202020202F2A2A0A20202020202A2072657365747320746865206C69627261727920';
wwv_flow_api.g_varchar2_table(304) := '6261636B20746F2069747320696E697469616C2073746174652E2020746869732069732075736566756C0A20202020202A20696620796F752077616E7420746F20636C656172206F7574207468652063757272656E74206B6579626F6172642073686F72';
wwv_flow_api.g_varchar2_table(305) := '746375747320616E642062696E640A20202020202A206E6577206F6E6573202D20666F72206578616D706C6520696620796F752073776974636820746F20616E6F7468657220706167650A20202020202A0A20202020202A204072657475726E7320766F';
wwv_flow_api.g_varchar2_table(306) := '69640A20202020202A2F0A202020204D6F757365747261702E70726F746F747970652E7265736574203D2066756E6374696F6E2829207B0A20202020202020207661722073656C66203D20746869733B0A202020202020202073656C662E5F63616C6C62';
wwv_flow_api.g_varchar2_table(307) := '61636B73203D207B7D3B0A202020202020202073656C662E5F6469726563744D6170203D207B7D3B0A202020202020202072657475726E2073656C663B0A202020207D3B0A0A202020202F2A2A0A20202020202A2073686F756C642077652073746F7020';
wwv_flow_api.g_varchar2_table(308) := '74686973206576656E74206265666F726520666972696E67206F66662063616C6C6261636B730A20202020202A0A20202020202A2040706172616D207B4576656E747D20650A20202020202A2040706172616D207B456C656D656E747D20656C656D656E';
wwv_flow_api.g_varchar2_table(309) := '740A20202020202A204072657475726E207B626F6F6C65616E7D0A20202020202A2F0A202020204D6F757365747261702E70726F746F747970652E73746F7043616C6C6261636B203D2066756E6374696F6E28652C20656C656D656E7429207B0A202020';
wwv_flow_api.g_varchar2_table(310) := '20202020207661722073656C66203D20746869733B0A0A20202020202020202F2F2069662074686520656C656D656E74206861732074686520636C61737320226D6F7573657472617022207468656E206E6F206E65656420746F2073746F700A20202020';
wwv_flow_api.g_varchar2_table(311) := '202020206966202828272027202B20656C656D656E742E636C6173734E616D65202B20272027292E696E6465784F662827206D6F75736574726170202729203E202D3129207B0A20202020202020202020202072657475726E2066616C73653B0A202020';
wwv_flow_api.g_varchar2_table(312) := '20202020207D0A0A2020202020202020696620285F62656C6F6E6773546F28656C656D656E742C2073656C662E7461726765742929207B0A20202020202020202020202072657475726E2066616C73653B0A20202020202020207D0A0A20202020202020';
wwv_flow_api.g_varchar2_table(313) := '202F2F204576656E7473206F726967696E6174696E672066726F6D206120736861646F7720444F4D206172652072652D74617267657474656420616E642060652E746172676574602069732074686520736861646F7720686F73742C0A20202020202020';
wwv_flow_api.g_varchar2_table(314) := '202F2F206E6F742074686520696E697469616C206576656E742074617267657420696E2074686520736861646F7720747265652E204E6F74652074686174206E6F7420616C6C206576656E74732063726F7373207468650A20202020202020202F2F2073';
wwv_flow_api.g_varchar2_table(315) := '6861646F7720626F756E646172792E0A20202020202020202F2F20466F7220736861646F77207472656573207769746820606D6F64653A20276F70656E27602C2074686520696E697469616C206576656E74207461726765742069732074686520666972';
wwv_flow_api.g_varchar2_table(316) := '737420656C656D656E7420696E0A20202020202020202F2F20746865206576656E74E280997320636F6D706F73656420706174682E20466F7220736861646F77207472656573207769746820606D6F64653A2027636C6F73656427602C2074686520696E';
wwv_flow_api.g_varchar2_table(317) := '697469616C206576656E740A20202020202020202F2F207461726765742063616E6E6F74206265206F627461696E65642E0A20202020202020206966202827636F6D706F736564506174682720696E206520262620747970656F6620652E636F6D706F73';
wwv_flow_api.g_varchar2_table(318) := '656450617468203D3D3D202766756E6374696F6E2729207B0A2020202020202020202020202F2F20466F72206F70656E20736861646F772074726565732C207570646174652060656C656D656E746020736F20746861742074686520666F6C6C6F77696E';
wwv_flow_api.g_varchar2_table(319) := '6720636865636B20776F726B732E0A20202020202020202020202076617220696E697469616C4576656E74546172676574203D20652E636F6D706F7365645061746828295B305D3B0A20202020202020202020202069662028696E697469616C4576656E';
wwv_flow_api.g_varchar2_table(320) := '7454617267657420213D3D20652E74617267657429207B0A20202020202020202020202020202020656C656D656E74203D20696E697469616C4576656E745461726765743B0A2020202020202020202020207D0A20202020202020207D0A0A2020202020';
wwv_flow_api.g_varchar2_table(321) := '2020202F2F2073746F7020666F7220696E7075742C2073656C6563742C20616E642074657874617265610A202020202020202072657475726E20656C656D656E742E7461674E616D65203D3D2027494E50555427207C7C20656C656D656E742E7461674E';
wwv_flow_api.g_varchar2_table(322) := '616D65203D3D202753454C45435427207C7C20656C656D656E742E7461674E616D65203D3D2027544558544152454127207C7C20656C656D656E742E6973436F6E74656E744564697461626C653B0A202020207D3B0A0A202020202F2A2A0A2020202020';
wwv_flow_api.g_varchar2_table(323) := '2A206578706F736573205F68616E646C654B6579207075626C69636C7920736F2069742063616E206265206F7665727772697474656E20627920657874656E73696F6E730A20202020202A2F0A202020204D6F757365747261702E70726F746F74797065';
wwv_flow_api.g_varchar2_table(324) := '2E68616E646C654B6579203D2066756E6374696F6E2829207B0A20202020202020207661722073656C66203D20746869733B0A202020202020202072657475726E2073656C662E5F68616E646C654B65792E6170706C792873656C662C20617267756D65';
wwv_flow_api.g_varchar2_table(325) := '6E7473293B0A202020207D3B0A0A202020202F2A2A0A20202020202A20616C6C6F7720637573746F6D206B6579206D617070696E67730A20202020202A2F0A202020204D6F757365747261702E6164644B6579636F646573203D2066756E6374696F6E28';
wwv_flow_api.g_varchar2_table(326) := '6F626A65637429207B0A2020202020202020666F722028766172206B657920696E206F626A65637429207B0A202020202020202020202020696620286F626A6563742E6861734F776E50726F7065727479286B65792929207B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(327) := '2020202020205F4D41505B6B65795D203D206F626A6563745B6B65795D3B0A2020202020202020202020207D0A20202020202020207D0A20202020202020205F524556455253455F4D4150203D206E756C6C3B0A202020207D3B0A0A202020202F2A2A0A';
wwv_flow_api.g_varchar2_table(328) := '20202020202A20496E69742074686520676C6F62616C206D6F757365747261702066756E6374696F6E730A20202020202A0A20202020202A2054686973206D6574686F64206973206E656564656420746F20616C6C6F772074686520676C6F62616C206D';
wwv_flow_api.g_varchar2_table(329) := '6F757365747261702066756E6374696F6E7320746F20776F726B0A20202020202A206E6F772074686174206D6F75736574726170206973206120636F6E7374727563746F722066756E6374696F6E2E0A20202020202A2F0A202020204D6F757365747261';
wwv_flow_api.g_varchar2_table(330) := '702E696E6974203D2066756E6374696F6E2829207B0A202020202020202076617220646F63756D656E744D6F75736574726170203D204D6F7573657472617028646F63756D656E74293B0A2020202020202020666F722028766172206D6574686F642069';
wwv_flow_api.g_varchar2_table(331) := '6E20646F63756D656E744D6F7573657472617029207B0A202020202020202020202020696620286D6574686F642E63686172417428302920213D3D20275F2729207B0A202020202020202020202020202020204D6F757365747261705B6D6574686F645D';
wwv_flow_api.g_varchar2_table(332) := '203D202866756E6374696F6E286D6574686F6429207B0A202020202020202020202020202020202020202072657475726E2066756E6374696F6E2829207B0A20202020202020202020202020202020202020202020202072657475726E20646F63756D65';
wwv_flow_api.g_varchar2_table(333) := '6E744D6F757365747261705B6D6574686F645D2E6170706C7928646F63756D656E744D6F757365747261702C20617267756D656E7473293B0A20202020202020202020202020202020202020207D3B0A202020202020202020202020202020207D20286D';
wwv_flow_api.g_varchar2_table(334) := '6574686F6429293B0A2020202020202020202020207D0A20202020202020207D0A202020207D3B0A0A202020204D6F757365747261702E696E697428293B0A0A202020202F2F206578706F7365206D6F7573657472617020746F2074686520676C6F6261';
wwv_flow_api.g_varchar2_table(335) := '6C206F626A6563740A2020202077696E646F772E4D6F75736574726170203D204D6F757365747261703B0A0A202020202F2F206578706F7365206173206120636F6D6D6F6E206A73206D6F64756C650A2020202069662028747970656F66206D6F64756C';
wwv_flow_api.g_varchar2_table(336) := '6520213D3D2027756E646566696E656427202626206D6F64756C652E6578706F72747329207B0A20202020202020206D6F64756C652E6578706F727473203D204D6F757365747261703B0A202020207D0A0A202020202F2F206578706F7365206D6F7573';
wwv_flow_api.g_varchar2_table(337) := '657472617020617320616E20414D44206D6F64756C650A2020202069662028747970656F6620646566696E65203D3D3D202766756E6374696F6E2720262620646566696E652E616D6429207B0A2020202020202020646566696E652866756E6374696F6E';
wwv_flow_api.g_varchar2_table(338) := '2829207B0A20202020202020202020202072657475726E204D6F757365747261703B0A20202020202020207D293B0A202020207D0A7D292028747970656F662077696E646F7720213D3D2027756E646566696E656427203F2077696E646F77203A206E75';
wwv_flow_api.g_varchar2_table(339) := '6C6C2C20747970656F66202077696E646F7720213D3D2027756E646566696E656427203F20646F63756D656E74203A206E756C6C293B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(4531776217582706)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_file_name=>'js/mousetrap.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '617065782E64612E6170657853706F746C696768743D7B696E69744B6579626F61726453686F7274637574733A66756E6374696F6E2874297B742E6576656E744E616D653D226B6579626F61726453686F7274637574222C617065782E64656275672E6C';
wwv_flow_api.g_varchar2_table(2) := '6F6728226170657853706F746C696768742E696E69744B6579426F61726453686F727463757473202D20704F7074696F6E73222C74293B76617220653D742E656E61626C654B6579626F61726453686F7274637574732C613D742E6B6579626F61726453';
wwv_flow_api.g_varchar2_table(3) := '686F7274637574732C693D5B5D3B2259223D3D65262628693D612E73706C697428222C22292C4D6F757365747261702E73746F7043616C6C6261636B3D66756E6374696F6E28652C742C61297B72657475726E21317D2C4D6F757365747261702E70726F';
wwv_flow_api.g_varchar2_table(4) := '746F747970652E73746F7043616C6C6261636B3D66756E6374696F6E28652C742C61297B72657475726E21317D2C4D6F757365747261702E62696E6428692C66756E6374696F6E2865297B652E70726576656E7444656661756C743F652E70726576656E';
wwv_flow_api.g_varchar2_table(5) := '7444656661756C7428293A652E72657475726E56616C75653D21312C617065782E64612E6170657853706F746C696768742E706C7567696E48616E646C65722874297D29297D2C736574486973746F727953656172636856616C75653A66756E6374696F';
wwv_flow_api.g_varchar2_table(6) := '6E2865297B2428222E6170782D53706F746C696768742D696E70757422292E76616C2865292E747269676765722822696E70757422297D2C706C7567696E48616E646C65723A66756E6374696F6E2865297B766172206D3D7B444F543A222E222C53505F';
wwv_flow_api.g_varchar2_table(7) := '4449414C4F473A226170782D53706F746C69676874222C53505F494E5055543A226170782D53706F746C696768742D696E707574222C53505F524553554C54533A226170782D53706F746C696768742D726573756C7473222C53505F4143544956453A22';
wwv_flow_api.g_varchar2_table(8) := '69732D616374697665222C53505F53484F52544355543A226170782D53706F746C696768742D73686F7274637574222C53505F414354494F4E5F53484F52544355543A2273706F746C696768742D736561726368222C53505F524553554C545F4C414245';
wwv_flow_api.g_varchar2_table(9) := '4C3A226170782D53706F746C696768742D6C6162656C222C53505F4C4956455F524547494F4E3A2273702D617269612D6D617463682D666F756E64222C53505F4C4953543A2273702D726573756C742D6C697374222C4B4559533A242E75692E6B657943';
wwv_flow_api.g_varchar2_table(10) := '6F64652C55524C5F54595045533A7B72656469726563743A227265646972656374222C736561726368506167653A227365617263682D70616765227D2C49434F4E533A7B706167653A2266612D77696E646F772D736561726368222C7365617263683A22';
wwv_flow_api.g_varchar2_table(11) := '69636F6E2D736561726368227D2C674D61784E6176526573756C743A35302C6757696474683A3635302C674861734469616C6F67437265617465643A21312C67536561726368496E6465783A5B5D2C67537461746963496E6465783A5B5D2C674B657977';
wwv_flow_api.g_varchar2_table(12) := '6F7264733A22222C67416A61784964656E7469666965723A6E756C6C2C6744796E616D6963416374696F6E49643A6E756C6C2C67506C616365686F6C646572546578743A6E756C6C2C674D6F72654368617273546578743A6E756C6C2C674E6F4D617463';
wwv_flow_api.g_varchar2_table(13) := '68546578743A6E756C6C2C674F6E654D61746368546578743A6E756C6C2C674D756C7469706C654D617463686573546578743A6E756C6C2C67496E50616765536561726368546578743A6E756C6C2C67536561726368486973746F727944656C65746554';
wwv_flow_api.g_varchar2_table(14) := '6578743A6E756C6C2C67456E61626C65496E506167655365617263683A21302C67456E61626C654461746143616368653A21312C67456E61626C6550726566696C6C53656C6563746564546578743A21312C67456E61626C65536561726368486973746F';
wwv_flow_api.g_varchar2_table(15) := '72793A21312C675375626D69744974656D7341727261793A5B5D2C67526573756C744C6973745468656D65436C6173733A22222C6749636F6E5468656D65436C6173733A22222C6753686F7750726F63657373696E673A21312C67506C616365486F6C64';
wwv_flow_api.g_varchar2_table(16) := '657249636F6E3A22612D49636F6E2069636F6E2D736561726368222C67576169745370696E6E6572243A6E756C6C2C67657453706F746C69676874446174613A66756E6374696F6E2869297B76617220653B6966286D2E67456E61626C65446174614361';
wwv_flow_api.g_varchar2_table(17) := '636865262628653D6D2E67657453706F746C696768744461746153657373696F6E53746F726167652829292969284A534F4E2E7061727365286529293B656C7365207472797B6D2E73686F77576169745370696E6E657228292C617065782E7365727665';
wwv_flow_api.g_varchar2_table(18) := '722E706C7567696E286D2E67416A61784964656E7469666965722C7B706167654974656D733A6D2E675375626D69744974656D7341727261792C7830313A224745545F44415441227D2C7B64617461547970653A226A736F6E222C737563636573733A66';
wwv_flow_api.g_varchar2_table(19) := '756E6374696F6E2865297B617065782E6576656E742E747269676765722822626F6479222C226170657873706F746C696768742D616A61782D73756363657373222C65292C617065782E64656275672E6C6F6728226170657853706F746C696768742E67';
wwv_flow_api.g_varchar2_table(20) := '657453706F746C696768744461746120414A41582053756363657373222C65292C6D2E67456E61626C6544617461436163686526266D2E73657453706F746C696768744461746153657373696F6E53746F72616765284A534F4E2E737472696E67696679';
wwv_flow_api.g_varchar2_table(21) := '286529292C6D2E68696465576169745370696E6E657228292C692865297D2C6572726F723A66756E6374696F6E28652C742C61297B617065782E6576656E742E747269676765722822626F6479222C226170657873706F746C696768742D616A61782D65';
wwv_flow_api.g_varchar2_table(22) := '72726F72222C7B6D6573736167653A617D292C617065782E64656275672E6C6F6728226170657853706F746C696768742E67657453706F746C696768744461746120414A4158204572726F72222C61292C6D2E68696465576169745370696E6E65722829';
wwv_flow_api.g_varchar2_table(23) := '2C69285B5D297D7D297D63617463682865297B617065782E6576656E742E747269676765722822626F6479222C226170657873706F746C696768742D616A61782D6572726F72222C7B6D6573736167653A657D292C617065782E64656275672E6C6F6728';
wwv_flow_api.g_varchar2_table(24) := '226170657853706F746C696768742E67657453706F746C696768744461746120414A4158204572726F72222C65292C6D2E68696465576169745370696E6E657228292C69285B5D297D7D2C67657450726F7065724170657855726C3A66756E6374696F6E';
wwv_flow_api.g_varchar2_table(25) := '28692C6F297B7472797B617065782E7365727665722E706C7567696E286D2E67416A61784964656E7469666965722C7B7830313A224745545F55524C222C7830323A6D2E674B6579776F7264732C7830333A697D2C7B64617461547970653A226A736F6E';
wwv_flow_api.g_varchar2_table(26) := '222C737563636573733A66756E6374696F6E2865297B617065782E64656275672E6C6F6728226170657853706F746C696768742E67657450726F7065724170657855726C20414A41582053756363657373222C65292C6F2865297D2C6572726F723A6675';
wwv_flow_api.g_varchar2_table(27) := '6E6374696F6E28652C742C61297B617065782E64656275672E6C6F6728226170657853706F746C696768742E67657450726F7065724170657855726C20414A4158204572726F72222C61292C6F287B75726C3A697D297D7D297D63617463682865297B61';
wwv_flow_api.g_varchar2_table(28) := '7065782E64656275672E6C6F6728226170657853706F746C696768742E67657450726F7065724170657855726C20414A4158204572726F72222C65292C6F287B75726C3A697D297D7D2C73657453706F746C696768744461746153657373696F6E53746F';
wwv_flow_api.g_varchar2_table(29) := '726167653A66756E6374696F6E2865297B696628617065782E73746F726167652E68617353657373696F6E53746F72616765537570706F72742829297B76617220743D2476282270496E7374616E636522293B617065782E73746F726167652E67657453';
wwv_flow_api.g_varchar2_table(30) := '636F70656453657373696F6E53746F72616765287B7072656669783A226170657853706F746C69676874222C75736541707049643A21307D292E7365744974656D28742B222E222B6D2E6744796E616D6963416374696F6E49642B222E64617461222C65';
wwv_flow_api.g_varchar2_table(31) := '297D7D2C67657453706F746C696768744461746153657373696F6E53746F726167653A66756E6374696F6E28297B76617220653B696628617065782E73746F726167652E68617353657373696F6E53746F72616765537570706F72742829297B76617220';
wwv_flow_api.g_varchar2_table(32) := '743D2476282270496E7374616E636522293B653D617065782E73746F726167652E67657453636F70656453657373696F6E53746F72616765287B7072656669783A226170657853706F746C69676874222C75736541707049643A21307D292E6765744974';
wwv_flow_api.g_varchar2_table(33) := '656D28742B222E222B6D2E6744796E616D6963416374696F6E49642B222E6461746122297D72657475726E20657D2C73657453706F746C69676874486973746F72794C6F63616C53746F726167653A66756E6374696F6E2865297B76617220742C613D61';
wwv_flow_api.g_varchar2_table(34) := '7065782E73746F726167652E6861734C6F63616C53746F72616765537570706F727428292C693D5B5D3B69734E614E28652926262828693D6D2E67657453706F746C69676874486973746F72794C6F63616C53746F726167652829292E756E7368696674';
wwv_flow_api.g_varchar2_table(35) := '28652E7472696D2829292C743D7B7D2C692E666F72456163682866756E6374696F6E2865297B745B655D7C7C28745B655D3D2130297D292C693D66756E6374696F6E2865297B666F722876617220743D303B743C652E6C656E6774683B742B2B2933303C';
wwv_flow_api.g_varchar2_table(36) := '742626652E73706C69636528742C31293B72657475726E20657D28693D4F626A6563742E6B657973287429292C612626617065782E73746F726167652E67657453636F7065644C6F63616C53746F72616765287B7072656669783A226170657853706F74';
wwv_flow_api.g_varchar2_table(37) := '6C69676874222C75736541707049643A21307D292E7365744974656D286D2E6744796E616D6963416374696F6E49642B222E686973746F7279222C4A534F4E2E737472696E6769667928692929297D2C67657453706F746C69676874486973746F72794C';
wwv_flow_api.g_varchar2_table(38) := '6F63616C53746F726167653A66756E6374696F6E28297B76617220652C743D5B5D3B617065782E73746F726167652E6861734C6F63616C53746F72616765537570706F7274282926262828653D617065782E73746F726167652E67657453636F7065644C';
wwv_flow_api.g_varchar2_table(39) := '6F63616C53746F72616765287B7072656669783A226170657853706F746C69676874222C75736541707049643A21307D292E6765744974656D286D2E6744796E616D6963416374696F6E49642B222E686973746F7279222929262628743D4A534F4E2E70';
wwv_flow_api.g_varchar2_table(40) := '6172736528652929293B72657475726E20747D2C72656D6F766553706F746C69676874486973746F72794C6F63616C53746F726167653A66756E6374696F6E28297B617065782E73746F726167652E6861734C6F63616C53746F72616765537570706F72';
wwv_flow_api.g_varchar2_table(41) := '7428292626617065782E73746F726167652E67657453636F7065644C6F63616C53746F72616765287B7072656669783A226170657853706F746C69676874222C75736541707049643A21307D292E72656D6F76654974656D286D2E6744796E616D696341';
wwv_flow_api.g_varchar2_table(42) := '6374696F6E49642B222E686973746F727922297D2C73686F775469707079486973746F7279506F706F7665723A66756E6374696F6E28297B76617220653D6D2E67657453706F746C69676874486973746F72794C6F63616C53746F7261676528297C7C5B';
wwv_flow_api.g_varchar2_table(43) := '5D2C743D22222C613D303B696628303C652E6C656E677468297B6D2E64657374726F795469707079486973746F7279506F706F76657228292C2428226469762E6170782D53706F746C696768742D69636F6E2D6D61696E22292E6373732822637572736F';
wwv_flow_api.g_varchar2_table(44) := '72222C22706F696E74657222292C742B3D273C756C20636C6173733D2273706F746C696768742D686973746F72792D6C697374223E273B666F722876617220693D303B693C652E6C656E677468262628742B3D273C6C693E3C6120636C6173733D227370';
wwv_flow_api.g_varchar2_table(45) := '6F746C696768742D686973746F72792D6C696E6B2220687265663D226A6176617363726970743A617065782E64612E6170657853706F746C696768742E736574486973746F727953656172636856616C7565285C27272B617065782E7574696C2E657363';
wwv_flow_api.g_varchar2_table(46) := '61706548544D4C28655B695D292B2227293B5C223E222B617065782E7574696C2E65736361706548544D4C28655B695D292B223C2F613E3C2F6C693E222C212832303C3D28612B3D312929293B692B2B293B742B3D273C6C693E3C6120636C6173733D22';
wwv_flow_api.g_varchar2_table(47) := '73706F746C696768742D686973746F72792D64656C6574652220687265663D226A6176617363726970743A766F69642830293B223E3C693E272B6D2E67536561726368486973746F727944656C657465546578742B223C2F693E3C2F613E3C2F6C693E22';
wwv_flow_api.g_varchar2_table(48) := '2C742B3D223C2F756C3E222C7469707079282428226469762E6170782D53706F746C696768742D69636F6E2D6D61696E22295B305D2C7B636F6E74656E743A742C696E7465726163746976653A21302C6172726F773A21302C706C6163656D656E743A22';
wwv_flow_api.g_varchar2_table(49) := '72696768742D656E64222C616E696D61746546696C6C3A21317D292C242822626F647922292E6F6E2822636C69636B222C22612E73706F746C696768742D686973746F72792D6C696E6B222C66756E6374696F6E28297B6D2E6869646554697070794869';
wwv_flow_api.g_varchar2_table(50) := '73746F7279506F706F76657228297D292C242822626F647922292E6F6E2822636C69636B222C22612E73706F746C696768742D686973746F72792D64656C657465222C66756E6374696F6E28297B6D2E64657374726F795469707079486973746F727950';
wwv_flow_api.g_varchar2_table(51) := '6F706F76657228292C6D2E72656D6F766553706F746C69676874486973746F72794C6F63616C53746F7261676528297D297D7D2C686964655469707079486973746F7279506F706F7665723A66756E6374696F6E28297B76617220653D2428226469762E';
wwv_flow_api.g_varchar2_table(52) := '6170782D53706F746C696768742D69636F6E2D6D61696E22295B305D3B652626652E5F74697070792626652E5F74697070792E6869646528297D2C64657374726F795469707079486973746F7279506F706F7665723A66756E6374696F6E28297B766172';
wwv_flow_api.g_varchar2_table(53) := '20653D2428226469762E6170782D53706F746C696768742D69636F6E2D6D61696E22295B305D3B652626652E5F74697070792626652E5F74697070792E64657374726F7928292C24286D2E444F542B6D2E53505F494E505554292E666F63757328297D2C';
wwv_flow_api.g_varchar2_table(54) := '73686F77576169745370696E6E65723A66756E6374696F6E28297B6D2E6753686F7750726F63657373696E6726262428226469762E6170782D53706F746C696768742D69636F6E2D6D61696E207370616E22292E72656D6F7665436C61737328292E6164';
wwv_flow_api.g_varchar2_table(55) := '64436C617373282266612066612D726566726573682066612D616E696D2D7370696E22297D2C68696465576169745370696E6E65723A66756E6374696F6E28297B6D2E6753686F7750726F63657373696E6726262428226469762E6170782D53706F746C';
wwv_flow_api.g_varchar2_table(56) := '696768742D69636F6E2D6D61696E207370616E22292E72656D6F7665436C61737328292E616464436C617373286D2E67506C616365486F6C64657249636F6E297D2C67657453656C6563746564546578743A66756E6374696F6E28297B72657475726E20';
wwv_flow_api.g_varchar2_table(57) := '77696E646F772E67657453656C656374696F6E3F77696E646F772E67657453656C656374696F6E28292E746F537472696E6728292E7472696D28293A646F63756D656E742E73656C656374696F6E2E63726561746552616E67653F646F63756D656E742E';
wwv_flow_api.g_varchar2_table(58) := '73656C656374696F6E2E63726561746552616E676528292E746578742E7472696D28293A766F696420307D2C73657453656C6563746564546578743A66756E6374696F6E28297B76617220653D6D2E67657453656C65637465645465787428293B652626';
wwv_flow_api.g_varchar2_table(59) := '286D2E674861734469616C6F67437265617465643F24286D2E444F542B6D2E53505F494E505554292E76616C2865292E747269676765722822696E70757422293A242822626F647922292E6F6E28226170657873706F746C696768742D6765742D646174';
wwv_flow_api.g_varchar2_table(60) := '61222C66756E6374696F6E28297B24286D2E444F542B6D2E53505F494E505554292E76616C2865292E747269676765722822696E70757422297D29297D2C72656469726563743A66756E6374696F6E2874297B6966286D2E6753686F7750726F63657373';
wwv_flow_api.g_varchar2_table(61) := '696E67297472797B742E7374617274735769746828226A6176617363726970743A22297C7C303D3D2428227370616E2E752D50726F63657373696E6722292E6C656E6774682626742E737461727473576974682822663F703D22292626617065782E7061';
wwv_flow_api.g_varchar2_table(62) := '67652E76616C69646174652829262621617065782E706167652E69734368616E67656428292626286D2E67576169745370696E6E6572243D617065782E7574696C2E73686F775370696E6E657228242822626F6479222929292C617065782E6E61766967';
wwv_flow_api.g_varchar2_table(63) := '6174696F6E2E72656469726563742874297D63617463682865297B6D2E67576169745370696E6E65722426266D2E67576169745370696E6E6572242E72656D6F766528292C617065782E6E617669676174696F6E2E72656469726563742874297D656C73';
wwv_flow_api.g_varchar2_table(64) := '6520617065782E6E617669676174696F6E2E72656469726563742874297D2C68616E646C6541726961417474723A66756E6374696F6E28297B76617220653D24286D2E444F542B6D2E53505F524553554C5453292C743D24286D2E444F542B6D2E53505F';
wwv_flow_api.g_varchar2_table(65) := '494E505554292C613D652E66696E64286D2E444F542B6D2E53505F414354495645292E66696E64286D2E444F542B6D2E53505F524553554C545F4C4142454C292E617474722822696422292C693D24282223222B61292C6F3D692E7465787428292C723D';
wwv_flow_api.g_varchar2_table(66) := '652E66696E6428226C6922292C6E3D30213D3D722E6C656E6774682C6C3D22222C733D722E66696C7465722866756E6374696F6E28297B72657475726E20303D3D3D242874686973292E66696E64286D2E444F542B6D2E53505F53484F5254435554292E';
wwv_flow_api.g_varchar2_table(67) := '6C656E6774687D292E6C656E6774683B24286D2E444F542B6D2E53505F524553554C545F4C4142454C292E617474722822617269612D73656C6563746564222C2266616C736522292C692E617474722822617269612D73656C6563746564222C22747275';
wwv_flow_api.g_varchar2_table(68) := '6522292C22223D3D3D6D2E674B6579776F7264733F6C3D6D2E674D6F72654368617273546578743A303D3D3D733F6C3D6D2E674E6F4D61746368546578743A313D3D3D733F6C3D6D2E674F6E654D61746368546578743A313C732626286C3D732B222022';
wwv_flow_api.g_varchar2_table(69) := '2B6D2E674D756C7469706C654D61746368657354657874292C6C3D6F2B222C20222B6C2C24282223222B6D2E53505F4C4956455F524547494F4E292E74657874286C292C742E617474722822617269612D61637469766564657363656E64616E74222C61';
wwv_flow_api.g_varchar2_table(70) := '292E617474722822617269612D657870616E646564222C6E297D2C636C6F73654469616C6F673A66756E6374696F6E28297B24286D2E444F542B6D2E53505F4449414C4F47292E6469616C6F672822636C6F736522297D2C726573657453706F746C6967';
wwv_flow_api.g_varchar2_table(71) := '68743A66756E6374696F6E28297B24282223222B6D2E53505F4C495354292E656D70747928292C24286D2E444F542B6D2E53505F494E505554292E76616C282222292E666F63757328292C6D2E674B6579776F7264733D22222C6D2E68616E646C654172';
wwv_flow_api.g_varchar2_table(72) := '69614174747228297D2C676F546F3A66756E6374696F6E28652C74297B76617220613D652E64617461282275726C22293B73776974636828652E646174612822747970652229297B63617365206D2E55524C5F54595045532E736561726368506167653A';
wwv_flow_api.g_varchar2_table(73) := '6D2E696E5061676553656172636828293B627265616B3B63617365206D2E55524C5F54595045532E72656469726563743A612E696E636C7564657328227E5345415243485F56414C55457E22293F286D2E674B6579776F7264733D6D2E674B6579776F72';
wwv_flow_api.g_varchar2_table(74) := '64732E7265706C616365282F3A7C2C7C227C272F672C222022292E7472696D28292C612E737461727473576974682822663F703D22293F6D2E67657450726F7065724170657855726C28612C66756E6374696F6E2865297B6D2E72656469726563742865';
wwv_flow_api.g_varchar2_table(75) := '2E75726C297D293A28613D612E7265706C61636528227E5345415243485F56414C55457E222C6D2E674B6579776F726473292C6D2E726564697265637428612929293A6D2E72656469726563742861297D6D2E636C6F73654469616C6F6728297D2C6765';
wwv_flow_api.g_varchar2_table(76) := '744D61726B75703A66756E6374696F6E2865297B76617220743D652E7469746C652C613D652E646573637C7C22222C693D652E75726C2C6F3D652E747970652C723D652E69636F6E2C6E3D652E69636F6E436F6C6F722C6C3D652E73686F72746375742C';
wwv_flow_api.g_varchar2_table(77) := '733D652E7374617469632C673D6C3F273C7370616E20636C6173733D22272B6D2E53505F53484F52544355542B2722203E272B6C2B223C2F7370616E3E223A22222C703D22222C633D22222C643D22222C683D22223B72657475726E28303D3D3D697C7C';
wwv_flow_api.g_varchar2_table(78) := '6929262628703D27646174612D75726C3D22272B692B27222027292C6F262628703D702B2720646174612D747970653D22272B6F2B27222027292C633D722E73746172747357697468282266612D22293F22666120222B723A722E737461727473576974';
wwv_flow_api.g_varchar2_table(79) := '68282269636F6E2D22293F22612D49636F6E20222B723A22612D49636F6E2069636F6E2D736561726368222C643D733F22535441544943223A2244594E414D4943222C6E262628683D277374796C653D226261636B67726F756E642D636F6C6F723A272B';
wwv_flow_api.g_varchar2_table(80) := '6E2B272227292C273C6C6920636C6173733D226170782D53706F746C696768742D726573756C7420272B6D2E67526573756C744C6973745468656D65436C6173732B22206170782D53706F746C696768742D726573756C742D2D70616765206170782D53';
wwv_flow_api.g_varchar2_table(81) := '706F746C696768742D222B642B27223E3C7370616E20636C6173733D226170782D53706F746C696768742D6C696E6B2220272B702B273E3C7370616E20636C6173733D226170782D53706F746C696768742D69636F6E20272B6D2E6749636F6E5468656D';
wwv_flow_api.g_varchar2_table(82) := '65436C6173732B272220272B682B2720617269612D68696464656E3D2274727565223E3C7370616E20636C6173733D22272B632B27223E3C2F7370616E3E3C2F7370616E3E3C7370616E20636C6173733D226170782D53706F746C696768742D696E666F';
wwv_flow_api.g_varchar2_table(83) := '223E3C7370616E20636C6173733D22272B6D2E53505F524553554C545F4C4142454C2B272220726F6C653D226F7074696F6E223E272B742B273C2F7370616E3E3C7370616E20636C6173733D226170782D53706F746C696768742D64657363223E272B61';
wwv_flow_api.g_varchar2_table(84) := '2B223C2F7370616E3E3C2F7370616E3E222B672B223C2F7370616E3E3C2F6C693E227D2C726573756C74734164644F6E733A66756E6374696F6E2865297B76617220743D303B6D2E67456E61626C65496E50616765536561726368262628652E70757368';
wwv_flow_api.g_varchar2_table(85) := '287B6E3A6D2E67496E50616765536561726368546578742C753A22222C693A6D2E49434F4E532E706167652C69633A6E756C6C2C743A6D2E55524C5F54595045532E736561726368506167652C73686F72746375743A224374726C202B2031222C733A21';
wwv_flow_api.g_varchar2_table(86) := '307D292C742B3D31293B666F722876617220613D303B613C6D2E67537461746963496E6465782E6C656E6774683B612B2B29393C28742B3D31293F652E70757368287B6E3A6D2E67537461746963496E6465785B615D2E6E2C643A6D2E67537461746963';
wwv_flow_api.g_varchar2_table(87) := '496E6465785B615D2E642C753A6D2E67537461746963496E6465785B615D2E752C693A6D2E67537461746963496E6465785B615D2E692C69633A6D2E67537461746963496E6465785B615D2E69632C743A6D2E67537461746963496E6465785B615D2E74';
wwv_flow_api.g_varchar2_table(88) := '2C733A6D2E67537461746963496E6465785B615D2E737D293A652E70757368287B6E3A6D2E67537461746963496E6465785B615D2E6E2C643A6D2E67537461746963496E6465785B615D2E642C753A6D2E67537461746963496E6465785B615D2E752C69';
wwv_flow_api.g_varchar2_table(89) := '3A6D2E67537461746963496E6465785B615D2E692C69633A6D2E67537461746963496E6465785B615D2E69632C743A6D2E67537461746963496E6465785B615D2E742C733A6D2E67537461746963496E6465785B615D2E732C73686F72746375743A2243';
wwv_flow_api.g_varchar2_table(90) := '74726C202B20222B747D293B72657475726E20657D2C7365617263684E61763A66756E6374696F6E2865297B76617220632C742C613D5B5D2C693D21312C643D652E6C656E6774683B666F7228743D303B743C652E6C656E6774683B742B2B29633D655B';
wwv_flow_api.g_varchar2_table(91) := '745D2C613D28693F613A6D2E67536561726368496E646578292E66696C7465722866756E6374696F6E28652C74297B76617220612C692C6F2C722C6E2C6C2C733D652E6E2E746F4C6F7765724361736528292C673D732E73706C697428222022292E6C65';
wwv_flow_api.g_varchar2_table(92) := '6E6774682C703D732E7365617263682863293B72657475726E2128673C64292626282D313C703F28652E73636F72653D286F3D732C6E3D3130302C6C3D28693D67292D312C303D3D3D28613D70292626303D3D3D6C7C7C282D313D3D3D28723D6F2E696E';
wwv_flow_api.g_varchar2_table(93) := '6465784F66286D2E674B6579776F72647329293F6E3D6E2D612D6C2D693A6E2D3D72292C6E292C2130293A652E7426262D313C652E742E7365617263682863293F28652E73636F72653D312C2130293A766F69642030297D292E736F72742866756E6374';
wwv_flow_api.g_varchar2_table(94) := '696F6E28652C74297B72657475726E20742E73636F72652D652E73636F72657D292C693D21303B72657475726E2066756E6374696F6E2865297B76617220742C612C692C6F2C722C6E2C6C2C733D22222C673D7B7D3B666F7228652E6C656E6774683E6D';
wwv_flow_api.g_varchar2_table(95) := '2E674D61784E6176526573756C74262628652E6C656E6774683D6D2E674D61784E6176526573756C74292C743D303B743C652E6C656E6774683B742B2B296F3D28613D655B745D292E73686F72746375742C693D612E747C7C6D2E55524C5F5459504553';
wwv_flow_api.g_varchar2_table(96) := '2E72656469726563742C723D612E697C7C6D2E49434F4E532E7365617263682C6C3D612E737C7C21312C2244454641554C5422213D3D612E69632626286E3D612E6963292C673D7B7469746C653A612E6E2C646573633A612E642C75726C3A612E752C69';
wwv_flow_api.g_varchar2_table(97) := '636F6E3A722C69636F6E436F6C6F723A6E2C747970653A692C7374617469633A6C7D2C6F262628672E73686F72746375743D6F292C732B3D6D2E6765744D61726B75702867293B72657475726E20737D286D2E726573756C74734164644F6E7328612929';
wwv_flow_api.g_varchar2_table(98) := '7D2C7365617263683A66756E6374696F6E2865297B6D2E674B6579776F7264733D652E7472696D28293B76617220742C612C693D6D2E674B6579776F7264732E73706C697428222022292C6F3D2824286D2E444F542B6D2E53505F524553554C5453292C';
wwv_flow_api.g_varchar2_table(99) := '5B5D293B666F7228613D303B613C692E6C656E6774683B612B2B296F2E70757368286E65772052656745787028617065782E7574696C2E65736361706552656745787028695B615D292C2267692229293B743D6D2E7365617263684E6176286F292C2428';
wwv_flow_api.g_varchar2_table(100) := '2223222B6D2E53505F4C495354292E68746D6C2874292E66696E6428226C6922292E656163682866756E6374696F6E2865297B242874686973292E66696E64286D2E444F542B6D2E53505F524553554C545F4C4142454C292E6174747228226964222C22';
wwv_flow_api.g_varchar2_table(101) := '73702D726573756C742D222B65297D292E666972737428292E616464436C617373286D2E53505F414354495645297D2C63726561746553706F746C696768744469616C6F673A66756E6374696F6E2865297B76617220692C6F2C722C6E2C6C2C732C673B';
wwv_flow_api.g_varchar2_table(102) := '6C3D66756E6374696F6E28297B696628303C24286D2E444F542B6D2E53505F4449414C4F47292E6C656E677468297B76617220653D2428226469762E6170782D53706F746C696768742D726573756C747322293B693D652E6F7574657248656967687428';
wwv_flow_api.g_varchar2_table(103) := '292C6F3D2428226C692E6170782D53706F746C696768742D726573756C7422292E6F7574657248656967687428292C723D652E6F666673657428292E746F702C6E3D692F6F7D7D2C733D66756E6374696F6E2865297B76617220743D652E66696E64286D';
wwv_flow_api.g_varchar2_table(104) := '2E444F542B6D2E53505F414354495645292C613D742E696E64657828293B6E7C7C6C28292C21742E6C656E6774687C7C742E697328223A6C6173742D6368696C6422293F28742E72656D6F7665436C617373286D2E53505F414354495645292C652E6669';
wwv_flow_api.g_varchar2_table(105) := '6E6428226C6922292E666972737428292E616464436C617373286D2E53505F414354495645292C652E616E696D617465287B7363726F6C6C546F703A307D29293A66756E6374696F6E2865297B696628655B305D297B76617220743D652E6F6666736574';
wwv_flow_api.g_varchar2_table(106) := '28292E746F703B72657475726E20743C307C7C693C747D7D28742E72656D6F7665436C617373286D2E53505F414354495645292E6E65787428292E616464436C617373286D2E53505F41435449564529292626652E616E696D617465287B7363726F6C6C';
wwv_flow_api.g_varchar2_table(107) := '546F703A28612D6E2B32292A6F7D2C30297D2C673D66756E6374696F6E2865297B76617220743D652E66696E64286D2E444F542B6D2E53505F414354495645292C613D742E696E64657828293B6E7C7C6C28292C21652E6C656E6774687C7C742E697328';
wwv_flow_api.g_varchar2_table(108) := '223A66697273742D6368696C6422293F28742E72656D6F7665436C617373286D2E53505F414354495645292C652E66696E6428226C6922292E6C61737428292E616464436C617373286D2E53505F414354495645292C652E616E696D617465287B736372';
wwv_flow_api.g_varchar2_table(109) := '6F6C6C546F703A652E66696E6428226C6922292E6C656E6774682A6F7D29293A66756E6374696F6E2865297B696628655B305D297B76617220743D652E6F666673657428292E746F703B72657475726E20693C747C7C743C3D727D7D28742E72656D6F76';
wwv_flow_api.g_varchar2_table(110) := '65436C617373286D2E53505F414354495645292E7072657628292E616464436C617373286D2E53505F41435449564529292626652E616E696D617465287B7363726F6C6C546F703A28612D31292A6F7D2C30297D2C242877696E646F77292E6F6E282261';
wwv_flow_api.g_varchar2_table(111) := '70657877696E646F77726573697A6564222C66756E6374696F6E28297B6C28297D292C242822626F647922292E617070656E6428273C64697620636C6173733D22272B6D2E53505F4449414C4F472B272220646174612D69643D22272B6D2E6744796E61';
wwv_flow_api.g_varchar2_table(112) := '6D6963416374696F6E49642B27223E3C64697620636C6173733D226170782D53706F746C696768742D626F6479223E3C64697620636C6173733D226170782D53706F746C696768742D736561726368223E3C64697620636C6173733D226170782D53706F';
wwv_flow_api.g_varchar2_table(113) := '746C696768742D69636F6E206170782D53706F746C696768742D69636F6E2D6D61696E223E3C7370616E20636C6173733D22272B6D2E67506C616365486F6C64657249636F6E2B272220617269612D68696464656E3D2274727565223E3C2F7370616E3E';
wwv_flow_api.g_varchar2_table(114) := '3C2F6469763E3C64697620636C6173733D226170782D53706F746C696768742D6669656C64223E3C696E70757420747970653D22746578742220726F6C653D22636F6D626F626F782220617269612D657870616E6465643D2266616C7365222061726961';
wwv_flow_api.g_varchar2_table(115) := '2D6175746F636F6D706C6574653D226E6F6E652220617269612D686173706F7075703D22747275652220617269612D6C6162656C3D2253706F746C69676874205365617263682220617269612D6F776E733D22272B6D2E53505F4C4953542B2722206175';
wwv_flow_api.g_varchar2_table(116) := '746F636F6D706C6574653D226F666622206175746F636F72726563743D226F666622207370656C6C636865636B3D2266616C73652220636C6173733D22272B6D2E53505F494E5055542B272220706C616365686F6C6465723D22272B652B27223E3C2F64';
wwv_flow_api.g_varchar2_table(117) := '69763E3C64697620726F6C653D22726567696F6E2220636C6173733D22752D56697375616C6C7948696464656E2220617269612D6C6976653D22706F6C697465222069643D22272B6D2E53505F4C4956455F524547494F4E2B27223E3C2F6469763E3C2F';
wwv_flow_api.g_varchar2_table(118) := '6469763E3C64697620636C6173733D22272B6D2E53505F524553554C54532B27223E3C756C20636C6173733D226170782D53706F746C696768742D726573756C74734C697374222069643D22272B6D2E53505F4C4953542B272220746162696E6465783D';
wwv_flow_api.g_varchar2_table(119) := '222D312220726F6C653D226C697374626F78223E3C2F756C3E3C2F6469763E3C2F6469763E3C2F6469763E27292E6F6E2822696E707574222C6D2E444F542B6D2E53505F494E5055542C66756E6374696F6E28297B76617220653D242874686973292E76';
wwv_flow_api.g_varchar2_table(120) := '616C28292E7472696D28292C743D652E6C656E6774683B303D3D3D743F6D2E726573657453706F746C6967687428293A28313C747C7C2169734E614E28652929262665213D3D6D2E674B6579776F72647326266D2E7365617263682865297D292E6F6E28';
wwv_flow_api.g_varchar2_table(121) := '226B6579646F776E222C6D2E444F542B6D2E53505F4449414C4F472C66756E6374696F6E2865297B76617220742C612C693D24286D2E444F542B6D2E53505F524553554C5453293B73776974636828652E7768696368297B63617365206D2E4B4559532E';
wwv_flow_api.g_varchar2_table(122) := '444F574E3A652E70726576656E7444656661756C7428292C732869293B627265616B3B63617365206D2E4B4559532E55503A652E70726576656E7444656661756C7428292C672869293B627265616B3B63617365206D2E4B4559532E454E5445523A652E';
wwv_flow_api.g_varchar2_table(123) := '70726576656E7444656661756C7428292C6D2E67456E61626C65536561726368486973746F727926266D2E73657453706F746C69676874486973746F72794C6F63616C53746F726167652824286D2E444F542B6D2E53505F494E505554292E76616C2829';
wwv_flow_api.g_varchar2_table(124) := '292C6D2E676F546F28692E66696E6428226C692E69732D616374697665207370616E22292C65293B627265616B3B63617365206D2E4B4559532E5441423A6D2E636C6F73654469616C6F6728297D696628652E6374726C4B6579297B7377697463682874';
wwv_flow_api.g_varchar2_table(125) := '3D692E66696E64286D2E444F542B6D2E53505F53484F5254435554292E706172656E7428292E67657428292C652E7768696368297B636173652034393A613D313B627265616B3B636173652035303A613D323B627265616B3B636173652035313A613D33';
wwv_flow_api.g_varchar2_table(126) := '3B627265616B3B636173652035323A613D343B627265616B3B636173652035333A613D353B627265616B3B636173652035343A613D363B627265616B3B636173652035353A613D373B627265616B3B636173652035363A613D383B627265616B3B636173';
wwv_flow_api.g_varchar2_table(127) := '652035373A613D397D6126266D2E676F546F282428745B612D315D292C65297D652E73686966744B65792626652E77686963683D3D3D6D2E4B4559532E54414226266D2E636C6F73654469616C6F6728292C6D2E68616E646C6541726961417474722829';
wwv_flow_api.g_varchar2_table(128) := '7D292E6F6E2822636C69636B222C227370616E2E6170782D53706F746C696768742D6C696E6B222C66756E6374696F6E2865297B6D2E67456E61626C65536561726368486973746F727926266D2E73657453706F746C69676874486973746F72794C6F63';
wwv_flow_api.g_varchar2_table(129) := '616C53746F726167652824286D2E444F542B6D2E53505F494E505554292E76616C2829292C6D2E676F546F28242874686973292C65297D292E6F6E28226D6F7573656D6F7665222C226C692E6170782D53706F746C696768742D726573756C74222C6675';
wwv_flow_api.g_varchar2_table(130) := '6E6374696F6E28297B76617220653D242874686973293B652E706172656E7428292E66696E64286D2E444F542B6D2E53505F414354495645292E72656D6F7665436C617373286D2E53505F414354495645292C652E616464436C617373286D2E53505F41';
wwv_flow_api.g_varchar2_table(131) := '4354495645297D292E6F6E2822626C7572222C6D2E444F542B6D2E53505F4449414C4F472C66756E6374696F6E2865297B24286D2E444F542B6D2E53505F4449414C4F47292E6469616C6F67282269734F70656E2229262624286D2E444F542B6D2E5350';
wwv_flow_api.g_varchar2_table(132) := '5F494E505554292E666F63757328297D292C24286D2E444F542B6D2E53505F4449414C4F47292E6F6E28226B6579646F776E222C66756E6374696F6E2865297B76617220743D24286D2E444F542B6D2E53505F494E505554293B652E77686963683D3D3D';
wwv_flow_api.g_varchar2_table(133) := '6D2E4B4559532E455343415045262628742E76616C28293F286D2E726573657453706F746C6967687428292C652E73746F7050726F7061676174696F6E2829293A6D2E636C6F73654469616C6F672829297D292C6D2E674861734469616C6F6743726561';
wwv_flow_api.g_varchar2_table(134) := '7465643D21307D2C6F70656E53706F746C696768744469616C6F673A66756E6374696F6E2865297B69662877696E646F772E73656C66213D3D77696E646F772E746F702972657475726E21313B6D2E674861734469616C6F67437265617465643D303C24';
wwv_flow_api.g_varchar2_table(135) := '286D2E444F542B6D2E53505F4449414C4F47292E6C656E6774682C6D2E674861734469616C6F6743726561746564262624286D2E444F542B6D2E53505F4449414C4F47292E617474722822646174612D69642229213D6D2E6744796E616D696341637469';
wwv_flow_api.g_varchar2_table(136) := '6F6E49642626286D2E726573657453706F746C6967687428292C24286D2E444F542B6D2E53505F4449414C4F47292E72656D6F766528292C6D2E674861734469616C6F67437265617465643D2131292C6D2E67456E61626C6550726566696C6C53656C65';
wwv_flow_api.g_varchar2_table(137) := '637465645465787426266D2E73657453656C65637465645465787428293B76617220743D66756E6374696F6E28297B76617220653D24286D2E444F542B6D2E53505F4449414C4F47292C743D77696E646F772E7363726F6C6C597C7C77696E646F772E70';
wwv_flow_api.g_varchar2_table(138) := '616765594F66667365743B652E686173436C617373282275692D6469616C6F672D636F6E74656E7422292626652E6469616C6F67282269734F70656E22297C7C652E6469616C6F67287B77696474683A6D2E6757696474682C6865696768743A22617574';
wwv_flow_api.g_varchar2_table(139) := '6F222C6D6F64616C3A21302C706F736974696F6E3A7B6D793A2263656E74657220746F70222C61743A2263656E74657220746F702B222B28742B3634292C6F663A242822626F647922297D2C6469616C6F67436C6173733A2275692D6469616C6F672D2D';
wwv_flow_api.g_varchar2_table(140) := '6170657873706F746C69676874222C6F70656E3A66756E6374696F6E28297B617065782E6576656E742E747269676765722822626F6479222C226170657873706F746C696768742D6F70656E2D6469616C6F6722292C242874686973292E63737328226D';
wwv_flow_api.g_varchar2_table(141) := '696E2D686569676874222C226175746F22292E7072657628222E75692D6469616C6F672D7469746C6562617222292E72656D6F766528292C617065782E6E617669676174696F6E2E626567696E467265657A655363726F6C6C28292C6D2E67456E61626C';
wwv_flow_api.g_varchar2_table(142) := '65536561726368486973746F727926266D2E73686F775469707079486973746F7279506F706F76657228292C2428222E75692D7769646765742D6F7665726C617922292E6F6E2822636C69636B222C66756E6374696F6E28297B6D2E636C6F7365446961';
wwv_flow_api.g_varchar2_table(143) := '6C6F6728297D297D2C636C6F73653A66756E6374696F6E28297B617065782E6576656E742E747269676765722822626F6479222C226170657873706F746C696768742D636C6F73652D6469616C6F6722292C6D2E726573657453706F746C696768742829';
wwv_flow_api.g_varchar2_table(144) := '2C617065782E6E617669676174696F6E2E656E64467265657A655363726F6C6C28292C6D2E67456E61626C65536561726368486973746F727926266D2E64657374726F795469707079486973746F7279506F706F76657228297D7D297D3B6D2E67486173';
wwv_flow_api.g_varchar2_table(145) := '4469616C6F67437265617465643F7428293A286D2E63726561746553706F746C696768744469616C6F67286D2E67506C616365686F6C64657254657874292C7428292C6D2E67657453706F746C69676874446174612866756E6374696F6E2865297B6D2E';
wwv_flow_api.g_varchar2_table(146) := '67536561726368496E6465783D242E6772657028652C66756E6374696F6E2865297B72657475726E20303D3D652E737D292C6D2E67537461746963496E6465783D242E6772657028652C66756E6374696F6E2865297B72657475726E20313D3D652E737D';
wwv_flow_api.g_varchar2_table(147) := '292C617065782E6576656E742E747269676765722822626F6479222C226170657873706F746C696768742D6765742D64617461222C65297D29292C666F637573456C656D656E743D657D2C696E506167655365617263683A66756E6374696F6E2865297B';
wwv_flow_api.g_varchar2_table(148) := '76617220743D657C7C6D2E674B6579776F7264733B242822626F647922292E756E6D61726B287B646F6E653A66756E6374696F6E28297B6D2E636C6F73654469616C6F6728292C6D2E726573657453706F746C6967687428292C242822626F647922292E';
wwv_flow_api.g_varchar2_table(149) := '6D61726B28742C7B7D292C617065782E6576656E742E747269676765722822626F6479222C226170657873706F746C696768742D696E706167652D736561726368222C7B6B6579776F72643A747D297D7D297D2C686173536561726368526573756C7473';
wwv_flow_api.g_varchar2_table(150) := '44796E616D6963456E74726965733A66756E6374696F6E28297B72657475726E202428226C692E6170782D53706F746C696768742D726573756C7422292E686173436C61737328226170782D53706F746C696768742D44594E414D494322297C7C21317D';
wwv_flow_api.g_varchar2_table(151) := '2C706C7567696E48616E646C65723A66756E6374696F6E2865297B76617220743D6D2E6744796E616D6963416374696F6E49643D652E64796E616D6963416374696F6E49642C613D6D2E67416A61784964656E7469666965723D652E616A61784964656E';
wwv_flow_api.g_varchar2_table(152) := '7469666965722C693D652E6576656E744E616D652C6F3D652E666972654F6E496E69742C723D6D2E67506C616365686F6C646572546578743D652E706C616365686F6C646572546578742C6E3D6D2E674D6F72654368617273546578743D652E6D6F7265';
wwv_flow_api.g_varchar2_table(153) := '4368617273546578742C6C3D6D2E674E6F4D61746368546578743D652E6E6F4D61746368546578742C733D6D2E674F6E654D61746368546578743D652E6F6E654D61746368546578742C673D6D2E674D756C7469706C654D617463686573546578743D65';
wwv_flow_api.g_varchar2_table(154) := '2E6D756C7469706C654D617463686573546578742C703D6D2E67496E50616765536561726368546578743D652E696E50616765536561726368546578742C633D6D2E67536561726368486973746F727944656C657465546578743D652E73656172636848';
wwv_flow_api.g_varchar2_table(155) := '6973746F727944656C657465546578742C643D652E656E61626C654B6579626F61726453686F7274637574732C683D652E6B6579626F61726453686F7274637574732C533D652E7375626D69744974656D732C753D652E656E61626C65496E5061676553';
wwv_flow_api.g_varchar2_table(156) := '65617263682C783D6D2E674D61784E6176526573756C743D652E6D61784E6176526573756C742C543D6D2E6757696474683D652E77696474682C663D652E656E61626C654461746143616368652C793D652E73706F746C696768745468656D652C493D65';
wwv_flow_api.g_varchar2_table(157) := '2E656E61626C6550726566696C6C53656C6563746564546578742C763D652E73686F7750726F63657373696E672C503D652E706C616365486F6C64657249636F6E2C623D652E656E61626C65536561726368486973746F72792C443D21303B7377697463';
wwv_flow_api.g_varchar2_table(158) := '6828617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D2064796E616D6963416374696F6E4964222C74292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C';
wwv_flow_api.g_varchar2_table(159) := '7567696E48616E646C6572202D20616A61784964656E746966696572222C61292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D206576656E744E616D65222C69292C617065782E6465';
wwv_flow_api.g_varchar2_table(160) := '6275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D20666972654F6E496E6974222C6F292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D20';
wwv_flow_api.g_varchar2_table(161) := '706C616365686F6C64657254657874222C72292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D206D6F7265436861727354657874222C6E292C617065782E64656275672E6C6F672822';
wwv_flow_api.g_varchar2_table(162) := '6170657853706F746C696768742E706C7567696E48616E646C6572202D206E6F4D6174636854657874222C6C292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D206F6E654D61746368';
wwv_flow_api.g_varchar2_table(163) := '54657874222C73292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D206D756C7469706C654D61746368657354657874222C67292C617065782E64656275672E6C6F6728226170657853';
wwv_flow_api.g_varchar2_table(164) := '706F746C696768742E706C7567696E48616E646C6572202D20696E5061676553656172636854657874222C70292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D207365617263684869';
wwv_flow_api.g_varchar2_table(165) := '73746F727944656C65746554657874222C63292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D20656E61626C654B6579626F61726453686F727463757473222C64292C617065782E64';
wwv_flow_api.g_varchar2_table(166) := '656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D206B6579626F61726453686F727463757473222C68292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E4861';
wwv_flow_api.g_varchar2_table(167) := '6E646C6572202D207375626D69744974656D73222C53292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D20656E61626C65496E50616765536561726368222C75292C617065782E6465';
wwv_flow_api.g_varchar2_table(168) := '6275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D206D61784E6176526573756C74222C78292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C657220';
wwv_flow_api.g_varchar2_table(169) := '2D207769647468222C54292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D20656E61626C65446174614361636865222C66292C617065782E64656275672E6C6F672822617065785370';
wwv_flow_api.g_varchar2_table(170) := '6F746C696768742E706C7567696E48616E646C6572202D2073706F746C696768745468656D65222C79292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D20656E61626C655072656669';
wwv_flow_api.g_varchar2_table(171) := '6C6C53656C656374656454657874222C49292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D2073686F7750726F63657373696E67222C76292C617065782E64656275672E6C6F672822';
wwv_flow_api.g_varchar2_table(172) := '6170657853706F746C696768742E706C7567696E48616E646C6572202D20706C616365486F6C64657249636F6E222C50292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D20656E6162';
wwv_flow_api.g_varchar2_table(173) := '6C65536561726368486973746F7279222C62292C537472696E672E70726F746F747970652E737461727473576974687C7C28537472696E672E70726F746F747970652E737461727473576974683D66756E6374696F6E28652C74297B72657475726E2074';
wwv_flow_api.g_varchar2_table(174) := '6869732E7375627374722821747C7C743C303F303A2B742C652E6C656E677468293D3D3D657D292C537472696E672E70726F746F747970652E696E636C756465737C7C28537472696E672E70726F746F747970652E696E636C756465733D66756E637469';
wwv_flow_api.g_varchar2_table(175) := '6F6E28652C74297B2275736520737472696374223B72657475726E226E756D62657222213D747970656F662074262628743D30292C2128742B652E6C656E6774683E746869732E6C656E6774682926262D31213D3D746869732E696E6465784F6628652C';
wwv_flow_api.g_varchar2_table(176) := '74297D292C6D2E67456E61626C65496E506167655365617263683D2259223D3D752C6D2E67456E61626C654461746143616368653D2259223D3D662C6D2E67456E61626C6550726566696C6C53656C6563746564546578743D2259223D3D492C6D2E6753';
wwv_flow_api.g_varchar2_table(177) := '686F7750726F63657373696E673D2259223D3D762C6D2E67456E61626C65536561726368486973746F72793D2259223D3D622C532626286D2E675375626D69744974656D7341727261793D532E73706C697428222C2229292C79297B63617365224F5241';
wwv_flow_api.g_varchar2_table(178) := '4E4745223A6D2E67526573756C744C6973745468656D65436C6173733D226170782D53706F746C696768742D726573756C742D6F72616E6765222C6D2E6749636F6E5468656D65436C6173733D226170782D53706F746C696768742D69636F6E2D6F7261';
wwv_flow_api.g_varchar2_table(179) := '6E6765223B627265616B3B6361736522524544223A6D2E67526573756C744C6973745468656D65436C6173733D226170782D53706F746C696768742D726573756C742D726564222C6D2E6749636F6E5468656D65436C6173733D226170782D53706F746C';
wwv_flow_api.g_varchar2_table(180) := '696768742D69636F6E2D726564223B627265616B3B63617365224441524B223A6D2E67526573756C744C6973745468656D65436C6173733D226170782D53706F746C696768742D726573756C742D6461726B222C6D2E6749636F6E5468656D65436C6173';
wwv_flow_api.g_varchar2_table(181) := '733D226170782D53706F746C696768742D69636F6E2D6461726B227D6D2E67506C616365486F6C64657249636F6E3D2244454641554C54223D3D3D503F22612D49636F6E2069636F6E2D736561726368223A22666120222B502C443D226B6579626F6172';
wwv_flow_api.g_varchar2_table(182) := '6453686F7274637574223D3D697C7C2259223D3D6F7C7C22726561647922213D692C242822626F647922292E6F6E28226170657873706F746C696768742D6765742D64617461222C66756E6374696F6E28297B6966286D2E674861734469616C6F674372';
wwv_flow_api.g_varchar2_table(183) := '65617465642626216D2E686173536561726368526573756C747344796E616D6963456E74726965732829297B76617220653D24286D2E444F542B6D2E53505F494E505554292E76616C28292E7472696D28293B652626286D2E7365617263682865292C24';
wwv_flow_api.g_varchar2_table(184) := '286D2E444F542B6D2E53505F494E505554292E747269676765722822696E7075742229297D7D292C4426266D2E6F70656E53706F746C696768744469616C6F6728297D7D3B6D2E706C7567696E48616E646C65722865297D7D3B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(4532193554582716)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_file_name=>'js/apexspotlight.min.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A2A0A202A20415045582053706F746C69676874205365617263680A202A20417574686F723A2044616E69656C20486F63686C6569746E65720A202A20437265646974733A204150455820446576205465616D3A202F692F617065785F75692F6A732F';
wwv_flow_api.g_varchar2_table(2) := '73706F746C696768742E6A730A202A2056657273696F6E3A20312E362E310A202A2F0A0A2F2A2A0A202A20457874656E6420617065782E64610A202A2F0A617065782E64612E6170657853706F746C69676874203D207B0A20202F2A2A0A2020202A2049';
wwv_flow_api.g_varchar2_table(3) := '6E6974206B6579626F6172642073686F727463757473206F6E2070616765206C6F61640A2020202A2040706172616D207B6F626A6563747D20704F7074696F6E730A2020202A2F0A2020696E69744B6579626F61726453686F7274637574733A2066756E';
wwv_flow_api.g_varchar2_table(4) := '6374696F6E28704F7074696F6E7329207B0A202020202F2F206368616E67652064656661756C74206576656E740A20202020704F7074696F6E732E6576656E744E616D65203D20276B6579626F61726453686F7274637574273B0A0A202020202F2F2064';
wwv_flow_api.g_varchar2_table(5) := '656275670A20202020617065782E64656275672E6C6F6728276170657853706F746C696768742E696E69744B6579426F61726453686F727463757473202D20704F7074696F6E73272C20704F7074696F6E73293B0A0A2020202076617220656E61626C65';
wwv_flow_api.g_varchar2_table(6) := '4B6579626F61726453686F727463757473203D20704F7074696F6E732E656E61626C654B6579626F61726453686F7274637574733B0A20202020766172206B6579626F61726453686F727463757473203D20704F7074696F6E732E6B6579626F61726453';
wwv_flow_api.g_varchar2_table(7) := '686F7274637574733B0A20202020766172206B6579626F61726453686F7274637574734172726179203D205B5D3B0A0A2020202069662028656E61626C654B6579626F61726453686F727463757473203D3D2027592729207B0A2020202020206B657962';
wwv_flow_api.g_varchar2_table(8) := '6F61726453686F7274637574734172726179203D206B6579626F61726453686F7274637574732E73706C697428272C27293B0A0A2020202020202F2F2064697361626C652064656661756C74206265686176696F7220746F206E6F742062696E6420696E';
wwv_flow_api.g_varchar2_table(9) := '20696E707574206669656C64730A2020202020204D6F757365747261702E73746F7043616C6C6261636B203D2066756E6374696F6E28652C20656C656D656E742C20636F6D626F29207B0A202020202020202072657475726E2066616C73653B0A202020';
wwv_flow_api.g_varchar2_table(10) := '2020207D3B0A2020202020204D6F757365747261702E70726F746F747970652E73746F7043616C6C6261636B203D2066756E6374696F6E28652C20656C656D656E742C20636F6D626F29207B0A202020202020202072657475726E2066616C73653B0A20';
wwv_flow_api.g_varchar2_table(11) := '20202020207D3B0A0A2020202020202F2F2062696E64206D6F75737472617020746F206B6579626F6172642073686F72746375740A2020202020204D6F757365747261702E62696E64286B6579626F61726453686F72746375747341727261792C206675';
wwv_flow_api.g_varchar2_table(12) := '6E6374696F6E286529207B0A20202020202020202F2F2070726576656E742064656661756C74206265686176696F720A202020202020202069662028652E70726576656E7444656661756C7429207B0A20202020202020202020652E70726576656E7444';
wwv_flow_api.g_varchar2_table(13) := '656661756C7428293B0A20202020202020207D20656C7365207B0A202020202020202020202F2F20696E7465726E6574206578706C6F7265720A20202020202020202020652E72657475726E56616C7565203D2066616C73653B0A20202020202020207D';
wwv_flow_api.g_varchar2_table(14) := '0A20202020202020202F2F2063616C6C206D61696E20706C7567696E2068616E646C65720A2020202020202020617065782E64612E6170657853706F746C696768742E706C7567696E48616E646C657228704F7074696F6E73293B0A2020202020207D29';
wwv_flow_api.g_varchar2_table(15) := '3B0A202020207D0A20207D2C0A20202F2A2A0A2020202A205365742073706F746C696768742073656172636820696E70757420746F20686973746F72792076616C75650A2020202A2040706172616D207B737472696E677D20705365617263685465726D';
wwv_flow_api.g_varchar2_table(16) := '0A2020202A2F0A2020736574486973746F727953656172636856616C75653A2066756E6374696F6E28705365617263685465726D29207B0A202020202428272E6170782D53706F746C696768742D696E70757427292E76616C2870536561726368546572';
wwv_flow_api.g_varchar2_table(17) := '6D292E747269676765722827696E70757427293B0A20207D2C0A20202F2A2A0A2020202A20506C7567696E2068616E646C6572202D2063616C6C65642066726F6D20706C7567696E2072656E6465722066756E6374696F6E0A2020202A2040706172616D';
wwv_flow_api.g_varchar2_table(18) := '207B6F626A6563747D20704F7074696F6E730A2020202A2F0A2020706C7567696E48616E646C65723A2066756E6374696F6E28704F7074696F6E7329207B0A202020202F2A2A0A20202020202A204D61696E204E616D6573706163650A20202020202A2F';
wwv_flow_api.g_varchar2_table(19) := '0A20202020766172206170657853706F746C69676874203D207B0A2020202020202F2A2A0A202020202020202A20436F6E7374616E74730A202020202020202A2F0A202020202020444F543A20272E272C0A20202020202053505F4449414C4F473A2027';
wwv_flow_api.g_varchar2_table(20) := '6170782D53706F746C69676874272C0A20202020202053505F494E5055543A20276170782D53706F746C696768742D696E707574272C0A20202020202053505F524553554C54533A20276170782D53706F746C696768742D726573756C7473272C0A2020';
wwv_flow_api.g_varchar2_table(21) := '2020202053505F4143544956453A202769732D616374697665272C0A20202020202053505F53484F52544355543A20276170782D53706F746C696768742D73686F7274637574272C0A20202020202053505F414354494F4E5F53484F52544355543A2027';
wwv_flow_api.g_varchar2_table(22) := '73706F746C696768742D736561726368272C0A20202020202053505F524553554C545F4C4142454C3A20276170782D53706F746C696768742D6C6162656C272C0A20202020202053505F4C4956455F524547494F4E3A202773702D617269612D6D617463';
wwv_flow_api.g_varchar2_table(23) := '682D666F756E64272C0A20202020202053505F4C4953543A202773702D726573756C742D6C697374272C0A2020202020204B4559533A20242E75692E6B6579436F64652C0A20202020202055524C5F54595045533A207B0A202020202020202072656469';
wwv_flow_api.g_varchar2_table(24) := '726563743A20277265646972656374272C0A2020202020202020736561726368506167653A20277365617263682D70616765270A2020202020207D2C0A20202020202049434F4E533A207B0A2020202020202020706167653A202766612D77696E646F77';
wwv_flow_api.g_varchar2_table(25) := '2D736561726368272C0A20202020202020207365617263683A202769636F6E2D736561726368270A2020202020207D2C0A2020202020202F2A2A0A202020202020202A20676C6F62616C20766172730A202020202020202A2F0A202020202020674D6178';
wwv_flow_api.g_varchar2_table(26) := '4E6176526573756C743A2035302C0A2020202020206757696474683A203635302C0A202020202020674861734469616C6F67437265617465643A2066616C73652C0A20202020202067536561726368496E6465783A205B5D2C0A20202020202067537461';
wwv_flow_api.g_varchar2_table(27) := '746963496E6465783A205B5D2C0A202020202020674B6579776F7264733A2027272C0A20202020202067416A61784964656E7469666965723A206E756C6C2C0A2020202020206744796E616D6963416374696F6E49643A206E756C6C2C0A202020202020';
wwv_flow_api.g_varchar2_table(28) := '67506C616365686F6C646572546578743A206E756C6C2C0A202020202020674D6F72654368617273546578743A206E756C6C2C0A202020202020674E6F4D61746368546578743A206E756C6C2C0A202020202020674F6E654D61746368546578743A206E';
wwv_flow_api.g_varchar2_table(29) := '756C6C2C0A202020202020674D756C7469706C654D617463686573546578743A206E756C6C2C0A20202020202067496E50616765536561726368546578743A206E756C6C2C0A20202020202067536561726368486973746F727944656C65746554657874';
wwv_flow_api.g_varchar2_table(30) := '3A206E756C6C2C0A20202020202067456E61626C65496E506167655365617263683A20747275652C0A20202020202067456E61626C654461746143616368653A2066616C73652C0A20202020202067456E61626C6550726566696C6C53656C6563746564';
wwv_flow_api.g_varchar2_table(31) := '546578743A2066616C73652C0A20202020202067456E61626C65536561726368486973746F72793A2066616C73652C0A202020202020675375626D69744974656D7341727261793A205B5D2C0A20202020202067526573756C744C6973745468656D6543';
wwv_flow_api.g_varchar2_table(32) := '6C6173733A2027272C0A2020202020206749636F6E5468656D65436C6173733A2027272C0A2020202020206753686F7750726F63657373696E673A2066616C73652C0A20202020202067506C616365486F6C64657249636F6E3A2027612D49636F6E2069';
wwv_flow_api.g_varchar2_table(33) := '636F6E2D736561726368272C0A20202020202067576169745370696E6E6572243A206E756C6C2C0A2020202020202F2A2A0A202020202020202A20476574204A534F4E20636F6E7461696E696E67206461746120666F722073706F746C69676874207365';
wwv_flow_api.g_varchar2_table(34) := '6172636820656E74726965732066726F6D2044420A202020202020202A2040706172616D207B66756E6374696F6E7D2063616C6C6261636B0A202020202020202A2F0A20202020202067657453706F746C69676874446174613A2066756E6374696F6E28';
wwv_flow_api.g_varchar2_table(35) := '63616C6C6261636B29207B0A2020202020202020766172206361636865446174613B0A2020202020202020696620286170657853706F746C696768742E67456E61626C6544617461436163686529207B0A20202020202020202020636163686544617461';
wwv_flow_api.g_varchar2_table(36) := '203D206170657853706F746C696768742E67657453706F746C696768744461746153657373696F6E53746F7261676528293B0A202020202020202020206966202863616368654461746129207B0A20202020202020202020202063616C6C6261636B284A';
wwv_flow_api.g_varchar2_table(37) := '534F4E2E70617273652863616368654461746129293B0A20202020202020202020202072657475726E3B0A202020202020202020207D0A20202020202020207D0A2020202020202020747279207B0A202020202020202020206170657853706F746C6967';
wwv_flow_api.g_varchar2_table(38) := '68742E73686F77576169745370696E6E657228293B0A20202020202020202020617065782E7365727665722E706C7567696E286170657853706F746C696768742E67416A61784964656E7469666965722C207B0A20202020202020202020202070616765';
wwv_flow_api.g_varchar2_table(39) := '4974656D733A206170657853706F746C696768742E675375626D69744974656D7341727261792C0A2020202020202020202020207830313A20274745545F44415441270A202020202020202020207D2C207B0A2020202020202020202020206461746154';
wwv_flow_api.g_varchar2_table(40) := '7970653A20276A736F6E272C0A202020202020202020202020737563636573733A2066756E6374696F6E286461746129207B0A2020202020202020202020202020617065782E6576656E742E747269676765722827626F6479272C20276170657873706F';
wwv_flow_api.g_varchar2_table(41) := '746C696768742D616A61782D73756363657373272C2064617461293B0A2020202020202020202020202020617065782E64656275672E6C6F6728226170657853706F746C696768742E67657453706F746C696768744461746120414A4158205375636365';
wwv_flow_api.g_varchar2_table(42) := '7373222C2064617461293B0A2020202020202020202020202020696620286170657853706F746C696768742E67456E61626C6544617461436163686529207B0A202020202020202020202020202020206170657853706F746C696768742E73657453706F';
wwv_flow_api.g_varchar2_table(43) := '746C696768744461746153657373696F6E53746F72616765284A534F4E2E737472696E67696679286461746129293B0A20202020202020202020202020207D0A20202020202020202020202020206170657853706F746C696768742E6869646557616974';
wwv_flow_api.g_varchar2_table(44) := '5370696E6E657228293B0A202020202020202020202020202063616C6C6261636B2864617461293B0A2020202020202020202020207D2C0A2020202020202020202020206572726F723A2066756E6374696F6E286A715848522C20746578745374617475';
wwv_flow_api.g_varchar2_table(45) := '732C206572726F725468726F776E29207B0A2020202020202020202020202020617065782E6576656E742E747269676765722827626F6479272C20276170657873706F746C696768742D616A61782D6572726F72272C207B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(46) := '2020202020226D657373616765223A206572726F725468726F776E0A20202020202020202020202020207D293B0A2020202020202020202020202020617065782E64656275672E6C6F6728226170657853706F746C696768742E67657453706F746C6967';
wwv_flow_api.g_varchar2_table(47) := '68744461746120414A4158204572726F72222C206572726F725468726F776E293B0A20202020202020202020202020206170657853706F746C696768742E68696465576169745370696E6E657228293B0A202020202020202020202020202063616C6C62';
wwv_flow_api.g_varchar2_table(48) := '61636B285B5D293B0A2020202020202020202020207D0A202020202020202020207D293B0A20202020202020207D206361746368202865727229207B0A20202020202020202020617065782E6576656E742E747269676765722827626F6479272C202761';
wwv_flow_api.g_varchar2_table(49) := '70657873706F746C696768742D616A61782D6572726F72272C207B0A202020202020202020202020226D657373616765223A206572720A202020202020202020207D293B0A20202020202020202020617065782E64656275672E6C6F6728226170657853';
wwv_flow_api.g_varchar2_table(50) := '706F746C696768742E67657453706F746C696768744461746120414A4158204572726F72222C20657272293B0A202020202020202020206170657853706F746C696768742E68696465576169745370696E6E657228293B0A202020202020202020206361';
wwv_flow_api.g_varchar2_table(51) := '6C6C6261636B285B5D293B0A20202020202020207D0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A20476574204A534F4E20636F6E7461696E696E67205353502055524C2077697468207265706C6163656420736561726368206B';
wwv_flow_api.g_varchar2_table(52) := '6579776F72642076616C756520287E5345415243485F56414C55457E20737562737469747574696F6E20737472696E67290A202020202020202A2040706172616D207B737472696E677D207055726C0A202020202020202A2040706172616D207B66756E';
wwv_flow_api.g_varchar2_table(53) := '6374696F6E7D2063616C6C6261636B0A202020202020202A2F0A20202020202067657450726F7065724170657855726C3A2066756E6374696F6E287055726C2C2063616C6C6261636B29207B0A2020202020202020747279207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(54) := '20617065782E7365727665722E706C7567696E286170657853706F746C696768742E67416A61784964656E7469666965722C207B0A2020202020202020202020207830313A20274745545F55524C272C0A2020202020202020202020207830323A206170';
wwv_flow_api.g_varchar2_table(55) := '657853706F746C696768742E674B6579776F7264732C0A2020202020202020202020207830333A207055726C0A202020202020202020207D2C207B0A20202020202020202020202064617461547970653A20276A736F6E272C0A20202020202020202020';
wwv_flow_api.g_varchar2_table(56) := '2020737563636573733A2066756E6374696F6E286461746129207B0A2020202020202020202020202020617065782E64656275672E6C6F6728226170657853706F746C696768742E67657450726F7065724170657855726C20414A415820537563636573';
wwv_flow_api.g_varchar2_table(57) := '73222C2064617461293B0A202020202020202020202020202063616C6C6261636B2864617461293B0A2020202020202020202020207D2C0A2020202020202020202020206572726F723A2066756E6374696F6E286A715848522C20746578745374617475';
wwv_flow_api.g_varchar2_table(58) := '732C206572726F725468726F776E29207B0A2020202020202020202020202020617065782E64656275672E6C6F6728226170657853706F746C696768742E67657450726F7065724170657855726C20414A4158204572726F72222C206572726F72546872';
wwv_flow_api.g_varchar2_table(59) := '6F776E293B0A202020202020202020202020202063616C6C6261636B287B0A202020202020202020202020202020202275726C223A207055726C0A20202020202020202020202020207D293B0A2020202020202020202020207D0A202020202020202020';
wwv_flow_api.g_varchar2_table(60) := '207D293B0A20202020202020207D206361746368202865727229207B0A20202020202020202020617065782E64656275672E6C6F6728226170657853706F746C696768742E67657450726F7065724170657855726C20414A4158204572726F72222C2065';
wwv_flow_api.g_varchar2_table(61) := '7272293B0A2020202020202020202063616C6C6261636B287B0A2020202020202020202020202275726C223A207055726C0A202020202020202020207D293B0A20202020202020207D0A2020202020207D2C0A2020202020202F2A2A0A20202020202020';
wwv_flow_api.g_varchar2_table(62) := '2A2053617665204A534F4E204461746120696E206C6F63616C2073657373696F6E2073746F72616765206F662062726F7773657220286170657853706F746C696768742E3C6170705F69643E2E3C6170705F73657373696F6E3E2E3C64612D69643E2E64';
wwv_flow_api.g_varchar2_table(63) := '617461290A202020202020202A2040706172616D207B6F626A6563747D2070446174610A202020202020202A2F0A20202020202073657453706F746C696768744461746153657373696F6E53746F726167653A2066756E6374696F6E2870446174612920';
wwv_flow_api.g_varchar2_table(64) := '7B0A20202020202020207661722068617353657373696F6E53746F72616765537570706F7274203D20617065782E73746F726167652E68617353657373696F6E53746F72616765537570706F727428293B0A0A2020202020202020696620286861735365';
wwv_flow_api.g_varchar2_table(65) := '7373696F6E53746F72616765537570706F727429207B0A20202020202020202020766172206170657853657373696F6E203D202476282770496E7374616E636527293B0A202020202020202020207661722073657373696F6E53746F72616765203D2061';
wwv_flow_api.g_varchar2_table(66) := '7065782E73746F726167652E67657453636F70656453657373696F6E53746F72616765287B0A2020202020202020202020207072656669783A20276170657853706F746C69676874272C0A20202020202020202020202075736541707049643A20747275';
wwv_flow_api.g_varchar2_table(67) := '650A202020202020202020207D293B0A2020202020202020202073657373696F6E53746F726167652E7365744974656D286170657853657373696F6E202B20272E27202B206170657853706F746C696768742E6744796E616D6963416374696F6E496420';
wwv_flow_api.g_varchar2_table(68) := '2B20272E64617461272C207044617461293B0A20202020202020207D0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A20476574204A534F4E20446174612066726F6D206C6F63616C2073657373696F6E2073746F72616765206F66';
wwv_flow_api.g_varchar2_table(69) := '2062726F7773657220286170657853706F746C696768742E3C6170705F69643E2E3C6170705F73657373696F6E3E2E3C64612D69643E2E64617461290A202020202020202A2F0A20202020202067657453706F746C696768744461746153657373696F6E';
wwv_flow_api.g_varchar2_table(70) := '53746F726167653A2066756E6374696F6E2829207B0A20202020202020207661722068617353657373696F6E53746F72616765537570706F7274203D20617065782E73746F726167652E68617353657373696F6E53746F72616765537570706F72742829';
wwv_flow_api.g_varchar2_table(71) := '3B0A0A20202020202020207661722073746F7261676556616C75653B0A20202020202020206966202868617353657373696F6E53746F72616765537570706F727429207B0A20202020202020202020766172206170657853657373696F6E203D20247628';
wwv_flow_api.g_varchar2_table(72) := '2770496E7374616E636527293B0A202020202020202020207661722073657373696F6E53746F72616765203D20617065782E73746F726167652E67657453636F70656453657373696F6E53746F72616765287B0A20202020202020202020202070726566';
wwv_flow_api.g_varchar2_table(73) := '69783A20276170657853706F746C69676874272C0A20202020202020202020202075736541707049643A20747275650A202020202020202020207D293B0A2020202020202020202073746F7261676556616C7565203D2073657373696F6E53746F726167';
wwv_flow_api.g_varchar2_table(74) := '652E6765744974656D286170657853657373696F6E202B20272E27202B206170657853706F746C696768742E6744796E616D6963416374696F6E4964202B20272E6461746127293B0A20202020202020207D0A202020202020202072657475726E207374';
wwv_flow_api.g_varchar2_table(75) := '6F7261676556616C75653B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A205361766520736561726368207465726D20696E206C6F63616C2073746F72616765206F662062726F7773657220286170657853706F746C696768742E';
wwv_flow_api.g_varchar2_table(76) := '3C6170705F69643E2E3C64612D69643E2E686973746F7279290A202020202020202A2040706172616D207B737472696E677D20705365617263685465726D0A202020202020202A2F0A20202020202073657453706F746C69676874486973746F72794C6F';
wwv_flow_api.g_varchar2_table(77) := '63616C53746F726167653A2066756E6374696F6E28705365617263685465726D29207B0A2020202020202020766172206861734C6F63616C53746F72616765537570706F7274203D20617065782E73746F726167652E6861734C6F63616C53746F726167';
wwv_flow_api.g_varchar2_table(78) := '65537570706F727428293B0A20202020202020207661722073746F726167654172726179203D205B5D3B0A0A20202020202020207661722072656D6F76654475707346726F6D4172726179203D2066756E6374696F6E2870417272617929207B0A202020';
wwv_flow_api.g_varchar2_table(79) := '2020202020202076617220756E69717565203D207B7D3B0A202020202020202020207041727261792E666F72456163682866756E6374696F6E286929207B0A2020202020202020202020206966202821756E697175655B695D29207B0A20202020202020';
wwv_flow_api.g_varchar2_table(80) := '20202020202020756E697175655B695D203D20747275653B0A2020202020202020202020207D0A202020202020202020207D293B0A2020202020202020202072657475726E204F626A6563742E6B65797328756E69717565293B0A20202020202020207D';
wwv_flow_api.g_varchar2_table(81) := '3B0A0A20202020202020207661722072656D6F76654F6C6456616C75657346726F6D4172726179203D2066756E6374696F6E2870417272617929207B0A20202020202020202020666F7220287661722069203D20303B2069203C207041727261792E6C65';
wwv_flow_api.g_varchar2_table(82) := '6E6774683B20692B2B29207B0A2020202020202020202020206966202869203E20333029207B0A20202020202020202020202020207041727261792E73706C69636528692C2031293B0A2020202020202020202020207D0A202020202020202020207D0A';
wwv_flow_api.g_varchar2_table(83) := '2020202020202020202072657475726E207041727261793B0A20202020202020207D3B0A20202020202020202F2F206F6E6C792061646420737472696E677320746F20666972737420706F736974696F6E206F662061727261790A202020202020202069';
wwv_flow_api.g_varchar2_table(84) := '66202869734E614E28705365617263685465726D2929207B0A2020202020202020202073746F726167654172726179203D206170657853706F746C696768742E67657453706F746C69676874486973746F72794C6F63616C53746F7261676528293B0A20';
wwv_flow_api.g_varchar2_table(85) := '20202020202020202073746F7261676541727261792E756E736869667428705365617263685465726D2E7472696D2829293B0A2020202020202020202073746F726167654172726179203D2072656D6F76654475707346726F6D41727261792873746F72';
wwv_flow_api.g_varchar2_table(86) := '6167654172726179293B0A2020202020202020202073746F726167654172726179203D2072656D6F76654F6C6456616C75657346726F6D41727261792873746F726167654172726179293B0A0A20202020202020202020696620286861734C6F63616C53';
wwv_flow_api.g_varchar2_table(87) := '746F72616765537570706F727429207B0A202020202020202020202020766172206C6F63616C53746F72616765203D20617065782E73746F726167652E67657453636F7065644C6F63616C53746F72616765287B0A202020202020202020202020202070';
wwv_flow_api.g_varchar2_table(88) := '72656669783A20276170657853706F746C69676874272C0A202020202020202020202020202075736541707049643A20747275650A2020202020202020202020207D293B0A2020202020202020202020206C6F63616C53746F726167652E736574497465';
wwv_flow_api.g_varchar2_table(89) := '6D286170657853706F746C696768742E6744796E616D6963416374696F6E4964202B20272E686973746F7279272C204A534F4E2E737472696E676966792873746F72616765417272617929293B0A202020202020202020207D0A20202020202020207D0A';
wwv_flow_api.g_varchar2_table(90) := '2020202020207D2C0A2020202020202F2A2A0A202020202020202A2047657420736176656420736561726368207465726D732066726F6D206C6F63616C2073746F72616765206F662062726F7773657220286170657853706F746C696768742E3C617070';
wwv_flow_api.g_varchar2_table(91) := '5F69643E2E3C64612D69643E2E686973746F7279290A202020202020202A2F0A20202020202067657453706F746C69676874486973746F72794C6F63616C53746F726167653A2066756E6374696F6E2829207B0A2020202020202020766172206861734C';
wwv_flow_api.g_varchar2_table(92) := '6F63616C53746F72616765537570706F7274203D20617065782E73746F726167652E6861734C6F63616C53746F72616765537570706F727428293B0A0A20202020202020207661722073746F7261676556616C75653B0A20202020202020207661722073';
wwv_flow_api.g_varchar2_table(93) := '746F726167654172726179203D205B5D3B0A2020202020202020696620286861734C6F63616C53746F72616765537570706F727429207B0A20202020202020202020766172206C6F63616C53746F72616765203D20617065782E73746F726167652E6765';
wwv_flow_api.g_varchar2_table(94) := '7453636F7065644C6F63616C53746F72616765287B0A2020202020202020202020207072656669783A20276170657853706F746C69676874272C0A20202020202020202020202075736541707049643A20747275650A202020202020202020207D293B0A';
wwv_flow_api.g_varchar2_table(95) := '2020202020202020202073746F7261676556616C7565203D206C6F63616C53746F726167652E6765744974656D286170657853706F746C696768742E6744796E616D6963416374696F6E4964202B20272E686973746F727927293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(96) := '20206966202873746F7261676556616C756529207B0A20202020202020202020202073746F726167654172726179203D204A534F4E2E70617273652873746F7261676556616C7565293B0A202020202020202020207D0A20202020202020207D0A202020';
wwv_flow_api.g_varchar2_table(97) := '202020202072657475726E2073746F7261676541727261793B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A2052656D6F766520736176656420736561726368207465726D732066726F6D206C6F63616C2073746F72616765206F';
wwv_flow_api.g_varchar2_table(98) := '662062726F7773657220286170657853706F746C696768742E3C6170705F69643E2E3C6170705F73657373696F6E3E2E3C64612D69643E2E686973746F7279290A202020202020202A2F0A20202020202072656D6F766553706F746C6967687448697374';
wwv_flow_api.g_varchar2_table(99) := '6F72794C6F63616C53746F726167653A2066756E6374696F6E2829207B0A2020202020202020766172206861734C6F63616C53746F72616765537570706F7274203D20617065782E73746F726167652E6861734C6F63616C53746F72616765537570706F';
wwv_flow_api.g_varchar2_table(100) := '727428293B0A0A2020202020202020696620286861734C6F63616C53746F72616765537570706F727429207B0A20202020202020202020766172206C6F63616C53746F72616765203D20617065782E73746F726167652E67657453636F7065644C6F6361';
wwv_flow_api.g_varchar2_table(101) := '6C53746F72616765287B0A2020202020202020202020207072656669783A20276170657853706F746C69676874272C0A20202020202020202020202075736541707049643A20747275650A202020202020202020207D293B0A202020202020202020206C';
wwv_flow_api.g_varchar2_table(102) := '6F63616C53746F726167652E72656D6F76654974656D286170657853706F746C696768742E6744796E616D6963416374696F6E4964202B20272E686973746F727927293B0A20202020202020207D0A2020202020207D2C0A2020202020202F2A2A0A2020';
wwv_flow_api.g_varchar2_table(103) := '20202020202A2053686F7720706F706F766572207573696E672074697070792E6A7320776869636820636F6E7461696E7320736176656420686973746F727920656E7472696573206F66206C6F63616C2073746F726167650A202020202020202A2F0A20';
wwv_flow_api.g_varchar2_table(104) := '202020202073686F775469707079486973746F7279506F706F7665723A2066756E6374696F6E2829207B0A202020202020202076617220686973746F72794172726179203D206170657853706F746C696768742E67657453706F746C6967687448697374';
wwv_flow_api.g_varchar2_table(105) := '6F72794C6F63616C53746F726167652829207C7C205B5D3B0A202020202020202076617220636F6E74656E74203D2027273B0A2020202020202020766172206C6F6F70436F756E74203D20303B0A0A202020202020202069662028686973746F72794172';
wwv_flow_api.g_varchar2_table(106) := '7261792E6C656E677468203E203029207B0A0A202020202020202020206170657853706F746C696768742E64657374726F795469707079486973746F7279506F706F76657228293B0A202020202020202020202428276469762E6170782D53706F746C69';
wwv_flow_api.g_varchar2_table(107) := '6768742D69636F6E2D6D61696E27292E6373732827637572736F72272C2027706F696E74657227293B0A0A20202020202020202020636F6E74656E74202B3D20273C756C20636C6173733D2273706F746C696768742D686973746F72792D6C697374223E';
wwv_flow_api.g_varchar2_table(108) := '273B0A20202020202020202020666F7220287661722069203D20303B2069203C20686973746F727941727261792E6C656E6774683B20692B2B29207B0A202020202020202020202020636F6E74656E74202B3D20223C6C693E3C6120636C6173733D5C22';
wwv_flow_api.g_varchar2_table(109) := '73706F746C696768742D686973746F72792D6C696E6B5C2220687265663D5C226A6176617363726970743A617065782E64612E6170657853706F746C696768742E736574486973746F727953656172636856616C7565282722202B20617065782E757469';
wwv_flow_api.g_varchar2_table(110) := '6C2E65736361706548544D4C28686973746F727941727261795B695D29202B202227293B5C223E22202B20617065782E7574696C2E65736361706548544D4C28686973746F727941727261795B695D29202B20223C2F613E3C2F6C693E223B0A20202020';
wwv_flow_api.g_varchar2_table(111) := '20202020202020206C6F6F70436F756E74203D206C6F6F70436F756E74202B20313B0A202020202020202020202020696620286C6F6F70436F756E74203E3D20323029207B0A2020202020202020202020202020627265616B3B0A202020202020202020';
wwv_flow_api.g_varchar2_table(112) := '2020207D0A202020202020202020207D0A20202020202020202020636F6E74656E74202B3D20223C6C693E3C6120636C6173733D5C2273706F746C696768742D686973746F72792D64656C6574655C2220687265663D5C226A6176617363726970743A76';
wwv_flow_api.g_varchar2_table(113) := '6F69642830293B5C223E3C693E22202B206170657853706F746C696768742E67536561726368486973746F727944656C65746554657874202B20223C2F693E3C2F613E3C2F6C693E223B0A20202020202020202020636F6E74656E74202B3D20273C2F75';
wwv_flow_api.g_varchar2_table(114) := '6C3E273B0A0A202020202020202020207469707079282428276469762E6170782D53706F746C696768742D69636F6E2D6D61696E27295B305D2C207B0A202020202020202020202020636F6E74656E743A20636F6E74656E742C0A202020202020202020';
wwv_flow_api.g_varchar2_table(115) := '202020696E7465726163746976653A20747275652C0A2020202020202020202020206172726F773A20747275652C0A202020202020202020202020706C6163656D656E743A202772696768742D656E64272C0A202020202020202020202020616E696D61';
wwv_flow_api.g_varchar2_table(116) := '746546696C6C3A2066616C73650A202020202020202020207D293B0A0A20202020202020202020242827626F647927292E6F6E2827636C69636B272C2027612E73706F746C696768742D686973746F72792D6C696E6B272C2066756E6374696F6E282920';
wwv_flow_api.g_varchar2_table(117) := '7B0A2020202020202020202020206170657853706F746C696768742E686964655469707079486973746F7279506F706F76657228293B0A202020202020202020207D293B0A20202020202020202020242827626F647927292E6F6E2827636C69636B272C';
wwv_flow_api.g_varchar2_table(118) := '2027612E73706F746C696768742D686973746F72792D64656C657465272C2066756E6374696F6E2829207B0A2020202020202020202020206170657853706F746C696768742E64657374726F795469707079486973746F7279506F706F76657228293B0A';
wwv_flow_api.g_varchar2_table(119) := '2020202020202020202020206170657853706F746C696768742E72656D6F766553706F746C69676874486973746F72794C6F63616C53746F7261676528293B0A202020202020202020207D293B0A20202020202020207D0A2020202020207D2C0A202020';
wwv_flow_api.g_varchar2_table(120) := '2020202F2A2A0A202020202020202A204869646520706F706F766572207573696E672074697070792E6A7320776869636820636F6E7461696E7320736176656420686973746F727920656E7472696573206F66206C6F63616C2073746F726167650A2020';
wwv_flow_api.g_varchar2_table(121) := '20202020202A2F0A202020202020686964655469707079486973746F7279506F706F7665723A2066756E6374696F6E2829207B0A2020202020202020766172207469707079456C656D203D202428276469762E6170782D53706F746C696768742D69636F';
wwv_flow_api.g_varchar2_table(122) := '6E2D6D61696E27295B305D3B0A2020202020202020696620287469707079456C656D202626207469707079456C656D2E5F746970707929207B0A202020202020202020207469707079456C656D2E5F74697070792E6869646528293B0A20202020202020';
wwv_flow_api.g_varchar2_table(123) := '207D0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A2044657374726F7920706F706F766572207573696E672074697070792E6A7320776869636820636F6E7461696E7320736176656420686973746F727920656E7472696573206F';
wwv_flow_api.g_varchar2_table(124) := '66206C6F63616C2073746F726167650A202020202020202A2F0A20202020202064657374726F795469707079486973746F7279506F706F7665723A2066756E6374696F6E2829207B0A2020202020202020766172207469707079456C656D203D20242827';
wwv_flow_api.g_varchar2_table(125) := '6469762E6170782D53706F746C696768742D69636F6E2D6D61696E27295B305D3B0A2020202020202020696620287469707079456C656D202626207469707079456C656D2E5F746970707929207B0A202020202020202020207469707079456C656D2E5F';
wwv_flow_api.g_varchar2_table(126) := '74697070792E64657374726F7928293B0A20202020202020207D0A202020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E666F63757328293B0A2020202020207D2C0A20';
wwv_flow_api.g_varchar2_table(127) := '20202020202F2A2A0A202020202020202A2053686F772077616974207370696E6E657220746F2073686F772070726F6772657373206F6620414A41582063616C6C0A202020202020202A2F0A20202020202073686F77576169745370696E6E65723A2066';
wwv_flow_api.g_varchar2_table(128) := '756E6374696F6E2829207B0A2020202020202020696620286170657853706F746C696768742E6753686F7750726F63657373696E6729207B0A202020202020202020202428276469762E6170782D53706F746C696768742D69636F6E2D6D61696E207370';
wwv_flow_api.g_varchar2_table(129) := '616E27292E72656D6F7665436C61737328292E616464436C617373282766612066612D726566726573682066612D616E696D2D7370696E27293B0A20202020202020207D0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A20486964';
wwv_flow_api.g_varchar2_table(130) := '652077616974207370696E6E657220616E6420646973706C61792064656661756C74207365617263682069636F6E0A202020202020202A2F0A20202020202068696465576169745370696E6E65723A2066756E6374696F6E2829207B0A20202020202020';
wwv_flow_api.g_varchar2_table(131) := '20696620286170657853706F746C696768742E6753686F7750726F63657373696E6729207B0A202020202020202020202428276469762E6170782D53706F746C696768742D69636F6E2D6D61696E207370616E27292E72656D6F7665436C61737328292E';
wwv_flow_api.g_varchar2_table(132) := '616464436C617373286170657853706F746C696768742E67506C616365486F6C64657249636F6E293B0A20202020202020207D0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A204765742074657874206F662073656C6563746564';
wwv_flow_api.g_varchar2_table(133) := '2074657874206F6E20646F63756D656E740A202020202020202A2F0A20202020202067657453656C6563746564546578743A2066756E6374696F6E2829207B0A20202020202020207661722072616E67653B0A20202020202020206966202877696E646F';
wwv_flow_api.g_varchar2_table(134) := '772E67657453656C656374696F6E29207B0A2020202020202020202072616E6765203D2077696E646F772E67657453656C656374696F6E28293B0A2020202020202020202072657475726E2072616E67652E746F537472696E6728292E7472696D28293B';
wwv_flow_api.g_varchar2_table(135) := '0A20202020202020207D20656C7365207B0A2020202020202020202069662028646F63756D656E742E73656C656374696F6E2E63726561746552616E676529207B0A20202020202020202020202072616E6765203D20646F63756D656E742E73656C6563';
wwv_flow_api.g_varchar2_table(136) := '74696F6E2E63726561746552616E676528293B0A20202020202020202020202072657475726E2072616E67652E746578742E7472696D28293B0A202020202020202020207D0A20202020202020207D0A2020202020207D2C0A2020202020202F2A2A0A20';
wwv_flow_api.g_varchar2_table(137) := '2020202020202A2046657463682073656C6563746564207465787420616E642073657420697420746F2073706F746C696768742073656172636820696E7075740A202020202020202A2F0A20202020202073657453656C6563746564546578743A206675';
wwv_flow_api.g_varchar2_table(138) := '6E6374696F6E2829207B0A20202020202020202F2F206765742073656C656374656420746578740A20202020202020207661722073656C656374656454657874203D206170657853706F746C696768742E67657453656C65637465645465787428293B0A';
wwv_flow_api.g_varchar2_table(139) := '0A20202020202020202F2F207365742073656C6563746564207465787420746F2073706F746C6967687420696E7075740A20202020202020206966202873656C65637465645465787429207B0A202020202020202020202F2F206966206469616C6F6720';
wwv_flow_api.g_varchar2_table(140) := '26206461746120616C72656164792074686572650A20202020202020202020696620286170657853706F746C696768742E674861734469616C6F674372656174656429207B0A20202020202020202020202024286170657853706F746C696768742E444F';
wwv_flow_api.g_varchar2_table(141) := '54202B206170657853706F746C696768742E53505F494E505554292E76616C2873656C656374656454657874292E747269676765722827696E70757427293B0A2020202020202020202020202F2F206469616C6F672068617320746F206265206F70656E';
wwv_flow_api.g_varchar2_table(142) := '656420262064617461206D75737420626520666574636865640A202020202020202020207D20656C7365207B0A2020202020202020202020202F2F206E6F7420756E74696C206461746120686173206265656E20696E20706C6163650A20202020202020';
wwv_flow_api.g_varchar2_table(143) := '2020202020242827626F647927292E6F6E28276170657873706F746C696768742D6765742D64617461272C2066756E6374696F6E2829207B0A202020202020202020202020202024286170657853706F746C696768742E444F54202B206170657853706F';
wwv_flow_api.g_varchar2_table(144) := '746C696768742E53505F494E505554292E76616C2873656C656374656454657874292E747269676765722827696E70757427293B0A2020202020202020202020207D293B0A202020202020202020207D0A20202020202020207D0A2020202020207D2C0A';
wwv_flow_api.g_varchar2_table(145) := '2020202020202F2A2A0A202020202020202A205772617070657220666F7220617065782E6E617669676174696F6E2E726564697265637420746F206F7074696F6E616C6C792073686F7720612077616974696E67207370696E6E6572206265666F726520';
wwv_flow_api.g_varchar2_table(146) := '7265646972656374696E670A202020202020202A2040706172616D207B737472696E677D207057686572650A202020202020202A2F0A20202020202072656469726563743A2066756E6374696F6E2870576865726529207B0A2020202020202020696620';
wwv_flow_api.g_varchar2_table(147) := '286170657853706F746C696768742E6753686F7750726F63657373696E6729207B0A20202020202020202020747279207B0A2020202020202020202020202F2F206E6F2077616974696E67207370696E6E657220666F72206A6176617363726970742074';
wwv_flow_api.g_varchar2_table(148) := '6172676574730A202020202020202020202020696620287057686572652E7374617274735769746828276A6176617363726970743A272929207B0A2020202020202020202020202020617065782E6E617669676174696F6E2E7265646972656374287057';
wwv_flow_api.g_varchar2_table(149) := '68657265293B0A2020202020202020202020207D20656C7365207B0A20202020202020202020202020202F2F206F6E6C792073686F77207370696E6E6572206966206E6F7420616C72656164792070726573656E7420616E64206966206974C2B4732061';
wwv_flow_api.g_varchar2_table(150) := '6E204150455820746172676574207061676520616E64206E6F20636C69656E7420736964652076616C69646174696F6E206572726F7273206F63637572656420616E6420746865207061676520686173206E6F74206368616E6765640A20202020202020';
wwv_flow_api.g_varchar2_table(151) := '20202020202020696620282428277370616E2E752D50726F63657373696E6727292E6C656E677468203D3D20302026260A202020202020202020202020202020207057686572652E737461727473576974682827663F703D27292026260A202020202020';
wwv_flow_api.g_varchar2_table(152) := '20202020202020202020617065782E706167652E76616C696461746528292026260A2020202020202020202020202020202021617065782E706167652E69734368616E676564282929207B0A202020202020202020202020202020206170657853706F74';
wwv_flow_api.g_varchar2_table(153) := '6C696768742E67576169745370696E6E657224203D20617065782E7574696C2E73686F775370696E6E657228242827626F64792729293B0A20202020202020202020202020207D0A2020202020202020202020202020617065782E6E617669676174696F';
wwv_flow_api.g_varchar2_table(154) := '6E2E726564697265637428705768657265293B0A2020202020202020202020207D0A202020202020202020207D206361746368202865727229207B0A202020202020202020202020696620286170657853706F746C696768742E67576169745370696E6E';
wwv_flow_api.g_varchar2_table(155) := '65722429207B0A20202020202020202020202020206170657853706F746C696768742E67576169745370696E6E6572242E72656D6F766528293B0A2020202020202020202020207D0A202020202020202020202020617065782E6E617669676174696F6E';
wwv_flow_api.g_varchar2_table(156) := '2E726564697265637428705768657265293B0A202020202020202020207D0A20202020202020207D20656C7365207B0A20202020202020202020617065782E6E617669676174696F6E2E726564697265637428705768657265293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(157) := '7D0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A2048616E646C65206172696120617474726962757465730A202020202020202A2F0A20202020202068616E646C6541726961417474723A2066756E6374696F6E2829207B0A2020';
wwv_flow_api.g_varchar2_table(158) := '20202020202076617220726573756C747324203D2024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F524553554C5453292C0A20202020202020202020696E70757424203D2024286170657853706F746C';
wwv_flow_api.g_varchar2_table(159) := '696768742E444F54202B206170657853706F746C696768742E53505F494E505554292C0A202020202020202020206163746976654964203D20726573756C7473242E66696E64286170657853706F746C696768742E444F54202B206170657853706F746C';
wwv_flow_api.g_varchar2_table(160) := '696768742E53505F414354495645292E66696E64286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F524553554C545F4C4142454C292E617474722827696427292C0A20202020202020202020616374697665';
wwv_flow_api.g_varchar2_table(161) := '456C656D24203D202428272327202B206163746976654964292C0A2020202020202020202061637469766554657874203D20616374697665456C656D242E7465787428292C0A202020202020202020206C697324203D20726573756C7473242E66696E64';
wwv_flow_api.g_varchar2_table(162) := '28276C6927292C0A202020202020202020206973457870616E646564203D206C6973242E6C656E67746820213D3D20302C0A202020202020202020206C69766554657874203D2027272C0A20202020202020202020726573756C7473436F756E74203D20';
wwv_flow_api.g_varchar2_table(163) := '6C6973242E66696C7465722866756E6374696F6E2829207B0A2020202020202020202020202F2F204578636C7564652074686520676C6F62616C20696E736572746564203C6C693E2C207768696368206861732073686F727463757473204374726C202B';
wwv_flow_api.g_varchar2_table(164) := '20312C20322C20330A2020202020202020202020202F2F2073756368206173202253656172636820576F726B737061636520666F722078222E0A20202020202020202020202072657475726E20242874686973292E66696E64286170657853706F746C69';
wwv_flow_api.g_varchar2_table(165) := '6768742E444F54202B206170657853706F746C696768742E53505F53484F5254435554292E6C656E677468203D3D3D20303B0A202020202020202020207D292E6C656E6774683B0A0A202020202020202024286170657853706F746C696768742E444F54';
wwv_flow_api.g_varchar2_table(166) := '202B206170657853706F746C696768742E53505F524553554C545F4C4142454C290A202020202020202020202E617474722827617269612D73656C6563746564272C202766616C736527293B0A0A2020202020202020616374697665456C656D240A2020';
wwv_flow_api.g_varchar2_table(167) := '20202020202020202E617474722827617269612D73656C6563746564272C20277472756527293B0A0A2020202020202020696620286170657853706F746C696768742E674B6579776F726473203D3D3D20272729207B0A202020202020202020206C6976';
wwv_flow_api.g_varchar2_table(168) := '6554657874203D206170657853706F746C696768742E674D6F72654368617273546578743B0A20202020202020207D20656C73652069662028726573756C7473436F756E74203D3D3D203029207B0A202020202020202020206C69766554657874203D20';
wwv_flow_api.g_varchar2_table(169) := '6170657853706F746C696768742E674E6F4D61746368546578743B0A20202020202020207D20656C73652069662028726573756C7473436F756E74203D3D3D203129207B0A202020202020202020206C69766554657874203D206170657853706F746C69';
wwv_flow_api.g_varchar2_table(170) := '6768742E674F6E654D61746368546578743B0A20202020202020207D20656C73652069662028726573756C7473436F756E74203E203129207B0A202020202020202020206C69766554657874203D20726573756C7473436F756E74202B20272027202B20';
wwv_flow_api.g_varchar2_table(171) := '6170657853706F746C696768742E674D756C7469706C654D617463686573546578743B0A20202020202020207D0A0A20202020202020206C69766554657874203D2061637469766554657874202B20272C2027202B206C697665546578743B0A0A202020';
wwv_flow_api.g_varchar2_table(172) := '20202020202428272327202B206170657853706F746C696768742E53505F4C4956455F524547494F4E292E74657874286C69766554657874293B0A0A2020202020202020696E707574240A202020202020202020202F2F202E706172656E74282920202F';
wwv_flow_api.g_varchar2_table(173) := '2F206172696120312E31207061747465726E0A202020202020202020202E617474722827617269612D61637469766564657363656E64616E74272C206163746976654964290A202020202020202020202E617474722827617269612D657870616E646564';
wwv_flow_api.g_varchar2_table(174) := '272C206973457870616E646564293B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A20436C6F7365206D6F64616C2073706F746C69676874206469616C6F670A202020202020202A2F0A202020202020636C6F73654469616C6F67';
wwv_flow_api.g_varchar2_table(175) := '3A2066756E6374696F6E2829207B0A202020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F47292E6469616C6F672827636C6F736527293B0A2020202020207D2C0A20202020';
wwv_flow_api.g_varchar2_table(176) := '20202F2A2A0A202020202020202A2052657365742073706F746C696768740A202020202020202A2F0A202020202020726573657453706F746C696768743A2066756E6374696F6E2829207B0A20202020202020202428272327202B206170657853706F74';
wwv_flow_api.g_varchar2_table(177) := '6C696768742E53505F4C495354292E656D70747928293B0A202020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E76616C282727292E666F63757328293B0A2020202020';
wwv_flow_api.g_varchar2_table(178) := '2020206170657853706F746C696768742E674B6579776F726473203D2027273B0A20202020202020206170657853706F746C696768742E68616E646C65417269614174747228293B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A';
wwv_flow_api.g_varchar2_table(179) := '204E617669676174696F6E20746F2074617267657420776869636820697320636F6E7461696E656420696E20656C656D2420283C613E206C696E6B290A202020202020202A2040706172616D207B6F626A6563747D20656C656D240A202020202020202A';
wwv_flow_api.g_varchar2_table(180) := '2040706172616D207B6F626A6563747D206576656E740A202020202020202A2F0A202020202020676F546F3A2066756E6374696F6E28656C656D242C206576656E7429207B0A20202020202020207661722075726C203D20656C656D242E646174612827';
wwv_flow_api.g_varchar2_table(181) := '75726C27292C0A2020202020202020202074797065203D20656C656D242E6461746128277479706527293B0A0A202020202020202073776974636820287479706529207B0A2020202020202020202063617365206170657853706F746C696768742E5552';
wwv_flow_api.g_varchar2_table(182) := '4C5F54595045532E736561726368506167653A0A2020202020202020202020206170657853706F746C696768742E696E5061676553656172636828293B0A202020202020202020202020627265616B3B0A0A202020202020202020206361736520617065';
wwv_flow_api.g_varchar2_table(183) := '7853706F746C696768742E55524C5F54595045532E72656469726563743A0A2020202020202020202020202F2F207265706C616365207E5345415243485F56414C55457E20737562737469747574696F6E20737472696E670A2020202020202020202020';
wwv_flow_api.g_varchar2_table(184) := '206966202875726C2E696E636C7564657328277E5345415243485F56414C55457E272929207B0A20202020202020202020202020202F2F2065736361706520736F6D652070726F626C656D61746963206368617273203A2C22270A202020202020202020';
wwv_flow_api.g_varchar2_table(185) := '20202020206170657853706F746C696768742E674B6579776F726473203D206170657853706F746C696768742E674B6579776F7264732E7265706C616365282F3A7C2C7C227C272F672C20272027292E7472696D28293B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(186) := '20202F2F20736572766572207369646520696620415045582055524C2069732064657465637465640A20202020202020202020202020206966202875726C2E737461727473576974682827663F703D272929207B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(187) := '206170657853706F746C696768742E67657450726F7065724170657855726C2875726C2C2066756E6374696F6E286461746129207B0A2020202020202020202020202020202020206170657853706F746C696768742E726564697265637428646174612E';
wwv_flow_api.g_varchar2_table(188) := '75726C293B0A202020202020202020202020202020207D293B0A202020202020202020202020202020202F2F20636C69656E74207369646520666F7220616C6C206F746865722055524C730A20202020202020202020202020207D20656C7365207B0A20';
wwv_flow_api.g_varchar2_table(189) := '20202020202020202020202020202075726C203D2075726C2E7265706C61636528277E5345415243485F56414C55457E272C206170657853706F746C696768742E674B6579776F726473293B0A202020202020202020202020202020206170657853706F';
wwv_flow_api.g_varchar2_table(190) := '746C696768742E72656469726563742875726C293B0A20202020202020202020202020207D0A20202020202020202020202020202F2F206E6F726D616C2055524C20776974686F757420737562737469747574696F6E20737472696E670A202020202020';
wwv_flow_api.g_varchar2_table(191) := '2020202020207D20656C7365207B0A20202020202020202020202020206170657853706F746C696768742E72656469726563742875726C293B0A2020202020202020202020207D0A202020202020202020202020627265616B3B0A20202020202020207D';
wwv_flow_api.g_varchar2_table(192) := '0A0A20202020202020206170657853706F746C696768742E636C6F73654469616C6F6728293B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A204765742048544D4C206D61726B75700A202020202020202A2040706172616D207B';
wwv_flow_api.g_varchar2_table(193) := '6F626A6563747D20646174610A202020202020202A2F0A2020202020206765744D61726B75703A2066756E6374696F6E286461746129207B0A2020202020202020766172207469746C65203D20646174612E7469746C652C0A2020202020202020202064';
wwv_flow_api.g_varchar2_table(194) := '657363203D20646174612E64657363207C7C2027272C0A2020202020202020202075726C203D20646174612E75726C2C0A2020202020202020202074797065203D20646174612E747970652C0A2020202020202020202069636F6E203D20646174612E69';
wwv_flow_api.g_varchar2_table(195) := '636F6E2C0A2020202020202020202069636F6E436F6C6F72203D20646174612E69636F6E436F6C6F722C0A2020202020202020202073686F7274637574203D20646174612E73686F72746375742C0A20202020202020202020737461746963203D206461';
wwv_flow_api.g_varchar2_table(196) := '74612E7374617469632C0A2020202020202020202073686F72746375744D61726B7570203D2073686F7274637574203F20273C7370616E20636C6173733D2227202B206170657853706F746C696768742E53505F53484F5254435554202B202722203E27';
wwv_flow_api.g_varchar2_table(197) := '202B2073686F7274637574202B20273C2F7370616E3E27203A2027272C0A202020202020202020206461746141747472203D2027272C0A2020202020202020202069636F6E537472696E67203D2027272C0A20202020202020202020696E646578547970';
wwv_flow_api.g_varchar2_table(198) := '65203D2027272C0A2020202020202020202069636F6E436F6C6F72537472696E67203D2027272C0A202020202020202020206F75743B0A0A20202020202020206966202875726C203D3D3D2030207C7C2075726C29207B0A202020202020202020206461';
wwv_flow_api.g_varchar2_table(199) := '746141747472203D2027646174612D75726C3D2227202B2075726C202B20272220273B0A20202020202020207D0A0A2020202020202020696620287479706529207B0A202020202020202020206461746141747472203D206461746141747472202B2027';
wwv_flow_api.g_varchar2_table(200) := '20646174612D747970653D2227202B2074797065202B20272220273B0A20202020202020207D0A0A20202020202020206966202869636F6E2E73746172747357697468282766612D272929207B0A2020202020202020202069636F6E537472696E67203D';
wwv_flow_api.g_varchar2_table(201) := '202766612027202B2069636F6E3B0A20202020202020207D20656C7365206966202869636F6E2E73746172747357697468282769636F6E2D272929207B0A2020202020202020202069636F6E537472696E67203D2027612D49636F6E2027202B2069636F';
wwv_flow_api.g_varchar2_table(202) := '6E3B0A20202020202020207D20656C7365207B0A2020202020202020202069636F6E537472696E67203D2027612D49636F6E2069636F6E2D736561726368273B0A20202020202020207D0A0A20202020202020202F2F2069732069742061207374617469';
wwv_flow_api.g_varchar2_table(203) := '6320656E747279206F7220612064796E616D69632073656172636820726573756C740A20202020202020206966202873746174696329207B0A20202020202020202020696E64657854797065203D2027535441544943273B0A20202020202020207D2065';
wwv_flow_api.g_varchar2_table(204) := '6C7365207B0A20202020202020202020696E64657854797065203D202744594E414D4943273B0A20202020202020207D0A0A20202020202020206966202869636F6E436F6C6F7229207B0A2020202020202020202069636F6E436F6C6F72537472696E67';
wwv_flow_api.g_varchar2_table(205) := '203D20277374796C653D226261636B67726F756E642D636F6C6F723A27202B2069636F6E436F6C6F72202B202722273B0A20202020202020207D0A0A20202020202020206F7574203D20273C6C6920636C6173733D226170782D53706F746C696768742D';
wwv_flow_api.g_varchar2_table(206) := '726573756C742027202B206170657853706F746C696768742E67526573756C744C6973745468656D65436C617373202B2027206170782D53706F746C696768742D726573756C742D2D70616765206170782D53706F746C696768742D27202B20696E6465';
wwv_flow_api.g_varchar2_table(207) := '7854797065202B2027223E27202B0A20202020202020202020273C7370616E20636C6173733D226170782D53706F746C696768742D6C696E6B222027202B206461746141747472202B20273E27202B0A20202020202020202020273C7370616E20636C61';
wwv_flow_api.g_varchar2_table(208) := '73733D226170782D53706F746C696768742D69636F6E2027202B206170657853706F746C696768742E6749636F6E5468656D65436C617373202B2027222027202B2069636F6E436F6C6F72537472696E67202B202720617269612D68696464656E3D2274';
wwv_flow_api.g_varchar2_table(209) := '727565223E27202B0A20202020202020202020273C7370616E20636C6173733D2227202B2069636F6E537472696E67202B2027223E3C2F7370616E3E27202B0A20202020202020202020273C2F7370616E3E27202B0A20202020202020202020273C7370';
wwv_flow_api.g_varchar2_table(210) := '616E20636C6173733D226170782D53706F746C696768742D696E666F223E27202B0A20202020202020202020273C7370616E20636C6173733D2227202B206170657853706F746C696768742E53505F524553554C545F4C4142454C202B20272220726F6C';
wwv_flow_api.g_varchar2_table(211) := '653D226F7074696F6E223E27202B207469746C65202B20273C2F7370616E3E27202B0A20202020202020202020273C7370616E20636C6173733D226170782D53706F746C696768742D64657363223E27202B2064657363202B20273C2F7370616E3E2720';
wwv_flow_api.g_varchar2_table(212) := '2B0A20202020202020202020273C2F7370616E3E27202B0A2020202020202020202073686F72746375744D61726B7570202B0A20202020202020202020273C2F7370616E3E27202B0A20202020202020202020273C2F6C693E273B0A0A20202020202020';
wwv_flow_api.g_varchar2_table(213) := '2072657475726E206F75743B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A205075736820737461746963206C69737420656E747269657320746F20726573756C747365740A202020202020202A2040706172616D207B61727261';
wwv_flow_api.g_varchar2_table(214) := '797D20726573756C74730A202020202020202A2F0A202020202020726573756C74734164644F6E733A2066756E6374696F6E28726573756C747329207B0A0A20202020202020207661722073686F7274637574436F756E746572203D20303B0A0A202020';
wwv_flow_api.g_varchar2_table(215) := '2020202020696620286170657853706F746C696768742E67456E61626C65496E5061676553656172636829207B0A20202020202020202020726573756C74732E70757368287B0A2020202020202020202020206E3A206170657853706F746C696768742E';
wwv_flow_api.g_varchar2_table(216) := '67496E50616765536561726368546578742C0A202020202020202020202020753A2027272C0A202020202020202020202020693A206170657853706F746C696768742E49434F4E532E706167652C0A20202020202020202020202069633A206E756C6C2C';
wwv_flow_api.g_varchar2_table(217) := '0A202020202020202020202020743A206170657853706F746C696768742E55524C5F54595045532E736561726368506167652C0A20202020202020202020202073686F72746375743A20274374726C202B2031272C0A202020202020202020202020733A';
wwv_flow_api.g_varchar2_table(218) := '20747275650A202020202020202020207D293B0A2020202020202020202073686F7274637574436F756E746572203D2073686F7274637574436F756E746572202B20313B0A20202020202020207D0A0A2020202020202020666F7220287661722069203D';
wwv_flow_api.g_varchar2_table(219) := '20303B2069203C206170657853706F746C696768742E67537461746963496E6465782E6C656E6774683B20692B2B29207B0A2020202020202020202073686F7274637574436F756E746572203D2073686F7274637574436F756E746572202B20313B0A20';
wwv_flow_api.g_varchar2_table(220) := '2020202020202020206966202873686F7274637574436F756E746572203E203929207B0A202020202020202020202020726573756C74732E70757368287B0A20202020202020202020202020206E3A206170657853706F746C696768742E675374617469';
wwv_flow_api.g_varchar2_table(221) := '63496E6465785B695D2E6E2C0A2020202020202020202020202020643A206170657853706F746C696768742E67537461746963496E6465785B695D2E642C0A2020202020202020202020202020753A206170657853706F746C696768742E675374617469';
wwv_flow_api.g_varchar2_table(222) := '63496E6465785B695D2E752C0A2020202020202020202020202020693A206170657853706F746C696768742E67537461746963496E6465785B695D2E692C0A202020202020202020202020202069633A206170657853706F746C696768742E6753746174';
wwv_flow_api.g_varchar2_table(223) := '6963496E6465785B695D2E69632C0A2020202020202020202020202020743A206170657853706F746C696768742E67537461746963496E6465785B695D2E742C0A2020202020202020202020202020733A206170657853706F746C696768742E67537461';
wwv_flow_api.g_varchar2_table(224) := '746963496E6465785B695D2E730A2020202020202020202020207D293B0A202020202020202020207D20656C7365207B0A202020202020202020202020726573756C74732E70757368287B0A20202020202020202020202020206E3A206170657853706F';
wwv_flow_api.g_varchar2_table(225) := '746C696768742E67537461746963496E6465785B695D2E6E2C0A2020202020202020202020202020643A206170657853706F746C696768742E67537461746963496E6465785B695D2E642C0A2020202020202020202020202020753A206170657853706F';
wwv_flow_api.g_varchar2_table(226) := '746C696768742E67537461746963496E6465785B695D2E752C0A2020202020202020202020202020693A206170657853706F746C696768742E67537461746963496E6465785B695D2E692C0A202020202020202020202020202069633A20617065785370';
wwv_flow_api.g_varchar2_table(227) := '6F746C696768742E67537461746963496E6465785B695D2E69632C0A2020202020202020202020202020743A206170657853706F746C696768742E67537461746963496E6465785B695D2E742C0A2020202020202020202020202020733A206170657853';
wwv_flow_api.g_varchar2_table(228) := '706F746C696768742E67537461746963496E6465785B695D2E732C0A202020202020202020202020202073686F72746375743A20274374726C202B2027202B2073686F7274637574436F756E7465720A2020202020202020202020207D293B0A20202020';
wwv_flow_api.g_varchar2_table(229) := '2020202020207D0A20202020202020207D0A0A202020202020202072657475726E20726573756C74733B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A20536561726368204E617669676174696F6E0A202020202020202A204070';
wwv_flow_api.g_varchar2_table(230) := '6172616D207B61727261797D207061747465726E730A202020202020202A2F0A2020202020207365617263684E61763A2066756E6374696F6E287061747465726E7329207B0A2020202020202020766172206E6176526573756C7473203D205B5D2C0A20';
wwv_flow_api.g_varchar2_table(231) := '202020202020202020686173526573756C7473203D2066616C73652C0A202020202020202020207061747465726E2C0A202020202020202020207061747465726E4C656E677468203D207061747465726E732E6C656E6774682C0A202020202020202020';
wwv_flow_api.g_varchar2_table(232) := '20693B0A0A2020202020202020766172206E6172726F776564536574203D2066756E6374696F6E2829207B0A2020202020202020202072657475726E20686173526573756C7473203F206E6176526573756C7473203A206170657853706F746C69676874';
wwv_flow_api.g_varchar2_table(233) := '2E67536561726368496E6465783B0A20202020202020207D3B0A0A20202020202020207661722067657453636F7265203D2066756E6374696F6E28706F732C20776F726473436F756E742C2066756C6C54787429207B0A20202020202020202020766172';
wwv_flow_api.g_varchar2_table(234) := '2073636F7265203D203130302C0A202020202020202020202020737061636573203D20776F726473436F756E74202D20312C0A202020202020202020202020706F736974696F6E4F6657686F6C654B6579776F7264733B0A0A2020202020202020202069';
wwv_flow_api.g_varchar2_table(235) := '662028706F73203D3D3D203020262620737061636573203D3D3D203029207B0A2020202020202020202020202F2F2070657266656374206D617463682028206D6174636865642066726F6D20746865206669727374206C65747465722077697468206E6F';
wwv_flow_api.g_varchar2_table(236) := '20737061636520290A20202020202020202020202072657475726E2073636F72653B0A202020202020202020207D20656C7365207B0A2020202020202020202020202F2F207768656E20736561726368202773716C2063272C202753514C20436F6D6D61';
wwv_flow_api.g_varchar2_table(237) := '6E6473272073686F756C642073636F726520686967686572207468616E202753514C2053637269707473270A2020202020202020202020202F2F207768656E207365617263682027736372697074272C202753637269707420506C616E6E657227207368';
wwv_flow_api.g_varchar2_table(238) := '6F756C642073636F726520686967686572207468616E202753514C2053637269707473270A202020202020202020202020706F736974696F6E4F6657686F6C654B6579776F726473203D2066756C6C5478742E696E6465784F66286170657853706F746C';
wwv_flow_api.g_varchar2_table(239) := '696768742E674B6579776F726473293B0A20202020202020202020202069662028706F736974696F6E4F6657686F6C654B6579776F726473203D3D3D202D3129207B0A202020202020202020202020202073636F7265203D2073636F7265202D20706F73';
wwv_flow_api.g_varchar2_table(240) := '202D20737061636573202D20776F726473436F756E743B0A2020202020202020202020207D20656C7365207B0A202020202020202020202020202073636F7265203D2073636F7265202D20706F736974696F6E4F6657686F6C654B6579776F7264733B0A';
wwv_flow_api.g_varchar2_table(241) := '2020202020202020202020207D0A202020202020202020207D0A0A2020202020202020202072657475726E2073636F72653B0A20202020202020207D3B0A0A2020202020202020666F72202869203D20303B2069203C207061747465726E732E6C656E67';
wwv_flow_api.g_varchar2_table(242) := '74683B20692B2B29207B0A202020202020202020207061747465726E203D207061747465726E735B695D3B0A0A202020202020202020206E6176526573756C7473203D206E6172726F77656453657428290A2020202020202020202020202E66696C7465';
wwv_flow_api.g_varchar2_table(243) := '722866756E6374696F6E28656C656D2C20696E64657829207B0A2020202020202020202020202020766172206E616D65203D20656C656D2E6E2E746F4C6F7765724361736528292C0A20202020202020202020202020202020776F726473436F756E7420';
wwv_flow_api.g_varchar2_table(244) := '3D206E616D652E73706C697428272027292E6C656E6774682C0A20202020202020202020202020202020706F736974696F6E203D206E616D652E736561726368287061747465726E293B0A0A202020202020202020202020202069662028706174746572';
wwv_flow_api.g_varchar2_table(245) := '6E4C656E677468203E20776F726473436F756E7429207B0A202020202020202020202020202020202F2F206B6579776F72647320636F6E7461696E73206D6F726520776F726473207468616E20737472696E6720746F2062652073656172636865640A20';
wwv_flow_api.g_varchar2_table(246) := '20202020202020202020202020202072657475726E2066616C73653B0A20202020202020202020202020207D0A0A202020202020202020202020202069662028706F736974696F6E203E202D3129207B0A20202020202020202020202020202020656C65';
wwv_flow_api.g_varchar2_table(247) := '6D2E73636F7265203D2067657453636F726528706F736974696F6E2C20776F726473436F756E742C206E616D65293B0A2020202020202020202020202020202072657475726E20747275653B0A20202020202020202020202020207D20656C7365206966';
wwv_flow_api.g_varchar2_table(248) := '2028656C656D2E7429207B202F2F20746F6B656E73202873686F7274206465736372697074696F6E20666F72206E617620656E74726965732E290A2020202020202020202020202020202069662028656C656D2E742E736561726368287061747465726E';
wwv_flow_api.g_varchar2_table(249) := '29203E202D3129207B0A202020202020202020202020202020202020656C656D2E73636F7265203D20313B0A20202020202020202020202020202020202072657475726E20747275653B0A202020202020202020202020202020207D0A20202020202020';
wwv_flow_api.g_varchar2_table(250) := '202020202020207D0A0A2020202020202020202020207D290A2020202020202020202020202E736F72742866756E6374696F6E28612C206229207B0A202020202020202020202020202072657475726E20622E73636F7265202D20612E73636F72653B0A';
wwv_flow_api.g_varchar2_table(251) := '2020202020202020202020207D293B0A0A20202020202020202020686173526573756C7473203D20747275653B0A20202020202020207D0A0A202020202020202076617220666F726D61744E6176526573756C7473203D2066756E6374696F6E28726573';
wwv_flow_api.g_varchar2_table(252) := '29207B0A20202020202020202020766172206F7574203D2027272C0A202020202020202020202020692C0A2020202020202020202020206974656D2C0A202020202020202020202020747970652C0A20202020202020202020202073686F72746375742C';
wwv_flow_api.g_varchar2_table(253) := '0A20202020202020202020202069636F6E2C0A20202020202020202020202069636F6E436F6C6F722C0A2020202020202020202020207374617469632C0A202020202020202020202020656E747279203D207B7D3B0A0A20202020202020202020696620';
wwv_flow_api.g_varchar2_table(254) := '287265732E6C656E677468203E206170657853706F746C696768742E674D61784E6176526573756C7429207B0A2020202020202020202020207265732E6C656E677468203D206170657853706F746C696768742E674D61784E6176526573756C743B0A20';
wwv_flow_api.g_varchar2_table(255) := '2020202020202020207D0A0A20202020202020202020666F72202869203D20303B2069203C207265732E6C656E6774683B20692B2B29207B0A2020202020202020202020206974656D203D207265735B695D3B0A0A20202020202020202020202073686F';
wwv_flow_api.g_varchar2_table(256) := '7274637574203D206974656D2E73686F72746375743B0A20202020202020202020202074797065203D206974656D2E74207C7C206170657853706F746C696768742E55524C5F54595045532E72656469726563743B0A2020202020202020202020206963';
wwv_flow_api.g_varchar2_table(257) := '6F6E203D206974656D2E69207C7C206170657853706F746C696768742E49434F4E532E7365617263683B0A202020202020202020202020737461746963203D206974656D2E73207C7C2066616C73653B0A20202020202020202020202069662028697465';
wwv_flow_api.g_varchar2_table(258) := '6D2E696320213D3D202744454641554C542729207B0A202020202020202020202020202069636F6E436F6C6F72203D206974656D2E69633B0A2020202020202020202020207D0A0A202020202020202020202020656E747279203D207B0A202020202020';
wwv_flow_api.g_varchar2_table(259) := '20202020202020207469746C653A206974656D2E6E2C0A2020202020202020202020202020646573633A206974656D2E642C0A202020202020202020202020202075726C3A206974656D2E752C0A202020202020202020202020202069636F6E3A206963';
wwv_flow_api.g_varchar2_table(260) := '6F6E2C0A202020202020202020202020202069636F6E436F6C6F723A2069636F6E436F6C6F722C0A2020202020202020202020202020747970653A20747970652C0A20202020202020202020202020207374617469633A207374617469630A2020202020';
wwv_flow_api.g_varchar2_table(261) := '202020202020207D3B0A0A2020202020202020202020206966202873686F727463757429207B0A2020202020202020202020202020656E7472792E73686F7274637574203D2073686F72746375743B0A2020202020202020202020207D0A0A2020202020';
wwv_flow_api.g_varchar2_table(262) := '202020202020206F7574203D206F7574202B206170657853706F746C696768742E6765744D61726B757028656E747279293B0A202020202020202020207D0A2020202020202020202072657475726E206F75743B0A20202020202020207D3B0A20202020';
wwv_flow_api.g_varchar2_table(263) := '2020202072657475726E20666F726D61744E6176526573756C7473286170657853706F746C696768742E726573756C74734164644F6E73286E6176526573756C747329293B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A205365';
wwv_flow_api.g_varchar2_table(264) := '617263680A202020202020202A2040706172616D207B737472696E677D206B0A202020202020202A2F0A2020202020207365617263683A2066756E6374696F6E286B29207B0A2020202020202020766172205052454649585F454E545259203D20277370';
wwv_flow_api.g_varchar2_table(265) := '2D726573756C742D273B0A20202020202020202F2F2073746F7265206B6579776F7264730A20202020202020206170657853706F746C696768742E674B6579776F726473203D206B2E7472696D28293B0A0A202020202020202076617220776F72647320';
wwv_flow_api.g_varchar2_table(266) := '3D206170657853706F746C696768742E674B6579776F7264732E73706C697428272027292C0A2020202020202020202072657324203D2024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F524553554C54';
wwv_flow_api.g_varchar2_table(267) := '53292C0A202020202020202020207061747465726E73203D205B5D2C0A202020202020202020206E61764F757075742C0A20202020202020202020693B0A2020202020202020666F72202869203D20303B2069203C20776F7264732E6C656E6774683B20';
wwv_flow_api.g_varchar2_table(268) := '692B2B29207B0A202020202020202020202F2F2073746F7265206B65797320696E20617272617920746F20737570706F727420737061636520696E206B6579776F72647320666F72206E617669676174696F6E20656E74726965732C0A20202020202020';
wwv_flow_api.g_varchar2_table(269) := '2020202F2F20652E672E20277374612066272066696E64732027537461746963204170706C69636174696F6E2046696C6573270A202020202020202020207061747465726E732E70757368286E65772052656745787028617065782E7574696C2E657363';
wwv_flow_api.g_varchar2_table(270) := '61706552656745787028776F7264735B695D292C202767692729293B0A20202020202020207D0A0A20202020202020206E61764F75707574203D206170657853706F746C696768742E7365617263684E6176287061747465726E73293B0A0A2020202020';
wwv_flow_api.g_varchar2_table(271) := '2020202428272327202B206170657853706F746C696768742E53505F4C495354290A202020202020202020202E68746D6C286E61764F75707574290A202020202020202020202E66696E6428276C6927290A202020202020202020202E65616368286675';
wwv_flow_api.g_varchar2_table(272) := '6E6374696F6E286929207B0A202020202020202020202020766172207468617424203D20242874686973293B0A20202020202020202020202074686174240A20202020202020202020202020202E66696E64286170657853706F746C696768742E444F54';
wwv_flow_api.g_varchar2_table(273) := '202B206170657853706F746C696768742E53505F524553554C545F4C4142454C290A20202020202020202020202020202E6174747228276964272C205052454649585F454E545259202B2069293B202F2F20666F72206163636573736962696C6974790A';
wwv_flow_api.g_varchar2_table(274) := '202020202020202020207D290A202020202020202020202E666972737428290A202020202020202020202E616464436C617373286170657853706F746C696768742E53505F414354495645293B0A2020202020207D2C0A2020202020202F2A2A0A202020';
wwv_flow_api.g_varchar2_table(275) := '202020202A2043726561746573207468652073706F746C69676874206469616C6F67206D61726B75700A202020202020202A2040706172616D207B737472696E677D2070506C616365486F6C6465720A202020202020202A2F0A20202020202063726561';
wwv_flow_api.g_varchar2_table(276) := '746553706F746C696768744469616C6F673A2066756E6374696F6E2870506C616365486F6C64657229207B0A2020202020202020766172206372656174654469616C6F67203D2066756E6374696F6E2829207B0A20202020202020202020766172207669';
wwv_flow_api.g_varchar2_table(277) := '65774865696768742C0A2020202020202020202020206C696E654865696768742C0A20202020202020202020202076696577546F702C0A202020202020202020202020726F7773506572566965773B0A0A2020202020202020202076617220696E697448';
wwv_flow_api.g_varchar2_table(278) := '656967687473203D2066756E6374696F6E2829207B0A2020202020202020202020206966202824286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F47292E6C656E677468203E203029207B0A20';
wwv_flow_api.g_varchar2_table(279) := '202020202020202020202020207661722076696577546F7024203D202428276469762E6170782D53706F746C696768742D726573756C747327293B0A202020202020202020202020202076696577486569676874203D2076696577546F70242E6F757465';
wwv_flow_api.g_varchar2_table(280) := '7248656967687428293B0A20202020202020202020202020206C696E65486569676874203D202428276C692E6170782D53706F746C696768742D726573756C7427292E6F7574657248656967687428293B0A202020202020202020202020202076696577';
wwv_flow_api.g_varchar2_table(281) := '546F70203D2076696577546F70242E6F666673657428292E746F703B0A2020202020202020202020202020726F777350657256696577203D202876696577486569676874202F206C696E65486569676874293B0A2020202020202020202020207D0A2020';
wwv_flow_api.g_varchar2_table(282) := '20202020202020207D3B0A0A20202020202020202020766172207363726F6C6C6564446F776E4F75744F6656696577203D2066756E6374696F6E28656C656D2429207B0A20202020202020202020202069662028656C656D245B305D29207B0A20202020';
wwv_flow_api.g_varchar2_table(283) := '2020202020202020202076617220746F70203D20656C656D242E6F666673657428292E746F703B0A202020202020202020202020202069662028746F70203C203029207B0A2020202020202020202020202020202072657475726E20747275653B202F2F';
wwv_flow_api.g_varchar2_table(284) := '207363726F6C6C2062617220776173207573656420746F2067657420616374697665206974656D206F7574206F6620766965770A20202020202020202020202020207D20656C7365207B0A2020202020202020202020202020202072657475726E20746F';
wwv_flow_api.g_varchar2_table(285) := '70203E20766965774865696768743B0A20202020202020202020202020207D0A2020202020202020202020207D0A202020202020202020207D3B0A0A20202020202020202020766172207363726F6C6C656455704F75744F6656696577203D2066756E63';
wwv_flow_api.g_varchar2_table(286) := '74696F6E28656C656D2429207B0A20202020202020202020202069662028656C656D245B305D29207B0A202020202020202020202020202076617220746F70203D20656C656D242E6F666673657428292E746F703B0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(287) := '69662028746F70203E207669657748656967687429207B0A2020202020202020202020202020202072657475726E20747275653B202F2F207363726F6C6C2062617220776173207573656420746F2067657420616374697665206974656D206F7574206F';
wwv_flow_api.g_varchar2_table(288) := '6620766965770A20202020202020202020202020207D20656C7365207B0A2020202020202020202020202020202072657475726E20746F70203C3D2076696577546F703B0A20202020202020202020202020207D0A2020202020202020202020207D0A20';
wwv_flow_api.g_varchar2_table(289) := '2020202020202020207D3B0A0A202020202020202020202F2F206B6579626F61726420555020616E6420444F574E20737570706F727420746F20676F207468726F75676820726573756C74730A20202020202020202020766172206765744E657874203D';
wwv_flow_api.g_varchar2_table(290) := '2066756E6374696F6E287265732429207B0A2020202020202020202020207661722063757272656E7424203D20726573242E66696E64286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F414354495645292C';
wwv_flow_api.g_varchar2_table(291) := '0A202020202020202020202020202073657175656E6365203D2063757272656E74242E696E64657828292C0A20202020202020202020202020206E657874243B0A2020202020202020202020206966202821726F77735065725669657729207B0A202020';
wwv_flow_api.g_varchar2_table(292) := '2020202020202020202020696E69744865696768747328293B0A2020202020202020202020207D0A0A202020202020202020202020696620282163757272656E74242E6C656E677468207C7C2063757272656E74242E697328273A6C6173742D6368696C';
wwv_flow_api.g_varchar2_table(293) := '64272929207B0A20202020202020202020202020202F2F2048697420626F74746F6D2C207363726F6C6C20746F20746F700A202020202020202020202020202063757272656E74242E72656D6F7665436C617373286170657853706F746C696768742E53';
wwv_flow_api.g_varchar2_table(294) := '505F414354495645293B0A2020202020202020202020202020726573242E66696E6428276C6927292E666972737428292E616464436C617373286170657853706F746C696768742E53505F414354495645293B0A20202020202020202020202020207265';
wwv_flow_api.g_varchar2_table(295) := '73242E616E696D617465287B0A202020202020202020202020202020207363726F6C6C546F703A20300A20202020202020202020202020207D293B0A2020202020202020202020207D20656C7365207B0A20202020202020202020202020206E65787424';
wwv_flow_api.g_varchar2_table(296) := '203D2063757272656E74242E72656D6F7665436C617373286170657853706F746C696768742E53505F414354495645292E6E65787428292E616464436C617373286170657853706F746C696768742E53505F414354495645293B0A202020202020202020';
wwv_flow_api.g_varchar2_table(297) := '2020202020696620287363726F6C6C6564446F776E4F75744F6656696577286E657874242929207B0A20202020202020202020202020202020726573242E616E696D617465287B0A2020202020202020202020202020202020207363726F6C6C546F703A';
wwv_flow_api.g_varchar2_table(298) := '202873657175656E6365202D20726F777350657256696577202B203229202A206C696E654865696768740A202020202020202020202020202020207D2C2030293B0A20202020202020202020202020207D0A2020202020202020202020207D0A20202020';
wwv_flow_api.g_varchar2_table(299) := '2020202020207D3B0A0A202020202020202020207661722067657450726576203D2066756E6374696F6E287265732429207B0A2020202020202020202020207661722063757272656E7424203D20726573242E66696E64286170657853706F746C696768';
wwv_flow_api.g_varchar2_table(300) := '742E444F54202B206170657853706F746C696768742E53505F414354495645292C0A202020202020202020202020202073657175656E6365203D2063757272656E74242E696E64657828292C0A202020202020202020202020202070726576243B0A0A20';
wwv_flow_api.g_varchar2_table(301) := '20202020202020202020206966202821726F77735065725669657729207B0A2020202020202020202020202020696E69744865696768747328293B0A2020202020202020202020207D0A0A2020202020202020202020206966202821726573242E6C656E';
wwv_flow_api.g_varchar2_table(302) := '677468207C7C2063757272656E74242E697328273A66697273742D6368696C64272929207B0A20202020202020202020202020202F2F2048697420746F702C207363726F6C6C20746F20626F74746F6D0A20202020202020202020202020206375727265';
wwv_flow_api.g_varchar2_table(303) := '6E74242E72656D6F7665436C617373286170657853706F746C696768742E53505F414354495645293B0A2020202020202020202020202020726573242E66696E6428276C6927292E6C61737428292E616464436C617373286170657853706F746C696768';
wwv_flow_api.g_varchar2_table(304) := '742E53505F414354495645293B0A2020202020202020202020202020726573242E616E696D617465287B0A202020202020202020202020202020207363726F6C6C546F703A20726573242E66696E6428276C6927292E6C656E677468202A206C696E6548';
wwv_flow_api.g_varchar2_table(305) := '65696768740A20202020202020202020202020207D293B0A2020202020202020202020207D20656C7365207B0A20202020202020202020202020207072657624203D2063757272656E74242E72656D6F7665436C617373286170657853706F746C696768';
wwv_flow_api.g_varchar2_table(306) := '742E53505F414354495645292E7072657628292E616464436C617373286170657853706F746C696768742E53505F414354495645293B0A2020202020202020202020202020696620287363726F6C6C656455704F75744F66566965772870726576242929';
wwv_flow_api.g_varchar2_table(307) := '207B0A20202020202020202020202020202020726573242E616E696D617465287B0A2020202020202020202020202020202020207363726F6C6C546F703A202873657175656E6365202D203129202A206C696E654865696768740A202020202020202020';
wwv_flow_api.g_varchar2_table(308) := '202020202020207D2C2030293B0A20202020202020202020202020207D0A2020202020202020202020207D0A202020202020202020207D3B0A0A20202020202020202020242877696E646F77292E6F6E28276170657877696E646F77726573697A656427';
wwv_flow_api.g_varchar2_table(309) := '2C2066756E6374696F6E2829207B0A202020202020202020202020696E69744865696768747328293B0A202020202020202020207D293B0A0A20202020202020202020242827626F647927290A2020202020202020202020202E617070656E64280A2020';
wwv_flow_api.g_varchar2_table(310) := '202020202020202020202020273C64697620636C6173733D2227202B206170657853706F746C696768742E53505F4449414C4F47202B20272220646174612D69643D2227202B206170657853706F746C696768742E6744796E616D6963416374696F6E49';
wwv_flow_api.g_varchar2_table(311) := '64202B2027223E27202B0A2020202020202020202020202020273C64697620636C6173733D226170782D53706F746C696768742D626F6479223E27202B0A2020202020202020202020202020273C64697620636C6173733D226170782D53706F746C6967';
wwv_flow_api.g_varchar2_table(312) := '68742D736561726368223E27202B0A2020202020202020202020202020273C64697620636C6173733D226170782D53706F746C696768742D69636F6E206170782D53706F746C696768742D69636F6E2D6D61696E223E27202B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(313) := '20202020273C7370616E20636C6173733D2227202B206170657853706F746C696768742E67506C616365486F6C64657249636F6E202B20272220617269612D68696464656E3D2274727565223E3C2F7370616E3E27202B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(314) := '2020273C2F6469763E27202B0A2020202020202020202020202020273C64697620636C6173733D226170782D53706F746C696768742D6669656C64223E27202B0A2020202020202020202020202020273C696E70757420747970653D2274657874222072';
wwv_flow_api.g_varchar2_table(315) := '6F6C653D22636F6D626F626F782220617269612D657870616E6465643D2266616C73652220617269612D6175746F636F6D706C6574653D226E6F6E652220617269612D686173706F7075703D22747275652220617269612D6C6162656C3D2253706F746C';
wwv_flow_api.g_varchar2_table(316) := '69676874205365617263682220617269612D6F776E733D2227202B206170657853706F746C696768742E53505F4C495354202B202722206175746F636F6D706C6574653D226F666622206175746F636F72726563743D226F666622207370656C6C636865';
wwv_flow_api.g_varchar2_table(317) := '636B3D2266616C73652220636C6173733D2227202B206170657853706F746C696768742E53505F494E505554202B20272220706C616365686F6C6465723D2227202B2070506C616365486F6C646572202B2027223E27202B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(318) := '202020273C2F6469763E27202B0A2020202020202020202020202020273C64697620726F6C653D22726567696F6E2220636C6173733D22752D56697375616C6C7948696464656E2220617269612D6C6976653D22706F6C697465222069643D2227202B20';
wwv_flow_api.g_varchar2_table(319) := '6170657853706F746C696768742E53505F4C4956455F524547494F4E202B2027223E3C2F6469763E27202B0A2020202020202020202020202020273C2F6469763E27202B0A2020202020202020202020202020273C64697620636C6173733D2227202B20';
wwv_flow_api.g_varchar2_table(320) := '6170657853706F746C696768742E53505F524553554C5453202B2027223E27202B0A2020202020202020202020202020273C756C20636C6173733D226170782D53706F746C696768742D726573756C74734C697374222069643D2227202B206170657853';
wwv_flow_api.g_varchar2_table(321) := '706F746C696768742E53505F4C495354202B20272220746162696E6465783D222D312220726F6C653D226C697374626F78223E3C2F756C3E27202B0A2020202020202020202020202020273C2F6469763E27202B0A202020202020202020202020202027';
wwv_flow_api.g_varchar2_table(322) := '3C2F6469763E27202B0A2020202020202020202020202020273C2F6469763E270A202020202020202020202020290A2020202020202020202020202E6F6E2827696E707574272C206170657853706F746C696768742E444F54202B206170657853706F74';
wwv_flow_api.g_varchar2_table(323) := '6C696768742E53505F494E5055542C2066756E6374696F6E2829207B0A20202020202020202020202020207661722076203D20242874686973292E76616C28292E7472696D28292C0A202020202020202020202020202020206C656E203D20762E6C656E';
wwv_flow_api.g_varchar2_table(324) := '6774683B0A0A2020202020202020202020202020696620286C656E203D3D3D203029207B0A202020202020202020202020202020206170657853706F746C696768742E726573657453706F746C6967687428293B202F2F20636C65617273206576657279';
wwv_flow_api.g_varchar2_table(325) := '7468696E67207768656E206B6579776F72642069732072656D6F7665642E0A20202020202020202020202020207D20656C736520696620286C656E203E2031207C7C202169734E614E28762929207B0A202020202020202020202020202020202F2F2073';
wwv_flow_api.g_varchar2_table(326) := '6561726368207265717569726573206D6F7265207468616E206F6E65206368617261637465722C206F722069742069732061206E756D6265722E0A20202020202020202020202020202020696620287620213D3D206170657853706F746C696768742E67';
wwv_flow_api.g_varchar2_table(327) := '4B6579776F72647329207B0A2020202020202020202020202020202020206170657853706F746C696768742E7365617263682876293B0A202020202020202020202020202020207D0A20202020202020202020202020207D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(328) := '207D290A2020202020202020202020202E6F6E28276B6579646F776E272C206170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F472C2066756E6374696F6E286529207B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(329) := '2020202076617220726573756C747324203D2024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F524553554C5453292C0A202020202020202020202020202020206C61737439526573756C74732C0A2020';
wwv_flow_api.g_varchar2_table(330) := '202020202020202020202020202073686F72746375744E756D6265723B0A0A20202020202020202020202020202F2F2075702F646F776E206172726F77730A20202020202020202020202020207377697463682028652E776869636829207B0A20202020';
wwv_flow_api.g_varchar2_table(331) := '20202020202020202020202063617365206170657853706F746C696768742E4B4559532E444F574E3A0A202020202020202020202020202020202020652E70726576656E7444656661756C7428293B0A2020202020202020202020202020202020206765';
wwv_flow_api.g_varchar2_table(332) := '744E65787428726573756C747324293B0A202020202020202020202020202020202020627265616B3B0A0A2020202020202020202020202020202063617365206170657853706F746C696768742E4B4559532E55503A0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(333) := '2020202020652E70726576656E7444656661756C7428293B0A2020202020202020202020202020202020206765745072657628726573756C747324293B0A202020202020202020202020202020202020627265616B3B0A0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(334) := '2020202063617365206170657853706F746C696768742E4B4559532E454E5445523A0A202020202020202020202020202020202020652E70726576656E7444656661756C7428293B202F2F20646F6E2774207375626D6974206F6E20656E7465720A2020';
wwv_flow_api.g_varchar2_table(335) := '20202020202020202020202020202020696620286170657853706F746C696768742E67456E61626C65536561726368486973746F727929207B0A20202020202020202020202020202020202020206170657853706F746C696768742E73657453706F746C';
wwv_flow_api.g_varchar2_table(336) := '69676874486973746F72794C6F63616C53746F726167652824286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E76616C2829293B0A2020202020202020202020202020202020207D0A2020';
wwv_flow_api.g_varchar2_table(337) := '202020202020202020202020202020206170657853706F746C696768742E676F546F28726573756C7473242E66696E6428276C692E69732D616374697665207370616E27292C2065293B0A202020202020202020202020202020202020627265616B3B0A';
wwv_flow_api.g_varchar2_table(338) := '2020202020202020202020202020202063617365206170657853706F746C696768742E4B4559532E5441423A0A2020202020202020202020202020202020206170657853706F746C696768742E636C6F73654469616C6F6728293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(339) := '20202020202020202020627265616B3B0A20202020202020202020202020207D0A0A202020202020202020202020202069662028652E6374726C4B657929207B0A202020202020202020202020202020202F2F20737570706F727473204374726C202B20';
wwv_flow_api.g_varchar2_table(340) := '312C20322C20332C20342C20352C20362C20372C20382C20392073686F7274637574730A202020202020202020202020202020206C61737439526573756C7473203D20726573756C7473242E66696E64286170657853706F746C696768742E444F54202B';
wwv_flow_api.g_varchar2_table(341) := '206170657853706F746C696768742E53505F53484F5254435554292E706172656E7428292E67657428293B0A202020202020202020202020202020207377697463682028652E776869636829207B0A202020202020202020202020202020202020636173';
wwv_flow_api.g_varchar2_table(342) := '652034393A202F2F204374726C202B20310A202020202020202020202020202020202020202073686F72746375744E756D626572203D20313B0A2020202020202020202020202020202020202020627265616B3B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(343) := '202020636173652035303A202F2F204374726C202B20320A202020202020202020202020202020202020202073686F72746375744E756D626572203D20323B0A2020202020202020202020202020202020202020627265616B3B0A0A2020202020202020';
wwv_flow_api.g_varchar2_table(344) := '20202020202020202020636173652035313A202F2F204374726C202B20330A202020202020202020202020202020202020202073686F72746375744E756D626572203D20333B0A2020202020202020202020202020202020202020627265616B3B0A0A20';
wwv_flow_api.g_varchar2_table(345) := '2020202020202020202020202020202020636173652035323A202F2F204374726C202B20340A202020202020202020202020202020202020202073686F72746375744E756D626572203D20343B0A20202020202020202020202020202020202020206272';
wwv_flow_api.g_varchar2_table(346) := '65616B3B0A0A202020202020202020202020202020202020636173652035333A202F2F204374726C202B20350A202020202020202020202020202020202020202073686F72746375744E756D626572203D20353B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(347) := '2020202020627265616B3B0A0A202020202020202020202020202020202020636173652035343A202F2F204374726C202B20360A202020202020202020202020202020202020202073686F72746375744E756D626572203D20363B0A2020202020202020';
wwv_flow_api.g_varchar2_table(348) := '202020202020202020202020627265616B3B0A0A202020202020202020202020202020202020636173652035353A202F2F204374726C202B20370A202020202020202020202020202020202020202073686F72746375744E756D626572203D20373B0A20';
wwv_flow_api.g_varchar2_table(349) := '20202020202020202020202020202020202020627265616B3B0A0A202020202020202020202020202020202020636173652035363A202F2F204374726C202B20380A202020202020202020202020202020202020202073686F72746375744E756D626572';
wwv_flow_api.g_varchar2_table(350) := '203D20383B0A2020202020202020202020202020202020202020627265616B3B0A0A202020202020202020202020202020202020636173652035373A202F2F204374726C202B20390A202020202020202020202020202020202020202073686F72746375';
wwv_flow_api.g_varchar2_table(351) := '744E756D626572203D20393B0A2020202020202020202020202020202020202020627265616B3B0A202020202020202020202020202020207D0A0A202020202020202020202020202020206966202873686F72746375744E756D62657229207B0A202020';
wwv_flow_api.g_varchar2_table(352) := '2020202020202020202020202020206170657853706F746C696768742E676F546F2824286C61737439526573756C74735B73686F72746375744E756D626572202D20315D292C2065293B0A202020202020202020202020202020207D0A20202020202020';
wwv_flow_api.g_varchar2_table(353) := '202020202020207D0A0A20202020202020202020202020202F2F205368696674202B2054616220746F20636C6F736520616E6420666F63757320676F6573206261636B20746F207768657265206974207761732E0A202020202020202020202020202069';
wwv_flow_api.g_varchar2_table(354) := '662028652E73686966744B657929207B0A2020202020202020202020202020202069662028652E7768696368203D3D3D206170657853706F746C696768742E4B4559532E54414229207B0A2020202020202020202020202020202020206170657853706F';
wwv_flow_api.g_varchar2_table(355) := '746C696768742E636C6F73654469616C6F6728293B0A202020202020202020202020202020207D0A20202020202020202020202020207D0A0A20202020202020202020202020206170657853706F746C696768742E68616E646C65417269614174747228';
wwv_flow_api.g_varchar2_table(356) := '293B0A0A2020202020202020202020207D290A2020202020202020202020202E6F6E2827636C69636B272C20277370616E2E6170782D53706F746C696768742D6C696E6B272C2066756E6374696F6E286529207B0A202020202020202020202020202069';
wwv_flow_api.g_varchar2_table(357) := '6620286170657853706F746C696768742E67456E61626C65536561726368486973746F727929207B0A202020202020202020202020202020206170657853706F746C696768742E73657453706F746C69676874486973746F72794C6F63616C53746F7261';
wwv_flow_api.g_varchar2_table(358) := '67652824286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E76616C2829293B0A20202020202020202020202020207D0A20202020202020202020202020206170657853706F746C69676874';
wwv_flow_api.g_varchar2_table(359) := '2E676F546F28242874686973292C2065293B0A2020202020202020202020207D290A2020202020202020202020202E6F6E28276D6F7573656D6F7665272C20276C692E6170782D53706F746C696768742D726573756C74272C2066756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(360) := '207B0A202020202020202020202020202076617220686967686C6967687424203D20242874686973293B0A2020202020202020202020202020686967686C69676874240A202020202020202020202020202020202E706172656E7428290A202020202020';
wwv_flow_api.g_varchar2_table(361) := '202020202020202020202E66696E64286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F414354495645290A202020202020202020202020202020202E72656D6F7665436C617373286170657853706F746C69';
wwv_flow_api.g_varchar2_table(362) := '6768742E53505F414354495645293B0A0A2020202020202020202020202020686967686C69676874242E616464436C617373286170657853706F746C696768742E53505F414354495645293B0A20202020202020202020202020202F2F2068616E646C65';
wwv_flow_api.g_varchar2_table(363) := '417269614174747228293B0A2020202020202020202020207D290A2020202020202020202020202E6F6E2827626C7572272C206170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F472C2066756E63';
wwv_flow_api.g_varchar2_table(364) := '74696F6E286529207B0A20202020202020202020202020202F2F20646F6E277420646F2074686973206966206469616C6F6720697320636C6F7365642F636C6F73696E670A20202020202020202020202020206966202824286170657853706F746C6967';
wwv_flow_api.g_varchar2_table(365) := '68742E444F54202B206170657853706F746C696768742E53505F4449414C4F47292E6469616C6F67282269734F70656E222929207B0A202020202020202020202020202020202F2F20696E7075742074616B657320666F637573206469616C6F67206C6F';
wwv_flow_api.g_varchar2_table(366) := '73657320666F63757320746F207363726F6C6C206261720A2020202020202020202020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E666F63757328293B0A2020202020';
wwv_flow_api.g_varchar2_table(367) := '2020202020202020207D0A2020202020202020202020207D293B0A0A202020202020202020202F2F20457363617065206B65792070726573736564206F6E63652C20636C656172206669656C642C2074776963652C20636C6F7365206469616C6F672E0A';
wwv_flow_api.g_varchar2_table(368) := '2020202020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F47292E6F6E28276B6579646F776E272C2066756E6374696F6E286529207B0A202020202020202020202020766172';
wwv_flow_api.g_varchar2_table(369) := '20696E70757424203D2024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554293B0A20202020202020202020202069662028652E7768696368203D3D3D206170657853706F746C696768742E4B';
wwv_flow_api.g_varchar2_table(370) := '4559532E45534341504529207B0A202020202020202020202020202069662028696E707574242E76616C282929207B0A202020202020202020202020202020206170657853706F746C696768742E726573657453706F746C6967687428293B0A20202020';
wwv_flow_api.g_varchar2_table(371) := '202020202020202020202020652E73746F7050726F7061676174696F6E28293B0A20202020202020202020202020207D20656C7365207B0A202020202020202020202020202020206170657853706F746C696768742E636C6F73654469616C6F6728293B';
wwv_flow_api.g_varchar2_table(372) := '0A20202020202020202020202020207D0A2020202020202020202020207D0A202020202020202020207D293B0A0A202020202020202020206170657853706F746C696768742E674861734469616C6F6743726561746564203D20747275653B0A20202020';
wwv_flow_api.g_varchar2_table(373) := '202020207D3B0A20202020202020206372656174654469616C6F6728293B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A204F70656E2053706F746C69676874204469616C6F670A202020202020202A2040706172616D207B6F62';
wwv_flow_api.g_varchar2_table(374) := '6A6563747D2070466F637573456C656D656E740A202020202020202A2F0A2020202020206F70656E53706F746C696768744469616C6F673A2066756E6374696F6E2870466F637573456C656D656E7429207B0A20202020202020202F2F2044697361626C';
wwv_flow_api.g_varchar2_table(375) := '652053706F746C6967687420666F72204D6F64616C204469616C6F670A2020202020202020696620282877696E646F772E73656C6620213D3D2077696E646F772E746F702929207B0A2020202020202020202072657475726E2066616C73653B0A202020';
wwv_flow_api.g_varchar2_table(376) := '20202020207D0A0A20202020202020206170657853706F746C696768742E674861734469616C6F6743726561746564203D2024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F47292E6C656E';
wwv_flow_api.g_varchar2_table(377) := '677468203E20303B0A0A20202020202020202F2F20696620616C72656164792063726561746564206469616C6F672069732066726F6D20616E6F74686572204441202D2D3E2064657374726F79206578697374696E67206469616C6F670A202020202020';
wwv_flow_api.g_varchar2_table(378) := '2020696620286170657853706F746C696768742E674861734469616C6F674372656174656429207B0A202020202020202020206966202824286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F47';
wwv_flow_api.g_varchar2_table(379) := '292E617474722827646174612D6964272920213D206170657853706F746C696768742E6744796E616D6963416374696F6E496429207B0A2020202020202020202020206170657853706F746C696768742E726573657453706F746C6967687428293B0A20';
wwv_flow_api.g_varchar2_table(380) := '202020202020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F47292E72656D6F766528293B0A2020202020202020202020206170657853706F746C696768742E674861734469';
wwv_flow_api.g_varchar2_table(381) := '616C6F6743726561746564203D2066616C73653B0A202020202020202020207D0A20202020202020207D0A0A20202020202020202F2F207365742073656C6563746564207465787420746F2073706F746C6967687420696E7075740A2020202020202020';
wwv_flow_api.g_varchar2_table(382) := '696620286170657853706F746C696768742E67456E61626C6550726566696C6C53656C65637465645465787429207B0A202020202020202020206170657853706F746C696768742E73657453656C65637465645465787428293B0A20202020202020207D';
wwv_flow_api.g_varchar2_table(383) := '0A0A2020202020202020766172206F70656E4469616C6F67203D2066756E6374696F6E2829207B0A2020202020202020202076617220646C6724203D2024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F';
wwv_flow_api.g_varchar2_table(384) := '4449414C4F47292C0A2020202020202020202020207363726F6C6C59203D2077696E646F772E7363726F6C6C59207C7C2077696E646F772E70616765594F66667365743B0A202020202020202020206966202821646C67242E686173436C617373282775';
wwv_flow_api.g_varchar2_table(385) := '692D6469616C6F672D636F6E74656E742729207C7C2021646C67242E6469616C6F67282269734F70656E222929207B0A202020202020202020202020646C67242E6469616C6F67287B0A202020202020202020202020202077696474683A206170657853';
wwv_flow_api.g_varchar2_table(386) := '706F746C696768742E6757696474682C0A20202020202020202020202020206865696768743A20276175746F272C0A20202020202020202020202020206D6F64616C3A20747275652C0A2020202020202020202020202020706F736974696F6E3A207B0A';
wwv_flow_api.g_varchar2_table(387) := '202020202020202020202020202020206D793A202263656E74657220746F70222C0A2020202020202020202020202020202061743A202263656E74657220746F702B22202B20287363726F6C6C59202B203634292C0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(388) := '20206F663A20242827626F647927290A20202020202020202020202020207D2C0A20202020202020202020202020206469616C6F67436C6173733A202775692D6469616C6F672D2D6170657873706F746C69676874272C0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(389) := '20206F70656E3A2066756E6374696F6E2829207B0A20202020202020202020202020202020617065782E6576656E742E747269676765722827626F6479272C20276170657873706F746C696768742D6F70656E2D6469616C6F6727293B0A0A2020202020';
wwv_flow_api.g_varchar2_table(390) := '202020202020202020202076617220646C6724203D20242874686973293B0A0A20202020202020202020202020202020646C67240A2020202020202020202020202020202020202E63737328276D696E2D686569676874272C20276175746F27290A2020';
wwv_flow_api.g_varchar2_table(391) := '202020202020202020202020202020202E7072657628272E75692D6469616C6F672D7469746C6562617227290A2020202020202020202020202020202020202E72656D6F766528293B0A0A20202020202020202020202020202020617065782E6E617669';
wwv_flow_api.g_varchar2_table(392) := '676174696F6E2E626567696E467265657A655363726F6C6C28293B0A0A202020202020202020202020202020202F2F2073686F7720686973746F727920706F706F7665720A20202020202020202020202020202020696620286170657853706F746C6967';
wwv_flow_api.g_varchar2_table(393) := '68742E67456E61626C65536561726368486973746F727929207B0A2020202020202020202020202020202020206170657853706F746C696768742E73686F775469707079486973746F7279506F706F76657228293B0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(394) := '20207D0A0A202020202020202020202020202020202428272E75692D7769646765742D6F7665726C617927292E6F6E2827636C69636B272C2066756E6374696F6E2829207B0A2020202020202020202020202020202020206170657853706F746C696768';
wwv_flow_api.g_varchar2_table(395) := '742E636C6F73654469616C6F6728293B0A202020202020202020202020202020207D293B0A20202020202020202020202020207D2C0A2020202020202020202020202020636C6F73653A2066756E6374696F6E2829207B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(396) := '20202020617065782E6576656E742E747269676765722827626F6479272C20276170657873706F746C696768742D636C6F73652D6469616C6F6727293B0A202020202020202020202020202020206170657853706F746C696768742E726573657453706F';
wwv_flow_api.g_varchar2_table(397) := '746C6967687428293B0A20202020202020202020202020202020617065782E6E617669676174696F6E2E656E64467265657A655363726F6C6C28293B0A202020202020202020202020202020202F2F2064697374726F7920686973746F727920706F706F';
wwv_flow_api.g_varchar2_table(398) := '7665720A20202020202020202020202020202020696620286170657853706F746C696768742E67456E61626C65536561726368486973746F727929207B0A2020202020202020202020202020202020206170657853706F746C696768742E64657374726F';
wwv_flow_api.g_varchar2_table(399) := '795469707079486973746F7279506F706F76657228293B0A202020202020202020202020202020207D0A20202020202020202020202020207D0A2020202020202020202020207D293B0A202020202020202020207D0A20202020202020207D3B0A0A2020';
wwv_flow_api.g_varchar2_table(400) := '202020202020696620286170657853706F746C696768742E674861734469616C6F674372656174656429207B0A202020202020202020206F70656E4469616C6F6728293B0A20202020202020207D20656C7365207B0A2020202020202020202061706578';
wwv_flow_api.g_varchar2_table(401) := '53706F746C696768742E63726561746553706F746C696768744469616C6F67286170657853706F746C696768742E67506C616365686F6C64657254657874293B0A202020202020202020206F70656E4469616C6F6728293B0A2020202020202020202061';
wwv_flow_api.g_varchar2_table(402) := '70657853706F746C696768742E67657453706F746C69676874446174612866756E6374696F6E286461746129207B0A2020202020202020202020206170657853706F746C696768742E67536561726368496E646578203D20242E6772657028646174612C';
wwv_flow_api.g_varchar2_table(403) := '2066756E6374696F6E286529207B0A202020202020202020202020202072657475726E20652E73203D3D2066616C73653B0A2020202020202020202020207D293B0A2020202020202020202020206170657853706F746C696768742E6753746174696349';
wwv_flow_api.g_varchar2_table(404) := '6E646578203D20242E6772657028646174612C2066756E6374696F6E286529207B0A202020202020202020202020202072657475726E20652E73203D3D20747275653B0A2020202020202020202020207D293B0A20202020202020202020202061706578';
wwv_flow_api.g_varchar2_table(405) := '2E6576656E742E747269676765722827626F6479272C20276170657873706F746C696768742D6765742D64617461272C2064617461293B0A202020202020202020207D293B0A20202020202020207D0A2020202020202020666F637573456C656D656E74';
wwv_flow_api.g_varchar2_table(406) := '203D2070466F637573456C656D656E743B202F2F20636F756C642062652075736566756C20666F722073686F72746375747320616464656420627920617065782E616374696F6E0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A20';
wwv_flow_api.g_varchar2_table(407) := '496E2D5061676520736561726368207573696E67206D61726B2E6A730A202020202020202A2040706172616D207B737472696E677D20704B6579776F72640A202020202020202A2F0A202020202020696E506167655365617263683A2066756E6374696F';
wwv_flow_api.g_varchar2_table(408) := '6E28704B6579776F726429207B0A2020202020202020766172206B6579776F7264203D20704B6579776F7264207C7C206170657853706F746C696768742E674B6579776F7264733B0A2020202020202020242827626F647927292E756E6D61726B287B0A';
wwv_flow_api.g_varchar2_table(409) := '20202020202020202020646F6E653A2066756E6374696F6E2829207B0A2020202020202020202020206170657853706F746C696768742E636C6F73654469616C6F6728293B0A2020202020202020202020206170657853706F746C696768742E72657365';
wwv_flow_api.g_varchar2_table(410) := '7453706F746C6967687428293B0A202020202020202020202020242827626F647927292E6D61726B286B6579776F72642C207B7D293B0A202020202020202020202020617065782E6576656E742E747269676765722827626F6479272C20276170657873';
wwv_flow_api.g_varchar2_table(411) := '706F746C696768742D696E706167652D736561726368272C207B0A2020202020202020202020202020226B6579776F7264223A206B6579776F72640A2020202020202020202020207D293B0A202020202020202020207D0A20202020202020207D293B0A';
wwv_flow_api.g_varchar2_table(412) := '2020202020207D2C0A2020202020202F2A2A0A202020202020202A20436865636B20696620726573756C74736574206D61726B7570206861732064796E616D6963206C69737420656E747269657320286E6F7420737461746963290A202020202020202A';
wwv_flow_api.g_varchar2_table(413) := '204072657475726E207B626F6F6C65616E7D0A202020202020202A2F0A202020202020686173536561726368526573756C747344796E616D6963456E74726965733A2066756E6374696F6E2829207B0A20202020202020207661722068617344796E616D';
wwv_flow_api.g_varchar2_table(414) := '6963456E7472696573203D202428276C692E6170782D53706F746C696768742D726573756C7427292E686173436C61737328276170782D53706F746C696768742D44594E414D49432729207C7C2066616C73653B0A202020202020202072657475726E20';
wwv_flow_api.g_varchar2_table(415) := '68617344796E616D6963456E74726965733B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A205265616C20506C7567696E2068616E646C6572202D2063616C6C65642066726F6D206F7574657220706C7567696E48616E646C6572';
wwv_flow_api.g_varchar2_table(416) := '2066756E6374696F6E0A202020202020202A2040706172616D207B6F626A6563747D20704F7074696F6E730A202020202020202A2F0A202020202020706C7567696E48616E646C65723A2066756E6374696F6E28704F7074696F6E7329207B0A20202020';
wwv_flow_api.g_varchar2_table(417) := '202020202F2F20706C7567696E20617474726962757465730A20202020202020207661722064796E616D6963416374696F6E4964203D206170657853706F746C696768742E6744796E616D6963416374696F6E4964203D20704F7074696F6E732E64796E';
wwv_flow_api.g_varchar2_table(418) := '616D6963416374696F6E49643B0A202020202020202076617220616A61784964656E746966696572203D206170657853706F746C696768742E67416A61784964656E746966696572203D20704F7074696F6E732E616A61784964656E7469666965723B0A';
wwv_flow_api.g_varchar2_table(419) := '2020202020202020766172206576656E744E616D65203D20704F7074696F6E732E6576656E744E616D653B0A202020202020202076617220666972654F6E496E6974203D20704F7074696F6E732E666972654F6E496E69743B0A0A202020202020202076';
wwv_flow_api.g_varchar2_table(420) := '617220706C616365686F6C64657254657874203D206170657853706F746C696768742E67506C616365686F6C64657254657874203D20704F7074696F6E732E706C616365686F6C646572546578743B0A2020202020202020766172206D6F726543686172';
wwv_flow_api.g_varchar2_table(421) := '7354657874203D206170657853706F746C696768742E674D6F7265436861727354657874203D20704F7074696F6E732E6D6F72654368617273546578743B0A2020202020202020766172206E6F4D6174636854657874203D206170657853706F746C6967';
wwv_flow_api.g_varchar2_table(422) := '68742E674E6F4D6174636854657874203D20704F7074696F6E732E6E6F4D61746368546578743B0A2020202020202020766172206F6E654D6174636854657874203D206170657853706F746C696768742E674F6E654D6174636854657874203D20704F70';
wwv_flow_api.g_varchar2_table(423) := '74696F6E732E6F6E654D61746368546578743B0A2020202020202020766172206D756C7469706C654D61746368657354657874203D206170657853706F746C696768742E674D756C7469706C654D61746368657354657874203D20704F7074696F6E732E';
wwv_flow_api.g_varchar2_table(424) := '6D756C7469706C654D617463686573546578743B0A202020202020202076617220696E5061676553656172636854657874203D206170657853706F746C696768742E67496E5061676553656172636854657874203D20704F7074696F6E732E696E506167';
wwv_flow_api.g_varchar2_table(425) := '65536561726368546578743B0A202020202020202076617220736561726368486973746F727944656C65746554657874203D206170657853706F746C696768742E67536561726368486973746F727944656C65746554657874203D20704F7074696F6E73';
wwv_flow_api.g_varchar2_table(426) := '2E736561726368486973746F727944656C657465546578743B0A0A202020202020202076617220656E61626C654B6579626F61726453686F727463757473203D20704F7074696F6E732E656E61626C654B6579626F61726453686F7274637574733B0A20';
wwv_flow_api.g_varchar2_table(427) := '20202020202020766172206B6579626F61726453686F727463757473203D20704F7074696F6E732E6B6579626F61726453686F7274637574733B0A2020202020202020766172207375626D69744974656D73203D20704F7074696F6E732E7375626D6974';
wwv_flow_api.g_varchar2_table(428) := '4974656D733B0A202020202020202076617220656E61626C65496E50616765536561726368203D20704F7074696F6E732E656E61626C65496E506167655365617263683B0A2020202020202020766172206D61784E6176526573756C74203D2061706578';
wwv_flow_api.g_varchar2_table(429) := '53706F746C696768742E674D61784E6176526573756C74203D20704F7074696F6E732E6D61784E6176526573756C743B0A2020202020202020766172207769647468203D206170657853706F746C696768742E675769647468203D20704F7074696F6E73';
wwv_flow_api.g_varchar2_table(430) := '2E77696474683B0A202020202020202076617220656E61626C65446174614361636865203D20704F7074696F6E732E656E61626C654461746143616368653B0A20202020202020207661722073706F746C696768745468656D65203D20704F7074696F6E';
wwv_flow_api.g_varchar2_table(431) := '732E73706F746C696768745468656D653B0A202020202020202076617220656E61626C6550726566696C6C53656C656374656454657874203D20704F7074696F6E732E656E61626C6550726566696C6C53656C6563746564546578743B0A202020202020';
wwv_flow_api.g_varchar2_table(432) := '20207661722073686F7750726F63657373696E67203D20704F7074696F6E732E73686F7750726F63657373696E673B0A202020202020202076617220706C616365486F6C64657249636F6E203D20704F7074696F6E732E706C616365486F6C6465724963';
wwv_flow_api.g_varchar2_table(433) := '6F6E3B0A202020202020202076617220656E61626C65536561726368486973746F7279203D20704F7074696F6E732E656E61626C65536561726368486973746F72793B0A0A2020202020202020766172207375626D69744974656D734172726179203D20';
wwv_flow_api.g_varchar2_table(434) := '5B5D3B0A2020202020202020766172206F70656E4469616C6F67203D20747275653B0A0A20202020202020202F2F2064656275670A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E';
wwv_flow_api.g_varchar2_table(435) := '646C6572202D2064796E616D6963416374696F6E4964272C2064796E616D6963416374696F6E4964293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D20616A61';
wwv_flow_api.g_varchar2_table(436) := '784964656E746966696572272C20616A61784964656E746966696572293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D206576656E744E616D65272C20657665';
wwv_flow_api.g_varchar2_table(437) := '6E744E616D65293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D20666972654F6E496E6974272C20666972654F6E496E6974293B0A0A20202020202020206170';
wwv_flow_api.g_varchar2_table(438) := '65782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D20706C616365686F6C64657254657874272C20706C616365686F6C64657254657874293B0A2020202020202020617065782E64656275672E6C';
wwv_flow_api.g_varchar2_table(439) := '6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D206D6F7265436861727354657874272C206D6F7265436861727354657874293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C69';
wwv_flow_api.g_varchar2_table(440) := '6768742E706C7567696E48616E646C6572202D206E6F4D6174636854657874272C206E6F4D6174636854657874293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C657220';
wwv_flow_api.g_varchar2_table(441) := '2D206F6E654D6174636854657874272C206F6E654D6174636854657874293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D206D756C7469706C654D6174636865';
wwv_flow_api.g_varchar2_table(442) := '7354657874272C206D756C7469706C654D61746368657354657874293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D20696E5061676553656172636854657874';
wwv_flow_api.g_varchar2_table(443) := '272C20696E5061676553656172636854657874293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D20736561726368486973746F727944656C6574655465787427';
wwv_flow_api.g_varchar2_table(444) := '2C20736561726368486973746F727944656C65746554657874293B0A0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D20656E61626C654B6579626F61726453686F';
wwv_flow_api.g_varchar2_table(445) := '727463757473272C20656E61626C654B6579626F61726453686F727463757473293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D206B6579626F61726453686F';
wwv_flow_api.g_varchar2_table(446) := '727463757473272C206B6579626F61726453686F727463757473293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D207375626D69744974656D73272C20737562';
wwv_flow_api.g_varchar2_table(447) := '6D69744974656D73293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D20656E61626C65496E50616765536561726368272C20656E61626C65496E506167655365';
wwv_flow_api.g_varchar2_table(448) := '61726368293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D206D61784E6176526573756C74272C206D61784E6176526573756C74293B0A202020202020202061';
wwv_flow_api.g_varchar2_table(449) := '7065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D207769647468272C207769647468293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E70';
wwv_flow_api.g_varchar2_table(450) := '6C7567696E48616E646C6572202D20656E61626C65446174614361636865272C20656E61626C65446174614361636865293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C';
wwv_flow_api.g_varchar2_table(451) := '6572202D2073706F746C696768745468656D65272C2073706F746C696768745468656D65293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D20656E61626C6550';
wwv_flow_api.g_varchar2_table(452) := '726566696C6C53656C656374656454657874272C20656E61626C6550726566696C6C53656C656374656454657874293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572';
wwv_flow_api.g_varchar2_table(453) := '202D2073686F7750726F63657373696E67272C2073686F7750726F63657373696E67293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D20706C616365486F6C64';
wwv_flow_api.g_varchar2_table(454) := '657249636F6E272C20706C616365486F6C64657249636F6E293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D20656E61626C65536561726368486973746F7279';
wwv_flow_api.g_varchar2_table(455) := '272C20656E61626C65536561726368486973746F7279293B0A0A20202020202020202F2F20706F6C7966696C6C20666F72206F6C6465722062726F7773657273206C696B65204945202873746172747357697468202620696E636C756465732066756E63';
wwv_flow_api.g_varchar2_table(456) := '74696F6E73290A20202020202020206966202821537472696E672E70726F746F747970652E7374617274735769746829207B0A20202020202020202020537472696E672E70726F746F747970652E73746172747357697468203D2066756E6374696F6E28';
wwv_flow_api.g_varchar2_table(457) := '7365617263682C20706F7329207B0A20202020202020202020202072657475726E20746869732E7375627374722821706F73207C7C20706F73203C2030203F2030203A202B706F732C207365617263682E6C656E67746829203D3D3D207365617263683B';
wwv_flow_api.g_varchar2_table(458) := '0A202020202020202020207D3B0A20202020202020207D0A20202020202020206966202821537472696E672E70726F746F747970652E696E636C7564657329207B0A20202020202020202020537472696E672E70726F746F747970652E696E636C756465';
wwv_flow_api.g_varchar2_table(459) := '73203D2066756E6374696F6E287365617263682C20737461727429207B0A2020202020202020202020202775736520737472696374273B0A20202020202020202020202069662028747970656F6620737461727420213D3D20276E756D6265722729207B';
wwv_flow_api.g_varchar2_table(460) := '0A20202020202020202020202020207374617274203D20303B0A2020202020202020202020207D0A0A202020202020202020202020696620287374617274202B207365617263682E6C656E677468203E20746869732E6C656E67746829207B0A20202020';
wwv_flow_api.g_varchar2_table(461) := '2020202020202020202072657475726E2066616C73653B0A2020202020202020202020207D20656C7365207B0A202020202020202020202020202072657475726E20746869732E696E6465784F66287365617263682C2073746172742920213D3D202D31';
wwv_flow_api.g_varchar2_table(462) := '3B0A2020202020202020202020207D0A202020202020202020207D3B0A20202020202020207D0A0A20202020202020202F2F2073657420626F6F6C65616E20676C6F62616C20766172730A20202020202020206170657853706F746C696768742E67456E';
wwv_flow_api.g_varchar2_table(463) := '61626C65496E50616765536561726368203D2028656E61626C65496E50616765536561726368203D3D2027592729203F2074727565203A2066616C73653B0A20202020202020206170657853706F746C696768742E67456E61626C654461746143616368';
wwv_flow_api.g_varchar2_table(464) := '65203D2028656E61626C65446174614361636865203D3D2027592729203F2074727565203A2066616C73653B0A20202020202020206170657853706F746C696768742E67456E61626C6550726566696C6C53656C656374656454657874203D2028656E61';
wwv_flow_api.g_varchar2_table(465) := '626C6550726566696C6C53656C656374656454657874203D3D2027592729203F2074727565203A2066616C73653B0A20202020202020206170657853706F746C696768742E6753686F7750726F63657373696E67203D202873686F7750726F6365737369';
wwv_flow_api.g_varchar2_table(466) := '6E67203D3D2027592729203F2074727565203A2066616C73653B0A20202020202020206170657853706F746C696768742E67456E61626C65536561726368486973746F7279203D2028656E61626C65536561726368486973746F7279203D3D2027592729';
wwv_flow_api.g_varchar2_table(467) := '203F2074727565203A2066616C73653B0A0A0A20202020202020202F2F206275696C642070616765206974656D7320746F207375626D69742061727261790A2020202020202020696620287375626D69744974656D7329207B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(468) := '7375626D69744974656D734172726179203D206170657853706F746C696768742E675375626D69744974656D734172726179203D207375626D69744974656D732E73706C697428272C27293B0A20202020202020207D0A0A20202020202020202F2F2073';
wwv_flow_api.g_varchar2_table(469) := '65742073706F746C69676874207468656D650A2020202020202020737769746368202873706F746C696768745468656D6529207B0A202020202020202020206361736520274F52414E4745273A0A2020202020202020202020206170657853706F746C69';
wwv_flow_api.g_varchar2_table(470) := '6768742E67526573756C744C6973745468656D65436C617373203D20276170782D53706F746C696768742D726573756C742D6F72616E6765273B0A2020202020202020202020206170657853706F746C696768742E6749636F6E5468656D65436C617373';
wwv_flow_api.g_varchar2_table(471) := '203D20276170782D53706F746C696768742D69636F6E2D6F72616E6765273B0A202020202020202020202020627265616B3B0A20202020202020202020636173652027524544273A0A2020202020202020202020206170657853706F746C696768742E67';
wwv_flow_api.g_varchar2_table(472) := '526573756C744C6973745468656D65436C617373203D20276170782D53706F746C696768742D726573756C742D726564273B0A2020202020202020202020206170657853706F746C696768742E6749636F6E5468656D65436C617373203D20276170782D';
wwv_flow_api.g_varchar2_table(473) := '53706F746C696768742D69636F6E2D726564273B0A202020202020202020202020627265616B3B0A202020202020202020206361736520274441524B273A0A2020202020202020202020206170657853706F746C696768742E67526573756C744C697374';
wwv_flow_api.g_varchar2_table(474) := '5468656D65436C617373203D20276170782D53706F746C696768742D726573756C742D6461726B273B0A2020202020202020202020206170657853706F746C696768742E6749636F6E5468656D65436C617373203D20276170782D53706F746C69676874';
wwv_flow_api.g_varchar2_table(475) := '2D69636F6E2D6461726B273B0A202020202020202020202020627265616B3B0A20202020202020207D0A0A20202020202020202F2F207365742073656172636820706C616365686F6C6465722069636F6E0A202020202020202069662028706C61636548';
wwv_flow_api.g_varchar2_table(476) := '6F6C64657249636F6E203D3D3D202744454641554C542729207B0A202020202020202020206170657853706F746C696768742E67506C616365486F6C64657249636F6E203D2027612D49636F6E2069636F6E2D736561726368273B0A2020202020202020';
wwv_flow_api.g_varchar2_table(477) := '7D20656C7365207B0A202020202020202020206170657853706F746C696768742E67506C616365486F6C64657249636F6E203D202766612027202B20706C616365486F6C64657249636F6E3B0A20202020202020207D0A0A20202020202020202F2F2063';
wwv_flow_api.g_varchar2_table(478) := '6865636B7320666F72206F70656E696E67206469616C6F670A2020202020202020696620286576656E744E616D65203D3D20276B6579626F61726453686F727463757427207C7C20666972654F6E496E6974203D3D2027592729207B0A20202020202020';
wwv_flow_api.g_varchar2_table(479) := '2020206F70656E4469616C6F67203D20747275653B0A20202020202020207D20656C736520696620286576656E744E616D65203D3D202772656164792729207B0A202020202020202020206F70656E4469616C6F67203D2066616C73653B0A2020202020';
wwv_flow_api.g_varchar2_table(480) := '2020207D20656C7365207B0A202020202020202020206F70656E4469616C6F67203D20747275653B0A20202020202020207D0A0A20202020202020202F2F207472696767657220696E70757420616E642073656172636820616761696E202D2D3E206966';
wwv_flow_api.g_varchar2_table(481) := '2073656172636820696E7075742068617320736F6D652076616C756520616E6420676574446174612072657175657374206861732066696E736865640A2020202020202020242827626F647927292E6F6E28276170657873706F746C696768742D676574';
wwv_flow_api.g_varchar2_table(482) := '2D64617461272C2066756E6374696F6E2829207B0A20202020202020202020696620286170657853706F746C696768742E674861734469616C6F67437265617465642026262028216170657853706F746C696768742E686173536561726368526573756C';
wwv_flow_api.g_varchar2_table(483) := '747344796E616D6963456E747269657328292929207B0A2020202020202020202020207661722073656172636856616C7565203D2024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E76';
wwv_flow_api.g_varchar2_table(484) := '616C28292E7472696D28293B0A2020202020202020202020206966202873656172636856616C756529207B0A20202020202020202020202020206170657853706F746C696768742E7365617263682873656172636856616C7565293B0A20202020202020';
wwv_flow_api.g_varchar2_table(485) := '2020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E747269676765722827696E70757427293B0A2020202020202020202020207D0A202020202020202020207D0A202020';
wwv_flow_api.g_varchar2_table(486) := '20202020207D293B0A0A20202020202020202F2F206F70656E206469616C6F670A2020202020202020696620286F70656E4469616C6F6729207B0A202020202020202020206170657853706F746C696768742E6F70656E53706F746C696768744469616C';
wwv_flow_api.g_varchar2_table(487) := '6F6728293B0A20202020202020207D0A2020202020207D0A202020207D3B202F2F20656E64206E616D657370616365206170657853706F746C696768740A0A202020202F2F2063616C6C207265616C20706C7567696E48616E646C65722066756E637469';
wwv_flow_api.g_varchar2_table(488) := '6F6E0A202020206170657853706F746C696768742E706C7567696E48616E646C657228704F7074696F6E73293B0A20207D0A7D3B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(4532520532582728)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_file_name=>'js/apexspotlight.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2166756E6374696F6E28652C722C74297B69662865297B666F722876617220692C6F3D7B383A226261636B7370616365222C393A22746162222C31333A22656E746572222C31363A227368696674222C31373A226374726C222C31383A22616C74222C32';
wwv_flow_api.g_varchar2_table(2) := '303A22636170736C6F636B222C32373A22657363222C33323A227370616365222C33333A22706167657570222C33343A2270616765646F776E222C33353A22656E64222C33363A22686F6D65222C33373A226C656674222C33383A227570222C33393A22';
wwv_flow_api.g_varchar2_table(3) := '7269676874222C34303A22646F776E222C34353A22696E73222C34363A2264656C222C39313A226D657461222C39333A226D657461222C3232343A226D657461227D2C6E3D7B3130363A222A222C3130373A222B222C3130393A222D222C3131303A222E';
wwv_flow_api.g_varchar2_table(4) := '222C3131313A222F222C3138363A223B222C3138373A223D222C3138383A222C222C3138393A222D222C3139303A222E222C3139313A222F222C3139323A2260222C3231393A225B222C3232303A225C5C222C3232313A225D222C3232323A2227227D2C';
wwv_flow_api.g_varchar2_table(5) := '633D7B227E223A2260222C2221223A2231222C2240223A2232222C2223223A2233222C243A2234222C2225223A2235222C225E223A2236222C2226223A2237222C222A223A2238222C2228223A2239222C2229223A2230222C5F3A222D222C222B223A22';
wwv_flow_api.g_varchar2_table(6) := '3D222C223A223A223B222C2722273A2227222C223C223A222C222C223E223A222E222C223F223A222F222C227C223A225C5C227D2C733D7B6F7074696F6E3A22616C74222C636F6D6D616E643A226D657461222C72657475726E3A22656E746572222C65';
wwv_flow_api.g_varchar2_table(7) := '73636170653A22657363222C706C75733A222B222C6D6F643A2F4D61637C69506F647C6950686F6E657C695061642F2E74657374286E6176696761746F722E706C6174666F726D293F226D657461223A226374726C227D2C613D313B613C32303B2B2B61';
wwv_flow_api.g_varchar2_table(8) := '296F5B3131312B615D3D2266222B613B666F7228613D303B613C3D393B2B2B61296F5B612B39365D3D612E746F537472696E6728293B5F2E70726F746F747970652E62696E643D66756E6374696F6E28652C742C6E297B72657475726E20653D6520696E';
wwv_flow_api.g_varchar2_table(9) := '7374616E63656F662041727261793F653A5B655D2C746869732E5F62696E644D756C7469706C652E63616C6C28746869732C652C742C6E292C746869737D2C5F2E70726F746F747970652E756E62696E643D66756E6374696F6E28652C74297B72657475';
wwv_flow_api.g_varchar2_table(10) := '726E20746869732E62696E642E63616C6C28746869732C652C66756E6374696F6E28297B7D2C74297D2C5F2E70726F746F747970652E747269676765723D66756E6374696F6E28652C74297B72657475726E20746869732E5F6469726563744D61705B65';
wwv_flow_api.g_varchar2_table(11) := '2B223A222B745D2626746869732E5F6469726563744D61705B652B223A222B745D287B7D2C65292C746869737D2C5F2E70726F746F747970652E72657365743D66756E6374696F6E28297B72657475726E20746869732E5F63616C6C6261636B733D7B7D';
wwv_flow_api.g_varchar2_table(12) := '2C746869732E5F6469726563744D61703D7B7D2C746869737D2C5F2E70726F746F747970652E73746F7043616C6C6261636B3D66756E6374696F6E28652C74297B6966282D313C282220222B742E636C6173734E616D652B222022292E696E6465784F66';
wwv_flow_api.g_varchar2_table(13) := '2822206D6F757365747261702022292972657475726E21313B69662866756E6374696F6E206528742C6E297B72657475726E206E756C6C213D3D74262674213D3D72262628743D3D3D6E7C7C6528742E706172656E744E6F64652C6E29297D28742C7468';
wwv_flow_api.g_varchar2_table(14) := '69732E746172676574292972657475726E21313B69662822636F6D706F7365645061746822696E206526262266756E6374696F6E223D3D747970656F6620652E636F6D706F73656450617468297B766172206E3D652E636F6D706F736564506174682829';
wwv_flow_api.g_varchar2_table(15) := '5B305D3B6E213D3D652E746172676574262628743D6E297D72657475726E22494E505554223D3D742E7461674E616D657C7C2253454C454354223D3D742E7461674E616D657C7C225445585441524541223D3D742E7461674E616D657C7C742E6973436F';
wwv_flow_api.g_varchar2_table(16) := '6E74656E744564697461626C657D2C5F2E70726F746F747970652E68616E646C654B65793D66756E6374696F6E28297B72657475726E20746869732E5F68616E646C654B65792E6170706C7928746869732C617267756D656E7473297D2C5F2E6164644B';
wwv_flow_api.g_varchar2_table(17) := '6579636F6465733D66756E6374696F6E2865297B666F7228766172207420696E206529652E6861734F776E50726F70657274792874292626286F5B745D3D655B745D293B693D6E756C6C7D2C5F2E696E69743D66756E6374696F6E28297B76617220743D';
wwv_flow_api.g_varchar2_table(18) := '5F2872293B666F7228766172206520696E207429225F22213D3D652E6368617241742830292626285F5B655D3D66756E6374696F6E2865297B72657475726E2066756E6374696F6E28297B72657475726E20745B655D2E6170706C7928742C617267756D';
wwv_flow_api.g_varchar2_table(19) := '656E7473297D7D286529297D2C5F2E696E697428292C652E4D6F757365747261703D5F2C22756E646566696E656422213D747970656F66206D6F64756C6526266D6F64756C652E6578706F7274732626286D6F64756C652E6578706F7274733D5F292C22';
wwv_flow_api.g_varchar2_table(20) := '66756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D642626646566696E652866756E6374696F6E28297B72657475726E205F7D297D66756E6374696F6E207628652C742C6E297B652E6164644576656E744C69737465';
wwv_flow_api.g_varchar2_table(21) := '6E65723F652E6164644576656E744C697374656E657228742C6E2C2131293A652E6174746163684576656E7428226F6E222B742C6E297D66756E6374696F6E20622865297B696628226B6579707265737322213D652E747970652972657475726E206F5B';
wwv_flow_api.g_varchar2_table(22) := '652E77686963685D3F6F5B652E77686963685D3A6E5B652E77686963685D3F6E5B652E77686963685D3A537472696E672E66726F6D43686172436F646528652E7768696368292E746F4C6F7765724361736528293B76617220743D537472696E672E6672';
wwv_flow_api.g_varchar2_table(23) := '6F6D43686172436F646528652E7768696368293B72657475726E20652E73686966744B65797C7C28743D742E746F4C6F776572436173652829292C747D66756E6374696F6E20672865297B72657475726E227368696674223D3D657C7C226374726C223D';
wwv_flow_api.g_varchar2_table(24) := '3D657C7C22616C74223D3D657C7C226D657461223D3D657D66756E6374696F6E206C28652C742C6E297B72657475726E206E7C7C286E3D66756E6374696F6E28297B696628216929666F7228766172206520696E20693D7B7D2C6F2939353C652626653C';
wwv_flow_api.g_varchar2_table(25) := '3131327C7C6F2E6861734F776E50726F7065727479286529262628695B6F5B655D5D3D65293B72657475726E20697D28295B655D3F226B6579646F776E223A226B6579707265737322292C226B65797072657373223D3D6E2626742E6C656E6774682626';
wwv_flow_api.g_varchar2_table(26) := '286E3D226B6579646F776E22292C6E7D66756E6374696F6E207728652C74297B766172206E2C722C692C6F2C613D5B5D3B666F72286E3D222B223D3D3D286F3D65293F5B222B225D3A286F3D6F2E7265706C616365282F5C2B7B327D2F672C222B706C75';
wwv_flow_api.g_varchar2_table(27) := '732229292E73706C697428222B22292C693D303B693C6E2E6C656E6774683B2B2B6929723D6E5B695D2C735B725D262628723D735B725D292C742626226B6579707265737322213D742626635B725D262628723D635B725D2C612E707573682822736869';
wwv_flow_api.g_varchar2_table(28) := '66742229292C672872292626612E707573682872293B72657475726E7B6B65793A722C6D6F646966696572733A612C616374696F6E3A743D6C28722C612C74297D7D66756E6374696F6E205F2865297B76617220643D746869733B696628653D657C7C72';
wwv_flow_api.g_varchar2_table(29) := '2C21286420696E7374616E63656F66205F292972657475726E206E6577205F2865293B642E7461726765743D652C642E5F63616C6C6261636B733D7B7D2C642E5F6469726563744D61703D7B7D3B76617220732C793D7B7D2C6C3D21312C753D21312C66';
wwv_flow_api.g_varchar2_table(30) := '3D21313B66756E6374696F6E20702865297B653D657C7C7B7D3B76617220742C6E3D21313B666F72287420696E207929655B745D3F6E3D21303A795B745D3D303B6E7C7C28663D2131297D66756E6374696F6E206828652C742C6E2C722C692C6F297B76';
wwv_flow_api.g_varchar2_table(31) := '617220612C632C732C6C2C753D5B5D2C663D6E2E747970653B69662821642E5F63616C6C6261636B735B655D2972657475726E5B5D3B666F7228226B65797570223D3D66262667286529262628743D5B655D292C613D303B613C642E5F63616C6C626163';
wwv_flow_api.g_varchar2_table(32) := '6B735B655D2E6C656E6774683B2B2B6129696628633D642E5F63616C6C6261636B735B655D5B615D2C28727C7C21632E7365717C7C795B632E7365715D3D3D632E6C6576656C292626663D3D632E616374696F6E262628226B65797072657373223D3D66';
wwv_flow_api.g_varchar2_table(33) := '2626216E2E6D6574614B65792626216E2E6374726C4B65797C7C28733D742C6C3D632E6D6F646966696572732C732E736F727428292E6A6F696E28222C22293D3D3D6C2E736F727428292E6A6F696E28222C22292929297B76617220703D21722626632E';
wwv_flow_api.g_varchar2_table(34) := '636F6D626F3D3D692C683D722626632E7365713D3D722626632E6C6576656C3D3D6F3B28707C7C68292626642E5F63616C6C6261636B735B655D2E73706C69636528612C31292C752E707573682863297D72657475726E20757D66756E6374696F6E206D';
wwv_flow_api.g_varchar2_table(35) := '28652C742C6E2C72297B76617220692C6F3B642E73746F7043616C6C6261636B28742C742E7461726765747C7C742E737263456C656D656E742C6E2C72297C7C21313D3D3D6528742C6E29262628286F3D74292E70726576656E7444656661756C743F6F';
wwv_flow_api.g_varchar2_table(36) := '2E70726576656E7444656661756C7428293A6F2E72657475726E56616C75653D21312C28693D74292E73746F7050726F7061676174696F6E3F692E73746F7050726F7061676174696F6E28293A692E63616E63656C427562626C653D2130297D66756E63';
wwv_flow_api.g_varchar2_table(37) := '74696F6E20742865297B226E756D62657222213D747970656F6620652E7768696368262628652E77686963683D652E6B6579436F6465293B76617220742C6E2C723D622865293B72262628226B6579757022213D652E747970657C7C6C213D3D723F642E';
wwv_flow_api.g_varchar2_table(38) := '68616E646C654B657928722C286E3D5B5D2C28743D65292E73686966744B657926266E2E707573682822736869667422292C742E616C744B657926266E2E707573682822616C7422292C742E6374726C4B657926266E2E7075736828226374726C22292C';
wwv_flow_api.g_varchar2_table(39) := '742E6D6574614B657926266E2E7075736828226D65746122292C6E292C65293A6C3D2131297D66756E6374696F6E206328742C652C6E2C72297B66756E6374696F6E20692865297B72657475726E2066756E6374696F6E28297B663D652C2B2B795B745D';
wwv_flow_api.g_varchar2_table(40) := '2C636C65617254696D656F75742873292C733D73657454696D656F757428702C316533297D7D66756E6374696F6E206F2865297B6D286E2C652C74292C226B6579757022213D3D722626286C3D62286529292C73657454696D656F757428702C3130297D';
wwv_flow_api.g_varchar2_table(41) := '666F722876617220613D795B745D3D303B613C652E6C656E6774683B2B2B61297B76617220633D612B313D3D3D652E6C656E6774683F6F3A6928727C7C7728655B612B315D292E616374696F6E293B6B28655B615D2C632C722C742C61297D7D66756E63';
wwv_flow_api.g_varchar2_table(42) := '74696F6E206B28652C742C6E2C722C69297B642E5F6469726563744D61705B652B223A222B6E5D3D743B766172206F2C613D28653D652E7265706C616365282F5C732B2F672C22202229292E73706C697428222022293B313C612E6C656E6774683F6328';
wwv_flow_api.g_varchar2_table(43) := '652C612C742C6E293A286F3D7728652C6E292C642E5F63616C6C6261636B735B6F2E6B65795D3D642E5F63616C6C6261636B735B6F2E6B65795D7C7C5B5D2C68286F2E6B65792C6F2E6D6F646966696572732C7B747970653A6F2E616374696F6E7D2C72';
wwv_flow_api.g_varchar2_table(44) := '2C652C69292C642E5F63616C6C6261636B735B6F2E6B65795D5B723F22756E7368696674223A2270757368225D287B63616C6C6261636B3A742C6D6F646966696572733A6F2E6D6F646966696572732C616374696F6E3A6F2E616374696F6E2C7365713A';
wwv_flow_api.g_varchar2_table(45) := '722C6C6576656C3A692C636F6D626F3A657D29297D642E5F68616E646C654B65793D66756E6374696F6E28652C742C6E297B76617220722C693D6828652C742C6E292C6F3D7B7D2C613D302C633D21313B666F7228723D303B723C692E6C656E6774683B';
wwv_flow_api.g_varchar2_table(46) := '2B2B7229695B725D2E736571262628613D4D6174682E6D617828612C695B725D2E6C6576656C29293B666F7228723D303B723C692E6C656E6774683B2B2B7229696628695B725D2E736571297B696628695B725D2E6C6576656C213D6129636F6E74696E';
wwv_flow_api.g_varchar2_table(47) := '75653B633D21302C6F5B695B725D2E7365715D3D312C6D28695B725D2E63616C6C6261636B2C6E2C695B725D2E636F6D626F2C695B725D2E736571297D656C736520637C7C6D28695B725D2E63616C6C6261636B2C6E2C695B725D2E636F6D626F293B76';
wwv_flow_api.g_varchar2_table(48) := '617220733D226B65797072657373223D3D6E2E747970652626753B6E2E74797065213D667C7C672865297C7C737C7C70286F292C753D632626226B6579646F776E223D3D6E2E747970657D2C642E5F62696E644D756C7469706C653D66756E6374696F6E';
wwv_flow_api.g_varchar2_table(49) := '28652C742C6E297B666F722876617220723D303B723C652E6C656E6774683B2B2B72296B28655B725D2C742C6E297D2C7628652C226B65797072657373222C74292C7628652C226B6579646F776E222C74292C7628652C226B65797570222C74297D7D28';
wwv_flow_api.g_varchar2_table(50) := '22756E646566696E656422213D747970656F662077696E646F773F77696E646F773A6E756C6C2C22756E646566696E656422213D747970656F662077696E646F773F646F63756D656E743A6E756C6C293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(4532958647582741)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_file_name=>'js/mousetrap.min.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A212A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A0A2A206D61726B2E6A732076382E31312E310A2A2068747470733A2F2F6D61726B6A732E696F2F0A2A20436F7079';
wwv_flow_api.g_varchar2_table(2) := '7269676874202863292032303134E28093323031382C204A756C69616E204BC3BC686E656C0A2A2052656C656173656420756E64657220746865204D4954206C6963656E73652068747470733A2F2F6769742E696F2F767754566C0A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(3) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A0A2866756E6374696F6E2028676C6F62616C2C20666163746F727929207B0A09747970656F66206578706F727473203D3D3D20276F';
wwv_flow_api.g_varchar2_table(4) := '626A6563742720262620747970656F66206D6F64756C6520213D3D2027756E646566696E656427203F206D6F64756C652E6578706F727473203D20666163746F7279287265717569726528276A7175657279272929203A0A09747970656F662064656669';
wwv_flow_api.g_varchar2_table(5) := '6E65203D3D3D202766756E6374696F6E2720262620646566696E652E616D64203F20646566696E65285B276A7175657279275D2C20666163746F727929203A0A0928676C6F62616C2E4D61726B203D20666163746F727928676C6F62616C2E6A51756572';
wwv_flow_api.g_varchar2_table(6) := '7929293B0A7D28746869732C202866756E6374696F6E20282429207B202775736520737472696374273B0A0A24203D202420262620242E6861734F776E50726F7065727479282764656661756C742729203F20245B2764656661756C74275D203A20243B';
wwv_flow_api.g_varchar2_table(7) := '0A0A766172205F747970656F66203D20747970656F662053796D626F6C203D3D3D202266756E6374696F6E2220262620747970656F662053796D626F6C2E6974657261746F72203D3D3D202273796D626F6C22203F2066756E6374696F6E20286F626A29';
wwv_flow_api.g_varchar2_table(8) := '207B0A202072657475726E20747970656F66206F626A3B0A7D203A2066756E6374696F6E20286F626A29207B0A202072657475726E206F626A20262620747970656F662053796D626F6C203D3D3D202266756E6374696F6E22202626206F626A2E636F6E';
wwv_flow_api.g_varchar2_table(9) := '7374727563746F72203D3D3D2053796D626F6C202626206F626A20213D3D2053796D626F6C2E70726F746F74797065203F202273796D626F6C22203A20747970656F66206F626A3B0A7D3B0A0A0A0A0A0A0A0A0A0A0A0A76617220636C61737343616C6C';
wwv_flow_api.g_varchar2_table(10) := '436865636B203D2066756E6374696F6E2028696E7374616E63652C20436F6E7374727563746F7229207B0A2020696620282128696E7374616E636520696E7374616E63656F6620436F6E7374727563746F722929207B0A202020207468726F77206E6577';
wwv_flow_api.g_varchar2_table(11) := '20547970654572726F72282243616E6E6F742063616C6C206120636C61737320617320612066756E6374696F6E22293B0A20207D0A7D3B0A0A76617220637265617465436C617373203D2066756E6374696F6E202829207B0A202066756E6374696F6E20';
wwv_flow_api.g_varchar2_table(12) := '646566696E6550726F70657274696573287461726765742C2070726F707329207B0A20202020666F7220287661722069203D20303B2069203C2070726F70732E6C656E6774683B20692B2B29207B0A2020202020207661722064657363726970746F7220';
wwv_flow_api.g_varchar2_table(13) := '3D2070726F70735B695D3B0A20202020202064657363726970746F722E656E756D657261626C65203D2064657363726970746F722E656E756D657261626C65207C7C2066616C73653B0A20202020202064657363726970746F722E636F6E666967757261';
wwv_flow_api.g_varchar2_table(14) := '626C65203D20747275653B0A202020202020696620282276616C75652220696E2064657363726970746F72292064657363726970746F722E7772697461626C65203D20747275653B0A2020202020204F626A6563742E646566696E6550726F7065727479';
wwv_flow_api.g_varchar2_table(15) := '287461726765742C2064657363726970746F722E6B65792C2064657363726970746F72293B0A202020207D0A20207D0A0A202072657475726E2066756E6374696F6E2028436F6E7374727563746F722C2070726F746F50726F70732C2073746174696350';
wwv_flow_api.g_varchar2_table(16) := '726F707329207B0A202020206966202870726F746F50726F70732920646566696E6550726F7065727469657328436F6E7374727563746F722E70726F746F747970652C2070726F746F50726F7073293B0A202020206966202873746174696350726F7073';
wwv_flow_api.g_varchar2_table(17) := '2920646566696E6550726F7065727469657328436F6E7374727563746F722C2073746174696350726F7073293B0A2020202072657475726E20436F6E7374727563746F723B0A20207D3B0A7D28293B0A0A0A0A0A0A0A0A766172205F657874656E647320';
wwv_flow_api.g_varchar2_table(18) := '3D204F626A6563742E61737369676E207C7C2066756E6374696F6E202874617267657429207B0A2020666F7220287661722069203D20313B2069203C20617267756D656E74732E6C656E6774683B20692B2B29207B0A2020202076617220736F75726365';
wwv_flow_api.g_varchar2_table(19) := '203D20617267756D656E74735B695D3B0A0A20202020666F722028766172206B657920696E20736F7572636529207B0A202020202020696620284F626A6563742E70726F746F747970652E6861734F776E50726F70657274792E63616C6C28736F757263';
wwv_flow_api.g_varchar2_table(20) := '652C206B65792929207B0A20202020202020207461726765745B6B65795D203D20736F757263655B6B65795D3B0A2020202020207D0A202020207D0A20207D0A0A202072657475726E207461726765743B0A7D3B0A0A76617220444F4D4974657261746F';
wwv_flow_api.g_varchar2_table(21) := '72203D2066756E6374696F6E202829207B0A202066756E6374696F6E20444F4D4974657261746F722863747829207B0A2020202076617220696672616D6573203D20617267756D656E74732E6C656E677468203E203120262620617267756D656E74735B';
wwv_flow_api.g_varchar2_table(22) := '315D20213D3D20756E646566696E6564203F20617267756D656E74735B315D203A20747275653B0A20202020766172206578636C756465203D20617267756D656E74732E6C656E677468203E203220262620617267756D656E74735B325D20213D3D2075';
wwv_flow_api.g_varchar2_table(23) := '6E646566696E6564203F20617267756D656E74735B325D203A205B5D3B0A2020202076617220696672616D657354696D656F7574203D20617267756D656E74732E6C656E677468203E203320262620617267756D656E74735B335D20213D3D20756E6465';
wwv_flow_api.g_varchar2_table(24) := '66696E6564203F20617267756D656E74735B335D203A20353030303B0A20202020636C61737343616C6C436865636B28746869732C20444F4D4974657261746F72293B0A0A20202020746869732E637478203D206374783B0A20202020746869732E6966';
wwv_flow_api.g_varchar2_table(25) := '72616D6573203D20696672616D65733B0A20202020746869732E6578636C756465203D206578636C7564653B0A20202020746869732E696672616D657354696D656F7574203D20696672616D657354696D656F75743B0A20207D0A0A2020637265617465';
wwv_flow_api.g_varchar2_table(26) := '436C61737328444F4D4974657261746F722C205B7B0A202020206B65793A2027676574436F6E7465787473272C0A2020202076616C75653A2066756E6374696F6E20676574436F6E74657874732829207B0A20202020202076617220637478203D20766F';
wwv_flow_api.g_varchar2_table(27) := '696420302C0A2020202020202020202066696C7465726564437478203D205B5D3B0A20202020202069662028747970656F6620746869732E637478203D3D3D2027756E646566696E656427207C7C2021746869732E63747829207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(28) := '637478203D205B5D3B0A2020202020207D20656C736520696620284E6F64654C6973742E70726F746F747970652E697350726F746F747970654F6628746869732E6374782929207B0A2020202020202020637478203D2041727261792E70726F746F7479';
wwv_flow_api.g_varchar2_table(29) := '70652E736C6963652E63616C6C28746869732E637478293B0A2020202020207D20656C7365206966202841727261792E6973417272617928746869732E6374782929207B0A2020202020202020637478203D20746869732E6374783B0A2020202020207D';
wwv_flow_api.g_varchar2_table(30) := '20656C73652069662028747970656F6620746869732E637478203D3D3D2027737472696E672729207B0A2020202020202020637478203D2041727261792E70726F746F747970652E736C6963652E63616C6C28646F63756D656E742E717565727953656C';
wwv_flow_api.g_varchar2_table(31) := '6563746F72416C6C28746869732E63747829293B0A2020202020207D20656C7365207B0A2020202020202020637478203D205B746869732E6374785D3B0A2020202020207D0A2020202020206374782E666F72456163682866756E6374696F6E20286374';
wwv_flow_api.g_varchar2_table(32) := '7829207B0A202020202020202076617220697344657363656E64616E74203D2066696C74657265644374782E66696C7465722866756E6374696F6E2028636F6E746578747329207B0A2020202020202020202072657475726E20636F6E74657874732E63';
wwv_flow_api.g_varchar2_table(33) := '6F6E7461696E7328637478293B0A20202020202020207D292E6C656E677468203E20303B0A20202020202020206966202866696C74657265644374782E696E6465784F662863747829203D3D3D202D312026262021697344657363656E64616E7429207B';
wwv_flow_api.g_varchar2_table(34) := '0A2020202020202020202066696C74657265644374782E7075736828637478293B0A20202020202020207D0A2020202020207D293B0A20202020202072657475726E2066696C74657265644374783B0A202020207D0A20207D2C207B0A202020206B6579';
wwv_flow_api.g_varchar2_table(35) := '3A2027676574496672616D65436F6E74656E7473272C0A2020202076616C75653A2066756E6374696F6E20676574496672616D65436F6E74656E7473286966722C2073756363657373466E29207B0A202020202020766172206572726F72466E203D2061';
wwv_flow_api.g_varchar2_table(36) := '7267756D656E74732E6C656E677468203E203220262620617267756D656E74735B325D20213D3D20756E646566696E6564203F20617267756D656E74735B325D203A2066756E6374696F6E202829207B7D3B0A0A20202020202076617220646F63203D20';
wwv_flow_api.g_varchar2_table(37) := '766F696420303B0A202020202020747279207B0A20202020202020207661722069667257696E203D206966722E636F6E74656E7457696E646F773B0A2020202020202020646F63203D2069667257696E2E646F63756D656E743B0A202020202020202069';
wwv_flow_api.g_varchar2_table(38) := '6620282169667257696E207C7C2021646F6329207B0A202020202020202020207468726F77206E6577204572726F722827696672616D6520696E61636365737369626C6527293B0A20202020202020207D0A2020202020207D2063617463682028652920';
wwv_flow_api.g_varchar2_table(39) := '7B0A20202020202020206572726F72466E28293B0A2020202020207D0A20202020202069662028646F6329207B0A202020202020202073756363657373466E28646F63293B0A2020202020207D0A202020207D0A20207D2C207B0A202020206B65793A20';
wwv_flow_api.g_varchar2_table(40) := '276973496672616D65426C616E6B272C0A2020202076616C75653A2066756E6374696F6E206973496672616D65426C616E6B2869667229207B0A20202020202076617220626C203D202761626F75743A626C616E6B272C0A202020202020202020207372';
wwv_flow_api.g_varchar2_table(41) := '63203D206966722E676574417474726962757465282773726327292E7472696D28292C0A2020202020202020202068726566203D206966722E636F6E74656E7457696E646F772E6C6F636174696F6E2E687265663B0A20202020202072657475726E2068';
wwv_flow_api.g_varchar2_table(42) := '726566203D3D3D20626C2026262073726320213D3D20626C202626207372633B0A202020207D0A20207D2C207B0A202020206B65793A20276F627365727665496672616D654C6F6164272C0A2020202076616C75653A2066756E6374696F6E206F627365';
wwv_flow_api.g_varchar2_table(43) := '727665496672616D654C6F6164286966722C2073756363657373466E2C206572726F72466E29207B0A202020202020766172205F74686973203D20746869733B0A0A2020202020207661722063616C6C6564203D2066616C73652C0A2020202020202020';
wwv_flow_api.g_varchar2_table(44) := '2020746F7574203D206E756C6C3B0A202020202020766172206C697374656E6572203D2066756E6374696F6E206C697374656E65722829207B0A20202020202020206966202863616C6C656429207B0A2020202020202020202072657475726E3B0A2020';
wwv_flow_api.g_varchar2_table(45) := '2020202020207D0A202020202020202063616C6C6564203D20747275653B0A2020202020202020636C65617254696D656F757428746F7574293B0A2020202020202020747279207B0A2020202020202020202069662028215F746869732E697349667261';
wwv_flow_api.g_varchar2_table(46) := '6D65426C616E6B286966722929207B0A2020202020202020202020206966722E72656D6F76654576656E744C697374656E657228276C6F6164272C206C697374656E6572293B0A2020202020202020202020205F746869732E676574496672616D65436F';
wwv_flow_api.g_varchar2_table(47) := '6E74656E7473286966722C2073756363657373466E2C206572726F72466E293B0A202020202020202020207D0A20202020202020207D20636174636820286529207B0A202020202020202020206572726F72466E28293B0A20202020202020207D0A2020';
wwv_flow_api.g_varchar2_table(48) := '202020207D3B0A2020202020206966722E6164644576656E744C697374656E657228276C6F6164272C206C697374656E6572293B0A202020202020746F7574203D2073657454696D656F7574286C697374656E65722C20746869732E696672616D657354';
wwv_flow_api.g_varchar2_table(49) := '696D656F7574293B0A202020207D0A20207D2C207B0A202020206B65793A20276F6E496672616D655265616479272C0A2020202076616C75653A2066756E6374696F6E206F6E496672616D655265616479286966722C2073756363657373466E2C206572';
wwv_flow_api.g_varchar2_table(50) := '726F72466E29207B0A202020202020747279207B0A2020202020202020696620286966722E636F6E74656E7457696E646F772E646F63756D656E742E72656164795374617465203D3D3D2027636F6D706C6574652729207B0A2020202020202020202069';
wwv_flow_api.g_varchar2_table(51) := '662028746869732E6973496672616D65426C616E6B286966722929207B0A202020202020202020202020746869732E6F627365727665496672616D654C6F6164286966722C2073756363657373466E2C206572726F72466E293B0A202020202020202020';
wwv_flow_api.g_varchar2_table(52) := '207D20656C7365207B0A202020202020202020202020746869732E676574496672616D65436F6E74656E7473286966722C2073756363657373466E2C206572726F72466E293B0A202020202020202020207D0A20202020202020207D20656C7365207B0A';
wwv_flow_api.g_varchar2_table(53) := '20202020202020202020746869732E6F627365727665496672616D654C6F6164286966722C2073756363657373466E2C206572726F72466E293B0A20202020202020207D0A2020202020207D20636174636820286529207B0A2020202020202020657272';
wwv_flow_api.g_varchar2_table(54) := '6F72466E28293B0A2020202020207D0A202020207D0A20207D2C207B0A202020206B65793A202777616974466F72496672616D6573272C0A2020202076616C75653A2066756E6374696F6E2077616974466F72496672616D6573286374782C20646F6E65';
wwv_flow_api.g_varchar2_table(55) := '29207B0A202020202020766172205F7468697332203D20746869733B0A0A202020202020766172206561636843616C6C6564203D20303B0A202020202020746869732E666F7245616368496672616D65286374782C2066756E6374696F6E202829207B0A';
wwv_flow_api.g_varchar2_table(56) := '202020202020202072657475726E20747275653B0A2020202020207D2C2066756E6374696F6E202869667229207B0A20202020202020206561636843616C6C65642B2B3B0A20202020202020205F74686973322E77616974466F72496672616D65732869';
wwv_flow_api.g_varchar2_table(57) := '66722E717565727953656C6563746F72282768746D6C27292C2066756E6374696F6E202829207B0A202020202020202020206966202821202D2D6561636843616C6C656429207B0A202020202020202020202020646F6E6528293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(58) := '20207D0A20202020202020207D293B0A2020202020207D2C2066756E6374696F6E202868616E646C656429207B0A2020202020202020696620282168616E646C656429207B0A20202020202020202020646F6E6528293B0A20202020202020207D0A2020';
wwv_flow_api.g_varchar2_table(59) := '202020207D293B0A202020207D0A20207D2C207B0A202020206B65793A2027666F7245616368496672616D65272C0A2020202076616C75653A2066756E6374696F6E20666F7245616368496672616D65286374782C2066696C7465722C20656163682920';
wwv_flow_api.g_varchar2_table(60) := '7B0A202020202020766172205F7468697333203D20746869733B0A0A20202020202076617220656E64203D20617267756D656E74732E6C656E677468203E203320262620617267756D656E74735B335D20213D3D20756E646566696E6564203F20617267';
wwv_flow_api.g_varchar2_table(61) := '756D656E74735B335D203A2066756E6374696F6E202829207B7D3B0A0A20202020202076617220696672203D206374782E717565727953656C6563746F72416C6C2827696672616D6527292C0A202020202020202020206F70656E203D206966722E6C65';
wwv_flow_api.g_varchar2_table(62) := '6E6774682C0A2020202020202020202068616E646C6564203D20303B0A202020202020696672203D2041727261792E70726F746F747970652E736C6963652E63616C6C28696672293B0A20202020202076617220636865636B456E64203D2066756E6374';
wwv_flow_api.g_varchar2_table(63) := '696F6E20636865636B456E642829207B0A2020202020202020696620282D2D6F70656E203C3D203029207B0A20202020202020202020656E642868616E646C6564293B0A20202020202020207D0A2020202020207D3B0A20202020202069662028216F70';
wwv_flow_api.g_varchar2_table(64) := '656E29207B0A2020202020202020636865636B456E6428293B0A2020202020207D0A2020202020206966722E666F72456163682866756E6374696F6E202869667229207B0A202020202020202069662028444F4D4974657261746F722E6D617463686573';
wwv_flow_api.g_varchar2_table(65) := '286966722C205F74686973332E6578636C7564652929207B0A20202020202020202020636865636B456E6428293B0A20202020202020207D20656C7365207B0A202020202020202020205F74686973332E6F6E496672616D655265616479286966722C20';
wwv_flow_api.g_varchar2_table(66) := '66756E6374696F6E2028636F6E29207B0A2020202020202020202020206966202866696C746572286966722929207B0A202020202020202020202020202068616E646C65642B2B3B0A20202020202020202020202020206561636828636F6E293B0A2020';
wwv_flow_api.g_varchar2_table(67) := '202020202020202020207D0A202020202020202020202020636865636B456E6428293B0A202020202020202020207D2C20636865636B456E64293B0A20202020202020207D0A2020202020207D293B0A202020207D0A20207D2C207B0A202020206B6579';
wwv_flow_api.g_varchar2_table(68) := '3A20276372656174654974657261746F72272C0A2020202076616C75653A2066756E6374696F6E206372656174654974657261746F72286374782C2077686174546F53686F772C2066696C74657229207B0A20202020202072657475726E20646F63756D';
wwv_flow_api.g_varchar2_table(69) := '656E742E6372656174654E6F64654974657261746F72286374782C2077686174546F53686F772C2066696C7465722C2066616C7365293B0A202020207D0A20207D2C207B0A202020206B65793A2027637265617465496E7374616E63654F6E496672616D';
wwv_flow_api.g_varchar2_table(70) := '65272C0A2020202076616C75653A2066756E6374696F6E20637265617465496E7374616E63654F6E496672616D6528636F6E74656E747329207B0A20202020202072657475726E206E657720444F4D4974657261746F7228636F6E74656E74732E717565';
wwv_flow_api.g_varchar2_table(71) := '727953656C6563746F72282768746D6C27292C20746869732E696672616D6573293B0A202020207D0A20207D2C207B0A202020206B65793A2027636F6D706172654E6F6465496672616D65272C0A2020202076616C75653A2066756E6374696F6E20636F';
wwv_flow_api.g_varchar2_table(72) := '6D706172654E6F6465496672616D65286E6F64652C20707265764E6F64652C2069667229207B0A20202020202076617220636F6D7043757272203D206E6F64652E636F6D70617265446F63756D656E74506F736974696F6E28696672292C0A2020202020';
wwv_flow_api.g_varchar2_table(73) := '202020202070726576203D204E6F64652E444F43554D454E545F504F534954494F4E5F505245434544494E473B0A20202020202069662028636F6D70437572722026207072657629207B0A202020202020202069662028707265764E6F646520213D3D20';
wwv_flow_api.g_varchar2_table(74) := '6E756C6C29207B0A2020202020202020202076617220636F6D7050726576203D20707265764E6F64652E636F6D70617265446F63756D656E74506F736974696F6E28696672292C0A20202020202020202020202020206166746572203D204E6F64652E44';
wwv_flow_api.g_varchar2_table(75) := '4F43554D454E545F504F534954494F4E5F464F4C4C4F57494E473B0A2020202020202020202069662028636F6D7050726576202620616674657229207B0A20202020202020202020202072657475726E20747275653B0A202020202020202020207D0A20';
wwv_flow_api.g_varchar2_table(76) := '202020202020207D20656C7365207B0A2020202020202020202072657475726E20747275653B0A20202020202020207D0A2020202020207D0A20202020202072657475726E2066616C73653B0A202020207D0A20207D2C207B0A202020206B65793A2027';
wwv_flow_api.g_varchar2_table(77) := '6765744974657261746F724E6F6465272C0A2020202076616C75653A2066756E6374696F6E206765744974657261746F724E6F64652869747229207B0A20202020202076617220707265764E6F6465203D206974722E70726576696F75734E6F64652829';
wwv_flow_api.g_varchar2_table(78) := '3B0A202020202020766172206E6F6465203D20766F696420303B0A20202020202069662028707265764E6F6465203D3D3D206E756C6C29207B0A20202020202020206E6F6465203D206974722E6E6578744E6F646528293B0A2020202020207D20656C73';
wwv_flow_api.g_varchar2_table(79) := '65207B0A20202020202020206E6F6465203D206974722E6E6578744E6F64652829202626206974722E6E6578744E6F646528293B0A2020202020207D0A20202020202072657475726E207B0A2020202020202020707265764E6F64653A20707265764E6F';
wwv_flow_api.g_varchar2_table(80) := '64652C0A20202020202020206E6F64653A206E6F64650A2020202020207D3B0A202020207D0A20207D2C207B0A202020206B65793A2027636865636B496672616D6546696C746572272C0A2020202076616C75653A2066756E6374696F6E20636865636B';
wwv_flow_api.g_varchar2_table(81) := '496672616D6546696C746572286E6F64652C20707265764E6F64652C20637572724966722C2069667229207B0A202020202020766172206B6579203D2066616C73652C0A2020202020202020202068616E646C6564203D2066616C73653B0A2020202020';
wwv_flow_api.g_varchar2_table(82) := '206966722E666F72456163682866756E6374696F6E2028696672446963742C206929207B0A202020202020202069662028696672446963742E76616C203D3D3D206375727249667229207B0A202020202020202020206B6579203D20693B0A2020202020';
wwv_flow_api.g_varchar2_table(83) := '202020202068616E646C6564203D20696672446963742E68616E646C65643B0A20202020202020207D0A2020202020207D293B0A20202020202069662028746869732E636F6D706172654E6F6465496672616D65286E6F64652C20707265764E6F64652C';
wwv_flow_api.g_varchar2_table(84) := '20637572724966722929207B0A2020202020202020696620286B6579203D3D3D2066616C7365202626202168616E646C656429207B0A202020202020202020206966722E70757368287B0A20202020202020202020202076616C3A20637572724966722C';
wwv_flow_api.g_varchar2_table(85) := '0A20202020202020202020202068616E646C65643A20747275650A202020202020202020207D293B0A20202020202020207D20656C736520696620286B657920213D3D2066616C7365202626202168616E646C656429207B0A2020202020202020202069';
wwv_flow_api.g_varchar2_table(86) := '66725B6B65795D2E68616E646C6564203D20747275653B0A20202020202020207D0A202020202020202072657475726E20747275653B0A2020202020207D0A202020202020696620286B6579203D3D3D2066616C736529207B0A20202020202020206966';
wwv_flow_api.g_varchar2_table(87) := '722E70757368287B0A2020202020202020202076616C3A20637572724966722C0A2020202020202020202068616E646C65643A2066616C73650A20202020202020207D293B0A2020202020207D0A20202020202072657475726E2066616C73653B0A2020';
wwv_flow_api.g_varchar2_table(88) := '20207D0A20207D2C207B0A202020206B65793A202768616E646C654F70656E496672616D6573272C0A2020202076616C75653A2066756E6374696F6E2068616E646C654F70656E496672616D6573286966722C2077686174546F53686F772C206543622C';
wwv_flow_api.g_varchar2_table(89) := '2066436229207B0A202020202020766172205F7468697334203D20746869733B0A0A2020202020206966722E666F72456163682866756E6374696F6E20286966724469637429207B0A20202020202020206966202821696672446963742E68616E646C65';
wwv_flow_api.g_varchar2_table(90) := '6429207B0A202020202020202020205F74686973342E676574496672616D65436F6E74656E747328696672446963742E76616C2C2066756E6374696F6E2028636F6E29207B0A2020202020202020202020205F74686973342E637265617465496E737461';
wwv_flow_api.g_varchar2_table(91) := '6E63654F6E496672616D6528636F6E292E666F72456163684E6F64652877686174546F53686F772C206543622C20664362293B0A202020202020202020207D293B0A20202020202020207D0A2020202020207D293B0A202020207D0A20207D2C207B0A20';
wwv_flow_api.g_varchar2_table(92) := '2020206B65793A2027697465726174655468726F7567684E6F646573272C0A2020202076616C75653A2066756E6374696F6E20697465726174655468726F7567684E6F6465732877686174546F53686F772C206374782C206561636843622C2066696C74';
wwv_flow_api.g_varchar2_table(93) := '657243622C20646F6E65436229207B0A202020202020766172205F7468697335203D20746869733B0A0A20202020202076617220697472203D20746869732E6372656174654974657261746F72286374782C2077686174546F53686F772C2066696C7465';
wwv_flow_api.g_varchar2_table(94) := '724362293B0A20202020202076617220696672203D205B5D2C0A20202020202020202020656C656D656E7473203D205B5D2C0A202020202020202020206E6F6465203D20766F696420302C0A20202020202020202020707265764E6F6465203D20766F69';
wwv_flow_api.g_varchar2_table(95) := '6420302C0A2020202020202020202072657472696576654E6F646573203D2066756E6374696F6E2072657472696576654E6F6465732829207B0A2020202020202020766172205F6765744974657261746F724E6F6465203D205F74686973352E67657449';
wwv_flow_api.g_varchar2_table(96) := '74657261746F724E6F646528697472293B0A0A2020202020202020707265764E6F6465203D205F6765744974657261746F724E6F64652E707265764E6F64653B0A20202020202020206E6F6465203D205F6765744974657261746F724E6F64652E6E6F64';
wwv_flow_api.g_varchar2_table(97) := '653B0A0A202020202020202072657475726E206E6F64653B0A2020202020207D3B0A2020202020207768696C65202872657472696576654E6F646573282929207B0A202020202020202069662028746869732E696672616D657329207B0A202020202020';
wwv_flow_api.g_varchar2_table(98) := '20202020746869732E666F7245616368496672616D65286374782C2066756E6374696F6E20286375727249667229207B0A20202020202020202020202072657475726E205F74686973352E636865636B496672616D6546696C746572286E6F64652C2070';
wwv_flow_api.g_varchar2_table(99) := '7265764E6F64652C20637572724966722C20696672293B0A202020202020202020207D2C2066756E6374696F6E2028636F6E29207B0A2020202020202020202020205F74686973352E637265617465496E7374616E63654F6E496672616D6528636F6E29';
wwv_flow_api.g_varchar2_table(100) := '2E666F72456163684E6F64652877686174546F53686F772C2066756E6374696F6E20286966724E6F646529207B0A202020202020202020202020202072657475726E20656C656D656E74732E70757368286966724E6F6465293B0A202020202020202020';
wwv_flow_api.g_varchar2_table(101) := '2020207D2C2066696C7465724362293B0A202020202020202020207D293B0A20202020202020207D0A2020202020202020656C656D656E74732E70757368286E6F6465293B0A2020202020207D0A202020202020656C656D656E74732E666F7245616368';
wwv_flow_api.g_varchar2_table(102) := '2866756E6374696F6E20286E6F646529207B0A2020202020202020656163684362286E6F6465293B0A2020202020207D293B0A20202020202069662028746869732E696672616D657329207B0A2020202020202020746869732E68616E646C654F70656E';
wwv_flow_api.g_varchar2_table(103) := '496672616D6573286966722C2077686174546F53686F772C206561636843622C2066696C7465724362293B0A2020202020207D0A202020202020646F6E65436228293B0A202020207D0A20207D2C207B0A202020206B65793A2027666F72456163684E6F';
wwv_flow_api.g_varchar2_table(104) := '6465272C0A2020202076616C75653A2066756E6374696F6E20666F72456163684E6F64652877686174546F53686F772C20656163682C2066696C74657229207B0A202020202020766172205F7468697336203D20746869733B0A0A202020202020766172';
wwv_flow_api.g_varchar2_table(105) := '20646F6E65203D20617267756D656E74732E6C656E677468203E203320262620617267756D656E74735B335D20213D3D20756E646566696E6564203F20617267756D656E74735B335D203A2066756E6374696F6E202829207B7D3B0A0A20202020202076';
wwv_flow_api.g_varchar2_table(106) := '617220636F6E7465787473203D20746869732E676574436F6E746578747328293B0A202020202020766172206F70656E203D20636F6E74657874732E6C656E6774683B0A20202020202069662028216F70656E29207B0A2020202020202020646F6E6528';
wwv_flow_api.g_varchar2_table(107) := '293B0A2020202020207D0A202020202020636F6E74657874732E666F72456163682866756E6374696F6E202863747829207B0A2020202020202020766172207265616479203D2066756E6374696F6E2072656164792829207B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(108) := '5F74686973362E697465726174655468726F7567684E6F6465732877686174546F53686F772C206374782C20656163682C2066696C7465722C2066756E6374696F6E202829207B0A202020202020202020202020696620282D2D6F70656E203C3D203029';
wwv_flow_api.g_varchar2_table(109) := '207B0A2020202020202020202020202020646F6E6528293B0A2020202020202020202020207D0A202020202020202020207D293B0A20202020202020207D3B0A2020202020202020696620285F74686973362E696672616D657329207B0A202020202020';
wwv_flow_api.g_varchar2_table(110) := '202020205F74686973362E77616974466F72496672616D6573286374782C207265616479293B0A20202020202020207D20656C7365207B0A20202020202020202020726561647928293B0A20202020202020207D0A2020202020207D293B0A202020207D';
wwv_flow_api.g_varchar2_table(111) := '0A20207D5D2C205B7B0A202020206B65793A20276D617463686573272C0A2020202076616C75653A2066756E6374696F6E206D61746368657328656C656D656E742C2073656C6563746F7229207B0A2020202020207661722073656C6563746F7273203D';
wwv_flow_api.g_varchar2_table(112) := '20747970656F662073656C6563746F72203D3D3D2027737472696E6727203F205B73656C6563746F725D203A2073656C6563746F722C0A20202020202020202020666E203D20656C656D656E742E6D617463686573207C7C20656C656D656E742E6D6174';
wwv_flow_api.g_varchar2_table(113) := '6368657353656C6563746F72207C7C20656C656D656E742E6D734D61746368657353656C6563746F72207C7C20656C656D656E742E6D6F7A4D61746368657353656C6563746F72207C7C20656C656D656E742E6F4D61746368657353656C6563746F7220';
wwv_flow_api.g_varchar2_table(114) := '7C7C20656C656D656E742E7765626B69744D61746368657353656C6563746F723B0A20202020202069662028666E29207B0A2020202020202020766172206D61746368203D2066616C73653B0A202020202020202073656C6563746F72732E6576657279';
wwv_flow_api.g_varchar2_table(115) := '2866756E6374696F6E202873656C29207B0A2020202020202020202069662028666E2E63616C6C28656C656D656E742C2073656C2929207B0A2020202020202020202020206D61746368203D20747275653B0A2020202020202020202020207265747572';
wwv_flow_api.g_varchar2_table(116) := '6E2066616C73653B0A202020202020202020207D0A2020202020202020202072657475726E20747275653B0A20202020202020207D293B0A202020202020202072657475726E206D617463683B0A2020202020207D20656C7365207B0A20202020202020';
wwv_flow_api.g_varchar2_table(117) := '2072657475726E2066616C73653B0A2020202020207D0A202020207D0A20207D5D293B0A202072657475726E20444F4D4974657261746F723B0A7D28293B0A0A766172204D61726B203D2066756E6374696F6E202829207B0A202066756E6374696F6E20';
wwv_flow_api.g_varchar2_table(118) := '4D61726B2863747829207B0A20202020636C61737343616C6C436865636B28746869732C204D61726B293B0A0A20202020746869732E637478203D206374783B0A20202020746869732E6965203D2066616C73653B0A20202020766172207561203D2077';
wwv_flow_api.g_varchar2_table(119) := '696E646F772E6E6176696761746F722E757365724167656E743B0A202020206966202875612E696E6465784F6628274D5349452729203E202D31207C7C2075612E696E6465784F66282754726964656E742729203E202D3129207B0A2020202020207468';
wwv_flow_api.g_varchar2_table(120) := '69732E6965203D20747275653B0A202020207D0A20207D0A0A2020637265617465436C617373284D61726B2C205B7B0A202020206B65793A20276C6F67272C0A2020202076616C75653A2066756E6374696F6E206C6F67286D736729207B0A2020202020';
wwv_flow_api.g_varchar2_table(121) := '20766172206C6576656C203D20617267756D656E74732E6C656E677468203E203120262620617267756D656E74735B315D20213D3D20756E646566696E6564203F20617267756D656E74735B315D203A20276465627567273B0A0A202020202020766172';
wwv_flow_api.g_varchar2_table(122) := '206C6F67203D20746869732E6F70742E6C6F673B0A2020202020206966202821746869732E6F70742E646562756729207B0A202020202020202072657475726E3B0A2020202020207D0A2020202020206966202828747970656F66206C6F67203D3D3D20';
wwv_flow_api.g_varchar2_table(123) := '27756E646566696E656427203F2027756E646566696E656427203A205F747970656F66286C6F672929203D3D3D20276F626A6563742720262620747970656F66206C6F675B6C6576656C5D203D3D3D202766756E6374696F6E2729207B0A202020202020';
wwv_flow_api.g_varchar2_table(124) := '20206C6F675B6C6576656C5D28276D61726B2E6A733A2027202B206D7367293B0A2020202020207D0A202020207D0A20207D2C207B0A202020206B65793A2027657363617065537472272C0A2020202076616C75653A2066756E6374696F6E2065736361';
wwv_flow_api.g_varchar2_table(125) := '70655374722873747229207B0A20202020202072657475726E207374722E7265706C616365282F5B5C2D5C5B5C5D5C2F5C7B5C7D5C285C295C2A5C2B5C3F5C2E5C5C5C5E5C245C7C5D2F672C20275C5C242627293B0A202020207D0A20207D2C207B0A20';
wwv_flow_api.g_varchar2_table(126) := '2020206B65793A2027637265617465526567457870272C0A2020202076616C75653A2066756E6374696F6E206372656174655265674578702873747229207B0A20202020202069662028746869732E6F70742E77696C64636172647320213D3D20276469';
wwv_flow_api.g_varchar2_table(127) := '7361626C65642729207B0A2020202020202020737472203D20746869732E736574757057696C64636172647352656745787028737472293B0A2020202020207D0A202020202020737472203D20746869732E65736361706553747228737472293B0A2020';
wwv_flow_api.g_varchar2_table(128) := '20202020696620284F626A6563742E6B65797328746869732E6F70742E73796E6F6E796D73292E6C656E67746829207B0A2020202020202020737472203D20746869732E63726561746553796E6F6E796D7352656745787028737472293B0A2020202020';
wwv_flow_api.g_varchar2_table(129) := '207D0A20202020202069662028746869732E6F70742E69676E6F72654A6F696E657273207C7C20746869732E6F70742E69676E6F726550756E6374756174696F6E2E6C656E67746829207B0A2020202020202020737472203D20746869732E7365747570';
wwv_flow_api.g_varchar2_table(130) := '49676E6F72654A6F696E65727352656745787028737472293B0A2020202020207D0A20202020202069662028746869732E6F70742E6469616372697469637329207B0A2020202020202020737472203D20746869732E6372656174654469616372697469';
wwv_flow_api.g_varchar2_table(131) := '637352656745787028737472293B0A2020202020207D0A202020202020737472203D20746869732E6372656174654D6572676564426C616E6B7352656745787028737472293B0A20202020202069662028746869732E6F70742E69676E6F72654A6F696E';
wwv_flow_api.g_varchar2_table(132) := '657273207C7C20746869732E6F70742E69676E6F726550756E6374756174696F6E2E6C656E67746829207B0A2020202020202020737472203D20746869732E6372656174654A6F696E65727352656745787028737472293B0A2020202020207D0A202020';
wwv_flow_api.g_varchar2_table(133) := '20202069662028746869732E6F70742E77696C64636172647320213D3D202764697361626C65642729207B0A2020202020202020737472203D20746869732E63726561746557696C64636172647352656745787028737472293B0A2020202020207D0A20';
wwv_flow_api.g_varchar2_table(134) := '2020202020737472203D20746869732E637265617465416363757261637952656745787028737472293B0A20202020202072657475726E207374723B0A202020207D0A20207D2C207B0A202020206B65793A202763726561746553796E6F6E796D735265';
wwv_flow_api.g_varchar2_table(135) := '67457870272C0A2020202076616C75653A2066756E6374696F6E2063726561746553796E6F6E796D735265674578702873747229207B0A2020202020207661722073796E203D20746869732E6F70742E73796E6F6E796D732C0A20202020202020202020';
wwv_flow_api.g_varchar2_table(136) := '73656E73203D20746869732E6F70742E6361736553656E736974697665203F202727203A202769272C0A202020202020202020206A6F696E6572506C616365686F6C646572203D20746869732E6F70742E69676E6F72654A6F696E657273207C7C207468';
wwv_flow_api.g_varchar2_table(137) := '69732E6F70742E69676E6F726550756E6374756174696F6E2E6C656E677468203F20275C3027203A2027273B0A202020202020666F72202876617220696E64657820696E2073796E29207B0A20202020202020206966202873796E2E6861734F776E5072';
wwv_flow_api.g_varchar2_table(138) := '6F706572747928696E6465782929207B0A202020202020202020207661722076616C7565203D2073796E5B696E6465785D2C0A20202020202020202020202020206B31203D20746869732E6F70742E77696C64636172647320213D3D202764697361626C';
wwv_flow_api.g_varchar2_table(139) := '656427203F20746869732E736574757057696C64636172647352656745787028696E64657829203A20746869732E65736361706553747228696E646578292C0A20202020202020202020202020206B32203D20746869732E6F70742E77696C6463617264';
wwv_flow_api.g_varchar2_table(140) := '7320213D3D202764697361626C656427203F20746869732E736574757057696C6463617264735265674578702876616C756529203A20746869732E6573636170655374722876616C7565293B0A20202020202020202020696620286B3120213D3D202727';
wwv_flow_api.g_varchar2_table(141) := '202626206B3220213D3D20272729207B0A202020202020202020202020737472203D207374722E7265706C616365286E65772052656745787028272827202B20746869732E657363617065537472286B3129202B20277C27202B20746869732E65736361';
wwv_flow_api.g_varchar2_table(142) := '7065537472286B3229202B202729272C2027676D27202B2073656E73292C206A6F696E6572506C616365686F6C646572202B2028272827202B20746869732E70726F6365737353796E6F6D796D73286B3129202B20277C2729202B2028746869732E7072';
wwv_flow_api.g_varchar2_table(143) := '6F6365737353796E6F6D796D73286B3229202B2027292729202B206A6F696E6572506C616365686F6C646572293B0A202020202020202020207D0A20202020202020207D0A2020202020207D0A20202020202072657475726E207374723B0A202020207D';
wwv_flow_api.g_varchar2_table(144) := '0A20207D2C207B0A202020206B65793A202770726F6365737353796E6F6D796D73272C0A2020202076616C75653A2066756E6374696F6E2070726F6365737353796E6F6D796D732873747229207B0A20202020202069662028746869732E6F70742E6967';
wwv_flow_api.g_varchar2_table(145) := '6E6F72654A6F696E657273207C7C20746869732E6F70742E69676E6F726550756E6374756174696F6E2E6C656E67746829207B0A2020202020202020737472203D20746869732E736574757049676E6F72654A6F696E6572735265674578702873747229';
wwv_flow_api.g_varchar2_table(146) := '3B0A2020202020207D0A20202020202072657475726E207374723B0A202020207D0A20207D2C207B0A202020206B65793A2027736574757057696C646361726473526567457870272C0A2020202076616C75653A2066756E6374696F6E20736574757057';
wwv_flow_api.g_varchar2_table(147) := '696C6463617264735265674578702873747229207B0A202020202020737472203D207374722E7265706C616365282F283F3A5C5C292A5C3F2F672C2066756E6374696F6E202876616C29207B0A202020202020202072657475726E2076616C2E63686172';
wwv_flow_api.g_varchar2_table(148) := '4174283029203D3D3D20275C5C27203F20273F27203A20275C783031273B0A2020202020207D293B0A20202020202072657475726E207374722E7265706C616365282F283F3A5C5C292A5C2A2F672C2066756E6374696F6E202876616C29207B0A202020';
wwv_flow_api.g_varchar2_table(149) := '202020202072657475726E2076616C2E636861724174283029203D3D3D20275C5C27203F20272A27203A20275C783032273B0A2020202020207D293B0A202020207D0A20207D2C207B0A202020206B65793A202763726561746557696C64636172647352';
wwv_flow_api.g_varchar2_table(150) := '6567457870272C0A2020202076616C75653A2066756E6374696F6E2063726561746557696C6463617264735265674578702873747229207B0A20202020202076617220737061636573203D20746869732E6F70742E77696C646361726473203D3D3D2027';
wwv_flow_api.g_varchar2_table(151) := '77697468537061636573273B0A20202020202072657475726E207374722E7265706C616365282F5C75303030312F672C20737061636573203F20275B5C5C535C5C735D3F27203A20275C5C533F27292E7265706C616365282F5C75303030322F672C2073';
wwv_flow_api.g_varchar2_table(152) := '7061636573203F20275B5C5C535C5C735D2A3F27203A20275C5C532A27293B0A202020207D0A20207D2C207B0A202020206B65793A2027736574757049676E6F72654A6F696E657273526567457870272C0A2020202076616C75653A2066756E6374696F';
wwv_flow_api.g_varchar2_table(153) := '6E20736574757049676E6F72654A6F696E6572735265674578702873747229207B0A20202020202072657475726E207374722E7265706C616365282F5B5E287C295C5C5D2F672C2066756E6374696F6E202876616C2C20696E64782C206F726967696E61';
wwv_flow_api.g_varchar2_table(154) := '6C29207B0A2020202020202020766172206E65787443686172203D206F726967696E616C2E63686172417428696E6478202B2031293B0A2020202020202020696620282F5B287C295C5C5D2F2E74657374286E6578744368617229207C7C206E65787443';
wwv_flow_api.g_varchar2_table(155) := '686172203D3D3D20272729207B0A2020202020202020202072657475726E2076616C3B0A20202020202020207D20656C7365207B0A2020202020202020202072657475726E2076616C202B20275C30273B0A20202020202020207D0A2020202020207D29';
wwv_flow_api.g_varchar2_table(156) := '3B0A202020207D0A20207D2C207B0A202020206B65793A20276372656174654A6F696E657273526567457870272C0A2020202076616C75653A2066756E6374696F6E206372656174654A6F696E6572735265674578702873747229207B0A202020202020';
wwv_flow_api.g_varchar2_table(157) := '766172206A6F696E6572203D205B5D3B0A2020202020207661722069676E6F726550756E6374756174696F6E203D20746869732E6F70742E69676E6F726550756E6374756174696F6E3B0A2020202020206966202841727261792E697341727261792869';
wwv_flow_api.g_varchar2_table(158) := '676E6F726550756E6374756174696F6E292026262069676E6F726550756E6374756174696F6E2E6C656E67746829207B0A20202020202020206A6F696E65722E7075736828746869732E6573636170655374722869676E6F726550756E6374756174696F';
wwv_flow_api.g_varchar2_table(159) := '6E2E6A6F696E2827272929293B0A2020202020207D0A20202020202069662028746869732E6F70742E69676E6F72654A6F696E65727329207B0A20202020202020206A6F696E65722E7075736828275C5C75303061645C5C75323030625C5C7532303063';
wwv_flow_api.g_varchar2_table(160) := '5C5C753230306427293B0A2020202020207D0A20202020202072657475726E206A6F696E65722E6C656E677468203F207374722E73706C6974282F5C75303030302B2F292E6A6F696E28275B27202B206A6F696E65722E6A6F696E28272729202B20275D';
wwv_flow_api.g_varchar2_table(161) := '2A2729203A207374723B0A202020207D0A20207D2C207B0A202020206B65793A202763726561746544696163726974696373526567457870272C0A2020202076616C75653A2066756E6374696F6E20637265617465446961637269746963735265674578';
wwv_flow_api.g_varchar2_table(162) := '702873747229207B0A2020202020207661722073656E73203D20746869732E6F70742E6361736553656E736974697665203F202727203A202769272C0A20202020202020202020646374203D20746869732E6F70742E6361736553656E73697469766520';
wwv_flow_api.g_varchar2_table(163) := '3F205B2761C3A0C3A1E1BAA3C3A3E1BAA1C483E1BAB1E1BAAFE1BAB3E1BAB5E1BAB7C3A2E1BAA7E1BAA5E1BAA9E1BAABE1BAADC3A4C3A5C481C485272C202741C380C381E1BAA2C383E1BAA0C482E1BAB0E1BAAEE1BAB2E1BAB4E1BAB6C382E1BAA6E1BA';
wwv_flow_api.g_varchar2_table(164) := 'A4E1BAA8E1BAAAE1BAACC384C385C480C484272C202763C3A7C487C48D272C202743C387C486C48C272C202764C491C48F272C202744C490C48E272C202765C3A8C3A9E1BABBE1BABDE1BAB9C3AAE1BB81E1BABFE1BB83E1BB85E1BB87C3ABC49BC493C4';
wwv_flow_api.g_varchar2_table(165) := '99272C202745C388C389E1BABAE1BABCE1BAB8C38AE1BB80E1BABEE1BB82E1BB84E1BB86C38BC49AC492C498272C202769C3ACC3ADE1BB89C4A9E1BB8BC3AEC3AFC4AB272C202749C38CC38DE1BB88C4A8E1BB8AC38EC38FC4AA272C20276CC582272C20';
wwv_flow_api.g_varchar2_table(166) := '274CC581272C20276EC3B1C588C584272C20274EC391C587C583272C20276FC3B2C3B3E1BB8FC3B5E1BB8DC3B4E1BB93E1BB91E1BB95E1BB97E1BB99C6A1E1BB9FE1BBA1E1BB9BE1BB9DE1BBA3C3B6C3B8C58D272C20274FC392C393E1BB8EC395E1BB8C';
wwv_flow_api.g_varchar2_table(167) := 'C394E1BB92E1BB90E1BB94E1BB96E1BB98C6A0E1BB9EE1BBA0E1BB9AE1BB9CE1BBA2C396C398C58C272C202772C599272C202752C598272C202773C5A1C59BC899C59F272C202753C5A0C59AC898C59E272C202774C5A5C89BC5A3272C202754C5A4C89A';
wwv_flow_api.g_varchar2_table(168) := 'C5A2272C202775C3B9C3BAE1BBA7C5A9E1BBA5C6B0E1BBABE1BBA9E1BBADE1BBAFE1BBB1C3BBC3BCC5AFC5AB272C202755C399C39AE1BBA6C5A8E1BBA4C6AFE1BBAAE1BBA8E1BBACE1BBAEE1BBB0C39BC39CC5AEC5AA272C202779C3BDE1BBB3E1BBB7E1';
wwv_flow_api.g_varchar2_table(169) := 'BBB9E1BBB5C3BF272C202759C39DE1BBB2E1BBB6E1BBB8E1BBB4C5B8272C20277AC5BEC5BCC5BA272C20275AC5BDC5BBC5B9275D203A205B2761C3A0C3A1E1BAA3C3A3E1BAA1C483E1BAB1E1BAAFE1BAB3E1BAB5E1BAB7C3A2E1BAA7E1BAA5E1BAA9E1BA';
wwv_flow_api.g_varchar2_table(170) := 'ABE1BAADC3A4C3A5C481C48541C380C381E1BAA2C383E1BAA0C482E1BAB0E1BAAEE1BAB2E1BAB4E1BAB6C382E1BAA6E1BAA4E1BAA8E1BAAAE1BAACC384C385C480C484272C202763C3A7C487C48D43C387C486C48C272C202764C491C48F44C490C48E27';
wwv_flow_api.g_varchar2_table(171) := '2C202765C3A8C3A9E1BABBE1BABDE1BAB9C3AAE1BB81E1BABFE1BB83E1BB85E1BB87C3ABC49BC493C49945C388C389E1BABAE1BABCE1BAB8C38AE1BB80E1BABEE1BB82E1BB84E1BB86C38BC49AC492C498272C202769C3ACC3ADE1BB89C4A9E1BB8BC3AE';
wwv_flow_api.g_varchar2_table(172) := 'C3AFC4AB49C38CC38DE1BB88C4A8E1BB8AC38EC38FC4AA272C20276CC5824CC581272C20276EC3B1C588C5844EC391C587C583272C20276FC3B2C3B3E1BB8FC3B5E1BB8DC3B4E1BB93E1BB91E1BB95E1BB97E1BB99C6A1E1BB9FE1BBA1E1BB9BE1BB9DE1';
wwv_flow_api.g_varchar2_table(173) := 'BBA3C3B6C3B8C58D4FC392C393E1BB8EC395E1BB8CC394E1BB92E1BB90E1BB94E1BB96E1BB98C6A0E1BB9EE1BBA0E1BB9AE1BB9CE1BBA2C396C398C58C272C202772C59952C598272C202773C5A1C59BC899C59F53C5A0C59AC898C59E272C202774C5A5';
wwv_flow_api.g_varchar2_table(174) := 'C89BC5A354C5A4C89AC5A2272C202775C3B9C3BAE1BBA7C5A9E1BBA5C6B0E1BBABE1BBA9E1BBADE1BBAFE1BBB1C3BBC3BCC5AFC5AB55C399C39AE1BBA6C5A8E1BBA4C6AFE1BBAAE1BBA8E1BBACE1BBAEE1BBB0C39BC39CC5AEC5AA272C202779C3BDE1BB';
wwv_flow_api.g_varchar2_table(175) := 'B3E1BBB7E1BBB9E1BBB5C3BF59C39DE1BBB2E1BBB6E1BBB8E1BBB4C5B8272C20277AC5BEC5BCC5BA5AC5BDC5BBC5B9275D3B0A2020202020207661722068616E646C6564203D205B5D3B0A2020202020207374722E73706C6974282727292E666F724561';
wwv_flow_api.g_varchar2_table(176) := '63682866756E6374696F6E2028636829207B0A20202020202020206463742E65766572792866756E6374696F6E202864637429207B0A20202020202020202020696620286463742E696E6465784F662863682920213D3D202D3129207B0A202020202020';
wwv_flow_api.g_varchar2_table(177) := '2020202020206966202868616E646C65642E696E6465784F662864637429203E202D3129207B0A202020202020202020202020202072657475726E2066616C73653B0A2020202020202020202020207D0A202020202020202020202020737472203D2073';
wwv_flow_api.g_varchar2_table(178) := '74722E7265706C616365286E65772052656745787028275B27202B20646374202B20275D272C2027676D27202B2073656E73292C20275B27202B20646374202B20275D27293B0A20202020202020202020202068616E646C65642E707573682864637429';
wwv_flow_api.g_varchar2_table(179) := '3B0A202020202020202020207D0A2020202020202020202072657475726E20747275653B0A20202020202020207D293B0A2020202020207D293B0A20202020202072657475726E207374723B0A202020207D0A20207D2C207B0A202020206B65793A2027';
wwv_flow_api.g_varchar2_table(180) := '6372656174654D6572676564426C616E6B73526567457870272C0A2020202076616C75653A2066756E6374696F6E206372656174654D6572676564426C616E6B735265674578702873747229207B0A20202020202072657475726E207374722E7265706C';
wwv_flow_api.g_varchar2_table(181) := '616365282F5B5C735D2B2F676D692C20275B5C5C735D2B27293B0A202020207D0A20207D2C207B0A202020206B65793A20276372656174654163637572616379526567457870272C0A2020202076616C75653A2066756E6374696F6E2063726561746541';
wwv_flow_api.g_varchar2_table(182) := '636375726163795265674578702873747229207B0A202020202020766172205F74686973203D20746869733B0A0A202020202020766172206368617273203D20272122232425265C2728292A2B2C2D2E2F3A3B3C3D3E3F405B5C5C5D5E5F607B7C7D7EC2';
wwv_flow_api.g_varchar2_table(183) := 'A1C2BF273B0A20202020202076617220616363203D20746869732E6F70742E61636375726163792C0A2020202020202020202076616C203D20747970656F6620616363203D3D3D2027737472696E6727203F20616363203A206163632E76616C75652C0A';
wwv_flow_api.g_varchar2_table(184) := '202020202020202020206C73203D20747970656F6620616363203D3D3D2027737472696E6727203F205B5D203A206163632E6C696D69746572732C0A202020202020202020206C734A6F696E203D2027273B0A2020202020206C732E666F724561636828';
wwv_flow_api.g_varchar2_table(185) := '66756E6374696F6E20286C696D6974657229207B0A20202020202020206C734A6F696E202B3D20277C27202B205F746869732E657363617065537472286C696D69746572293B0A2020202020207D293B0A202020202020737769746368202876616C2920';
wwv_flow_api.g_varchar2_table(186) := '7B0A20202020202020206361736520277061727469616C6C79273A0A202020202020202064656661756C743A0A2020202020202020202072657475726E202728292827202B20737472202B202729273B0A2020202020202020636173652027636F6D706C';
wwv_flow_api.g_varchar2_table(187) := '656D656E74617279273A0A202020202020202020206C734A6F696E203D20275C5C7327202B20286C734A6F696E203F206C734A6F696E203A20746869732E65736361706553747228636861727329293B0A2020202020202020202072657475726E202728';
wwv_flow_api.g_varchar2_table(188) := '29285B5E27202B206C734A6F696E202B20275D2A27202B20737472202B20275B5E27202B206C734A6F696E202B20275D2A29273B0A202020202020202063617365202765786163746C79273A0A2020202020202020202072657475726E2027285E7C5C5C';
wwv_flow_api.g_varchar2_table(189) := '7327202B206C734A6F696E202B2027292827202B20737472202B202729283F3D247C5C5C7327202B206C734A6F696E202B202729273B0A2020202020207D0A202020207D0A20207D2C207B0A202020206B65793A20276765745365706172617465644B65';
wwv_flow_api.g_varchar2_table(190) := '79776F726473272C0A2020202076616C75653A2066756E6374696F6E206765745365706172617465644B6579776F72647328737629207B0A202020202020766172205F7468697332203D20746869733B0A0A20202020202076617220737461636B203D20';
wwv_flow_api.g_varchar2_table(191) := '5B5D3B0A20202020202073762E666F72456163682866756E6374696F6E20286B7729207B0A202020202020202069662028215F74686973322E6F70742E7365706172617465576F726453656172636829207B0A20202020202020202020696620286B772E';
wwv_flow_api.g_varchar2_table(192) := '7472696D282920262620737461636B2E696E6465784F66286B7729203D3D3D202D3129207B0A202020202020202020202020737461636B2E70757368286B77293B0A202020202020202020207D0A20202020202020207D20656C7365207B0A2020202020';
wwv_flow_api.g_varchar2_table(193) := '20202020206B772E73706C697428272027292E666F72456163682866756E6374696F6E20286B7753706C697474656429207B0A202020202020202020202020696620286B7753706C69747465642E7472696D282920262620737461636B2E696E6465784F';
wwv_flow_api.g_varchar2_table(194) := '66286B7753706C697474656429203D3D3D202D3129207B0A2020202020202020202020202020737461636B2E70757368286B7753706C6974746564293B0A2020202020202020202020207D0A202020202020202020207D293B0A20202020202020207D0A';
wwv_flow_api.g_varchar2_table(195) := '2020202020207D293B0A20202020202072657475726E207B0A2020202020202020276B6579776F726473273A20737461636B2E736F72742866756E6374696F6E2028612C206229207B0A2020202020202020202072657475726E20622E6C656E67746820';
wwv_flow_api.g_varchar2_table(196) := '2D20612E6C656E6774683B0A20202020202020207D292C0A2020202020202020276C656E677468273A20737461636B2E6C656E6774680A2020202020207D3B0A202020207D0A20207D2C207B0A202020206B65793A202769734E756D65726963272C0A20';
wwv_flow_api.g_varchar2_table(197) := '20202076616C75653A2066756E6374696F6E2069734E756D657269632876616C756529207B0A20202020202072657475726E204E756D626572287061727365466C6F61742876616C75652929203D3D2076616C75653B0A202020207D0A20207D2C207B0A';
wwv_flow_api.g_varchar2_table(198) := '202020206B65793A2027636865636B52616E676573272C0A2020202076616C75653A2066756E6374696F6E20636865636B52616E67657328617272617929207B0A202020202020766172205F7468697333203D20746869733B0A0A202020202020696620';
wwv_flow_api.g_varchar2_table(199) := '282141727261792E6973417272617928617272617929207C7C204F626A6563742E70726F746F747970652E746F537472696E672E63616C6C2861727261795B305D2920213D3D20275B6F626A656374204F626A6563745D2729207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(200) := '746869732E6C6F6728276D61726B52616E67657328292077696C6C206F6E6C792061636365707420616E206172726179206F66206F626A6563747327293B0A2020202020202020746869732E6F70742E6E6F4D61746368286172726179293B0A20202020';
wwv_flow_api.g_varchar2_table(201) := '2020202072657475726E205B5D3B0A2020202020207D0A20202020202076617220737461636B203D205B5D3B0A202020202020766172206C617374203D20303B0A20202020202061727261792E736F72742866756E6374696F6E2028612C206229207B0A';
wwv_flow_api.g_varchar2_table(202) := '202020202020202072657475726E20612E7374617274202D20622E73746172743B0A2020202020207D292E666F72456163682866756E6374696F6E20286974656D29207B0A2020202020202020766172205F63616C6C4E6F4D617463684F6E496E76616C';
wwv_flow_api.g_varchar2_table(203) := '6964203D205F74686973332E63616C6C4E6F4D617463684F6E496E76616C696452616E676573286974656D2C206C617374292C0A2020202020202020202020207374617274203D205F63616C6C4E6F4D617463684F6E496E76616C69642E73746172742C';
wwv_flow_api.g_varchar2_table(204) := '0A202020202020202020202020656E64203D205F63616C6C4E6F4D617463684F6E496E76616C69642E656E642C0A20202020202020202020202076616C6964203D205F63616C6C4E6F4D617463684F6E496E76616C69642E76616C69643B0A0A20202020';
wwv_flow_api.g_varchar2_table(205) := '202020206966202876616C696429207B0A202020202020202020206974656D2E7374617274203D2073746172743B0A202020202020202020206974656D2E6C656E677468203D20656E64202D2073746172743B0A20202020202020202020737461636B2E';
wwv_flow_api.g_varchar2_table(206) := '70757368286974656D293B0A202020202020202020206C617374203D20656E643B0A20202020202020207D0A2020202020207D293B0A20202020202072657475726E20737461636B3B0A202020207D0A20207D2C207B0A202020206B65793A202763616C';
wwv_flow_api.g_varchar2_table(207) := '6C4E6F4D617463684F6E496E76616C696452616E676573272C0A2020202076616C75653A2066756E6374696F6E2063616C6C4E6F4D617463684F6E496E76616C696452616E6765732872616E67652C206C61737429207B0A202020202020766172207374';
wwv_flow_api.g_varchar2_table(208) := '617274203D20766F696420302C0A20202020202020202020656E64203D20766F696420302C0A2020202020202020202076616C6964203D2066616C73653B0A2020202020206966202872616E676520262620747970656F662072616E67652E7374617274';
wwv_flow_api.g_varchar2_table(209) := '20213D3D2027756E646566696E65642729207B0A20202020202020207374617274203D207061727365496E742872616E67652E73746172742C203130293B0A2020202020202020656E64203D207374617274202B207061727365496E742872616E67652E';
wwv_flow_api.g_varchar2_table(210) := '6C656E6774682C203130293B0A202020202020202069662028746869732E69734E756D657269632872616E67652E73746172742920262620746869732E69734E756D657269632872616E67652E6C656E6774682920262620656E64202D206C617374203E';
wwv_flow_api.g_varchar2_table(211) := '203020262620656E64202D207374617274203E203029207B0A2020202020202020202076616C6964203D20747275653B0A20202020202020207D20656C7365207B0A20202020202020202020746869732E6C6F67282749676E6F72696E6720696E76616C';
wwv_flow_api.g_varchar2_table(212) := '6964206F72206F7665726C617070696E672072616E67653A2027202B20282727202B204A534F4E2E737472696E676966792872616E67652929293B0A20202020202020202020746869732E6F70742E6E6F4D617463682872616E6765293B0A2020202020';
wwv_flow_api.g_varchar2_table(213) := '2020207D0A2020202020207D20656C7365207B0A2020202020202020746869732E6C6F67282749676E6F72696E6720696E76616C69642072616E67653A2027202B204A534F4E2E737472696E676966792872616E676529293B0A20202020202020207468';
wwv_flow_api.g_varchar2_table(214) := '69732E6F70742E6E6F4D617463682872616E6765293B0A2020202020207D0A20202020202072657475726E207B0A202020202020202073746172743A2073746172742C0A2020202020202020656E643A20656E642C0A202020202020202076616C69643A';
wwv_flow_api.g_varchar2_table(215) := '2076616C69640A2020202020207D3B0A202020207D0A20207D2C207B0A202020206B65793A2027636865636B5768697465737061636552616E676573272C0A2020202076616C75653A2066756E6374696F6E20636865636B576869746573706163655261';
wwv_flow_api.g_varchar2_table(216) := '6E6765732872616E67652C206F726967696E616C4C656E6774682C20737472696E6729207B0A20202020202076617220656E64203D20766F696420302C0A2020202020202020202076616C6964203D20747275652C0A202020202020202020206D617820';
wwv_flow_api.g_varchar2_table(217) := '3D20737472696E672E6C656E6774682C0A202020202020202020206F6666736574203D206F726967696E616C4C656E677468202D206D61782C0A202020202020202020207374617274203D207061727365496E742872616E67652E73746172742C203130';
wwv_flow_api.g_varchar2_table(218) := '29202D206F66667365743B0A2020202020207374617274203D207374617274203E206D6178203F206D6178203A2073746172743B0A202020202020656E64203D207374617274202B207061727365496E742872616E67652E6C656E6774682C203130293B';
wwv_flow_api.g_varchar2_table(219) := '0A20202020202069662028656E64203E206D617829207B0A2020202020202020656E64203D206D61783B0A2020202020202020746869732E6C6F672827456E642072616E6765206175746F6D61746963616C6C792073657420746F20746865206D617820';
wwv_flow_api.g_varchar2_table(220) := '76616C7565206F662027202B206D6178293B0A2020202020207D0A202020202020696620287374617274203C2030207C7C20656E64202D207374617274203C2030207C7C207374617274203E206D6178207C7C20656E64203E206D617829207B0A202020';
wwv_flow_api.g_varchar2_table(221) := '202020202076616C6964203D2066616C73653B0A2020202020202020746869732E6C6F672827496E76616C69642072616E67653A2027202B204A534F4E2E737472696E676966792872616E676529293B0A2020202020202020746869732E6F70742E6E6F';
wwv_flow_api.g_varchar2_table(222) := '4D617463682872616E6765293B0A2020202020207D20656C73652069662028737472696E672E737562737472696E672873746172742C20656E64292E7265706C616365282F5C732B2F672C20272729203D3D3D20272729207B0A20202020202020207661';
wwv_flow_api.g_varchar2_table(223) := '6C6964203D2066616C73653B0A2020202020202020746869732E6C6F672827536B697070696E672077686974657370616365206F6E6C792072616E67653A2027202B204A534F4E2E737472696E676966792872616E676529293B0A202020202020202074';
wwv_flow_api.g_varchar2_table(224) := '6869732E6F70742E6E6F4D617463682872616E6765293B0A2020202020207D0A20202020202072657475726E207B0A202020202020202073746172743A2073746172742C0A2020202020202020656E643A20656E642C0A202020202020202076616C6964';
wwv_flow_api.g_varchar2_table(225) := '3A2076616C69640A2020202020207D3B0A202020207D0A20207D2C207B0A202020206B65793A2027676574546578744E6F646573272C0A2020202076616C75653A2066756E6374696F6E20676574546578744E6F64657328636229207B0A202020202020';
wwv_flow_api.g_varchar2_table(226) := '766172205F7468697334203D20746869733B0A0A2020202020207661722076616C203D2027272C0A202020202020202020206E6F646573203D205B5D3B0A202020202020746869732E6974657261746F722E666F72456163684E6F6465284E6F64654669';
wwv_flow_api.g_varchar2_table(227) := '6C7465722E53484F575F544558542C2066756E6374696F6E20286E6F646529207B0A20202020202020206E6F6465732E70757368287B0A2020202020202020202073746172743A2076616C2E6C656E6774682C0A20202020202020202020656E643A2028';
wwv_flow_api.g_varchar2_table(228) := '76616C202B3D206E6F64652E74657874436F6E74656E74292E6C656E6774682C0A202020202020202020206E6F64653A206E6F64650A20202020202020207D293B0A2020202020207D2C2066756E6374696F6E20286E6F646529207B0A20202020202020';
wwv_flow_api.g_varchar2_table(229) := '20696620285F74686973342E6D6174636865734578636C756465286E6F64652E706172656E744E6F64652929207B0A2020202020202020202072657475726E204E6F646546696C7465722E46494C5445525F52454A4543543B0A20202020202020207D20';
wwv_flow_api.g_varchar2_table(230) := '656C7365207B0A2020202020202020202072657475726E204E6F646546696C7465722E46494C5445525F4143434550543B0A20202020202020207D0A2020202020207D2C2066756E6374696F6E202829207B0A20202020202020206362287B0A20202020';
wwv_flow_api.g_varchar2_table(231) := '20202020202076616C75653A2076616C2C0A202020202020202020206E6F6465733A206E6F6465730A20202020202020207D293B0A2020202020207D293B0A202020207D0A20207D2C207B0A202020206B65793A20276D6174636865734578636C756465';
wwv_flow_api.g_varchar2_table(232) := '272C0A2020202076616C75653A2066756E6374696F6E206D6174636865734578636C75646528656C29207B0A20202020202072657475726E20444F4D4974657261746F722E6D61746368657328656C2C20746869732E6F70742E6578636C7564652E636F';
wwv_flow_api.g_varchar2_table(233) := '6E636174285B27736372697074272C20277374796C65272C20277469746C65272C202768656164272C202768746D6C275D29293B0A202020207D0A20207D2C207B0A202020206B65793A20277772617052616E6765496E546578744E6F6465272C0A2020';
wwv_flow_api.g_varchar2_table(234) := '202076616C75653A2066756E6374696F6E207772617052616E6765496E546578744E6F6465286E6F64652C2073746172742C20656E6429207B0A2020202020207661722068456C203D2021746869732E6F70742E656C656D656E74203F20276D61726B27';
wwv_flow_api.g_varchar2_table(235) := '203A20746869732E6F70742E656C656D656E742C0A2020202020202020202073746172744E6F6465203D206E6F64652E73706C697454657874287374617274292C0A20202020202020202020726574203D2073746172744E6F64652E73706C6974546578';
wwv_flow_api.g_varchar2_table(236) := '7428656E64202D207374617274293B0A202020202020766172207265706C203D20646F63756D656E742E637265617465456C656D656E742868456C293B0A2020202020207265706C2E7365744174747269627574652827646174612D6D61726B6A73272C';
wwv_flow_api.g_varchar2_table(237) := '20277472756527293B0A20202020202069662028746869732E6F70742E636C6173734E616D6529207B0A20202020202020207265706C2E7365744174747269627574652827636C617373272C20746869732E6F70742E636C6173734E616D65293B0A2020';
wwv_flow_api.g_varchar2_table(238) := '202020207D0A2020202020207265706C2E74657874436F6E74656E74203D2073746172744E6F64652E74657874436F6E74656E743B0A20202020202073746172744E6F64652E706172656E744E6F64652E7265706C6163654368696C64287265706C2C20';
wwv_flow_api.g_varchar2_table(239) := '73746172744E6F6465293B0A20202020202072657475726E207265743B0A202020207D0A20207D2C207B0A202020206B65793A20277772617052616E6765496E4D6170706564546578744E6F6465272C0A2020202076616C75653A2066756E6374696F6E';
wwv_flow_api.g_varchar2_table(240) := '207772617052616E6765496E4D6170706564546578744E6F646528646963742C2073746172742C20656E642C2066696C74657243622C2065616368436229207B0A202020202020766172205F7468697335203D20746869733B0A0A202020202020646963';
wwv_flow_api.g_varchar2_table(241) := '742E6E6F6465732E65766572792866756E6374696F6E20286E2C206929207B0A2020202020202020766172207369626C203D20646963742E6E6F6465735B69202B20315D3B0A202020202020202069662028747970656F66207369626C203D3D3D202775';
wwv_flow_api.g_varchar2_table(242) := '6E646566696E656427207C7C207369626C2E7374617274203E20737461727429207B0A20202020202020202020696620282166696C7465724362286E2E6E6F64652929207B0A20202020202020202020202072657475726E2066616C73653B0A20202020';
wwv_flow_api.g_varchar2_table(243) := '2020202020207D0A202020202020202020207661722073203D207374617274202D206E2E73746172742C0A202020202020202020202020202065203D2028656E64203E206E2E656E64203F206E2E656E64203A20656E6429202D206E2E73746172742C0A';
wwv_flow_api.g_varchar2_table(244) := '20202020202020202020202020207374617274537472203D20646963742E76616C75652E73756273747228302C206E2E7374617274292C0A2020202020202020202020202020656E64537472203D20646963742E76616C75652E7375627374722865202B';
wwv_flow_api.g_varchar2_table(245) := '206E2E7374617274293B0A202020202020202020206E2E6E6F6465203D205F74686973352E7772617052616E6765496E546578744E6F6465286E2E6E6F64652C20732C2065293B0A20202020202020202020646963742E76616C7565203D207374617274';
wwv_flow_api.g_varchar2_table(246) := '537472202B20656E645374723B0A20202020202020202020646963742E6E6F6465732E666F72456163682866756E6374696F6E20286B2C206A29207B0A202020202020202020202020696620286A203E3D206929207B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(247) := '2069662028646963742E6E6F6465735B6A5D2E7374617274203E2030202626206A20213D3D206929207B0A20202020202020202020202020202020646963742E6E6F6465735B6A5D2E7374617274202D3D20653B0A20202020202020202020202020207D';
wwv_flow_api.g_varchar2_table(248) := '0A2020202020202020202020202020646963742E6E6F6465735B6A5D2E656E64202D3D20653B0A2020202020202020202020207D0A202020202020202020207D293B0A20202020202020202020656E64202D3D20653B0A20202020202020202020656163';
wwv_flow_api.g_varchar2_table(249) := '684362286E2E6E6F64652E70726576696F75735369626C696E672C206E2E7374617274293B0A2020202020202020202069662028656E64203E206E2E656E6429207B0A2020202020202020202020207374617274203D206E2E656E643B0A202020202020';
wwv_flow_api.g_varchar2_table(250) := '202020207D20656C7365207B0A20202020202020202020202072657475726E2066616C73653B0A202020202020202020207D0A20202020202020207D0A202020202020202072657475726E20747275653B0A2020202020207D293B0A202020207D0A2020';
wwv_flow_api.g_varchar2_table(251) := '7D2C207B0A202020206B65793A2027777261704D617463686573272C0A2020202076616C75653A2066756E6374696F6E20777261704D6174636865732872656765782C2069676E6F726547726F7570732C2066696C74657243622C206561636843622C20';
wwv_flow_api.g_varchar2_table(252) := '656E64436229207B0A202020202020766172205F7468697336203D20746869733B0A0A202020202020766172206D61746368496478203D2069676E6F726547726F757073203D3D3D2030203F2030203A2069676E6F726547726F757073202B20313B0A20';
wwv_flow_api.g_varchar2_table(253) := '2020202020746869732E676574546578744E6F6465732866756E6374696F6E20286469637429207B0A2020202020202020646963742E6E6F6465732E666F72456163682866756E6374696F6E20286E6F646529207B0A202020202020202020206E6F6465';
wwv_flow_api.g_varchar2_table(254) := '203D206E6F64652E6E6F64653B0A20202020202020202020766172206D61746368203D20766F696420303B0A202020202020202020207768696C652028286D61746368203D2072656765782E65786563286E6F64652E74657874436F6E74656E74292920';
wwv_flow_api.g_varchar2_table(255) := '213D3D206E756C6C202626206D617463685B6D617463684964785D20213D3D20272729207B0A202020202020202020202020696620282166696C7465724362286D617463685B6D617463684964785D2C206E6F64652929207B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(256) := '20202020636F6E74696E75653B0A2020202020202020202020207D0A20202020202020202020202076617220706F73203D206D617463682E696E6465783B0A202020202020202020202020696620286D6174636849647820213D3D203029207B0A202020';
wwv_flow_api.g_varchar2_table(257) := '2020202020202020202020666F7220287661722069203D20313B2069203C206D617463684964783B20692B2B29207B0A20202020202020202020202020202020706F73202B3D206D617463685B695D2E6C656E6774683B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(258) := '20207D0A2020202020202020202020207D0A2020202020202020202020206E6F6465203D205F74686973362E7772617052616E6765496E546578744E6F6465286E6F64652C20706F732C20706F73202B206D617463685B6D617463684964785D2E6C656E';
wwv_flow_api.g_varchar2_table(259) := '677468293B0A202020202020202020202020656163684362286E6F64652E70726576696F75735369626C696E67293B0A20202020202020202020202072656765782E6C617374496E646578203D20303B0A202020202020202020207D0A20202020202020';
wwv_flow_api.g_varchar2_table(260) := '207D293B0A2020202020202020656E64436228293B0A2020202020207D293B0A202020207D0A20207D2C207B0A202020206B65793A2027777261704D6174636865734163726F7373456C656D656E7473272C0A2020202076616C75653A2066756E637469';
wwv_flow_api.g_varchar2_table(261) := '6F6E20777261704D6174636865734163726F7373456C656D656E74732872656765782C2069676E6F726547726F7570732C2066696C74657243622C206561636843622C20656E64436229207B0A202020202020766172205F7468697337203D2074686973';
wwv_flow_api.g_varchar2_table(262) := '3B0A0A202020202020766172206D61746368496478203D2069676E6F726547726F757073203D3D3D2030203F2030203A2069676E6F726547726F757073202B20313B0A202020202020746869732E676574546578744E6F6465732866756E6374696F6E20';
wwv_flow_api.g_varchar2_table(263) := '286469637429207B0A2020202020202020766172206D61746368203D20766F696420303B0A20202020202020207768696C652028286D61746368203D2072656765782E6578656328646963742E76616C7565292920213D3D206E756C6C202626206D6174';
wwv_flow_api.g_varchar2_table(264) := '63685B6D617463684964785D20213D3D20272729207B0A20202020202020202020766172207374617274203D206D617463682E696E6465783B0A20202020202020202020696620286D6174636849647820213D3D203029207B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(265) := '2020666F7220287661722069203D20313B2069203C206D617463684964783B20692B2B29207B0A20202020202020202020202020207374617274202B3D206D617463685B695D2E6C656E6774683B0A2020202020202020202020207D0A20202020202020';
wwv_flow_api.g_varchar2_table(266) := '2020207D0A2020202020202020202076617220656E64203D207374617274202B206D617463685B6D617463684964785D2E6C656E6774683B0A202020202020202020205F74686973372E7772617052616E6765496E4D6170706564546578744E6F646528';
wwv_flow_api.g_varchar2_table(267) := '646963742C2073746172742C20656E642C2066756E6374696F6E20286E6F646529207B0A20202020202020202020202072657475726E2066696C7465724362286D617463685B6D617463684964785D2C206E6F6465293B0A202020202020202020207D2C';
wwv_flow_api.g_varchar2_table(268) := '2066756E6374696F6E20286E6F64652C206C617374496E64657829207B0A20202020202020202020202072656765782E6C617374496E646578203D206C617374496E6465783B0A202020202020202020202020656163684362286E6F6465293B0A202020';
wwv_flow_api.g_varchar2_table(269) := '202020202020207D293B0A20202020202020207D0A2020202020202020656E64436228293B0A2020202020207D293B0A202020207D0A20207D2C207B0A202020206B65793A20277772617052616E676546726F6D496E646578272C0A2020202076616C75';
wwv_flow_api.g_varchar2_table(270) := '653A2066756E6374696F6E207772617052616E676546726F6D496E6465782872616E6765732C2066696C74657243622C206561636843622C20656E64436229207B0A202020202020766172205F7468697338203D20746869733B0A0A2020202020207468';
wwv_flow_api.g_varchar2_table(271) := '69732E676574546578744E6F6465732866756E6374696F6E20286469637429207B0A2020202020202020766172206F726967696E616C4C656E677468203D20646963742E76616C75652E6C656E6774683B0A202020202020202072616E6765732E666F72';
wwv_flow_api.g_varchar2_table(272) := '456163682866756E6374696F6E202872616E67652C20636F756E74657229207B0A20202020202020202020766172205F636865636B5768697465737061636552616E6765203D205F74686973382E636865636B5768697465737061636552616E67657328';
wwv_flow_api.g_varchar2_table(273) := '72616E67652C206F726967696E616C4C656E6774682C20646963742E76616C7565292C0A20202020202020202020202020207374617274203D205F636865636B5768697465737061636552616E67652E73746172742C0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(274) := '20656E64203D205F636865636B5768697465737061636552616E67652E656E642C0A202020202020202020202020202076616C6964203D205F636865636B5768697465737061636552616E67652E76616C69643B0A0A2020202020202020202069662028';
wwv_flow_api.g_varchar2_table(275) := '76616C696429207B0A2020202020202020202020205F74686973382E7772617052616E6765496E4D6170706564546578744E6F646528646963742C2073746172742C20656E642C2066756E6374696F6E20286E6F646529207B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(276) := '2020202072657475726E2066696C7465724362286E6F64652C2072616E67652C20646963742E76616C75652E737562737472696E672873746172742C20656E64292C20636F756E746572293B0A2020202020202020202020207D2C2066756E6374696F6E';
wwv_flow_api.g_varchar2_table(277) := '20286E6F646529207B0A2020202020202020202020202020656163684362286E6F64652C2072616E6765293B0A2020202020202020202020207D293B0A202020202020202020207D0A20202020202020207D293B0A2020202020202020656E6443622829';
wwv_flow_api.g_varchar2_table(278) := '3B0A2020202020207D293B0A202020207D0A20207D2C207B0A202020206B65793A2027756E777261704D617463686573272C0A2020202076616C75653A2066756E6374696F6E20756E777261704D617463686573286E6F646529207B0A20202020202076';
wwv_flow_api.g_varchar2_table(279) := '617220706172656E74203D206E6F64652E706172656E744E6F64653B0A20202020202076617220646F6346726167203D20646F63756D656E742E637265617465446F63756D656E74467261676D656E7428293B0A2020202020207768696C6520286E6F64';
wwv_flow_api.g_varchar2_table(280) := '652E66697273744368696C6429207B0A2020202020202020646F63467261672E617070656E644368696C64286E6F64652E72656D6F76654368696C64286E6F64652E66697273744368696C6429293B0A2020202020207D0A202020202020706172656E74';
wwv_flow_api.g_varchar2_table(281) := '2E7265706C6163654368696C6428646F63467261672C206E6F6465293B0A2020202020206966202821746869732E696529207B0A2020202020202020706172656E742E6E6F726D616C697A6528293B0A2020202020207D20656C7365207B0A2020202020';
wwv_flow_api.g_varchar2_table(282) := '202020746869732E6E6F726D616C697A65546578744E6F646528706172656E74293B0A2020202020207D0A202020207D0A20207D2C207B0A202020206B65793A20276E6F726D616C697A65546578744E6F6465272C0A2020202076616C75653A2066756E';
wwv_flow_api.g_varchar2_table(283) := '6374696F6E206E6F726D616C697A65546578744E6F6465286E6F646529207B0A20202020202069662028216E6F646529207B0A202020202020202072657475726E3B0A2020202020207D0A202020202020696620286E6F64652E6E6F646554797065203D';
wwv_flow_api.g_varchar2_table(284) := '3D3D203329207B0A20202020202020207768696C6520286E6F64652E6E6578745369626C696E67202626206E6F64652E6E6578745369626C696E672E6E6F646554797065203D3D3D203329207B0A202020202020202020206E6F64652E6E6F646556616C';
wwv_flow_api.g_varchar2_table(285) := '7565202B3D206E6F64652E6E6578745369626C696E672E6E6F646556616C75653B0A202020202020202020206E6F64652E706172656E744E6F64652E72656D6F76654368696C64286E6F64652E6E6578745369626C696E67293B0A20202020202020207D';
wwv_flow_api.g_varchar2_table(286) := '0A2020202020207D20656C7365207B0A2020202020202020746869732E6E6F726D616C697A65546578744E6F6465286E6F64652E66697273744368696C64293B0A2020202020207D0A202020202020746869732E6E6F726D616C697A65546578744E6F64';
wwv_flow_api.g_varchar2_table(287) := '65286E6F64652E6E6578745369626C696E67293B0A202020207D0A20207D2C207B0A202020206B65793A20276D61726B526567457870272C0A2020202076616C75653A2066756E6374696F6E206D61726B526567457870287265676578702C206F707429';
wwv_flow_api.g_varchar2_table(288) := '207B0A202020202020766172205F7468697339203D20746869733B0A0A202020202020746869732E6F7074203D206F70743B0A202020202020746869732E6C6F672827536561726368696E6720776974682065787072657373696F6E202227202B207265';
wwv_flow_api.g_varchar2_table(289) := '67657870202B20272227293B0A20202020202076617220746F74616C4D617463686573203D20302C0A20202020202020202020666E203D2027777261704D617463686573273B0A20202020202076617220656163684362203D2066756E6374696F6E2065';
wwv_flow_api.g_varchar2_table(290) := '616368436228656C656D656E7429207B0A2020202020202020746F74616C4D6174636865732B2B3B0A20202020202020205F74686973392E6F70742E6561636828656C656D656E74293B0A2020202020207D3B0A20202020202069662028746869732E6F';
wwv_flow_api.g_varchar2_table(291) := '70742E6163726F7373456C656D656E747329207B0A2020202020202020666E203D2027777261704D6174636865734163726F7373456C656D656E7473273B0A2020202020207D0A202020202020746869735B666E5D287265676578702C20746869732E6F';
wwv_flow_api.g_varchar2_table(292) := '70742E69676E6F726547726F7570732C2066756E6374696F6E20286D617463682C206E6F646529207B0A202020202020202072657475726E205F74686973392E6F70742E66696C746572286E6F64652C206D617463682C20746F74616C4D617463686573';
wwv_flow_api.g_varchar2_table(293) := '293B0A2020202020207D2C206561636843622C2066756E6374696F6E202829207B0A202020202020202069662028746F74616C4D617463686573203D3D3D203029207B0A202020202020202020205F74686973392E6F70742E6E6F4D6174636828726567';
wwv_flow_api.g_varchar2_table(294) := '657870293B0A20202020202020207D0A20202020202020205F74686973392E6F70742E646F6E6528746F74616C4D617463686573293B0A2020202020207D293B0A202020207D0A20207D2C207B0A202020206B65793A20276D61726B272C0A2020202076';
wwv_flow_api.g_varchar2_table(295) := '616C75653A2066756E6374696F6E206D61726B2873762C206F707429207B0A202020202020766172205F746869733130203D20746869733B0A0A202020202020746869732E6F7074203D206F70743B0A20202020202076617220746F74616C4D61746368';
wwv_flow_api.g_varchar2_table(296) := '6573203D20302C0A20202020202020202020666E203D2027777261704D617463686573273B0A0A202020202020766172205F6765745365706172617465644B6579776F726473203D20746869732E6765745365706172617465644B6579776F7264732874';
wwv_flow_api.g_varchar2_table(297) := '7970656F66207376203D3D3D2027737472696E6727203F205B73765D203A207376292C0A202020202020202020206B77417272203D205F6765745365706172617465644B6579776F7264732E6B6579776F7264732C0A202020202020202020206B774172';
wwv_flow_api.g_varchar2_table(298) := '724C656E203D205F6765745365706172617465644B6579776F7264732E6C656E6774682C0A2020202020202020202073656E73203D20746869732E6F70742E6361736553656E736974697665203F202727203A202769272C0A2020202020202020202068';
wwv_flow_api.g_varchar2_table(299) := '616E646C6572203D2066756E6374696F6E2068616E646C6572286B7729207B0A2020202020202020766172207265676578203D206E657720526567457870285F7468697331302E637265617465526567457870286B77292C2027676D27202B2073656E73';
wwv_flow_api.g_varchar2_table(300) := '292C0A2020202020202020202020206D617463686573203D20303B0A20202020202020205F7468697331302E6C6F672827536561726368696E6720776974682065787072657373696F6E202227202B207265676578202B20272227293B0A202020202020';
wwv_flow_api.g_varchar2_table(301) := '20205F7468697331305B666E5D2872656765782C20312C2066756E6374696F6E20287465726D2C206E6F646529207B0A2020202020202020202072657475726E205F7468697331302E6F70742E66696C746572286E6F64652C206B772C20746F74616C4D';
wwv_flow_api.g_varchar2_table(302) := '6174636865732C206D617463686573293B0A20202020202020207D2C2066756E6374696F6E2028656C656D656E7429207B0A202020202020202020206D6174636865732B2B3B0A20202020202020202020746F74616C4D6174636865732B2B3B0A202020';
wwv_flow_api.g_varchar2_table(303) := '202020202020205F7468697331302E6F70742E6561636828656C656D656E74293B0A20202020202020207D2C2066756E6374696F6E202829207B0A20202020202020202020696620286D617463686573203D3D3D203029207B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(304) := '20205F7468697331302E6F70742E6E6F4D61746368286B77293B0A202020202020202020207D0A20202020202020202020696620286B774172725B6B774172724C656E202D20315D203D3D3D206B7729207B0A2020202020202020202020205F74686973';
wwv_flow_api.g_varchar2_table(305) := '31302E6F70742E646F6E6528746F74616C4D617463686573293B0A202020202020202020207D20656C7365207B0A20202020202020202020202068616E646C6572286B774172725B6B774172722E696E6465784F66286B7729202B20315D293B0A202020';
wwv_flow_api.g_varchar2_table(306) := '202020202020207D0A20202020202020207D293B0A2020202020207D3B0A0A20202020202069662028746869732E6F70742E6163726F7373456C656D656E747329207B0A2020202020202020666E203D2027777261704D6174636865734163726F737345';
wwv_flow_api.g_varchar2_table(307) := '6C656D656E7473273B0A2020202020207D0A202020202020696620286B774172724C656E203D3D3D203029207B0A2020202020202020746869732E6F70742E646F6E6528746F74616C4D617463686573293B0A2020202020207D20656C7365207B0A2020';
wwv_flow_api.g_varchar2_table(308) := '20202020202068616E646C6572286B774172725B305D293B0A2020202020207D0A202020207D0A20207D2C207B0A202020206B65793A20276D61726B52616E676573272C0A2020202076616C75653A2066756E6374696F6E206D61726B52616E67657328';
wwv_flow_api.g_varchar2_table(309) := '72617752616E6765732C206F707429207B0A202020202020766172205F746869733131203D20746869733B0A0A202020202020746869732E6F7074203D206F70743B0A20202020202076617220746F74616C4D617463686573203D20302C0A2020202020';
wwv_flow_api.g_varchar2_table(310) := '202020202072616E676573203D20746869732E636865636B52616E6765732872617752616E676573293B0A2020202020206966202872616E6765732026262072616E6765732E6C656E67746829207B0A2020202020202020746869732E6C6F6728275374';
wwv_flow_api.g_varchar2_table(311) := '617274696E6720746F206D61726B20776974682074686520666F6C6C6F77696E672072616E6765733A2027202B204A534F4E2E737472696E676966792872616E67657329293B0A2020202020202020746869732E7772617052616E676546726F6D496E64';
wwv_flow_api.g_varchar2_table(312) := '65782872616E6765732C2066756E6374696F6E20286E6F64652C2072616E67652C206D617463682C20636F756E74657229207B0A2020202020202020202072657475726E205F7468697331312E6F70742E66696C746572286E6F64652C2072616E67652C';
wwv_flow_api.g_varchar2_table(313) := '206D617463682C20636F756E746572293B0A20202020202020207D2C2066756E6374696F6E2028656C656D656E742C2072616E676529207B0A20202020202020202020746F74616C4D6174636865732B2B3B0A202020202020202020205F746869733131';
wwv_flow_api.g_varchar2_table(314) := '2E6F70742E6561636828656C656D656E742C2072616E6765293B0A20202020202020207D2C2066756E6374696F6E202829207B0A202020202020202020205F7468697331312E6F70742E646F6E6528746F74616C4D617463686573293B0A202020202020';
wwv_flow_api.g_varchar2_table(315) := '20207D293B0A2020202020207D20656C7365207B0A2020202020202020746869732E6F70742E646F6E6528746F74616C4D617463686573293B0A2020202020207D0A202020207D0A20207D2C207B0A202020206B65793A2027756E6D61726B272C0A2020';
wwv_flow_api.g_varchar2_table(316) := '202076616C75653A2066756E6374696F6E20756E6D61726B286F707429207B0A202020202020766172205F746869733132203D20746869733B0A0A202020202020746869732E6F7074203D206F70743B0A2020202020207661722073656C203D20746869';
wwv_flow_api.g_varchar2_table(317) := '732E6F70742E656C656D656E74203F20746869732E6F70742E656C656D656E74203A20272A273B0A20202020202073656C202B3D20275B646174612D6D61726B6A735D273B0A20202020202069662028746869732E6F70742E636C6173734E616D652920';
wwv_flow_api.g_varchar2_table(318) := '7B0A202020202020202073656C202B3D20272E27202B20746869732E6F70742E636C6173734E616D653B0A2020202020207D0A202020202020746869732E6C6F67282752656D6F76616C2073656C6563746F72202227202B2073656C202B20272227293B';
wwv_flow_api.g_varchar2_table(319) := '0A202020202020746869732E6974657261746F722E666F72456163684E6F6465284E6F646546696C7465722E53484F575F454C454D454E542C2066756E6374696F6E20286E6F646529207B0A20202020202020205F7468697331322E756E777261704D61';
wwv_flow_api.g_varchar2_table(320) := '7463686573286E6F6465293B0A2020202020207D2C2066756E6374696F6E20286E6F646529207B0A2020202020202020766172206D61746368657353656C203D20444F4D4974657261746F722E6D617463686573286E6F64652C2073656C292C0A202020';
wwv_flow_api.g_varchar2_table(321) := '2020202020202020206D6174636865734578636C756465203D205F7468697331322E6D6174636865734578636C756465286E6F6465293B0A202020202020202069662028216D61746368657353656C207C7C206D6174636865734578636C75646529207B';
wwv_flow_api.g_varchar2_table(322) := '0A2020202020202020202072657475726E204E6F646546696C7465722E46494C5445525F52454A4543543B0A20202020202020207D20656C7365207B0A2020202020202020202072657475726E204E6F646546696C7465722E46494C5445525F41434345';
wwv_flow_api.g_varchar2_table(323) := '50543B0A20202020202020207D0A2020202020207D2C20746869732E6F70742E646F6E65293B0A202020207D0A20207D2C207B0A202020206B65793A20276F7074272C0A202020207365743A2066756E6374696F6E207365742424312876616C29207B0A';
wwv_flow_api.g_varchar2_table(324) := '202020202020746869732E5F6F7074203D205F657874656E6473287B7D2C207B0A202020202020202027656C656D656E74273A2027272C0A202020202020202027636C6173734E616D65273A2027272C0A2020202020202020276578636C756465273A20';
wwv_flow_api.g_varchar2_table(325) := '5B5D2C0A202020202020202027696672616D6573273A2066616C73652C0A202020202020202027696672616D657354696D656F7574273A20353030302C0A2020202020202020277365706172617465576F7264536561726368273A20747275652C0A2020';
wwv_flow_api.g_varchar2_table(326) := '2020202020202764696163726974696373273A20747275652C0A20202020202020202773796E6F6E796D73273A207B7D2C0A2020202020202020276163637572616379273A20277061727469616C6C79272C0A2020202020202020276163726F7373456C';
wwv_flow_api.g_varchar2_table(327) := '656D656E7473273A2066616C73652C0A2020202020202020276361736553656E736974697665273A2066616C73652C0A20202020202020202769676E6F72654A6F696E657273273A2066616C73652C0A20202020202020202769676E6F726547726F7570';
wwv_flow_api.g_varchar2_table(328) := '73273A20302C0A20202020202020202769676E6F726550756E6374756174696F6E273A205B5D2C0A20202020202020202777696C646361726473273A202764697361626C6564272C0A20202020202020202765616368273A2066756E6374696F6E206561';
wwv_flow_api.g_varchar2_table(329) := '63682829207B7D2C0A2020202020202020276E6F4D61746368273A2066756E6374696F6E206E6F4D617463682829207B7D2C0A20202020202020202766696C746572273A2066756E6374696F6E2066696C7465722829207B0A2020202020202020202072';
wwv_flow_api.g_varchar2_table(330) := '657475726E20747275653B0A20202020202020207D2C0A202020202020202027646F6E65273A2066756E6374696F6E20646F6E652829207B7D2C0A2020202020202020276465627567273A2066616C73652C0A2020202020202020276C6F67273A207769';
wwv_flow_api.g_varchar2_table(331) := '6E646F772E636F6E736F6C650A2020202020207D2C2076616C293B0A202020207D2C0A202020206765743A2066756E6374696F6E206765742424312829207B0A20202020202072657475726E20746869732E5F6F70743B0A202020207D0A20207D2C207B';
wwv_flow_api.g_varchar2_table(332) := '0A202020206B65793A20276974657261746F72272C0A202020206765743A2066756E6374696F6E206765742424312829207B0A20202020202072657475726E206E657720444F4D4974657261746F7228746869732E6374782C20746869732E6F70742E69';
wwv_flow_api.g_varchar2_table(333) := '6672616D65732C20746869732E6F70742E6578636C7564652C20746869732E6F70742E696672616D657354696D656F7574293B0A202020207D0A20207D5D293B0A202072657475726E204D61726B3B0A7D28293B0A0A242E666E2E6D61726B203D206675';
wwv_flow_api.g_varchar2_table(334) := '6E6374696F6E202873762C206F707429207B0A20206E6577204D61726B28746869732E6765742829292E6D61726B2873762C206F7074293B0A202072657475726E20746869733B0A7D3B0A242E666E2E6D61726B526567457870203D2066756E6374696F';
wwv_flow_api.g_varchar2_table(335) := '6E20287265676578702C206F707429207B0A20206E6577204D61726B28746869732E6765742829292E6D61726B526567457870287265676578702C206F7074293B0A202072657475726E20746869733B0A7D3B0A242E666E2E6D61726B52616E67657320';
wwv_flow_api.g_varchar2_table(336) := '3D2066756E6374696F6E202872616E6765732C206F707429207B0A20206E6577204D61726B28746869732E6765742829292E6D61726B52616E6765732872616E6765732C206F7074293B0A202072657475726E20746869733B0A7D3B0A242E666E2E756E';
wwv_flow_api.g_varchar2_table(337) := '6D61726B203D2066756E6374696F6E20286F707429207B0A20206E6577204D61726B28746869732E6765742829292E756E6D61726B286F7074293B0A202072657475726E20746869733B0A7D3B0A0A72657475726E20243B0A0A7D2929293B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(4568068986876268)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_file_name=>'js/jquery.mark.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2166756E6374696F6E28652C74297B226F626A656374223D3D747970656F66206578706F727473262622756E646566696E656422213D747970656F66206D6F64756C653F6D6F64756C652E6578706F7274733D74287265717569726528226A7175657279';
wwv_flow_api.g_varchar2_table(2) := '2229293A2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B226A7175657279225D2C74293A652E4D61726B3D7428652E6A5175657279297D28746869732C66756E6374696F6E2865297B';
wwv_flow_api.g_varchar2_table(3) := '2275736520737472696374223B653D652626652E6861734F776E50726F7065727479282264656661756C7422293F652E64656661756C743A653B76617220723D2266756E6374696F6E223D3D747970656F662053796D626F6C26262273796D626F6C223D';
wwv_flow_api.g_varchar2_table(4) := '3D747970656F662053796D626F6C2E6974657261746F723F66756E6374696F6E2865297B72657475726E20747970656F6620657D3A66756E6374696F6E2865297B72657475726E206526262266756E6374696F6E223D3D747970656F662053796D626F6C';
wwv_flow_api.g_varchar2_table(5) := '2626652E636F6E7374727563746F723D3D3D53796D626F6C262665213D3D53796D626F6C2E70726F746F747970653F2273796D626F6C223A747970656F6620657D2C693D66756E6374696F6E28652C74297B69662821286520696E7374616E63656F6620';
wwv_flow_api.g_varchar2_table(6) := '7429297468726F77206E657720547970654572726F72282243616E6E6F742063616C6C206120636C61737320617320612066756E6374696F6E22297D2C743D66756E6374696F6E28297B66756E6374696F6E207228652C74297B666F7228766172206E3D';
wwv_flow_api.g_varchar2_table(7) := '303B6E3C742E6C656E6774683B6E2B2B297B76617220723D745B6E5D3B722E656E756D657261626C653D722E656E756D657261626C657C7C21312C722E636F6E666967757261626C653D21302C2276616C756522696E2072262628722E7772697461626C';
wwv_flow_api.g_varchar2_table(8) := '653D2130292C4F626A6563742E646566696E6550726F706572747928652C722E6B65792C72297D7D72657475726E2066756E6374696F6E28652C742C6E297B72657475726E207426267228652E70726F746F747970652C74292C6E26267228652C6E292C';
wwv_flow_api.g_varchar2_table(9) := '657D7D28292C6F3D4F626A6563742E61737369676E7C7C66756E6374696F6E2865297B666F722876617220743D313B743C617267756D656E74732E6C656E6774683B742B2B297B766172206E3D617267756D656E74735B745D3B666F7228766172207220';
wwv_flow_api.g_varchar2_table(10) := '696E206E294F626A6563742E70726F746F747970652E6861734F776E50726F70657274792E63616C6C286E2C7229262628655B725D3D6E5B725D297D72657475726E20657D2C613D66756E6374696F6E28297B66756E6374696F6E20752865297B766172';
wwv_flow_api.g_varchar2_table(11) := '20743D2128313C617267756D656E74732E6C656E6774682626766F69642030213D3D617267756D656E74735B315D297C7C617267756D656E74735B315D2C6E3D323C617267756D656E74732E6C656E6774682626766F69642030213D3D617267756D656E';
wwv_flow_api.g_varchar2_table(12) := '74735B325D3F617267756D656E74735B325D3A5B5D2C723D333C617267756D656E74732E6C656E6774682626766F69642030213D3D617267756D656E74735B335D3F617267756D656E74735B335D3A3565333B6928746869732C75292C746869732E6374';
wwv_flow_api.g_varchar2_table(13) := '783D652C746869732E696672616D65733D742C746869732E6578636C7564653D6E2C746869732E696672616D657354696D656F75743D727D72657475726E207428752C5B7B6B65793A22676574436F6E7465787473222C76616C75653A66756E6374696F';
wwv_flow_api.g_varchar2_table(14) := '6E28297B766172206E3D5B5D3B72657475726E28766F69642030213D3D746869732E6374782626746869732E6374783F4E6F64654C6973742E70726F746F747970652E697350726F746F747970654F6628746869732E637478293F41727261792E70726F';
wwv_flow_api.g_varchar2_table(15) := '746F747970652E736C6963652E63616C6C28746869732E637478293A41727261792E6973417272617928746869732E637478293F746869732E6374783A22737472696E67223D3D747970656F6620746869732E6374783F41727261792E70726F746F7479';
wwv_flow_api.g_varchar2_table(16) := '70652E736C6963652E63616C6C28646F63756D656E742E717565727953656C6563746F72416C6C28746869732E63747829293A5B746869732E6374785D3A5B5D292E666F72456163682866756E6374696F6E2874297B76617220653D303C6E2E66696C74';
wwv_flow_api.g_varchar2_table(17) := '65722866756E6374696F6E2865297B72657475726E20652E636F6E7461696E732874297D292E6C656E6774683B2D31213D3D6E2E696E6465784F662874297C7C657C7C6E2E707573682874297D292C6E7D7D2C7B6B65793A22676574496672616D65436F';
wwv_flow_api.g_varchar2_table(18) := '6E74656E7473222C76616C75653A66756E6374696F6E28652C74297B766172206E3D323C617267756D656E74732E6C656E6774682626766F69642030213D3D617267756D656E74735B325D3F617267756D656E74735B325D3A66756E6374696F6E28297B';
wwv_flow_api.g_varchar2_table(19) := '7D2C723D766F696420303B7472797B76617220693D652E636F6E74656E7457696E646F773B696628723D692E646F63756D656E742C21697C7C2172297468726F77206E6577204572726F722822696672616D6520696E61636365737369626C6522297D63';
wwv_flow_api.g_varchar2_table(20) := '617463682865297B6E28297D722626742872297D7D2C7B6B65793A226973496672616D65426C616E6B222C76616C75653A66756E6374696F6E2865297B76617220743D2261626F75743A626C616E6B222C6E3D652E676574417474726962757465282273';
wwv_flow_api.g_varchar2_table(21) := '726322292E7472696D28293B72657475726E20652E636F6E74656E7457696E646F772E6C6F636174696F6E2E687265663D3D3D7426266E213D3D7426266E7D7D2C7B6B65793A226F627365727665496672616D654C6F6164222C76616C75653A66756E63';
wwv_flow_api.g_varchar2_table(22) := '74696F6E28742C6E2C72297B76617220693D746869732C6F3D21312C613D6E756C6C2C653D66756E6374696F6E206528297B696628216F297B6F3D21302C636C65617254696D656F75742861293B7472797B692E6973496672616D65426C616E6B287429';
wwv_flow_api.g_varchar2_table(23) := '7C7C28742E72656D6F76654576656E744C697374656E657228226C6F6164222C65292C692E676574496672616D65436F6E74656E747328742C6E2C7229297D63617463682865297B7228297D7D7D3B742E6164644576656E744C697374656E657228226C';
wwv_flow_api.g_varchar2_table(24) := '6F6164222C65292C613D73657454696D656F757428652C746869732E696672616D657354696D656F7574297D7D2C7B6B65793A226F6E496672616D655265616479222C76616C75653A66756E6374696F6E28652C742C6E297B7472797B22636F6D706C65';
wwv_flow_api.g_varchar2_table(25) := '7465223D3D3D652E636F6E74656E7457696E646F772E646F63756D656E742E726561647953746174653F746869732E6973496672616D65426C616E6B2865293F746869732E6F627365727665496672616D654C6F616428652C742C6E293A746869732E67';
wwv_flow_api.g_varchar2_table(26) := '6574496672616D65436F6E74656E747328652C742C6E293A746869732E6F627365727665496672616D654C6F616428652C742C6E297D63617463682865297B6E28297D7D7D2C7B6B65793A2277616974466F72496672616D6573222C76616C75653A6675';
wwv_flow_api.g_varchar2_table(27) := '6E6374696F6E28652C74297B766172206E3D746869732C723D303B746869732E666F7245616368496672616D6528652C66756E6374696F6E28297B72657475726E21307D2C66756E6374696F6E2865297B722B2B2C6E2E77616974466F72496672616D65';
wwv_flow_api.g_varchar2_table(28) := '7328652E717565727953656C6563746F72282268746D6C22292C66756E6374696F6E28297B2D2D727C7C7428297D297D2C66756E6374696F6E2865297B657C7C7428297D297D7D2C7B6B65793A22666F7245616368496672616D65222C76616C75653A66';
wwv_flow_api.g_varchar2_table(29) := '756E6374696F6E28652C6E2C72297B76617220693D746869732C743D333C617267756D656E74732E6C656E6774682626766F69642030213D3D617267756D656E74735B335D3F617267756D656E74735B335D3A66756E6374696F6E28297B7D2C6F3D652E';
wwv_flow_api.g_varchar2_table(30) := '717565727953656C6563746F72416C6C2822696672616D6522292C613D6F2E6C656E6774682C733D303B6F3D41727261792E70726F746F747970652E736C6963652E63616C6C286F293B76617220633D66756E6374696F6E28297B2D2D613C3D30262674';
wwv_flow_api.g_varchar2_table(31) := '2873297D3B617C7C6328292C6F2E666F72456163682866756E6374696F6E2874297B752E6D61746368657328742C692E6578636C756465293F6328293A692E6F6E496672616D65526561647928742C66756E6374696F6E2865297B6E287429262628732B';
wwv_flow_api.g_varchar2_table(32) := '2B2C72286529292C6328297D2C63297D297D7D2C7B6B65793A226372656174654974657261746F72222C76616C75653A66756E6374696F6E28652C742C6E297B72657475726E20646F63756D656E742E6372656174654E6F64654974657261746F722865';
wwv_flow_api.g_varchar2_table(33) := '2C742C6E2C2131297D7D2C7B6B65793A22637265617465496E7374616E63654F6E496672616D65222C76616C75653A66756E6374696F6E2865297B72657475726E206E6577207528652E717565727953656C6563746F72282268746D6C22292C74686973';
wwv_flow_api.g_varchar2_table(34) := '2E696672616D6573297D7D2C7B6B65793A22636F6D706172654E6F6465496672616D65222C76616C75653A66756E6374696F6E28652C742C6E297B696628652E636F6D70617265446F63756D656E74506F736974696F6E286E29264E6F64652E444F4355';
wwv_flow_api.g_varchar2_table(35) := '4D454E545F504F534954494F4E5F505245434544494E47297B6966286E756C6C3D3D3D742972657475726E21303B696628742E636F6D70617265446F63756D656E74506F736974696F6E286E29264E6F64652E444F43554D454E545F504F534954494F4E';
wwv_flow_api.g_varchar2_table(36) := '5F464F4C4C4F57494E472972657475726E21307D72657475726E21317D7D2C7B6B65793A226765744974657261746F724E6F6465222C76616C75653A66756E6374696F6E2865297B76617220743D652E70726576696F75734E6F646528293B7265747572';
wwv_flow_api.g_varchar2_table(37) := '6E7B707265764E6F64653A742C6E6F64653A6E756C6C3D3D3D743F652E6E6578744E6F646528293A652E6E6578744E6F646528292626652E6E6578744E6F646528297D7D7D2C7B6B65793A22636865636B496672616D6546696C746572222C76616C7565';
wwv_flow_api.g_varchar2_table(38) := '3A66756E6374696F6E28652C742C6E2C72297B76617220693D21312C6F3D21313B72657475726E20722E666F72456163682866756E6374696F6E28652C74297B652E76616C3D3D3D6E262628693D742C6F3D652E68616E646C6564297D292C746869732E';
wwv_flow_api.g_varchar2_table(39) := '636F6D706172654E6F6465496672616D6528652C742C6E293F282131213D3D697C7C6F3F21313D3D3D697C7C6F7C7C28725B695D2E68616E646C65643D2130293A722E70757368287B76616C3A6E2C68616E646C65643A21307D292C2130293A2821313D';
wwv_flow_api.g_varchar2_table(40) := '3D3D692626722E70757368287B76616C3A6E2C68616E646C65643A21317D292C2131297D7D2C7B6B65793A2268616E646C654F70656E496672616D6573222C76616C75653A66756E6374696F6E28652C742C6E2C72297B76617220693D746869733B652E';
wwv_flow_api.g_varchar2_table(41) := '666F72456163682866756E6374696F6E2865297B652E68616E646C65647C7C692E676574496672616D65436F6E74656E747328652E76616C2C66756E6374696F6E2865297B692E637265617465496E7374616E63654F6E496672616D652865292E666F72';
wwv_flow_api.g_varchar2_table(42) := '456163684E6F646528742C6E2C72297D297D297D7D2C7B6B65793A22697465726174655468726F7567684E6F646573222C76616C75653A66756E6374696F6E28742C652C6E2C722C69297B666F7228766172206F2C613D746869732C733D746869732E63';
wwv_flow_api.g_varchar2_table(43) := '72656174654974657261746F7228652C742C72292C633D5B5D2C753D5B5D2C6C3D766F696420302C683D766F696420303B766F696420302C6F3D612E6765744974657261746F724E6F64652873292C683D6F2E707265764E6F64652C6C3D6F2E6E6F6465';
wwv_flow_api.g_varchar2_table(44) := '3B29746869732E696672616D65732626746869732E666F7245616368496672616D6528652C66756E6374696F6E2865297B72657475726E20612E636865636B496672616D6546696C746572286C2C682C652C63297D2C66756E6374696F6E2865297B612E';
wwv_flow_api.g_varchar2_table(45) := '637265617465496E7374616E63654F6E496672616D652865292E666F72456163684E6F646528742C66756E6374696F6E2865297B72657475726E20752E707573682865297D2C72297D292C752E70757368286C293B752E666F72456163682866756E6374';
wwv_flow_api.g_varchar2_table(46) := '696F6E2865297B6E2865297D292C746869732E696672616D65732626746869732E68616E646C654F70656E496672616D657328632C742C6E2C72292C6928297D7D2C7B6B65793A22666F72456163684E6F6465222C76616C75653A66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(47) := '6E2C722C69297B766172206F3D746869732C613D333C617267756D656E74732E6C656E6774682626766F69642030213D3D617267756D656E74735B335D3F617267756D656E74735B335D3A66756E6374696F6E28297B7D2C653D746869732E676574436F';
wwv_flow_api.g_varchar2_table(48) := '6E746578747328292C733D652E6C656E6774683B737C7C6128292C652E666F72456163682866756E6374696F6E2865297B76617220743D66756E6374696F6E28297B6F2E697465726174655468726F7567684E6F646573286E2C652C722C692C66756E63';
wwv_flow_api.g_varchar2_table(49) := '74696F6E28297B2D2D733C3D3026266128297D297D3B6F2E696672616D65733F6F2E77616974466F72496672616D657328652C74293A7428297D297D7D5D2C5B7B6B65793A226D617463686573222C76616C75653A66756E6374696F6E28742C65297B76';
wwv_flow_api.g_varchar2_table(50) := '6172206E3D22737472696E67223D3D747970656F6620653F5B655D3A652C723D742E6D6174636865737C7C742E6D61746368657353656C6563746F727C7C742E6D734D61746368657353656C6563746F727C7C742E6D6F7A4D61746368657353656C6563';
wwv_flow_api.g_varchar2_table(51) := '746F727C7C742E6F4D61746368657353656C6563746F727C7C742E7765626B69744D61746368657353656C6563746F723B69662872297B76617220693D21313B72657475726E206E2E65766572792866756E6374696F6E2865297B72657475726E21722E';
wwv_flow_api.g_varchar2_table(52) := '63616C6C28742C65297C7C2128693D2130297D292C697D72657475726E21317D7D5D292C757D28292C6E3D66756E6374696F6E28297B66756E6374696F6E206E2865297B6928746869732C6E292C746869732E6374783D652C746869732E69653D21313B';
wwv_flow_api.g_varchar2_table(53) := '76617220743D77696E646F772E6E6176696761746F722E757365724167656E743B282D313C742E696E6465784F6628224D53494522297C7C2D313C742E696E6465784F66282254726964656E74222929262628746869732E69653D2130297D7265747572';
wwv_flow_api.g_varchar2_table(54) := '6E2074286E2C5B7B6B65793A226C6F67222C76616C75653A66756E6374696F6E2865297B76617220743D313C617267756D656E74732E6C656E6774682626766F69642030213D3D617267756D656E74735B315D3F617267756D656E74735B315D3A226465';
wwv_flow_api.g_varchar2_table(55) := '627567222C6E3D746869732E6F70742E6C6F673B746869732E6F70742E64656275672626226F626A656374223D3D3D28766F696420303D3D3D6E3F22756E646566696E6564223A72286E292926262266756E6374696F6E223D3D747970656F66206E5B74';
wwv_flow_api.g_varchar2_table(56) := '5D26266E5B745D28226D61726B2E6A733A20222B65297D7D2C7B6B65793A22657363617065537472222C76616C75653A66756E6374696F6E2865297B72657475726E20652E7265706C616365282F5B5C2D5C5B5C5D5C2F5C7B5C7D5C285C295C2A5C2B5C';
wwv_flow_api.g_varchar2_table(57) := '3F5C2E5C5C5C5E5C245C7C5D2F672C225C5C242622297D7D2C7B6B65793A22637265617465526567457870222C76616C75653A66756E6374696F6E2865297B72657475726E2264697361626C656422213D3D746869732E6F70742E77696C646361726473';
wwv_flow_api.g_varchar2_table(58) := '262628653D746869732E736574757057696C646361726473526567457870286529292C653D746869732E6573636170655374722865292C4F626A6563742E6B65797328746869732E6F70742E73796E6F6E796D73292E6C656E677468262628653D746869';
wwv_flow_api.g_varchar2_table(59) := '732E63726561746553796E6F6E796D73526567457870286529292C28746869732E6F70742E69676E6F72654A6F696E6572737C7C746869732E6F70742E69676E6F726550756E6374756174696F6E2E6C656E67746829262628653D746869732E73657475';
wwv_flow_api.g_varchar2_table(60) := '7049676E6F72654A6F696E657273526567457870286529292C746869732E6F70742E64696163726974696373262628653D746869732E63726561746544696163726974696373526567457870286529292C653D746869732E6372656174654D6572676564';
wwv_flow_api.g_varchar2_table(61) := '426C616E6B735265674578702865292C28746869732E6F70742E69676E6F72654A6F696E6572737C7C746869732E6F70742E69676E6F726550756E6374756174696F6E2E6C656E67746829262628653D746869732E6372656174654A6F696E6572735265';
wwv_flow_api.g_varchar2_table(62) := '67457870286529292C2264697361626C656422213D3D746869732E6F70742E77696C646361726473262628653D746869732E63726561746557696C646361726473526567457870286529292C653D746869732E6372656174654163637572616379526567';
wwv_flow_api.g_varchar2_table(63) := '4578702865297D7D2C7B6B65793A2263726561746553796E6F6E796D73526567457870222C76616C75653A66756E6374696F6E2865297B76617220743D746869732E6F70742E73796E6F6E796D732C6E3D746869732E6F70742E6361736553656E736974';
wwv_flow_api.g_varchar2_table(64) := '6976653F22223A2269222C723D746869732E6F70742E69676E6F72654A6F696E6572737C7C746869732E6F70742E69676E6F726550756E6374756174696F6E2E6C656E6774683F225C30223A22223B666F7228766172206920696E207429696628742E68';
wwv_flow_api.g_varchar2_table(65) := '61734F776E50726F7065727479286929297B766172206F3D745B695D2C613D2264697361626C656422213D3D746869732E6F70742E77696C6463617264733F746869732E736574757057696C6463617264735265674578702869293A746869732E657363';
wwv_flow_api.g_varchar2_table(66) := '6170655374722869292C733D2264697361626C656422213D3D746869732E6F70742E77696C6463617264733F746869732E736574757057696C646361726473526567457870286F293A746869732E657363617065537472286F293B2222213D3D61262622';
wwv_flow_api.g_varchar2_table(67) := '22213D3D73262628653D652E7265706C616365286E657720526567457870282228222B746869732E6573636170655374722861292B227C222B746869732E6573636170655374722873292B2229222C22676D222B6E292C722B2228222B746869732E7072';
wwv_flow_api.g_varchar2_table(68) := '6F6365737353796E6F6D796D732861292B227C222B746869732E70726F6365737353796E6F6D796D732873292B2229222B7229297D72657475726E20657D7D2C7B6B65793A2270726F6365737353796E6F6D796D73222C76616C75653A66756E6374696F';
wwv_flow_api.g_varchar2_table(69) := '6E2865297B72657475726E28746869732E6F70742E69676E6F72654A6F696E6572737C7C746869732E6F70742E69676E6F726550756E6374756174696F6E2E6C656E67746829262628653D746869732E736574757049676E6F72654A6F696E6572735265';
wwv_flow_api.g_varchar2_table(70) := '67457870286529292C657D7D2C7B6B65793A22736574757057696C646361726473526567457870222C76616C75653A66756E6374696F6E2865297B72657475726E28653D652E7265706C616365282F283F3A5C5C292A5C3F2F672C66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(71) := '65297B72657475726E225C5C223D3D3D652E6368617241742830293F223F223A2201227D29292E7265706C616365282F283F3A5C5C292A5C2A2F672C66756E6374696F6E2865297B72657475726E225C5C223D3D3D652E6368617241742830293F222A22';
wwv_flow_api.g_varchar2_table(72) := '3A2202227D297D7D2C7B6B65793A2263726561746557696C646361726473526567457870222C76616C75653A66756E6374696F6E2865297B76617220743D2277697468537061636573223D3D3D746869732E6F70742E77696C6463617264733B72657475';
wwv_flow_api.g_varchar2_table(73) := '726E20652E7265706C616365282F5C75303030312F672C743F225B5C5C535C5C735D3F223A225C5C533F22292E7265706C616365282F5C75303030322F672C743F225B5C5C535C5C735D2A3F223A225C5C532A22297D7D2C7B6B65793A22736574757049';
wwv_flow_api.g_varchar2_table(74) := '676E6F72654A6F696E657273526567457870222C76616C75653A66756E6374696F6E2865297B72657475726E20652E7265706C616365282F5B5E287C295C5C5D2F672C66756E6374696F6E28652C742C6E297B76617220723D6E2E63686172417428742B';
wwv_flow_api.g_varchar2_table(75) := '31293B72657475726E2F5B287C295C5C5D2F2E746573742872297C7C22223D3D3D723F653A652B225C30227D297D7D2C7B6B65793A226372656174654A6F696E657273526567457870222C76616C75653A66756E6374696F6E2865297B76617220743D5B';
wwv_flow_api.g_varchar2_table(76) := '5D2C6E3D746869732E6F70742E69676E6F726550756E6374756174696F6E3B72657475726E2041727261792E69734172726179286E2926266E2E6C656E6774682626742E7075736828746869732E657363617065537472286E2E6A6F696E282222292929';
wwv_flow_api.g_varchar2_table(77) := '2C746869732E6F70742E69676E6F72654A6F696E6572732626742E7075736828225C5C75303061645C5C75323030625C5C75323030635C5C753230306422292C742E6C656E6774683F652E73706C6974282F5C75303030302B2F292E6A6F696E28225B22';
wwv_flow_api.g_varchar2_table(78) := '2B742E6A6F696E282222292B225D2A22293A657D7D2C7B6B65793A2263726561746544696163726974696373526567457870222C76616C75653A66756E6374696F6E286E297B76617220723D746869732E6F70742E6361736553656E7369746976653F22';
wwv_flow_api.g_varchar2_table(79) := '223A2269222C653D746869732E6F70742E6361736553656E7369746976653F5B2261C3A0C3A1E1BAA3C3A3E1BAA1C483E1BAB1E1BAAFE1BAB3E1BAB5E1BAB7C3A2E1BAA7E1BAA5E1BAA9E1BAABE1BAADC3A4C3A5C481C485222C2241C380C381E1BAA2C3';
wwv_flow_api.g_varchar2_table(80) := '83E1BAA0C482E1BAB0E1BAAEE1BAB2E1BAB4E1BAB6C382E1BAA6E1BAA4E1BAA8E1BAAAE1BAACC384C385C480C484222C2263C3A7C487C48D222C2243C387C486C48C222C2264C491C48F222C2244C490C48E222C2265C3A8C3A9E1BABBE1BABDE1BAB9C3';
wwv_flow_api.g_varchar2_table(81) := 'AAE1BB81E1BABFE1BB83E1BB85E1BB87C3ABC49BC493C499222C2245C388C389E1BABAE1BABCE1BAB8C38AE1BB80E1BABEE1BB82E1BB84E1BB86C38BC49AC492C498222C2269C3ACC3ADE1BB89C4A9E1BB8BC3AEC3AFC4AB222C2249C38CC38DE1BB88C4';
wwv_flow_api.g_varchar2_table(82) := 'A8E1BB8AC38EC38FC4AA222C226CC582222C224CC581222C226EC3B1C588C584222C224EC391C587C583222C226FC3B2C3B3E1BB8FC3B5E1BB8DC3B4E1BB93E1BB91E1BB95E1BB97E1BB99C6A1E1BB9FE1BBA1E1BB9BE1BB9DE1BBA3C3B6C3B8C58D222C';
wwv_flow_api.g_varchar2_table(83) := '224FC392C393E1BB8EC395E1BB8CC394E1BB92E1BB90E1BB94E1BB96E1BB98C6A0E1BB9EE1BBA0E1BB9AE1BB9CE1BBA2C396C398C58C222C2272C599222C2252C598222C2273C5A1C59BC899C59F222C2253C5A0C59AC898C59E222C2274C5A5C89BC5A3';
wwv_flow_api.g_varchar2_table(84) := '222C2254C5A4C89AC5A2222C2275C3B9C3BAE1BBA7C5A9E1BBA5C6B0E1BBABE1BBA9E1BBADE1BBAFE1BBB1C3BBC3BCC5AFC5AB222C2255C399C39AE1BBA6C5A8E1BBA4C6AFE1BBAAE1BBA8E1BBACE1BBAEE1BBB0C39BC39CC5AEC5AA222C2279C3BDE1BB';
wwv_flow_api.g_varchar2_table(85) := 'B3E1BBB7E1BBB9E1BBB5C3BF222C2259C39DE1BBB2E1BBB6E1BBB8E1BBB4C5B8222C227AC5BEC5BCC5BA222C225AC5BDC5BBC5B9225D3A5B2261C3A0C3A1E1BAA3C3A3E1BAA1C483E1BAB1E1BAAFE1BAB3E1BAB5E1BAB7C3A2E1BAA7E1BAA5E1BAA9E1BA';
wwv_flow_api.g_varchar2_table(86) := 'ABE1BAADC3A4C3A5C481C48541C380C381E1BAA2C383E1BAA0C482E1BAB0E1BAAEE1BAB2E1BAB4E1BAB6C382E1BAA6E1BAA4E1BAA8E1BAAAE1BAACC384C385C480C484222C2263C3A7C487C48D43C387C486C48C222C2264C491C48F44C490C48E222C22';
wwv_flow_api.g_varchar2_table(87) := '65C3A8C3A9E1BABBE1BABDE1BAB9C3AAE1BB81E1BABFE1BB83E1BB85E1BB87C3ABC49BC493C49945C388C389E1BABAE1BABCE1BAB8C38AE1BB80E1BABEE1BB82E1BB84E1BB86C38BC49AC492C498222C2269C3ACC3ADE1BB89C4A9E1BB8BC3AEC3AFC4AB';
wwv_flow_api.g_varchar2_table(88) := '49C38CC38DE1BB88C4A8E1BB8AC38EC38FC4AA222C226CC5824CC581222C226EC3B1C588C5844EC391C587C583222C226FC3B2C3B3E1BB8FC3B5E1BB8DC3B4E1BB93E1BB91E1BB95E1BB97E1BB99C6A1E1BB9FE1BBA1E1BB9BE1BB9DE1BBA3C3B6C3B8C5';
wwv_flow_api.g_varchar2_table(89) := '8D4FC392C393E1BB8EC395E1BB8CC394E1BB92E1BB90E1BB94E1BB96E1BB98C6A0E1BB9EE1BBA0E1BB9AE1BB9CE1BBA2C396C398C58C222C2272C59952C598222C2273C5A1C59BC899C59F53C5A0C59AC898C59E222C2274C5A5C89BC5A354C5A4C89AC5';
wwv_flow_api.g_varchar2_table(90) := 'A2222C2275C3B9C3BAE1BBA7C5A9E1BBA5C6B0E1BBABE1BBA9E1BBADE1BBAFE1BBB1C3BBC3BCC5AFC5AB55C399C39AE1BBA6C5A8E1BBA4C6AFE1BBAAE1BBA8E1BBACE1BBAEE1BBB0C39BC39CC5AEC5AA222C2279C3BDE1BBB3E1BBB7E1BBB9E1BBB5C3BF';
wwv_flow_api.g_varchar2_table(91) := '59C39DE1BBB2E1BBB6E1BBB8E1BBB4C5B8222C227AC5BEC5BCC5BA5AC5BDC5BBC5B9225D2C693D5B5D3B72657475726E206E2E73706C6974282222292E666F72456163682866756E6374696F6E2874297B652E65766572792866756E6374696F6E286529';
wwv_flow_api.g_varchar2_table(92) := '7B6966282D31213D3D652E696E6465784F66287429297B6966282D313C692E696E6465784F662865292972657475726E21313B6E3D6E2E7265706C616365286E65772052656745787028225B222B652B225D222C22676D222B72292C225B222B652B225D';
wwv_flow_api.g_varchar2_table(93) := '22292C692E707573682865297D72657475726E21307D297D292C6E7D7D2C7B6B65793A226372656174654D6572676564426C616E6B73526567457870222C76616C75653A66756E6374696F6E2865297B72657475726E20652E7265706C616365282F5B5C';
wwv_flow_api.g_varchar2_table(94) := '735D2B2F67696D2C225B5C5C735D2B22297D7D2C7B6B65793A226372656174654163637572616379526567457870222C76616C75653A66756E6374696F6E2865297B76617220743D746869732C6E3D746869732E6F70742E61636375726163792C723D22';
wwv_flow_api.g_varchar2_table(95) := '737472696E67223D3D747970656F66206E3F6E3A6E2E76616C75652C693D22737472696E67223D3D747970656F66206E3F5B5D3A6E2E6C696D69746572732C6F3D22223B73776974636828692E666F72456163682866756E6374696F6E2865297B6F2B3D';
wwv_flow_api.g_varchar2_table(96) := '227C222B742E6573636170655374722865297D292C72297B63617365227061727469616C6C79223A64656661756C743A72657475726E22282928222B652B2229223B6361736522636F6D706C656D656E74617279223A72657475726E222829285B5E222B';
wwv_flow_api.g_varchar2_table(97) := '286F3D225C5C73222B286F7C7C746869732E6573636170655374722822215C22232425262728292A2B2C2D2E2F3A3B3C3D3E3F405B5C5C5D5E5F607B7C7D7EC2A1C2BF222929292B225D2A222B652B225B5E222B6F2B225D2A29223B6361736522657861';
wwv_flow_api.g_varchar2_table(98) := '63746C79223A72657475726E22285E7C5C5C73222B6F2B222928222B652B2229283F3D247C5C5C73222B6F2B2229227D7D7D2C7B6B65793A226765745365706172617465644B6579776F726473222C76616C75653A66756E6374696F6E2865297B766172';
wwv_flow_api.g_varchar2_table(99) := '20743D746869732C6E3D5B5D3B72657475726E20652E666F72456163682866756E6374696F6E2865297B742E6F70742E7365706172617465576F72645365617263683F652E73706C697428222022292E666F72456163682866756E6374696F6E2865297B';
wwv_flow_api.g_varchar2_table(100) := '652E7472696D282926262D313D3D3D6E2E696E6465784F6628652926266E2E707573682865297D293A652E7472696D282926262D313D3D3D6E2E696E6465784F6628652926266E2E707573682865297D292C7B6B6579776F7264733A6E2E736F72742866';
wwv_flow_api.g_varchar2_table(101) := '756E6374696F6E28652C74297B72657475726E20742E6C656E6774682D652E6C656E6774687D292C6C656E6774683A6E2E6C656E6774687D7D7D2C7B6B65793A2269734E756D65726963222C76616C75653A66756E6374696F6E2865297B72657475726E';
wwv_flow_api.g_varchar2_table(102) := '204E756D626572287061727365466C6F6174286529293D3D657D7D2C7B6B65793A22636865636B52616E676573222C76616C75653A66756E6374696F6E2865297B76617220693D746869733B6966282141727261792E697341727261792865297C7C225B';
wwv_flow_api.g_varchar2_table(103) := '6F626A656374204F626A6563745D22213D3D4F626A6563742E70726F746F747970652E746F537472696E672E63616C6C28655B305D292972657475726E20746869732E6C6F6728226D61726B52616E67657328292077696C6C206F6E6C79206163636570';
wwv_flow_api.g_varchar2_table(104) := '7420616E206172726179206F66206F626A6563747322292C746869732E6F70742E6E6F4D617463682865292C5B5D3B766172206F3D5B5D2C613D303B72657475726E20652E736F72742866756E6374696F6E28652C74297B72657475726E20652E737461';
wwv_flow_api.g_varchar2_table(105) := '72742D742E73746172747D292E666F72456163682866756E6374696F6E2865297B76617220743D692E63616C6C4E6F4D617463684F6E496E76616C696452616E67657328652C61292C6E3D742E73746172742C723D742E656E643B742E76616C69642626';
wwv_flow_api.g_varchar2_table(106) := '28652E73746172743D6E2C652E6C656E6774683D722D6E2C6F2E707573682865292C613D72297D292C6F7D7D2C7B6B65793A2263616C6C4E6F4D617463684F6E496E76616C696452616E676573222C76616C75653A66756E6374696F6E28652C74297B76';
wwv_flow_api.g_varchar2_table(107) := '6172206E3D766F696420302C723D766F696420302C693D21313B72657475726E20652626766F69642030213D3D652E73746172743F28723D286E3D7061727365496E7428652E73746172742C313029292B7061727365496E7428652E6C656E6774682C31';
wwv_flow_api.g_varchar2_table(108) := '30292C746869732E69734E756D6572696328652E7374617274292626746869732E69734E756D6572696328652E6C656E677468292626303C722D742626303C722D6E3F693D21303A28746869732E6C6F67282249676E6F72696E6720696E76616C696420';
wwv_flow_api.g_varchar2_table(109) := '6F72206F7665726C617070696E672072616E67653A20222B4A534F4E2E737472696E67696679286529292C746869732E6F70742E6E6F4D6174636828652929293A28746869732E6C6F67282249676E6F72696E6720696E76616C69642072616E67653A20';
wwv_flow_api.g_varchar2_table(110) := '222B4A534F4E2E737472696E67696679286529292C746869732E6F70742E6E6F4D61746368286529292C7B73746172743A6E2C656E643A722C76616C69643A697D7D7D2C7B6B65793A22636865636B5768697465737061636552616E676573222C76616C';
wwv_flow_api.g_varchar2_table(111) := '75653A66756E6374696F6E28652C742C6E297B76617220723D766F696420302C693D21302C6F3D6E2E6C656E6774682C613D742D6F2C733D7061727365496E7428652E73746172742C3130292D613B72657475726E206F3C28723D28733D6F3C733F6F3A';
wwv_flow_api.g_varchar2_table(112) := '73292B7061727365496E7428652E6C656E6774682C31302929262628723D6F2C746869732E6C6F672822456E642072616E6765206175746F6D61746963616C6C792073657420746F20746865206D61782076616C7565206F6620222B6F29292C733C307C';
wwv_flow_api.g_varchar2_table(113) := '7C722D733C307C7C6F3C737C7C6F3C723F28693D21312C746869732E6C6F672822496E76616C69642072616E67653A20222B4A534F4E2E737472696E67696679286529292C746869732E6F70742E6E6F4D61746368286529293A22223D3D3D6E2E737562';
wwv_flow_api.g_varchar2_table(114) := '737472696E6728732C72292E7265706C616365282F5C732B2F672C222229262628693D21312C746869732E6C6F672822536B697070696E672077686974657370616365206F6E6C792072616E67653A20222B4A534F4E2E737472696E6769667928652929';
wwv_flow_api.g_varchar2_table(115) := '2C746869732E6F70742E6E6F4D61746368286529292C7B73746172743A732C656E643A722C76616C69643A697D7D7D2C7B6B65793A22676574546578744E6F646573222C76616C75653A66756E6374696F6E2865297B76617220743D746869732C6E3D22';
wwv_flow_api.g_varchar2_table(116) := '222C723D5B5D3B746869732E6974657261746F722E666F72456163684E6F6465284E6F646546696C7465722E53484F575F544558542C66756E6374696F6E2865297B722E70757368287B73746172743A6E2E6C656E6774682C656E643A286E2B3D652E74';
wwv_flow_api.g_varchar2_table(117) := '657874436F6E74656E74292E6C656E6774682C6E6F64653A657D297D2C66756E6374696F6E2865297B72657475726E20742E6D6174636865734578636C75646528652E706172656E744E6F6465293F4E6F646546696C7465722E46494C5445525F52454A';
wwv_flow_api.g_varchar2_table(118) := '4543543A4E6F646546696C7465722E46494C5445525F4143434550547D2C66756E6374696F6E28297B65287B76616C75653A6E2C6E6F6465733A727D297D297D7D2C7B6B65793A226D6174636865734578636C756465222C76616C75653A66756E637469';
wwv_flow_api.g_varchar2_table(119) := '6F6E2865297B72657475726E20612E6D61746368657328652C746869732E6F70742E6578636C7564652E636F6E636174285B22736372697074222C227374796C65222C227469746C65222C2268656164222C2268746D6C225D29297D7D2C7B6B65793A22';
wwv_flow_api.g_varchar2_table(120) := '7772617052616E6765496E546578744E6F6465222C76616C75653A66756E6374696F6E28652C742C6E297B76617220723D746869732E6F70742E656C656D656E743F746869732E6F70742E656C656D656E743A226D61726B222C693D652E73706C697454';
wwv_flow_api.g_varchar2_table(121) := '6578742874292C6F3D692E73706C697454657874286E2D74292C613D646F63756D656E742E637265617465456C656D656E742872293B72657475726E20612E7365744174747269627574652822646174612D6D61726B6A73222C227472756522292C7468';
wwv_flow_api.g_varchar2_table(122) := '69732E6F70742E636C6173734E616D652626612E7365744174747269627574652822636C617373222C746869732E6F70742E636C6173734E616D65292C612E74657874436F6E74656E743D692E74657874436F6E74656E742C692E706172656E744E6F64';
wwv_flow_api.g_varchar2_table(123) := '652E7265706C6163654368696C6428612C69292C6F7D7D2C7B6B65793A227772617052616E6765496E4D6170706564546578744E6F6465222C76616C75653A66756E6374696F6E28732C632C752C6C2C68297B76617220663D746869733B732E6E6F6465';
wwv_flow_api.g_varchar2_table(124) := '732E65766572792866756E6374696F6E28652C6E297B76617220743D732E6E6F6465735B6E2B315D3B696628766F696420303D3D3D747C7C742E73746172743E63297B696628216C28652E6E6F6465292972657475726E21313B76617220723D632D652E';
wwv_flow_api.g_varchar2_table(125) := '73746172742C693D28753E652E656E643F652E656E643A75292D652E73746172742C6F3D732E76616C75652E73756273747228302C652E7374617274292C613D732E76616C75652E73756273747228692B652E7374617274293B696628652E6E6F64653D';
wwv_flow_api.g_varchar2_table(126) := '662E7772617052616E6765496E546578744E6F646528652E6E6F64652C722C69292C732E76616C75653D6F2B612C732E6E6F6465732E666F72456163682866756E6374696F6E28652C74297B6E3C3D74262628303C732E6E6F6465735B745D2E73746172';
wwv_flow_api.g_varchar2_table(127) := '74262674213D3D6E262628732E6E6F6465735B745D2E73746172742D3D69292C732E6E6F6465735B745D2E656E642D3D69297D292C752D3D692C6828652E6E6F64652E70726576696F75735369626C696E672C652E7374617274292C2128753E652E656E';
wwv_flow_api.g_varchar2_table(128) := '64292972657475726E21313B633D652E656E647D72657475726E21307D297D7D2C7B6B65793A22777261704D617463686573222C76616C75653A66756E6374696F6E28692C652C6F2C612C74297B76617220733D746869732C633D303D3D3D653F303A65';
wwv_flow_api.g_varchar2_table(129) := '2B313B746869732E676574546578744E6F6465732866756E6374696F6E2865297B652E6E6F6465732E666F72456163682866756E6374696F6E2865297B653D652E6E6F64653B666F722876617220743D766F696420303B6E756C6C213D3D28743D692E65';
wwv_flow_api.g_varchar2_table(130) := '78656328652E74657874436F6E74656E74292926262222213D3D745B635D3B296966286F28745B635D2C6529297B766172206E3D742E696E6465783B69662830213D3D6329666F722876617220723D313B723C633B722B2B296E2B3D745B725D2E6C656E';
wwv_flow_api.g_varchar2_table(131) := '6774683B653D732E7772617052616E6765496E546578744E6F646528652C6E2C6E2B745B635D2E6C656E677468292C6128652E70726576696F75735369626C696E67292C692E6C617374496E6465783D307D7D292C7428297D297D7D2C7B6B65793A2277';
wwv_flow_api.g_varchar2_table(132) := '7261704D6174636865734163726F7373456C656D656E7473222C76616C75653A66756E6374696F6E286F2C652C612C732C63297B76617220753D746869732C6C3D303D3D3D653F303A652B313B746869732E676574546578744E6F6465732866756E6374';
wwv_flow_api.g_varchar2_table(133) := '696F6E2865297B666F722876617220743D766F696420303B6E756C6C213D3D28743D6F2E6578656328652E76616C7565292926262222213D3D745B6C5D3B297B766172206E3D742E696E6465783B69662830213D3D6C29666F722876617220723D313B72';
wwv_flow_api.g_varchar2_table(134) := '3C6C3B722B2B296E2B3D745B725D2E6C656E6774683B76617220693D6E2B745B6C5D2E6C656E6774683B752E7772617052616E6765496E4D6170706564546578744E6F646528652C6E2C692C66756E6374696F6E2865297B72657475726E206128745B6C';
wwv_flow_api.g_varchar2_table(135) := '5D2C65297D2C66756E6374696F6E28652C74297B6F2E6C617374496E6465783D742C732865297D297D6328297D297D7D2C7B6B65793A227772617052616E676546726F6D496E646578222C76616C75653A66756E6374696F6E28652C732C632C74297B76';
wwv_flow_api.g_varchar2_table(136) := '617220753D746869733B746869732E676574546578744E6F6465732866756E6374696F6E286F297B76617220613D6F2E76616C75652E6C656E6774683B652E666F72456163682866756E6374696F6E28742C6E297B76617220653D752E636865636B5768';
wwv_flow_api.g_varchar2_table(137) := '697465737061636552616E67657328742C612C6F2E76616C7565292C723D652E73746172742C693D652E656E643B652E76616C69642626752E7772617052616E6765496E4D6170706564546578744E6F6465286F2C722C692C66756E6374696F6E286529';
wwv_flow_api.g_varchar2_table(138) := '7B72657475726E207328652C742C6F2E76616C75652E737562737472696E6728722C69292C6E297D2C66756E6374696F6E2865297B6328652C74297D297D292C7428297D297D7D2C7B6B65793A22756E777261704D617463686573222C76616C75653A66';
wwv_flow_api.g_varchar2_table(139) := '756E6374696F6E2865297B666F722876617220743D652E706172656E744E6F64652C6E3D646F63756D656E742E637265617465446F63756D656E74467261676D656E7428293B652E66697273744368696C643B296E2E617070656E644368696C6428652E';
wwv_flow_api.g_varchar2_table(140) := '72656D6F76654368696C6428652E66697273744368696C6429293B742E7265706C6163654368696C64286E2C65292C746869732E69653F746869732E6E6F726D616C697A65546578744E6F64652874293A742E6E6F726D616C697A6528297D7D2C7B6B65';
wwv_flow_api.g_varchar2_table(141) := '793A226E6F726D616C697A65546578744E6F6465222C76616C75653A66756E6374696F6E2865297B69662865297B696628333D3D3D652E6E6F64655479706529666F72283B652E6E6578745369626C696E672626333D3D3D652E6E6578745369626C696E';
wwv_flow_api.g_varchar2_table(142) := '672E6E6F6465547970653B29652E6E6F646556616C75652B3D652E6E6578745369626C696E672E6E6F646556616C75652C652E706172656E744E6F64652E72656D6F76654368696C6428652E6E6578745369626C696E67293B656C736520746869732E6E';
wwv_flow_api.g_varchar2_table(143) := '6F726D616C697A65546578744E6F646528652E66697273744368696C64293B746869732E6E6F726D616C697A65546578744E6F646528652E6E6578745369626C696E67297D7D7D2C7B6B65793A226D61726B526567457870222C76616C75653A66756E63';
wwv_flow_api.g_varchar2_table(144) := '74696F6E28652C74297B766172206E3D746869733B746869732E6F70743D742C746869732E6C6F672827536561726368696E6720776974682065787072657373696F6E2022272B652B272227293B76617220723D302C693D22777261704D617463686573';
wwv_flow_api.g_varchar2_table(145) := '223B746869732E6F70742E6163726F7373456C656D656E7473262628693D22777261704D6174636865734163726F7373456C656D656E747322292C746869735B695D28652C746869732E6F70742E69676E6F726547726F7570732C66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(146) := '652C74297B72657475726E206E2E6F70742E66696C74657228742C652C72297D2C66756E6374696F6E2865297B722B2B2C6E2E6F70742E656163682865297D2C66756E6374696F6E28297B303D3D3D7226266E2E6F70742E6E6F4D617463682865292C6E';
wwv_flow_api.g_varchar2_table(147) := '2E6F70742E646F6E652872297D297D7D2C7B6B65793A226D61726B222C76616C75653A66756E6374696F6E28652C74297B76617220693D746869733B746869732E6F70743D743B766172206F3D302C613D22777261704D617463686573222C6E3D746869';
wwv_flow_api.g_varchar2_table(148) := '732E6765745365706172617465644B6579776F7264732822737472696E67223D3D747970656F6620653F5B655D3A65292C733D6E2E6B6579776F7264732C633D6E2E6C656E6774682C753D746869732E6F70742E6361736553656E7369746976653F2222';
wwv_flow_api.g_varchar2_table(149) := '3A2269223B746869732E6F70742E6163726F7373456C656D656E7473262628613D22777261704D6174636865734163726F7373456C656D656E747322292C303D3D3D633F746869732E6F70742E646F6E65286F293A66756E6374696F6E2065286E297B76';
wwv_flow_api.g_varchar2_table(150) := '617220743D6E65772052656745787028692E637265617465526567457870286E292C22676D222B75292C723D303B692E6C6F672827536561726368696E6720776974682065787072657373696F6E2022272B742B272227292C695B615D28742C312C6675';
wwv_flow_api.g_varchar2_table(151) := '6E6374696F6E28652C74297B72657475726E20692E6F70742E66696C74657228742C6E2C6F2C72297D2C66756E6374696F6E2865297B722B2B2C6F2B2B2C692E6F70742E656163682865297D2C66756E6374696F6E28297B303D3D3D722626692E6F7074';
wwv_flow_api.g_varchar2_table(152) := '2E6E6F4D61746368286E292C735B632D315D3D3D3D6E3F692E6F70742E646F6E65286F293A6528735B732E696E6465784F66286E292B315D297D297D28735B305D297D7D2C7B6B65793A226D61726B52616E676573222C76616C75653A66756E6374696F';
wwv_flow_api.g_varchar2_table(153) := '6E28652C74297B76617220693D746869733B746869732E6F70743D743B766172206E3D302C723D746869732E636865636B52616E6765732865293B722626722E6C656E6774683F28746869732E6C6F6728225374617274696E6720746F206D61726B2077';
wwv_flow_api.g_varchar2_table(154) := '6974682074686520666F6C6C6F77696E672072616E6765733A20222B4A534F4E2E737472696E67696679287229292C746869732E7772617052616E676546726F6D496E64657828722C66756E6374696F6E28652C742C6E2C72297B72657475726E20692E';
wwv_flow_api.g_varchar2_table(155) := '6F70742E66696C74657228652C742C6E2C72297D2C66756E6374696F6E28652C74297B6E2B2B2C692E6F70742E6561636828652C74297D2C66756E6374696F6E28297B692E6F70742E646F6E65286E297D29293A746869732E6F70742E646F6E65286E29';
wwv_flow_api.g_varchar2_table(156) := '7D7D2C7B6B65793A22756E6D61726B222C76616C75653A66756E6374696F6E2865297B76617220723D746869733B746869732E6F70743D653B76617220693D746869732E6F70742E656C656D656E743F746869732E6F70742E656C656D656E743A222A22';
wwv_flow_api.g_varchar2_table(157) := '3B692B3D225B646174612D6D61726B6A735D222C746869732E6F70742E636C6173734E616D65262628692B3D222E222B746869732E6F70742E636C6173734E616D65292C746869732E6C6F67282752656D6F76616C2073656C6563746F722022272B692B';
wwv_flow_api.g_varchar2_table(158) := '272227292C746869732E6974657261746F722E666F72456163684E6F6465284E6F646546696C7465722E53484F575F454C454D454E542C66756E6374696F6E2865297B722E756E777261704D6174636865732865297D2C66756E6374696F6E2865297B76';
wwv_flow_api.g_varchar2_table(159) := '617220743D612E6D61746368657328652C69292C6E3D722E6D6174636865734578636C7564652865293B72657475726E21747C7C6E3F4E6F646546696C7465722E46494C5445525F52454A4543543A4E6F646546696C7465722E46494C5445525F414343';
wwv_flow_api.g_varchar2_table(160) := '4550547D2C746869732E6F70742E646F6E65297D7D2C7B6B65793A226F7074222C7365743A66756E6374696F6E2865297B746869732E5F6F70743D6F287B7D2C7B656C656D656E743A22222C636C6173734E616D653A22222C6578636C7564653A5B5D2C';
wwv_flow_api.g_varchar2_table(161) := '696672616D65733A21312C696672616D657354696D656F75743A3565332C7365706172617465576F72645365617263683A21302C646961637269746963733A21302C73796E6F6E796D733A7B7D2C61636375726163793A227061727469616C6C79222C61';
wwv_flow_api.g_varchar2_table(162) := '63726F7373456C656D656E74733A21312C6361736553656E7369746976653A21312C69676E6F72654A6F696E6572733A21312C69676E6F726547726F7570733A302C69676E6F726550756E6374756174696F6E3A5B5D2C77696C6463617264733A226469';
wwv_flow_api.g_varchar2_table(163) := '7361626C6564222C656163683A66756E6374696F6E28297B7D2C6E6F4D617463683A66756E6374696F6E28297B7D2C66696C7465723A66756E6374696F6E28297B72657475726E21307D2C646F6E653A66756E6374696F6E28297B7D2C64656275673A21';
wwv_flow_api.g_varchar2_table(164) := '312C6C6F673A77696E646F772E636F6E736F6C657D2C65297D2C6765743A66756E6374696F6E28297B72657475726E20746869732E5F6F70747D7D2C7B6B65793A226974657261746F72222C6765743A66756E6374696F6E28297B72657475726E206E65';
wwv_flow_api.g_varchar2_table(165) := '77206128746869732E6374782C746869732E6F70742E696672616D65732C746869732E6F70742E6578636C7564652C746869732E6F70742E696672616D657354696D656F7574297D7D5D292C6E7D28293B72657475726E20652E666E2E6D61726B3D6675';
wwv_flow_api.g_varchar2_table(166) := '6E6374696F6E28652C74297B72657475726E206E6577206E28746869732E6765742829292E6D61726B28652C74292C746869737D2C652E666E2E6D61726B5265674578703D66756E6374696F6E28652C74297B72657475726E206E6577206E2874686973';
wwv_flow_api.g_varchar2_table(167) := '2E6765742829292E6D61726B52656745787028652C74292C746869737D2C652E666E2E6D61726B52616E6765733D66756E6374696F6E28652C74297B72657475726E206E6577206E28746869732E6765742829292E6D61726B52616E67657328652C7429';
wwv_flow_api.g_varchar2_table(168) := '2C746869737D2C652E666E2E756E6D61726B3D66756E6374696F6E2865297B72657475726E206E6577206E28746869732E6765742829292E756E6D61726B2865292C746869737D2C657D293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(4568648674876334)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_file_name=>'js/jquery.mark.min.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A210A2A2054697070792E6A732076332E342E310A2A2028632920323031372D323031392061746F6D696B730A2A204D49540A2A2F0A2866756E6374696F6E2028676C6F62616C2C20666163746F727929207B0A09747970656F66206578706F727473';
wwv_flow_api.g_varchar2_table(2) := '203D3D3D20276F626A6563742720262620747970656F66206D6F64756C6520213D3D2027756E646566696E656427203F206D6F64756C652E6578706F727473203D20666163746F72792829203A0A09747970656F6620646566696E65203D3D3D20276675';
wwv_flow_api.g_varchar2_table(3) := '6E6374696F6E2720262620646566696E652E616D64203F20646566696E6528666163746F727929203A0A0928676C6F62616C2E7469707079203D20666163746F72792829293B0A7D28746869732C202866756E6374696F6E202829207B20277573652073';
wwv_flow_api.g_varchar2_table(4) := '7472696374273B0A0A766172207374796C6573203D20222E74697070792D694F537B637572736F723A706F696E74657221696D706F7274616E747D2E74697070792D6E6F7472616E736974696F6E7B7472616E736974696F6E3A6E6F6E6521696D706F72';
wwv_flow_api.g_varchar2_table(5) := '74616E747D2E74697070792D706F707065727B2D7765626B69742D70657273706563746976653A37303070783B70657273706563746976653A37303070783B7A2D696E6465783A393939393B6F75746C696E653A303B7472616E736974696F6E2D74696D';
wwv_flow_api.g_varchar2_table(6) := '696E672D66756E6374696F6E3A63756269632D62657A696572282E3136352C2E38342C2E34342C31293B706F696E7465722D6576656E74733A6E6F6E653B6C696E652D6865696768743A312E343B6D61782D77696474683A63616C632831303025202D20';
wwv_flow_api.g_varchar2_table(7) := '31307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D202E74697070792D6261636B64726F707B626F726465722D7261646975733A34302520343025203020307D2E74697070792D706F707065725B782D706C6163';
wwv_flow_api.g_varchar2_table(8) := '656D656E745E3D746F705D202E74697070792D726F756E646172726F777B626F74746F6D3A2D3870783B2D7765626B69742D7472616E73666F726D2D6F726967696E3A35302520303B7472616E73666F726D2D6F726967696E3A35302520307D2E746970';
wwv_flow_api.g_varchar2_table(9) := '70792D706F707065725B782D706C6163656D656E745E3D746F705D202E74697070792D726F756E646172726F77207376677B706F736974696F6E3A6162736F6C7574653B6C6566743A303B2D7765626B69742D7472616E73666F726D3A726F7461746528';
wwv_flow_api.g_varchar2_table(10) := '313830646567293B7472616E73666F726D3A726F7461746528313830646567297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D202E74697070792D6172726F777B626F726465722D746F703A38707820736F6C69642023';
wwv_flow_api.g_varchar2_table(11) := '3333333B626F726465722D72696768743A38707820736F6C6964207472616E73706172656E743B626F726465722D6C6566743A38707820736F6C6964207472616E73706172656E743B626F74746F6D3A2D3770783B6D617267696E3A30203670783B2D77';
wwv_flow_api.g_varchar2_table(12) := '65626B69742D7472616E73666F726D2D6F726967696E3A35302520303B7472616E73666F726D2D6F726967696E3A35302520307D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D202E74697070792D6261636B64726F707B';
wwv_flow_api.g_varchar2_table(13) := '2D7765626B69742D7472616E73666F726D2D6F726967696E3A30203235253B7472616E73666F726D2D6F726967696E3A30203235257D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D202E74697070792D6261636B64726F';
wwv_flow_api.g_varchar2_table(14) := '705B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7363616C65283129207472616E736C617465282D3530252C2D353525293B7472616E73666F726D3A7363616C65283129207472616E736C617465282D';
wwv_flow_api.g_varchar2_table(15) := '3530252C2D353525297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D202E74697070792D6261636B64726F705B646174612D73746174653D68696464656E5D7B2D7765626B69742D7472616E73666F726D3A7363616C65';
wwv_flow_api.g_varchar2_table(16) := '282E3229207472616E736C617465282D3530252C2D343525293B7472616E73666F726D3A7363616C65282E3229207472616E736C617465282D3530252C2D343525293B6F7061636974793A307D2E74697070792D706F707065725B782D706C6163656D65';
wwv_flow_api.g_varchar2_table(17) := '6E745E3D746F705D205B646174612D616E696D6174696F6E3D73686966742D746F776172645D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559282D31307078293B7472616E73';
wwv_flow_api.g_varchar2_table(18) := '666F726D3A7472616E736C61746559282D31307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D205B646174612D616E696D6174696F6E3D73686966742D746F776172645D5B646174612D73746174653D68696464';
wwv_flow_api.g_varchar2_table(19) := '656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559282D32307078293B7472616E73666F726D3A7472616E736C61746559282D32307078297D2E74697070792D706F707065725B782D706C6163656D';
wwv_flow_api.g_varchar2_table(20) := '656E745E3D746F705D205B646174612D616E696D6174696F6E3D70657273706563746976655D7B2D7765626B69742D7472616E73666F726D2D6F726967696E3A626F74746F6D3B7472616E73666F726D2D6F726967696E3A626F74746F6D7D2E74697070';
wwv_flow_api.g_varchar2_table(21) := '792D706F707065725B782D706C6163656D656E745E3D746F705D205B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C';
wwv_flow_api.g_varchar2_table(22) := '61746559282D313070782920726F74617465582830293B7472616E73666F726D3A7472616E736C61746559282D313070782920726F74617465582830297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D205B646174612D';
wwv_flow_api.g_varchar2_table(23) := '616E696D6174696F6E3D70657273706563746976655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C6174655928302920726F7461746558283630646567293B74';
wwv_flow_api.g_varchar2_table(24) := '72616E73666F726D3A7472616E736C6174655928302920726F7461746558283630646567297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D205B646174612D616E696D6174696F6E3D666164655D5B646174612D737461';
wwv_flow_api.g_varchar2_table(25) := '74653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559282D31307078293B7472616E73666F726D3A7472616E736C61746559282D31307078297D2E74697070792D706F707065725B782D706C6163656D656E';
wwv_flow_api.g_varchar2_table(26) := '745E3D746F705D205B646174612D616E696D6174696F6E3D666164655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559282D31307078293B7472616E73';
wwv_flow_api.g_varchar2_table(27) := '666F726D3A7472616E736C61746559282D31307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D205B646174612D616E696D6174696F6E3D73686966742D617761795D5B646174612D73746174653D76697369626C';
wwv_flow_api.g_varchar2_table(28) := '655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559282D31307078293B7472616E73666F726D3A7472616E736C61746559282D31307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D205B';
wwv_flow_api.g_varchar2_table(29) := '646174612D616E696D6174696F6E3D73686966742D617761795D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592830293B7472616E73666F726D3A7472';
wwv_flow_api.g_varchar2_table(30) := '616E736C617465592830297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D205B646174612D616E696D6174696F6E3D7363616C655D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73';
wwv_flow_api.g_varchar2_table(31) := '666F726D3A7472616E736C61746559282D3130707829207363616C652831293B7472616E73666F726D3A7472616E736C61746559282D3130707829207363616C652831297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D';
wwv_flow_api.g_varchar2_table(32) := '205B646174612D616E696D6174696F6E3D7363616C655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559283029207363616C65282E35293B7472616E73';
wwv_flow_api.g_varchar2_table(33) := '666F726D3A7472616E736C61746559283029207363616C65282E35297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D202E74697070792D6261636B64726F707B626F726465722D7261646975733A302030203330';
wwv_flow_api.g_varchar2_table(34) := '25203330257D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D202E74697070792D726F756E646172726F777B746F703A2D3870783B2D7765626B69742D7472616E73666F726D2D6F726967696E3A35302520313030';
wwv_flow_api.g_varchar2_table(35) := '253B7472616E73666F726D2D6F726967696E3A35302520313030257D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D202E74697070792D726F756E646172726F77207376677B706F736974696F6E3A6162736F6C75';
wwv_flow_api.g_varchar2_table(36) := '74653B6C6566743A303B2D7765626B69742D7472616E73666F726D3A726F746174652830293B7472616E73666F726D3A726F746174652830297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D202E74697070792D';
wwv_flow_api.g_varchar2_table(37) := '6172726F777B626F726465722D626F74746F6D3A38707820736F6C696420233333333B626F726465722D72696768743A38707820736F6C6964207472616E73706172656E743B626F726465722D6C6566743A38707820736F6C6964207472616E73706172';
wwv_flow_api.g_varchar2_table(38) := '656E743B746F703A2D3770783B6D617267696E3A30203670783B2D7765626B69742D7472616E73666F726D2D6F726967696E3A35302520313030253B7472616E73666F726D2D6F726967696E3A35302520313030257D2E74697070792D706F707065725B';
wwv_flow_api.g_varchar2_table(39) := '782D706C6163656D656E745E3D626F74746F6D5D202E74697070792D6261636B64726F707B2D7765626B69742D7472616E73666F726D2D6F726967696E3A30202D3530253B7472616E73666F726D2D6F726967696E3A30202D3530257D2E74697070792D';
wwv_flow_api.g_varchar2_table(40) := '706F707065725B782D706C6163656D656E745E3D626F74746F6D5D202E74697070792D6261636B64726F705B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7363616C65283129207472616E736C617465';
wwv_flow_api.g_varchar2_table(41) := '282D3530252C2D343525293B7472616E73666F726D3A7363616C65283129207472616E736C617465282D3530252C2D343525297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D202E74697070792D6261636B6472';
wwv_flow_api.g_varchar2_table(42) := '6F705B646174612D73746174653D68696464656E5D7B2D7765626B69742D7472616E73666F726D3A7363616C65282E3229207472616E736C617465282D353025293B7472616E73666F726D3A7363616C65282E3229207472616E736C617465282D353025';
wwv_flow_api.g_varchar2_table(43) := '293B6F7061636974793A307D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B646174612D616E696D6174696F6E3D73686966742D746F776172645D5B646174612D73746174653D76697369626C655D7B2D7765';
wwv_flow_api.g_varchar2_table(44) := '626B69742D7472616E73666F726D3A7472616E736C617465592831307078293B7472616E73666F726D3A7472616E736C617465592831307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B646174612D';
wwv_flow_api.g_varchar2_table(45) := '616E696D6174696F6E3D73686966742D746F776172645D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592832307078293B7472616E73666F726D3A7472';
wwv_flow_api.g_varchar2_table(46) := '616E736C617465592832307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B646174612D616E696D6174696F6E3D70657273706563746976655D7B2D7765626B69742D7472616E73666F726D2D6F7269';
wwv_flow_api.g_varchar2_table(47) := '67696E3A746F703B7472616E73666F726D2D6F726967696E3A746F707D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D7374';
wwv_flow_api.g_varchar2_table(48) := '6174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C6174655928313070782920726F74617465582830293B7472616E73666F726D3A7472616E736C6174655928313070782920726F74617465582830297D2E7469';
wwv_flow_api.g_varchar2_table(49) := '7070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472';
wwv_flow_api.g_varchar2_table(50) := '616E73666F726D3A7472616E736C6174655928302920726F7461746558282D3630646567293B7472616E73666F726D3A7472616E736C6174655928302920726F7461746558282D3630646567297D2E74697070792D706F707065725B782D706C6163656D';
wwv_flow_api.g_varchar2_table(51) := '656E745E3D626F74746F6D5D205B646174612D616E696D6174696F6E3D666164655D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592831307078293B7472616E73666F726D3A';
wwv_flow_api.g_varchar2_table(52) := '7472616E736C617465592831307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B646174612D616E696D6174696F6E3D666164655D5B646174612D73746174653D68696464656E5D7B6F706163697479';
wwv_flow_api.g_varchar2_table(53) := '3A303B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592831307078293B7472616E73666F726D3A7472616E736C617465592831307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D20';
wwv_flow_api.g_varchar2_table(54) := '5B646174612D616E696D6174696F6E3D73686966742D617761795D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592831307078293B7472616E73666F726D3A7472616E736C61';
wwv_flow_api.g_varchar2_table(55) := '7465592831307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B646174612D616E696D6174696F6E3D73686966742D617761795D5B646174612D73746174653D68696464656E5D7B6F7061636974793A';
wwv_flow_api.g_varchar2_table(56) := '303B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592830293B7472616E73666F726D3A7472616E736C617465592830297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B646174612D61';
wwv_flow_api.g_varchar2_table(57) := '6E696D6174696F6E3D7363616C655D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559283130707829207363616C652831293B7472616E73666F726D3A7472616E736C61746559';
wwv_flow_api.g_varchar2_table(58) := '283130707829207363616C652831297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B646174612D616E696D6174696F6E3D7363616C655D5B646174612D73746174653D68696464656E5D7B6F706163697479';
wwv_flow_api.g_varchar2_table(59) := '3A303B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559283029207363616C65282E35293B7472616E73666F726D3A7472616E736C61746559283029207363616C65282E35297D2E74697070792D706F707065725B782D706C616365';
wwv_flow_api.g_varchar2_table(60) := '6D656E745E3D6C6566745D202E74697070792D6261636B64726F707B626F726465722D7261646975733A35302520302030203530257D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D202E74697070792D726F756E6461';
wwv_flow_api.g_varchar2_table(61) := '72726F777B72696768743A2D313670783B2D7765626B69742D7472616E73666F726D2D6F726967696E3A33332E333333333333333325203530253B7472616E73666F726D2D6F726967696E3A33332E333333333333333325203530257D2E74697070792D';
wwv_flow_api.g_varchar2_table(62) := '706F707065725B782D706C6163656D656E745E3D6C6566745D202E74697070792D726F756E646172726F77207376677B706F736974696F6E3A6162736F6C7574653B6C6566743A303B2D7765626B69742D7472616E73666F726D3A726F74617465283930';
wwv_flow_api.g_varchar2_table(63) := '646567293B7472616E73666F726D3A726F74617465283930646567297D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D202E74697070792D6172726F777B626F726465722D6C6566743A38707820736F6C696420233333';
wwv_flow_api.g_varchar2_table(64) := '333B626F726465722D746F703A38707820736F6C6964207472616E73706172656E743B626F726465722D626F74746F6D3A38707820736F6C6964207472616E73706172656E743B72696768743A2D3770783B6D617267696E3A33707820303B2D7765626B';
wwv_flow_api.g_varchar2_table(65) := '69742D7472616E73666F726D2D6F726967696E3A30203530253B7472616E73666F726D2D6F726967696E3A30203530257D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D202E74697070792D6261636B64726F707B2D77';
wwv_flow_api.g_varchar2_table(66) := '65626B69742D7472616E73666F726D2D6F726967696E3A35302520303B7472616E73666F726D2D6F726967696E3A35302520307D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D202E74697070792D6261636B64726F70';
wwv_flow_api.g_varchar2_table(67) := '5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7363616C65283129207472616E736C617465282D3530252C2D353025293B7472616E73666F726D3A7363616C65283129207472616E736C617465282D35';
wwv_flow_api.g_varchar2_table(68) := '30252C2D353025297D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D202E74697070792D6261636B64726F705B646174612D73746174653D68696464656E5D7B2D7765626B69742D7472616E73666F726D3A7363616C65';
wwv_flow_api.g_varchar2_table(69) := '282E3229207472616E736C617465282D3735252C2D353025293B7472616E73666F726D3A7363616C65282E3229207472616E736C617465282D3735252C2D353025293B6F7061636974793A307D2E74697070792D706F707065725B782D706C6163656D65';
wwv_flow_api.g_varchar2_table(70) := '6E745E3D6C6566745D205B646174612D616E696D6174696F6E3D73686966742D746F776172645D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558282D31307078293B7472616E';
wwv_flow_api.g_varchar2_table(71) := '73666F726D3A7472616E736C61746558282D31307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D205B646174612D616E696D6174696F6E3D73686966742D746F776172645D5B646174612D73746174653D6869';
wwv_flow_api.g_varchar2_table(72) := '6464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558282D32307078293B7472616E73666F726D3A7472616E736C61746558282D32307078297D2E74697070792D706F707065725B782D706C6163';
wwv_flow_api.g_varchar2_table(73) := '656D656E745E3D6C6566745D205B646174612D616E696D6174696F6E3D70657273706563746976655D7B2D7765626B69742D7472616E73666F726D2D6F726967696E3A72696768743B7472616E73666F726D2D6F726967696E3A72696768747D2E746970';
wwv_flow_api.g_varchar2_table(74) := '70792D706F707065725B782D706C6163656D656E745E3D6C6566745D205B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E';
wwv_flow_api.g_varchar2_table(75) := '736C61746558282D313070782920726F74617465592830293B7472616E73666F726D3A7472616E736C61746558282D313070782920726F74617465592830297D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D205B6461';
wwv_flow_api.g_varchar2_table(76) := '74612D616E696D6174696F6E3D70657273706563746976655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C6174655828302920726F7461746559282D36306465';
wwv_flow_api.g_varchar2_table(77) := '67293B7472616E73666F726D3A7472616E736C6174655828302920726F7461746559282D3630646567297D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D205B646174612D616E696D6174696F6E3D666164655D5B6461';
wwv_flow_api.g_varchar2_table(78) := '74612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558282D31307078293B7472616E73666F726D3A7472616E736C61746558282D31307078297D2E74697070792D706F707065725B782D706C';
wwv_flow_api.g_varchar2_table(79) := '6163656D656E745E3D6C6566745D205B646174612D616E696D6174696F6E3D666164655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558282D31307078';
wwv_flow_api.g_varchar2_table(80) := '293B7472616E73666F726D3A7472616E736C61746558282D31307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D205B646174612D616E696D6174696F6E3D73686966742D617761795D5B646174612D73746174';
wwv_flow_api.g_varchar2_table(81) := '653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558282D31307078293B7472616E73666F726D3A7472616E736C61746558282D31307078297D2E74697070792D706F707065725B782D706C6163656D656E74';
wwv_flow_api.g_varchar2_table(82) := '5E3D6C6566745D205B646174612D616E696D6174696F6E3D73686966742D617761795D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C617465582830293B747261';
wwv_flow_api.g_varchar2_table(83) := '6E73666F726D3A7472616E736C617465582830297D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D205B646174612D616E696D6174696F6E3D7363616C655D5B646174612D73746174653D76697369626C655D7B2D7765';
wwv_flow_api.g_varchar2_table(84) := '626B69742D7472616E73666F726D3A7472616E736C61746558282D3130707829207363616C652831293B7472616E73666F726D3A7472616E736C61746558282D3130707829207363616C652831297D2E74697070792D706F707065725B782D706C616365';
wwv_flow_api.g_varchar2_table(85) := '6D656E745E3D6C6566745D205B646174612D616E696D6174696F6E3D7363616C655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558283029207363616C';
wwv_flow_api.g_varchar2_table(86) := '65282E35293B7472616E73666F726D3A7472616E736C61746558283029207363616C65282E35297D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D202E74697070792D6261636B64726F707B626F726465722D726164';
wwv_flow_api.g_varchar2_table(87) := '6975733A30203530252035302520307D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D202E74697070792D726F756E646172726F777B6C6566743A2D313670783B2D7765626B69742D7472616E73666F726D2D6F7269';
wwv_flow_api.g_varchar2_table(88) := '67696E3A36362E363636363636363625203530253B7472616E73666F726D2D6F726967696E3A36362E363636363636363625203530257D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D202E74697070792D726F756E';
wwv_flow_api.g_varchar2_table(89) := '646172726F77207376677B706F736974696F6E3A6162736F6C7574653B6C6566743A303B2D7765626B69742D7472616E73666F726D3A726F74617465282D3930646567293B7472616E73666F726D3A726F74617465282D3930646567297D2E7469707079';
wwv_flow_api.g_varchar2_table(90) := '2D706F707065725B782D706C6163656D656E745E3D72696768745D202E74697070792D6172726F777B626F726465722D72696768743A38707820736F6C696420233333333B626F726465722D746F703A38707820736F6C6964207472616E73706172656E';
wwv_flow_api.g_varchar2_table(91) := '743B626F726465722D626F74746F6D3A38707820736F6C6964207472616E73706172656E743B6C6566743A2D3770783B6D617267696E3A33707820303B2D7765626B69742D7472616E73666F726D2D6F726967696E3A31303025203530253B7472616E73';
wwv_flow_api.g_varchar2_table(92) := '666F726D2D6F726967696E3A31303025203530257D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D202E74697070792D6261636B64726F707B2D7765626B69742D7472616E73666F726D2D6F726967696E3A2D353025';
wwv_flow_api.g_varchar2_table(93) := '20303B7472616E73666F726D2D6F726967696E3A2D35302520307D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D202E74697070792D6261636B64726F705B646174612D73746174653D76697369626C655D7B2D7765';
wwv_flow_api.g_varchar2_table(94) := '626B69742D7472616E73666F726D3A7363616C65283129207472616E736C617465282D3530252C2D353025293B7472616E73666F726D3A7363616C65283129207472616E736C617465282D3530252C2D353025297D2E74697070792D706F707065725B78';
wwv_flow_api.g_varchar2_table(95) := '2D706C6163656D656E745E3D72696768745D202E74697070792D6261636B64726F705B646174612D73746174653D68696464656E5D7B2D7765626B69742D7472616E73666F726D3A7363616C65282E3229207472616E736C617465282D3235252C2D3530';
wwv_flow_api.g_varchar2_table(96) := '25293B7472616E73666F726D3A7363616C65282E3229207472616E736C617465282D3235252C2D353025293B6F7061636974793A307D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D6174';
wwv_flow_api.g_varchar2_table(97) := '696F6E3D73686966742D746F776172645D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C617465582831307078293B7472616E73666F726D3A7472616E736C617465582831307078297D';
wwv_flow_api.g_varchar2_table(98) := '2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D6174696F6E3D73686966742D746F776172645D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B6974';
wwv_flow_api.g_varchar2_table(99) := '2D7472616E73666F726D3A7472616E736C617465582832307078293B7472616E73666F726D3A7472616E736C617465582832307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D61';
wwv_flow_api.g_varchar2_table(100) := '74696F6E3D70657273706563746976655D7B2D7765626B69742D7472616E73666F726D2D6F726967696E3A6C6566743B7472616E73666F726D2D6F726967696E3A6C6566747D2E74697070792D706F707065725B782D706C6163656D656E745E3D726967';
wwv_flow_api.g_varchar2_table(101) := '68745D205B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C6174655828313070782920726F74617465592830293B74';
wwv_flow_api.g_varchar2_table(102) := '72616E73666F726D3A7472616E736C6174655828313070782920726F74617465592830297D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D6174696F6E3D70657273706563746976655D5B';
wwv_flow_api.g_varchar2_table(103) := '646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C6174655828302920726F7461746559283630646567293B7472616E73666F726D3A7472616E736C6174655828302920';
wwv_flow_api.g_varchar2_table(104) := '726F7461746559283630646567297D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D6174696F6E3D666164655D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D74';
wwv_flow_api.g_varchar2_table(105) := '72616E73666F726D3A7472616E736C617465582831307078293B7472616E73666F726D3A7472616E736C617465582831307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D617469';
wwv_flow_api.g_varchar2_table(106) := '6F6E3D666164655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C617465582831307078293B7472616E73666F726D3A7472616E736C617465582831307078297D';
wwv_flow_api.g_varchar2_table(107) := '2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D6174696F6E3D73686966742D617761795D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A';
wwv_flow_api.g_varchar2_table(108) := '7472616E736C617465582831307078293B7472616E73666F726D3A7472616E736C617465582831307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D6174696F6E3D73686966742D';
wwv_flow_api.g_varchar2_table(109) := '617761795D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C617465582830293B7472616E73666F726D3A7472616E736C617465582830297D2E74697070792D706F';
wwv_flow_api.g_varchar2_table(110) := '707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D6174696F6E3D7363616C655D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C6174655828313070';
wwv_flow_api.g_varchar2_table(111) := '7829207363616C652831293B7472616E73666F726D3A7472616E736C61746558283130707829207363616C652831297D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D6174696F6E3D7363';
wwv_flow_api.g_varchar2_table(112) := '616C655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558283029207363616C65282E35293B7472616E73666F726D3A7472616E736C6174655828302920';
wwv_flow_api.g_varchar2_table(113) := '7363616C65282E35297D2E74697070792D746F6F6C7469707B706F736974696F6E3A72656C61746976653B636F6C6F723A236666663B626F726465722D7261646975733A3470783B666F6E742D73697A653A2E3972656D3B70616464696E673A2E337265';
wwv_flow_api.g_varchar2_table(114) := '6D202E3672656D3B6D61782D77696474683A33353070783B746578742D616C69676E3A63656E7465723B77696C6C2D6368616E67653A7472616E73666F726D3B2D7765626B69742D666F6E742D736D6F6F7468696E673A616E7469616C69617365643B2D';
wwv_flow_api.g_varchar2_table(115) := '6D6F7A2D6F73782D666F6E742D736D6F6F7468696E673A677261797363616C653B6261636B67726F756E642D636F6C6F723A233333337D2E74697070792D746F6F6C7469705B646174612D73697A653D736D616C6C5D7B70616464696E673A2E3272656D';
wwv_flow_api.g_varchar2_table(116) := '202E3472656D3B666F6E742D73697A653A2E373572656D7D2E74697070792D746F6F6C7469705B646174612D73697A653D6C617267655D7B70616464696E673A2E3472656D202E3872656D3B666F6E742D73697A653A3172656D7D2E74697070792D746F';
wwv_flow_api.g_varchar2_table(117) := '6F6C7469705B646174612D616E696D61746566696C6C5D7B6F766572666C6F773A68696464656E3B6261636B67726F756E642D636F6C6F723A7472616E73706172656E747D2E74697070792D746F6F6C7469705B646174612D696E746572616374697665';
wwv_flow_api.g_varchar2_table(118) := '5D2C2E74697070792D746F6F6C7469705B646174612D696E7465726163746976655D20706174687B706F696E7465722D6576656E74733A6175746F7D2E74697070792D746F6F6C7469705B646174612D696E65727469615D5B646174612D73746174653D';
wwv_flow_api.g_varchar2_table(119) := '76697369626C655D7B7472616E736974696F6E2D74696D696E672D66756E6374696F6E3A63756269632D62657A696572282E35342C312E352C2E33382C312E3131297D2E74697070792D746F6F6C7469705B646174612D696E65727469615D5B64617461';
wwv_flow_api.g_varchar2_table(120) := '2D73746174653D68696464656E5D7B7472616E736974696F6E2D74696D696E672D66756E6374696F6E3A656173657D2E74697070792D6172726F772C2E74697070792D726F756E646172726F777B706F736974696F6E3A6162736F6C7574653B77696474';
wwv_flow_api.g_varchar2_table(121) := '683A303B6865696768743A307D2E74697070792D726F756E646172726F777B77696474683A323470783B6865696768743A3870783B66696C6C3A233333333B706F696E7465722D6576656E74733A6E6F6E657D2E74697070792D6261636B64726F707B70';
wwv_flow_api.g_varchar2_table(122) := '6F736974696F6E3A6162736F6C7574653B77696C6C2D6368616E67653A7472616E73666F726D3B6261636B67726F756E642D636F6C6F723A233333333B626F726465722D7261646975733A3530253B77696474683A63616C632831313025202B20327265';
wwv_flow_api.g_varchar2_table(123) := '6D293B6C6566743A3530253B746F703A3530253B7A2D696E6465783A2D313B7472616E736974696F6E3A616C6C2063756269632D62657A696572282E34362C2E312C2E35322C2E3938293B2D7765626B69742D6261636B666163652D7669736962696C69';
wwv_flow_api.g_varchar2_table(124) := '74793A68696464656E3B6261636B666163652D7669736962696C6974793A68696464656E7D2E74697070792D6261636B64726F703A61667465727B636F6E74656E743A5C225C223B666C6F61743A6C6566743B70616464696E672D746F703A313030257D';
wwv_flow_api.g_varchar2_table(125) := '2E74697070792D6261636B64726F702B2E74697070792D636F6E74656E747B7472616E736974696F6E2D70726F70657274793A6F7061636974793B77696C6C2D6368616E67653A6F7061636974797D2E74697070792D6261636B64726F702B2E74697070';
wwv_flow_api.g_varchar2_table(126) := '792D636F6E74656E745B646174612D73746174653D76697369626C655D7B6F7061636974793A317D2E74697070792D6261636B64726F702B2E74697070792D636F6E74656E745B646174612D73746174653D68696464656E5D7B6F7061636974793A307D';
wwv_flow_api.g_varchar2_table(127) := '223B0A0A7661722076657273696F6E203D2022332E342E31223B0A0A76617220697342726F77736572203D20747970656F662077696E646F7720213D3D2027756E646566696E6564273B0A0A766172206E6176203D20697342726F77736572203F206E61';
wwv_flow_api.g_varchar2_table(128) := '76696761746F72203A207B7D3B0A7661722077696E203D20697342726F77736572203F2077696E646F77203A207B7D3B0A0A76617220697342726F77736572537570706F72746564203D20274D75746174696F6E4F627365727665722720696E2077696E';
wwv_flow_api.g_varchar2_table(129) := '3B0A7661722069734945203D202F4D534945207C54726964656E745C2F2F2E74657374286E61762E757365724167656E74293B0A766172206973494F53203D202F6950686F6E657C695061647C69506F642F2E74657374286E61762E706C6174666F726D';
wwv_flow_api.g_varchar2_table(130) := '29202626202177696E2E4D5353747265616D3B0A76617220737570706F727473546F756368203D20276F6E746F75636873746172742720696E2077696E3B0A0A7661722044656661756C7473203D207B0A2020613131793A20747275652C0A2020616C6C';
wwv_flow_api.g_varchar2_table(131) := '6F7748544D4C3A20747275652C0A2020616E696D61746546696C6C3A20747275652C0A2020616E696D6174696F6E3A202773686966742D61776179272C0A2020617070656E64546F3A2066756E6374696F6E20617070656E64546F2829207B0A20202020';
wwv_flow_api.g_varchar2_table(132) := '72657475726E20646F63756D656E742E626F64793B0A20207D2C0A2020617269613A20276465736372696265646279272C0A20206172726F773A2066616C73652C0A20206172726F775472616E73666F726D3A2027272C0A20206172726F77547970653A';
wwv_flow_api.g_varchar2_table(133) := '20277368617270272C0A20206175746F466F6375733A20747275652C0A2020626F756E646172793A20277363726F6C6C506172656E74272C0A2020636F6E74656E743A2027272C0A202064656C61793A205B302C2032305D2C0A202064697374616E6365';
wwv_flow_api.g_varchar2_table(134) := '3A2031302C0A20206475726174696F6E3A205B3332352C203237355D2C0A2020666C69703A20747275652C0A2020666C69704265686176696F723A2027666C6970272C0A2020666F6C6C6F77437572736F723A2066616C73652C0A2020686964654F6E43';
wwv_flow_api.g_varchar2_table(135) := '6C69636B3A20747275652C0A2020696E65727469613A2066616C73652C0A2020696E7465726163746976653A2066616C73652C0A2020696E746572616374697665426F726465723A20322C0A2020696E7465726163746976654465626F756E63653A2030';
wwv_flow_api.g_varchar2_table(136) := '2C0A20206C617A793A20747275652C0A20206C697665506C6163656D656E743A20747275652C0A20206D617857696474683A2027272C0A20206D756C7469706C653A2066616C73652C0A20206F66667365743A20302C0A20206F6E48696464656E3A2066';
wwv_flow_api.g_varchar2_table(137) := '756E6374696F6E206F6E48696464656E2829207B7D2C0A20206F6E486964653A2066756E6374696F6E206F6E486964652829207B7D2C0A20206F6E4D6F756E743A2066756E6374696F6E206F6E4D6F756E742829207B7D2C0A20206F6E53686F773A2066';
wwv_flow_api.g_varchar2_table(138) := '756E6374696F6E206F6E53686F772829207B7D2C0A20206F6E53686F776E3A2066756E6374696F6E206F6E53686F776E2829207B7D2C0A0A2020706572666F726D616E63653A2066616C73652C0A2020706C6163656D656E743A2027746F70272C0A2020';
wwv_flow_api.g_varchar2_table(139) := '706F707065724F7074696F6E733A207B7D2C0A202073686F756C64506F70706572486964654F6E426C75723A2066756E6374696F6E2073686F756C64506F70706572486964654F6E426C75722829207B0A2020202072657475726E20747275653B0A2020';
wwv_flow_api.g_varchar2_table(140) := '7D2C0A202073686F774F6E496E69743A2066616C73652C0A202073697A653A2027726567756C6172272C0A2020737469636B793A2066616C73652C0A20207461726765743A2027272C0A20207468656D653A20276461726B272C0A2020746F7563683A20';
wwv_flow_api.g_varchar2_table(141) := '747275652C0A2020746F756368486F6C643A2066616C73652C0A2020747269676765723A20276D6F757365656E74657220666F637573272C0A20207570646174654475726174696F6E3A203230302C0A2020776169743A206E756C6C2C0A20207A496E64';
wwv_flow_api.g_varchar2_table(142) := '65783A20393939390A0A20202F2A2A0A2020202A20496620746865207365742829206D6574686F6420656E636F756E74657273206F6E65206F662074686573652C2074686520706F70706572496E7374616E6365206D7573742062650A2020202A207265';
wwv_flow_api.g_varchar2_table(143) := '637265617465640A2020202A2F0A7D3B76617220504F505045525F494E5354414E43455F52454C415445445F50524F5053203D205B276172726F77272C20276172726F7754797065272C202764697374616E6365272C2027666C6970272C2027666C6970';
wwv_flow_api.g_varchar2_table(144) := '4265686176696F72272C20276F6666736574272C2027706C6163656D656E74272C2027706F707065724F7074696F6E73275D3B0A0A2F2A2A210A202A204066696C654F76657276696577204B69636B617373206C69627261727920746F20637265617465';
wwv_flow_api.g_varchar2_table(145) := '20616E6420706C61636520706F7070657273206E656172207468656972207265666572656E636520656C656D656E74732E0A202A204076657273696F6E20312E31342E360A202A20406C6963656E73650A202A20436F7079726967687420286329203230';
wwv_flow_api.g_varchar2_table(146) := '313620466564657269636F205A69766F6C6F20616E6420636F6E7472696275746F72730A202A0A202A205065726D697373696F6E20697320686572656279206772616E7465642C2066726565206F66206368617267652C20746F20616E7920706572736F';
wwv_flow_api.g_varchar2_table(147) := '6E206F627461696E696E67206120636F70790A202A206F66207468697320736F66747761726520616E64206173736F63696174656420646F63756D656E746174696F6E2066696C657320287468652022536F66747761726522292C20746F206465616C0A';
wwv_flow_api.g_varchar2_table(148) := '202A20696E2074686520536F66747761726520776974686F7574207265737472696374696F6E2C20696E636C7564696E6720776974686F7574206C696D69746174696F6E20746865207269676874730A202A20746F207573652C20636F70792C206D6F64';
wwv_flow_api.g_varchar2_table(149) := '6966792C206D657267652C207075626C6973682C20646973747269627574652C207375626C6963656E73652C20616E642F6F722073656C6C0A202A20636F70696573206F662074686520536F6674776172652C20616E6420746F207065726D6974207065';
wwv_flow_api.g_varchar2_table(150) := '72736F6E7320746F2077686F6D2074686520536F6674776172652069730A202A206675726E697368656420746F20646F20736F2C207375626A65637420746F2074686520666F6C6C6F77696E6720636F6E646974696F6E733A0A202A0A202A2054686520';
wwv_flow_api.g_varchar2_table(151) := '61626F766520636F70797269676874206E6F7469636520616E642074686973207065726D697373696F6E206E6F74696365207368616C6C20626520696E636C7564656420696E20616C6C0A202A20636F70696573206F72207375627374616E7469616C20';
wwv_flow_api.g_varchar2_table(152) := '706F7274696F6E73206F662074686520536F6674776172652E0A202A0A202A2054484520534F4654574152452049532050524F564944454420224153204953222C20574954484F55542057415252414E5459204F4620414E59204B494E442C2045585052';
wwv_flow_api.g_varchar2_table(153) := '455353204F520A202A20494D504C4945442C20494E434C5544494E4720425554204E4F54204C494D4954454420544F205448452057415252414E54494553204F46204D45524348414E544142494C4954592C0A202A204649544E45535320464F52204120';
wwv_flow_api.g_varchar2_table(154) := '504152544943554C415220505552504F534520414E44204E4F4E494E4652494E47454D454E542E20494E204E4F204556454E54205348414C4C205448450A202A20415554484F5253204F5220434F5059524947485420484F4C44455253204245204C4941';
wwv_flow_api.g_varchar2_table(155) := '424C4520464F5220414E5920434C41494D2C2044414D41474553204F52204F544845520A202A204C494142494C4954592C205748455448455220494E20414E20414354494F4E204F4620434F4E54524143542C20544F5254204F52204F54484552574953';
wwv_flow_api.g_varchar2_table(156) := '452C2041524953494E472046524F4D2C0A202A204F5554204F46204F5220494E20434F4E4E454354494F4E20574954482054484520534F465457415245204F522054484520555345204F52204F54484552204445414C494E475320494E205448450A202A';
wwv_flow_api.g_varchar2_table(157) := '20534F4654574152452E0A202A2F0A76617220697342726F777365722431203D20747970656F662077696E646F7720213D3D2027756E646566696E65642720262620747970656F6620646F63756D656E7420213D3D2027756E646566696E6564273B0A0A';
wwv_flow_api.g_varchar2_table(158) := '766172206C6F6E67657254696D656F757442726F7773657273203D205B2745646765272C202754726964656E74272C202746697265666F78275D3B0A7661722074696D656F75744475726174696F6E203D20303B0A666F7220287661722069203D20303B';
wwv_flow_api.g_varchar2_table(159) := '2069203C206C6F6E67657254696D656F757442726F77736572732E6C656E6774683B2069202B3D203129207B0A202069662028697342726F777365722431202626206E6176696761746F722E757365724167656E742E696E6465784F66286C6F6E676572';
wwv_flow_api.g_varchar2_table(160) := '54696D656F757442726F77736572735B695D29203E3D203029207B0A2020202074696D656F75744475726174696F6E203D20313B0A20202020627265616B3B0A20207D0A7D0A0A66756E6374696F6E206D6963726F7461736B4465626F756E636528666E';
wwv_flow_api.g_varchar2_table(161) := '29207B0A20207661722063616C6C6564203D2066616C73653B0A202072657475726E2066756E6374696F6E202829207B0A202020206966202863616C6C656429207B0A20202020202072657475726E3B0A202020207D0A2020202063616C6C6564203D20';
wwv_flow_api.g_varchar2_table(162) := '747275653B0A2020202077696E646F772E50726F6D6973652E7265736F6C766528292E7468656E2866756E6374696F6E202829207B0A20202020202063616C6C6564203D2066616C73653B0A202020202020666E28293B0A202020207D293B0A20207D3B';
wwv_flow_api.g_varchar2_table(163) := '0A7D0A0A66756E6374696F6E207461736B4465626F756E636528666E29207B0A2020766172207363686564756C6564203D2066616C73653B0A202072657475726E2066756E6374696F6E202829207B0A2020202069662028217363686564756C65642920';
wwv_flow_api.g_varchar2_table(164) := '7B0A2020202020207363686564756C6564203D20747275653B0A20202020202073657454696D656F75742866756E6374696F6E202829207B0A20202020202020207363686564756C6564203D2066616C73653B0A2020202020202020666E28293B0A2020';
wwv_flow_api.g_varchar2_table(165) := '202020207D2C2074696D656F75744475726174696F6E293B0A202020207D0A20207D3B0A7D0A0A76617220737570706F7274734D6963726F5461736B73203D20697342726F7773657224312026262077696E646F772E50726F6D6973653B0A0A2F2A2A0A';
wwv_flow_api.g_varchar2_table(166) := '2A204372656174652061206465626F756E6365642076657273696F6E206F662061206D6574686F642C20746861742773206173796E6368726F6E6F75736C792064656665727265640A2A206275742063616C6C656420696E20746865206D696E696D756D';
wwv_flow_api.g_varchar2_table(167) := '2074696D6520706F737369626C652E0A2A0A2A20406D6574686F640A2A20406D656D6265726F6620506F707065722E5574696C730A2A2040617267756D656E74207B46756E6374696F6E7D20666E0A2A204072657475726E73207B46756E6374696F6E7D';
wwv_flow_api.g_varchar2_table(168) := '0A2A2F0A766172206465626F756E6365203D20737570706F7274734D6963726F5461736B73203F206D6963726F7461736B4465626F756E6365203A207461736B4465626F756E63653B0A0A2F2A2A0A202A20436865636B2069662074686520676976656E';
wwv_flow_api.g_varchar2_table(169) := '207661726961626C6520697320612066756E6374696F6E0A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040617267756D656E74207B416E797D2066756E6374696F6E546F436865636B202D207661';
wwv_flow_api.g_varchar2_table(170) := '726961626C6520746F20636865636B0A202A204072657475726E73207B426F6F6C65616E7D20616E7377657220746F3A20697320612066756E6374696F6E3F0A202A2F0A66756E6374696F6E20697346756E6374696F6E2866756E6374696F6E546F4368';
wwv_flow_api.g_varchar2_table(171) := '65636B29207B0A20207661722067657454797065203D207B7D3B0A202072657475726E2066756E6374696F6E546F436865636B20262620676574547970652E746F537472696E672E63616C6C2866756E6374696F6E546F436865636B29203D3D3D20275B';
wwv_flow_api.g_varchar2_table(172) := '6F626A6563742046756E6374696F6E5D273B0A7D0A0A2F2A2A0A202A204765742043535320636F6D70757465642070726F7065727479206F662074686520676976656E20656C656D656E740A202A20406D6574686F640A202A20406D656D6265726F6620';
wwv_flow_api.g_varchar2_table(173) := '506F707065722E5574696C730A202A2040617267756D656E74207B45656D656E747D20656C656D656E740A202A2040617267756D656E74207B537472696E677D2070726F70657274790A202A2F0A66756E6374696F6E206765745374796C65436F6D7075';
wwv_flow_api.g_varchar2_table(174) := '74656450726F706572747928656C656D656E742C2070726F706572747929207B0A202069662028656C656D656E742E6E6F64655479706520213D3D203129207B0A2020202072657475726E205B5D3B0A20207D0A20202F2F204E4F54453A203120444F4D';
wwv_flow_api.g_varchar2_table(175) := '2061636365737320686572650A20207661722077696E646F77203D20656C656D656E742E6F776E6572446F63756D656E742E64656661756C74566965773B0A202076617220637373203D2077696E646F772E676574436F6D70757465645374796C652865';
wwv_flow_api.g_varchar2_table(176) := '6C656D656E742C206E756C6C293B0A202072657475726E2070726F7065727479203F206373735B70726F70657274795D203A206373733B0A7D0A0A2F2A2A0A202A2052657475726E732074686520706172656E744E6F6465206F722074686520686F7374';
wwv_flow_api.g_varchar2_table(177) := '206F662074686520656C656D656E740A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040617267756D656E74207B456C656D656E747D20656C656D656E740A202A204072657475726E73207B456C65';
wwv_flow_api.g_varchar2_table(178) := '6D656E747D20706172656E740A202A2F0A66756E6374696F6E20676574506172656E744E6F646528656C656D656E7429207B0A202069662028656C656D656E742E6E6F64654E616D65203D3D3D202748544D4C2729207B0A2020202072657475726E2065';
wwv_flow_api.g_varchar2_table(179) := '6C656D656E743B0A20207D0A202072657475726E20656C656D656E742E706172656E744E6F6465207C7C20656C656D656E742E686F73743B0A7D0A0A2F2A2A0A202A2052657475726E7320746865207363726F6C6C696E6720706172656E74206F662074';
wwv_flow_api.g_varchar2_table(180) := '686520676976656E20656C656D656E740A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040617267756D656E74207B456C656D656E747D20656C656D656E740A202A204072657475726E73207B456C';
wwv_flow_api.g_varchar2_table(181) := '656D656E747D207363726F6C6C20706172656E740A202A2F0A66756E6374696F6E206765745363726F6C6C506172656E7428656C656D656E7429207B0A20202F2F2052657475726E20626F64792C20606765745363726F6C6C602077696C6C2074616B65';
wwv_flow_api.g_varchar2_table(182) := '206361726520746F206765742074686520636F727265637420607363726F6C6C546F70602066726F6D2069740A20206966202821656C656D656E7429207B0A2020202072657475726E20646F63756D656E742E626F64793B0A20207D0A0A202073776974';
wwv_flow_api.g_varchar2_table(183) := '63682028656C656D656E742E6E6F64654E616D6529207B0A2020202063617365202748544D4C273A0A20202020636173652027424F4459273A0A20202020202072657475726E20656C656D656E742E6F776E6572446F63756D656E742E626F64793B0A20';
wwv_flow_api.g_varchar2_table(184) := '20202063617365202723646F63756D656E74273A0A20202020202072657475726E20656C656D656E742E626F64793B0A20207D0A0A20202F2F2046697265666F782077616E7420757320746F20636865636B20602D786020616E6420602D796020766172';
wwv_flow_api.g_varchar2_table(185) := '696174696F6E732061732077656C6C0A0A2020766172205F6765745374796C65436F6D707574656450726F70203D206765745374796C65436F6D707574656450726F706572747928656C656D656E74292C0A2020202020206F766572666C6F77203D205F';
wwv_flow_api.g_varchar2_table(186) := '6765745374796C65436F6D707574656450726F702E6F766572666C6F772C0A2020202020206F766572666C6F7758203D205F6765745374796C65436F6D707574656450726F702E6F766572666C6F77582C0A2020202020206F766572666C6F7759203D20';
wwv_flow_api.g_varchar2_table(187) := '5F6765745374796C65436F6D707574656450726F702E6F766572666C6F77593B0A0A2020696620282F286175746F7C7363726F6C6C7C6F7665726C6179292F2E74657374286F766572666C6F77202B206F766572666C6F7759202B206F766572666C6F77';
wwv_flow_api.g_varchar2_table(188) := '582929207B0A2020202072657475726E20656C656D656E743B0A20207D0A0A202072657475726E206765745363726F6C6C506172656E7428676574506172656E744E6F646528656C656D656E7429293B0A7D0A0A76617220697349453131203D20697342';
wwv_flow_api.g_varchar2_table(189) := '726F7773657224312026262021212877696E646F772E4D53496E7075744D6574686F64436F6E7465787420262620646F63756D656E742E646F63756D656E744D6F6465293B0A76617220697349453130203D20697342726F777365722431202626202F4D';
wwv_flow_api.g_varchar2_table(190) := '5349452031302F2E74657374286E6176696761746F722E757365724167656E74293B0A0A2F2A2A0A202A2044657465726D696E6573206966207468652062726F7773657220697320496E7465726E6574204578706C6F7265720A202A20406D6574686F64';
wwv_flow_api.g_varchar2_table(191) := '0A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040706172616D207B4E756D6265727D2076657273696F6E20746F20636865636B0A202A204072657475726E73207B426F6F6C65616E7D20697349450A202A2F0A66756E637469';
wwv_flow_api.g_varchar2_table(192) := '6F6E206973494524312876657273696F6E29207B0A20206966202876657273696F6E203D3D3D20313129207B0A2020202072657475726E206973494531313B0A20207D0A20206966202876657273696F6E203D3D3D20313029207B0A2020202072657475';
wwv_flow_api.g_varchar2_table(193) := '726E206973494531303B0A20207D0A202072657475726E20697349453131207C7C206973494531303B0A7D0A0A2F2A2A0A202A2052657475726E7320746865206F666673657420706172656E74206F662074686520676976656E20656C656D656E740A20';
wwv_flow_api.g_varchar2_table(194) := '2A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040617267756D656E74207B456C656D656E747D20656C656D656E740A202A204072657475726E73207B456C656D656E747D206F66667365742070617265';
wwv_flow_api.g_varchar2_table(195) := '6E740A202A2F0A66756E6374696F6E206765744F6666736574506172656E7428656C656D656E7429207B0A20206966202821656C656D656E7429207B0A2020202072657475726E20646F63756D656E742E646F63756D656E74456C656D656E743B0A2020';
wwv_flow_api.g_varchar2_table(196) := '7D0A0A2020766172206E6F4F6666736574506172656E74203D2069734945243128313029203F20646F63756D656E742E626F6479203A206E756C6C3B0A0A20202F2F204E4F54453A203120444F4D2061636365737320686572650A2020766172206F6666';
wwv_flow_api.g_varchar2_table(197) := '736574506172656E74203D20656C656D656E742E6F6666736574506172656E74207C7C206E756C6C3B0A20202F2F20536B69702068696464656E20656C656D656E747320776869636820646F6E2774206861766520616E206F6666736574506172656E74';
wwv_flow_api.g_varchar2_table(198) := '0A20207768696C6520286F6666736574506172656E74203D3D3D206E6F4F6666736574506172656E7420262620656C656D656E742E6E657874456C656D656E745369626C696E6729207B0A202020206F6666736574506172656E74203D2028656C656D65';
wwv_flow_api.g_varchar2_table(199) := '6E74203D20656C656D656E742E6E657874456C656D656E745369626C696E67292E6F6666736574506172656E743B0A20207D0A0A2020766172206E6F64654E616D65203D206F6666736574506172656E74202626206F6666736574506172656E742E6E6F';
wwv_flow_api.g_varchar2_table(200) := '64654E616D653B0A0A202069662028216E6F64654E616D65207C7C206E6F64654E616D65203D3D3D2027424F445927207C7C206E6F64654E616D65203D3D3D202748544D4C2729207B0A2020202072657475726E20656C656D656E74203F20656C656D65';
wwv_flow_api.g_varchar2_table(201) := '6E742E6F776E6572446F63756D656E742E646F63756D656E74456C656D656E74203A20646F63756D656E742E646F63756D656E74456C656D656E743B0A20207D0A0A20202F2F202E6F6666736574506172656E742077696C6C2072657475726E20746865';
wwv_flow_api.g_varchar2_table(202) := '20636C6F736573742054482C205444206F72205441424C4520696E20636173650A20202F2F206E6F206F6666736574506172656E742069732070726573656E742C204920686174652074686973206A6F622E2E2E0A2020696620285B275448272C202754';
wwv_flow_api.g_varchar2_table(203) := '44272C20275441424C45275D2E696E6465784F66286F6666736574506172656E742E6E6F64654E616D652920213D3D202D31202626206765745374796C65436F6D707574656450726F7065727479286F6666736574506172656E742C2027706F73697469';
wwv_flow_api.g_varchar2_table(204) := '6F6E2729203D3D3D20277374617469632729207B0A2020202072657475726E206765744F6666736574506172656E74286F6666736574506172656E74293B0A20207D0A0A202072657475726E206F6666736574506172656E743B0A7D0A0A66756E637469';
wwv_flow_api.g_varchar2_table(205) := '6F6E2069734F6666736574436F6E7461696E657228656C656D656E7429207B0A2020766172206E6F64654E616D65203D20656C656D656E742E6E6F64654E616D653B0A0A2020696620286E6F64654E616D65203D3D3D2027424F44592729207B0A202020';
wwv_flow_api.g_varchar2_table(206) := '2072657475726E2066616C73653B0A20207D0A202072657475726E206E6F64654E616D65203D3D3D202748544D4C27207C7C206765744F6666736574506172656E7428656C656D656E742E6669727374456C656D656E744368696C6429203D3D3D20656C';
wwv_flow_api.g_varchar2_table(207) := '656D656E743B0A7D0A0A2F2A2A0A202A2046696E64732074686520726F6F74206E6F64652028646F63756D656E742C20736861646F77444F4D20726F6F7429206F662074686520676976656E20656C656D656E740A202A20406D6574686F640A202A2040';
wwv_flow_api.g_varchar2_table(208) := '6D656D6265726F6620506F707065722E5574696C730A202A2040617267756D656E74207B456C656D656E747D206E6F64650A202A204072657475726E73207B456C656D656E747D20726F6F74206E6F64650A202A2F0A66756E6374696F6E20676574526F';
wwv_flow_api.g_varchar2_table(209) := '6F74286E6F646529207B0A2020696620286E6F64652E706172656E744E6F646520213D3D206E756C6C29207B0A2020202072657475726E20676574526F6F74286E6F64652E706172656E744E6F6465293B0A20207D0A0A202072657475726E206E6F6465';
wwv_flow_api.g_varchar2_table(210) := '3B0A7D0A0A2F2A2A0A202A2046696E647320746865206F666673657420706172656E7420636F6D6D6F6E20746F207468652074776F2070726F7669646564206E6F6465730A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E';
wwv_flow_api.g_varchar2_table(211) := '5574696C730A202A2040617267756D656E74207B456C656D656E747D20656C656D656E74310A202A2040617267756D656E74207B456C656D656E747D20656C656D656E74320A202A204072657475726E73207B456C656D656E747D20636F6D6D6F6E206F';
wwv_flow_api.g_varchar2_table(212) := '666673657420706172656E740A202A2F0A66756E6374696F6E2066696E64436F6D6D6F6E4F6666736574506172656E7428656C656D656E74312C20656C656D656E743229207B0A20202F2F205468697320636865636B206973206E656564656420746F20';
wwv_flow_api.g_varchar2_table(213) := '61766F6964206572726F727320696E2063617365206F6E65206F662074686520656C656D656E74732069736E277420646566696E656420666F7220616E7920726561736F6E0A20206966202821656C656D656E7431207C7C2021656C656D656E74312E6E';
wwv_flow_api.g_varchar2_table(214) := '6F646554797065207C7C2021656C656D656E7432207C7C2021656C656D656E74322E6E6F64655479706529207B0A2020202072657475726E20646F63756D656E742E646F63756D656E74456C656D656E743B0A20207D0A0A20202F2F2048657265207765';
wwv_flow_api.g_varchar2_table(215) := '206D616B65207375726520746F206769766520617320227374617274222074686520656C656D656E74207468617420636F6D657320666972737420696E2074686520444F4D0A2020766172206F72646572203D20656C656D656E74312E636F6D70617265';
wwv_flow_api.g_varchar2_table(216) := '446F63756D656E74506F736974696F6E28656C656D656E7432292026204E6F64652E444F43554D454E545F504F534954494F4E5F464F4C4C4F57494E473B0A2020766172207374617274203D206F72646572203F20656C656D656E7431203A20656C656D';
wwv_flow_api.g_varchar2_table(217) := '656E74323B0A202076617220656E64203D206F72646572203F20656C656D656E7432203A20656C656D656E74313B0A0A20202F2F2047657420636F6D6D6F6E20616E636573746F7220636F6E7461696E65720A20207661722072616E6765203D20646F63';
wwv_flow_api.g_varchar2_table(218) := '756D656E742E63726561746552616E676528293B0A202072616E67652E73657453746172742873746172742C2030293B0A202072616E67652E736574456E6428656E642C2030293B0A202076617220636F6D6D6F6E416E636573746F72436F6E7461696E';
wwv_flow_api.g_varchar2_table(219) := '6572203D2072616E67652E636F6D6D6F6E416E636573746F72436F6E7461696E65723B0A0A20202F2F20426F7468206E6F6465732061726520696E736964652023646F63756D656E740A0A202069662028656C656D656E743120213D3D20636F6D6D6F6E';
wwv_flow_api.g_varchar2_table(220) := '416E636573746F72436F6E7461696E657220262620656C656D656E743220213D3D20636F6D6D6F6E416E636573746F72436F6E7461696E6572207C7C2073746172742E636F6E7461696E7328656E642929207B0A202020206966202869734F6666736574';
wwv_flow_api.g_varchar2_table(221) := '436F6E7461696E657228636F6D6D6F6E416E636573746F72436F6E7461696E65722929207B0A20202020202072657475726E20636F6D6D6F6E416E636573746F72436F6E7461696E65723B0A202020207D0A0A2020202072657475726E206765744F6666';
wwv_flow_api.g_varchar2_table(222) := '736574506172656E7428636F6D6D6F6E416E636573746F72436F6E7461696E6572293B0A20207D0A0A20202F2F206F6E65206F6620746865206E6F64657320697320696E7369646520736861646F77444F4D2C2066696E64207768696368206F6E650A20';
wwv_flow_api.g_varchar2_table(223) := '2076617220656C656D656E7431726F6F74203D20676574526F6F7428656C656D656E7431293B0A202069662028656C656D656E7431726F6F742E686F737429207B0A2020202072657475726E2066696E64436F6D6D6F6E4F6666736574506172656E7428';
wwv_flow_api.g_varchar2_table(224) := '656C656D656E7431726F6F742E686F73742C20656C656D656E7432293B0A20207D20656C7365207B0A2020202072657475726E2066696E64436F6D6D6F6E4F6666736574506172656E7428656C656D656E74312C20676574526F6F7428656C656D656E74';
wwv_flow_api.g_varchar2_table(225) := '32292E686F7374293B0A20207D0A7D0A0A2F2A2A0A202A204765747320746865207363726F6C6C2076616C7565206F662074686520676976656E20656C656D656E7420696E2074686520676976656E20736964652028746F7020616E64206C656674290A';
wwv_flow_api.g_varchar2_table(226) := '202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040617267756D656E74207B456C656D656E747D20656C656D656E740A202A2040617267756D656E74207B537472696E677D20736964652060746F7060';
wwv_flow_api.g_varchar2_table(227) := '206F7220606C656674600A202A204072657475726E73207B6E756D6265727D20616D6F756E74206F66207363726F6C6C656420706978656C730A202A2F0A66756E6374696F6E206765745363726F6C6C28656C656D656E7429207B0A2020766172207369';
wwv_flow_api.g_varchar2_table(228) := '6465203D20617267756D656E74732E6C656E677468203E203120262620617267756D656E74735B315D20213D3D20756E646566696E6564203F20617267756D656E74735B315D203A2027746F70273B0A0A202076617220757070657253696465203D2073';
wwv_flow_api.g_varchar2_table(229) := '696465203D3D3D2027746F7027203F20277363726F6C6C546F7027203A20277363726F6C6C4C656674273B0A2020766172206E6F64654E616D65203D20656C656D656E742E6E6F64654E616D653B0A0A2020696620286E6F64654E616D65203D3D3D2027';
wwv_flow_api.g_varchar2_table(230) := '424F445927207C7C206E6F64654E616D65203D3D3D202748544D4C2729207B0A202020207661722068746D6C203D20656C656D656E742E6F776E6572446F63756D656E742E646F63756D656E74456C656D656E743B0A20202020766172207363726F6C6C';
wwv_flow_api.g_varchar2_table(231) := '696E67456C656D656E74203D20656C656D656E742E6F776E6572446F63756D656E742E7363726F6C6C696E67456C656D656E74207C7C2068746D6C3B0A2020202072657475726E207363726F6C6C696E67456C656D656E745B7570706572536964655D3B';
wwv_flow_api.g_varchar2_table(232) := '0A20207D0A0A202072657475726E20656C656D656E745B7570706572536964655D3B0A7D0A0A2F2A0A202A2053756D206F722073756274726163742074686520656C656D656E74207363726F6C6C2076616C75657320286C65667420616E6420746F7029';
wwv_flow_api.g_varchar2_table(233) := '2066726F6D206120676976656E2072656374206F626A6563740A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040706172616D207B4F626A6563747D2072656374202D2052656374206F626A656374';
wwv_flow_api.g_varchar2_table(234) := '20796F752077616E7420746F206368616E67650A202A2040706172616D207B48544D4C456C656D656E747D20656C656D656E74202D2054686520656C656D656E742066726F6D207468652066756E6374696F6E20726561647320746865207363726F6C6C';
wwv_flow_api.g_varchar2_table(235) := '2076616C7565730A202A2040706172616D207B426F6F6C65616E7D207375627472616374202D2073657420746F207472756520696620796F752077616E7420746F20737562747261637420746865207363726F6C6C2076616C7565730A202A2040726574';
wwv_flow_api.g_varchar2_table(236) := '75726E207B4F626A6563747D2072656374202D20546865206D6F6469666965722072656374206F626A6563740A202A2F0A66756E6374696F6E20696E636C7564655363726F6C6C28726563742C20656C656D656E7429207B0A2020766172207375627472';
wwv_flow_api.g_varchar2_table(237) := '616374203D20617267756D656E74732E6C656E677468203E203220262620617267756D656E74735B325D20213D3D20756E646566696E6564203F20617267756D656E74735B325D203A2066616C73653B0A0A2020766172207363726F6C6C546F70203D20';
wwv_flow_api.g_varchar2_table(238) := '6765745363726F6C6C28656C656D656E742C2027746F7027293B0A2020766172207363726F6C6C4C656674203D206765745363726F6C6C28656C656D656E742C20276C65667427293B0A2020766172206D6F646966696572203D20737562747261637420';
wwv_flow_api.g_varchar2_table(239) := '3F202D31203A20313B0A2020726563742E746F70202B3D207363726F6C6C546F70202A206D6F6469666965723B0A2020726563742E626F74746F6D202B3D207363726F6C6C546F70202A206D6F6469666965723B0A2020726563742E6C656674202B3D20';
wwv_flow_api.g_varchar2_table(240) := '7363726F6C6C4C656674202A206D6F6469666965723B0A2020726563742E7269676874202B3D207363726F6C6C4C656674202A206D6F6469666965723B0A202072657475726E20726563743B0A7D0A0A2F2A0A202A2048656C70657220746F2064657465';
wwv_flow_api.g_varchar2_table(241) := '637420626F7264657273206F66206120676976656E20656C656D656E740A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040706172616D207B4353535374796C654465636C61726174696F6E7D2073';
wwv_flow_api.g_varchar2_table(242) := '74796C65730A202A20526573756C74206F6620606765745374796C65436F6D707574656450726F706572747960206F6E2074686520676976656E20656C656D656E740A202A2040706172616D207B537472696E677D2061786973202D20607860206F7220';
wwv_flow_api.g_varchar2_table(243) := '6079600A202A204072657475726E207B6E756D6265727D20626F7264657273202D2054686520626F72646572732073697A65206F662074686520676976656E20617869730A202A2F0A0A66756E6374696F6E20676574426F726465727353697A65287374';
wwv_flow_api.g_varchar2_table(244) := '796C65732C206178697329207B0A2020766172207369646541203D2061786973203D3D3D20277827203F20274C65667427203A2027546F70273B0A2020766172207369646542203D207369646541203D3D3D20274C65667427203F202752696768742720';
wwv_flow_api.g_varchar2_table(245) := '3A2027426F74746F6D273B0A0A202072657475726E207061727365466C6F6174287374796C65735B27626F7264657227202B207369646541202B20275769647468275D2C20313029202B207061727365466C6F6174287374796C65735B27626F72646572';
wwv_flow_api.g_varchar2_table(246) := '27202B207369646542202B20275769647468275D2C203130293B0A7D0A0A66756E6374696F6E2067657453697A6528617869732C20626F64792C2068746D6C2C20636F6D70757465645374796C6529207B0A202072657475726E204D6174682E6D617828';
wwv_flow_api.g_varchar2_table(247) := '626F64795B276F666673657427202B20617869735D2C20626F64795B277363726F6C6C27202B20617869735D2C2068746D6C5B27636C69656E7427202B20617869735D2C2068746D6C5B276F666673657427202B20617869735D2C2068746D6C5B277363';
wwv_flow_api.g_varchar2_table(248) := '726F6C6C27202B20617869735D2C2069734945243128313029203F207061727365496E742868746D6C5B276F666673657427202B20617869735D29202B207061727365496E7428636F6D70757465645374796C655B276D617267696E27202B2028617869';
wwv_flow_api.g_varchar2_table(249) := '73203D3D3D202748656967687427203F2027546F7027203A20274C65667427295D29202B207061727365496E7428636F6D70757465645374796C655B276D617267696E27202B202861786973203D3D3D202748656967687427203F2027426F74746F6D27';
wwv_flow_api.g_varchar2_table(250) := '203A2027526967687427295D29203A2030293B0A7D0A0A66756E6374696F6E2067657457696E646F7753697A657328646F63756D656E7429207B0A202076617220626F6479203D20646F63756D656E742E626F64793B0A20207661722068746D6C203D20';
wwv_flow_api.g_varchar2_table(251) := '646F63756D656E742E646F63756D656E74456C656D656E743B0A202076617220636F6D70757465645374796C65203D206973494524312831302920262620676574436F6D70757465645374796C652868746D6C293B0A0A202072657475726E207B0A2020';
wwv_flow_api.g_varchar2_table(252) := '20206865696768743A2067657453697A652827486569676874272C20626F64792C2068746D6C2C20636F6D70757465645374796C65292C0A2020202077696474683A2067657453697A6528275769647468272C20626F64792C2068746D6C2C20636F6D70';
wwv_flow_api.g_varchar2_table(253) := '757465645374796C65290A20207D3B0A7D0A0A76617220636C61737343616C6C436865636B203D2066756E6374696F6E20636C61737343616C6C436865636B28696E7374616E63652C20436F6E7374727563746F7229207B0A2020696620282128696E73';
wwv_flow_api.g_varchar2_table(254) := '74616E636520696E7374616E63656F6620436F6E7374727563746F722929207B0A202020207468726F77206E657720547970654572726F72282243616E6E6F742063616C6C206120636C61737320617320612066756E6374696F6E22293B0A20207D0A7D';
wwv_flow_api.g_varchar2_table(255) := '3B0A0A76617220637265617465436C617373203D2066756E6374696F6E202829207B0A202066756E6374696F6E20646566696E6550726F70657274696573287461726765742C2070726F707329207B0A20202020666F7220287661722069203D20303B20';
wwv_flow_api.g_varchar2_table(256) := '69203C2070726F70732E6C656E6774683B20692B2B29207B0A2020202020207661722064657363726970746F72203D2070726F70735B695D3B0A20202020202064657363726970746F722E656E756D657261626C65203D2064657363726970746F722E65';
wwv_flow_api.g_varchar2_table(257) := '6E756D657261626C65207C7C2066616C73653B0A20202020202064657363726970746F722E636F6E666967757261626C65203D20747275653B0A202020202020696620282276616C75652220696E2064657363726970746F72292064657363726970746F';
wwv_flow_api.g_varchar2_table(258) := '722E7772697461626C65203D20747275653B0A2020202020204F626A6563742E646566696E6550726F7065727479287461726765742C2064657363726970746F722E6B65792C2064657363726970746F72293B0A202020207D0A20207D0A0A2020726574';
wwv_flow_api.g_varchar2_table(259) := '75726E2066756E6374696F6E2028436F6E7374727563746F722C2070726F746F50726F70732C2073746174696350726F707329207B0A202020206966202870726F746F50726F70732920646566696E6550726F7065727469657328436F6E737472756374';
wwv_flow_api.g_varchar2_table(260) := '6F722E70726F746F747970652C2070726F746F50726F7073293B0A202020206966202873746174696350726F70732920646566696E6550726F7065727469657328436F6E7374727563746F722C2073746174696350726F7073293B0A2020202072657475';
wwv_flow_api.g_varchar2_table(261) := '726E20436F6E7374727563746F723B0A20207D3B0A7D28293B0A0A76617220646566696E6550726F7065727479203D2066756E6374696F6E20646566696E6550726F7065727479286F626A2C206B65792C2076616C756529207B0A2020696620286B6579';
wwv_flow_api.g_varchar2_table(262) := '20696E206F626A29207B0A202020204F626A6563742E646566696E6550726F7065727479286F626A2C206B65792C207B0A20202020202076616C75653A2076616C75652C0A202020202020656E756D657261626C653A20747275652C0A20202020202063';
wwv_flow_api.g_varchar2_table(263) := '6F6E666967757261626C653A20747275652C0A2020202020207772697461626C653A20747275650A202020207D293B0A20207D20656C7365207B0A202020206F626A5B6B65795D203D2076616C75653B0A20207D0A0A202072657475726E206F626A3B0A';
wwv_flow_api.g_varchar2_table(264) := '7D3B0A0A766172205F657874656E6473203D204F626A6563742E61737369676E207C7C2066756E6374696F6E202874617267657429207B0A2020666F7220287661722069203D20313B2069203C20617267756D656E74732E6C656E6774683B20692B2B29';
wwv_flow_api.g_varchar2_table(265) := '207B0A2020202076617220736F75726365203D20617267756D656E74735B695D3B0A0A20202020666F722028766172206B657920696E20736F7572636529207B0A202020202020696620284F626A6563742E70726F746F747970652E6861734F776E5072';
wwv_flow_api.g_varchar2_table(266) := '6F70657274792E63616C6C28736F757263652C206B65792929207B0A20202020202020207461726765745B6B65795D203D20736F757263655B6B65795D3B0A2020202020207D0A202020207D0A20207D0A0A202072657475726E207461726765743B0A7D';
wwv_flow_api.g_varchar2_table(267) := '3B0A0A2F2A2A0A202A20476976656E20656C656D656E74206F6666736574732C2067656E657261746520616E206F75747075742073696D696C617220746F20676574426F756E64696E67436C69656E74526563740A202A20406D6574686F640A202A2040';
wwv_flow_api.g_varchar2_table(268) := '6D656D6265726F6620506F707065722E5574696C730A202A2040617267756D656E74207B4F626A6563747D206F6666736574730A202A204072657475726E73207B4F626A6563747D20436C69656E7452656374206C696B65206F75747075740A202A2F0A';
wwv_flow_api.g_varchar2_table(269) := '66756E6374696F6E20676574436C69656E7452656374286F66667365747329207B0A202072657475726E205F657874656E6473287B7D2C206F6666736574732C207B0A2020202072696768743A206F6666736574732E6C656674202B206F666673657473';
wwv_flow_api.g_varchar2_table(270) := '2E77696474682C0A20202020626F74746F6D3A206F6666736574732E746F70202B206F6666736574732E6865696768740A20207D293B0A7D0A0A2F2A2A0A202A2047657420626F756E64696E6720636C69656E742072656374206F6620676976656E2065';
wwv_flow_api.g_varchar2_table(271) := '6C656D656E740A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040706172616D207B48544D4C456C656D656E747D20656C656D656E740A202A204072657475726E207B4F626A6563747D20636C6965';
wwv_flow_api.g_varchar2_table(272) := '6E7420726563740A202A2F0A66756E6374696F6E20676574426F756E64696E67436C69656E745265637428656C656D656E7429207B0A20207661722072656374203D207B7D3B0A0A20202F2F2049453130203130204649583A20506C656173652C20646F';
wwv_flow_api.g_varchar2_table(273) := '6E27742061736B2C2074686520656C656D656E742069736E27740A20202F2F20636F6E7369646572656420696E20444F4D20696E20736F6D652063697263756D7374616E6365732E2E2E0A20202F2F20546869732069736E277420726570726F64756369';
wwv_flow_api.g_varchar2_table(274) := '626C6520696E204945313020636F6D7061746962696C697479206D6F6465206F6620494531310A2020747279207B0A20202020696620286973494524312831302929207B0A20202020202072656374203D20656C656D656E742E676574426F756E64696E';
wwv_flow_api.g_varchar2_table(275) := '67436C69656E745265637428293B0A202020202020766172207363726F6C6C546F70203D206765745363726F6C6C28656C656D656E742C2027746F7027293B0A202020202020766172207363726F6C6C4C656674203D206765745363726F6C6C28656C65';
wwv_flow_api.g_varchar2_table(276) := '6D656E742C20276C65667427293B0A202020202020726563742E746F70202B3D207363726F6C6C546F703B0A202020202020726563742E6C656674202B3D207363726F6C6C4C6566743B0A202020202020726563742E626F74746F6D202B3D207363726F';
wwv_flow_api.g_varchar2_table(277) := '6C6C546F703B0A202020202020726563742E7269676874202B3D207363726F6C6C4C6566743B0A202020207D20656C7365207B0A20202020202072656374203D20656C656D656E742E676574426F756E64696E67436C69656E745265637428293B0A2020';
wwv_flow_api.g_varchar2_table(278) := '20207D0A20207D20636174636820286529207B7D0A0A202076617220726573756C74203D207B0A202020206C6566743A20726563742E6C6566742C0A20202020746F703A20726563742E746F702C0A2020202077696474683A20726563742E7269676874';
wwv_flow_api.g_varchar2_table(279) := '202D20726563742E6C6566742C0A202020206865696768743A20726563742E626F74746F6D202D20726563742E746F700A20207D3B0A0A20202F2F207375627472616374207363726F6C6C6261722073697A652066726F6D2073697A65730A2020766172';
wwv_flow_api.g_varchar2_table(280) := '2073697A6573203D20656C656D656E742E6E6F64654E616D65203D3D3D202748544D4C27203F2067657457696E646F7753697A657328656C656D656E742E6F776E6572446F63756D656E7429203A207B7D3B0A2020766172207769647468203D2073697A';
wwv_flow_api.g_varchar2_table(281) := '65732E7769647468207C7C20656C656D656E742E636C69656E745769647468207C7C20726573756C742E7269676874202D20726573756C742E6C6566743B0A202076617220686569676874203D2073697A65732E686569676874207C7C20656C656D656E';
wwv_flow_api.g_varchar2_table(282) := '742E636C69656E74486569676874207C7C20726573756C742E626F74746F6D202D20726573756C742E746F703B0A0A202076617220686F72697A5363726F6C6C626172203D20656C656D656E742E6F66667365745769647468202D2077696474683B0A20';
wwv_flow_api.g_varchar2_table(283) := '2076617220766572745363726F6C6C626172203D20656C656D656E742E6F6666736574486569676874202D206865696768743B0A0A20202F2F20696620616E206879706F746865746963616C207363726F6C6C6261722069732064657465637465642C20';
wwv_flow_api.g_varchar2_table(284) := '7765206D75737420626520737572652069742773206E6F7420612060626F72646572600A20202F2F207765206D616B65207468697320636865636B20636F6E646974696F6E616C20666F7220706572666F726D616E636520726561736F6E730A20206966';
wwv_flow_api.g_varchar2_table(285) := '2028686F72697A5363726F6C6C626172207C7C20766572745363726F6C6C62617229207B0A20202020766172207374796C6573203D206765745374796C65436F6D707574656450726F706572747928656C656D656E74293B0A20202020686F72697A5363';
wwv_flow_api.g_varchar2_table(286) := '726F6C6C626172202D3D20676574426F726465727353697A65287374796C65732C20277827293B0A20202020766572745363726F6C6C626172202D3D20676574426F726465727353697A65287374796C65732C20277927293B0A0A20202020726573756C';
wwv_flow_api.g_varchar2_table(287) := '742E7769647468202D3D20686F72697A5363726F6C6C6261723B0A20202020726573756C742E686569676874202D3D20766572745363726F6C6C6261723B0A20207D0A0A202072657475726E20676574436C69656E745265637428726573756C74293B0A';
wwv_flow_api.g_varchar2_table(288) := '7D0A0A66756E6374696F6E206765744F66667365745265637452656C6174697665546F4172626974726172794E6F6465286368696C6472656E2C20706172656E7429207B0A2020766172206669786564506F736974696F6E203D20617267756D656E7473';
wwv_flow_api.g_varchar2_table(289) := '2E6C656E677468203E203220262620617267756D656E74735B325D20213D3D20756E646566696E6564203F20617267756D656E74735B325D203A2066616C73653B0A0A202076617220697349453130203D20697349452431283130293B0A202076617220';
wwv_flow_api.g_varchar2_table(290) := '697348544D4C203D20706172656E742E6E6F64654E616D65203D3D3D202748544D4C273B0A2020766172206368696C6472656E52656374203D20676574426F756E64696E67436C69656E7452656374286368696C6472656E293B0A202076617220706172';
wwv_flow_api.g_varchar2_table(291) := '656E7452656374203D20676574426F756E64696E67436C69656E745265637428706172656E74293B0A2020766172207363726F6C6C506172656E74203D206765745363726F6C6C506172656E74286368696C6472656E293B0A0A2020766172207374796C';
wwv_flow_api.g_varchar2_table(292) := '6573203D206765745374796C65436F6D707574656450726F706572747928706172656E74293B0A202076617220626F72646572546F705769647468203D207061727365466C6F6174287374796C65732E626F72646572546F7057696474682C203130293B';
wwv_flow_api.g_varchar2_table(293) := '0A202076617220626F726465724C6566745769647468203D207061727365466C6F6174287374796C65732E626F726465724C65667457696474682C203130293B0A0A20202F2F20496E2063617365732077686572652074686520706172656E7420697320';
wwv_flow_api.g_varchar2_table(294) := '66697865642C207765206D7573742069676E6F7265206E65676174697665207363726F6C6C20696E206F66667365742063616C630A2020696620286669786564506F736974696F6E20262620697348544D4C29207B0A20202020706172656E7452656374';
wwv_flow_api.g_varchar2_table(295) := '2E746F70203D204D6174682E6D617828706172656E74526563742E746F702C2030293B0A20202020706172656E74526563742E6C656674203D204D6174682E6D617828706172656E74526563742E6C6566742C2030293B0A20207D0A2020766172206F66';
wwv_flow_api.g_varchar2_table(296) := '6673657473203D20676574436C69656E7452656374287B0A20202020746F703A206368696C6472656E526563742E746F70202D20706172656E74526563742E746F70202D20626F72646572546F7057696474682C0A202020206C6566743A206368696C64';
wwv_flow_api.g_varchar2_table(297) := '72656E526563742E6C656674202D20706172656E74526563742E6C656674202D20626F726465724C65667457696474682C0A2020202077696474683A206368696C6472656E526563742E77696474682C0A202020206865696768743A206368696C647265';
wwv_flow_api.g_varchar2_table(298) := '6E526563742E6865696768740A20207D293B0A20206F6666736574732E6D617267696E546F70203D20303B0A20206F6666736574732E6D617267696E4C656674203D20303B0A0A20202F2F205375627472616374206D617267696E73206F6620646F6375';
wwv_flow_api.g_varchar2_table(299) := '6D656E74456C656D656E7420696E20636173652069742773206265696E67207573656420617320706172656E740A20202F2F20776520646F2074686973206F6E6C79206F6E2048544D4C2062656361757365206974277320746865206F6E6C7920656C65';
wwv_flow_api.g_varchar2_table(300) := '6D656E74207468617420626568617665730A20202F2F20646966666572656E746C79207768656E206D617267696E7320617265206170706C69656420746F2069742E20546865206D617267696E732061726520696E636C7564656420696E0A20202F2F20';
wwv_flow_api.g_varchar2_table(301) := '74686520626F78206F662074686520646F63756D656E74456C656D656E742C20696E20746865206F74686572206361736573206E6F742E0A2020696620282169734945313020262620697348544D4C29207B0A20202020766172206D617267696E546F70';
wwv_flow_api.g_varchar2_table(302) := '203D207061727365466C6F6174287374796C65732E6D617267696E546F702C203130293B0A20202020766172206D617267696E4C656674203D207061727365466C6F6174287374796C65732E6D617267696E4C6566742C203130293B0A0A202020206F66';
wwv_flow_api.g_varchar2_table(303) := '66736574732E746F70202D3D20626F72646572546F705769647468202D206D617267696E546F703B0A202020206F6666736574732E626F74746F6D202D3D20626F72646572546F705769647468202D206D617267696E546F703B0A202020206F66667365';
wwv_flow_api.g_varchar2_table(304) := '74732E6C656674202D3D20626F726465724C6566745769647468202D206D617267696E4C6566743B0A202020206F6666736574732E7269676874202D3D20626F726465724C6566745769647468202D206D617267696E4C6566743B0A0A202020202F2F20';
wwv_flow_api.g_varchar2_table(305) := '417474616368206D617267696E546F7020616E64206D617267696E4C656674206265636175736520696E20736F6D652063697263756D7374616E636573207765206D6179206E656564207468656D0A202020206F6666736574732E6D617267696E546F70';
wwv_flow_api.g_varchar2_table(306) := '203D206D617267696E546F703B0A202020206F6666736574732E6D617267696E4C656674203D206D617267696E4C6566743B0A20207D0A0A20206966202869734945313020262620216669786564506F736974696F6E203F20706172656E742E636F6E74';
wwv_flow_api.g_varchar2_table(307) := '61696E73287363726F6C6C506172656E7429203A20706172656E74203D3D3D207363726F6C6C506172656E74202626207363726F6C6C506172656E742E6E6F64654E616D6520213D3D2027424F44592729207B0A202020206F666673657473203D20696E';
wwv_flow_api.g_varchar2_table(308) := '636C7564655363726F6C6C286F6666736574732C20706172656E74293B0A20207D0A0A202072657475726E206F6666736574733B0A7D0A0A66756E6374696F6E2067657456696577706F72744F66667365745265637452656C6174697665546F41727462';
wwv_flow_api.g_varchar2_table(309) := '6974726172794E6F646528656C656D656E7429207B0A2020766172206578636C7564655363726F6C6C203D20617267756D656E74732E6C656E677468203E203120262620617267756D656E74735B315D20213D3D20756E646566696E6564203F20617267';
wwv_flow_api.g_varchar2_table(310) := '756D656E74735B315D203A2066616C73653B0A0A20207661722068746D6C203D20656C656D656E742E6F776E6572446F63756D656E742E646F63756D656E74456C656D656E743B0A20207661722072656C61746976654F6666736574203D206765744F66';
wwv_flow_api.g_varchar2_table(311) := '667365745265637452656C6174697665546F4172626974726172794E6F646528656C656D656E742C2068746D6C293B0A2020766172207769647468203D204D6174682E6D61782868746D6C2E636C69656E7457696474682C2077696E646F772E696E6E65';
wwv_flow_api.g_varchar2_table(312) := '725769647468207C7C2030293B0A202076617220686569676874203D204D6174682E6D61782868746D6C2E636C69656E744865696768742C2077696E646F772E696E6E6572486569676874207C7C2030293B0A0A2020766172207363726F6C6C546F7020';
wwv_flow_api.g_varchar2_table(313) := '3D20216578636C7564655363726F6C6C203F206765745363726F6C6C2868746D6C29203A20303B0A2020766172207363726F6C6C4C656674203D20216578636C7564655363726F6C6C203F206765745363726F6C6C2868746D6C2C20276C656674272920';
wwv_flow_api.g_varchar2_table(314) := '3A20303B0A0A2020766172206F6666736574203D207B0A20202020746F703A207363726F6C6C546F70202D2072656C61746976654F66667365742E746F70202B2072656C61746976654F66667365742E6D617267696E546F702C0A202020206C6566743A';
wwv_flow_api.g_varchar2_table(315) := '207363726F6C6C4C656674202D2072656C61746976654F66667365742E6C656674202B2072656C61746976654F66667365742E6D617267696E4C6566742C0A2020202077696474683A2077696474682C0A202020206865696768743A206865696768740A';
wwv_flow_api.g_varchar2_table(316) := '20207D3B0A0A202072657475726E20676574436C69656E7452656374286F6666736574293B0A7D0A0A2F2A2A0A202A20436865636B2069662074686520676976656E20656C656D656E74206973206669786564206F7220697320696E7369646520612066';
wwv_flow_api.g_varchar2_table(317) := '6978656420706172656E740A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040617267756D656E74207B456C656D656E747D20656C656D656E740A202A2040617267756D656E74207B456C656D656E';
wwv_flow_api.g_varchar2_table(318) := '747D20637573746F6D436F6E7461696E65720A202A204072657475726E73207B426F6F6C65616E7D20616E7377657220746F2022697346697865643F220A202A2F0A66756E6374696F6E206973466978656428656C656D656E7429207B0A202076617220';
wwv_flow_api.g_varchar2_table(319) := '6E6F64654E616D65203D20656C656D656E742E6E6F64654E616D653B0A2020696620286E6F64654E616D65203D3D3D2027424F445927207C7C206E6F64654E616D65203D3D3D202748544D4C2729207B0A2020202072657475726E2066616C73653B0A20';
wwv_flow_api.g_varchar2_table(320) := '207D0A2020696620286765745374796C65436F6D707574656450726F706572747928656C656D656E742C2027706F736974696F6E2729203D3D3D202766697865642729207B0A2020202072657475726E20747275653B0A20207D0A202072657475726E20';
wwv_flow_api.g_varchar2_table(321) := '6973466978656428676574506172656E744E6F646528656C656D656E7429293B0A7D0A0A2F2A2A0A202A2046696E64732074686520666972737420706172656E74206F6620616E20656C656D656E742074686174206861732061207472616E73666F726D';
wwv_flow_api.g_varchar2_table(322) := '65642070726F706572747920646566696E65640A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040617267756D656E74207B456C656D656E747D20656C656D656E740A202A204072657475726E7320';
wwv_flow_api.g_varchar2_table(323) := '7B456C656D656E747D206669727374207472616E73666F726D656420706172656E74206F7220646F63756D656E74456C656D656E740A202A2F0A0A66756E6374696F6E206765744669786564506F736974696F6E4F6666736574506172656E7428656C65';
wwv_flow_api.g_varchar2_table(324) := '6D656E7429207B0A20202F2F205468697320636865636B206973206E656564656420746F2061766F6964206572726F727320696E2063617365206F6E65206F662074686520656C656D656E74732069736E277420646566696E656420666F7220616E7920';
wwv_flow_api.g_varchar2_table(325) := '726561736F6E0A20206966202821656C656D656E74207C7C2021656C656D656E742E706172656E74456C656D656E74207C7C20697349452431282929207B0A2020202072657475726E20646F63756D656E742E646F63756D656E74456C656D656E743B0A';
wwv_flow_api.g_varchar2_table(326) := '20207D0A202076617220656C203D20656C656D656E742E706172656E74456C656D656E743B0A20207768696C652028656C202626206765745374796C65436F6D707574656450726F706572747928656C2C20277472616E73666F726D2729203D3D3D2027';
wwv_flow_api.g_varchar2_table(327) := '6E6F6E652729207B0A20202020656C203D20656C2E706172656E74456C656D656E743B0A20207D0A202072657475726E20656C207C7C20646F63756D656E742E646F63756D656E74456C656D656E743B0A7D0A0A2F2A2A0A202A20436F6D707574656420';
wwv_flow_api.g_varchar2_table(328) := '74686520626F756E646172696573206C696D69747320616E642072657475726E207468656D0A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040706172616D207B48544D4C456C656D656E747D2070';
wwv_flow_api.g_varchar2_table(329) := '6F707065720A202A2040706172616D207B48544D4C456C656D656E747D207265666572656E63650A202A2040706172616D207B6E756D6265727D2070616464696E670A202A2040706172616D207B48544D4C456C656D656E747D20626F756E6461726965';
wwv_flow_api.g_varchar2_table(330) := '73456C656D656E74202D20456C656D656E74207573656420746F20646566696E652074686520626F756E6461726965730A202A2040706172616D207B426F6F6C65616E7D206669786564506F736974696F6E202D20497320696E20666978656420706F73';
wwv_flow_api.g_varchar2_table(331) := '6974696F6E206D6F64650A202A204072657475726E73207B4F626A6563747D20436F6F7264696E61746573206F662074686520626F756E6461726965730A202A2F0A66756E6374696F6E20676574426F756E64617269657328706F707065722C20726566';
wwv_flow_api.g_varchar2_table(332) := '6572656E63652C2070616464696E672C20626F756E646172696573456C656D656E7429207B0A2020766172206669786564506F736974696F6E203D20617267756D656E74732E6C656E677468203E203420262620617267756D656E74735B345D20213D3D';
wwv_flow_api.g_varchar2_table(333) := '20756E646566696E6564203F20617267756D656E74735B345D203A2066616C73653B0A0A20202F2F204E4F54453A203120444F4D2061636365737320686572650A0A202076617220626F756E646172696573203D207B20746F703A20302C206C6566743A';
wwv_flow_api.g_varchar2_table(334) := '2030207D3B0A2020766172206F6666736574506172656E74203D206669786564506F736974696F6E203F206765744669786564506F736974696F6E4F6666736574506172656E7428706F7070657229203A2066696E64436F6D6D6F6E4F66667365745061';
wwv_flow_api.g_varchar2_table(335) := '72656E7428706F707065722C207265666572656E6365293B0A0A20202F2F2048616E646C652076696577706F727420636173650A202069662028626F756E646172696573456C656D656E74203D3D3D202776696577706F72742729207B0A20202020626F';
wwv_flow_api.g_varchar2_table(336) := '756E646172696573203D2067657456696577706F72744F66667365745265637452656C6174697665546F417274626974726172794E6F6465286F6666736574506172656E742C206669786564506F736974696F6E293B0A20207D20656C7365207B0A2020';
wwv_flow_api.g_varchar2_table(337) := '20202F2F2048616E646C65206F74686572206361736573206261736564206F6E20444F4D20656C656D656E74207573656420617320626F756E6461726965730A2020202076617220626F756E6461726965734E6F6465203D20766F696420303B0A202020';
wwv_flow_api.g_varchar2_table(338) := '2069662028626F756E646172696573456C656D656E74203D3D3D20277363726F6C6C506172656E742729207B0A202020202020626F756E6461726965734E6F6465203D206765745363726F6C6C506172656E7428676574506172656E744E6F6465287265';
wwv_flow_api.g_varchar2_table(339) := '666572656E636529293B0A20202020202069662028626F756E6461726965734E6F64652E6E6F64654E616D65203D3D3D2027424F44592729207B0A2020202020202020626F756E6461726965734E6F6465203D20706F707065722E6F776E6572446F6375';
wwv_flow_api.g_varchar2_table(340) := '6D656E742E646F63756D656E74456C656D656E743B0A2020202020207D0A202020207D20656C73652069662028626F756E646172696573456C656D656E74203D3D3D202777696E646F772729207B0A202020202020626F756E6461726965734E6F646520';
wwv_flow_api.g_varchar2_table(341) := '3D20706F707065722E6F776E6572446F63756D656E742E646F63756D656E74456C656D656E743B0A202020207D20656C7365207B0A202020202020626F756E6461726965734E6F6465203D20626F756E646172696573456C656D656E743B0A202020207D';
wwv_flow_api.g_varchar2_table(342) := '0A0A20202020766172206F666673657473203D206765744F66667365745265637452656C6174697665546F4172626974726172794E6F646528626F756E6461726965734E6F64652C206F6666736574506172656E742C206669786564506F736974696F6E';
wwv_flow_api.g_varchar2_table(343) := '293B0A0A202020202F2F20496E2063617365206F662048544D4C2C207765206E656564206120646966666572656E7420636F6D7075746174696F6E0A2020202069662028626F756E6461726965734E6F64652E6E6F64654E616D65203D3D3D202748544D';
wwv_flow_api.g_varchar2_table(344) := '4C27202626202169734669786564286F6666736574506172656E742929207B0A202020202020766172205F67657457696E646F7753697A6573203D2067657457696E646F7753697A657328706F707065722E6F776E6572446F63756D656E74292C0A2020';
wwv_flow_api.g_varchar2_table(345) := '2020202020202020686569676874203D205F67657457696E646F7753697A65732E6865696768742C0A202020202020202020207769647468203D205F67657457696E646F7753697A65732E77696474683B0A0A202020202020626F756E6461726965732E';
wwv_flow_api.g_varchar2_table(346) := '746F70202B3D206F6666736574732E746F70202D206F6666736574732E6D617267696E546F703B0A202020202020626F756E6461726965732E626F74746F6D203D20686569676874202B206F6666736574732E746F703B0A202020202020626F756E6461';
wwv_flow_api.g_varchar2_table(347) := '726965732E6C656674202B3D206F6666736574732E6C656674202D206F6666736574732E6D617267696E4C6566743B0A202020202020626F756E6461726965732E7269676874203D207769647468202B206F6666736574732E6C6566743B0A202020207D';
wwv_flow_api.g_varchar2_table(348) := '20656C7365207B0A2020202020202F2F20666F7220616C6C20746865206F7468657220444F4D20656C656D656E74732C2074686973206F6E6520697320676F6F640A202020202020626F756E646172696573203D206F6666736574733B0A202020207D0A';
wwv_flow_api.g_varchar2_table(349) := '20207D0A0A20202F2F204164642070616464696E67730A202070616464696E67203D2070616464696E67207C7C20303B0A202076617220697350616464696E674E756D626572203D20747970656F662070616464696E67203D3D3D20276E756D62657227';
wwv_flow_api.g_varchar2_table(350) := '3B0A2020626F756E6461726965732E6C656674202B3D20697350616464696E674E756D626572203F2070616464696E67203A2070616464696E672E6C656674207C7C20303B0A2020626F756E6461726965732E746F70202B3D20697350616464696E674E';
wwv_flow_api.g_varchar2_table(351) := '756D626572203F2070616464696E67203A2070616464696E672E746F70207C7C20303B0A2020626F756E6461726965732E7269676874202D3D20697350616464696E674E756D626572203F2070616464696E67203A2070616464696E672E726967687420';
wwv_flow_api.g_varchar2_table(352) := '7C7C20303B0A2020626F756E6461726965732E626F74746F6D202D3D20697350616464696E674E756D626572203F2070616464696E67203A2070616464696E672E626F74746F6D207C7C20303B0A0A202072657475726E20626F756E6461726965733B0A';
wwv_flow_api.g_varchar2_table(353) := '7D0A0A66756E6374696F6E2067657441726561285F72656629207B0A2020766172207769647468203D205F7265662E77696474682C0A202020202020686569676874203D205F7265662E6865696768743B0A0A202072657475726E207769647468202A20';
wwv_flow_api.g_varchar2_table(354) := '6865696768743B0A7D0A0A2F2A2A0A202A205574696C697479207573656420746F207472616E73666F726D2074686520606175746F6020706C6163656D656E7420746F2074686520706C6163656D656E742077697468206D6F72650A202A20617661696C';
wwv_flow_api.g_varchar2_table(355) := '61626C652073706163652E0A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040617267756D656E74207B4F626A6563747D2064617461202D205468652064617461206F626A6563742067656E657261';
wwv_flow_api.g_varchar2_table(356) := '74656420627920757064617465206D6574686F640A202A2040617267756D656E74207B4F626A6563747D206F7074696F6E73202D204D6F6469666965727320636F6E66696775726174696F6E20616E64206F7074696F6E730A202A204072657475726E73';
wwv_flow_api.g_varchar2_table(357) := '207B4F626A6563747D205468652064617461206F626A6563742C2070726F7065726C79206D6F6469666965640A202A2F0A66756E6374696F6E20636F6D707574654175746F506C6163656D656E7428706C6163656D656E742C20726566526563742C2070';
wwv_flow_api.g_varchar2_table(358) := '6F707065722C207265666572656E63652C20626F756E646172696573456C656D656E7429207B0A20207661722070616464696E67203D20617267756D656E74732E6C656E677468203E203520262620617267756D656E74735B355D20213D3D20756E6465';
wwv_flow_api.g_varchar2_table(359) := '66696E6564203F20617267756D656E74735B355D203A20303B0A0A202069662028706C6163656D656E742E696E6465784F6628276175746F2729203D3D3D202D3129207B0A2020202072657475726E20706C6163656D656E743B0A20207D0A0A20207661';
wwv_flow_api.g_varchar2_table(360) := '7220626F756E646172696573203D20676574426F756E64617269657328706F707065722C207265666572656E63652C2070616464696E672C20626F756E646172696573456C656D656E74293B0A0A2020766172207265637473203D207B0A20202020746F';
wwv_flow_api.g_varchar2_table(361) := '703A207B0A20202020202077696474683A20626F756E6461726965732E77696474682C0A2020202020206865696768743A20726566526563742E746F70202D20626F756E6461726965732E746F700A202020207D2C0A2020202072696768743A207B0A20';
wwv_flow_api.g_varchar2_table(362) := '202020202077696474683A20626F756E6461726965732E7269676874202D20726566526563742E72696768742C0A2020202020206865696768743A20626F756E6461726965732E6865696768740A202020207D2C0A20202020626F74746F6D3A207B0A20';
wwv_flow_api.g_varchar2_table(363) := '202020202077696474683A20626F756E6461726965732E77696474682C0A2020202020206865696768743A20626F756E6461726965732E626F74746F6D202D20726566526563742E626F74746F6D0A202020207D2C0A202020206C6566743A207B0A2020';
wwv_flow_api.g_varchar2_table(364) := '2020202077696474683A20726566526563742E6C656674202D20626F756E6461726965732E6C6566742C0A2020202020206865696768743A20626F756E6461726965732E6865696768740A202020207D0A20207D3B0A0A202076617220736F7274656441';
wwv_flow_api.g_varchar2_table(365) := '72656173203D204F626A6563742E6B657973287265637473292E6D61702866756E6374696F6E20286B657929207B0A2020202072657475726E205F657874656E6473287B0A2020202020206B65793A206B65790A202020207D2C2072656374735B6B6579';
wwv_flow_api.g_varchar2_table(366) := '5D2C207B0A202020202020617265613A20676574417265612872656374735B6B65795D290A202020207D293B0A20207D292E736F72742866756E6374696F6E2028612C206229207B0A2020202072657475726E20622E61726561202D20612E617265613B';
wwv_flow_api.g_varchar2_table(367) := '0A20207D293B0A0A20207661722066696C74657265644172656173203D20736F7274656441726561732E66696C7465722866756E6374696F6E20285F7265663229207B0A20202020766172207769647468203D205F726566322E77696474682C0A202020';
wwv_flow_api.g_varchar2_table(368) := '2020202020686569676874203D205F726566322E6865696768743B0A2020202072657475726E207769647468203E3D20706F707065722E636C69656E74576964746820262620686569676874203E3D20706F707065722E636C69656E744865696768743B';
wwv_flow_api.g_varchar2_table(369) := '0A20207D293B0A0A202076617220636F6D7075746564506C6163656D656E74203D2066696C746572656441726561732E6C656E677468203E2030203F2066696C746572656441726561735B305D2E6B6579203A20736F7274656441726561735B305D2E6B';
wwv_flow_api.g_varchar2_table(370) := '65793B0A0A202076617220766172696174696F6E203D20706C6163656D656E742E73706C697428272D27295B315D3B0A0A202072657475726E20636F6D7075746564506C6163656D656E74202B2028766172696174696F6E203F20272D27202B20766172';
wwv_flow_api.g_varchar2_table(371) := '696174696F6E203A202727293B0A7D0A0A2F2A2A0A202A20476574206F66667365747320746F20746865207265666572656E636520656C656D656E740A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A';
wwv_flow_api.g_varchar2_table(372) := '2040706172616D207B4F626A6563747D2073746174650A202A2040706172616D207B456C656D656E747D20706F70706572202D2074686520706F7070657220656C656D656E740A202A2040706172616D207B456C656D656E747D207265666572656E6365';
wwv_flow_api.g_varchar2_table(373) := '202D20746865207265666572656E636520656C656D656E74202874686520706F707065722077696C6C2062652072656C617469766520746F2074686973290A202A2040706172616D207B456C656D656E747D206669786564506F736974696F6E202D2069';
wwv_flow_api.g_varchar2_table(374) := '7320696E20666978656420706F736974696F6E206D6F64650A202A204072657475726E73207B4F626A6563747D20416E206F626A65637420636F6E7461696E696E6720746865206F6666736574732077686963682077696C6C206265206170706C696564';
wwv_flow_api.g_varchar2_table(375) := '20746F2074686520706F707065720A202A2F0A66756E6374696F6E206765745265666572656E63654F6666736574732873746174652C20706F707065722C207265666572656E636529207B0A2020766172206669786564506F736974696F6E203D206172';
wwv_flow_api.g_varchar2_table(376) := '67756D656E74732E6C656E677468203E203320262620617267756D656E74735B335D20213D3D20756E646566696E6564203F20617267756D656E74735B335D203A206E756C6C3B0A0A202076617220636F6D6D6F6E4F6666736574506172656E74203D20';
wwv_flow_api.g_varchar2_table(377) := '6669786564506F736974696F6E203F206765744669786564506F736974696F6E4F6666736574506172656E7428706F7070657229203A2066696E64436F6D6D6F6E4F6666736574506172656E7428706F707065722C207265666572656E6365293B0A2020';
wwv_flow_api.g_varchar2_table(378) := '72657475726E206765744F66667365745265637452656C6174697665546F4172626974726172794E6F6465287265666572656E63652C20636F6D6D6F6E4F6666736574506172656E742C206669786564506F736974696F6E293B0A7D0A0A2F2A2A0A202A';
wwv_flow_api.g_varchar2_table(379) := '2047657420746865206F757465722073697A6573206F662074686520676976656E20656C656D656E7420286F66667365742073697A65202B206D617267696E73290A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E557469';
wwv_flow_api.g_varchar2_table(380) := '6C730A202A2040617267756D656E74207B456C656D656E747D20656C656D656E740A202A204072657475726E73207B4F626A6563747D206F626A65637420636F6E7461696E696E6720776964746820616E64206865696768742070726F70657274696573';
wwv_flow_api.g_varchar2_table(381) := '0A202A2F0A66756E6374696F6E206765744F7574657253697A657328656C656D656E7429207B0A20207661722077696E646F77203D20656C656D656E742E6F776E6572446F63756D656E742E64656661756C74566965773B0A2020766172207374796C65';
wwv_flow_api.g_varchar2_table(382) := '73203D2077696E646F772E676574436F6D70757465645374796C6528656C656D656E74293B0A20207661722078203D207061727365466C6F6174287374796C65732E6D617267696E546F70207C7C203029202B207061727365466C6F6174287374796C65';
wwv_flow_api.g_varchar2_table(383) := '732E6D617267696E426F74746F6D207C7C2030293B0A20207661722079203D207061727365466C6F6174287374796C65732E6D617267696E4C656674207C7C203029202B207061727365466C6F6174287374796C65732E6D617267696E5269676874207C';
wwv_flow_api.g_varchar2_table(384) := '7C2030293B0A202076617220726573756C74203D207B0A2020202077696474683A20656C656D656E742E6F66667365745769647468202B20792C0A202020206865696768743A20656C656D656E742E6F6666736574486569676874202B20780A20207D3B';
wwv_flow_api.g_varchar2_table(385) := '0A202072657475726E20726573756C743B0A7D0A0A2F2A2A0A202A2047657420746865206F70706F7369746520706C6163656D656E74206F662074686520676976656E206F6E650A202A20406D6574686F640A202A20406D656D6265726F6620506F7070';
wwv_flow_api.g_varchar2_table(386) := '65722E5574696C730A202A2040617267756D656E74207B537472696E677D20706C6163656D656E740A202A204072657475726E73207B537472696E677D20666C697070656420706C6163656D656E740A202A2F0A66756E6374696F6E206765744F70706F';
wwv_flow_api.g_varchar2_table(387) := '73697465506C6163656D656E7428706C6163656D656E7429207B0A20207661722068617368203D207B206C6566743A20277269676874272C2072696768743A20276C656674272C20626F74746F6D3A2027746F70272C20746F703A2027626F74746F6D27';
wwv_flow_api.g_varchar2_table(388) := '207D3B0A202072657475726E20706C6163656D656E742E7265706C616365282F6C6566747C72696768747C626F74746F6D7C746F702F672C2066756E6374696F6E20286D61746368656429207B0A2020202072657475726E20686173685B6D6174636865';
wwv_flow_api.g_varchar2_table(389) := '645D3B0A20207D293B0A7D0A0A2F2A2A0A202A20476574206F66667365747320746F2074686520706F707065720A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040706172616D207B4F626A656374';
wwv_flow_api.g_varchar2_table(390) := '7D20706F736974696F6E202D2043535320706F736974696F6E2074686520506F707065722077696C6C20676574206170706C6965640A202A2040706172616D207B48544D4C456C656D656E747D20706F70706572202D2074686520706F7070657220656C';
wwv_flow_api.g_varchar2_table(391) := '656D656E740A202A2040706172616D207B4F626A6563747D207265666572656E63654F666673657473202D20746865207265666572656E6365206F666673657473202874686520706F707065722077696C6C2062652072656C617469766520746F207468';
wwv_flow_api.g_varchar2_table(392) := '6973290A202A2040706172616D207B537472696E677D20706C6163656D656E74202D206F6E65206F66207468652076616C696420706C6163656D656E74206F7074696F6E730A202A204072657475726E73207B4F626A6563747D20706F707065724F6666';
wwv_flow_api.g_varchar2_table(393) := '73657473202D20416E206F626A65637420636F6E7461696E696E6720746865206F6666736574732077686963682077696C6C206265206170706C69656420746F2074686520706F707065720A202A2F0A66756E6374696F6E20676574506F707065724F66';
wwv_flow_api.g_varchar2_table(394) := '667365747328706F707065722C207265666572656E63654F6666736574732C20706C6163656D656E7429207B0A2020706C6163656D656E74203D20706C6163656D656E742E73706C697428272D27295B305D3B0A0A20202F2F2047657420706F70706572';
wwv_flow_api.g_varchar2_table(395) := '206E6F64652073697A65730A202076617220706F7070657252656374203D206765744F7574657253697A657328706F70706572293B0A0A20202F2F2041646420706F736974696F6E2C20776964746820616E642068656967687420746F206F7572206F66';
wwv_flow_api.g_varchar2_table(396) := '6673657473206F626A6563740A202076617220706F707065724F666673657473203D207B0A2020202077696474683A20706F70706572526563742E77696474682C0A202020206865696768743A20706F70706572526563742E6865696768740A20207D3B';
wwv_flow_api.g_varchar2_table(397) := '0A0A20202F2F20646570656E64696E672062792074686520706F7070657220706C6163656D656E74207765206861766520746F20636F6D7075746520697473206F66667365747320736C696768746C7920646966666572656E746C790A20207661722069';
wwv_flow_api.g_varchar2_table(398) := '73486F72697A203D205B277269676874272C20276C656674275D2E696E6465784F6628706C6163656D656E742920213D3D202D313B0A2020766172206D61696E53696465203D206973486F72697A203F2027746F7027203A20276C656674273B0A202076';
wwv_flow_api.g_varchar2_table(399) := '6172207365636F6E6461727953696465203D206973486F72697A203F20276C65667427203A2027746F70273B0A2020766172206D6561737572656D656E74203D206973486F72697A203F202768656967687427203A20277769647468273B0A2020766172';
wwv_flow_api.g_varchar2_table(400) := '207365636F6E646172794D6561737572656D656E74203D20216973486F72697A203F202768656967687427203A20277769647468273B0A0A2020706F707065724F6666736574735B6D61696E536964655D203D207265666572656E63654F666673657473';
wwv_flow_api.g_varchar2_table(401) := '5B6D61696E536964655D202B207265666572656E63654F6666736574735B6D6561737572656D656E745D202F2032202D20706F70706572526563745B6D6561737572656D656E745D202F20323B0A202069662028706C6163656D656E74203D3D3D207365';
wwv_flow_api.g_varchar2_table(402) := '636F6E646172795369646529207B0A20202020706F707065724F6666736574735B7365636F6E64617279536964655D203D207265666572656E63654F6666736574735B7365636F6E64617279536964655D202D20706F70706572526563745B7365636F6E';
wwv_flow_api.g_varchar2_table(403) := '646172794D6561737572656D656E745D3B0A20207D20656C7365207B0A20202020706F707065724F6666736574735B7365636F6E64617279536964655D203D207265666572656E63654F6666736574735B6765744F70706F73697465506C6163656D656E';
wwv_flow_api.g_varchar2_table(404) := '74287365636F6E6461727953696465295D3B0A20207D0A0A202072657475726E20706F707065724F6666736574733B0A7D0A0A2F2A2A0A202A204D696D69637320746865206066696E6460206D6574686F64206F662041727261790A202A20406D657468';
wwv_flow_api.g_varchar2_table(405) := '6F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040617267756D656E74207B41727261797D206172720A202A2040617267756D656E742070726F700A202A2040617267756D656E742076616C75650A202A20407265747572';
wwv_flow_api.g_varchar2_table(406) := '6E7320696E646578206F72202D310A202A2F0A66756E6374696F6E2066696E64286172722C20636865636B29207B0A20202F2F20757365206E61746976652066696E6420696620737570706F727465640A20206966202841727261792E70726F746F7479';
wwv_flow_api.g_varchar2_table(407) := '70652E66696E6429207B0A2020202072657475726E206172722E66696E6428636865636B293B0A20207D0A0A20202F2F20757365206066696C7465726020746F206F627461696E207468652073616D65206265686176696F72206F66206066696E64600A';
wwv_flow_api.g_varchar2_table(408) := '202072657475726E206172722E66696C74657228636865636B295B305D3B0A7D0A0A2F2A2A0A202A2052657475726E2074686520696E646578206F6620746865206D61746368696E67206F626A6563740A202A20406D6574686F640A202A20406D656D62';
wwv_flow_api.g_varchar2_table(409) := '65726F6620506F707065722E5574696C730A202A2040617267756D656E74207B41727261797D206172720A202A2040617267756D656E742070726F700A202A2040617267756D656E742076616C75650A202A204072657475726E7320696E646578206F72';
wwv_flow_api.g_varchar2_table(410) := '202D310A202A2F0A66756E6374696F6E2066696E64496E646578286172722C2070726F702C2076616C756529207B0A20202F2F20757365206E61746976652066696E64496E64657820696620737570706F727465640A20206966202841727261792E7072';
wwv_flow_api.g_varchar2_table(411) := '6F746F747970652E66696E64496E64657829207B0A2020202072657475726E206172722E66696E64496E6465782866756E6374696F6E202863757229207B0A20202020202072657475726E206375725B70726F705D203D3D3D2076616C75653B0A202020';
wwv_flow_api.g_varchar2_table(412) := '207D293B0A20207D0A0A20202F2F20757365206066696E6460202B2060696E6465784F6660206966206066696E64496E646578602069736E277420737570706F727465640A2020766172206D61746368203D2066696E64286172722C2066756E6374696F';
wwv_flow_api.g_varchar2_table(413) := '6E20286F626A29207B0A2020202072657475726E206F626A5B70726F705D203D3D3D2076616C75653B0A20207D293B0A202072657475726E206172722E696E6465784F66286D61746368293B0A7D0A0A2F2A2A0A202A204C6F6F702074726F7567682074';
wwv_flow_api.g_varchar2_table(414) := '6865206C697374206F66206D6F6469666965727320616E642072756E207468656D20696E206F726465722C0A202A2065616368206F66207468656D2077696C6C207468656E2065646974207468652064617461206F626A6563742E0A202A20406D657468';
wwv_flow_api.g_varchar2_table(415) := '6F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040706172616D207B646174614F626A6563747D20646174610A202A2040706172616D207B41727261797D206D6F646966696572730A202A2040706172616D207B53747269';
wwv_flow_api.g_varchar2_table(416) := '6E677D20656E6473202D204F7074696F6E616C206D6F646966696572206E616D6520757365642061732073746F707065720A202A204072657475726E73207B646174614F626A6563747D0A202A2F0A66756E6374696F6E2072756E4D6F64696669657273';
wwv_flow_api.g_varchar2_table(417) := '286D6F646966696572732C20646174612C20656E647329207B0A2020766172206D6F64696669657273546F52756E203D20656E6473203D3D3D20756E646566696E6564203F206D6F64696669657273203A206D6F646966696572732E736C69636528302C';
wwv_flow_api.g_varchar2_table(418) := '2066696E64496E646578286D6F646966696572732C20276E616D65272C20656E647329293B0A0A20206D6F64696669657273546F52756E2E666F72456163682866756E6374696F6E20286D6F64696669657229207B0A20202020696620286D6F64696669';
wwv_flow_api.g_varchar2_table(419) := '65725B2766756E6374696F6E275D29207B0A2020202020202F2F2065736C696E742D64697361626C652D6C696E6520646F742D6E6F746174696F6E0A202020202020636F6E736F6C652E7761726E2827606D6F6469666965722E66756E6374696F6E6020';
wwv_flow_api.g_varchar2_table(420) := '697320646570726563617465642C2075736520606D6F6469666965722E666E602127293B0A202020207D0A2020202076617220666E203D206D6F6469666965725B2766756E6374696F6E275D207C7C206D6F6469666965722E666E3B202F2F2065736C69';
wwv_flow_api.g_varchar2_table(421) := '6E742D64697361626C652D6C696E6520646F742D6E6F746174696F6E0A20202020696620286D6F6469666965722E656E61626C656420262620697346756E6374696F6E28666E2929207B0A2020202020202F2F204164642070726F706572746965732074';
wwv_flow_api.g_varchar2_table(422) := '6F206F66667365747320746F206D616B65207468656D206120636F6D706C65746520636C69656E7452656374206F626A6563740A2020202020202F2F20776520646F2074686973206265666F72652065616368206D6F64696669657220746F206D616B65';
wwv_flow_api.g_varchar2_table(423) := '2073757265207468652070726576696F7573206F6E6520646F65736E27740A2020202020202F2F206D65737320776974682074686573652076616C7565730A202020202020646174612E6F6666736574732E706F70706572203D20676574436C69656E74';
wwv_flow_api.g_varchar2_table(424) := '5265637428646174612E6F6666736574732E706F70706572293B0A202020202020646174612E6F6666736574732E7265666572656E6365203D20676574436C69656E745265637428646174612E6F6666736574732E7265666572656E6365293B0A0A2020';
wwv_flow_api.g_varchar2_table(425) := '2020202064617461203D20666E28646174612C206D6F646966696572293B0A202020207D0A20207D293B0A0A202072657475726E20646174613B0A7D0A0A2F2A2A0A202A20557064617465732074686520706F736974696F6E206F662074686520706F70';
wwv_flow_api.g_varchar2_table(426) := '7065722C20636F6D707574696E6720746865206E6577206F66667365747320616E64206170706C79696E670A202A20746865206E6577207374796C652E3C6272202F3E0A202A2050726566657220607363686564756C6555706461746560206F76657220';
wwv_flow_api.g_varchar2_table(427) := '60757064617465602062656361757365206F6620706572666F726D616E636520726561736F6E732E0A202A20406D6574686F640A202A20406D656D6265726F6620506F707065720A202A2F0A66756E6374696F6E207570646174652829207B0A20202F2F';
wwv_flow_api.g_varchar2_table(428) := '20696620706F707065722069732064657374726F7965642C20646F6E277420706572666F726D20616E792066757274686572207570646174650A202069662028746869732E73746174652E697344657374726F79656429207B0A2020202072657475726E';
wwv_flow_api.g_varchar2_table(429) := '3B0A20207D0A0A20207661722064617461203D207B0A20202020696E7374616E63653A20746869732C0A202020207374796C65733A207B7D2C0A202020206172726F775374796C65733A207B7D2C0A20202020617474726962757465733A207B7D2C0A20';
wwv_flow_api.g_varchar2_table(430) := '202020666C69707065643A2066616C73652C0A202020206F6666736574733A207B7D0A20207D3B0A0A20202F2F20636F6D70757465207265666572656E636520656C656D656E74206F6666736574730A2020646174612E6F6666736574732E7265666572';
wwv_flow_api.g_varchar2_table(431) := '656E6365203D206765745265666572656E63654F66667365747328746869732E73746174652C20746869732E706F707065722C20746869732E7265666572656E63652C20746869732E6F7074696F6E732E706F736974696F6E4669786564293B0A0A2020';
wwv_flow_api.g_varchar2_table(432) := '2F2F20636F6D70757465206175746F20706C6163656D656E742C2073746F726520706C6163656D656E7420696E73696465207468652064617461206F626A6563742C0A20202F2F206D6F646966696572732077696C6C2062652061626C6520746F206564';
wwv_flow_api.g_varchar2_table(433) := '69742060706C6163656D656E7460206966206E65656465640A20202F2F20616E6420726566657220746F206F726967696E616C506C6163656D656E7420746F206B6E6F7720746865206F726967696E616C2076616C75650A2020646174612E706C616365';
wwv_flow_api.g_varchar2_table(434) := '6D656E74203D20636F6D707574654175746F506C6163656D656E7428746869732E6F7074696F6E732E706C6163656D656E742C20646174612E6F6666736574732E7265666572656E63652C20746869732E706F707065722C20746869732E726566657265';
wwv_flow_api.g_varchar2_table(435) := '6E63652C20746869732E6F7074696F6E732E6D6F646966696572732E666C69702E626F756E646172696573456C656D656E742C20746869732E6F7074696F6E732E6D6F646966696572732E666C69702E70616464696E67293B0A0A20202F2F2073746F72';
wwv_flow_api.g_varchar2_table(436) := '652074686520636F6D707574656420706C6163656D656E7420696E7369646520606F726967696E616C506C6163656D656E74600A2020646174612E6F726967696E616C506C6163656D656E74203D20646174612E706C6163656D656E743B0A0A20206461';
wwv_flow_api.g_varchar2_table(437) := '74612E706F736974696F6E4669786564203D20746869732E6F7074696F6E732E706F736974696F6E46697865643B0A0A20202F2F20636F6D707574652074686520706F70706572206F6666736574730A2020646174612E6F6666736574732E706F707065';
wwv_flow_api.g_varchar2_table(438) := '72203D20676574506F707065724F66667365747328746869732E706F707065722C20646174612E6F6666736574732E7265666572656E63652C20646174612E706C6163656D656E74293B0A0A2020646174612E6F6666736574732E706F707065722E706F';
wwv_flow_api.g_varchar2_table(439) := '736974696F6E203D20746869732E6F7074696F6E732E706F736974696F6E4669786564203F2027666978656427203A20276162736F6C757465273B0A0A20202F2F2072756E20746865206D6F646966696572730A202064617461203D2072756E4D6F6469';
wwv_flow_api.g_varchar2_table(440) := '666965727328746869732E6D6F646966696572732C2064617461293B0A0A20202F2F207468652066697273742060757064617465602077696C6C2063616C6C20606F6E437265617465602063616C6C6261636B0A20202F2F20746865206F74686572206F';
wwv_flow_api.g_varchar2_table(441) := '6E65732077696C6C2063616C6C20606F6E557064617465602063616C6C6261636B0A20206966202821746869732E73746174652E69734372656174656429207B0A20202020746869732E73746174652E697343726561746564203D20747275653B0A2020';
wwv_flow_api.g_varchar2_table(442) := '2020746869732E6F7074696F6E732E6F6E4372656174652864617461293B0A20207D20656C7365207B0A20202020746869732E6F7074696F6E732E6F6E5570646174652864617461293B0A20207D0A7D0A0A2F2A2A0A202A2048656C7065722075736564';
wwv_flow_api.g_varchar2_table(443) := '20746F206B6E6F772069662074686520676976656E206D6F64696669657220697320656E61626C65642E0A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A204072657475726E73207B426F6F6C65616E';
wwv_flow_api.g_varchar2_table(444) := '7D0A202A2F0A66756E6374696F6E2069734D6F646966696572456E61626C6564286D6F646966696572732C206D6F6469666965724E616D6529207B0A202072657475726E206D6F646966696572732E736F6D652866756E6374696F6E20285F7265662920';
wwv_flow_api.g_varchar2_table(445) := '7B0A20202020766172206E616D65203D205F7265662E6E616D652C0A2020202020202020656E61626C6564203D205F7265662E656E61626C65643B0A2020202072657475726E20656E61626C6564202626206E616D65203D3D3D206D6F6469666965724E';
wwv_flow_api.g_varchar2_table(446) := '616D653B0A20207D293B0A7D0A0A2F2A2A0A202A204765742074686520707265666978656420737570706F727465642070726F7065727479206E616D650A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A20';
wwv_flow_api.g_varchar2_table(447) := '2A2040617267756D656E74207B537472696E677D2070726F7065727479202863616D656C43617365290A202A204072657475726E73207B537472696E677D2070726566697865642070726F7065727479202863616D656C43617365206F72205061736361';
wwv_flow_api.g_varchar2_table(448) := '6C436173652C20646570656E64696E67206F6E207468652076656E646F7220707265666978290A202A2F0A66756E6374696F6E20676574537570706F7274656450726F70657274794E616D652870726F706572747929207B0A2020766172207072656669';
wwv_flow_api.g_varchar2_table(449) := '786573203D205B66616C73652C20276D73272C20275765626B6974272C20274D6F7A272C20274F275D3B0A202076617220757070657250726F70203D2070726F70657274792E6368617241742830292E746F5570706572436173652829202B2070726F70';
wwv_flow_api.g_varchar2_table(450) := '657274792E736C6963652831293B0A0A2020666F7220287661722069203D20303B2069203C2070726566697865732E6C656E6774683B20692B2B29207B0A2020202076617220707265666978203D2070726566697865735B695D3B0A2020202076617220';
wwv_flow_api.g_varchar2_table(451) := '746F436865636B203D20707265666978203F202727202B20707265666978202B20757070657250726F70203A2070726F70657274793B0A2020202069662028747970656F6620646F63756D656E742E626F64792E7374796C655B746F436865636B5D2021';
wwv_flow_api.g_varchar2_table(452) := '3D3D2027756E646566696E65642729207B0A20202020202072657475726E20746F436865636B3B0A202020207D0A20207D0A202072657475726E206E756C6C3B0A7D0A0A2F2A2A0A202A2044657374726F79732074686520706F707065722E0A202A2040';
wwv_flow_api.g_varchar2_table(453) := '6D6574686F640A202A20406D656D6265726F6620506F707065720A202A2F0A66756E6374696F6E2064657374726F792829207B0A2020746869732E73746174652E697344657374726F796564203D20747275653B0A0A20202F2F20746F75636820444F4D';
wwv_flow_api.g_varchar2_table(454) := '206F6E6C7920696620606170706C795374796C6560206D6F64696669657220697320656E61626C65640A20206966202869734D6F646966696572456E61626C656428746869732E6D6F646966696572732C20276170706C795374796C65272929207B0A20';
wwv_flow_api.g_varchar2_table(455) := '202020746869732E706F707065722E72656D6F76654174747269627574652827782D706C6163656D656E7427293B0A20202020746869732E706F707065722E7374796C652E706F736974696F6E203D2027273B0A20202020746869732E706F707065722E';
wwv_flow_api.g_varchar2_table(456) := '7374796C652E746F70203D2027273B0A20202020746869732E706F707065722E7374796C652E6C656674203D2027273B0A20202020746869732E706F707065722E7374796C652E7269676874203D2027273B0A20202020746869732E706F707065722E73';
wwv_flow_api.g_varchar2_table(457) := '74796C652E626F74746F6D203D2027273B0A20202020746869732E706F707065722E7374796C652E77696C6C4368616E6765203D2027273B0A20202020746869732E706F707065722E7374796C655B676574537570706F7274656450726F70657274794E';
wwv_flow_api.g_varchar2_table(458) := '616D6528277472616E73666F726D27295D203D2027273B0A20207D0A0A2020746869732E64697361626C654576656E744C697374656E65727328293B0A0A20202F2F2072656D6F76652074686520706F707065722069662075736572206578706C696369';
wwv_flow_api.g_varchar2_table(459) := '74792061736B656420666F72207468652064656C6574696F6E206F6E2064657374726F790A20202F2F20646F206E6F7420757365206072656D6F7665602062656361757365204945313120646F65736E277420737570706F72742069740A202069662028';
wwv_flow_api.g_varchar2_table(460) := '746869732E6F7074696F6E732E72656D6F76654F6E44657374726F7929207B0A20202020746869732E706F707065722E706172656E744E6F64652E72656D6F76654368696C6428746869732E706F70706572293B0A20207D0A202072657475726E207468';
wwv_flow_api.g_varchar2_table(461) := '69733B0A7D0A0A2F2A2A0A202A20476574207468652077696E646F77206173736F63696174656420776974682074686520656C656D656E740A202A2040617267756D656E74207B456C656D656E747D20656C656D656E740A202A204072657475726E7320';
wwv_flow_api.g_varchar2_table(462) := '7B57696E646F777D0A202A2F0A66756E6374696F6E2067657457696E646F7728656C656D656E7429207B0A2020766172206F776E6572446F63756D656E74203D20656C656D656E742E6F776E6572446F63756D656E743B0A202072657475726E206F776E';
wwv_flow_api.g_varchar2_table(463) := '6572446F63756D656E74203F206F776E6572446F63756D656E742E64656661756C7456696577203A2077696E646F773B0A7D0A0A66756E6374696F6E20617474616368546F5363726F6C6C506172656E7473287363726F6C6C506172656E742C20657665';
wwv_flow_api.g_varchar2_table(464) := '6E742C2063616C6C6261636B2C207363726F6C6C506172656E747329207B0A2020766172206973426F6479203D207363726F6C6C506172656E742E6E6F64654E616D65203D3D3D2027424F4459273B0A202076617220746172676574203D206973426F64';
wwv_flow_api.g_varchar2_table(465) := '79203F207363726F6C6C506172656E742E6F776E6572446F63756D656E742E64656661756C7456696577203A207363726F6C6C506172656E743B0A20207461726765742E6164644576656E744C697374656E6572286576656E742C2063616C6C6261636B';
wwv_flow_api.g_varchar2_table(466) := '2C207B20706173736976653A2074727565207D293B0A0A202069662028216973426F647929207B0A20202020617474616368546F5363726F6C6C506172656E7473286765745363726F6C6C506172656E74287461726765742E706172656E744E6F646529';
wwv_flow_api.g_varchar2_table(467) := '2C206576656E742C2063616C6C6261636B2C207363726F6C6C506172656E7473293B0A20207D0A20207363726F6C6C506172656E74732E7075736828746172676574293B0A7D0A0A2F2A2A0A202A205365747570206E6565646564206576656E74206C69';
wwv_flow_api.g_varchar2_table(468) := '7374656E657273207573656420746F207570646174652074686520706F7070657220706F736974696F6E0A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040707269766174650A202A2F0A66756E63';
wwv_flow_api.g_varchar2_table(469) := '74696F6E2073657475704576656E744C697374656E657273287265666572656E63652C206F7074696F6E732C2073746174652C20757064617465426F756E6429207B0A20202F2F20526573697A65206576656E74206C697374656E6572206F6E2077696E';
wwv_flow_api.g_varchar2_table(470) := '646F770A202073746174652E757064617465426F756E64203D20757064617465426F756E643B0A202067657457696E646F77287265666572656E6365292E6164644576656E744C697374656E65722827726573697A65272C2073746174652E7570646174';
wwv_flow_api.g_varchar2_table(471) := '65426F756E642C207B20706173736976653A2074727565207D293B0A0A20202F2F205363726F6C6C206576656E74206C697374656E6572206F6E207363726F6C6C20706172656E74730A2020766172207363726F6C6C456C656D656E74203D2067657453';
wwv_flow_api.g_varchar2_table(472) := '63726F6C6C506172656E74287265666572656E6365293B0A2020617474616368546F5363726F6C6C506172656E7473287363726F6C6C456C656D656E742C20277363726F6C6C272C2073746174652E757064617465426F756E642C2073746174652E7363';
wwv_flow_api.g_varchar2_table(473) := '726F6C6C506172656E7473293B0A202073746174652E7363726F6C6C456C656D656E74203D207363726F6C6C456C656D656E743B0A202073746174652E6576656E7473456E61626C6564203D20747275653B0A0A202072657475726E2073746174653B0A';
wwv_flow_api.g_varchar2_table(474) := '7D0A0A2F2A2A0A202A2049742077696C6C2061646420726573697A652F7363726F6C6C206576656E747320616E6420737461727420726563616C63756C6174696E670A202A20706F736974696F6E206F662074686520706F7070657220656C656D656E74';
wwv_flow_api.g_varchar2_table(475) := '207768656E207468657920617265207472696767657265642E0A202A20406D6574686F640A202A20406D656D6265726F6620506F707065720A202A2F0A66756E6374696F6E20656E61626C654576656E744C697374656E6572732829207B0A2020696620';
wwv_flow_api.g_varchar2_table(476) := '2821746869732E73746174652E6576656E7473456E61626C656429207B0A20202020746869732E7374617465203D2073657475704576656E744C697374656E65727328746869732E7265666572656E63652C20746869732E6F7074696F6E732C20746869';
wwv_flow_api.g_varchar2_table(477) := '732E73746174652C20746869732E7363686564756C65557064617465293B0A20207D0A7D0A0A2F2A2A0A202A2052656D6F7665206576656E74206C697374656E657273207573656420746F207570646174652074686520706F7070657220706F73697469';
wwv_flow_api.g_varchar2_table(478) := '6F6E0A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040707269766174650A202A2F0A66756E6374696F6E2072656D6F76654576656E744C697374656E657273287265666572656E63652C20737461';
wwv_flow_api.g_varchar2_table(479) := '746529207B0A20202F2F2052656D6F766520726573697A65206576656E74206C697374656E6572206F6E2077696E646F770A202067657457696E646F77287265666572656E6365292E72656D6F76654576656E744C697374656E65722827726573697A65';
wwv_flow_api.g_varchar2_table(480) := '272C2073746174652E757064617465426F756E64293B0A0A20202F2F2052656D6F7665207363726F6C6C206576656E74206C697374656E6572206F6E207363726F6C6C20706172656E74730A202073746174652E7363726F6C6C506172656E74732E666F';
wwv_flow_api.g_varchar2_table(481) := '72456163682866756E6374696F6E202874617267657429207B0A202020207461726765742E72656D6F76654576656E744C697374656E657228277363726F6C6C272C2073746174652E757064617465426F756E64293B0A20207D293B0A0A20202F2F2052';
wwv_flow_api.g_varchar2_table(482) := '657365742073746174650A202073746174652E757064617465426F756E64203D206E756C6C3B0A202073746174652E7363726F6C6C506172656E7473203D205B5D3B0A202073746174652E7363726F6C6C456C656D656E74203D206E756C6C3B0A202073';
wwv_flow_api.g_varchar2_table(483) := '746174652E6576656E7473456E61626C6564203D2066616C73653B0A202072657475726E2073746174653B0A7D0A0A2F2A2A0A202A2049742077696C6C2072656D6F766520726573697A652F7363726F6C6C206576656E747320616E6420776F6E277420';
wwv_flow_api.g_varchar2_table(484) := '726563616C63756C61746520706F7070657220706F736974696F6E0A202A207768656E207468657920617265207472696767657265642E20497420616C736F20776F6E2774207472696767657220606F6E557064617465602063616C6C6261636B20616E';
wwv_flow_api.g_varchar2_table(485) := '796D6F72652C0A202A20756E6C65737320796F752063616C6C206075706461746560206D6574686F64206D616E75616C6C792E0A202A20406D6574686F640A202A20406D656D6265726F6620506F707065720A202A2F0A66756E6374696F6E2064697361';
wwv_flow_api.g_varchar2_table(486) := '626C654576656E744C697374656E6572732829207B0A202069662028746869732E73746174652E6576656E7473456E61626C656429207B0A2020202063616E63656C416E696D6174696F6E4672616D6528746869732E7363686564756C65557064617465';
wwv_flow_api.g_varchar2_table(487) := '293B0A20202020746869732E7374617465203D2072656D6F76654576656E744C697374656E65727328746869732E7265666572656E63652C20746869732E7374617465293B0A20207D0A7D0A0A2F2A2A0A202A2054656C6C73206966206120676976656E';
wwv_flow_api.g_varchar2_table(488) := '20696E7075742069732061206E756D6265720A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040706172616D207B2A7D20696E70757420746F20636865636B0A202A204072657475726E207B426F6F';
wwv_flow_api.g_varchar2_table(489) := '6C65616E7D0A202A2F0A66756E6374696F6E2069734E756D65726963286E29207B0A202072657475726E206E20213D3D202727202626202169734E614E287061727365466C6F6174286E292920262620697346696E697465286E293B0A7D0A0A2F2A2A0A';
wwv_flow_api.g_varchar2_table(490) := '202A2053657420746865207374796C6520746F2074686520676976656E20706F707065720A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040617267756D656E74207B456C656D656E747D20656C65';
wwv_flow_api.g_varchar2_table(491) := '6D656E74202D20456C656D656E7420746F206170706C7920746865207374796C6520746F0A202A2040617267756D656E74207B4F626A6563747D207374796C65730A202A204F626A65637420776974682061206C697374206F662070726F706572746965';
wwv_flow_api.g_varchar2_table(492) := '7320616E642076616C7565732077686963682077696C6C206265206170706C69656420746F2074686520656C656D656E740A202A2F0A66756E6374696F6E207365745374796C657328656C656D656E742C207374796C657329207B0A20204F626A656374';
wwv_flow_api.g_varchar2_table(493) := '2E6B657973287374796C6573292E666F72456163682866756E6374696F6E202870726F7029207B0A2020202076617220756E6974203D2027273B0A202020202F2F2061646420756E6974206966207468652076616C7565206973206E756D657269632061';
wwv_flow_api.g_varchar2_table(494) := '6E64206973206F6E65206F662074686520666F6C6C6F77696E670A20202020696620285B277769647468272C2027686569676874272C2027746F70272C20277269676874272C2027626F74746F6D272C20276C656674275D2E696E6465784F662870726F';
wwv_flow_api.g_varchar2_table(495) := '702920213D3D202D312026262069734E756D65726963287374796C65735B70726F705D2929207B0A202020202020756E6974203D20277078273B0A202020207D0A20202020656C656D656E742E7374796C655B70726F705D203D207374796C65735B7072';
wwv_flow_api.g_varchar2_table(496) := '6F705D202B20756E69743B0A20207D293B0A7D0A0A2F2A2A0A202A2053657420746865206174747269627574657320746F2074686520676976656E20706F707065720A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574';
wwv_flow_api.g_varchar2_table(497) := '696C730A202A2040617267756D656E74207B456C656D656E747D20656C656D656E74202D20456C656D656E7420746F206170706C7920746865206174747269627574657320746F0A202A2040617267756D656E74207B4F626A6563747D207374796C6573';
wwv_flow_api.g_varchar2_table(498) := '0A202A204F626A65637420776974682061206C697374206F662070726F7065727469657320616E642076616C7565732077686963682077696C6C206265206170706C69656420746F2074686520656C656D656E740A202A2F0A66756E6374696F6E207365';
wwv_flow_api.g_varchar2_table(499) := '744174747269627574657328656C656D656E742C206174747269627574657329207B0A20204F626A6563742E6B6579732861747472696275746573292E666F72456163682866756E6374696F6E202870726F7029207B0A202020207661722076616C7565';
wwv_flow_api.g_varchar2_table(500) := '203D20617474726962757465735B70726F705D3B0A202020206966202876616C756520213D3D2066616C736529207B0A202020202020656C656D656E742E7365744174747269627574652870726F702C20617474726962757465735B70726F705D293B0A';
wwv_flow_api.g_varchar2_table(501) := '202020207D20656C7365207B0A202020202020656C656D656E742E72656D6F76654174747269627574652870726F70293B0A202020207D0A20207D293B0A7D0A0A2F2A2A0A202A204066756E6374696F6E0A202A20406D656D6265726F66204D6F646966';
wwv_flow_api.g_varchar2_table(502) := '696572730A202A2040617267756D656E74207B4F626A6563747D2064617461202D205468652064617461206F626A6563742067656E657261746564206279206075706461746560206D6574686F640A202A2040617267756D656E74207B4F626A6563747D';
wwv_flow_api.g_varchar2_table(503) := '20646174612E7374796C6573202D204C697374206F66207374796C652070726F70657274696573202D2076616C75657320746F206170706C7920746F20706F7070657220656C656D656E740A202A2040617267756D656E74207B4F626A6563747D206461';
wwv_flow_api.g_varchar2_table(504) := '74612E61747472696275746573202D204C697374206F66206174747269627574652070726F70657274696573202D2076616C75657320746F206170706C7920746F20706F7070657220656C656D656E740A202A2040617267756D656E74207B4F626A6563';
wwv_flow_api.g_varchar2_table(505) := '747D206F7074696F6E73202D204D6F6469666965727320636F6E66696775726174696F6E20616E64206F7074696F6E730A202A204072657475726E73207B4F626A6563747D205468652073616D652064617461206F626A6563740A202A2F0A66756E6374';
wwv_flow_api.g_varchar2_table(506) := '696F6E206170706C795374796C65286461746129207B0A20202F2F20616E792070726F70657274792070726573656E7420696E2060646174612E7374796C6573602077696C6C206265206170706C69656420746F2074686520706F707065722C0A20202F';
wwv_flow_api.g_varchar2_table(507) := '2F20696E2074686973207761792077652063616E206D616B652074686520337264207061727479206D6F646966696572732061646420637573746F6D207374796C657320746F2069740A20202F2F2042652061776172652C206D6F646966696572732063';
wwv_flow_api.g_varchar2_table(508) := '6F756C64206F76657272696465207468652070726F7065727469657320646566696E656420696E207468652070726576696F75730A20202F2F206C696E6573206F662074686973206D6F646966696572210A20207365745374796C657328646174612E69';
wwv_flow_api.g_varchar2_table(509) := '6E7374616E63652E706F707065722C20646174612E7374796C6573293B0A0A20202F2F20616E792070726F70657274792070726573656E7420696E2060646174612E61747472696275746573602077696C6C206265206170706C69656420746F20746865';
wwv_flow_api.g_varchar2_table(510) := '20706F707065722C0A20202F2F20746865792077696C6C206265207365742061732048544D4C2061747472696275746573206F662074686520656C656D656E740A20207365744174747269627574657328646174612E696E7374616E63652E706F707065';
wwv_flow_api.g_varchar2_table(511) := '722C20646174612E61747472696275746573293B0A0A20202F2F206966206172726F77456C656D656E7420697320646566696E656420616E64206172726F775374796C65732068617320736F6D652070726F706572746965730A20206966202864617461';
wwv_flow_api.g_varchar2_table(512) := '2E6172726F77456C656D656E74202626204F626A6563742E6B65797328646174612E6172726F775374796C6573292E6C656E67746829207B0A202020207365745374796C657328646174612E6172726F77456C656D656E742C20646174612E6172726F77';
wwv_flow_api.g_varchar2_table(513) := '5374796C6573293B0A20207D0A0A202072657475726E20646174613B0A7D0A0A2F2A2A0A202A205365742074686520782D706C6163656D656E7420617474726962757465206265666F72652065766572797468696E6720656C7365206265636175736520';
wwv_flow_api.g_varchar2_table(514) := '697420636F756C6420626520757365640A202A20746F20616464206D617267696E7320746F2074686520706F70706572206D617267696E73206E6565647320746F2062652063616C63756C6174656420746F20676574207468650A202A20636F72726563';
wwv_flow_api.g_varchar2_table(515) := '7420706F70706572206F6666736574732E0A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E6D6F646966696572730A202A2040706172616D207B48544D4C456C656D656E747D207265666572656E6365202D205468652072';
wwv_flow_api.g_varchar2_table(516) := '65666572656E636520656C656D656E74207573656420746F20706F736974696F6E2074686520706F707065720A202A2040706172616D207B48544D4C456C656D656E747D20706F70706572202D205468652048544D4C20656C656D656E74207573656420';
wwv_flow_api.g_varchar2_table(517) := '617320706F707065720A202A2040706172616D207B4F626A6563747D206F7074696F6E73202D20506F707065722E6A73206F7074696F6E730A202A2F0A66756E6374696F6E206170706C795374796C654F6E4C6F6164287265666572656E63652C20706F';
wwv_flow_api.g_varchar2_table(518) := '707065722C206F7074696F6E732C206D6F6469666965724F7074696F6E732C20737461746529207B0A20202F2F20636F6D70757465207265666572656E636520656C656D656E74206F6666736574730A2020766172207265666572656E63654F66667365';
wwv_flow_api.g_varchar2_table(519) := '7473203D206765745265666572656E63654F6666736574732873746174652C20706F707065722C207265666572656E63652C206F7074696F6E732E706F736974696F6E4669786564293B0A0A20202F2F20636F6D70757465206175746F20706C6163656D';
wwv_flow_api.g_varchar2_table(520) := '656E742C2073746F726520706C6163656D656E7420696E73696465207468652064617461206F626A6563742C0A20202F2F206D6F646966696572732077696C6C2062652061626C6520746F20656469742060706C6163656D656E7460206966206E656564';
wwv_flow_api.g_varchar2_table(521) := '65640A20202F2F20616E6420726566657220746F206F726967696E616C506C6163656D656E7420746F206B6E6F7720746865206F726967696E616C2076616C75650A202076617220706C6163656D656E74203D20636F6D707574654175746F506C616365';
wwv_flow_api.g_varchar2_table(522) := '6D656E74286F7074696F6E732E706C6163656D656E742C207265666572656E63654F6666736574732C20706F707065722C207265666572656E63652C206F7074696F6E732E6D6F646966696572732E666C69702E626F756E646172696573456C656D656E';
wwv_flow_api.g_varchar2_table(523) := '742C206F7074696F6E732E6D6F646966696572732E666C69702E70616464696E67293B0A0A2020706F707065722E7365744174747269627574652827782D706C6163656D656E74272C20706C6163656D656E74293B0A0A20202F2F204170706C79206070';
wwv_flow_api.g_varchar2_table(524) := '6F736974696F6E6020746F20706F70706572206265666F726520616E797468696E6720656C736520626563617573650A20202F2F20776974686F75742074686520706F736974696F6E206170706C6965642077652063616E27742067756172616E746565';
wwv_flow_api.g_varchar2_table(525) := '20636F727265637420636F6D7075746174696F6E730A20207365745374796C657328706F707065722C207B20706F736974696F6E3A206F7074696F6E732E706F736974696F6E4669786564203F2027666978656427203A20276162736F6C75746527207D';
wwv_flow_api.g_varchar2_table(526) := '293B0A0A202072657475726E206F7074696F6E733B0A7D0A0A2F2A2A0A202A204066756E6374696F6E0A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040617267756D656E74207B4F626A6563747D2064617461202D20546865';
wwv_flow_api.g_varchar2_table(527) := '2064617461206F626A6563742067656E657261746564206279206075706461746560206D6574686F640A202A2040617267756D656E74207B426F6F6C65616E7D2073686F756C64526F756E64202D20496620746865206F6666736574732073686F756C64';
wwv_flow_api.g_varchar2_table(528) := '20626520726F756E64656420617420616C6C0A202A204072657475726E73207B4F626A6563747D2054686520706F70706572277320706F736974696F6E206F66667365747320726F756E6465640A202A0A202A205468652074616C65206F662070697865';
wwv_flow_api.g_varchar2_table(529) := '6C2D7065726665637420706F736974696F6E696E672E2049742773207374696C6C206E6F74203130302520706572666563742C206275742061730A202A20676F6F642061732069742063616E2062652077697468696E20726561736F6E2E0A202A204469';
wwv_flow_api.g_varchar2_table(530) := '7363757373696F6E20686572653A2068747470733A2F2F6769746875622E636F6D2F46657A5672617374612F706F707065722E6A732F70756C6C2F3731350A202A0A202A204C6F77204450492073637265656E73206361757365206120706F7070657220';
wwv_flow_api.g_varchar2_table(531) := '746F20626520626C75727279206966206E6F74207573696E672066756C6C20706978656C7320285361666172690A202A2061732077656C6C206F6E2048696768204450492073637265656E73292E0A202A0A202A2046697265666F782070726566657273';
wwv_flow_api.g_varchar2_table(532) := '206E6F20726F756E64696E6720666F7220706F736974696F6E696E6720616E6420646F6573206E6F74206861766520626C757272696E657373206F6E0A202A2068696768204450492073637265656E732E0A202A0A202A204F6E6C7920686F72697A6F6E';
wwv_flow_api.g_varchar2_table(533) := '74616C20706C6163656D656E7420616E64206C6566742F72696768742076616C756573206E65656420746F20626520636F6E736964657265642E0A202A2F0A66756E6374696F6E20676574526F756E6465644F66667365747328646174612C2073686F75';
wwv_flow_api.g_varchar2_table(534) := '6C64526F756E6429207B0A2020766172205F64617461246F666673657473203D20646174612E6F6666736574732C0A202020202020706F70706572203D205F64617461246F6666736574732E706F707065722C0A2020202020207265666572656E636520';
wwv_flow_api.g_varchar2_table(535) := '3D205F64617461246F6666736574732E7265666572656E63653B0A0A202076617220726F756E64203D204D6174682E726F756E643B0A202076617220666C6F6F72203D204D6174682E666C6F6F723B0A2020766172206E6F526F756E64203D2066756E63';
wwv_flow_api.g_varchar2_table(536) := '74696F6E206E6F526F756E64287629207B0A2020202072657475726E20763B0A20207D3B0A0A202076617220706F707065725769647468203D20726F756E6428706F707065722E7769647468293B0A2020766172207265666572656E6365576964746820';
wwv_flow_api.g_varchar2_table(537) := '3D20726F756E64287265666572656E63652E7769647468293B0A0A2020766172206973566572746963616C203D205B276C656674272C20277269676874275D2E696E6465784F6628646174612E706C6163656D656E742920213D3D202D313B0A20207661';
wwv_flow_api.g_varchar2_table(538) := '72206973566172696174696F6E203D20646174612E706C6163656D656E742E696E6465784F6628272D272920213D3D202D313B0A20207661722073616D655769647468506172697479203D207265666572656E6365576964746820252032203D3D3D2070';
wwv_flow_api.g_varchar2_table(539) := '6F707065725769647468202520323B0A202076617220626F74684F64645769647468203D207265666572656E6365576964746820252032203D3D3D203120262620706F70706572576964746820252032203D3D3D20313B0A0A202076617220686F72697A';
wwv_flow_api.g_varchar2_table(540) := '6F6E74616C546F496E7465676572203D202173686F756C64526F756E64203F206E6F526F756E64203A206973566572746963616C207C7C206973566172696174696F6E207C7C2073616D655769647468506172697479203F20726F756E64203A20666C6F';
wwv_flow_api.g_varchar2_table(541) := '6F723B0A202076617220766572746963616C546F496E7465676572203D202173686F756C64526F756E64203F206E6F526F756E64203A20726F756E643B0A0A202072657475726E207B0A202020206C6566743A20686F72697A6F6E74616C546F496E7465';
wwv_flow_api.g_varchar2_table(542) := '67657228626F74684F6464576964746820262620216973566172696174696F6E2026262073686F756C64526F756E64203F20706F707065722E6C656674202D2031203A20706F707065722E6C656674292C0A20202020746F703A20766572746963616C54';
wwv_flow_api.g_varchar2_table(543) := '6F496E746567657228706F707065722E746F70292C0A20202020626F74746F6D3A20766572746963616C546F496E746567657228706F707065722E626F74746F6D292C0A2020202072696768743A20686F72697A6F6E74616C546F496E74656765722870';
wwv_flow_api.g_varchar2_table(544) := '6F707065722E7269676874290A20207D3B0A7D0A0A76617220697346697265666F78203D20697342726F777365722431202626202F46697265666F782F692E74657374286E6176696761746F722E757365724167656E74293B0A0A2F2A2A0A202A204066';
wwv_flow_api.g_varchar2_table(545) := '756E6374696F6E0A202A20406D656D6265726F66204D6F646966696572730A202A2040617267756D656E74207B4F626A6563747D2064617461202D205468652064617461206F626A6563742067656E657261746564206279206075706461746560206D65';
wwv_flow_api.g_varchar2_table(546) := '74686F640A202A2040617267756D656E74207B4F626A6563747D206F7074696F6E73202D204D6F6469666965727320636F6E66696775726174696F6E20616E64206F7074696F6E730A202A204072657475726E73207B4F626A6563747D20546865206461';
wwv_flow_api.g_varchar2_table(547) := '7461206F626A6563742C2070726F7065726C79206D6F6469666965640A202A2F0A66756E6374696F6E20636F6D707574655374796C6528646174612C206F7074696F6E7329207B0A20207661722078203D206F7074696F6E732E782C0A20202020202079';
wwv_flow_api.g_varchar2_table(548) := '203D206F7074696F6E732E793B0A202076617220706F70706572203D20646174612E6F6666736574732E706F707065723B0A0A20202F2F2052656D6F76652074686973206C656761637920737570706F727420696E20506F707065722E6A732076320A0A';
wwv_flow_api.g_varchar2_table(549) := '2020766172206C6567616379477075416363656C65726174696F6E4F7074696F6E203D2066696E6428646174612E696E7374616E63652E6D6F646966696572732C2066756E6374696F6E20286D6F64696669657229207B0A2020202072657475726E206D';
wwv_flow_api.g_varchar2_table(550) := '6F6469666965722E6E616D65203D3D3D20276170706C795374796C65273B0A20207D292E677075416363656C65726174696F6E3B0A2020696620286C6567616379477075416363656C65726174696F6E4F7074696F6E20213D3D20756E646566696E6564';
wwv_flow_api.g_varchar2_table(551) := '29207B0A20202020636F6E736F6C652E7761726E28275741524E494E473A2060677075416363656C65726174696F6E60206F7074696F6E206D6F76656420746F2060636F6D707574655374796C6560206D6F64696669657220616E642077696C6C206E6F';
wwv_flow_api.g_varchar2_table(552) := '7420626520737570706F7274656420696E206675747572652076657273696F6E73206F6620506F707065722E6A732127293B0A20207D0A202076617220677075416363656C65726174696F6E203D206C6567616379477075416363656C65726174696F6E';
wwv_flow_api.g_varchar2_table(553) := '4F7074696F6E20213D3D20756E646566696E6564203F206C6567616379477075416363656C65726174696F6E4F7074696F6E203A206F7074696F6E732E677075416363656C65726174696F6E3B0A0A2020766172206F6666736574506172656E74203D20';
wwv_flow_api.g_varchar2_table(554) := '6765744F6666736574506172656E7428646174612E696E7374616E63652E706F70706572293B0A2020766172206F6666736574506172656E7452656374203D20676574426F756E64696E67436C69656E7452656374286F6666736574506172656E74293B';
wwv_flow_api.g_varchar2_table(555) := '0A0A20202F2F205374796C65730A2020766172207374796C6573203D207B0A20202020706F736974696F6E3A20706F707065722E706F736974696F6E0A20207D3B0A0A2020766172206F666673657473203D20676574526F756E6465644F666673657473';
wwv_flow_api.g_varchar2_table(556) := '28646174612C2077696E646F772E646576696365506978656C526174696F203C2032207C7C2021697346697265666F78293B0A0A2020766172207369646541203D2078203D3D3D2027626F74746F6D27203F2027746F7027203A2027626F74746F6D273B';
wwv_flow_api.g_varchar2_table(557) := '0A2020766172207369646542203D2079203D3D3D2027726967687427203F20276C65667427203A20277269676874273B0A0A20202F2F20696620677075416363656C65726174696F6E2069732073657420746F2060747275656020616E64207472616E73';
wwv_flow_api.g_varchar2_table(558) := '666F726D20697320737570706F727465642C0A20202F2F202077652075736520607472616E736C61746533646020746F206170706C792074686520706F736974696F6E20746F2074686520706F707065722077650A20202F2F206175746F6D6174696361';
wwv_flow_api.g_varchar2_table(559) := '6C6C79207573652074686520737570706F727465642070726566697865642076657273696F6E206966206E65656465640A202076617220707265666978656450726F7065727479203D20676574537570706F7274656450726F70657274794E616D652827';
wwv_flow_api.g_varchar2_table(560) := '7472616E73666F726D27293B0A0A20202F2F206E6F772C206C65742773206D616B6520612073746570206261636B20616E64206C6F6F6B206174207468697320636F646520636C6F73656C7920287774663F290A20202F2F2049662074686520636F6E74';
wwv_flow_api.g_varchar2_table(561) := '656E74206F662074686520706F707065722067726F7773206F6E63652069742773206265656E20706F736974696F6E65642C2069740A20202F2F206D61792068617070656E20746861742074686520706F707065722067657473206D6973706C61636564';
wwv_flow_api.g_varchar2_table(562) := '2062656361757365206F6620746865206E657720636F6E74656E740A20202F2F206F766572666C6F77696E6720697473207265666572656E636520656C656D656E740A20202F2F20546F2061766F696420746869732070726F626C656D2C207765207072';
wwv_flow_api.g_varchar2_table(563) := '6F766964652074776F206F7074696F6E7320287820616E642079292C20776869636820616C6C6F770A20202F2F2074686520636F6E73756D657220746F20646566696E6520746865206F6666736574206F726967696E2E0A20202F2F2049662077652070';
wwv_flow_api.g_varchar2_table(564) := '6F736974696F6E206120706F70706572206F6E20746F70206F662061207265666572656E636520656C656D656E742C2077652063616E207365740A20202F2F2060786020746F2060746F706020746F206D616B652074686520706F707065722067726F77';
wwv_flow_api.g_varchar2_table(565) := '20746F77617264732069747320746F7020696E7374656164206F660A20202F2F2069747320626F74746F6D2E0A2020766172206C656674203D20766F696420302C0A202020202020746F70203D20766F696420303B0A2020696620287369646541203D3D';
wwv_flow_api.g_varchar2_table(566) := '3D2027626F74746F6D2729207B0A202020202F2F207768656E206F6666736574506172656E74206973203C68746D6C3E2074686520706F736974696F6E696E672069732072656C617469766520746F2074686520626F74746F6D206F6620746865207363';
wwv_flow_api.g_varchar2_table(567) := '7265656E20286578636C7564696E6720746865207363726F6C6C626172290A202020202F2F20616E64206E6F742074686520626F74746F6D206F66207468652068746D6C20656C656D656E740A20202020696620286F6666736574506172656E742E6E6F';
wwv_flow_api.g_varchar2_table(568) := '64654E616D65203D3D3D202748544D4C2729207B0A202020202020746F70203D202D6F6666736574506172656E742E636C69656E74486569676874202B206F6666736574732E626F74746F6D3B0A202020207D20656C7365207B0A202020202020746F70';
wwv_flow_api.g_varchar2_table(569) := '203D202D6F6666736574506172656E74526563742E686569676874202B206F6666736574732E626F74746F6D3B0A202020207D0A20207D20656C7365207B0A20202020746F70203D206F6666736574732E746F703B0A20207D0A20206966202873696465';
wwv_flow_api.g_varchar2_table(570) := '42203D3D3D202772696768742729207B0A20202020696620286F6666736574506172656E742E6E6F64654E616D65203D3D3D202748544D4C2729207B0A2020202020206C656674203D202D6F6666736574506172656E742E636C69656E74576964746820';
wwv_flow_api.g_varchar2_table(571) := '2B206F6666736574732E72696768743B0A202020207D20656C7365207B0A2020202020206C656674203D202D6F6666736574506172656E74526563742E7769647468202B206F6666736574732E72696768743B0A202020207D0A20207D20656C7365207B';
wwv_flow_api.g_varchar2_table(572) := '0A202020206C656674203D206F6666736574732E6C6566743B0A20207D0A202069662028677075416363656C65726174696F6E20262620707265666978656450726F706572747929207B0A202020207374796C65735B707265666978656450726F706572';
wwv_flow_api.g_varchar2_table(573) := '74795D203D20277472616E736C61746533642827202B206C656674202B202770782C2027202B20746F70202B202770782C203029273B0A202020207374796C65735B73696465415D203D20303B0A202020207374796C65735B73696465425D203D20303B';
wwv_flow_api.g_varchar2_table(574) := '0A202020207374796C65732E77696C6C4368616E6765203D20277472616E73666F726D273B0A20207D20656C7365207B0A202020202F2F206F74687765726973652C2077652075736520746865207374616E646172642060746F70602C20606C65667460';
wwv_flow_api.g_varchar2_table(575) := '2C2060626F74746F6D6020616E6420607269676874602070726F706572746965730A2020202076617220696E76657274546F70203D207369646541203D3D3D2027626F74746F6D27203F202D31203A20313B0A2020202076617220696E766572744C6566';
wwv_flow_api.g_varchar2_table(576) := '74203D207369646542203D3D3D2027726967687427203F202D31203A20313B0A202020207374796C65735B73696465415D203D20746F70202A20696E76657274546F703B0A202020207374796C65735B73696465425D203D206C656674202A20696E7665';
wwv_flow_api.g_varchar2_table(577) := '72744C6566743B0A202020207374796C65732E77696C6C4368616E6765203D207369646541202B20272C2027202B2073696465423B0A20207D0A0A20202F2F20417474726962757465730A20207661722061747472696275746573203D207B0A20202020';
wwv_flow_api.g_varchar2_table(578) := '27782D706C6163656D656E74273A20646174612E706C6163656D656E740A20207D3B0A0A20202F2F205570646174652060646174616020617474726962757465732C207374796C657320616E64206172726F775374796C65730A2020646174612E617474';
wwv_flow_api.g_varchar2_table(579) := '72696275746573203D205F657874656E6473287B7D2C20617474726962757465732C20646174612E61747472696275746573293B0A2020646174612E7374796C6573203D205F657874656E6473287B7D2C207374796C65732C20646174612E7374796C65';
wwv_flow_api.g_varchar2_table(580) := '73293B0A2020646174612E6172726F775374796C6573203D205F657874656E6473287B7D2C20646174612E6F6666736574732E6172726F772C20646174612E6172726F775374796C6573293B0A0A202072657475726E20646174613B0A7D0A0A2F2A2A0A';
wwv_flow_api.g_varchar2_table(581) := '202A2048656C706572207573656420746F206B6E6F772069662074686520676976656E206D6F64696669657220646570656E64732066726F6D20616E6F74686572206F6E652E3C6272202F3E0A202A20497420636865636B7320696620746865206E6565';
wwv_flow_api.g_varchar2_table(582) := '646564206D6F646966696572206973206C697374656420616E6420656E61626C65642E0A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040706172616D207B41727261797D206D6F64696669657273';
wwv_flow_api.g_varchar2_table(583) := '202D206C697374206F66206D6F646966696572730A202A2040706172616D207B537472696E677D2072657175657374696E674E616D65202D206E616D65206F662072657175657374696E67206D6F6469666965720A202A2040706172616D207B53747269';
wwv_flow_api.g_varchar2_table(584) := '6E677D207265717565737465644E616D65202D206E616D65206F6620726571756573746564206D6F6469666965720A202A204072657475726E73207B426F6F6C65616E7D0A202A2F0A66756E6374696F6E2069734D6F6469666965725265717569726564';
wwv_flow_api.g_varchar2_table(585) := '286D6F646966696572732C2072657175657374696E674E616D652C207265717565737465644E616D6529207B0A20207661722072657175657374696E67203D2066696E64286D6F646966696572732C2066756E6374696F6E20285F72656629207B0A2020';
wwv_flow_api.g_varchar2_table(586) := '2020766172206E616D65203D205F7265662E6E616D653B0A2020202072657475726E206E616D65203D3D3D2072657175657374696E674E616D653B0A20207D293B0A0A20207661722069735265717569726564203D20212172657175657374696E672026';
wwv_flow_api.g_varchar2_table(587) := '26206D6F646966696572732E736F6D652866756E6374696F6E20286D6F64696669657229207B0A2020202072657475726E206D6F6469666965722E6E616D65203D3D3D207265717565737465644E616D65202626206D6F6469666965722E656E61626C65';
wwv_flow_api.g_varchar2_table(588) := '64202626206D6F6469666965722E6F72646572203C2072657175657374696E672E6F726465723B0A20207D293B0A0A202069662028216973526571756972656429207B0A20202020766172205F72657175657374696E67203D20276027202B2072657175';
wwv_flow_api.g_varchar2_table(589) := '657374696E674E616D65202B202760273B0A2020202076617220726571756573746564203D20276027202B207265717565737465644E616D65202B202760273B0A20202020636F6E736F6C652E7761726E28726571756573746564202B2027206D6F6469';
wwv_flow_api.g_varchar2_table(590) := '666965722069732072657175697265642062792027202B205F72657175657374696E67202B2027206D6F64696669657220696E206F7264657220746F20776F726B2C206265207375726520746F20696E636C756465206974206265666F72652027202B20';
wwv_flow_api.g_varchar2_table(591) := '5F72657175657374696E67202B20272127293B0A20207D0A202072657475726E20697352657175697265643B0A7D0A0A2F2A2A0A202A204066756E6374696F6E0A202A20406D656D6265726F66204D6F646966696572730A202A2040617267756D656E74';
wwv_flow_api.g_varchar2_table(592) := '207B4F626A6563747D2064617461202D205468652064617461206F626A6563742067656E65726174656420627920757064617465206D6574686F640A202A2040617267756D656E74207B4F626A6563747D206F7074696F6E73202D204D6F646966696572';
wwv_flow_api.g_varchar2_table(593) := '7320636F6E66696775726174696F6E20616E64206F7074696F6E730A202A204072657475726E73207B4F626A6563747D205468652064617461206F626A6563742C2070726F7065726C79206D6F6469666965640A202A2F0A66756E6374696F6E20617272';
wwv_flow_api.g_varchar2_table(594) := '6F7728646174612C206F7074696F6E7329207B0A2020766172205F64617461246F666673657473246172726F773B0A0A20202F2F206172726F7720646570656E6473206F6E206B656570546F67657468657220696E206F7264657220746F20776F726B0A';
wwv_flow_api.g_varchar2_table(595) := '2020696620282169734D6F646966696572526571756972656428646174612E696E7374616E63652E6D6F646966696572732C20276172726F77272C20276B656570546F676574686572272929207B0A2020202072657475726E20646174613B0A20207D0A';
wwv_flow_api.g_varchar2_table(596) := '0A2020766172206172726F77456C656D656E74203D206F7074696F6E732E656C656D656E743B0A0A20202F2F206966206172726F77456C656D656E74206973206120737472696E672C20737570706F736520697427732061204353532073656C6563746F';
wwv_flow_api.g_varchar2_table(597) := '720A202069662028747970656F66206172726F77456C656D656E74203D3D3D2027737472696E672729207B0A202020206172726F77456C656D656E74203D20646174612E696E7374616E63652E706F707065722E717565727953656C6563746F72286172';
wwv_flow_api.g_varchar2_table(598) := '726F77456C656D656E74293B0A0A202020202F2F206966206172726F77456C656D656E74206973206E6F7420666F756E642C20646F6E27742072756E20746865206D6F6469666965720A2020202069662028216172726F77456C656D656E7429207B0A20';
wwv_flow_api.g_varchar2_table(599) := '202020202072657475726E20646174613B0A202020207D0A20207D20656C7365207B0A202020202F2F20696620746865206172726F77456C656D656E742069736E277420612071756572792073656C6563746F72207765206D75737420636865636B2074';
wwv_flow_api.g_varchar2_table(600) := '686174207468650A202020202F2F2070726F766964656420444F4D206E6F6465206973206368696C64206F662069747320706F70706572206E6F64650A202020206966202821646174612E696E7374616E63652E706F707065722E636F6E7461696E7328';
wwv_flow_api.g_varchar2_table(601) := '6172726F77456C656D656E742929207B0A202020202020636F6E736F6C652E7761726E28275741524E494E473A20606172726F772E656C656D656E7460206D757374206265206368696C64206F662069747320706F7070657220656C656D656E74212729';
wwv_flow_api.g_varchar2_table(602) := '3B0A20202020202072657475726E20646174613B0A202020207D0A20207D0A0A202076617220706C6163656D656E74203D20646174612E706C6163656D656E742E73706C697428272D27295B305D3B0A2020766172205F64617461246F66667365747320';
wwv_flow_api.g_varchar2_table(603) := '3D20646174612E6F6666736574732C0A202020202020706F70706572203D205F64617461246F6666736574732E706F707065722C0A2020202020207265666572656E6365203D205F64617461246F6666736574732E7265666572656E63653B0A0A202076';
wwv_flow_api.g_varchar2_table(604) := '6172206973566572746963616C203D205B276C656674272C20277269676874275D2E696E6465784F6628706C6163656D656E742920213D3D202D313B0A0A2020766172206C656E203D206973566572746963616C203F202768656967687427203A202777';
wwv_flow_api.g_varchar2_table(605) := '69647468273B0A202076617220736964654361706974616C697A6564203D206973566572746963616C203F2027546F7027203A20274C656674273B0A20207661722073696465203D20736964654361706974616C697A65642E746F4C6F77657243617365';
wwv_flow_api.g_varchar2_table(606) := '28293B0A202076617220616C7453696465203D206973566572746963616C203F20276C65667427203A2027746F70273B0A2020766172206F7053696465203D206973566572746963616C203F2027626F74746F6D27203A20277269676874273B0A202076';
wwv_flow_api.g_varchar2_table(607) := '6172206172726F77456C656D656E7453697A65203D206765744F7574657253697A6573286172726F77456C656D656E74295B6C656E5D3B0A0A20202F2F0A20202F2F20657874656E6473206B656570546F676574686572206265686176696F72206D616B';
wwv_flow_api.g_varchar2_table(608) := '696E6720737572652074686520706F7070657220616E64206974730A20202F2F207265666572656E6365206861766520656E6F75676820706978656C7320696E20636F6E6A756E6374696F6E0A20202F2F0A0A20202F2F20746F702F6C65667420736964';
wwv_flow_api.g_varchar2_table(609) := '650A2020696620287265666572656E63655B6F70536964655D202D206172726F77456C656D656E7453697A65203C20706F707065725B736964655D29207B0A20202020646174612E6F6666736574732E706F707065725B736964655D202D3D20706F7070';
wwv_flow_api.g_varchar2_table(610) := '65725B736964655D202D20287265666572656E63655B6F70536964655D202D206172726F77456C656D656E7453697A65293B0A20207D0A20202F2F20626F74746F6D2F726967687420736964650A2020696620287265666572656E63655B736964655D20';
wwv_flow_api.g_varchar2_table(611) := '2B206172726F77456C656D656E7453697A65203E20706F707065725B6F70536964655D29207B0A20202020646174612E6F6666736574732E706F707065725B736964655D202B3D207265666572656E63655B736964655D202B206172726F77456C656D65';
wwv_flow_api.g_varchar2_table(612) := '6E7453697A65202D20706F707065725B6F70536964655D3B0A20207D0A2020646174612E6F6666736574732E706F70706572203D20676574436C69656E745265637428646174612E6F6666736574732E706F70706572293B0A0A20202F2F20636F6D7075';
wwv_flow_api.g_varchar2_table(613) := '74652063656E746572206F662074686520706F707065720A20207661722063656E746572203D207265666572656E63655B736964655D202B207265666572656E63655B6C656E5D202F2032202D206172726F77456C656D656E7453697A65202F20323B0A';
wwv_flow_api.g_varchar2_table(614) := '0A20202F2F20436F6D7075746520746865207369646556616C7565207573696E6720746865207570646174656420706F70706572206F6666736574730A20202F2F2074616B6520706F70706572206D617267696E20696E206163636F756E742062656361';
wwv_flow_api.g_varchar2_table(615) := '75736520776520646F6E27742068617665207468697320696E666F20617661696C61626C650A202076617220637373203D206765745374796C65436F6D707574656450726F706572747928646174612E696E7374616E63652E706F70706572293B0A2020';
wwv_flow_api.g_varchar2_table(616) := '76617220706F707065724D617267696E53696465203D207061727365466C6F6174286373735B276D617267696E27202B20736964654361706974616C697A65645D2C203130293B0A202076617220706F70706572426F7264657253696465203D20706172';
wwv_flow_api.g_varchar2_table(617) := '7365466C6F6174286373735B27626F7264657227202B20736964654361706974616C697A6564202B20275769647468275D2C203130293B0A2020766172207369646556616C7565203D2063656E746572202D20646174612E6F6666736574732E706F7070';
wwv_flow_api.g_varchar2_table(618) := '65725B736964655D202D20706F707065724D617267696E53696465202D20706F70706572426F72646572536964653B0A0A20202F2F2070726576656E74206172726F77456C656D656E742066726F6D206265696E6720706C61636564206E6F7420636F6E';
wwv_flow_api.g_varchar2_table(619) := '746967756F75736C7920746F2069747320706F707065720A20207369646556616C7565203D204D6174682E6D6178284D6174682E6D696E28706F707065725B6C656E5D202D206172726F77456C656D656E7453697A652C207369646556616C7565292C20';
wwv_flow_api.g_varchar2_table(620) := '30293B0A0A2020646174612E6172726F77456C656D656E74203D206172726F77456C656D656E743B0A2020646174612E6F6666736574732E6172726F77203D20285F64617461246F666673657473246172726F77203D207B7D2C20646566696E6550726F';
wwv_flow_api.g_varchar2_table(621) := '7065727479285F64617461246F666673657473246172726F772C20736964652C204D6174682E726F756E64287369646556616C756529292C20646566696E6550726F7065727479285F64617461246F666673657473246172726F772C20616C7453696465';
wwv_flow_api.g_varchar2_table(622) := '2C202727292C205F64617461246F666673657473246172726F77293B0A0A202072657475726E20646174613B0A7D0A0A2F2A2A0A202A2047657420746865206F70706F7369746520706C6163656D656E7420766172696174696F6E206F66207468652067';
wwv_flow_api.g_varchar2_table(623) := '6976656E206F6E650A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040617267756D656E74207B537472696E677D20706C6163656D656E7420766172696174696F6E0A202A204072657475726E7320';
wwv_flow_api.g_varchar2_table(624) := '7B537472696E677D20666C697070656420706C6163656D656E7420766172696174696F6E0A202A2F0A66756E6374696F6E206765744F70706F73697465566172696174696F6E28766172696174696F6E29207B0A202069662028766172696174696F6E20';
wwv_flow_api.g_varchar2_table(625) := '3D3D3D2027656E642729207B0A2020202072657475726E20277374617274273B0A20207D20656C73652069662028766172696174696F6E203D3D3D202773746172742729207B0A2020202072657475726E2027656E64273B0A20207D0A20207265747572';
wwv_flow_api.g_varchar2_table(626) := '6E20766172696174696F6E3B0A7D0A0A2F2A2A0A202A204C697374206F6620616363657074656420706C6163656D656E747320746F207573652061732076616C756573206F66207468652060706C6163656D656E7460206F7074696F6E2E3C6272202F3E';
wwv_flow_api.g_varchar2_table(627) := '0A202A2056616C696420706C6163656D656E7473206172653A0A202A202D20606175746F600A202A202D2060746F70600A202A202D20607269676874600A202A202D2060626F74746F6D600A202A202D20606C656674600A202A0A202A20456163682070';
wwv_flow_api.g_varchar2_table(628) := '6C6163656D656E742063616E2068617665206120766172696174696F6E2066726F6D2074686973206C6973743A0A202A202D20602D7374617274600A202A202D20602D656E64600A202A0A202A20566172696174696F6E732061726520696E7465727072';
wwv_flow_api.g_varchar2_table(629) := '6574656420656173696C7920696620796F75207468696E6B206F66207468656D20617320746865206C65667420746F2072696768740A202A207772697474656E206C616E6775616765732E20486F72697A6F6E74616C6C79202860746F706020616E6420';
wwv_flow_api.g_varchar2_table(630) := '60626F74746F6D60292C2060737461727460206973206C65667420616E642060656E64600A202A2069732072696768742E3C6272202F3E0A202A20566572746963616C6C792028606C6566746020616E642060726967687460292C206073746172746020';
wwv_flow_api.g_varchar2_table(631) := '697320746F7020616E642060656E646020697320626F74746F6D2E0A202A0A202A20536F6D652076616C6964206578616D706C6573206172653A0A202A202D2060746F702D656E646020286F6E20746F70206F66207265666572656E63652C2072696768';
wwv_flow_api.g_varchar2_table(632) := '7420616C69676E6564290A202A202D206072696768742D73746172746020286F6E207269676874206F66207265666572656E63652C20746F7020616C69676E6564290A202A202D2060626F74746F6D6020286F6E20626F74746F6D2C2063656E74657265';
wwv_flow_api.g_varchar2_table(633) := '64290A202A202D20606175746F2D656E646020286F6E2074686520736964652077697468206D6F726520737061636520617661696C61626C652C20616C69676E6D656E7420646570656E647320627920706C6163656D656E74290A202A0A202A20407374';
wwv_flow_api.g_varchar2_table(634) := '617469630A202A204074797065207B41727261797D0A202A2040656E756D207B537472696E677D0A202A2040726561646F6E6C790A202A20406D6574686F6420706C6163656D656E74730A202A20406D656D6265726F6620506F707065720A202A2F0A76';
wwv_flow_api.g_varchar2_table(635) := '617220706C6163656D656E7473203D205B276175746F2D7374617274272C20276175746F272C20276175746F2D656E64272C2027746F702D7374617274272C2027746F70272C2027746F702D656E64272C202772696768742D7374617274272C20277269';
wwv_flow_api.g_varchar2_table(636) := '676874272C202772696768742D656E64272C2027626F74746F6D2D656E64272C2027626F74746F6D272C2027626F74746F6D2D7374617274272C20276C6566742D656E64272C20276C656674272C20276C6566742D7374617274275D3B0A0A2F2F204765';
wwv_flow_api.g_varchar2_table(637) := '7420726964206F6620606175746F6020606175746F2D73746172746020616E6420606175746F2D656E64600A7661722076616C6964506C6163656D656E7473203D20706C6163656D656E74732E736C6963652833293B0A0A2F2A2A0A202A20476976656E';
wwv_flow_api.g_varchar2_table(638) := '20616E20696E697469616C20706C6163656D656E742C2072657475726E7320616C6C207468652073756273657175656E7420706C6163656D656E74730A202A20636C6F636B7769736520286F7220636F756E7465722D636C6F636B77697365292E0A202A';
wwv_flow_api.g_varchar2_table(639) := '0A202A20406D6574686F640A202A20406D656D6265726F6620506F707065722E5574696C730A202A2040617267756D656E74207B537472696E677D20706C6163656D656E74202D20412076616C696420706C6163656D656E742028697420616363657074';
wwv_flow_api.g_varchar2_table(640) := '7320766172696174696F6E73290A202A2040617267756D656E74207B426F6F6C65616E7D20636F756E746572202D2053657420746F207472756520746F2077616C6B2074686520706C6163656D656E747320636F756E746572636C6F636B776973650A20';
wwv_flow_api.g_varchar2_table(641) := '2A204072657475726E73207B41727261797D20706C6163656D656E747320696E636C7564696E6720746865697220766172696174696F6E730A202A2F0A66756E6374696F6E20636C6F636B7769736528706C6163656D656E7429207B0A20207661722063';
wwv_flow_api.g_varchar2_table(642) := '6F756E746572203D20617267756D656E74732E6C656E677468203E203120262620617267756D656E74735B315D20213D3D20756E646566696E6564203F20617267756D656E74735B315D203A2066616C73653B0A0A202076617220696E646578203D2076';
wwv_flow_api.g_varchar2_table(643) := '616C6964506C6163656D656E74732E696E6465784F6628706C6163656D656E74293B0A202076617220617272203D2076616C6964506C6163656D656E74732E736C69636528696E646578202B2031292E636F6E6361742876616C6964506C6163656D656E';
wwv_flow_api.g_varchar2_table(644) := '74732E736C69636528302C20696E64657829293B0A202072657475726E20636F756E746572203F206172722E726576657273652829203A206172723B0A7D0A0A766172204245484156494F5253203D207B0A2020464C49503A2027666C6970272C0A2020';
wwv_flow_api.g_varchar2_table(645) := '434C4F434B574953453A2027636C6F636B77697365272C0A2020434F554E544552434C4F434B574953453A2027636F756E746572636C6F636B77697365270A7D3B0A0A2F2A2A0A202A204066756E6374696F6E0A202A20406D656D6265726F66204D6F64';
wwv_flow_api.g_varchar2_table(646) := '6966696572730A202A2040617267756D656E74207B4F626A6563747D2064617461202D205468652064617461206F626A6563742067656E65726174656420627920757064617465206D6574686F640A202A2040617267756D656E74207B4F626A6563747D';
wwv_flow_api.g_varchar2_table(647) := '206F7074696F6E73202D204D6F6469666965727320636F6E66696775726174696F6E20616E64206F7074696F6E730A202A204072657475726E73207B4F626A6563747D205468652064617461206F626A6563742C2070726F7065726C79206D6F64696669';
wwv_flow_api.g_varchar2_table(648) := '65640A202A2F0A66756E6374696F6E20666C697028646174612C206F7074696F6E7329207B0A20202F2F2069662060696E6E657260206D6F64696669657220697320656E61626C65642C2077652063616E277420757365207468652060666C697060206D';
wwv_flow_api.g_varchar2_table(649) := '6F6469666965720A20206966202869734D6F646966696572456E61626C656428646174612E696E7374616E63652E6D6F646966696572732C2027696E6E6572272929207B0A2020202072657475726E20646174613B0A20207D0A0A202069662028646174';
wwv_flow_api.g_varchar2_table(650) := '612E666C697070656420262620646174612E706C6163656D656E74203D3D3D20646174612E6F726967696E616C506C6163656D656E7429207B0A202020202F2F207365656D73206C696B6520666C697020697320747279696E6720746F206C6F6F702C20';
wwv_flow_api.g_varchar2_table(651) := '70726F6261626C792074686572652773206E6F7420656E6F756768207370616365206F6E20616E79206F662074686520666C69707061626C652073696465730A2020202072657475726E20646174613B0A20207D0A0A202076617220626F756E64617269';
wwv_flow_api.g_varchar2_table(652) := '6573203D20676574426F756E64617269657328646174612E696E7374616E63652E706F707065722C20646174612E696E7374616E63652E7265666572656E63652C206F7074696F6E732E70616464696E672C206F7074696F6E732E626F756E6461726965';
wwv_flow_api.g_varchar2_table(653) := '73456C656D656E742C20646174612E706F736974696F6E4669786564293B0A0A202076617220706C6163656D656E74203D20646174612E706C6163656D656E742E73706C697428272D27295B305D3B0A202076617220706C6163656D656E744F70706F73';
wwv_flow_api.g_varchar2_table(654) := '697465203D206765744F70706F73697465506C6163656D656E7428706C6163656D656E74293B0A202076617220766172696174696F6E203D20646174612E706C6163656D656E742E73706C697428272D27295B315D207C7C2027273B0A0A202076617220';
wwv_flow_api.g_varchar2_table(655) := '666C69704F72646572203D205B5D3B0A0A202073776974636820286F7074696F6E732E6265686176696F7229207B0A2020202063617365204245484156494F52532E464C49503A0A202020202020666C69704F72646572203D205B706C6163656D656E74';
wwv_flow_api.g_varchar2_table(656) := '2C20706C6163656D656E744F70706F736974655D3B0A202020202020627265616B3B0A2020202063617365204245484156494F52532E434C4F434B574953453A0A202020202020666C69704F72646572203D20636C6F636B7769736528706C6163656D65';
wwv_flow_api.g_varchar2_table(657) := '6E74293B0A202020202020627265616B3B0A2020202063617365204245484156494F52532E434F554E544552434C4F434B574953453A0A202020202020666C69704F72646572203D20636C6F636B7769736528706C6163656D656E742C2074727565293B';
wwv_flow_api.g_varchar2_table(658) := '0A202020202020627265616B3B0A2020202064656661756C743A0A202020202020666C69704F72646572203D206F7074696F6E732E6265686176696F723B0A20207D0A0A2020666C69704F726465722E666F72456163682866756E6374696F6E20287374';
wwv_flow_api.g_varchar2_table(659) := '65702C20696E64657829207B0A2020202069662028706C6163656D656E7420213D3D2073746570207C7C20666C69704F726465722E6C656E677468203D3D3D20696E646578202B203129207B0A20202020202072657475726E20646174613B0A20202020';
wwv_flow_api.g_varchar2_table(660) := '7D0A0A20202020706C6163656D656E74203D20646174612E706C6163656D656E742E73706C697428272D27295B305D3B0A20202020706C6163656D656E744F70706F73697465203D206765744F70706F73697465506C6163656D656E7428706C6163656D';
wwv_flow_api.g_varchar2_table(661) := '656E74293B0A0A2020202076617220706F707065724F666673657473203D20646174612E6F6666736574732E706F707065723B0A20202020766172207265664F666673657473203D20646174612E6F6666736574732E7265666572656E63653B0A0A2020';
wwv_flow_api.g_varchar2_table(662) := '20202F2F207573696E6720666C6F6F72206265636175736520746865207265666572656E6365206F666673657473206D617920636F6E7461696E20646563696D616C7320776520617265206E6F7420676F696E6720746F20636F6E736964657220686572';
wwv_flow_api.g_varchar2_table(663) := '650A2020202076617220666C6F6F72203D204D6174682E666C6F6F723B0A20202020766172206F7665726C617073526566203D20706C6163656D656E74203D3D3D20276C6566742720262620666C6F6F7228706F707065724F6666736574732E72696768';
wwv_flow_api.g_varchar2_table(664) := '7429203E20666C6F6F72287265664F6666736574732E6C65667429207C7C20706C6163656D656E74203D3D3D202772696768742720262620666C6F6F7228706F707065724F6666736574732E6C65667429203C20666C6F6F72287265664F666673657473';
wwv_flow_api.g_varchar2_table(665) := '2E726967687429207C7C20706C6163656D656E74203D3D3D2027746F702720262620666C6F6F7228706F707065724F6666736574732E626F74746F6D29203E20666C6F6F72287265664F6666736574732E746F7029207C7C20706C6163656D656E74203D';
wwv_flow_api.g_varchar2_table(666) := '3D3D2027626F74746F6D2720262620666C6F6F7228706F707065724F6666736574732E746F7029203C20666C6F6F72287265664F6666736574732E626F74746F6D293B0A0A20202020766172206F766572666C6F77734C656674203D20666C6F6F722870';
wwv_flow_api.g_varchar2_table(667) := '6F707065724F6666736574732E6C65667429203C20666C6F6F7228626F756E6461726965732E6C656674293B0A20202020766172206F766572666C6F77735269676874203D20666C6F6F7228706F707065724F6666736574732E726967687429203E2066';
wwv_flow_api.g_varchar2_table(668) := '6C6F6F7228626F756E6461726965732E7269676874293B0A20202020766172206F766572666C6F7773546F70203D20666C6F6F7228706F707065724F6666736574732E746F7029203C20666C6F6F7228626F756E6461726965732E746F70293B0A202020';
wwv_flow_api.g_varchar2_table(669) := '20766172206F766572666C6F7773426F74746F6D203D20666C6F6F7228706F707065724F6666736574732E626F74746F6D29203E20666C6F6F7228626F756E6461726965732E626F74746F6D293B0A0A20202020766172206F766572666C6F7773426F75';
wwv_flow_api.g_varchar2_table(670) := '6E646172696573203D20706C6163656D656E74203D3D3D20276C65667427202626206F766572666C6F77734C656674207C7C20706C6163656D656E74203D3D3D2027726967687427202626206F766572666C6F77735269676874207C7C20706C6163656D';
wwv_flow_api.g_varchar2_table(671) := '656E74203D3D3D2027746F7027202626206F766572666C6F7773546F70207C7C20706C6163656D656E74203D3D3D2027626F74746F6D27202626206F766572666C6F7773426F74746F6D3B0A0A202020202F2F20666C6970207468652076617269617469';
wwv_flow_api.g_varchar2_table(672) := '6F6E2069662072657175697265640A20202020766172206973566572746963616C203D205B27746F70272C2027626F74746F6D275D2E696E6465784F6628706C6163656D656E742920213D3D202D313B0A2020202076617220666C697070656456617269';
wwv_flow_api.g_varchar2_table(673) := '6174696F6E203D2021216F7074696F6E732E666C6970566172696174696F6E7320262620286973566572746963616C20262620766172696174696F6E203D3D3D2027737461727427202626206F766572666C6F77734C656674207C7C2069735665727469';
wwv_flow_api.g_varchar2_table(674) := '63616C20262620766172696174696F6E203D3D3D2027656E6427202626206F766572666C6F77735269676874207C7C20216973566572746963616C20262620766172696174696F6E203D3D3D2027737461727427202626206F766572666C6F7773546F70';
wwv_flow_api.g_varchar2_table(675) := '207C7C20216973566572746963616C20262620766172696174696F6E203D3D3D2027656E6427202626206F766572666C6F7773426F74746F6D293B0A0A20202020696620286F7665726C617073526566207C7C206F766572666C6F7773426F756E646172';
wwv_flow_api.g_varchar2_table(676) := '696573207C7C20666C6970706564566172696174696F6E29207B0A2020202020202F2F207468697320626F6F6C65616E20746F2064657465637420616E7920666C6970206C6F6F700A202020202020646174612E666C6970706564203D20747275653B0A';
wwv_flow_api.g_varchar2_table(677) := '0A202020202020696620286F7665726C617073526566207C7C206F766572666C6F7773426F756E64617269657329207B0A2020202020202020706C6163656D656E74203D20666C69704F726465725B696E646578202B20315D3B0A2020202020207D0A0A';
wwv_flow_api.g_varchar2_table(678) := '20202020202069662028666C6970706564566172696174696F6E29207B0A2020202020202020766172696174696F6E203D206765744F70706F73697465566172696174696F6E28766172696174696F6E293B0A2020202020207D0A0A2020202020206461';
wwv_flow_api.g_varchar2_table(679) := '74612E706C6163656D656E74203D20706C6163656D656E74202B2028766172696174696F6E203F20272D27202B20766172696174696F6E203A202727293B0A0A2020202020202F2F2074686973206F626A65637420636F6E7461696E732060706F736974';
wwv_flow_api.g_varchar2_table(680) := '696F6E602C2077652077616E7420746F20707265736572766520697420616C6F6E6720776974680A2020202020202F2F20616E79206164646974696F6E616C2070726F7065727479207765206D61792061646420696E20746865206675747572650A2020';
wwv_flow_api.g_varchar2_table(681) := '20202020646174612E6F6666736574732E706F70706572203D205F657874656E6473287B7D2C20646174612E6F6666736574732E706F707065722C20676574506F707065724F66667365747328646174612E696E7374616E63652E706F707065722C2064';
wwv_flow_api.g_varchar2_table(682) := '6174612E6F6666736574732E7265666572656E63652C20646174612E706C6163656D656E7429293B0A0A20202020202064617461203D2072756E4D6F6469666965727328646174612E696E7374616E63652E6D6F646966696572732C20646174612C2027';
wwv_flow_api.g_varchar2_table(683) := '666C697027293B0A202020207D0A20207D293B0A202072657475726E20646174613B0A7D0A0A2F2A2A0A202A204066756E6374696F6E0A202A20406D656D6265726F66204D6F646966696572730A202A2040617267756D656E74207B4F626A6563747D20';
wwv_flow_api.g_varchar2_table(684) := '64617461202D205468652064617461206F626A6563742067656E65726174656420627920757064617465206D6574686F640A202A2040617267756D656E74207B4F626A6563747D206F7074696F6E73202D204D6F6469666965727320636F6E6669677572';
wwv_flow_api.g_varchar2_table(685) := '6174696F6E20616E64206F7074696F6E730A202A204072657475726E73207B4F626A6563747D205468652064617461206F626A6563742C2070726F7065726C79206D6F6469666965640A202A2F0A66756E6374696F6E206B656570546F67657468657228';
wwv_flow_api.g_varchar2_table(686) := '6461746129207B0A2020766172205F64617461246F666673657473203D20646174612E6F6666736574732C0A202020202020706F70706572203D205F64617461246F6666736574732E706F707065722C0A2020202020207265666572656E6365203D205F';
wwv_flow_api.g_varchar2_table(687) := '64617461246F6666736574732E7265666572656E63653B0A0A202076617220706C6163656D656E74203D20646174612E706C6163656D656E742E73706C697428272D27295B305D3B0A202076617220666C6F6F72203D204D6174682E666C6F6F723B0A20';
wwv_flow_api.g_varchar2_table(688) := '20766172206973566572746963616C203D205B27746F70272C2027626F74746F6D275D2E696E6465784F6628706C6163656D656E742920213D3D202D313B0A20207661722073696465203D206973566572746963616C203F2027726967687427203A2027';
wwv_flow_api.g_varchar2_table(689) := '626F74746F6D273B0A2020766172206F7053696465203D206973566572746963616C203F20276C65667427203A2027746F70273B0A2020766172206D6561737572656D656E74203D206973566572746963616C203F2027776964746827203A2027686569';
wwv_flow_api.g_varchar2_table(690) := '676874273B0A0A202069662028706F707065725B736964655D203C20666C6F6F72287265666572656E63655B6F70536964655D2929207B0A20202020646174612E6F6666736574732E706F707065725B6F70536964655D203D20666C6F6F722872656665';
wwv_flow_api.g_varchar2_table(691) := '72656E63655B6F70536964655D29202D20706F707065725B6D6561737572656D656E745D3B0A20207D0A202069662028706F707065725B6F70536964655D203E20666C6F6F72287265666572656E63655B736964655D2929207B0A20202020646174612E';
wwv_flow_api.g_varchar2_table(692) := '6F6666736574732E706F707065725B6F70536964655D203D20666C6F6F72287265666572656E63655B736964655D293B0A20207D0A0A202072657475726E20646174613B0A7D0A0A2F2A2A0A202A20436F6E7665727473206120737472696E6720636F6E';
wwv_flow_api.g_varchar2_table(693) := '7461696E696E672076616C7565202B20756E697420696E746F20612070782076616C7565206E756D6265720A202A204066756E6374696F6E0A202A20406D656D6265726F66207B6D6F646966696572737E6F66667365747D0A202A204070726976617465';
wwv_flow_api.g_varchar2_table(694) := '0A202A2040617267756D656E74207B537472696E677D20737472202D2056616C7565202B20756E697420737472696E670A202A2040617267756D656E74207B537472696E677D206D6561737572656D656E74202D206068656967687460206F7220607769';
wwv_flow_api.g_varchar2_table(695) := '647468600A202A2040617267756D656E74207B4F626A6563747D20706F707065724F6666736574730A202A2040617267756D656E74207B4F626A6563747D207265666572656E63654F6666736574730A202A204072657475726E73207B4E756D6265727C';
wwv_flow_api.g_varchar2_table(696) := '537472696E677D0A202A2056616C756520696E20706978656C732C206F72206F726967696E616C20737472696E67206966206E6F2076616C7565732077657265206578747261637465640A202A2F0A66756E6374696F6E20746F56616C7565287374722C';
wwv_flow_api.g_varchar2_table(697) := '206D6561737572656D656E742C20706F707065724F6666736574732C207265666572656E63654F66667365747329207B0A20202F2F2073657061726174652076616C75652066726F6D20756E69740A20207661722073706C6974203D207374722E6D6174';
wwv_flow_api.g_varchar2_table(698) := '6368282F28283F3A5C2D7C5C2B293F5C642A5C2E3F5C642A29282E2A292F293B0A20207661722076616C7565203D202B73706C69745B315D3B0A202076617220756E6974203D2073706C69745B325D3B0A0A20202F2F2049662069742773206E6F742061';
wwv_flow_api.g_varchar2_table(699) := '206E756D626572206974277320616E206F70657261746F722C20492067756573730A2020696620282176616C756529207B0A2020202072657475726E207374723B0A20207D0A0A202069662028756E69742E696E6465784F662827252729203D3D3D2030';
wwv_flow_api.g_varchar2_table(700) := '29207B0A2020202076617220656C656D656E74203D20766F696420303B0A202020207377697463682028756E697429207B0A2020202020206361736520272570273A0A2020202020202020656C656D656E74203D20706F707065724F6666736574733B0A';
wwv_flow_api.g_varchar2_table(701) := '2020202020202020627265616B3B0A20202020202063617365202725273A0A2020202020206361736520272572273A0A20202020202064656661756C743A0A2020202020202020656C656D656E74203D207265666572656E63654F6666736574733B0A20';
wwv_flow_api.g_varchar2_table(702) := '2020207D0A0A202020207661722072656374203D20676574436C69656E745265637428656C656D656E74293B0A2020202072657475726E20726563745B6D6561737572656D656E745D202F20313030202A2076616C75653B0A20207D20656C7365206966';
wwv_flow_api.g_varchar2_table(703) := '2028756E6974203D3D3D2027766827207C7C20756E6974203D3D3D202776772729207B0A202020202F2F2069662069732061207668206F722076772C2077652063616C63756C617465207468652073697A65206261736564206F6E207468652076696577';
wwv_flow_api.g_varchar2_table(704) := '706F72740A202020207661722073697A65203D20766F696420303B0A2020202069662028756E6974203D3D3D202776682729207B0A20202020202073697A65203D204D6174682E6D617828646F63756D656E742E646F63756D656E74456C656D656E742E';
wwv_flow_api.g_varchar2_table(705) := '636C69656E744865696768742C2077696E646F772E696E6E6572486569676874207C7C2030293B0A202020207D20656C7365207B0A20202020202073697A65203D204D6174682E6D617828646F63756D656E742E646F63756D656E74456C656D656E742E';
wwv_flow_api.g_varchar2_table(706) := '636C69656E7457696474682C2077696E646F772E696E6E65725769647468207C7C2030293B0A202020207D0A2020202072657475726E2073697A65202F20313030202A2076616C75653B0A20207D20656C7365207B0A202020202F2F2069662069732061';
wwv_flow_api.g_varchar2_table(707) := '6E206578706C6963697420706978656C20756E69742C2077652067657420726964206F662074686520756E697420616E64206B656570207468652076616C75650A202020202F2F20696620697320616E20696D706C6963697420756E69742C2069742773';
wwv_flow_api.g_varchar2_table(708) := '2070782C20616E642077652072657475726E206A757374207468652076616C75650A2020202072657475726E2076616C75653B0A20207D0A7D0A0A2F2A2A0A202A20506172736520616E20606F66667365746020737472696E6720746F20657874726170';
wwv_flow_api.g_varchar2_table(709) := '6F6C6174652060786020616E6420607960206E756D65726963206F6666736574732E0A202A204066756E6374696F6E0A202A20406D656D6265726F66207B6D6F646966696572737E6F66667365747D0A202A2040707269766174650A202A204061726775';
wwv_flow_api.g_varchar2_table(710) := '6D656E74207B537472696E677D206F66667365740A202A2040617267756D656E74207B4F626A6563747D20706F707065724F6666736574730A202A2040617267756D656E74207B4F626A6563747D207265666572656E63654F6666736574730A202A2040';
wwv_flow_api.g_varchar2_table(711) := '617267756D656E74207B537472696E677D2062617365506C6163656D656E740A202A204072657475726E73207B41727261797D20612074776F2063656C6C732061727261792077697468207820616E642079206F66667365747320696E206E756D626572';
wwv_flow_api.g_varchar2_table(712) := '730A202A2F0A66756E6374696F6E2070617273654F6666736574286F66667365742C20706F707065724F6666736574732C207265666572656E63654F6666736574732C2062617365506C6163656D656E7429207B0A2020766172206F666673657473203D';
wwv_flow_api.g_varchar2_table(713) := '205B302C20305D3B0A0A20202F2F205573652068656967687420696620706C6163656D656E74206973206C656674206F7220726967687420616E6420696E6465782069732030206F7468657277697365207573652077696474680A20202F2F20696E2074';
wwv_flow_api.g_varchar2_table(714) := '6869732077617920746865206669727374206F66667365742077696C6C2075736520616E206178697320616E6420746865207365636F6E64206F6E650A20202F2F2077696C6C2075736520746865206F74686572206F6E650A2020766172207573654865';
wwv_flow_api.g_varchar2_table(715) := '69676874203D205B277269676874272C20276C656674275D2E696E6465784F662862617365506C6163656D656E742920213D3D202D313B0A0A20202F2F2053706C697420746865206F666673657420737472696E6720746F206F627461696E2061206C69';
wwv_flow_api.g_varchar2_table(716) := '7374206F662076616C75657320616E64206F706572616E64730A20202F2F20546865207265676578206164647265737365732076616C75657320776974682074686520706C7573206F72206D696E7573207369676E20696E2066726F6E7420282B31302C';
wwv_flow_api.g_varchar2_table(717) := '202D32302C20657463290A202076617220667261676D656E7473203D206F66667365742E73706C6974282F285C2B7C5C2D292F292E6D61702866756E6374696F6E20286672616729207B0A2020202072657475726E20667261672E7472696D28293B0A20';
wwv_flow_api.g_varchar2_table(718) := '207D293B0A0A20202F2F2044657465637420696620746865206F666673657420737472696E6720636F6E7461696E7320612070616972206F662076616C756573206F7220612073696E676C65206F6E650A20202F2F207468657920636F756C6420626520';
wwv_flow_api.g_varchar2_table(719) := '73657061726174656420627920636F6D6D61206F722073706163650A20207661722064697669646572203D20667261676D656E74732E696E6465784F662866696E6428667261676D656E74732C2066756E6374696F6E20286672616729207B0A20202020';
wwv_flow_api.g_varchar2_table(720) := '72657475726E20667261672E736561726368282F2C7C5C732F2920213D3D202D313B0A20207D29293B0A0A202069662028667261676D656E74735B646976696465725D20262620667261676D656E74735B646976696465725D2E696E6465784F6628272C';
wwv_flow_api.g_varchar2_table(721) := '2729203D3D3D202D3129207B0A20202020636F6E736F6C652E7761726E28274F666673657473207365706172617465642062792077686974652073706163652873292061726520646570726563617465642C20757365206120636F6D6D6120282C292069';
wwv_flow_api.g_varchar2_table(722) := '6E73746561642E27293B0A20207D0A0A20202F2F204966206469766964657220697320666F756E642C2077652064697669646520746865206C697374206F662076616C75657320616E64206F706572616E647320746F206469766964650A20202F2F2074';
wwv_flow_api.g_varchar2_table(723) := '68656D206279206F66736574205820616E6420592E0A20207661722073706C69745265676578203D202F5C732A2C5C732A7C5C732B2F3B0A2020766172206F7073203D206469766964657220213D3D202D31203F205B667261676D656E74732E736C6963';
wwv_flow_api.g_varchar2_table(724) := '6528302C2064697669646572292E636F6E636174285B667261676D656E74735B646976696465725D2E73706C69742873706C69745265676578295B305D5D292C205B667261676D656E74735B646976696465725D2E73706C69742873706C697452656765';
wwv_flow_api.g_varchar2_table(725) := '78295B315D5D2E636F6E63617428667261676D656E74732E736C6963652864697669646572202B203129295D203A205B667261676D656E74735D3B0A0A20202F2F20436F6E76657274207468652076616C756573207769746820756E69747320746F2061';
wwv_flow_api.g_varchar2_table(726) := '62736F6C75746520706978656C7320746F20616C6C6F77206F757220636F6D7075746174696F6E730A20206F7073203D206F70732E6D61702866756E6374696F6E20286F702C20696E64657829207B0A202020202F2F204D6F7374206F66207468652075';
wwv_flow_api.g_varchar2_table(727) := '6E6974732072656C79206F6E20746865206F7269656E746174696F6E206F662074686520706F707065720A20202020766172206D6561737572656D656E74203D2028696E646578203D3D3D2031203F2021757365486569676874203A2075736548656967';
wwv_flow_api.g_varchar2_table(728) := '687429203F202768656967687427203A20277769647468273B0A20202020766172206D657267655769746850726576696F7573203D2066616C73653B0A2020202072657475726E206F700A202020202F2F2054686973206167677265676174657320616E';
wwv_flow_api.g_varchar2_table(729) := '7920602B60206F7220602D60207369676E2074686174206172656E277420636F6E73696465726564206F70657261746F72730A202020202F2F20652E672E3A203130202B202B35203D3E205B31302C202B2C202B355D0A202020202E7265647563652866';
wwv_flow_api.g_varchar2_table(730) := '756E6374696F6E2028612C206229207B0A20202020202069662028615B612E6C656E677468202D20315D203D3D3D202727202626205B272B272C20272D275D2E696E6465784F6628622920213D3D202D3129207B0A2020202020202020615B612E6C656E';
wwv_flow_api.g_varchar2_table(731) := '677468202D20315D203D20623B0A20202020202020206D657267655769746850726576696F7573203D20747275653B0A202020202020202072657475726E20613B0A2020202020207D20656C736520696620286D657267655769746850726576696F7573';
wwv_flow_api.g_varchar2_table(732) := '29207B0A2020202020202020615B612E6C656E677468202D20315D202B3D20623B0A20202020202020206D657267655769746850726576696F7573203D2066616C73653B0A202020202020202072657475726E20613B0A2020202020207D20656C736520';
wwv_flow_api.g_varchar2_table(733) := '7B0A202020202020202072657475726E20612E636F6E6361742862293B0A2020202020207D0A202020207D2C205B5D290A202020202F2F204865726520776520636F6E766572742074686520737472696E672076616C75657320696E746F206E756D6265';
wwv_flow_api.g_varchar2_table(734) := '722076616C7565732028696E207078290A202020202E6D61702866756E6374696F6E202873747229207B0A20202020202072657475726E20746F56616C7565287374722C206D6561737572656D656E742C20706F707065724F6666736574732C20726566';
wwv_flow_api.g_varchar2_table(735) := '6572656E63654F666673657473293B0A202020207D293B0A20207D293B0A0A20202F2F204C6F6F702074726F75676820746865206F6666736574732061727261797320616E64206578656375746520746865206F7065726174696F6E730A20206F70732E';
wwv_flow_api.g_varchar2_table(736) := '666F72456163682866756E6374696F6E20286F702C20696E64657829207B0A202020206F702E666F72456163682866756E6374696F6E2028667261672C20696E6465783229207B0A2020202020206966202869734E756D6572696328667261672929207B';
wwv_flow_api.g_varchar2_table(737) := '0A20202020202020206F6666736574735B696E6465785D202B3D2066726167202A20286F705B696E64657832202D20315D203D3D3D20272D27203F202D31203A2031293B0A2020202020207D0A202020207D293B0A20207D293B0A202072657475726E20';
wwv_flow_api.g_varchar2_table(738) := '6F6666736574733B0A7D0A0A2F2A2A0A202A204066756E6374696F6E0A202A20406D656D6265726F66204D6F646966696572730A202A2040617267756D656E74207B4F626A6563747D2064617461202D205468652064617461206F626A6563742067656E';
wwv_flow_api.g_varchar2_table(739) := '65726174656420627920757064617465206D6574686F640A202A2040617267756D656E74207B4F626A6563747D206F7074696F6E73202D204D6F6469666965727320636F6E66696775726174696F6E20616E64206F7074696F6E730A202A204061726775';
wwv_flow_api.g_varchar2_table(740) := '6D656E74207B4E756D6265727C537472696E677D206F7074696F6E732E6F66667365743D300A202A20546865206F66667365742076616C75652061732064657363726962656420696E20746865206D6F646966696572206465736372697074696F6E0A20';
wwv_flow_api.g_varchar2_table(741) := '2A204072657475726E73207B4F626A6563747D205468652064617461206F626A6563742C2070726F7065726C79206D6F6469666965640A202A2F0A66756E6374696F6E206F666673657428646174612C205F72656629207B0A2020766172206F66667365';
wwv_flow_api.g_varchar2_table(742) := '74203D205F7265662E6F66667365743B0A202076617220706C6163656D656E74203D20646174612E706C6163656D656E742C0A2020202020205F64617461246F666673657473203D20646174612E6F6666736574732C0A202020202020706F7070657220';
wwv_flow_api.g_varchar2_table(743) := '3D205F64617461246F6666736574732E706F707065722C0A2020202020207265666572656E6365203D205F64617461246F6666736574732E7265666572656E63653B0A0A20207661722062617365506C6163656D656E74203D20706C6163656D656E742E';
wwv_flow_api.g_varchar2_table(744) := '73706C697428272D27295B305D3B0A0A2020766172206F666673657473203D20766F696420303B0A20206966202869734E756D65726963282B6F66667365742929207B0A202020206F666673657473203D205B2B6F66667365742C20305D3B0A20207D20';
wwv_flow_api.g_varchar2_table(745) := '656C7365207B0A202020206F666673657473203D2070617273654F6666736574286F66667365742C20706F707065722C207265666572656E63652C2062617365506C6163656D656E74293B0A20207D0A0A20206966202862617365506C6163656D656E74';
wwv_flow_api.g_varchar2_table(746) := '203D3D3D20276C6566742729207B0A20202020706F707065722E746F70202B3D206F6666736574735B305D3B0A20202020706F707065722E6C656674202D3D206F6666736574735B315D3B0A20207D20656C7365206966202862617365506C6163656D65';
wwv_flow_api.g_varchar2_table(747) := '6E74203D3D3D202772696768742729207B0A20202020706F707065722E746F70202B3D206F6666736574735B305D3B0A20202020706F707065722E6C656674202B3D206F6666736574735B315D3B0A20207D20656C7365206966202862617365506C6163';
wwv_flow_api.g_varchar2_table(748) := '656D656E74203D3D3D2027746F702729207B0A20202020706F707065722E6C656674202B3D206F6666736574735B305D3B0A20202020706F707065722E746F70202D3D206F6666736574735B315D3B0A20207D20656C7365206966202862617365506C61';
wwv_flow_api.g_varchar2_table(749) := '63656D656E74203D3D3D2027626F74746F6D2729207B0A20202020706F707065722E6C656674202B3D206F6666736574735B305D3B0A20202020706F707065722E746F70202B3D206F6666736574735B315D3B0A20207D0A0A2020646174612E706F7070';
wwv_flow_api.g_varchar2_table(750) := '6572203D20706F707065723B0A202072657475726E20646174613B0A7D0A0A2F2A2A0A202A204066756E6374696F6E0A202A20406D656D6265726F66204D6F646966696572730A202A2040617267756D656E74207B4F626A6563747D2064617461202D20';
wwv_flow_api.g_varchar2_table(751) := '5468652064617461206F626A6563742067656E657261746564206279206075706461746560206D6574686F640A202A2040617267756D656E74207B4F626A6563747D206F7074696F6E73202D204D6F6469666965727320636F6E66696775726174696F6E';
wwv_flow_api.g_varchar2_table(752) := '20616E64206F7074696F6E730A202A204072657475726E73207B4F626A6563747D205468652064617461206F626A6563742C2070726F7065726C79206D6F6469666965640A202A2F0A66756E6374696F6E2070726576656E744F766572666C6F77286461';
wwv_flow_api.g_varchar2_table(753) := '74612C206F7074696F6E7329207B0A202076617220626F756E646172696573456C656D656E74203D206F7074696F6E732E626F756E646172696573456C656D656E74207C7C206765744F6666736574506172656E7428646174612E696E7374616E63652E';
wwv_flow_api.g_varchar2_table(754) := '706F70706572293B0A0A20202F2F204966206F6666736574506172656E7420697320746865207265666572656E636520656C656D656E742C207765207265616C6C792077616E7420746F0A20202F2F20676F206F6E65207374657020757020616E642075';
wwv_flow_api.g_varchar2_table(755) := '736520746865206E657874206F6666736574506172656E74206173207265666572656E636520746F0A20202F2F2061766F696420746F206D616B652074686973206D6F64696669657220636F6D706C6574656C79207573656C65737320616E64206C6F6F';
wwv_flow_api.g_varchar2_table(756) := '6B206C696B652062726F6B656E0A202069662028646174612E696E7374616E63652E7265666572656E6365203D3D3D20626F756E646172696573456C656D656E7429207B0A20202020626F756E646172696573456C656D656E74203D206765744F666673';
wwv_flow_api.g_varchar2_table(757) := '6574506172656E7428626F756E646172696573456C656D656E74293B0A20207D0A0A20202F2F204E4F54453A20444F4D2061636365737320686572650A20202F2F207265736574732074686520706F70706572277320706F736974696F6E20736F207468';
wwv_flow_api.g_varchar2_table(758) := '61742074686520646F63756D656E742073697A652063616E2062652063616C63756C61746564206578636C7564696E670A20202F2F207468652073697A65206F662074686520706F7070657220656C656D656E7420697473656C660A2020766172207472';
wwv_flow_api.g_varchar2_table(759) := '616E73666F726D50726F70203D20676574537570706F7274656450726F70657274794E616D6528277472616E73666F726D27293B0A202076617220706F707065725374796C6573203D20646174612E696E7374616E63652E706F707065722E7374796C65';
wwv_flow_api.g_varchar2_table(760) := '3B202F2F2061737369676E6D656E7420746F2068656C70206D696E696669636174696F6E0A202076617220746F70203D20706F707065725374796C65732E746F702C0A2020202020206C656674203D20706F707065725374796C65732E6C6566742C0A20';
wwv_flow_api.g_varchar2_table(761) := '20202020207472616E73666F726D203D20706F707065725374796C65735B7472616E73666F726D50726F705D3B0A0A2020706F707065725374796C65732E746F70203D2027273B0A2020706F707065725374796C65732E6C656674203D2027273B0A2020';
wwv_flow_api.g_varchar2_table(762) := '706F707065725374796C65735B7472616E73666F726D50726F705D203D2027273B0A0A202076617220626F756E646172696573203D20676574426F756E64617269657328646174612E696E7374616E63652E706F707065722C20646174612E696E737461';
wwv_flow_api.g_varchar2_table(763) := '6E63652E7265666572656E63652C206F7074696F6E732E70616464696E672C20626F756E646172696573456C656D656E742C20646174612E706F736974696F6E4669786564293B0A0A20202F2F204E4F54453A20444F4D2061636365737320686572650A';
wwv_flow_api.g_varchar2_table(764) := '20202F2F20726573746F72657320746865206F726967696E616C207374796C652070726F7065727469657320616674657220746865206F6666736574732068617665206265656E20636F6D70757465640A2020706F707065725374796C65732E746F7020';
wwv_flow_api.g_varchar2_table(765) := '3D20746F703B0A2020706F707065725374796C65732E6C656674203D206C6566743B0A2020706F707065725374796C65735B7472616E73666F726D50726F705D203D207472616E73666F726D3B0A0A20206F7074696F6E732E626F756E64617269657320';
wwv_flow_api.g_varchar2_table(766) := '3D20626F756E6461726965733B0A0A2020766172206F72646572203D206F7074696F6E732E7072696F726974793B0A202076617220706F70706572203D20646174612E6F6666736574732E706F707065723B0A0A202076617220636865636B203D207B0A';
wwv_flow_api.g_varchar2_table(767) := '202020207072696D6172793A2066756E6374696F6E207072696D61727928706C6163656D656E7429207B0A2020202020207661722076616C7565203D20706F707065725B706C6163656D656E745D3B0A20202020202069662028706F707065725B706C61';
wwv_flow_api.g_varchar2_table(768) := '63656D656E745D203C20626F756E6461726965735B706C6163656D656E745D20262620216F7074696F6E732E657363617065576974685265666572656E636529207B0A202020202020202076616C7565203D204D6174682E6D617828706F707065725B70';
wwv_flow_api.g_varchar2_table(769) := '6C6163656D656E745D2C20626F756E6461726965735B706C6163656D656E745D293B0A2020202020207D0A20202020202072657475726E20646566696E6550726F7065727479287B7D2C20706C6163656D656E742C2076616C7565293B0A202020207D2C';
wwv_flow_api.g_varchar2_table(770) := '0A202020207365636F6E646172793A2066756E6374696F6E207365636F6E6461727928706C6163656D656E7429207B0A202020202020766172206D61696E53696465203D20706C6163656D656E74203D3D3D2027726967687427203F20276C6566742720';
wwv_flow_api.g_varchar2_table(771) := '3A2027746F70273B0A2020202020207661722076616C7565203D20706F707065725B6D61696E536964655D3B0A20202020202069662028706F707065725B706C6163656D656E745D203E20626F756E6461726965735B706C6163656D656E745D20262620';
wwv_flow_api.g_varchar2_table(772) := '216F7074696F6E732E657363617065576974685265666572656E636529207B0A202020202020202076616C7565203D204D6174682E6D696E28706F707065725B6D61696E536964655D2C20626F756E6461726965735B706C6163656D656E745D202D2028';
wwv_flow_api.g_varchar2_table(773) := '706C6163656D656E74203D3D3D2027726967687427203F20706F707065722E7769647468203A20706F707065722E68656967687429293B0A2020202020207D0A20202020202072657475726E20646566696E6550726F7065727479287B7D2C206D61696E';
wwv_flow_api.g_varchar2_table(774) := '536964652C2076616C7565293B0A202020207D0A20207D3B0A0A20206F726465722E666F72456163682866756E6374696F6E2028706C6163656D656E7429207B0A202020207661722073696465203D205B276C656674272C2027746F70275D2E696E6465';
wwv_flow_api.g_varchar2_table(775) := '784F6628706C6163656D656E742920213D3D202D31203F20277072696D61727927203A20277365636F6E64617279273B0A20202020706F70706572203D205F657874656E6473287B7D2C20706F707065722C20636865636B5B736964655D28706C616365';
wwv_flow_api.g_varchar2_table(776) := '6D656E7429293B0A20207D293B0A0A2020646174612E6F6666736574732E706F70706572203D20706F707065723B0A0A202072657475726E20646174613B0A7D0A0A2F2A2A0A202A204066756E6374696F6E0A202A20406D656D6265726F66204D6F6469';
wwv_flow_api.g_varchar2_table(777) := '66696572730A202A2040617267756D656E74207B4F626A6563747D2064617461202D205468652064617461206F626A6563742067656E657261746564206279206075706461746560206D6574686F640A202A2040617267756D656E74207B4F626A656374';
wwv_flow_api.g_varchar2_table(778) := '7D206F7074696F6E73202D204D6F6469666965727320636F6E66696775726174696F6E20616E64206F7074696F6E730A202A204072657475726E73207B4F626A6563747D205468652064617461206F626A6563742C2070726F7065726C79206D6F646966';
wwv_flow_api.g_varchar2_table(779) := '6965640A202A2F0A66756E6374696F6E207368696674286461746129207B0A202076617220706C6163656D656E74203D20646174612E706C6163656D656E743B0A20207661722062617365506C6163656D656E74203D20706C6163656D656E742E73706C';
wwv_flow_api.g_varchar2_table(780) := '697428272D27295B305D3B0A2020766172207368696674766172696174696F6E203D20706C6163656D656E742E73706C697428272D27295B315D3B0A0A20202F2F206966207368696674207368696674766172696174696F6E2069732073706563696669';
wwv_flow_api.g_varchar2_table(781) := '65642C2072756E20746865206D6F6469666965720A2020696620287368696674766172696174696F6E29207B0A20202020766172205F64617461246F666673657473203D20646174612E6F6666736574732C0A20202020202020207265666572656E6365';
wwv_flow_api.g_varchar2_table(782) := '203D205F64617461246F6666736574732E7265666572656E63652C0A2020202020202020706F70706572203D205F64617461246F6666736574732E706F707065723B0A0A20202020766172206973566572746963616C203D205B27626F74746F6D272C20';
wwv_flow_api.g_varchar2_table(783) := '27746F70275D2E696E6465784F662862617365506C6163656D656E742920213D3D202D313B0A202020207661722073696465203D206973566572746963616C203F20276C65667427203A2027746F70273B0A20202020766172206D6561737572656D656E';
wwv_flow_api.g_varchar2_table(784) := '74203D206973566572746963616C203F2027776964746827203A2027686569676874273B0A0A202020207661722073686966744F666673657473203D207B0A20202020202073746172743A20646566696E6550726F7065727479287B7D2C20736964652C';
wwv_flow_api.g_varchar2_table(785) := '207265666572656E63655B736964655D292C0A202020202020656E643A20646566696E6550726F7065727479287B7D2C20736964652C207265666572656E63655B736964655D202B207265666572656E63655B6D6561737572656D656E745D202D20706F';
wwv_flow_api.g_varchar2_table(786) := '707065725B6D6561737572656D656E745D290A202020207D3B0A0A20202020646174612E6F6666736574732E706F70706572203D205F657874656E6473287B7D2C20706F707065722C2073686966744F6666736574735B7368696674766172696174696F';
wwv_flow_api.g_varchar2_table(787) := '6E5D293B0A20207D0A0A202072657475726E20646174613B0A7D0A0A2F2A2A0A202A204066756E6374696F6E0A202A20406D656D6265726F66204D6F646966696572730A202A2040617267756D656E74207B4F626A6563747D2064617461202D20546865';
wwv_flow_api.g_varchar2_table(788) := '2064617461206F626A6563742067656E65726174656420627920757064617465206D6574686F640A202A2040617267756D656E74207B4F626A6563747D206F7074696F6E73202D204D6F6469666965727320636F6E66696775726174696F6E20616E6420';
wwv_flow_api.g_varchar2_table(789) := '6F7074696F6E730A202A204072657475726E73207B4F626A6563747D205468652064617461206F626A6563742C2070726F7065726C79206D6F6469666965640A202A2F0A66756E6374696F6E2068696465286461746129207B0A2020696620282169734D';
wwv_flow_api.g_varchar2_table(790) := '6F646966696572526571756972656428646174612E696E7374616E63652E6D6F646966696572732C202768696465272C202770726576656E744F766572666C6F77272929207B0A2020202072657475726E20646174613B0A20207D0A0A20207661722072';
wwv_flow_api.g_varchar2_table(791) := '656652656374203D20646174612E6F6666736574732E7265666572656E63653B0A202076617220626F756E64203D2066696E6428646174612E696E7374616E63652E6D6F646966696572732C2066756E6374696F6E20286D6F64696669657229207B0A20';
wwv_flow_api.g_varchar2_table(792) := '20202072657475726E206D6F6469666965722E6E616D65203D3D3D202770726576656E744F766572666C6F77273B0A20207D292E626F756E6461726965733B0A0A202069662028726566526563742E626F74746F6D203C20626F756E642E746F70207C7C';
wwv_flow_api.g_varchar2_table(793) := '20726566526563742E6C656674203E20626F756E642E7269676874207C7C20726566526563742E746F70203E20626F756E642E626F74746F6D207C7C20726566526563742E7269676874203C20626F756E642E6C65667429207B0A202020202F2F204176';
wwv_flow_api.g_varchar2_table(794) := '6F696420756E6E656365737361727920444F4D20616363657373206966207669736962696C697479206861736E2774206368616E6765640A2020202069662028646174612E68696465203D3D3D207472756529207B0A20202020202072657475726E2064';
wwv_flow_api.g_varchar2_table(795) := '6174613B0A202020207D0A0A20202020646174612E68696465203D20747275653B0A20202020646174612E617474726962757465735B27782D6F75742D6F662D626F756E646172696573275D203D2027273B0A20207D20656C7365207B0A202020202F2F';
wwv_flow_api.g_varchar2_table(796) := '2041766F696420756E6E656365737361727920444F4D20616363657373206966207669736962696C697479206861736E2774206368616E6765640A2020202069662028646174612E68696465203D3D3D2066616C736529207B0A20202020202072657475';
wwv_flow_api.g_varchar2_table(797) := '726E20646174613B0A202020207D0A0A20202020646174612E68696465203D2066616C73653B0A20202020646174612E617474726962757465735B27782D6F75742D6F662D626F756E646172696573275D203D2066616C73653B0A20207D0A0A20207265';
wwv_flow_api.g_varchar2_table(798) := '7475726E20646174613B0A7D0A0A2F2A2A0A202A204066756E6374696F6E0A202A20406D656D6265726F66204D6F646966696572730A202A2040617267756D656E74207B4F626A6563747D2064617461202D205468652064617461206F626A6563742067';
wwv_flow_api.g_varchar2_table(799) := '656E657261746564206279206075706461746560206D6574686F640A202A2040617267756D656E74207B4F626A6563747D206F7074696F6E73202D204D6F6469666965727320636F6E66696775726174696F6E20616E64206F7074696F6E730A202A2040';
wwv_flow_api.g_varchar2_table(800) := '72657475726E73207B4F626A6563747D205468652064617461206F626A6563742C2070726F7065726C79206D6F6469666965640A202A2F0A66756E6374696F6E20696E6E6572286461746129207B0A202076617220706C6163656D656E74203D20646174';
wwv_flow_api.g_varchar2_table(801) := '612E706C6163656D656E743B0A20207661722062617365506C6163656D656E74203D20706C6163656D656E742E73706C697428272D27295B305D3B0A2020766172205F64617461246F666673657473203D20646174612E6F6666736574732C0A20202020';
wwv_flow_api.g_varchar2_table(802) := '2020706F70706572203D205F64617461246F6666736574732E706F707065722C0A2020202020207265666572656E6365203D205F64617461246F6666736574732E7265666572656E63653B0A0A2020766172206973486F72697A203D205B276C65667427';
wwv_flow_api.g_varchar2_table(803) := '2C20277269676874275D2E696E6465784F662862617365506C6163656D656E742920213D3D202D313B0A0A20207661722073756274726163744C656E677468203D205B27746F70272C20276C656674275D2E696E6465784F662862617365506C6163656D';
wwv_flow_api.g_varchar2_table(804) := '656E7429203D3D3D202D313B0A0A2020706F707065725B6973486F72697A203F20276C65667427203A2027746F70275D203D207265666572656E63655B62617365506C6163656D656E745D202D202873756274726163744C656E677468203F20706F7070';
wwv_flow_api.g_varchar2_table(805) := '65725B6973486F72697A203F2027776964746827203A2027686569676874275D203A2030293B0A0A2020646174612E706C6163656D656E74203D206765744F70706F73697465506C6163656D656E7428706C6163656D656E74293B0A2020646174612E6F';
wwv_flow_api.g_varchar2_table(806) := '6666736574732E706F70706572203D20676574436C69656E745265637428706F70706572293B0A0A202072657475726E20646174613B0A7D0A0A2F2A2A0A202A204D6F6469666965722066756E6374696F6E2C2065616368206D6F646966696572206361';
wwv_flow_api.g_varchar2_table(807) := '6E206861766520612066756E6374696F6E206F66207468697320747970652061737369676E65640A202A20746F206974732060666E602070726F70657274792E3C6272202F3E0A202A2054686573652066756E6374696F6E732077696C6C206265206361';
wwv_flow_api.g_varchar2_table(808) := '6C6C6564206F6E2065616368207570646174652C2074686973206D65616E73207468617420796F75206D7573740A202A206D616B65207375726520746865792061726520706572666F726D616E7420656E6F75676820746F2061766F696420706572666F';
wwv_flow_api.g_varchar2_table(809) := '726D616E636520626F74746C656E65636B732E0A202A0A202A204066756E6374696F6E204D6F646966696572466E0A202A2040617267756D656E74207B646174614F626A6563747D2064617461202D205468652064617461206F626A6563742067656E65';
wwv_flow_api.g_varchar2_table(810) := '7261746564206279206075706461746560206D6574686F640A202A2040617267756D656E74207B4F626A6563747D206F7074696F6E73202D204D6F6469666965727320636F6E66696775726174696F6E20616E64206F7074696F6E730A202A2040726574';
wwv_flow_api.g_varchar2_table(811) := '75726E73207B646174614F626A6563747D205468652064617461206F626A6563742C2070726F7065726C79206D6F6469666965640A202A2F0A0A2F2A2A0A202A204D6F646966696572732061726520706C7567696E73207573656420746F20616C746572';
wwv_flow_api.g_varchar2_table(812) := '20746865206265686176696F72206F6620796F757220706F70706572732E3C6272202F3E0A202A20506F707065722E6A732075736573206120736574206F662039206D6F6469666965727320746F2070726F7669646520616C6C20746865206261736963';
wwv_flow_api.g_varchar2_table(813) := '2066756E6374696F6E616C69746965730A202A206E656564656420627920746865206C6962726172792E0A202A0A202A20557375616C6C7920796F7520646F6E27742077616E7420746F206F766572726964652074686520606F72646572602C2060666E';
wwv_flow_api.g_varchar2_table(814) := '6020616E6420606F6E4C6F6164602070726F70732E0A202A20416C6C20746865206F746865722070726F706572746965732061726520636F6E66696775726174696F6E73207468617420636F756C6420626520747765616B65642E0A202A20406E616D65';
wwv_flow_api.g_varchar2_table(815) := '7370616365206D6F646966696572730A202A2F0A766172206D6F64696669657273203D207B0A20202F2A2A0A2020202A204D6F646966696572207573656420746F2073686966742074686520706F70706572206F6E20746865207374617274206F722065';
wwv_flow_api.g_varchar2_table(816) := '6E64206F6620697473207265666572656E63650A2020202A20656C656D656E742E3C6272202F3E0A2020202A2049742077696C6C20726561642074686520766172696174696F6E206F66207468652060706C6163656D656E74602070726F70657274792E';
wwv_flow_api.g_varchar2_table(817) := '3C6272202F3E0A2020202A2049742063616E206265206F6E652065697468657220602D656E6460206F7220602D7374617274602E0A2020202A20406D656D6265726F66206D6F646966696572730A2020202A2040696E6E65720A2020202A2F0A20207368';
wwv_flow_api.g_varchar2_table(818) := '6966743A207B0A202020202F2A2A204070726F70207B6E756D6265727D206F726465723D313030202D20496E646578207573656420746F20646566696E6520746865206F72646572206F6620657865637574696F6E202A2F0A202020206F726465723A20';
wwv_flow_api.g_varchar2_table(819) := '3130302C0A202020202F2A2A204070726F70207B426F6F6C65616E7D20656E61626C65643D74727565202D205768657468657220746865206D6F64696669657220697320656E61626C6564206F72206E6F74202A2F0A20202020656E61626C65643A2074';
wwv_flow_api.g_varchar2_table(820) := '7275652C0A202020202F2A2A204070726F70207B4D6F646966696572466E7D202A2F0A20202020666E3A2073686966740A20207D2C0A0A20202F2A2A0A2020202A2054686520606F666673657460206D6F6469666965722063616E20736869667420796F';
wwv_flow_api.g_varchar2_table(821) := '757220706F70706572206F6E20626F74682069747320617869732E0A2020202A0A2020202A20497420616363657074732074686520666F6C6C6F77696E6720756E6974733A0A2020202A202D2060707860206F7220756E69742D6C6573732C20696E7465';
wwv_flow_api.g_varchar2_table(822) := '7270726574656420617320706978656C730A2020202A202D20602560206F7220602572602C2070657263656E746167652072656C617469766520746F20746865206C656E677468206F6620746865207265666572656E636520656C656D656E740A202020';
wwv_flow_api.g_varchar2_table(823) := '2A202D20602570602C2070657263656E746167652072656C617469766520746F20746865206C656E677468206F662074686520706F7070657220656C656D656E740A2020202A202D20607677602C204353532076696577706F727420776964746820756E';
wwv_flow_api.g_varchar2_table(824) := '69740A2020202A202D20607668602C204353532076696577706F72742068656967687420756E69740A2020202A0A2020202A20466F72206C656E67746820697320696E74656E64656420746865206D61696E20617869732072656C617469766520746F20';
wwv_flow_api.g_varchar2_table(825) := '74686520706C6163656D656E74206F662074686520706F707065722E3C6272202F3E0A2020202A2054686973206D65616E7320746861742069662074686520706C6163656D656E742069732060746F7060206F722060626F74746F6D602C20746865206C';
wwv_flow_api.g_varchar2_table(826) := '656E6774682077696C6C206265207468650A2020202A20607769647468602E20496E2063617365206F6620606C65667460206F7220607269676874602C2069742077696C6C206265207468652060686569676874602E0A2020202A0A2020202A20596F75';
wwv_flow_api.g_varchar2_table(827) := '2063616E2070726F7669646520612073696E676C652076616C75652028617320604E756D62657260206F722060537472696E6760292C206F7220612070616972206F662076616C7565730A2020202A2061732060537472696E6760206469766964656420';
wwv_flow_api.g_varchar2_table(828) := '6279206120636F6D6D61206F72206F6E6520286F72206D6F726529207768697465207370616365732E3C6272202F3E0A2020202A20546865206C617474657220697320612064657072656361746564206D6574686F642062656361757365206974206C65';
wwv_flow_api.g_varchar2_table(829) := '61647320746F20636F6E667573696F6E20616E642077696C6C2062650A2020202A2072656D6F76656420696E2076322E3C6272202F3E0A2020202A204164646974696F6E616C6C792C2069742061636365707473206164646974696F6E7320616E642073';
wwv_flow_api.g_varchar2_table(830) := '75627472616374696F6E73206265747765656E20646966666572656E7420756E6974732E0A2020202A204E6F74652074686174206D756C7469706C69636174696F6E7320616E64206469766973696F6E73206172656E277420737570706F727465642E0A';
wwv_flow_api.g_varchar2_table(831) := '2020202A0A2020202A2056616C6964206578616D706C6573206172653A0A2020202A206060600A2020202A2031300A2020202A2027313025270A2020202A202731302C203130270A2020202A20273130252C203130270A2020202A20273130202B203130';
wwv_flow_api.g_varchar2_table(832) := '25270A2020202A20273130202D20357668202B203325270A2020202A20272D31307078202B203576682C20357078202D203625270A2020202A206060600A2020202A203E202A2A4E422A2A3A20496620796F752064657369726520746F206170706C7920';
wwv_flow_api.g_varchar2_table(833) := '6F66667365747320746F20796F757220706F707065727320696E2061207761792074686174206D6179206D616B65207468656D206F7665726C61700A2020202A203E2077697468207468656972207265666572656E636520656C656D656E742C20756E66';
wwv_flow_api.g_varchar2_table(834) := '6F7274756E6174656C792C20796F752077696C6C206861766520746F2064697361626C65207468652060666C697060206D6F6469666965722E0A2020202A203E20596F752063616E2072656164206D6F7265206F6E20746869732061742074686973205B';
wwv_flow_api.g_varchar2_table(835) := '69737375655D2868747470733A2F2F6769746875622E636F6D2F46657A5672617374612F706F707065722E6A732F6973737565732F333733292E0A2020202A0A2020202A20406D656D6265726F66206D6F646966696572730A2020202A2040696E6E6572';
wwv_flow_api.g_varchar2_table(836) := '0A2020202A2F0A20206F66667365743A207B0A202020202F2A2A204070726F70207B6E756D6265727D206F726465723D323030202D20496E646578207573656420746F20646566696E6520746865206F72646572206F6620657865637574696F6E202A2F';
wwv_flow_api.g_varchar2_table(837) := '0A202020206F726465723A203230302C0A202020202F2A2A204070726F70207B426F6F6C65616E7D20656E61626C65643D74727565202D205768657468657220746865206D6F64696669657220697320656E61626C6564206F72206E6F74202A2F0A2020';
wwv_flow_api.g_varchar2_table(838) := '2020656E61626C65643A20747275652C0A202020202F2A2A204070726F70207B4D6F646966696572466E7D202A2F0A20202020666E3A206F66667365742C0A202020202F2A2A204070726F70207B4E756D6265727C537472696E677D206F66667365743D';
wwv_flow_api.g_varchar2_table(839) := '300A20202020202A20546865206F66667365742076616C75652061732064657363726962656420696E20746865206D6F646966696572206465736372697074696F6E0A20202020202A2F0A202020206F66667365743A20300A20207D2C0A0A20202F2A2A';
wwv_flow_api.g_varchar2_table(840) := '0A2020202A204D6F646966696572207573656420746F2070726576656E742074686520706F707065722066726F6D206265696E6720706F736974696F6E6564206F7574736964652074686520626F756E646172792E0A2020202A0A2020202A2041207363';
wwv_flow_api.g_varchar2_table(841) := '656E6172696F2065786973747320776865726520746865207265666572656E636520697473656C66206973206E6F742077697468696E2074686520626F756E6461726965732E3C6272202F3E0A2020202A2057652063616E207361792069742068617320';
wwv_flow_api.g_varchar2_table(842) := '22657363617065642074686520626F756E6461726965732220E28094206F72206A757374202265736361706564222E3C6272202F3E0A2020202A20496E20746869732063617365207765206E65656420746F206465636964652077686574686572207468';
wwv_flow_api.g_varchar2_table(843) := '6520706F707065722073686F756C64206569746865723A0A2020202A0A2020202A202D206465746163682066726F6D20746865207265666572656E636520616E642072656D61696E2022747261707065642220696E2074686520626F756E646172696573';
wwv_flow_api.g_varchar2_table(844) := '2C206F720A2020202A202D2069662069742073686F756C642069676E6F72652074686520626F756E6461727920616E642022657363617065207769746820697473207265666572656E6365220A2020202A0A2020202A205768656E206065736361706557';
wwv_flow_api.g_varchar2_table(845) := '6974685265666572656E6365602069732073657420746F60747275656020616E64207265666572656E636520697320636F6D706C6574656C790A2020202A206F7574736964652069747320626F756E6461726965732C2074686520706F70706572207769';
wwv_flow_api.g_varchar2_table(846) := '6C6C206F766572666C6F7720286F7220636F6D706C6574656C79206C65617665290A2020202A2074686520626F756E64617269657320696E206F7264657220746F2072656D61696E20617474616368656420746F207468652065646765206F6620746865';
wwv_flow_api.g_varchar2_table(847) := '207265666572656E63652E0A2020202A0A2020202A20406D656D6265726F66206D6F646966696572730A2020202A2040696E6E65720A2020202A2F0A202070726576656E744F766572666C6F773A207B0A202020202F2A2A204070726F70207B6E756D62';
wwv_flow_api.g_varchar2_table(848) := '65727D206F726465723D333030202D20496E646578207573656420746F20646566696E6520746865206F72646572206F6620657865637574696F6E202A2F0A202020206F726465723A203330302C0A202020202F2A2A204070726F70207B426F6F6C6561';
wwv_flow_api.g_varchar2_table(849) := '6E7D20656E61626C65643D74727565202D205768657468657220746865206D6F64696669657220697320656E61626C6564206F72206E6F74202A2F0A20202020656E61626C65643A20747275652C0A202020202F2A2A204070726F70207B4D6F64696669';
wwv_flow_api.g_varchar2_table(850) := '6572466E7D202A2F0A20202020666E3A2070726576656E744F766572666C6F772C0A202020202F2A2A0A20202020202A204070726F70207B41727261797D205B7072696F726974793D5B276C656674272C277269676874272C27746F70272C27626F7474';
wwv_flow_api.g_varchar2_table(851) := '6F6D275D5D0A20202020202A20506F707065722077696C6C2074727920746F2070726576656E74206F766572666C6F7720666F6C6C6F77696E67207468657365207072696F7269746965732062792064656661756C742C0A20202020202A207468656E2C';
wwv_flow_api.g_varchar2_table(852) := '20697420636F756C64206F766572666C6F77206F6E20746865206C65667420616E64206F6E20746F70206F66207468652060626F756E646172696573456C656D656E74600A20202020202A2F0A202020207072696F726974793A205B276C656674272C20';
wwv_flow_api.g_varchar2_table(853) := '277269676874272C2027746F70272C2027626F74746F6D275D2C0A202020202F2A2A0A20202020202A204070726F70207B6E756D6265727D2070616464696E673D350A20202020202A20416D6F756E74206F6620706978656C207573656420746F206465';
wwv_flow_api.g_varchar2_table(854) := '66696E652061206D696E696D756D2064697374616E6365206265747765656E2074686520626F756E6461726965730A20202020202A20616E642074686520706F707065722E2054686973206D616B657320737572652074686520706F7070657220616C77';
wwv_flow_api.g_varchar2_table(855) := '617973206861732061206C6974746C652070616464696E670A20202020202A206265747765656E20746865206564676573206F662069747320636F6E7461696E65720A20202020202A2F0A2020202070616464696E673A20352C0A202020202F2A2A0A20';
wwv_flow_api.g_varchar2_table(856) := '202020202A204070726F70207B537472696E677C48544D4C456C656D656E747D20626F756E646172696573456C656D656E743D277363726F6C6C506172656E74270A20202020202A20426F756E646172696573207573656420627920746865206D6F6469';
wwv_flow_api.g_varchar2_table(857) := '666965722E2043616E20626520607363726F6C6C506172656E74602C206077696E646F77602C0A20202020202A206076696577706F727460206F7220616E7920444F4D20656C656D656E742E0A20202020202A2F0A20202020626F756E64617269657345';
wwv_flow_api.g_varchar2_table(858) := '6C656D656E743A20277363726F6C6C506172656E74270A20207D2C0A0A20202F2A2A0A2020202A204D6F646966696572207573656420746F206D616B65207375726520746865207265666572656E636520616E642069747320706F707065722073746179';
wwv_flow_api.g_varchar2_table(859) := '206E6561722065616368206F746865720A2020202A20776974686F7574206C656176696E6720616E7920676170206265747765656E207468652074776F2E20457370656369616C6C792075736566756C207768656E20746865206172726F772069730A20';
wwv_flow_api.g_varchar2_table(860) := '20202A20656E61626C656420616E6420796F752077616E7420746F20656E73757265207468617420697420706F696E747320746F20697473207265666572656E636520656C656D656E742E0A2020202A204974206361726573206F6E6C792061626F7574';
wwv_flow_api.g_varchar2_table(861) := '2074686520666972737420617869732E20596F752063616E207374696C6C206861766520706F70706572732077697468206D617267696E0A2020202A206265747765656E2074686520706F7070657220616E6420697473207265666572656E636520656C';
wwv_flow_api.g_varchar2_table(862) := '656D656E742E0A2020202A20406D656D6265726F66206D6F646966696572730A2020202A2040696E6E65720A2020202A2F0A20206B656570546F6765746865723A207B0A202020202F2A2A204070726F70207B6E756D6265727D206F726465723D343030';
wwv_flow_api.g_varchar2_table(863) := '202D20496E646578207573656420746F20646566696E6520746865206F72646572206F6620657865637574696F6E202A2F0A202020206F726465723A203430302C0A202020202F2A2A204070726F70207B426F6F6C65616E7D20656E61626C65643D7472';
wwv_flow_api.g_varchar2_table(864) := '7565202D205768657468657220746865206D6F64696669657220697320656E61626C6564206F72206E6F74202A2F0A20202020656E61626C65643A20747275652C0A202020202F2A2A204070726F70207B4D6F646966696572466E7D202A2F0A20202020';
wwv_flow_api.g_varchar2_table(865) := '666E3A206B656570546F6765746865720A20207D2C0A0A20202F2A2A0A2020202A2054686973206D6F646966696572206973207573656420746F206D6F76652074686520606172726F77456C656D656E7460206F662074686520706F7070657220746F20';
wwv_flow_api.g_varchar2_table(866) := '6D616B650A2020202A207375726520697420697320706F736974696F6E6564206265747765656E20746865207265666572656E636520656C656D656E7420616E642069747320706F7070657220656C656D656E742E0A2020202A2049742077696C6C2072';
wwv_flow_api.g_varchar2_table(867) := '65616420746865206F757465722073697A65206F662074686520606172726F77456C656D656E7460206E6F646520746F2064657465637420686F77206D616E790A2020202A20706978656C73206F6620636F6E6A756E6374696F6E20617265206E656564';
wwv_flow_api.g_varchar2_table(868) := '65642E0A2020202A0A2020202A20497420686173206E6F20656666656374206966206E6F20606172726F77456C656D656E74602069732070726F76696465642E0A2020202A20406D656D6265726F66206D6F646966696572730A2020202A2040696E6E65';
wwv_flow_api.g_varchar2_table(869) := '720A2020202A2F0A20206172726F773A207B0A202020202F2A2A204070726F70207B6E756D6265727D206F726465723D353030202D20496E646578207573656420746F20646566696E6520746865206F72646572206F6620657865637574696F6E202A2F';
wwv_flow_api.g_varchar2_table(870) := '0A202020206F726465723A203530302C0A202020202F2A2A204070726F70207B426F6F6C65616E7D20656E61626C65643D74727565202D205768657468657220746865206D6F64696669657220697320656E61626C6564206F72206E6F74202A2F0A2020';
wwv_flow_api.g_varchar2_table(871) := '2020656E61626C65643A20747275652C0A202020202F2A2A204070726F70207B4D6F646966696572466E7D202A2F0A20202020666E3A206172726F772C0A202020202F2A2A204070726F70207B537472696E677C48544D4C456C656D656E747D20656C65';
wwv_flow_api.g_varchar2_table(872) := '6D656E743D275B782D6172726F775D27202D2053656C6563746F72206F72206E6F64652075736564206173206172726F77202A2F0A20202020656C656D656E743A20275B782D6172726F775D270A20207D2C0A0A20202F2A2A0A2020202A204D6F646966';
wwv_flow_api.g_varchar2_table(873) := '696572207573656420746F20666C69702074686520706F70706572277320706C6163656D656E74207768656E2069742073746172747320746F206F7665726C6170206974730A2020202A207265666572656E636520656C656D656E742E0A2020202A0A20';
wwv_flow_api.g_varchar2_table(874) := '20202A20526571756972657320746865206070726576656E744F766572666C6F7760206D6F646966696572206265666F726520697420696E206F7264657220746F20776F726B2E0A2020202A0A2020202A202A2A4E4F54453A2A2A2074686973206D6F64';
wwv_flow_api.g_varchar2_table(875) := '69666965722077696C6C20696E74657272757074207468652063757272656E7420757064617465206379636C6520616E642077696C6C0A2020202A2072657374617274206974206966206974206465746563747320746865206E65656420746F20666C69';
wwv_flow_api.g_varchar2_table(876) := '702074686520706C6163656D656E742E0A2020202A20406D656D6265726F66206D6F646966696572730A2020202A2040696E6E65720A2020202A2F0A2020666C69703A207B0A202020202F2A2A204070726F70207B6E756D6265727D206F726465723D36';
wwv_flow_api.g_varchar2_table(877) := '3030202D20496E646578207573656420746F20646566696E6520746865206F72646572206F6620657865637574696F6E202A2F0A202020206F726465723A203630302C0A202020202F2A2A204070726F70207B426F6F6C65616E7D20656E61626C65643D';
wwv_flow_api.g_varchar2_table(878) := '74727565202D205768657468657220746865206D6F64696669657220697320656E61626C6564206F72206E6F74202A2F0A20202020656E61626C65643A20747275652C0A202020202F2A2A204070726F70207B4D6F646966696572466E7D202A2F0A2020';
wwv_flow_api.g_varchar2_table(879) := '2020666E3A20666C69702C0A202020202F2A2A0A20202020202A204070726F70207B537472696E677C41727261797D206265686176696F723D27666C6970270A20202020202A20546865206265686176696F72207573656420746F206368616E67652074';
wwv_flow_api.g_varchar2_table(880) := '686520706F70706572277320706C6163656D656E742E2049742063616E206265206F6E65206F660A20202020202A2060666C6970602C2060636C6F636B77697365602C2060636F756E746572636C6F636B7769736560206F7220616E2061727261792077';
wwv_flow_api.g_varchar2_table(881) := '6974682061206C697374206F662076616C69640A20202020202A20706C6163656D656E7473202877697468206F7074696F6E616C20766172696174696F6E73290A20202020202A2F0A202020206265686176696F723A2027666C6970272C0A202020202F';
wwv_flow_api.g_varchar2_table(882) := '2A2A0A20202020202A204070726F70207B6E756D6265727D2070616464696E673D350A20202020202A2054686520706F707065722077696C6C20666C6970206966206974206869747320746865206564676573206F66207468652060626F756E64617269';
wwv_flow_api.g_varchar2_table(883) := '6573456C656D656E74600A20202020202A2F0A2020202070616464696E673A20352C0A202020202F2A2A0A20202020202A204070726F70207B537472696E677C48544D4C456C656D656E747D20626F756E646172696573456C656D656E743D2776696577';
wwv_flow_api.g_varchar2_table(884) := '706F7274270A20202020202A2054686520656C656D656E742077686963682077696C6C20646566696E652074686520626F756E646172696573206F662074686520706F7070657220706F736974696F6E2E0A20202020202A2054686520706F7070657220';
wwv_flow_api.g_varchar2_table(885) := '77696C6C206E6576657220626520706C61636564206F757473696465206F662074686520646566696E656420626F756E6461726965730A20202020202A202865786365707420696620606B656570546F6765746865726020697320656E61626C6564290A';
wwv_flow_api.g_varchar2_table(886) := '20202020202A2F0A20202020626F756E646172696573456C656D656E743A202776696577706F7274270A20207D2C0A0A20202F2A2A0A2020202A204D6F646966696572207573656420746F206D616B652074686520706F7070657220666C6F7720746F77';
wwv_flow_api.g_varchar2_table(887) := '6172642074686520696E6E6572206F6620746865207265666572656E636520656C656D656E742E0A2020202A2042792064656661756C742C207768656E2074686973206D6F6469666965722069732064697361626C65642C2074686520706F7070657220';
wwv_flow_api.g_varchar2_table(888) := '77696C6C20626520706C61636564206F7574736964650A2020202A20746865207265666572656E636520656C656D656E742E0A2020202A20406D656D6265726F66206D6F646966696572730A2020202A2040696E6E65720A2020202A2F0A2020696E6E65';
wwv_flow_api.g_varchar2_table(889) := '723A207B0A202020202F2A2A204070726F70207B6E756D6265727D206F726465723D373030202D20496E646578207573656420746F20646566696E6520746865206F72646572206F6620657865637574696F6E202A2F0A202020206F726465723A203730';
wwv_flow_api.g_varchar2_table(890) := '302C0A202020202F2A2A204070726F70207B426F6F6C65616E7D20656E61626C65643D66616C7365202D205768657468657220746865206D6F64696669657220697320656E61626C6564206F72206E6F74202A2F0A20202020656E61626C65643A206661';
wwv_flow_api.g_varchar2_table(891) := '6C73652C0A202020202F2A2A204070726F70207B4D6F646966696572466E7D202A2F0A20202020666E3A20696E6E65720A20207D2C0A0A20202F2A2A0A2020202A204D6F646966696572207573656420746F20686964652074686520706F707065722077';
wwv_flow_api.g_varchar2_table(892) := '68656E20697473207265666572656E636520656C656D656E74206973206F757473696465206F66207468650A2020202A20706F7070657220626F756E6461726965732E2049742077696C6C2073657420612060782D6F75742D6F662D626F756E64617269';
wwv_flow_api.g_varchar2_table(893) := '657360206174747269627574652077686963682063616E0A2020202A206265207573656420746F206869646520776974682061204353532073656C6563746F722074686520706F70706572207768656E20697473207265666572656E63652069730A2020';
wwv_flow_api.g_varchar2_table(894) := '202A206F7574206F6620626F756E6461726965732E0A2020202A0A2020202A20526571756972657320746865206070726576656E744F766572666C6F7760206D6F646966696572206265666F726520697420696E206F7264657220746F20776F726B2E0A';
wwv_flow_api.g_varchar2_table(895) := '2020202A20406D656D6265726F66206D6F646966696572730A2020202A2040696E6E65720A2020202A2F0A2020686964653A207B0A202020202F2A2A204070726F70207B6E756D6265727D206F726465723D383030202D20496E64657820757365642074';
wwv_flow_api.g_varchar2_table(896) := '6F20646566696E6520746865206F72646572206F6620657865637574696F6E202A2F0A202020206F726465723A203830302C0A202020202F2A2A204070726F70207B426F6F6C65616E7D20656E61626C65643D74727565202D2057686574686572207468';
wwv_flow_api.g_varchar2_table(897) := '65206D6F64696669657220697320656E61626C6564206F72206E6F74202A2F0A20202020656E61626C65643A20747275652C0A202020202F2A2A204070726F70207B4D6F646966696572466E7D202A2F0A20202020666E3A20686964650A20207D2C0A0A';
wwv_flow_api.g_varchar2_table(898) := '20202F2A2A0A2020202A20436F6D707574657320746865207374796C6520746861742077696C6C206265206170706C69656420746F2074686520706F7070657220656C656D656E7420746F20676574730A2020202A2070726F7065726C7920706F736974';
wwv_flow_api.g_varchar2_table(899) := '696F6E65642E0A2020202A0A2020202A204E6F746520746861742074686973206D6F6469666965722077696C6C206E6F7420746F7563682074686520444F4D2C206974206A75737420707265706172657320746865207374796C65730A2020202A20736F';
wwv_flow_api.g_varchar2_table(900) := '207468617420606170706C795374796C6560206D6F6469666965722063616E206170706C792069742E20546869732073657061726174696F6E2069732075736566756C0A2020202A20696E206361736520796F75206E65656420746F207265706C616365';
wwv_flow_api.g_varchar2_table(901) := '20606170706C795374796C65602077697468206120637573746F6D20696D706C656D656E746174696F6E2E0A2020202A0A2020202A2054686973206D6F6469666965722068617320603835306020617320606F72646572602076616C756520746F206D61';
wwv_flow_api.g_varchar2_table(902) := '696E7461696E206261636B7761726420636F6D7061746962696C6974790A2020202A20776974682070726576696F75732076657273696F6E73206F6620506F707065722E6A732E2045787065637420746865206D6F64696669657273206F72646572696E';
wwv_flow_api.g_varchar2_table(903) := '67206D6574686F640A2020202A20746F206368616E676520696E20667574757265206D616A6F722076657273696F6E73206F6620746865206C6962726172792E0A2020202A0A2020202A20406D656D6265726F66206D6F646966696572730A2020202A20';
wwv_flow_api.g_varchar2_table(904) := '40696E6E65720A2020202A2F0A2020636F6D707574655374796C653A207B0A202020202F2A2A204070726F70207B6E756D6265727D206F726465723D383530202D20496E646578207573656420746F20646566696E6520746865206F72646572206F6620';
wwv_flow_api.g_varchar2_table(905) := '657865637574696F6E202A2F0A202020206F726465723A203835302C0A202020202F2A2A204070726F70207B426F6F6C65616E7D20656E61626C65643D74727565202D205768657468657220746865206D6F64696669657220697320656E61626C656420';
wwv_flow_api.g_varchar2_table(906) := '6F72206E6F74202A2F0A20202020656E61626C65643A20747275652C0A202020202F2A2A204070726F70207B4D6F646966696572466E7D202A2F0A20202020666E3A20636F6D707574655374796C652C0A202020202F2A2A0A20202020202A204070726F';
wwv_flow_api.g_varchar2_table(907) := '70207B426F6F6C65616E7D20677075416363656C65726174696F6E3D747275650A20202020202A20496620747275652C20697420757365732074686520435353203344207472616E73666F726D6174696F6E20746F20706F736974696F6E207468652070';
wwv_flow_api.g_varchar2_table(908) := '6F707065722E0A20202020202A204F74686572776973652C2069742077696C6C20757365207468652060746F706020616E6420606C656674602070726F706572746965730A20202020202A2F0A20202020677075416363656C65726174696F6E3A207472';
wwv_flow_api.g_varchar2_table(909) := '75652C0A202020202F2A2A0A20202020202A204070726F70207B737472696E677D205B783D27626F74746F6D275D0A20202020202A20576865726520746F20616E63686F722074686520582061786973202860626F74746F6D60206F722060746F706029';
wwv_flow_api.g_varchar2_table(910) := '2E20414B412058206F6666736574206F726967696E2E0A20202020202A204368616E6765207468697320696620796F757220706F707065722073686F756C642067726F7720696E206120646972656374696F6E20646966666572656E742066726F6D2060';
wwv_flow_api.g_varchar2_table(911) := '626F74746F6D600A20202020202A2F0A20202020783A2027626F74746F6D272C0A202020202F2A2A0A20202020202A204070726F70207B737472696E677D205B783D276C656674275D0A20202020202A20576865726520746F20616E63686F7220746865';
wwv_flow_api.g_varchar2_table(912) := '205920617869732028606C65667460206F722060726967687460292E20414B412059206F6666736574206F726967696E2E0A20202020202A204368616E6765207468697320696620796F757220706F707065722073686F756C642067726F7720696E2061';
wwv_flow_api.g_varchar2_table(913) := '20646972656374696F6E20646966666572656E742066726F6D20607269676874600A20202020202A2F0A20202020793A20277269676874270A20207D2C0A0A20202F2A2A0A2020202A204170706C6965732074686520636F6D7075746564207374796C65';
wwv_flow_api.g_varchar2_table(914) := '7320746F2074686520706F7070657220656C656D656E742E0A2020202A0A2020202A20416C6C2074686520444F4D206D616E6970756C6174696F6E7320617265206C696D6974656420746F2074686973206D6F6469666965722E20546869732069732075';
wwv_flow_api.g_varchar2_table(915) := '736566756C20696E20636173650A2020202A20796F752077616E7420746F20696E7465677261746520506F707065722E6A7320696E736964652061206672616D65776F726B206F722076696577206C69627261727920616E6420796F750A2020202A2077';
wwv_flow_api.g_varchar2_table(916) := '616E7420746F2064656C656761746520616C6C2074686520444F4D206D616E6970756C6174696F6E7320746F2069742E0A2020202A0A2020202A204E6F7465207468617420696620796F752064697361626C652074686973206D6F6469666965722C2079';
wwv_flow_api.g_varchar2_table(917) := '6F75206D757374206D616B6520737572652074686520706F7070657220656C656D656E740A2020202A206861732069747320706F736974696F6E2073657420746F20606162736F6C75746560206265666F726520506F707065722E6A732063616E20646F';
wwv_flow_api.g_varchar2_table(918) := '2069747320776F726B210A2020202A0A2020202A204A7573742064697361626C652074686973206D6F64696669657220616E6420646566696E6520796F7572206F776E20746F2061636869657665207468652064657369726564206566666563742E0A20';
wwv_flow_api.g_varchar2_table(919) := '20202A0A2020202A20406D656D6265726F66206D6F646966696572730A2020202A2040696E6E65720A2020202A2F0A20206170706C795374796C653A207B0A202020202F2A2A204070726F70207B6E756D6265727D206F726465723D393030202D20496E';
wwv_flow_api.g_varchar2_table(920) := '646578207573656420746F20646566696E6520746865206F72646572206F6620657865637574696F6E202A2F0A202020206F726465723A203930302C0A202020202F2A2A204070726F70207B426F6F6C65616E7D20656E61626C65643D74727565202D20';
wwv_flow_api.g_varchar2_table(921) := '5768657468657220746865206D6F64696669657220697320656E61626C6564206F72206E6F74202A2F0A20202020656E61626C65643A20747275652C0A202020202F2A2A204070726F70207B4D6F646966696572466E7D202A2F0A20202020666E3A2061';
wwv_flow_api.g_varchar2_table(922) := '70706C795374796C652C0A202020202F2A2A204070726F70207B46756E6374696F6E7D202A2F0A202020206F6E4C6F61643A206170706C795374796C654F6E4C6F61642C0A202020202F2A2A0A20202020202A2040646570726563617465642073696E63';
wwv_flow_api.g_varchar2_table(923) := '652076657273696F6E20312E31302E302C207468652070726F7065727479206D6F76656420746F2060636F6D707574655374796C6560206D6F6469666965720A20202020202A204070726F70207B426F6F6C65616E7D20677075416363656C6572617469';
wwv_flow_api.g_varchar2_table(924) := '6F6E3D747275650A20202020202A20496620747275652C20697420757365732074686520435353203344207472616E73666F726D6174696F6E20746F20706F736974696F6E2074686520706F707065722E0A20202020202A204F74686572776973652C20';
wwv_flow_api.g_varchar2_table(925) := '69742077696C6C20757365207468652060746F706020616E6420606C656674602070726F706572746965730A20202020202A2F0A20202020677075416363656C65726174696F6E3A20756E646566696E65640A20207D0A7D3B0A0A2F2A2A0A202A205468';
wwv_flow_api.g_varchar2_table(926) := '652060646174614F626A6563746020697320616E206F626A65637420636F6E7461696E696E6720616C6C2074686520696E666F726D6174696F6E207573656420627920506F707065722E6A732E0A202A2054686973206F626A6563742069732070617373';
wwv_flow_api.g_varchar2_table(927) := '656420746F206D6F6469666965727320616E6420746F2074686520606F6E4372656174656020616E6420606F6E557064617465602063616C6C6261636B732E0A202A20406E616D6520646174614F626A6563740A202A204070726F7065727479207B4F62';
wwv_flow_api.g_varchar2_table(928) := '6A6563747D20646174612E696E7374616E63652054686520506F707065722E6A7320696E7374616E63650A202A204070726F7065727479207B537472696E677D20646174612E706C6163656D656E7420506C6163656D656E74206170706C69656420746F';
wwv_flow_api.g_varchar2_table(929) := '20706F707065720A202A204070726F7065727479207B537472696E677D20646174612E6F726967696E616C506C6163656D656E7420506C6163656D656E74206F726967696E616C6C7920646566696E6564206F6E20696E69740A202A204070726F706572';
wwv_flow_api.g_varchar2_table(930) := '7479207B426F6F6C65616E7D20646174612E666C6970706564205472756520696620706F7070657220686173206265656E20666C697070656420627920666C6970206D6F6469666965720A202A204070726F7065727479207B426F6F6C65616E7D206461';
wwv_flow_api.g_varchar2_table(931) := '74612E68696465205472756520696620746865207265666572656E636520656C656D656E74206973206F7574206F6620626F756E6461726965732C2075736566756C20746F206B6E6F77207768656E20746F20686964652074686520706F707065720A20';
wwv_flow_api.g_varchar2_table(932) := '2A204070726F7065727479207B48544D4C456C656D656E747D20646174612E6172726F77456C656D656E74204E6F64652075736564206173206172726F77206279206172726F77206D6F6469666965720A202A204070726F7065727479207B4F626A6563';
wwv_flow_api.g_varchar2_table(933) := '747D20646174612E7374796C657320416E79204353532070726F706572747920646566696E656420686572652077696C6C206265206170706C69656420746F2074686520706F707065722E204974206578706563747320746865204A6176615363726970';
wwv_flow_api.g_varchar2_table(934) := '74206E6F6D656E636C6174757265202865672E20606D617267696E426F74746F6D60290A202A204070726F7065727479207B4F626A6563747D20646174612E6172726F775374796C657320416E79204353532070726F706572747920646566696E656420';
wwv_flow_api.g_varchar2_table(935) := '686572652077696C6C206265206170706C69656420746F2074686520706F70706572206172726F772E204974206578706563747320746865204A617661536372697074206E6F6D656E636C6174757265202865672E20606D617267696E426F74746F6D60';
wwv_flow_api.g_varchar2_table(936) := '290A202A204070726F7065727479207B4F626A6563747D20646174612E626F756E646172696573204F666673657473206F662074686520706F7070657220626F756E6461726965730A202A204070726F7065727479207B4F626A6563747D20646174612E';
wwv_flow_api.g_varchar2_table(937) := '6F66667365747320546865206D6561737572656D656E7473206F6620706F707065722C207265666572656E636520616E64206172726F7720656C656D656E74730A202A204070726F7065727479207B4F626A6563747D20646174612E6F6666736574732E';
wwv_flow_api.g_varchar2_table(938) := '706F707065722060746F70602C20606C656674602C20607769647468602C2060686569676874602076616C7565730A202A204070726F7065727479207B4F626A6563747D20646174612E6F6666736574732E7265666572656E63652060746F70602C2060';
wwv_flow_api.g_varchar2_table(939) := '6C656674602C20607769647468602C2060686569676874602076616C7565730A202A204070726F7065727479207B4F626A6563747D20646174612E6F6666736574732E6172726F775D2060746F706020616E6420606C65667460206F6666736574732C20';
wwv_flow_api.g_varchar2_table(940) := '6F6E6C79206F6E65206F66207468656D2077696C6C20626520646966666572656E742066726F6D20300A202A2F0A0A2F2A2A0A202A2044656661756C74206F7074696F6E732070726F766964656420746F20506F707065722E6A7320636F6E7374727563';
wwv_flow_api.g_varchar2_table(941) := '746F722E3C6272202F3E0A202A2054686573652063616E206265206F76657272696464656E207573696E672074686520606F7074696F6E736020617267756D656E74206F6620506F707065722E6A732E3C6272202F3E0A202A20546F206F766572726964';
wwv_flow_api.g_varchar2_table(942) := '6520616E206F7074696F6E2C2073696D706C79207061737320616E206F626A6563742077697468207468652073616D650A202A20737472756374757265206F662074686520606F7074696F6E7360206F626A6563742C2061732074686520337264206172';
wwv_flow_api.g_varchar2_table(943) := '67756D656E742E20466F72206578616D706C653A0A202A206060600A202A206E657720506F70706572287265662C20706F702C207B0A202A2020206D6F646966696572733A207B0A202A202020202070726576656E744F766572666C6F773A207B20656E';
wwv_flow_api.g_varchar2_table(944) := '61626C65643A2066616C7365207D0A202A2020207D0A202A207D290A202A206060600A202A204074797065207B4F626A6563747D0A202A20407374617469630A202A20406D656D6265726F6620506F707065720A202A2F0A7661722044656661756C7473';
wwv_flow_api.g_varchar2_table(945) := '2431203D207B0A20202F2A2A0A2020202A20506F70706572277320706C6163656D656E742E0A2020202A204070726F70207B506F707065722E706C6163656D656E74737D20706C6163656D656E743D27626F74746F6D270A2020202A2F0A2020706C6163';
wwv_flow_api.g_varchar2_table(946) := '656D656E743A2027626F74746F6D272C0A0A20202F2A2A0A2020202A20536574207468697320746F207472756520696620796F752077616E7420706F7070657220746F20706F736974696F6E2069742073656C6620696E2027666978656427206D6F6465';
wwv_flow_api.g_varchar2_table(947) := '0A2020202A204070726F70207B426F6F6C65616E7D20706F736974696F6E46697865643D66616C73650A2020202A2F0A2020706F736974696F6E46697865643A2066616C73652C0A0A20202F2A2A0A2020202A2057686574686572206576656E74732028';
wwv_flow_api.g_varchar2_table(948) := '726573697A652C207363726F6C6C292061726520696E697469616C6C7920656E61626C65642E0A2020202A204070726F70207B426F6F6C65616E7D206576656E7473456E61626C65643D747275650A2020202A2F0A20206576656E7473456E61626C6564';
wwv_flow_api.g_varchar2_table(949) := '3A20747275652C0A0A20202F2A2A0A2020202A2053657420746F207472756520696620796F752077616E7420746F206175746F6D61746963616C6C792072656D6F76652074686520706F70706572207768656E0A2020202A20796F752063616C6C207468';
wwv_flow_api.g_varchar2_table(950) := '65206064657374726F7960206D6574686F642E0A2020202A204070726F70207B426F6F6C65616E7D2072656D6F76654F6E44657374726F793D66616C73650A2020202A2F0A202072656D6F76654F6E44657374726F793A2066616C73652C0A0A20202F2A';
wwv_flow_api.g_varchar2_table(951) := '2A0A2020202A2043616C6C6261636B2063616C6C6564207768656E2074686520706F7070657220697320637265617465642E3C6272202F3E0A2020202A2042792064656661756C742C2069742069732073657420746F206E6F2D6F702E3C6272202F3E0A';
wwv_flow_api.g_varchar2_table(952) := '2020202A2041636365737320506F707065722E6A7320696E7374616E636520776974682060646174612E696E7374616E6365602E0A2020202A204070726F70207B6F6E4372656174657D0A2020202A2F0A20206F6E4372656174653A2066756E6374696F';
wwv_flow_api.g_varchar2_table(953) := '6E206F6E4372656174652829207B7D2C0A0A20202F2A2A0A2020202A2043616C6C6261636B2063616C6C6564207768656E2074686520706F7070657220697320757064617465642E20546869732063616C6C6261636B206973206E6F742063616C6C6564';
wwv_flow_api.g_varchar2_table(954) := '0A2020202A206F6E2074686520696E697469616C697A6174696F6E2F6372656174696F6E206F662074686520706F707065722C20627574206F6E6C79206F6E2073756273657175656E740A2020202A20757064617465732E3C6272202F3E0A2020202A20';
wwv_flow_api.g_varchar2_table(955) := '42792064656661756C742C2069742069732073657420746F206E6F2D6F702E3C6272202F3E0A2020202A2041636365737320506F707065722E6A7320696E7374616E636520776974682060646174612E696E7374616E6365602E0A2020202A204070726F';
wwv_flow_api.g_varchar2_table(956) := '70207B6F6E5570646174657D0A2020202A2F0A20206F6E5570646174653A2066756E6374696F6E206F6E5570646174652829207B7D2C0A0A20202F2A2A0A2020202A204C697374206F66206D6F64696669657273207573656420746F206D6F6469667920';
wwv_flow_api.g_varchar2_table(957) := '746865206F666673657473206265666F7265207468657920617265206170706C69656420746F2074686520706F707065722E0A2020202A20546865792070726F76696465206D6F7374206F66207468652066756E6374696F6E616C6974696573206F6620';
wwv_flow_api.g_varchar2_table(958) := '506F707065722E6A732E0A2020202A204070726F70207B6D6F646966696572737D0A2020202A2F0A20206D6F646966696572733A206D6F646966696572730A7D3B0A0A2F2A2A0A202A204063616C6C6261636B206F6E4372656174650A202A2040706172';
wwv_flow_api.g_varchar2_table(959) := '616D207B646174614F626A6563747D20646174610A202A2F0A0A2F2A2A0A202A204063616C6C6261636B206F6E5570646174650A202A2040706172616D207B646174614F626A6563747D20646174610A202A2F0A0A2F2F205574696C730A2F2F204D6574';
wwv_flow_api.g_varchar2_table(960) := '686F64730A76617220506F70706572203D2066756E6374696F6E202829207B0A20202F2A2A0A2020202A20437265617465732061206E657720506F707065722E6A7320696E7374616E63652E0A2020202A2040636C61737320506F707065720A2020202A';
wwv_flow_api.g_varchar2_table(961) := '2040706172616D207B48544D4C456C656D656E747C7265666572656E63654F626A6563747D207265666572656E6365202D20546865207265666572656E636520656C656D656E74207573656420746F20706F736974696F6E2074686520706F707065720A';
wwv_flow_api.g_varchar2_table(962) := '2020202A2040706172616D207B48544D4C456C656D656E747D20706F70706572202D205468652048544D4C20656C656D656E7420757365642061732074686520706F707065720A2020202A2040706172616D207B4F626A6563747D206F7074696F6E7320';
wwv_flow_api.g_varchar2_table(963) := '2D20596F757220637573746F6D206F7074696F6E7320746F206F7665727269646520746865206F6E657320646566696E656420696E205B44656661756C74735D282364656661756C7473290A2020202A204072657475726E207B4F626A6563747D20696E';
wwv_flow_api.g_varchar2_table(964) := '7374616E6365202D205468652067656E65726174656420506F707065722E6A7320696E7374616E63650A2020202A2F0A202066756E6374696F6E20506F70706572287265666572656E63652C20706F7070657229207B0A20202020766172205F74686973';
wwv_flow_api.g_varchar2_table(965) := '203D20746869733B0A0A20202020766172206F7074696F6E73203D20617267756D656E74732E6C656E677468203E203220262620617267756D656E74735B325D20213D3D20756E646566696E6564203F20617267756D656E74735B325D203A207B7D3B0A';
wwv_flow_api.g_varchar2_table(966) := '20202020636C61737343616C6C436865636B28746869732C20506F70706572293B0A0A20202020746869732E7363686564756C65557064617465203D2066756E6374696F6E202829207B0A20202020202072657475726E2072657175657374416E696D61';
wwv_flow_api.g_varchar2_table(967) := '74696F6E4672616D65285F746869732E757064617465293B0A202020207D3B0A0A202020202F2F206D616B65207570646174652829206465626F756E6365642C20736F2074686174206974206F6E6C792072756E73206174206D6F7374206F6E63652D70';
wwv_flow_api.g_varchar2_table(968) := '65722D7469636B0A20202020746869732E757064617465203D206465626F756E636528746869732E7570646174652E62696E64287468697329293B0A0A202020202F2F2077697468207B7D207765206372656174652061206E6577206F626A6563742077';
wwv_flow_api.g_varchar2_table(969) := '69746820746865206F7074696F6E7320696E736964652069740A20202020746869732E6F7074696F6E73203D205F657874656E6473287B7D2C20506F707065722E44656661756C74732C206F7074696F6E73293B0A0A202020202F2F20696E6974207374';
wwv_flow_api.g_varchar2_table(970) := '6174650A20202020746869732E7374617465203D207B0A202020202020697344657374726F7965643A2066616C73652C0A2020202020206973437265617465643A2066616C73652C0A2020202020207363726F6C6C506172656E74733A205B5D0A202020';
wwv_flow_api.g_varchar2_table(971) := '207D3B0A0A202020202F2F20676574207265666572656E636520616E6420706F7070657220656C656D656E74732028616C6C6F77206A5175657279207772617070657273290A20202020746869732E7265666572656E6365203D207265666572656E6365';
wwv_flow_api.g_varchar2_table(972) := '202626207265666572656E63652E6A7175657279203F207265666572656E63655B305D203A207265666572656E63653B0A20202020746869732E706F70706572203D20706F7070657220262620706F707065722E6A7175657279203F20706F707065725B';
wwv_flow_api.g_varchar2_table(973) := '305D203A20706F707065723B0A0A202020202F2F2044656570206D65726765206D6F64696669657273206F7074696F6E730A20202020746869732E6F7074696F6E732E6D6F64696669657273203D207B7D3B0A202020204F626A6563742E6B657973285F';
wwv_flow_api.g_varchar2_table(974) := '657874656E6473287B7D2C20506F707065722E44656661756C74732E6D6F646966696572732C206F7074696F6E732E6D6F6469666965727329292E666F72456163682866756E6374696F6E20286E616D6529207B0A2020202020205F746869732E6F7074';
wwv_flow_api.g_varchar2_table(975) := '696F6E732E6D6F646966696572735B6E616D655D203D205F657874656E6473287B7D2C20506F707065722E44656661756C74732E6D6F646966696572735B6E616D655D207C7C207B7D2C206F7074696F6E732E6D6F64696669657273203F206F7074696F';
wwv_flow_api.g_varchar2_table(976) := '6E732E6D6F646966696572735B6E616D655D203A207B7D293B0A202020207D293B0A0A202020202F2F205265666163746F72696E67206D6F6469666965727327206C69737420284F626A656374203D3E204172726179290A20202020746869732E6D6F64';
wwv_flow_api.g_varchar2_table(977) := '696669657273203D204F626A6563742E6B65797328746869732E6F7074696F6E732E6D6F64696669657273292E6D61702866756E6374696F6E20286E616D6529207B0A20202020202072657475726E205F657874656E6473287B0A20202020202020206E';
wwv_flow_api.g_varchar2_table(978) := '616D653A206E616D650A2020202020207D2C205F746869732E6F7074696F6E732E6D6F646966696572735B6E616D655D293B0A202020207D290A202020202F2F20736F727420746865206D6F64696669657273206279206F726465720A202020202E736F';
wwv_flow_api.g_varchar2_table(979) := '72742866756E6374696F6E2028612C206229207B0A20202020202072657475726E20612E6F72646572202D20622E6F726465723B0A202020207D293B0A0A202020202F2F206D6F64696669657273206861766520746865206162696C69747920746F2065';
wwv_flow_api.g_varchar2_table(980) := '7865637574652061726269747261727920636F6465207768656E20506F707065722E6A732067657420696E697465640A202020202F2F207375636820636F646520697320657865637574656420696E207468652073616D65206F72646572206F66206974';
wwv_flow_api.g_varchar2_table(981) := '73206D6F6469666965720A202020202F2F207468657920636F756C6420616464206E65772070726F7065727469657320746F207468656972206F7074696F6E7320636F6E66696775726174696F6E0A202020202F2F2042452041574152453A20646F6E27';
wwv_flow_api.g_varchar2_table(982) := '7420616464206F7074696F6E7320746F20606F7074696F6E732E6D6F646966696572732E6E616D65602062757420746F20606D6F6469666965724F7074696F6E7360210A20202020746869732E6D6F646966696572732E666F72456163682866756E6374';
wwv_flow_api.g_varchar2_table(983) := '696F6E20286D6F6469666965724F7074696F6E7329207B0A202020202020696620286D6F6469666965724F7074696F6E732E656E61626C656420262620697346756E6374696F6E286D6F6469666965724F7074696F6E732E6F6E4C6F61642929207B0A20';
wwv_flow_api.g_varchar2_table(984) := '202020202020206D6F6469666965724F7074696F6E732E6F6E4C6F6164285F746869732E7265666572656E63652C205F746869732E706F707065722C205F746869732E6F7074696F6E732C206D6F6469666965724F7074696F6E732C205F746869732E73';
wwv_flow_api.g_varchar2_table(985) := '74617465293B0A2020202020207D0A202020207D293B0A0A202020202F2F2066697265207468652066697273742075706461746520746F20706F736974696F6E2074686520706F7070657220696E2074686520726967687420706C6163650A2020202074';
wwv_flow_api.g_varchar2_table(986) := '6869732E75706461746528293B0A0A20202020766172206576656E7473456E61626C6564203D20746869732E6F7074696F6E732E6576656E7473456E61626C65643B0A20202020696620286576656E7473456E61626C656429207B0A2020202020202F2F';
wwv_flow_api.g_varchar2_table(987) := '207365747570206576656E74206C697374656E6572732C20746865792077696C6C2074616B652063617265206F66207570646174652074686520706F736974696F6E20696E20737065636966696320736974756174696F6E730A20202020202074686973';
wwv_flow_api.g_varchar2_table(988) := '2E656E61626C654576656E744C697374656E65727328293B0A202020207D0A0A20202020746869732E73746174652E6576656E7473456E61626C6564203D206576656E7473456E61626C65643B0A20207D0A0A20202F2F2057652063616E277420757365';
wwv_flow_api.g_varchar2_table(989) := '20636C6173732070726F706572746965732062656361757365207468657920646F6E277420676574206C697374656420696E207468650A20202F2F20636C6173732070726F746F7479706520616E6420627265616B207374756666206C696B652053696E';
wwv_flow_api.g_varchar2_table(990) := '6F6E2073747562730A0A0A2020637265617465436C61737328506F707065722C205B7B0A202020206B65793A2027757064617465272C0A2020202076616C75653A2066756E6374696F6E207570646174652424312829207B0A2020202020207265747572';
wwv_flow_api.g_varchar2_table(991) := '6E207570646174652E63616C6C2874686973293B0A202020207D0A20207D2C207B0A202020206B65793A202764657374726F79272C0A2020202076616C75653A2066756E6374696F6E2064657374726F792424312829207B0A2020202020207265747572';
wwv_flow_api.g_varchar2_table(992) := '6E2064657374726F792E63616C6C2874686973293B0A202020207D0A20207D2C207B0A202020206B65793A2027656E61626C654576656E744C697374656E657273272C0A2020202076616C75653A2066756E6374696F6E20656E61626C654576656E744C';
wwv_flow_api.g_varchar2_table(993) := '697374656E6572732424312829207B0A20202020202072657475726E20656E61626C654576656E744C697374656E6572732E63616C6C2874686973293B0A202020207D0A20207D2C207B0A202020206B65793A202764697361626C654576656E744C6973';
wwv_flow_api.g_varchar2_table(994) := '74656E657273272C0A2020202076616C75653A2066756E6374696F6E2064697361626C654576656E744C697374656E6572732424312829207B0A20202020202072657475726E2064697361626C654576656E744C697374656E6572732E63616C6C287468';
wwv_flow_api.g_varchar2_table(995) := '6973293B0A202020207D0A0A202020202F2A2A0A20202020202A205363686564756C657320616E207570646174652E2049742077696C6C2072756E206F6E20746865206E6578742055492075706461746520617661696C61626C652E0A20202020202A20';
wwv_flow_api.g_varchar2_table(996) := '406D6574686F64207363686564756C655570646174650A20202020202A20406D656D6265726F6620506F707065720A20202020202A2F0A0A202020202F2A2A0A20202020202A20436F6C6C656374696F6E206F66207574696C6974696573207573656675';
wwv_flow_api.g_varchar2_table(997) := '6C207768656E2077726974696E6720637573746F6D206D6F646966696572732E0A20202020202A205374617274696E672066726F6D2076657273696F6E20312E372C2074686973206D6574686F6420697320617661696C61626C65206F6E6C7920696620';
wwv_flow_api.g_varchar2_table(998) := '796F750A20202020202A20696E636C7564652060706F707065722D7574696C732E6A7360206265666F72652060706F707065722E6A73602E0A20202020202A0A20202020202A202A2A4445505245434154494F4E2A2A3A20546869732077617920746F20';
wwv_flow_api.g_varchar2_table(999) := '61636365737320506F707065725574696C7320697320646570726563617465640A20202020202A20616E642077696C6C2062652072656D6F76656420696E20763221205573652074686520506F707065725574696C73206D6F64756C6520646972656374';
wwv_flow_api.g_varchar2_table(1000) := '6C7920696E73746561642E0A20202020202A2044756520746F20746865206869676820696E73746162696C697479206F6620746865206D6574686F647320636F6E7461696E656420696E205574696C732C2077652063616E27740A20202020202A206775';
wwv_flow_api.g_varchar2_table(1001) := '6172616E746565207468656D20746F20666F6C6C6F772073656D7665722E20557365207468656D20617420796F7572206F776E207269736B210A20202020202A20407374617469630A20202020202A2040707269766174650A20202020202A2040747970';
wwv_flow_api.g_varchar2_table(1002) := '65207B4F626A6563747D0A20202020202A2040646570726563617465642073696E63652076657273696F6E20312E380A20202020202A20406D656D626572205574696C730A20202020202A20406D656D6265726F6620506F707065720A20202020202A2F';
wwv_flow_api.g_varchar2_table(1003) := '0A0A20207D5D293B0A202072657475726E20506F707065723B0A7D28293B0A0A2F2A2A0A202A2054686520607265666572656E63654F626A6563746020697320616E206F626A65637420746861742070726F766964657320616E20696E74657266616365';
wwv_flow_api.g_varchar2_table(1004) := '20636F6D70617469626C65207769746820506F707065722E6A730A202A20616E64206C65747320796F7520757365206974206173207265706C6163656D656E74206F662061207265616C20444F4D206E6F64652E3C6272202F3E0A202A20596F75206361';
wwv_flow_api.g_varchar2_table(1005) := '6E207573652074686973206D6574686F6420746F20706F736974696F6E206120706F707065722072656C61746976656C7920746F206120736574206F6620636F6F7264696E617465730A202A20696E206361736520796F7520646F6E2774206861766520';
wwv_flow_api.g_varchar2_table(1006) := '6120444F4D206E6F646520746F20757365206173207265666572656E63652E0A202A0A202A206060600A202A206E657720506F70706572287265666572656E63654F626A6563742C20706F707065724E6F6465293B0A202A206060600A202A0A202A204E';
wwv_flow_api.g_varchar2_table(1007) := '423A205468697320666561747572652069736E277420737570706F7274656420696E20496E7465726E6574204578706C6F7265722031302E0A202A20406E616D65207265666572656E63654F626A6563740A202A204070726F7065727479207B46756E63';
wwv_flow_api.g_varchar2_table(1008) := '74696F6E7D20646174612E676574426F756E64696E67436C69656E74526563740A202A20412066756E6374696F6E20746861742072657475726E73206120736574206F6620636F6F7264696E6174657320636F6D70617469626C65207769746820746865';
wwv_flow_api.g_varchar2_table(1009) := '206E61746976652060676574426F756E64696E67436C69656E745265637460206D6574686F642E0A202A204070726F7065727479207B6E756D6265727D20646174612E636C69656E7457696474680A202A20416E20455336206765747465722074686174';
wwv_flow_api.g_varchar2_table(1010) := '2077696C6C2072657475726E20746865207769647468206F6620746865207669727475616C207265666572656E636520656C656D656E742E0A202A204070726F7065727479207B6E756D6265727D20646174612E636C69656E744865696768740A202A20';
wwv_flow_api.g_varchar2_table(1011) := '416E204553362067657474657220746861742077696C6C2072657475726E2074686520686569676874206F6620746865207669727475616C207265666572656E636520656C656D656E742E0A202A2F0A0A506F707065722E5574696C73203D2028747970';
wwv_flow_api.g_varchar2_table(1012) := '656F662077696E646F7720213D3D2027756E646566696E656427203F2077696E646F77203A20676C6F62616C292E506F707065725574696C733B0A506F707065722E706C6163656D656E7473203D20706C6163656D656E74733B0A506F707065722E4465';
wwv_flow_api.g_varchar2_table(1013) := '6661756C7473203D2044656661756C747324313B0A0A7661722053656C6563746F7273203D207B0A2020504F505045523A20272E74697070792D706F70706572272C0A2020544F4F4C5449503A20272E74697070792D746F6F6C746970272C0A2020434F';
wwv_flow_api.g_varchar2_table(1014) := '4E54454E543A20272E74697070792D636F6E74656E74272C0A20204241434B44524F503A20272E74697070792D6261636B64726F70272C0A20204152524F573A20272E74697070792D6172726F77272C0A2020524F554E445F4152524F573A20272E7469';
wwv_flow_api.g_varchar2_table(1015) := '7070792D726F756E646172726F77270A7D3B0A0A76617220656C656D656E7450726F746F203D20697342726F77736572203F20456C656D656E742E70726F746F74797065203A207B7D3B0A0A766172206D617463686573203D20656C656D656E7450726F';
wwv_flow_api.g_varchar2_table(1016) := '746F2E6D617463686573207C7C20656C656D656E7450726F746F2E6D61746368657353656C6563746F72207C7C20656C656D656E7450726F746F2E7765626B69744D61746368657353656C6563746F72207C7C20656C656D656E7450726F746F2E6D6F7A';
wwv_flow_api.g_varchar2_table(1017) := '4D61746368657353656C6563746F72207C7C20656C656D656E7450726F746F2E6D734D61746368657353656C6563746F723B0A0A2F2A2A0A202A20506F6E7966696C6C20666F722041727261792E66726F6D202D20636F6E766572747320697465726162';
wwv_flow_api.g_varchar2_table(1018) := '6C652076616C75657320746F20616E2061727261790A202A2040706172616D207B41727261792D6C696B657D2076616C75650A202A204072657475726E207B41727261797D0A202A2F0A66756E6374696F6E20617272617946726F6D2876616C75652920';
wwv_flow_api.g_varchar2_table(1019) := '7B0A202072657475726E205B5D2E736C6963652E63616C6C2876616C7565293B0A7D0A0A2F2A2A0A202A20506F6E7966696C6C20666F7220456C656D656E742E70726F746F747970652E636C6F736573740A202A2040706172616D207B456C656D656E74';
wwv_flow_api.g_varchar2_table(1020) := '7D20656C656D656E740A202A2040706172616D207B537472696E677D20706172656E7453656C6563746F720A202A204072657475726E207B456C656D656E747D0A202A2F0A66756E6374696F6E20636C6F7365737428656C656D656E742C20706172656E';
wwv_flow_api.g_varchar2_table(1021) := '7453656C6563746F7229207B0A202072657475726E2028656C656D656E7450726F746F2E636C6F73657374207C7C2066756E6374696F6E202873656C6563746F7229207B0A2020202076617220656C203D20746869733B0A202020207768696C65202865';
wwv_flow_api.g_varchar2_table(1022) := '6C29207B0A202020202020696620286D6174636865732E63616C6C28656C2C2073656C6563746F7229292072657475726E20656C3B0A202020202020656C203D20656C2E706172656E74456C656D656E743B0A202020207D0A20207D292E63616C6C2865';
wwv_flow_api.g_varchar2_table(1023) := '6C656D656E742C20706172656E7453656C6563746F72293B0A7D0A0A2F2A2A0A202A20576F726B73206C696B6520456C656D656E742E70726F746F747970652E636C6F736573742C20627574207573657320612063616C6C6261636B20696E7374656164';
wwv_flow_api.g_varchar2_table(1024) := '0A202A2040706172616D207B456C656D656E747D20656C656D656E740A202A2040706172616D207B46756E6374696F6E7D2063616C6C6261636B0A202A204072657475726E207B456C656D656E747D0A202A2F0A66756E6374696F6E20636C6F73657374';
wwv_flow_api.g_varchar2_table(1025) := '43616C6C6261636B28656C656D656E742C2063616C6C6261636B29207B0A20207768696C652028656C656D656E7429207B0A202020206966202863616C6C6261636B28656C656D656E7429292072657475726E20656C656D656E743B0A20202020656C65';
wwv_flow_api.g_varchar2_table(1026) := '6D656E74203D20656C656D656E742E706172656E74456C656D656E743B0A20207D0A7D0A0A7661722050415353495645203D207B20706173736976653A2074727565207D3B0A7661722046465F455854454E53494F4E5F545249434B203D207B20783A20';
wwv_flow_api.g_varchar2_table(1027) := '74727565207D3B0A0A2F2A2A0A202A2052657475726E732061206E657720606469766020656C656D656E740A202A204072657475726E207B48544D4C446976456C656D656E747D0A202A2F0A66756E6374696F6E206469762829207B0A20207265747572';
wwv_flow_api.g_varchar2_table(1028) := '6E20646F63756D656E742E637265617465456C656D656E74282764697627293B0A7D0A0A2F2A2A0A202A20536574732074686520696E6E657248544D4C206F6620616E20656C656D656E74207768696C6520747269636B696E67206C696E746572732026';
wwv_flow_api.g_varchar2_table(1029) := '206D696E6966696572730A202A2040706172616D207B48544D4C456C656D656E747D20656C0A202A2040706172616D207B456C656D656E747C537472696E677D2068746D6C0A202A2F0A66756E6374696F6E20736574496E6E657248544D4C28656C2C20';
wwv_flow_api.g_varchar2_table(1030) := '68746D6C29207B0A2020656C5B46465F455854454E53494F4E5F545249434B2E782026262027696E6E657248544D4C275D203D2068746D6C20696E7374616E63656F6620456C656D656E74203F2068746D6C5B46465F455854454E53494F4E5F54524943';
wwv_flow_api.g_varchar2_table(1031) := '4B2E782026262027696E6E657248544D4C275D203A2068746D6C3B0A7D0A0A2F2A2A0A202A20536574732074686520636F6E74656E74206F66206120746F6F6C7469700A202A2040706172616D207B48544D4C456C656D656E747D20636F6E74656E7445';
wwv_flow_api.g_varchar2_table(1032) := '6C0A202A2040706172616D207B4F626A6563747D2070726F70730A202A2F0A66756E6374696F6E20736574436F6E74656E7428636F6E74656E74456C2C2070726F707329207B0A20206966202870726F70732E636F6E74656E7420696E7374616E63656F';
wwv_flow_api.g_varchar2_table(1033) := '6620456C656D656E7429207B0A20202020736574496E6E657248544D4C28636F6E74656E74456C2C202727293B0A20202020636F6E74656E74456C2E617070656E644368696C642870726F70732E636F6E74656E74293B0A20207D20656C7365207B0A20';
wwv_flow_api.g_varchar2_table(1034) := '202020636F6E74656E74456C5B70726F70732E616C6C6F7748544D4C203F2027696E6E657248544D4C27203A202774657874436F6E74656E74275D203D2070726F70732E636F6E74656E743B0A20207D0A7D0A0A2F2A2A0A202A2052657475726E732074';
wwv_flow_api.g_varchar2_table(1035) := '6865206368696C6420656C656D656E7473206F66206120706F7070657220656C656D656E740A202A2040706172616D207B48544D4C456C656D656E747D20706F707065720A202A2F0A66756E6374696F6E206765744368696C6472656E28706F70706572';
wwv_flow_api.g_varchar2_table(1036) := '29207B0A202072657475726E207B0A20202020746F6F6C7469703A20706F707065722E717565727953656C6563746F722853656C6563746F72732E544F4F4C544950292C0A202020206261636B64726F703A20706F707065722E717565727953656C6563';
wwv_flow_api.g_varchar2_table(1037) := '746F722853656C6563746F72732E4241434B44524F50292C0A20202020636F6E74656E743A20706F707065722E717565727953656C6563746F722853656C6563746F72732E434F4E54454E54292C0A202020206172726F773A20706F707065722E717565';
wwv_flow_api.g_varchar2_table(1038) := '727953656C6563746F722853656C6563746F72732E4152524F5729207C7C20706F707065722E717565727953656C6563746F722853656C6563746F72732E524F554E445F4152524F57290A20207D3B0A7D0A0A2F2A2A0A202A2041646473206064617461';
wwv_flow_api.g_varchar2_table(1039) := '2D696E657274696160206174747269627574650A202A2040706172616D207B48544D4C456C656D656E747D20746F6F6C7469700A202A2F0A66756E6374696F6E20616464496E657274696128746F6F6C74697029207B0A2020746F6F6C7469702E736574';
wwv_flow_api.g_varchar2_table(1040) := '4174747269627574652827646174612D696E6572746961272C202727293B0A7D0A0A2F2A2A0A202A2052656D6F7665732060646174612D696E657274696160206174747269627574650A202A2040706172616D207B48544D4C456C656D656E747D20746F';
wwv_flow_api.g_varchar2_table(1041) := '6F6C7469700A202A2F0A66756E6374696F6E2072656D6F7665496E657274696128746F6F6C74697029207B0A2020746F6F6C7469702E72656D6F76654174747269627574652827646174612D696E657274696127293B0A7D0A0A2F2A2A0A202A20437265';
wwv_flow_api.g_varchar2_table(1042) := '6174657320616E206172726F7720656C656D656E7420616E642072657475726E732069740A202A2F0A66756E6374696F6E206372656174654172726F77456C656D656E74286172726F775479706529207B0A2020766172206172726F77203D2064697628';
wwv_flow_api.g_varchar2_table(1043) := '293B0A2020696620286172726F7754797065203D3D3D2027726F756E642729207B0A202020206172726F772E636C6173734E616D65203D202774697070792D726F756E646172726F77273B0A20202020736574496E6E657248544D4C286172726F772C20';
wwv_flow_api.g_varchar2_table(1044) := '273C7376672076696577426F783D2230203020323420382220786D6C6E733D22687474703A2F2F7777772E77332E6F72672F323030302F737667223E3C7061746820643D224D33203873322E3032312D2E30313520352E3235332D342E32313843392E35';
wwv_flow_api.g_varchar2_table(1045) := '383420322E3035312031302E37393720312E303037203132203163312E3230332D2E30303720322E34313620312E30333520332E37363120322E3738324331392E30313220382E3030352032312038203231203848337A222F3E3C2F7376673E27293B0A';
wwv_flow_api.g_varchar2_table(1046) := '20207D20656C7365207B0A202020206172726F772E636C6173734E616D65203D202774697070792D6172726F77273B0A20207D0A202072657475726E206172726F773B0A7D0A0A2F2A2A0A202A20437265617465732061206261636B64726F7020656C65';
wwv_flow_api.g_varchar2_table(1047) := '6D656E7420616E642072657475726E732069740A202A2F0A66756E6374696F6E206372656174654261636B64726F70456C656D656E742829207B0A2020766172206261636B64726F70203D2064697628293B0A20206261636B64726F702E636C6173734E';
wwv_flow_api.g_varchar2_table(1048) := '616D65203D202774697070792D6261636B64726F70273B0A20206261636B64726F702E7365744174747269627574652827646174612D7374617465272C202768696464656E27293B0A202072657475726E206261636B64726F703B0A7D0A0A2F2A2A0A20';
wwv_flow_api.g_varchar2_table(1049) := '2A204164647320696E7465726163746976652D72656C6174656420617474726962757465730A202A2040706172616D207B48544D4C456C656D656E747D20706F707065720A202A2040706172616D207B48544D4C456C656D656E747D20746F6F6C746970';
wwv_flow_api.g_varchar2_table(1050) := '0A202A2F0A66756E6374696F6E20616464496E74657261637469766528706F707065722C20746F6F6C74697029207B0A2020706F707065722E7365744174747269627574652827746162696E646578272C20272D3127293B0A2020746F6F6C7469702E73';
wwv_flow_api.g_varchar2_table(1051) := '65744174747269627574652827646174612D696E746572616374697665272C202727293B0A7D0A0A2F2A2A0A202A2052656D6F76657320696E7465726163746976652D72656C6174656420617474726962757465730A202A2040706172616D207B48544D';
wwv_flow_api.g_varchar2_table(1052) := '4C456C656D656E747D20706F707065720A202A2040706172616D207B48544D4C456C656D656E747D20746F6F6C7469700A202A2F0A66756E6374696F6E2072656D6F7665496E74657261637469766528706F707065722C20746F6F6C74697029207B0A20';
wwv_flow_api.g_varchar2_table(1053) := '20706F707065722E72656D6F76654174747269627574652827746162696E64657827293B0A2020746F6F6C7469702E72656D6F76654174747269627574652827646174612D696E74657261637469766527293B0A7D0A0A2F2A2A0A202A204170706C6965';
wwv_flow_api.g_varchar2_table(1054) := '732061207472616E736974696F6E206475726174696F6E20746F2061206C697374206F6620656C656D656E74730A202A2040706172616D207B41727261797D20656C730A202A2040706172616D207B4E756D6265727D2076616C75650A202A2F0A66756E';
wwv_flow_api.g_varchar2_table(1055) := '6374696F6E206170706C795472616E736974696F6E4475726174696F6E28656C732C2076616C756529207B0A2020656C732E666F72456163682866756E6374696F6E2028656C29207B0A2020202069662028656C29207B0A202020202020656C2E737479';
wwv_flow_api.g_varchar2_table(1056) := '6C652E7472616E736974696F6E4475726174696F6E203D2076616C7565202B20276D73273B0A202020207D0A20207D293B0A7D0A0A2F2A2A0A202A204164642F72656D6F7665207472616E736974696F6E656E64206C697374656E65722066726F6D2074';
wwv_flow_api.g_varchar2_table(1057) := '6F6F6C7469700A202A2040706172616D207B456C656D656E747D20746F6F6C7469700A202A2040706172616D207B537472696E677D20616374696F6E0A202A2040706172616D207B46756E6374696F6E7D206C697374656E65720A202A2F0A66756E6374';
wwv_flow_api.g_varchar2_table(1058) := '696F6E20746F67676C655472616E736974696F6E456E644C697374656E657228746F6F6C7469702C20616374696F6E2C206C697374656E657229207B0A2020746F6F6C7469705B616374696F6E202B20274576656E744C697374656E6572275D28277472';
wwv_flow_api.g_varchar2_table(1059) := '616E736974696F6E656E64272C206C697374656E6572293B0A7D0A0A2F2A2A0A202A2052657475726E732074686520706F70706572277320706C6163656D656E742C2069676E6F72696E67207368696674696E672028746F702D73746172742C20657463';
wwv_flow_api.g_varchar2_table(1060) := '290A202A2040706172616D207B456C656D656E747D20706F707065720A202A204072657475726E207B537472696E677D0A202A2F0A66756E6374696F6E20676574506F70706572506C6163656D656E7428706F7070657229207B0A20207661722066756C';
wwv_flow_api.g_varchar2_table(1061) := '6C506C6163656D656E74203D20706F707065722E6765744174747269627574652827782D706C6163656D656E7427293B0A202072657475726E2066756C6C506C6163656D656E74203F2066756C6C506C6163656D656E742E73706C697428272D27295B30';
wwv_flow_api.g_varchar2_table(1062) := '5D203A2027273B0A7D0A0A2F2A2A0A202A205365747320746865207669736962696C69747920737461746520746F20656C656D656E747320736F20746865792063616E20626567696E20746F207472616E736974696F6E0A202A2040706172616D207B41';
wwv_flow_api.g_varchar2_table(1063) := '727261797D20656C730A202A2040706172616D207B537472696E677D2073746174650A202A2F0A66756E6374696F6E207365745669736962696C697479537461746528656C732C20737461746529207B0A2020656C732E666F72456163682866756E6374';
wwv_flow_api.g_varchar2_table(1064) := '696F6E2028656C29207B0A2020202069662028656C29207B0A202020202020656C2E7365744174747269627574652827646174612D7374617465272C207374617465293B0A202020207D0A20207D293B0A7D0A0A2F2A2A0A202A20547269676765727320';
wwv_flow_api.g_varchar2_table(1065) := '7265666C6F770A202A2040706172616D207B456C656D656E747D20706F707065720A202A2F0A66756E6374696F6E207265666C6F7728706F7070657229207B0A2020766F696420706F707065722E6F66667365744865696768743B0A7D0A0A2F2A2A0A20';
wwv_flow_api.g_varchar2_table(1066) := '2A20436F6E737472756374732074686520706F7070657220656C656D656E7420616E642072657475726E732069740A202A2040706172616D207B4E756D6265727D2069640A202A2040706172616D207B4F626A6563747D2070726F70730A202A2F0A6675';
wwv_flow_api.g_varchar2_table(1067) := '6E6374696F6E20637265617465506F70706572456C656D656E742869642C2070726F707329207B0A202076617220706F70706572203D2064697628293B0A2020706F707065722E636C6173734E616D65203D202774697070792D706F70706572273B0A20';
wwv_flow_api.g_varchar2_table(1068) := '20706F707065722E7365744174747269627574652827726F6C65272C2027746F6F6C74697027293B0A2020706F707065722E6964203D202774697070792D27202B2069643B0A2020706F707065722E7374796C652E7A496E646578203D2070726F70732E';
wwv_flow_api.g_varchar2_table(1069) := '7A496E6465783B0A0A202076617220746F6F6C746970203D2064697628293B0A2020746F6F6C7469702E636C6173734E616D65203D202774697070792D746F6F6C746970273B0A2020746F6F6C7469702E7374796C652E6D61785769647468203D207072';
wwv_flow_api.g_varchar2_table(1070) := '6F70732E6D61785769647468202B2028747970656F662070726F70732E6D61785769647468203D3D3D20276E756D62657227203F2027707827203A202727293B0A2020746F6F6C7469702E7365744174747269627574652827646174612D73697A65272C';
wwv_flow_api.g_varchar2_table(1071) := '2070726F70732E73697A65293B0A2020746F6F6C7469702E7365744174747269627574652827646174612D616E696D6174696F6E272C2070726F70732E616E696D6174696F6E293B0A2020746F6F6C7469702E7365744174747269627574652827646174';
wwv_flow_api.g_varchar2_table(1072) := '612D7374617465272C202768696464656E27293B0A202070726F70732E7468656D652E73706C697428272027292E666F72456163682866756E6374696F6E20287429207B0A20202020746F6F6C7469702E636C6173734C6973742E6164642874202B2027';
wwv_flow_api.g_varchar2_table(1073) := '2D7468656D6527293B0A20207D293B0A0A202076617220636F6E74656E74203D2064697628293B0A2020636F6E74656E742E636C6173734E616D65203D202774697070792D636F6E74656E74273B0A2020636F6E74656E742E7365744174747269627574';
wwv_flow_api.g_varchar2_table(1074) := '652827646174612D7374617465272C202768696464656E27293B0A0A20206966202870726F70732E696E74657261637469766529207B0A20202020616464496E74657261637469766528706F707065722C20746F6F6C746970293B0A20207D0A0A202069';
wwv_flow_api.g_varchar2_table(1075) := '66202870726F70732E6172726F7729207B0A20202020746F6F6C7469702E617070656E644368696C64286372656174654172726F77456C656D656E742870726F70732E6172726F775479706529293B0A20207D0A0A20206966202870726F70732E616E69';
wwv_flow_api.g_varchar2_table(1076) := '6D61746546696C6C29207B0A20202020746F6F6C7469702E617070656E644368696C64286372656174654261636B64726F70456C656D656E742829293B0A20202020746F6F6C7469702E7365744174747269627574652827646174612D616E696D617465';
wwv_flow_api.g_varchar2_table(1077) := '66696C6C272C202727293B0A20207D0A0A20206966202870726F70732E696E657274696129207B0A20202020616464496E657274696128746F6F6C746970293B0A20207D0A0A2020736574436F6E74656E7428636F6E74656E742C2070726F7073293B0A';
wwv_flow_api.g_varchar2_table(1078) := '0A2020746F6F6C7469702E617070656E644368696C6428636F6E74656E74293B0A2020706F707065722E617070656E644368696C6428746F6F6C746970293B0A0A2020706F707065722E6164644576656E744C697374656E65722827666F6375736F7574';
wwv_flow_api.g_varchar2_table(1079) := '272C2066756E6374696F6E20286529207B0A2020202069662028652E72656C6174656454617267657420262620706F707065722E5F74697070792026262021636C6F7365737443616C6C6261636B28652E72656C617465645461726765742C2066756E63';
wwv_flow_api.g_varchar2_table(1080) := '74696F6E2028656C29207B0A20202020202072657475726E20656C203D3D3D20706F707065723B0A202020207D2920262620652E72656C6174656454617267657420213D3D20706F707065722E5F74697070792E7265666572656E636520262620706F70';
wwv_flow_api.g_varchar2_table(1081) := '7065722E5F74697070792E70726F70732E73686F756C64506F70706572486964654F6E426C757228652929207B0A202020202020706F707065722E5F74697070792E6869646528293B0A202020207D0A20207D293B0A0A202072657475726E20706F7070';
wwv_flow_api.g_varchar2_table(1082) := '65723B0A7D0A0A2F2A2A0A202A20557064617465732074686520706F7070657220656C656D656E74206261736564206F6E20746865206E65772070726F70730A202A2040706172616D207B48544D4C456C656D656E747D20706F707065720A202A204070';
wwv_flow_api.g_varchar2_table(1083) := '6172616D207B4F626A6563747D207072657650726F70730A202A2040706172616D207B4F626A6563747D206E65787450726F70730A202A2F0A66756E6374696F6E20757064617465506F70706572456C656D656E7428706F707065722C20707265765072';
wwv_flow_api.g_varchar2_table(1084) := '6F70732C206E65787450726F707329207B0A2020766172205F6765744368696C6472656E203D206765744368696C6472656E28706F70706572292C0A202020202020746F6F6C746970203D205F6765744368696C6472656E2E746F6F6C7469702C0A2020';
wwv_flow_api.g_varchar2_table(1085) := '20202020636F6E74656E74203D205F6765744368696C6472656E2E636F6E74656E742C0A2020202020206261636B64726F70203D205F6765744368696C6472656E2E6261636B64726F702C0A2020202020206172726F77203D205F6765744368696C6472';
wwv_flow_api.g_varchar2_table(1086) := '656E2E6172726F773B0A0A2020706F707065722E7374796C652E7A496E646578203D206E65787450726F70732E7A496E6465783B0A2020746F6F6C7469702E7365744174747269627574652827646174612D73697A65272C206E65787450726F70732E73';
wwv_flow_api.g_varchar2_table(1087) := '697A65293B0A2020746F6F6C7469702E7365744174747269627574652827646174612D616E696D6174696F6E272C206E65787450726F70732E616E696D6174696F6E293B0A2020746F6F6C7469702E7374796C652E6D61785769647468203D206E657874';
wwv_flow_api.g_varchar2_table(1088) := '50726F70732E6D61785769647468202B2028747970656F66206E65787450726F70732E6D61785769647468203D3D3D20276E756D62657227203F2027707827203A202727293B0A0A2020696620287072657650726F70732E636F6E74656E7420213D3D20';
wwv_flow_api.g_varchar2_table(1089) := '6E65787450726F70732E636F6E74656E7429207B0A20202020736574436F6E74656E7428636F6E74656E742C206E65787450726F7073293B0A20207D0A0A20202F2F20616E696D61746546696C6C0A202069662028217072657650726F70732E616E696D';
wwv_flow_api.g_varchar2_table(1090) := '61746546696C6C202626206E65787450726F70732E616E696D61746546696C6C29207B0A20202020746F6F6C7469702E617070656E644368696C64286372656174654261636B64726F70456C656D656E742829293B0A20202020746F6F6C7469702E7365';
wwv_flow_api.g_varchar2_table(1091) := '744174747269627574652827646174612D616E696D61746566696C6C272C202727293B0A20207D20656C736520696620287072657650726F70732E616E696D61746546696C6C20262620216E65787450726F70732E616E696D61746546696C6C29207B0A';
wwv_flow_api.g_varchar2_table(1092) := '20202020746F6F6C7469702E72656D6F76654368696C64286261636B64726F70293B0A20202020746F6F6C7469702E72656D6F76654174747269627574652827646174612D616E696D61746566696C6C27293B0A20207D0A0A20202F2F206172726F770A';
wwv_flow_api.g_varchar2_table(1093) := '202069662028217072657650726F70732E6172726F77202626206E65787450726F70732E6172726F7729207B0A20202020746F6F6C7469702E617070656E644368696C64286372656174654172726F77456C656D656E74286E65787450726F70732E6172';
wwv_flow_api.g_varchar2_table(1094) := '726F775479706529293B0A20207D20656C736520696620287072657650726F70732E6172726F7720262620216E65787450726F70732E6172726F7729207B0A20202020746F6F6C7469702E72656D6F76654368696C64286172726F77293B0A20207D0A0A';
wwv_flow_api.g_varchar2_table(1095) := '20202F2F206172726F77547970650A2020696620287072657650726F70732E6172726F77202626206E65787450726F70732E6172726F77202626207072657650726F70732E6172726F775479706520213D3D206E65787450726F70732E6172726F775479';
wwv_flow_api.g_varchar2_table(1096) := '706529207B0A20202020746F6F6C7469702E7265706C6163654368696C64286372656174654172726F77456C656D656E74286E65787450726F70732E6172726F7754797065292C206172726F77293B0A20207D0A0A20202F2F20696E7465726163746976';
wwv_flow_api.g_varchar2_table(1097) := '650A202069662028217072657650726F70732E696E746572616374697665202626206E65787450726F70732E696E74657261637469766529207B0A20202020616464496E74657261637469766528706F707065722C20746F6F6C746970293B0A20207D20';
wwv_flow_api.g_varchar2_table(1098) := '656C736520696620287072657650726F70732E696E74657261637469766520262620216E65787450726F70732E696E74657261637469766529207B0A2020202072656D6F7665496E74657261637469766528706F707065722C20746F6F6C746970293B0A';
wwv_flow_api.g_varchar2_table(1099) := '20207D0A0A20202F2F20696E65727469610A202069662028217072657650726F70732E696E6572746961202626206E65787450726F70732E696E657274696129207B0A20202020616464496E657274696128746F6F6C746970293B0A20207D20656C7365';
wwv_flow_api.g_varchar2_table(1100) := '20696620287072657650726F70732E696E657274696120262620216E65787450726F70732E696E657274696129207B0A2020202072656D6F7665496E657274696128746F6F6C746970293B0A20207D0A0A20202F2F207468656D650A2020696620287072';
wwv_flow_api.g_varchar2_table(1101) := '657650726F70732E7468656D6520213D3D206E65787450726F70732E7468656D6529207B0A202020207072657650726F70732E7468656D652E73706C697428272027292E666F72456163682866756E6374696F6E20287468656D6529207B0A2020202020';
wwv_flow_api.g_varchar2_table(1102) := '20746F6F6C7469702E636C6173734C6973742E72656D6F7665287468656D65202B20272D7468656D6527293B0A202020207D293B0A202020206E65787450726F70732E7468656D652E73706C697428272027292E666F72456163682866756E6374696F6E';
wwv_flow_api.g_varchar2_table(1103) := '20287468656D6529207B0A202020202020746F6F6C7469702E636C6173734C6973742E616464287468656D65202B20272D7468656D6527293B0A202020207D293B0A20207D0A7D0A0A2F2A2A0A202A2052756E73207468652063616C6C6261636B206166';
wwv_flow_api.g_varchar2_table(1104) := '7465722074686520706F70706572277320706F736974696F6E20686173206265656E20757064617465640A202A207570646174652829206973206465626F756E63656420776974682050726F6D6973652E7265736F6C76652829206F722073657454696D';
wwv_flow_api.g_varchar2_table(1105) := '656F757428290A202A207363686564756C655570646174652829206973207570646174652829207772617070656420696E2072657175657374416E696D6174696F6E4672616D6528290A202A2040706172616D207B506F707065727D20706F7070657249';
wwv_flow_api.g_varchar2_table(1106) := '6E7374616E63650A202A2040706172616D207B46756E6374696F6E7D2063616C6C6261636B0A202A2F0A66756E6374696F6E206166746572506F70706572506F736974696F6E5570646174657328706F70706572496E7374616E63652C2063616C6C6261';
wwv_flow_api.g_varchar2_table(1107) := '636B29207B0A202076617220706F70706572203D20706F70706572496E7374616E63652E706F707065722C0A2020202020206F7074696F6E73203D20706F70706572496E7374616E63652E6F7074696F6E733B0A2020766172206F6E437265617465203D';
wwv_flow_api.g_varchar2_table(1108) := '206F7074696F6E732E6F6E4372656174652C0A2020202020206F6E557064617465203D206F7074696F6E732E6F6E5570646174653B0A0A0A20206F7074696F6E732E6F6E437265617465203D206F7074696F6E732E6F6E557064617465203D2066756E63';
wwv_flow_api.g_varchar2_table(1109) := '74696F6E202829207B0A202020207265666C6F7728706F70706572293B0A2020202063616C6C6261636B28293B0A202020206F6E55706461746528293B0A202020206F7074696F6E732E6F6E437265617465203D206F6E4372656174653B0A202020206F';
wwv_flow_api.g_varchar2_table(1110) := '7074696F6E732E6F6E557064617465203D206F6E5570646174653B0A20207D3B0A7D0A0A2F2A2A0A202A20486964657320616C6C2076697369626C6520706F7070657273206F6E2074686520646F63756D656E742C206F7074696F6E616C6C7920657863';
wwv_flow_api.g_varchar2_table(1111) := '6C7564696E67206F6E650A202A2040706172616D207B54697070797D207469707079496E7374616E6365546F4578636C7564650A202A2F0A66756E6374696F6E2068696465416C6C506F7070657273287469707079496E7374616E6365546F4578636C75';
wwv_flow_api.g_varchar2_table(1112) := '646529207B0A2020617272617946726F6D28646F63756D656E742E717565727953656C6563746F72416C6C2853656C6563746F72732E504F5050455229292E666F72456163682866756E6374696F6E2028706F7070657229207B0A202020207661722074';
wwv_flow_api.g_varchar2_table(1113) := '6970203D20706F707065722E5F74697070793B0A2020202069662028746970202626207469702E70726F70732E686964654F6E436C69636B203D3D3D20747275652026262028217469707079496E7374616E6365546F4578636C756465207C7C20706F70';
wwv_flow_api.g_varchar2_table(1114) := '70657220213D3D207469707079496E7374616E6365546F4578636C7564652E706F707065722929207B0A2020202020207469702E6869646528293B0A202020207D0A20207D293B0A7D0A0A2F2A2A0A202A2044657465726D696E65732069662074686520';
wwv_flow_api.g_varchar2_table(1115) := '6D6F75736520637572736F72206973206F757473696465206F662074686520706F70706572277320696E74657261637469766520626F726465720A202A20726567696F6E0A202A2040706172616D207B537472696E677D20706F70706572506C6163656D';
wwv_flow_api.g_varchar2_table(1116) := '656E740A202A2040706172616D207B4F626A6563747D20706F70706572526563740A202A2040706172616D207B4D6F7573654576656E747D206576656E740A202A2040706172616D207B4F626A6563747D2070726F70730A202A2F0A66756E6374696F6E';
wwv_flow_api.g_varchar2_table(1117) := '206973437572736F724F757473696465496E746572616374697665426F7264657228706F70706572506C6163656D656E742C20706F70706572526563742C206576656E742C2070726F707329207B0A20206966202821706F70706572506C6163656D656E';
wwv_flow_api.g_varchar2_table(1118) := '7429207B0A2020202072657475726E20747275653B0A20207D0A0A20207661722078203D206576656E742E636C69656E74582C0A20202020202079203D206576656E742E636C69656E74593B0A202076617220696E746572616374697665426F72646572';
wwv_flow_api.g_varchar2_table(1119) := '203D2070726F70732E696E746572616374697665426F726465722C0A20202020202064697374616E6365203D2070726F70732E64697374616E63653B0A0A0A20207661722065786365656473546F70203D20706F70706572526563742E746F70202D2079';
wwv_flow_api.g_varchar2_table(1120) := '203E2028706F70706572506C6163656D656E74203D3D3D2027746F7027203F20696E746572616374697665426F72646572202B2064697374616E6365203A20696E746572616374697665426F72646572293B0A0A20207661722065786365656473426F74';
wwv_flow_api.g_varchar2_table(1121) := '746F6D203D2079202D20706F70706572526563742E626F74746F6D203E2028706F70706572506C6163656D656E74203D3D3D2027626F74746F6D27203F20696E746572616374697665426F72646572202B2064697374616E6365203A20696E7465726163';
wwv_flow_api.g_varchar2_table(1122) := '74697665426F72646572293B0A0A202076617220657863656564734C656674203D20706F70706572526563742E6C656674202D2078203E2028706F70706572506C6163656D656E74203D3D3D20276C65667427203F20696E746572616374697665426F72';
wwv_flow_api.g_varchar2_table(1123) := '646572202B2064697374616E6365203A20696E746572616374697665426F72646572293B0A0A202076617220657863656564735269676874203D2078202D20706F70706572526563742E7269676874203E2028706F70706572506C6163656D656E74203D';
wwv_flow_api.g_varchar2_table(1124) := '3D3D2027726967687427203F20696E746572616374697665426F72646572202B2064697374616E6365203A20696E746572616374697665426F72646572293B0A0A202072657475726E2065786365656473546F70207C7C2065786365656473426F74746F';
wwv_flow_api.g_varchar2_table(1125) := '6D207C7C20657863656564734C656674207C7C206578636565647352696768743B0A7D0A0A2F2A2A0A202A2052657475726E73207468652064697374616E6365206F66667365742C2074616B696E6720696E746F206163636F756E742074686520646566';
wwv_flow_api.g_varchar2_table(1126) := '61756C74206F66667365742064756520746F0A202A20746865207472616E73666F726D3A207472616E736C61746528292072756C6520696E204353530A202A2040706172616D207B4E756D6265727D2064697374616E63650A202A2040706172616D207B';
wwv_flow_api.g_varchar2_table(1127) := '4E756D6265727D2064656661756C7444697374616E63650A202A2F0A66756E6374696F6E206765744F666673657444697374616E6365496E50782864697374616E63652C2064656661756C7444697374616E636529207B0A202072657475726E202D2864';
wwv_flow_api.g_varchar2_table(1128) := '697374616E6365202D2064656661756C7444697374616E636529202B20277078273B0A7D0A0A2F2A2A0A202A2044657465726D696E657320696620612076616C7565206973206120706C61696E206F626A6563740A202A2040706172616D207B616E797D';
wwv_flow_api.g_varchar2_table(1129) := '2076616C75650A202A204072657475726E207B426F6F6C65616E7D0A202A2F0A66756E6374696F6E206973506C61696E4F626A6563742876616C756529207B0A202072657475726E207B7D2E746F537472696E672E63616C6C2876616C756529203D3D3D';
wwv_flow_api.g_varchar2_table(1130) := '20275B6F626A656374204F626A6563745D273B0A7D0A0A2F2A2A0A202A2053616665202E6861734F776E50726F706572747920636865636B2C20666F722070726F746F747970652D6C657373206F626A656374730A202A2040706172616D207B4F626A65';
wwv_flow_api.g_varchar2_table(1131) := '63747D206F626A0A202A2040706172616D207B537472696E677D206B65790A202A204072657475726E207B426F6F6C65616E7D0A202A2F0A66756E6374696F6E206861734F776E50726F7065727479286F626A2C206B657929207B0A202072657475726E';
wwv_flow_api.g_varchar2_table(1132) := '207B7D2E6861734F776E50726F70657274792E63616C6C286F626A2C206B6579293B0A7D0A0A2F2A2A0A202A2044657465726D696E657320696620612076616C7565206973206E756D657269630A202A2040706172616D207B616E797D2076616C75650A';
wwv_flow_api.g_varchar2_table(1133) := '202A204072657475726E207B426F6F6C65616E7D0A202A2F0A66756E6374696F6E2069734E756D6572696324312876616C756529207B0A202072657475726E202169734E614E2876616C756529202626202169734E614E287061727365466C6F61742876';
wwv_flow_api.g_varchar2_table(1134) := '616C756529293B0A7D0A0A2F2A2A0A202A2052657475726E7320616E206172726179206F6620656C656D656E7473206261736564206F6E207468652076616C75650A202A2040706172616D207B616E797D2076616C75650A202A204072657475726E207B';
wwv_flow_api.g_varchar2_table(1135) := '41727261797D0A202A2F0A66756E6374696F6E2067657441727261794F66456C656D656E74732876616C756529207B0A20206966202876616C756520696E7374616E63656F6620456C656D656E74207C7C206973506C61696E4F626A6563742876616C75';
wwv_flow_api.g_varchar2_table(1136) := '652929207B0A2020202072657475726E205B76616C75655D3B0A20207D0A20206966202876616C756520696E7374616E63656F66204E6F64654C69737429207B0A2020202072657475726E20617272617946726F6D2876616C7565293B0A20207D0A2020';
wwv_flow_api.g_varchar2_table(1137) := '6966202841727261792E697341727261792876616C75652929207B0A2020202072657475726E2076616C75653B0A20207D0A0A2020747279207B0A2020202072657475726E20617272617946726F6D28646F63756D656E742E717565727953656C656374';
wwv_flow_api.g_varchar2_table(1138) := '6F72416C6C2876616C756529293B0A20207D20636174636820286529207B0A2020202072657475726E205B5D3B0A20207D0A7D0A0A2F2A2A0A202A2052657475726E7320612076616C7565206174206120676976656E20696E64657820646570656E6469';
wwv_flow_api.g_varchar2_table(1139) := '6E67206F6E206966206974277320616E206172726179206F72206E756D6265720A202A2040706172616D207B616E797D2076616C75650A202A2040706172616D207B4E756D6265727D20696E6465780A202A2040706172616D207B616E797D2064656661';
wwv_flow_api.g_varchar2_table(1140) := '756C7456616C75650A202A2F0A66756E6374696F6E2067657456616C75652876616C75652C20696E6465782C2064656661756C7456616C756529207B0A20206966202841727261792E697341727261792876616C75652929207B0A202020207661722076';
wwv_flow_api.g_varchar2_table(1141) := '203D2076616C75655B696E6465785D3B0A2020202072657475726E2076203D3D206E756C6C203F2064656661756C7456616C7565203A20763B0A20207D0A202072657475726E2076616C75653B0A7D0A0A2F2A2A0A202A20466F637573657320616E2065';
wwv_flow_api.g_varchar2_table(1142) := '6C656D656E74207768696C652070726576656E74696E672061207363726F6C6C206A756D702069662069742773206E6F742077697468696E207468650A202A2076696577706F72740A202A2040706172616D207B456C656D656E747D20656C0A202A2F0A';
wwv_flow_api.g_varchar2_table(1143) := '66756E6374696F6E20666F63757328656C29207B0A20207661722078203D2077696E646F772E7363726F6C6C58207C7C2077696E646F772E70616765584F66667365743B0A20207661722079203D2077696E646F772E7363726F6C6C59207C7C2077696E';
wwv_flow_api.g_varchar2_table(1144) := '646F772E70616765594F66667365743B0A2020656C2E666F63757328293B0A20207363726F6C6C28782C2079293B0A7D0A0A2F2A2A0A202A2044656665727320612066756E6374696F6E277320657865637574696F6E20756E74696C207468652063616C';
wwv_flow_api.g_varchar2_table(1145) := '6C20737461636B2068617320636C65617265640A202A2040706172616D207B46756E6374696F6E7D20666E0A202A2F0A66756E6374696F6E20646566657228666E29207B0A202073657454696D656F757428666E2C2031293B0A7D0A0A2F2A2A0A202A20';
wwv_flow_api.g_varchar2_table(1146) := '4465626F756E6365207574696C6974790A202A2040706172616D207B46756E6374696F6E7D20666E0A202A2040706172616D207B4E756D6265727D206D730A202A2F0A66756E6374696F6E206465626F756E6365243128666E2C206D7329207B0A202076';
wwv_flow_api.g_varchar2_table(1147) := '61722074696D656F75744964203D20766F696420303B0A202072657475726E2066756E6374696F6E202829207B0A20202020766172205F74686973203D20746869732C0A20202020202020205F617267756D656E7473203D20617267756D656E74733B0A';
wwv_flow_api.g_varchar2_table(1148) := '0A20202020636C65617254696D656F75742874696D656F75744964293B0A2020202074696D656F75744964203D2073657454696D656F75742866756E6374696F6E202829207B0A20202020202072657475726E20666E2E6170706C79285F746869732C20';
wwv_flow_api.g_varchar2_table(1149) := '5F617267756D656E7473293B0A202020207D2C206D73293B0A20207D3B0A7D0A0A2F2A2A0A202A2050726576656E7473206572726F72732066726F6D206265696E67207468726F776E207768696C6520616363657373696E67206E6573746564206D6F64';
wwv_flow_api.g_varchar2_table(1150) := '6966696572206F626A656374730A202A20696E2060706F707065724F7074696F6E73600A202A2040706172616D207B4F626A6563747D206F626A0A202A2040706172616D207B537472696E677D206B65790A202A204072657475726E207B4F626A656374';
wwv_flow_api.g_varchar2_table(1151) := '7C756E646566696E65647D0A202A2F0A66756E6374696F6E206765744D6F646966696572286F626A2C206B657929207B0A202072657475726E206F626A202626206F626A2E6D6F64696669657273202626206F626A2E6D6F646966696572735B6B65795D';
wwv_flow_api.g_varchar2_table(1152) := '3B0A7D0A0A2F2A2A0A202A2044657465726D696E657320696620616E206172726179206F7220737472696E6720696E636C7564657320612076616C75650A202A2040706172616D207B41727261797C537472696E677D20610A202A2040706172616D207B';
wwv_flow_api.g_varchar2_table(1153) := '616E797D20620A202A204072657475726E207B426F6F6C65616E7D0A202A2F0A66756E6374696F6E20696E636C7564657328612C206229207B0A202072657475726E20612E696E6465784F66286229203E202D313B0A7D0A0A7661722069735573696E67';
wwv_flow_api.g_varchar2_table(1154) := '546F756368203D2066616C73653B0A0A66756E6374696F6E206F6E446F63756D656E74546F7563682829207B0A20206966202869735573696E67546F75636829207B0A2020202072657475726E3B0A20207D0A0A202069735573696E67546F756368203D';
wwv_flow_api.g_varchar2_table(1155) := '20747275653B0A0A2020696620286973494F5329207B0A20202020646F63756D656E742E626F64792E636C6173734C6973742E616464282774697070792D694F5327293B0A20207D0A0A20206966202877696E646F772E706572666F726D616E63652920';
wwv_flow_api.g_varchar2_table(1156) := '7B0A20202020646F63756D656E742E6164644576656E744C697374656E657228276D6F7573656D6F7665272C206F6E446F63756D656E744D6F7573654D6F7665293B0A20207D0A7D0A0A766172206C6173744D6F7573654D6F766554696D65203D20303B';
wwv_flow_api.g_varchar2_table(1157) := '0A66756E6374696F6E206F6E446F63756D656E744D6F7573654D6F76652829207B0A2020766172206E6F77203D20706572666F726D616E63652E6E6F7728293B0A0A20202F2F204368726F6D652036302B2069732031206D6F7573656D6F766520706572';
wwv_flow_api.g_varchar2_table(1158) := '20616E696D6174696F6E206672616D652C207573652032306D732074696D6520646966666572656E63650A2020696620286E6F77202D206C6173744D6F7573654D6F766554696D65203C20323029207B0A2020202069735573696E67546F756368203D20';
wwv_flow_api.g_varchar2_table(1159) := '66616C73653B0A20202020646F63756D656E742E72656D6F76654576656E744C697374656E657228276D6F7573656D6F7665272C206F6E446F63756D656E744D6F7573654D6F7665293B0A2020202069662028216973494F5329207B0A20202020202064';
wwv_flow_api.g_varchar2_table(1160) := '6F63756D656E742E626F64792E636C6173734C6973742E72656D6F7665282774697070792D694F5327293B0A202020207D0A20207D0A0A20206C6173744D6F7573654D6F766554696D65203D206E6F773B0A7D0A0A66756E6374696F6E206F6E446F6375';
wwv_flow_api.g_varchar2_table(1161) := '6D656E74436C69636B285F72656629207B0A202076617220746172676574203D205F7265662E7461726765743B0A0A20202F2F2053696D756C61746564206576656E74732064697370617463686564206F6E2074686520646F63756D656E740A20206966';
wwv_flow_api.g_varchar2_table(1162) := '2028212874617267657420696E7374616E63656F6620456C656D656E742929207B0A2020202072657475726E2068696465416C6C506F707065727328293B0A20207D0A0A20202F2F20436C69636B6564206F6E20616E20696E7465726163746976652070';
wwv_flow_api.g_varchar2_table(1163) := '6F707065720A202076617220706F70706572203D20636C6F73657374287461726765742C2053656C6563746F72732E504F50504552293B0A202069662028706F7070657220262620706F707065722E5F746970707920262620706F707065722E5F746970';
wwv_flow_api.g_varchar2_table(1164) := '70792E70726F70732E696E74657261637469766529207B0A2020202072657475726E3B0A20207D0A0A20202F2F20436C69636B6564206F6E2061207265666572656E63650A2020766172207265666572656E6365203D20636C6F7365737443616C6C6261';
wwv_flow_api.g_varchar2_table(1165) := '636B287461726765742C2066756E6374696F6E2028656C29207B0A2020202072657475726E20656C2E5F746970707920262620656C2E5F74697070792E7265666572656E6365203D3D3D20656C3B0A20207D293B0A2020696620287265666572656E6365';
wwv_flow_api.g_varchar2_table(1166) := '29207B0A2020202076617220746970203D207265666572656E63652E5F74697070793B0A20202020766172206973436C69636B54726967676572203D20696E636C75646573287469702E70726F70732E747269676765722C2027636C69636B27293B0A0A';
wwv_flow_api.g_varchar2_table(1167) := '202020206966202869735573696E67546F756368207C7C206973436C69636B5472696767657229207B0A20202020202072657475726E2068696465416C6C506F707065727328746970293B0A202020207D0A0A20202020696620287469702E70726F7073';
wwv_flow_api.g_varchar2_table(1168) := '2E686964654F6E436C69636B20213D3D2074727565207C7C206973436C69636B5472696767657229207B0A20202020202072657475726E3B0A202020207D0A0A202020207469702E636C65617244656C617954696D656F75747328293B0A20207D0A0A20';
wwv_flow_api.g_varchar2_table(1169) := '2068696465416C6C506F707065727328293B0A7D0A0A66756E6374696F6E206F6E57696E646F77426C75722829207B0A2020766172205F646F63756D656E74203D20646F63756D656E742C0A202020202020616374697665456C656D656E74203D205F64';
wwv_flow_api.g_varchar2_table(1170) := '6F63756D656E742E616374697665456C656D656E743B0A0A202069662028616374697665456C656D656E7420262620616374697665456C656D656E742E626C757220262620616374697665456C656D656E742E5F746970707929207B0A20202020616374';
wwv_flow_api.g_varchar2_table(1171) := '697665456C656D656E742E626C757228293B0A20207D0A7D0A0A66756E6374696F6E206F6E57696E646F77526573697A652829207B0A2020617272617946726F6D28646F63756D656E742E717565727953656C6563746F72416C6C2853656C6563746F72';
wwv_flow_api.g_varchar2_table(1172) := '732E504F5050455229292E666F72456163682866756E6374696F6E2028706F7070657229207B0A20202020766172207469707079496E7374616E6365203D20706F707065722E5F74697070793B0A2020202069662028217469707079496E7374616E6365';
wwv_flow_api.g_varchar2_table(1173) := '2E70726F70732E6C697665506C6163656D656E7429207B0A2020202020207469707079496E7374616E63652E706F70706572496E7374616E63652E7363686564756C6555706461746528293B0A202020207D0A20207D293B0A7D0A0A2F2A2A0A202A2041';
wwv_flow_api.g_varchar2_table(1174) := '64647320746865206E656564656420676C6F62616C206576656E74206C697374656E6572730A202A2F0A66756E6374696F6E2062696E64476C6F62616C4576656E744C697374656E6572732829207B0A2020646F63756D656E742E6164644576656E744C';
wwv_flow_api.g_varchar2_table(1175) := '697374656E65722827636C69636B272C206F6E446F63756D656E74436C69636B2C2074727565293B0A2020646F63756D656E742E6164644576656E744C697374656E65722827746F7563687374617274272C206F6E446F63756D656E74546F7563682C20';
wwv_flow_api.g_varchar2_table(1176) := '50415353495645293B0A202077696E646F772E6164644576656E744C697374656E65722827626C7572272C206F6E57696E646F77426C7572293B0A202077696E646F772E6164644576656E744C697374656E65722827726573697A65272C206F6E57696E';
wwv_flow_api.g_varchar2_table(1177) := '646F77526573697A65293B0A0A20206966202821737570706F727473546F75636820262620286E6176696761746F722E6D6178546F756368506F696E7473207C7C206E6176696761746F722E6D734D6178546F756368506F696E74732929207B0A202020';
wwv_flow_api.g_varchar2_table(1178) := '20646F63756D656E742E6164644576656E744C697374656E65722827706F696E746572646F776E272C206F6E446F63756D656E74546F756368293B0A20207D0A7D0A0A766172206B657973203D204F626A6563742E6B6579732844656661756C7473293B';
wwv_flow_api.g_varchar2_table(1179) := '0A0A2F2A2A0A202A2044657465726D696E657320696620616E20656C656D656E742063616E207265636569766520666F6375730A202A2040706172616D207B456C656D656E747D20656C0A202A204072657475726E207B426F6F6C65616E7D0A202A2F0A';
wwv_flow_api.g_varchar2_table(1180) := '66756E6374696F6E2063616E52656365697665466F63757328656C29207B0A202072657475726E20656C20696E7374616E63656F6620456C656D656E74203F206D6174636865732E63616C6C28656C2C2027615B687265665D2C617265615B687265665D';
wwv_flow_api.g_varchar2_table(1181) := '2C627574746F6E2C64657461696C732C696E7075742C74657874617265612C73656C6563742C696672616D652C5B746162696E6465785D27292026262021656C2E686173417474726962757465282764697361626C65642729203A20747275653B0A7D0A';
wwv_flow_api.g_varchar2_table(1182) := '0A2F2A2A0A202A2052657475726E7320616E206F626A656374206F66206F7074696F6E616C2070726F70732066726F6D20646174612D74697070792D2A20617474726962757465730A202A2040706172616D207B456C656D656E747D207265666572656E';
wwv_flow_api.g_varchar2_table(1183) := '63650A202A204072657475726E207B4F626A6563747D0A202A2F0A66756E6374696F6E20676574446174614174747269627574654F7074696F6E73287265666572656E636529207B0A202072657475726E206B6579732E7265647563652866756E637469';
wwv_flow_api.g_varchar2_table(1184) := '6F6E20286163632C206B657929207B0A202020207661722076616C75654173537472696E67203D20287265666572656E63652E6765744174747269627574652827646174612D74697070792D27202B206B657929207C7C202727292E7472696D28293B0A';
wwv_flow_api.g_varchar2_table(1185) := '0A20202020696620282176616C75654173537472696E6729207B0A20202020202072657475726E206163633B0A202020207D0A0A20202020696620286B6579203D3D3D2027636F6E74656E742729207B0A2020202020206163635B6B65795D203D207661';
wwv_flow_api.g_varchar2_table(1186) := '6C75654173537472696E673B0A202020207D20656C7365206966202876616C75654173537472696E67203D3D3D2027747275652729207B0A2020202020206163635B6B65795D203D20747275653B0A202020207D20656C7365206966202876616C756541';
wwv_flow_api.g_varchar2_table(1187) := '73537472696E67203D3D3D202766616C73652729207B0A2020202020206163635B6B65795D203D2066616C73653B0A202020207D20656C7365206966202869734E756D6572696324312876616C75654173537472696E672929207B0A2020202020206163';
wwv_flow_api.g_varchar2_table(1188) := '635B6B65795D203D204E756D6265722876616C75654173537472696E67293B0A202020207D20656C7365206966202876616C75654173537472696E675B305D203D3D3D20275B27207C7C2076616C75654173537472696E675B305D203D3D3D20277B2729';
wwv_flow_api.g_varchar2_table(1189) := '207B0A2020202020206163635B6B65795D203D204A534F4E2E70617273652876616C75654173537472696E67293B0A202020207D20656C7365207B0A2020202020206163635B6B65795D203D2076616C75654173537472696E673B0A202020207D0A0A20';
wwv_flow_api.g_varchar2_table(1190) := '20202072657475726E206163633B0A20207D2C207B7D293B0A7D0A0A2F2A2A0A202A20506F6C7966696C6C7320746865207669727475616C207265666572656E63652028706C61696E206F626A65637429207769746820456C656D656E742E70726F746F';
wwv_flow_api.g_varchar2_table(1191) := '747970652070726F70730A202A204D75746174696E67206265636175736520444F4D20656C656D656E747320617265206D7574617465642C206164647320605F7469707079602070726F70657274790A202A2040706172616D207B4F626A6563747D2076';
wwv_flow_api.g_varchar2_table(1192) := '69727475616C5265666572656E63650A202A204072657475726E207B4F626A6563747D0A202A2F0A66756E6374696F6E20706F6C7966696C6C456C656D656E7450726F746F7479706550726F70657274696573287669727475616C5265666572656E6365';
wwv_flow_api.g_varchar2_table(1193) := '29207B0A202076617220706F6C7966696C6C73203D207B0A2020202069735669727475616C3A20747275652C0A20202020617474726962757465733A207669727475616C5265666572656E63652E61747472696275746573207C7C207B7D2C0A20202020';
wwv_flow_api.g_varchar2_table(1194) := '7365744174747269627574653A2066756E6374696F6E20736574417474726962757465286B65792C2076616C756529207B0A2020202020207669727475616C5265666572656E63652E617474726962757465735B6B65795D203D2076616C75653B0A2020';
wwv_flow_api.g_varchar2_table(1195) := '20207D2C0A202020206765744174747269627574653A2066756E6374696F6E20676574417474726962757465286B657929207B0A20202020202072657475726E207669727475616C5265666572656E63652E617474726962757465735B6B65795D3B0A20';
wwv_flow_api.g_varchar2_table(1196) := '2020207D2C0A2020202072656D6F76654174747269627574653A2066756E6374696F6E2072656D6F7665417474726962757465286B657929207B0A20202020202064656C657465207669727475616C5265666572656E63652E617474726962757465735B';
wwv_flow_api.g_varchar2_table(1197) := '6B65795D3B0A202020207D2C0A202020206861734174747269627574653A2066756E6374696F6E20686173417474726962757465286B657929207B0A20202020202072657475726E206B657920696E207669727475616C5265666572656E63652E617474';
wwv_flow_api.g_varchar2_table(1198) := '726962757465733B0A202020207D2C0A202020206164644576656E744C697374656E65723A2066756E6374696F6E206164644576656E744C697374656E65722829207B7D2C0A2020202072656D6F76654576656E744C697374656E65723A2066756E6374';
wwv_flow_api.g_varchar2_table(1199) := '696F6E2072656D6F76654576656E744C697374656E65722829207B7D2C0A0A20202020636C6173734C6973743A207B0A202020202020636C6173734E616D65733A207B7D2C0A2020202020206164643A2066756E6374696F6E20616464286B657929207B';
wwv_flow_api.g_varchar2_table(1200) := '0A20202020202020207669727475616C5265666572656E63652E636C6173734C6973742E636C6173734E616D65735B6B65795D203D20747275653B0A2020202020207D2C0A20202020202072656D6F76653A2066756E6374696F6E2072656D6F7665286B';
wwv_flow_api.g_varchar2_table(1201) := '657929207B0A202020202020202064656C657465207669727475616C5265666572656E63652E636C6173734C6973742E636C6173734E616D65735B6B65795D3B0A2020202020207D2C0A202020202020636F6E7461696E733A2066756E6374696F6E2063';
wwv_flow_api.g_varchar2_table(1202) := '6F6E7461696E73286B657929207B0A202020202020202072657475726E206B657920696E207669727475616C5265666572656E63652E636C6173734C6973742E636C6173734E616D65733B0A2020202020207D0A202020207D0A20207D3B0A0A2020666F';
wwv_flow_api.g_varchar2_table(1203) := '722028766172206B657920696E20706F6C7966696C6C7329207B0A202020207669727475616C5265666572656E63655B6B65795D203D20706F6C7966696C6C735B6B65795D3B0A20207D0A7D0A0A766172205F657874656E64732431203D204F626A6563';
wwv_flow_api.g_varchar2_table(1204) := '742E61737369676E207C7C2066756E6374696F6E202874617267657429207B0A2020666F7220287661722069203D20313B2069203C20617267756D656E74732E6C656E6774683B20692B2B29207B0A2020202076617220736F75726365203D2061726775';
wwv_flow_api.g_varchar2_table(1205) := '6D656E74735B695D3B0A0A20202020666F722028766172206B657920696E20736F7572636529207B0A202020202020696620284F626A6563742E70726F746F747970652E6861734F776E50726F70657274792E63616C6C28736F757263652C206B657929';
wwv_flow_api.g_varchar2_table(1206) := '29207B0A20202020202020207461726765745B6B65795D203D20736F757263655B6B65795D3B0A2020202020207D0A202020207D0A20207D0A0A202072657475726E207461726765743B0A7D3B0A0A2F2A2A0A202A204576616C75617465732074686520';
wwv_flow_api.g_varchar2_table(1207) := '70726F7073206F626A6563740A202A2040706172616D207B456C656D656E747D207265666572656E63650A202A2040706172616D207B4F626A6563747D2070726F70730A202A204072657475726E207B4F626A6563747D0A202A2F0A66756E6374696F6E';
wwv_flow_api.g_varchar2_table(1208) := '206576616C7561746550726F7073287265666572656E63652C2070726F707329207B0A2020766172206F7574203D205F657874656E64732431287B7D2C2070726F70732C2070726F70732E706572666F726D616E6365203F207B7D203A20676574446174';
wwv_flow_api.g_varchar2_table(1209) := '614174747269627574654F7074696F6E73287265666572656E636529293B0A0A2020696620286F75742E6172726F7729207B0A202020206F75742E616E696D61746546696C6C203D2066616C73653B0A20207D0A0A202069662028747970656F66206F75';
wwv_flow_api.g_varchar2_table(1210) := '742E617070656E64546F203D3D3D202766756E6374696F6E2729207B0A202020206F75742E617070656E64546F203D2070726F70732E617070656E64546F287265666572656E6365293B0A20207D0A0A202069662028747970656F66206F75742E636F6E';
wwv_flow_api.g_varchar2_table(1211) := '74656E74203D3D3D202766756E6374696F6E2729207B0A202020206F75742E636F6E74656E74203D2070726F70732E636F6E74656E74287265666572656E6365293B0A20207D0A0A202072657475726E206F75743B0A7D0A0A2F2A2A0A202A2056616C69';
wwv_flow_api.g_varchar2_table(1212) := '646174657320616E206F626A656374206F66206F7074696F6E732077697468207468652076616C69642064656661756C742070726F7073206F626A6563740A202A2040706172616D207B4F626A6563747D206F7074696F6E730A202A2040706172616D20';
wwv_flow_api.g_varchar2_table(1213) := '7B4F626A6563747D2064656661756C74730A202A2F0A66756E6374696F6E2076616C69646174654F7074696F6E732829207B0A2020766172206F7074696F6E73203D20617267756D656E74732E6C656E677468203E203020262620617267756D656E7473';
wwv_flow_api.g_varchar2_table(1214) := '5B305D20213D3D20756E646566696E6564203F20617267756D656E74735B305D203A207B7D3B0A20207661722064656661756C7473242431203D20617267756D656E74735B315D3B0A0A20204F626A6563742E6B657973286F7074696F6E73292E666F72';
wwv_flow_api.g_varchar2_table(1215) := '456163682866756E6374696F6E20286F7074696F6E29207B0A2020202069662028216861734F776E50726F70657274792864656661756C74732424312C206F7074696F6E2929207B0A2020202020207468726F77206E6577204572726F7228275B746970';
wwv_flow_api.g_varchar2_table(1216) := '70795D3A206027202B206F7074696F6E202B202760206973206E6F7420612076616C6964206F7074696F6E27293B0A202020207D0A20207D293B0A7D0A0A2F2F203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(1217) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0A2F2F20444550524543415445440A2F2F20416C6C206F66207468697320636F64652028666F722074686520606172726F775472616E73666F72';
wwv_flow_api.g_varchar2_table(1218) := '6D60206F7074696F6E292077696C6C2062652072656D6F76656420696E2076340A2F2F203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(1219) := '3D3D3D3D3D3D3D3D3D3D3D3D3D0A766172205452414E53464F524D5F4E554D4245525F5245203D207B0A20207472616E736C6174653A202F7472616E736C617465583F593F5C28285B5E295D2B295C292F2C0A20207363616C653A202F7363616C65583F';
wwv_flow_api.g_varchar2_table(1220) := '593F5C28285B5E295D2B295C292F0A0A20202F2A2A0A2020202A205472616E73666F726D732074686520782F792061786973206261736564206F6E2074686520706C6163656D656E740A2020202A2F0A7D3B66756E6374696F6E207472616E73666F726D';
wwv_flow_api.g_varchar2_table(1221) := '4178697342617365644F6E506C6163656D656E7428617869732C206973566572746963616C29207B0A202072657475726E20286973566572746963616C203F2061786973203A207B0A20202020583A202759272C0A20202020593A202758270A20207D5B';
wwv_flow_api.g_varchar2_table(1222) := '617869735D29207C7C2027273B0A7D0A0A2F2A2A0A202A205472616E73666F726D7320746865207363616C652F7472616E736C617465206E756D62657273206261736564206F6E2074686520706C6163656D656E740A202A2F0A66756E6374696F6E2074';
wwv_flow_api.g_varchar2_table(1223) := '72616E73666F726D4E756D6265727342617365644F6E506C6163656D656E7428747970652C206E756D626572732C206973566572746963616C2C2069735265766572736529207B0A20202F2A2A0A2020202A2041766F6964206465737472756374757269';
wwv_flow_api.g_varchar2_table(1224) := '6E6720626563617573652061206C6172676520626F696C6572706C6174652066756E6374696F6E2069732067656E6572617465640A2020202A20627920426162656C0A2020202A2F0A20207661722061203D206E756D626572735B305D3B0A2020766172';
wwv_flow_api.g_varchar2_table(1225) := '2062203D206E756D626572735B315D3B0A0A202069662028216120262620216229207B0A2020202072657475726E2027273B0A20207D0A0A2020766172207472616E73666F726D73203D207B0A202020207363616C653A2066756E6374696F6E20282920';
wwv_flow_api.g_varchar2_table(1226) := '7B0A20202020202069662028216229207B0A202020202020202072657475726E202727202B20613B0A2020202020207D20656C7365207B0A202020202020202072657475726E206973566572746963616C203F2061202B20272C2027202B2062203A2062';
wwv_flow_api.g_varchar2_table(1227) := '202B20272C2027202B20613B0A2020202020207D0A202020207D28292C0A202020207472616E736C6174653A2066756E6374696F6E202829207B0A20202020202069662028216229207B0A202020202020202072657475726E2069735265766572736520';
wwv_flow_api.g_varchar2_table(1228) := '3F202D61202B2027707827203A2061202B20277078273B0A2020202020207D20656C7365207B0A2020202020202020696620286973566572746963616C29207B0A2020202020202020202072657475726E20697352657665727365203F2061202B202770';
wwv_flow_api.g_varchar2_table(1229) := '782C2027202B202D62202B2027707827203A2061202B202770782C2027202B2062202B20277078273B0A20202020202020207D20656C7365207B0A2020202020202020202072657475726E20697352657665727365203F202D62202B202770782C202720';
wwv_flow_api.g_varchar2_table(1230) := '2B2061202B2027707827203A2062202B202770782C2027202B2061202B20277078273B0A20202020202020207D0A2020202020207D0A202020207D28290A20207D3B0A0A202072657475726E207472616E73666F726D735B747970655D3B0A7D0A0A2F2A';
wwv_flow_api.g_varchar2_table(1231) := '2A0A202A2052657475726E7320746865206178697320666F722061204353532066756E6374696F6E20287472616E736C617465206F72207363616C65290A202A2F0A66756E6374696F6E206765745472616E73666F726D41786973287374722C20637373';
wwv_flow_api.g_varchar2_table(1232) := '46756E6374696F6E29207B0A2020766172206D61746368203D207374722E6D61746368286E6577205265674578702863737346756E6374696F6E202B2027285B58595D292729293B0A202072657475726E206D61746368203F206D617463685B315D203A';
wwv_flow_api.g_varchar2_table(1233) := '2027273B0A7D0A0A2F2A2A0A202A2052657475726E7320746865206E756D6265727320676976656E20746F20746865204353532066756E6374696F6E0A202A2F0A66756E6374696F6E206765745472616E73666F726D4E756D62657273287374722C2072';
wwv_flow_api.g_varchar2_table(1234) := '6567657829207B0A2020766172206D61746368203D207374722E6D61746368287265676578293B0A202072657475726E206D61746368203F206D617463685B315D2E73706C697428272C27292E6D61702866756E6374696F6E20286E29207B0A20202020';
wwv_flow_api.g_varchar2_table(1235) := '72657475726E207061727365466C6F6174286E2C203130293B0A20207D29203A205B5D3B0A7D0A0A2F2A2A0A202A20436F6D707574657320746865206172726F772773207472616E73666F726D20736F207468617420697420697320636F727265637420';
wwv_flow_api.g_varchar2_table(1236) := '666F7220616E7920706C6163656D656E740A202A2F0A66756E6374696F6E20636F6D707574654172726F775472616E73666F726D286172726F772C206172726F775472616E73666F726D29207B0A202076617220706C6163656D656E74203D2067657450';
wwv_flow_api.g_varchar2_table(1237) := '6F70706572506C6163656D656E7428636C6F73657374286172726F772C2053656C6563746F72732E504F5050455229293B0A2020766172206973566572746963616C203D20696E636C75646573285B27746F70272C2027626F74746F6D275D2C20706C61';
wwv_flow_api.g_varchar2_table(1238) := '63656D656E74293B0A202076617220697352657665727365203D20696E636C75646573285B277269676874272C2027626F74746F6D275D2C20706C6163656D656E74293B0A0A2020766172206D617463686573242431203D207B0A202020207472616E73';
wwv_flow_api.g_varchar2_table(1239) := '6C6174653A207B0A202020202020617869733A206765745472616E73666F726D41786973286172726F775472616E73666F726D2C20277472616E736C61746527292C0A2020202020206E756D626572733A206765745472616E73666F726D4E756D626572';
wwv_flow_api.g_varchar2_table(1240) := '73286172726F775472616E73666F726D2C205452414E53464F524D5F4E554D4245525F52452E7472616E736C617465290A202020207D2C0A202020207363616C653A207B0A202020202020617869733A206765745472616E73666F726D41786973286172';
wwv_flow_api.g_varchar2_table(1241) := '726F775472616E73666F726D2C20277363616C6527292C0A2020202020206E756D626572733A206765745472616E73666F726D4E756D62657273286172726F775472616E73666F726D2C205452414E53464F524D5F4E554D4245525F52452E7363616C65';
wwv_flow_api.g_varchar2_table(1242) := '290A202020207D0A20207D3B0A0A202076617220636F6D70757465645472616E73666F726D203D206172726F775472616E73666F726D2E7265706C616365285452414E53464F524D5F4E554D4245525F52452E7472616E736C6174652C20277472616E73';
wwv_flow_api.g_varchar2_table(1243) := '6C61746527202B207472616E73666F726D4178697342617365644F6E506C6163656D656E74286D6174636865732424312E7472616E736C6174652E617869732C206973566572746963616C29202B20272827202B207472616E73666F726D4E756D626572';
wwv_flow_api.g_varchar2_table(1244) := '7342617365644F6E506C6163656D656E7428277472616E736C617465272C206D6174636865732424312E7472616E736C6174652E6E756D626572732C206973566572746963616C2C2069735265766572736529202B20272927292E7265706C6163652854';
wwv_flow_api.g_varchar2_table(1245) := '52414E53464F524D5F4E554D4245525F52452E7363616C652C20277363616C6527202B207472616E73666F726D4178697342617365644F6E506C6163656D656E74286D6174636865732424312E7363616C652E617869732C206973566572746963616C29';
wwv_flow_api.g_varchar2_table(1246) := '202B20272827202B207472616E73666F726D4E756D6265727342617365644F6E506C6163656D656E7428277363616C65272C206D6174636865732424312E7363616C652E6E756D626572732C206973566572746963616C2C206973526576657273652920';
wwv_flow_api.g_varchar2_table(1247) := '2B20272927293B0A0A20206172726F772E7374796C655B747970656F6620646F63756D656E742E626F64792E7374796C652E7472616E73666F726D20213D3D2027756E646566696E656427203F20277472616E73666F726D27203A20277765626B697454';
wwv_flow_api.g_varchar2_table(1248) := '72616E73666F726D275D203D20636F6D70757465645472616E73666F726D3B0A7D0A0A766172206964436F756E746572203D20313B0A0A2F2A2A0A202A204372656174657320616E642072657475726E732061205469707079206F626A6563742E205765';
wwv_flow_api.g_varchar2_table(1249) := '277265207573696E67206120636C6F73757265207061747465726E20696E7374656164206F660A202A206120636C61737320736F207468617420746865206578706F736564206F626A6563742041504920697320636C65616E20776974686F7574207072';
wwv_flow_api.g_varchar2_table(1250) := '6976617465206D656D626572730A202A207072656669786564207769746820605F602E0A202A2040706172616D207B456C656D656E747D207265666572656E63650A202A2040706172616D207B4F626A6563747D20636F6C6C656374696F6E50726F7073';
wwv_flow_api.g_varchar2_table(1251) := '0A202A204072657475726E207B4F626A6563747D20696E7374616E63650A202A2F0A66756E6374696F6E206372656174655469707079287265666572656E63652C20636F6C6C656374696F6E50726F707329207B0A20207661722070726F7073203D2065';
wwv_flow_api.g_varchar2_table(1252) := '76616C7561746550726F7073287265666572656E63652C20636F6C6C656374696F6E50726F7073293B0A0A20202F2F20496620746865207265666572656E63652073686F756C646E27742068617665206D756C7469706C65207469707079732C20726574';
wwv_flow_api.g_varchar2_table(1253) := '75726E206E756C6C206561726C790A2020696620282170726F70732E6D756C7469706C65202626207265666572656E63652E5F746970707929207B0A2020202072657475726E206E756C6C3B0A20207D0A0A20202F2A203D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(1254) := '3D3D3D3D3D3D3D3D3D3D20F09F94922050726976617465206D656D6265727320F09F9492203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A20202F2F2054686520706F7070657220656C656D656E742773206D75746174696F6E206F';
wwv_flow_api.g_varchar2_table(1255) := '627365727665720A202076617220706F707065724D75746174696F6E4F62736572766572203D206E756C6C3B0A0A20202F2F20546865206C6173742074726967676572206576656E74206F626A6563742074686174206361757365642074686520746970';
wwv_flow_api.g_varchar2_table(1256) := '707920746F2073686F770A2020766172206C617374547269676765724576656E74203D207B7D3B0A0A20202F2F20546865206C617374206D6F7573656D6F7665206576656E74206F626A65637420637265617465642062792074686520646F63756D656E';
wwv_flow_api.g_varchar2_table(1257) := '74206D6F7573656D6F7665206576656E740A2020766172206C6173744D6F7573654D6F76654576656E74203D206E756C6C3B0A0A20202F2F2054696D656F75742063726561746564206279207468652073686F772064656C61790A20207661722073686F';
wwv_flow_api.g_varchar2_table(1258) := '7754696D656F75744964203D20303B0A0A20202F2F2054696D656F757420637265617465642062792074686520686964652064656C61790A2020766172206869646554696D656F75744964203D20303B0A0A20202F2F20466C616720746F206465746572';
wwv_flow_api.g_varchar2_table(1259) := '6D696E652069662074686520746970707920697320707265706172696E6720746F2073686F772064756520746F207468652073686F772074696D656F75740A2020766172206973507265706172696E67546F53686F77203D2066616C73653B0A0A20202F';
wwv_flow_api.g_varchar2_table(1260) := '2F205468652063757272656E7420607472616E736974696F6E656E64602063616C6C6261636B207265666572656E63650A2020766172207472616E736974696F6E456E644C697374656E6572203D2066756E6374696F6E207472616E736974696F6E456E';
wwv_flow_api.g_varchar2_table(1261) := '644C697374656E65722829207B7D3B0A0A20202F2F204172726179206F66206576656E74206C697374656E6572732063757272656E746C7920617474616368656420746F20746865207265666572656E636520656C656D656E740A2020766172206C6973';
wwv_flow_api.g_varchar2_table(1262) := '74656E657273203D205B5D3B0A0A20202F2F20466C616720746F2064657465726D696E6520696620746865207265666572656E63652077617320726563656E746C792070726F6772616D6D61746963616C6C7920666F63757365640A2020766172207265';
wwv_flow_api.g_varchar2_table(1263) := '666572656E63654A75737450726F6772616D6D61746963616C6C79466F6375736564203D2066616C73653B0A0A20202F2F2050726976617465206F6E4D6F7573654D6F76652068616E646C6572207265666572656E63652C206465626F756E636564206F';
wwv_flow_api.g_varchar2_table(1264) := '72206E6F740A2020766172206465626F756E6365644F6E4D6F7573654D6F7665203D2070726F70732E696E7465726163746976654465626F756E6365203E2030203F206465626F756E63652431286F6E4D6F7573654D6F76652C2070726F70732E696E74';
wwv_flow_api.g_varchar2_table(1265) := '65726163746976654465626F756E636529203A206F6E4D6F7573654D6F76653B0A0A20202F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D20F09F9491205075626C6963206D656D6265727320F09F9491203D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(1266) := '3D3D3D3D3D3D3D3D3D3D3D202A2F0A20202F2F206964207573656420666F72207468652060617269612D646573637269626564627960202F2060617269612D6C6162656C6C6564627960206174747269627574650A2020766172206964203D206964436F';
wwv_flow_api.g_varchar2_table(1267) := '756E7465722B2B3B0A0A20202F2F20506F7070657220656C656D656E74207265666572656E63650A202076617220706F70706572203D20637265617465506F70706572456C656D656E742869642C2070726F7073293B0A0A20202F2F2050726576656E74';
wwv_flow_api.g_varchar2_table(1268) := '2061207469707079207769746820612064656C61792066726F6D20686964696E672069662074686520637572736F72206C656674207468656E2072657475726E65640A20202F2F206265666F7265206974207374617274656420686964696E670A202070';
wwv_flow_api.g_varchar2_table(1269) := '6F707065722E6164644576656E744C697374656E657228276D6F757365656E746572272C2066756E6374696F6E20286576656E7429207B0A20202020696620287469702E70726F70732E696E746572616374697665202626207469702E73746174652E69';
wwv_flow_api.g_varchar2_table(1270) := '7356697369626C65202626206C617374547269676765724576656E742E74797065203D3D3D20276D6F757365656E7465722729207B0A2020202020207072657061726553686F77286576656E74293B0A202020207D0A20207D293B0A2020706F70706572';
wwv_flow_api.g_varchar2_table(1271) := '2E6164644576656E744C697374656E657228276D6F7573656C65617665272C2066756E6374696F6E20286576656E7429207B0A20202020696620287469702E70726F70732E696E746572616374697665202626206C617374547269676765724576656E74';
wwv_flow_api.g_varchar2_table(1272) := '2E74797065203D3D3D20276D6F757365656E74657227202626207469702E70726F70732E696E7465726163746976654465626F756E6365203D3D3D2030202626206973437572736F724F757473696465496E746572616374697665426F72646572286765';
wwv_flow_api.g_varchar2_table(1273) := '74506F70706572506C6163656D656E7428706F70706572292C20706F707065722E676574426F756E64696E67436C69656E745265637428292C206576656E742C207469702E70726F70732929207B0A202020202020707265706172654869646528293B0A';
wwv_flow_api.g_varchar2_table(1274) := '202020207D0A20207D293B0A0A20202F2F20506F7070657220656C656D656E74206368696C6472656E3A207B206172726F772C206261636B64726F702C20636F6E74656E742C20746F6F6C746970207D0A202076617220706F707065724368696C647265';
wwv_flow_api.g_varchar2_table(1275) := '6E203D206765744368696C6472656E28706F70706572293B0A0A20202F2F20546865207374617465206F66207468652074697070790A2020766172207374617465203D207B0A202020202F2F204966207468652074697070792069732063757272656E74';
wwv_flow_api.g_varchar2_table(1276) := '6C7920656E61626C65640A202020206973456E61626C65643A20747275652C0A202020202F2F2073686F77282920696E766F6B65642C206E6F742063757272656E746C79207472616E736974696F6E696E67206F75740A20202020697356697369626C65';
wwv_flow_api.g_varchar2_table(1277) := '3A2066616C73652C0A202020202F2F2049662074686520746970707920686173206265656E2064657374726F7965640A20202020697344657374726F7965643A2066616C73652C0A202020202F2F20496620746865207469707079206973206F6E207468';
wwv_flow_api.g_varchar2_table(1278) := '6520444F4D20287472616E736974696F6E696E67206F7574206F7220696E290A2020202069734D6F756E7465643A2066616C73652C0A202020202F2F2073686F772829207472616E736974696F6E2066696E69736865640A20202020697353686F776E3A';
wwv_flow_api.g_varchar2_table(1279) := '2066616C73650A0A202020202F2F20506F707065722E6A7320696E7374616E636520666F7220746865207469707079206973206C617A696C7920637265617465640A20207D3B76617220706F70706572496E7374616E6365203D206E756C6C3B0A0A2020';
wwv_flow_api.g_varchar2_table(1280) := '2F2F20F09F8C9F20746970707920696E7374616E63650A202076617220746970203D207B0A202020202F2F2070726F706572746965730A2020202069643A2069642C0A202020207265666572656E63653A207265666572656E63652C0A20202020706F70';
wwv_flow_api.g_varchar2_table(1281) := '7065723A20706F707065722C0A20202020706F707065724368696C6472656E3A20706F707065724368696C6472656E2C0A20202020706F70706572496E7374616E63653A20706F70706572496E7374616E63652C0A2020202070726F70733A2070726F70';
wwv_flow_api.g_varchar2_table(1282) := '732C0A2020202073746174653A2073746174652C0A202020202F2F206D6574686F64730A20202020636C65617244656C617954696D656F7574733A20636C65617244656C617954696D656F7574732C0A202020207365743A207365742424312C0A202020';
wwv_flow_api.g_varchar2_table(1283) := '20736574436F6E74656E743A20736574436F6E74656E742424312C0A2020202073686F773A2073686F772C0A20202020686964653A20686964652C0A20202020656E61626C653A20656E61626C652C0A2020202064697361626C653A2064697361626C65';
wwv_flow_api.g_varchar2_table(1284) := '2C0A2020202064657374726F793A2064657374726F790A20207D3B0A0A20206164645472696767657273546F5265666572656E636528293B0A0A20207265666572656E63652E6164644576656E744C697374656E65722827636C69636B272C206F6E5265';
wwv_flow_api.g_varchar2_table(1285) := '666572656E6365436C69636B293B0A0A2020696620282170726F70732E6C617A7929207B0A202020207469702E706F70706572496E7374616E6365203D20637265617465506F70706572496E7374616E636528293B0A202020207469702E706F70706572';
wwv_flow_api.g_varchar2_table(1286) := '496E7374616E63652E64697361626C654576656E744C697374656E65727328293B0A20207D0A0A20206966202870726F70732E73686F774F6E496E697429207B0A202020207072657061726553686F7728293B0A20207D0A0A20202F2F20456E73757265';
wwv_flow_api.g_varchar2_table(1287) := '20746865207265666572656E636520656C656D656E742063616E207265636569766520666F6375732028616E64206973206E6F7420612064656C6567617465290A20206966202870726F70732E61313179202626202170726F70732E7461726765742026';
wwv_flow_api.g_varchar2_table(1288) := '26202163616E52656365697665466F637573287265666572656E63652929207B0A202020207265666572656E63652E7365744174747269627574652827746162696E646578272C20273027293B0A20207D0A0A20202F2F20496E7374616C6C2073686F72';
wwv_flow_api.g_varchar2_table(1289) := '74637574730A20207265666572656E63652E5F7469707079203D207469703B0A2020706F707065722E5F7469707079203D207469703B0A0A202072657475726E207469703B0A0A20202F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D20';
wwv_flow_api.g_varchar2_table(1290) := 'F09F94922050726976617465206D6574686F647320F09F9492203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A20202F2A2A0A2020202A20496620746865207265666572656E63652077617320636C69636B65642C20697420616C73';
wwv_flow_api.g_varchar2_table(1291) := '6F20726563656976657320666F6375730A2020202A2F0A202066756E6374696F6E206F6E5265666572656E6365436C69636B2829207B0A2020202064656665722866756E6374696F6E202829207B0A2020202020207265666572656E63654A7573745072';
wwv_flow_api.g_varchar2_table(1292) := '6F6772616D6D61746963616C6C79466F6375736564203D2066616C73653B0A202020207D293B0A20207D0A0A20202F2A2A0A2020202A20456E737572652074686520706F70706572277320706F736974696F6E20737461797320636F7272656374206966';
wwv_flow_api.g_varchar2_table(1293) := '206974732064696D656E73696F6E73206368616E67652E205573650A2020202A207570646174652829206F766572202E7363686564756C65557064617465282920736F207468657265206973206E6F2031206672616D6520666C6173682064756520746F';
wwv_flow_api.g_varchar2_table(1294) := '0A2020202A206173796E63207570646174650A2020202A2F0A202066756E6374696F6E206164644D75746174696F6E4F627365727665722829207B0A20202020706F707065724D75746174696F6E4F62736572766572203D206E6577204D75746174696F';
wwv_flow_api.g_varchar2_table(1295) := '6E4F627365727665722866756E6374696F6E202829207B0A2020202020207469702E706F70706572496E7374616E63652E75706461746528293B0A202020207D293B0A20202020706F707065724D75746174696F6E4F627365727665722E6F6273657276';
wwv_flow_api.g_varchar2_table(1296) := '6528706F707065722C207B0A2020202020206368696C644C6973743A20747275652C0A202020202020737562747265653A20747275652C0A202020202020636861726163746572446174613A20747275650A202020207D293B0A20207D0A0A20202F2A2A';
wwv_flow_api.g_varchar2_table(1297) := '0A2020202A20506F736974696F6E7320746865207669727475616C207265666572656E6365206E65617220746865206D6F75736520637572736F720A2020202A2F0A202066756E6374696F6E20706F736974696F6E5669727475616C5265666572656E63';
wwv_flow_api.g_varchar2_table(1298) := '654E656172437572736F72286576656E7429207B0A20202020766172205F6C6173744D6F7573654D6F76654576656E74203D206C6173744D6F7573654D6F76654576656E74203D206576656E742C0A2020202020202020636C69656E7458203D205F6C61';
wwv_flow_api.g_varchar2_table(1299) := '73744D6F7573654D6F76654576656E742E636C69656E74582C0A2020202020202020636C69656E7459203D205F6C6173744D6F7573654D6F76654576656E742E636C69656E74593B0A0A2020202069662028217469702E706F70706572496E7374616E63';
wwv_flow_api.g_varchar2_table(1300) := '6529207B0A20202020202072657475726E3B0A202020207D0A0A202020202F2F20456E73757265207669727475616C207265666572656E6365206973207061646465642062792035707820746F2070726576656E7420746F6F6C7469702066726F6D0A20';
wwv_flow_api.g_varchar2_table(1301) := '2020202F2F206F766572666C6F77696E672E204D6179626520506F707065722E6A732069737375653F0A2020202076617220706C6163656D656E74203D20676574506F70706572506C6163656D656E74287469702E706F70706572293B0A202020207661';
wwv_flow_api.g_varchar2_table(1302) := '722070616464696E67203D207469702E706F707065724368696C6472656E2E6172726F77203F203230203A20353B0A20202020766172206973566572746963616C506C6163656D656E74203D20696E636C75646573285B27746F70272C2027626F74746F';
wwv_flow_api.g_varchar2_table(1303) := '6D275D2C20706C6163656D656E74293B0A20202020766172206973486F72697A6F6E74616C506C6163656D656E74203D20696E636C75646573285B276C656674272C20277269676874275D2C20706C6163656D656E74293B0A0A202020202F2F20546F70';
wwv_flow_api.g_varchar2_table(1304) := '202F206C65667420626F756E646172790A202020207661722078203D206973566572746963616C506C6163656D656E74203F204D6174682E6D61782870616464696E672C20636C69656E745829203A20636C69656E74583B0A202020207661722079203D';
wwv_flow_api.g_varchar2_table(1305) := '206973486F72697A6F6E74616C506C6163656D656E74203F204D6174682E6D61782870616464696E672C20636C69656E745929203A20636C69656E74593B0A0A202020202F2F20426F74746F6D202F20726967687420626F756E646172790A2020202069';
wwv_flow_api.g_varchar2_table(1306) := '6620286973566572746963616C506C6163656D656E742026262078203E2070616464696E6729207B0A20202020202078203D204D6174682E6D696E28636C69656E74582C2077696E646F772E696E6E65725769647468202D2070616464696E67293B0A20';
wwv_flow_api.g_varchar2_table(1307) := '2020207D0A20202020696620286973486F72697A6F6E74616C506C6163656D656E742026262079203E2070616464696E6729207B0A20202020202079203D204D6174682E6D696E28636C69656E74592C2077696E646F772E696E6E657248656967687420';
wwv_flow_api.g_varchar2_table(1308) := '2D2070616464696E67293B0A202020207D0A0A202020207661722072656374203D207469702E7265666572656E63652E676574426F756E64696E67436C69656E745265637428293B0A2020202076617220666F6C6C6F77437572736F72203D207469702E';
wwv_flow_api.g_varchar2_table(1309) := '70726F70732E666F6C6C6F77437572736F723B0A0A20202020766172206973486F72697A6F6E74616C203D20666F6C6C6F77437572736F72203D3D3D2027686F72697A6F6E74616C273B0A20202020766172206973566572746963616C203D20666F6C6C';
wwv_flow_api.g_varchar2_table(1310) := '6F77437572736F72203D3D3D2027766572746963616C273B0A0A202020207469702E706F70706572496E7374616E63652E7265666572656E6365203D207B0A202020202020676574426F756E64696E67436C69656E74526563743A2066756E6374696F6E';
wwv_flow_api.g_varchar2_table(1311) := '20676574426F756E64696E67436C69656E74526563742829207B0A202020202020202072657475726E207B0A2020202020202020202077696474683A20302C0A202020202020202020206865696768743A20302C0A20202020202020202020746F703A20';
wwv_flow_api.g_varchar2_table(1312) := '6973486F72697A6F6E74616C203F20726563742E746F70203A20792C0A20202020202020202020626F74746F6D3A206973486F72697A6F6E74616C203F20726563742E626F74746F6D203A20792C0A202020202020202020206C6566743A206973566572';
wwv_flow_api.g_varchar2_table(1313) := '746963616C203F20726563742E6C656674203A20782C0A2020202020202020202072696768743A206973566572746963616C203F20726563742E7269676874203A20780A20202020202020207D3B0A2020202020207D2C0A202020202020636C69656E74';
wwv_flow_api.g_varchar2_table(1314) := '57696474683A20302C0A202020202020636C69656E744865696768743A20300A202020207D3B0A0A202020207469702E706F70706572496E7374616E63652E7363686564756C6555706461746528293B0A0A2020202069662028666F6C6C6F7743757273';
wwv_flow_api.g_varchar2_table(1315) := '6F72203D3D3D2027696E697469616C27202626207469702E73746174652E697356697369626C6529207B0A20202020202072656D6F7665466F6C6C6F77437572736F724C697374656E657228293B0A202020207D0A20207D0A0A20202F2A2A0A2020202A';
wwv_flow_api.g_varchar2_table(1316) := '20437265617465732074686520746970707920696E7374616E636520666F7220612064656C6567617465207768656E2069742773206265656E207472696767657265640A2020202A2F0A202066756E6374696F6E2063726561746544656C656761746543';
wwv_flow_api.g_varchar2_table(1317) := '68696C645469707079286576656E7429207B0A2020202076617220746172676574456C203D20636C6F73657374286576656E742E7461726765742C207469702E70726F70732E746172676574293B0A2020202069662028746172676574456C2026262021';
wwv_flow_api.g_varchar2_table(1318) := '746172676574456C2E5F746970707929207B0A202020202020637265617465546970707928746172676574456C2C205F657874656E64732431287B7D2C207469702E70726F70732C207B0A20202020202020207461726765743A2027272C0A2020202020';
wwv_flow_api.g_varchar2_table(1319) := '20202073686F774F6E496E69743A20747275650A2020202020207D29293B0A2020202020207072657061726553686F77286576656E74293B0A202020207D0A20207D0A0A20202F2A2A0A2020202A205365747570206265666F72652073686F7728292069';
wwv_flow_api.g_varchar2_table(1320) := '7320696E766F6B6564202864656C6179732C206574632E290A2020202A2F0A202066756E6374696F6E207072657061726553686F77286576656E7429207B0A20202020636C65617244656C617954696D656F75747328293B0A0A20202020696620287469';
wwv_flow_api.g_varchar2_table(1321) := '702E73746174652E697356697369626C6529207B0A20202020202072657475726E3B0A202020207D0A0A202020202F2F20497320612064656C65676174652C2063726561746520616E20696E7374616E636520666F7220746865206368696C6420746172';
wwv_flow_api.g_varchar2_table(1322) := '6765740A20202020696620287469702E70726F70732E74617267657429207B0A20202020202072657475726E2063726561746544656C65676174654368696C645469707079286576656E74293B0A202020207D0A0A202020206973507265706172696E67';
wwv_flow_api.g_varchar2_table(1323) := '546F53686F77203D20747275653B0A0A20202020696620287469702E70726F70732E7761697429207B0A20202020202072657475726E207469702E70726F70732E77616974287469702C206576656E74293B0A202020207D0A0A202020202F2F20496620';
wwv_flow_api.g_varchar2_table(1324) := '74686520746F6F6C7469702068617320612064656C61792C207765206E65656420746F206265206C697374656E696E6720746F20746865206D6F7573656D6F76652061730A202020202F2F20736F6F6E206173207468652074726967676572206576656E';
wwv_flow_api.g_varchar2_table(1325) := '742069732066697265642C20736F2074686174206974277320696E2074686520636F727265637420706F736974696F6E0A202020202F2F2075706F6E206D6F756E742E0A202020202F2F204564676520636173653A2069662074686520746F6F6C746970';
wwv_flow_api.g_varchar2_table(1326) := '206973207374696C6C206D6F756E7465642C20627574207468656E207072657061726553686F7728292069730A202020202F2F2063616C6C65642C206974206361757365732061206A756D702E0A2020202069662028686173466F6C6C6F77437572736F';
wwv_flow_api.g_varchar2_table(1327) := '724265686176696F72282920262620217469702E73746174652E69734D6F756E74656429207B0A202020202020646F63756D656E742E6164644576656E744C697374656E657228276D6F7573656D6F7665272C20706F736974696F6E5669727475616C52';
wwv_flow_api.g_varchar2_table(1328) := '65666572656E63654E656172437572736F72293B0A202020207D0A0A202020207661722064656C6179203D2067657456616C7565287469702E70726F70732E64656C61792C20302C2044656661756C74732E64656C6179293B0A0A202020206966202864';
wwv_flow_api.g_varchar2_table(1329) := '656C617929207B0A20202020202073686F7754696D656F75744964203D2073657454696D656F75742866756E6374696F6E202829207B0A202020202020202073686F7728293B0A2020202020207D2C2064656C6179293B0A202020207D20656C7365207B';
wwv_flow_api.g_varchar2_table(1330) := '0A20202020202073686F7728293B0A202020207D0A20207D0A0A20202F2A2A0A2020202A205365747570206265666F72652068696465282920697320696E766F6B6564202864656C6179732C206574632E290A2020202A2F0A202066756E6374696F6E20';
wwv_flow_api.g_varchar2_table(1331) := '70726570617265486964652829207B0A20202020636C65617244656C617954696D656F75747328293B0A0A2020202069662028217469702E73746174652E697356697369626C6529207B0A20202020202072657475726E2072656D6F7665466F6C6C6F77';
wwv_flow_api.g_varchar2_table(1332) := '437572736F724C697374656E657228293B0A202020207D0A0A202020206973507265706172696E67546F53686F77203D2066616C73653B0A0A202020207661722064656C6179203D2067657456616C7565287469702E70726F70732E64656C61792C2031';
wwv_flow_api.g_varchar2_table(1333) := '2C2044656661756C74732E64656C6179293B0A0A202020206966202864656C617929207B0A2020202020206869646554696D656F75744964203D2073657454696D656F75742866756E6374696F6E202829207B0A2020202020202020696620287469702E';
wwv_flow_api.g_varchar2_table(1334) := '73746174652E697356697369626C6529207B0A202020202020202020206869646528293B0A20202020202020207D0A2020202020207D2C2064656C6179293B0A202020207D20656C7365207B0A2020202020206869646528293B0A202020207D0A20207D';
wwv_flow_api.g_varchar2_table(1335) := '0A0A20202F2A2A0A2020202A2052656D6F7665732074686520666F6C6C6F7720637572736F72206C697374656E65720A2020202A2F0A202066756E6374696F6E2072656D6F7665466F6C6C6F77437572736F724C697374656E65722829207B0A20202020';
wwv_flow_api.g_varchar2_table(1336) := '646F63756D656E742E72656D6F76654576656E744C697374656E657228276D6F7573656D6F7665272C20706F736974696F6E5669727475616C5265666572656E63654E656172437572736F72293B0A202020206C6173744D6F7573654D6F76654576656E';
wwv_flow_api.g_varchar2_table(1337) := '74203D206E756C6C3B0A20207D0A0A20202F2A2A0A2020202A20436C65616E73207570206F6C64206C697374656E6572730A2020202A2F0A202066756E6374696F6E20636C65616E75704F6C644D6F7573654C697374656E6572732829207B0A20202020';
wwv_flow_api.g_varchar2_table(1338) := '646F63756D656E742E626F64792E72656D6F76654576656E744C697374656E657228276D6F7573656C65617665272C207072657061726548696465293B0A20202020646F63756D656E742E72656D6F76654576656E744C697374656E657228276D6F7573';
wwv_flow_api.g_varchar2_table(1339) := '656D6F7665272C206465626F756E6365644F6E4D6F7573654D6F7665293B0A20207D0A0A20202F2A2A0A2020202A204576656E74206C697374656E657220696E766F6B65642075706F6E20747269676765720A2020202A2F0A202066756E6374696F6E20';
wwv_flow_api.g_varchar2_table(1340) := '6F6E54726967676572286576656E7429207B0A2020202069662028217469702E73746174652E6973456E61626C6564207C7C2069734576656E744C697374656E657253746F70706564286576656E742929207B0A20202020202072657475726E3B0A2020';
wwv_flow_api.g_varchar2_table(1341) := '20207D0A0A2020202069662028217469702E73746174652E697356697369626C6529207B0A2020202020206C617374547269676765724576656E74203D206576656E743B0A202020207D0A0A202020202F2F20546F67676C652073686F772F6869646520';
wwv_flow_api.g_varchar2_table(1342) := '7768656E20636C69636B696E6720636C69636B2D74726967676572656420746F6F6C746970730A20202020696620286576656E742E74797065203D3D3D2027636C69636B27202626207469702E70726F70732E686964654F6E436C69636B20213D3D2066';
wwv_flow_api.g_varchar2_table(1343) := '616C7365202626207469702E73746174652E697356697369626C6529207B0A202020202020707265706172654869646528293B0A202020207D20656C7365207B0A2020202020207072657061726553686F77286576656E74293B0A202020207D0A20207D';
wwv_flow_api.g_varchar2_table(1344) := '0A0A20202F2A2A0A2020202A204576656E74206C697374656E6572207573656420666F7220696E74657261637469766520746F6F6C7469707320746F20646574656374207768656E20746865792073686F756C640A2020202A20686964650A2020202A2F';
wwv_flow_api.g_varchar2_table(1345) := '0A202066756E6374696F6E206F6E4D6F7573654D6F7665286576656E7429207B0A20202020766172207265666572656E6365546865437572736F7249734F766572203D20636C6F7365737443616C6C6261636B286576656E742E7461726765742C206675';
wwv_flow_api.g_varchar2_table(1346) := '6E6374696F6E2028656C29207B0A20202020202072657475726E20656C2E5F74697070793B0A202020207D293B0A0A20202020766172206973437572736F724F766572506F70706572203D20636C6F73657374286576656E742E7461726765742C205365';
wwv_flow_api.g_varchar2_table(1347) := '6C6563746F72732E504F5050455229203D3D3D207469702E706F707065723B0A20202020766172206973437572736F724F7665725265666572656E6365203D207265666572656E6365546865437572736F7249734F766572203D3D3D207469702E726566';
wwv_flow_api.g_varchar2_table(1348) := '6572656E63653B0A0A20202020696620286973437572736F724F766572506F70706572207C7C206973437572736F724F7665725265666572656E636529207B0A20202020202072657475726E3B0A202020207D0A0A20202020696620286973437572736F';
wwv_flow_api.g_varchar2_table(1349) := '724F757473696465496E746572616374697665426F7264657228676574506F70706572506C6163656D656E74287469702E706F70706572292C207469702E706F707065722E676574426F756E64696E67436C69656E745265637428292C206576656E742C';
wwv_flow_api.g_varchar2_table(1350) := '207469702E70726F70732929207B0A202020202020636C65616E75704F6C644D6F7573654C697374656E65727328293B0A202020202020707265706172654869646528293B0A202020207D0A20207D0A0A20202F2A2A0A2020202A204576656E74206C69';
wwv_flow_api.g_varchar2_table(1351) := '7374656E657220696E766F6B65642075706F6E206D6F7573656C656176650A2020202A2F0A202066756E6374696F6E206F6E4D6F7573654C65617665286576656E7429207B0A202020206966202869734576656E744C697374656E657253746F70706564';
wwv_flow_api.g_varchar2_table(1352) := '286576656E742929207B0A20202020202072657475726E3B0A202020207D0A0A20202020696620287469702E70726F70732E696E74657261637469766529207B0A202020202020646F63756D656E742E626F64792E6164644576656E744C697374656E65';
wwv_flow_api.g_varchar2_table(1353) := '7228276D6F7573656C65617665272C207072657061726548696465293B0A202020202020646F63756D656E742E6164644576656E744C697374656E657228276D6F7573656D6F7665272C206465626F756E6365644F6E4D6F7573654D6F7665293B0A2020';
wwv_flow_api.g_varchar2_table(1354) := '2020202072657475726E3B0A202020207D0A0A20202020707265706172654869646528293B0A20207D0A0A20202F2A2A0A2020202A204576656E74206C697374656E657220696E766F6B65642075706F6E20626C75720A2020202A2F0A202066756E6374';
wwv_flow_api.g_varchar2_table(1355) := '696F6E206F6E426C7572286576656E7429207B0A20202020696620286576656E742E74617267657420213D3D207469702E7265666572656E636529207B0A20202020202072657475726E3B0A202020207D0A0A20202020696620287469702E70726F7073';
wwv_flow_api.g_varchar2_table(1356) := '2E696E74657261637469766529207B0A20202020202069662028216576656E742E72656C6174656454617267657429207B0A202020202020202072657475726E3B0A2020202020207D0A20202020202069662028636C6F73657374286576656E742E7265';
wwv_flow_api.g_varchar2_table(1357) := '6C617465645461726765742C2053656C6563746F72732E504F505045522929207B0A202020202020202072657475726E3B0A2020202020207D0A202020207D0A0A20202020707265706172654869646528293B0A20207D0A0A20202F2A2A0A2020202A20';
wwv_flow_api.g_varchar2_table(1358) := '4576656E74206C697374656E657220696E766F6B6564207768656E2061206368696C6420746172676574206973207472696767657265640A2020202A2F0A202066756E6374696F6E206F6E44656C656761746553686F77286576656E7429207B0A202020';
wwv_flow_api.g_varchar2_table(1359) := '2069662028636C6F73657374286576656E742E7461726765742C207469702E70726F70732E7461726765742929207B0A2020202020207072657061726553686F77286576656E74293B0A202020207D0A20207D0A0A20202F2A2A0A2020202A204576656E';
wwv_flow_api.g_varchar2_table(1360) := '74206C697374656E657220696E766F6B6564207768656E2061206368696C64207461726765742073686F756C6420686964650A2020202A2F0A202066756E6374696F6E206F6E44656C656761746548696465286576656E7429207B0A2020202069662028';
wwv_flow_api.g_varchar2_table(1361) := '636C6F73657374286576656E742E7461726765742C207469702E70726F70732E7461726765742929207B0A202020202020707265706172654869646528293B0A202020207D0A20207D0A0A20202F2A2A0A2020202A2044657465726D696E657320696620';
wwv_flow_api.g_varchar2_table(1362) := '616E206576656E74206C697374656E65722073686F756C642073746F70206675727468657220657865637574696F6E2064756520746F207468650A2020202A2060746F756368486F6C6460206F7074696F6E0A2020202A2F0A202066756E6374696F6E20';
wwv_flow_api.g_varchar2_table(1363) := '69734576656E744C697374656E657253746F70706564286576656E7429207B0A20202020766172206973546F7563684576656E74203D20696E636C75646573286576656E742E747970652C2027746F75636827293B0A2020202076617220636173654120';
wwv_flow_api.g_varchar2_table(1364) := '3D20737570706F727473546F7563682026262069735573696E67546F756368202626207469702E70726F70732E746F756368486F6C6420262620216973546F7563684576656E743B0A20202020766172206361736542203D2069735573696E67546F7563';
wwv_flow_api.g_varchar2_table(1365) := '6820262620217469702E70726F70732E746F756368486F6C64202626206973546F7563684576656E743B0A2020202072657475726E206361736541207C7C2063617365423B0A20207D0A0A20202F2A2A0A2020202A20437265617465732074686520706F';
wwv_flow_api.g_varchar2_table(1366) := '7070657220696E7374616E636520666F7220746865207469700A2020202A2F0A202066756E6374696F6E20637265617465506F70706572496E7374616E63652829207B0A2020202076617220706F707065724F7074696F6E73203D207469702E70726F70';
wwv_flow_api.g_varchar2_table(1367) := '732E706F707065724F7074696F6E733B0A20202020766172205F74697024706F707065724368696C6472656E203D207469702E706F707065724368696C6472656E2C0A2020202020202020746F6F6C746970203D205F74697024706F707065724368696C';
wwv_flow_api.g_varchar2_table(1368) := '6472656E2E746F6F6C7469702C0A20202020202020206172726F77203D205F74697024706F707065724368696C6472656E2E6172726F773B0A0A0A2020202072657475726E206E657720506F70706572287469702E7265666572656E63652C207469702E';
wwv_flow_api.g_varchar2_table(1369) := '706F707065722C205F657874656E64732431287B0A202020202020706C6163656D656E743A207469702E70726F70732E706C6163656D656E740A202020207D2C20706F707065724F7074696F6E732C207B0A2020202020206D6F646966696572733A205F';
wwv_flow_api.g_varchar2_table(1370) := '657874656E64732431287B7D2C20706F707065724F7074696F6E73203F20706F707065724F7074696F6E732E6D6F64696669657273203A207B7D2C207B0A202020202020202070726576656E744F766572666C6F773A205F657874656E64732431287B0A';
wwv_flow_api.g_varchar2_table(1371) := '20202020202020202020626F756E646172696573456C656D656E743A207469702E70726F70732E626F756E646172790A20202020202020207D2C206765744D6F64696669657228706F707065724F7074696F6E732C202770726576656E744F766572666C';
wwv_flow_api.g_varchar2_table(1372) := '6F772729292C0A20202020202020206172726F773A205F657874656E64732431287B0A20202020202020202020656C656D656E743A206172726F772C0A20202020202020202020656E61626C65643A2021216172726F770A20202020202020207D2C2067';
wwv_flow_api.g_varchar2_table(1373) := '65744D6F64696669657228706F707065724F7074696F6E732C20276172726F772729292C0A2020202020202020666C69703A205F657874656E64732431287B0A20202020202020202020656E61626C65643A207469702E70726F70732E666C69702C0A20';
wwv_flow_api.g_varchar2_table(1374) := '20202020202020202070616464696E673A207469702E70726F70732E64697374616E6365202B2035202F2A203570782066726F6D2076696577706F727420626F756E64617279202A2F0A202020202020202020202C206265686176696F723A207469702E';
wwv_flow_api.g_varchar2_table(1375) := '70726F70732E666C69704265686176696F720A20202020202020207D2C206765744D6F64696669657228706F707065724F7074696F6E732C2027666C69702729292C0A20202020202020206F66667365743A205F657874656E64732431287B0A20202020';
wwv_flow_api.g_varchar2_table(1376) := '2020202020206F66667365743A207469702E70726F70732E6F66667365740A20202020202020207D2C206765744D6F64696669657228706F707065724F7074696F6E732C20276F66667365742729290A2020202020207D292C0A2020202020206F6E4372';
wwv_flow_api.g_varchar2_table(1377) := '656174653A2066756E6374696F6E206F6E4372656174652829207B0A2020202020202020746F6F6C7469702E7374796C655B676574506F70706572506C6163656D656E74287469702E706F70706572295D203D206765744F666673657444697374616E63';
wwv_flow_api.g_varchar2_table(1378) := '65496E5078287469702E70726F70732E64697374616E63652C2044656661756C74732E64697374616E6365293B0A0A2020202020202020696620286172726F77202626207469702E70726F70732E6172726F775472616E73666F726D29207B0A20202020';
wwv_flow_api.g_varchar2_table(1379) := '202020202020636F6D707574654172726F775472616E73666F726D286172726F772C207469702E70726F70732E6172726F775472616E73666F726D293B0A20202020202020207D0A2020202020207D2C0A2020202020206F6E5570646174653A2066756E';
wwv_flow_api.g_varchar2_table(1380) := '6374696F6E206F6E5570646174652829207B0A2020202020202020766172207374796C6573203D20746F6F6C7469702E7374796C653B0A20202020202020207374796C65732E746F70203D2027273B0A20202020202020207374796C65732E626F74746F';
wwv_flow_api.g_varchar2_table(1381) := '6D203D2027273B0A20202020202020207374796C65732E6C656674203D2027273B0A20202020202020207374796C65732E7269676874203D2027273B0A20202020202020207374796C65735B676574506F70706572506C6163656D656E74287469702E70';
wwv_flow_api.g_varchar2_table(1382) := '6F70706572295D203D206765744F666673657444697374616E6365496E5078287469702E70726F70732E64697374616E63652C2044656661756C74732E64697374616E6365293B0A0A2020202020202020696620286172726F77202626207469702E7072';
wwv_flow_api.g_varchar2_table(1383) := '6F70732E6172726F775472616E73666F726D29207B0A20202020202020202020636F6D707574654172726F775472616E73666F726D286172726F772C207469702E70726F70732E6172726F775472616E73666F726D293B0A20202020202020207D0A2020';
wwv_flow_api.g_varchar2_table(1384) := '202020207D0A202020207D29293B0A20207D0A0A20202F2A2A0A2020202A204D6F756E74732074686520746F6F6C74697020746F2074686520444F4D2C2063616C6C6261636B20746F2073686F7720746F6F6C7469702069732072756E202A2A61667465';
wwv_flow_api.g_varchar2_table(1385) := '722A2A0A2020202A20706F70706572277320706F736974696F6E2068617320757064617465640A2020202A2F0A202066756E6374696F6E206D6F756E742863616C6C6261636B29207B0A2020202069662028217469702E706F70706572496E7374616E63';
wwv_flow_api.g_varchar2_table(1386) := '6529207B0A2020202020207469702E706F70706572496E7374616E6365203D20637265617465506F70706572496E7374616E636528293B0A2020202020206164644D75746174696F6E4F6273657276657228293B0A20202020202069662028217469702E';
wwv_flow_api.g_varchar2_table(1387) := '70726F70732E6C697665506C6163656D656E74207C7C20686173466F6C6C6F77437572736F724265686176696F72282929207B0A20202020202020207469702E706F70706572496E7374616E63652E64697361626C654576656E744C697374656E657273';
wwv_flow_api.g_varchar2_table(1388) := '28293B0A2020202020207D0A202020207D20656C7365207B0A2020202020206966202821686173466F6C6C6F77437572736F724265686176696F72282929207B0A20202020202020207469702E706F70706572496E7374616E63652E7363686564756C65';
wwv_flow_api.g_varchar2_table(1389) := '55706461746528293B0A2020202020202020696620287469702E70726F70732E6C697665506C6163656D656E7429207B0A202020202020202020207469702E706F70706572496E7374616E63652E656E61626C654576656E744C697374656E6572732829';
wwv_flow_api.g_varchar2_table(1390) := '3B0A20202020202020207D0A2020202020207D0A202020207D0A0A202020202F2F2049662074686520696E7374616E63652070726576696F75736C792068616420666F6C6C6F77437572736F72206265686176696F722C2069742077696C6C2062650A20';
wwv_flow_api.g_varchar2_table(1391) := '2020202F2F20706F736974696F6E656420696E636F72726563746C79206966207472696767657265642062792060666F6375736020616674657277617264732E0A202020202F2F2055706461746520746865207265666572656E6365206261636B20746F';
wwv_flow_api.g_varchar2_table(1392) := '20746865207265616C20444F4D20656C656D656E740A202020207469702E706F70706572496E7374616E63652E7265666572656E6365203D207469702E7265666572656E63653B0A20202020766172206172726F77203D207469702E706F707065724368';
wwv_flow_api.g_varchar2_table(1393) := '696C6472656E2E6172726F773B0A0A0A2020202069662028686173466F6C6C6F77437572736F724265686176696F72282929207B0A202020202020696620286172726F7729207B0A20202020202020206172726F772E7374796C652E6D617267696E203D';
wwv_flow_api.g_varchar2_table(1394) := '202730273B0A2020202020207D0A2020202020207661722064656C6179203D2067657456616C7565287469702E70726F70732E64656C61792C20302C2044656661756C74732E64656C6179293B0A202020202020696620286C6173745472696767657245';
wwv_flow_api.g_varchar2_table(1395) := '76656E742E7479706529207B0A2020202020202020706F736974696F6E5669727475616C5265666572656E63654E656172437572736F722864656C6179202626206C6173744D6F7573654D6F76654576656E74203F206C6173744D6F7573654D6F766545';
wwv_flow_api.g_varchar2_table(1396) := '76656E74203A206C617374547269676765724576656E74293B0A2020202020207D0A202020207D20656C736520696620286172726F7729207B0A2020202020206172726F772E7374796C652E6D617267696E203D2027273B0A202020207D0A0A20202020';
wwv_flow_api.g_varchar2_table(1397) := '6166746572506F70706572506F736974696F6E55706461746573287469702E706F70706572496E7374616E63652C2063616C6C6261636B293B0A0A2020202069662028217469702E70726F70732E617070656E64546F2E636F6E7461696E73287469702E';
wwv_flow_api.g_varchar2_table(1398) := '706F707065722929207B0A2020202020207469702E70726F70732E617070656E64546F2E617070656E644368696C64287469702E706F70706572293B0A2020202020207469702E70726F70732E6F6E4D6F756E7428746970293B0A202020202020746970';
wwv_flow_api.g_varchar2_table(1399) := '2E73746174652E69734D6F756E746564203D20747275653B0A202020207D0A20207D0A0A20202F2A2A0A2020202A2044657465726D696E65732069662074686520696E7374616E636520697320696E2060666F6C6C6F77437572736F7260206D6F64650A';
wwv_flow_api.g_varchar2_table(1400) := '2020202A2F0A202066756E6374696F6E20686173466F6C6C6F77437572736F724265686176696F722829207B0A2020202072657475726E207469702E70726F70732E666F6C6C6F77437572736F72202626202169735573696E67546F756368202626206C';
wwv_flow_api.g_varchar2_table(1401) := '617374547269676765724576656E742E7479706520213D3D2027666F637573273B0A20207D0A0A20202F2A2A0A2020202A20557064617465732074686520746F6F6C746970277320706F736974696F6E206F6E206561636820616E696D6174696F6E2066';
wwv_flow_api.g_varchar2_table(1402) := '72616D65202B2074696D656F75740A2020202A2F0A202066756E6374696F6E206D616B65537469636B792829207B0A202020206170706C795472616E736974696F6E4475726174696F6E285B7469702E706F707065725D2C2069734945203F2030203A20';
wwv_flow_api.g_varchar2_table(1403) := '7469702E70726F70732E7570646174654475726174696F6E293B0A0A2020202076617220757064617465506F736974696F6E203D2066756E6374696F6E20757064617465506F736974696F6E2829207B0A202020202020696620287469702E706F707065';
wwv_flow_api.g_varchar2_table(1404) := '72496E7374616E636529207B0A20202020202020207469702E706F70706572496E7374616E63652E7363686564756C6555706461746528293B0A2020202020207D0A0A202020202020696620287469702E73746174652E69734D6F756E74656429207B0A';
wwv_flow_api.g_varchar2_table(1405) := '202020202020202072657175657374416E696D6174696F6E4672616D6528757064617465506F736974696F6E293B0A2020202020207D20656C7365207B0A20202020202020206170706C795472616E736974696F6E4475726174696F6E285B7469702E70';
wwv_flow_api.g_varchar2_table(1406) := '6F707065725D2C2030293B0A2020202020207D0A202020207D3B0A0A20202020757064617465506F736974696F6E28293B0A20207D0A0A20202F2A2A0A2020202A20496E766F6B657320612063616C6C6261636B206F6E63652074686520746F6F6C7469';
wwv_flow_api.g_varchar2_table(1407) := '70206861732066756C6C79207472616E736974696F6E6564206F75740A2020202A2F0A202066756E6374696F6E206F6E5472616E736974696F6E65644F7574286475726174696F6E2C2063616C6C6261636B29207B0A202020206F6E5472616E73697469';
wwv_flow_api.g_varchar2_table(1408) := '6F6E456E64286475726174696F6E2C2066756E6374696F6E202829207B0A20202020202069662028217469702E73746174652E697356697369626C65202626207469702E70726F70732E617070656E64546F2E636F6E7461696E73287469702E706F7070';
wwv_flow_api.g_varchar2_table(1409) := '65722929207B0A202020202020202063616C6C6261636B28293B0A2020202020207D0A202020207D293B0A20207D0A0A20202F2A2A0A2020202A20496E766F6B657320612063616C6C6261636B206F6E63652074686520746F6F6C746970206861732066';
wwv_flow_api.g_varchar2_table(1410) := '756C6C79207472616E736974696F6E656420696E0A2020202A2F0A202066756E6374696F6E206F6E5472616E736974696F6E6564496E286475726174696F6E2C2063616C6C6261636B29207B0A202020206F6E5472616E736974696F6E456E6428647572';
wwv_flow_api.g_varchar2_table(1411) := '6174696F6E2C2063616C6C6261636B293B0A20207D0A0A20202F2A2A0A2020202A20496E766F6B657320612063616C6C6261636B206F6E63652074686520746F6F6C746970277320435353207472616E736974696F6E20656E64730A2020202A2F0A2020';
wwv_flow_api.g_varchar2_table(1412) := '66756E6374696F6E206F6E5472616E736974696F6E456E64286475726174696F6E2C2063616C6C6261636B29207B0A202020202F2F204D616B652063616C6C6261636B2073796E6368726F6E6F7573206966206475726174696F6E20697320300A202020';
wwv_flow_api.g_varchar2_table(1413) := '20696620286475726174696F6E203D3D3D203029207B0A20202020202072657475726E2063616C6C6261636B28293B0A202020207D0A0A2020202076617220746F6F6C746970203D207469702E706F707065724368696C6472656E2E746F6F6C7469703B';
wwv_flow_api.g_varchar2_table(1414) := '0A0A0A20202020766172206C697374656E6572203D2066756E6374696F6E206C697374656E6572286529207B0A20202020202069662028652E746172676574203D3D3D20746F6F6C74697029207B0A2020202020202020746F67676C655472616E736974';
wwv_flow_api.g_varchar2_table(1415) := '696F6E456E644C697374656E657228746F6F6C7469702C202772656D6F7665272C206C697374656E6572293B0A202020202020202063616C6C6261636B28293B0A2020202020207D0A202020207D3B0A0A20202020746F67676C655472616E736974696F';
wwv_flow_api.g_varchar2_table(1416) := '6E456E644C697374656E657228746F6F6C7469702C202772656D6F7665272C207472616E736974696F6E456E644C697374656E6572293B0A20202020746F67676C655472616E736974696F6E456E644C697374656E657228746F6F6C7469702C20276164';
wwv_flow_api.g_varchar2_table(1417) := '64272C206C697374656E6572293B0A0A202020207472616E736974696F6E456E644C697374656E6572203D206C697374656E65723B0A20207D0A0A20202F2A2A0A2020202A204164647320616E206576656E74206C697374656E657220746F2074686520';
wwv_flow_api.g_varchar2_table(1418) := '7265666572656E636520616E642073746F72657320697420696E20606C697374656E657273600A2020202A2F0A202066756E6374696F6E206F6E286576656E74547970652C2068616E646C657229207B0A20202020766172206F7074696F6E73203D2061';
wwv_flow_api.g_varchar2_table(1419) := '7267756D656E74732E6C656E677468203E203220262620617267756D656E74735B325D20213D3D20756E646566696E6564203F20617267756D656E74735B325D203A2066616C73653B0A0A202020207469702E7265666572656E63652E6164644576656E';
wwv_flow_api.g_varchar2_table(1420) := '744C697374656E6572286576656E74547970652C2068616E646C65722C206F7074696F6E73293B0A202020206C697374656E6572732E70757368287B206576656E74547970653A206576656E74547970652C2068616E646C65723A2068616E646C65722C';
wwv_flow_api.g_varchar2_table(1421) := '206F7074696F6E733A206F7074696F6E73207D293B0A20207D0A0A20202F2A2A0A2020202A2041646473206576656E74206C697374656E65727320746F20746865207265666572656E6365206261736564206F6E20746865206074726967676572602070';
wwv_flow_api.g_varchar2_table(1422) := '726F700A2020202A2F0A202066756E6374696F6E206164645472696767657273546F5265666572656E63652829207B0A20202020696620287469702E70726F70732E746F756368486F6C6420262620217469702E70726F70732E74617267657429207B0A';
wwv_flow_api.g_varchar2_table(1423) := '2020202020206F6E2827746F7563687374617274272C206F6E547269676765722C2050415353495645293B0A2020202020206F6E2827746F756368656E64272C206F6E4D6F7573654C656176652C2050415353495645293B0A202020207D0A0A20202020';
wwv_flow_api.g_varchar2_table(1424) := '7469702E70726F70732E747269676765722E7472696D28292E73706C697428272027292E666F72456163682866756E6374696F6E20286576656E745479706529207B0A202020202020696620286576656E7454797065203D3D3D20276D616E75616C2729';
wwv_flow_api.g_varchar2_table(1425) := '207B0A202020202020202072657475726E3B0A2020202020207D0A0A20202020202069662028217469702E70726F70732E74617267657429207B0A20202020202020206F6E286576656E74547970652C206F6E54726967676572293B0A20202020202020';
wwv_flow_api.g_varchar2_table(1426) := '2073776974636820286576656E745479706529207B0A202020202020202020206361736520276D6F757365656E746572273A0A2020202020202020202020206F6E28276D6F7573656C65617665272C206F6E4D6F7573654C65617665293B0A2020202020';
wwv_flow_api.g_varchar2_table(1427) := '20202020202020627265616B3B0A20202020202020202020636173652027666F637573273A0A2020202020202020202020206F6E2869734945203F2027666F6375736F757427203A2027626C7572272C206F6E426C7572293B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(1428) := '2020627265616B3B0A20202020202020207D0A2020202020207D20656C7365207B0A202020202020202073776974636820286576656E745479706529207B0A202020202020202020206361736520276D6F757365656E746572273A0A2020202020202020';
wwv_flow_api.g_varchar2_table(1429) := '202020206F6E28276D6F7573656F766572272C206F6E44656C656761746553686F77293B0A2020202020202020202020206F6E28276D6F7573656F7574272C206F6E44656C656761746548696465293B0A202020202020202020202020627265616B3B0A';
wwv_flow_api.g_varchar2_table(1430) := '20202020202020202020636173652027666F637573273A0A2020202020202020202020206F6E2827666F637573696E272C206F6E44656C656761746553686F77293B0A2020202020202020202020206F6E2827666F6375736F7574272C206F6E44656C65';
wwv_flow_api.g_varchar2_table(1431) := '6761746548696465293B0A202020202020202020202020627265616B3B0A20202020202020202020636173652027636C69636B273A0A2020202020202020202020206F6E286576656E74547970652C206F6E44656C656761746553686F77293B0A202020';
wwv_flow_api.g_varchar2_table(1432) := '202020202020202020627265616B3B0A20202020202020207D0A2020202020207D0A202020207D293B0A20207D0A0A20202F2A2A0A2020202A2052656D6F766573206576656E74206C697374656E6572732066726F6D20746865207265666572656E6365';
wwv_flow_api.g_varchar2_table(1433) := '0A2020202A2F0A202066756E6374696F6E2072656D6F7665547269676765727346726F6D5265666572656E63652829207B0A202020206C697374656E6572732E666F72456163682866756E6374696F6E20285F72656629207B0A20202020202076617220';
wwv_flow_api.g_varchar2_table(1434) := '6576656E7454797065203D205F7265662E6576656E74547970652C0A2020202020202020202068616E646C6572203D205F7265662E68616E646C65722C0A202020202020202020206F7074696F6E73203D205F7265662E6F7074696F6E733B0A0A202020';
wwv_flow_api.g_varchar2_table(1435) := '2020207469702E7265666572656E63652E72656D6F76654576656E744C697374656E6572286576656E74547970652C2068616E646C65722C206F7074696F6E73293B0A202020207D293B0A202020206C697374656E657273203D205B5D3B0A20207D0A0A';
wwv_flow_api.g_varchar2_table(1436) := '20202F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D20F09F9491205075626C6963206D6574686F647320F09F9491203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A20202F2A2A0A2020202A20456E61626C657320';
wwv_flow_api.g_varchar2_table(1437) := '74686520696E7374616E636520746F20616C6C6F7720697420746F2073686F77206F7220686964650A2020202A2F0A202066756E6374696F6E20656E61626C652829207B0A202020207469702E73746174652E6973456E61626C6564203D20747275653B';
wwv_flow_api.g_varchar2_table(1438) := '0A20207D0A0A20202F2A2A0A2020202A2044697361626C65732074686520696E7374616E636520746F20646973616C6C6F7720697420746F2073686F77206F7220686964650A2020202A2F0A202066756E6374696F6E2064697361626C652829207B0A20';
wwv_flow_api.g_varchar2_table(1439) := '2020207469702E73746174652E6973456E61626C6564203D2066616C73653B0A20207D0A0A20202F2A2A0A2020202A20436C656172732070656E64696E672074696D656F7574732072656C6174656420746F20746865206064656C6179602070726F7020';
wwv_flow_api.g_varchar2_table(1440) := '696620616E790A2020202A2F0A202066756E6374696F6E20636C65617244656C617954696D656F7574732829207B0A20202020636C65617254696D656F75742873686F7754696D656F75744964293B0A20202020636C65617254696D656F757428686964';
wwv_flow_api.g_varchar2_table(1441) := '6554696D656F75744964293B0A20207D0A0A20202F2A2A0A2020202A2053657473206E65772070726F707320666F722074686520696E7374616E636520616E6420726564726177732074686520746F6F6C7469700A2020202A2F0A202066756E6374696F';
wwv_flow_api.g_varchar2_table(1442) := '6E207365742424312829207B0A20202020766172206F7074696F6E73203D20617267756D656E74732E6C656E677468203E203020262620617267756D656E74735B305D20213D3D20756E646566696E6564203F20617267756D656E74735B305D203A207B';
wwv_flow_api.g_varchar2_table(1443) := '7D3B0A0A2020202076616C69646174654F7074696F6E73286F7074696F6E732C2044656661756C7473293B0A0A20202020766172207072657650726F7073203D207469702E70726F70733B0A20202020766172206E65787450726F7073203D206576616C';
wwv_flow_api.g_varchar2_table(1444) := '7561746550726F7073287469702E7265666572656E63652C205F657874656E64732431287B7D2C207469702E70726F70732C206F7074696F6E732C207B0A202020202020706572666F726D616E63653A20747275650A202020207D29293B0A202020206E';
wwv_flow_api.g_varchar2_table(1445) := '65787450726F70732E706572666F726D616E6365203D206861734F776E50726F7065727479286F7074696F6E732C2027706572666F726D616E63652729203F206F7074696F6E732E706572666F726D616E6365203A207072657650726F70732E70657266';
wwv_flow_api.g_varchar2_table(1446) := '6F726D616E63653B0A202020207469702E70726F7073203D206E65787450726F70733B0A0A20202020696620286861734F776E50726F7065727479286F7074696F6E732C2027747269676765722729207C7C206861734F776E50726F7065727479286F70';
wwv_flow_api.g_varchar2_table(1447) := '74696F6E732C2027746F756368486F6C64272929207B0A20202020202072656D6F7665547269676765727346726F6D5265666572656E636528293B0A2020202020206164645472696767657273546F5265666572656E636528293B0A202020207D0A0A20';
wwv_flow_api.g_varchar2_table(1448) := '202020696620286861734F776E50726F7065727479286F7074696F6E732C2027696E7465726163746976654465626F756E6365272929207B0A202020202020636C65616E75704F6C644D6F7573654C697374656E65727328293B0A202020202020646562';
wwv_flow_api.g_varchar2_table(1449) := '6F756E6365644F6E4D6F7573654D6F7665203D206465626F756E63652431286F6E4D6F7573654D6F76652C206F7074696F6E732E696E7465726163746976654465626F756E6365293B0A202020207D0A0A20202020757064617465506F70706572456C65';
wwv_flow_api.g_varchar2_table(1450) := '6D656E74287469702E706F707065722C207072657650726F70732C206E65787450726F7073293B0A202020207469702E706F707065724368696C6472656E203D206765744368696C6472656E287469702E706F70706572293B0A0A202020206966202874';
wwv_flow_api.g_varchar2_table(1451) := '69702E706F70706572496E7374616E636520262620504F505045525F494E5354414E43455F52454C415445445F50524F50532E736F6D652866756E6374696F6E202870726F7029207B0A20202020202072657475726E206861734F776E50726F70657274';
wwv_flow_api.g_varchar2_table(1452) := '79286F7074696F6E732C2070726F70293B0A202020207D2929207B0A2020202020207469702E706F70706572496E7374616E63652E64657374726F7928293B0A2020202020207469702E706F70706572496E7374616E6365203D20637265617465506F70';
wwv_flow_api.g_varchar2_table(1453) := '706572496E7374616E636528293B0A20202020202069662028217469702E73746174652E697356697369626C6529207B0A20202020202020207469702E706F70706572496E7374616E63652E64697361626C654576656E744C697374656E65727328293B';
wwv_flow_api.g_varchar2_table(1454) := '0A2020202020207D0A202020202020696620287469702E70726F70732E666F6C6C6F77437572736F72202626206C6173744D6F7573654D6F76654576656E7429207B0A2020202020202020706F736974696F6E5669727475616C5265666572656E63654E';
wwv_flow_api.g_varchar2_table(1455) := '656172437572736F72286C6173744D6F7573654D6F76654576656E74293B0A2020202020207D0A202020207D0A20207D0A0A20202F2A2A0A2020202A2053686F727463757420666F72202E736574287B20636F6E74656E743A206E6577436F6E74656E74';
wwv_flow_api.g_varchar2_table(1456) := '207D290A2020202A2F0A202066756E6374696F6E20736574436F6E74656E7424243128636F6E74656E7429207B0A20202020736574242431287B20636F6E74656E743A20636F6E74656E74207D293B0A20207D0A0A20202F2A2A0A2020202A2053686F77';
wwv_flow_api.g_varchar2_table(1457) := '732074686520746F6F6C7469700A2020202A2F0A202066756E6374696F6E2073686F772829207B0A20202020766172206475726174696F6E203D20617267756D656E74732E6C656E677468203E203020262620617267756D656E74735B305D20213D3D20';
wwv_flow_api.g_varchar2_table(1458) := '756E646566696E6564203F20617267756D656E74735B305D203A2067657456616C7565287469702E70726F70732E6475726174696F6E2C20302C2044656661756C74732E6475726174696F6E5B305D293B0A0A20202020696620287469702E7374617465';
wwv_flow_api.g_varchar2_table(1459) := '2E697344657374726F796564207C7C20217469702E73746174652E6973456E61626C6564207C7C2069735573696E67546F75636820262620217469702E70726F70732E746F75636829207B0A20202020202072657475726E3B0A202020207D0A0A202020';
wwv_flow_api.g_varchar2_table(1460) := '202F2F2044657374726F7920746F6F6C74697020696620746865207265666572656E636520656C656D656E74206973206E6F206C6F6E676572206F6E2074686520444F4D0A2020202069662028217469702E7265666572656E63652E6973566972747561';
wwv_flow_api.g_varchar2_table(1461) := '6C2026262021646F63756D656E742E646F63756D656E74456C656D656E742E636F6E7461696E73287469702E7265666572656E63652929207B0A20202020202072657475726E2064657374726F7928293B0A202020207D0A0A202020202F2F20446F206E';
wwv_flow_api.g_varchar2_table(1462) := '6F742073686F7720746F6F6C74697020696620746865207265666572656E636520656C656D656E74206861732061206064697361626C656460206174747269627574650A20202020696620287469702E7265666572656E63652E68617341747472696275';
wwv_flow_api.g_varchar2_table(1463) := '7465282764697361626C6564272929207B0A20202020202072657475726E3B0A202020207D0A0A202020202F2F20496620746865207265666572656E636520776173206A7573742070726F6772616D6D61746963616C6C7920666F637573656420666F72';
wwv_flow_api.g_varchar2_table(1464) := '206163636573736962696C6974790A202020202F2F20726561736F6E730A20202020696620287265666572656E63654A75737450726F6772616D6D61746963616C6C79466F637573656429207B0A2020202020207265666572656E63654A75737450726F';
wwv_flow_api.g_varchar2_table(1465) := '6772616D6D61746963616C6C79466F6375736564203D2066616C73653B0A20202020202072657475726E3B0A202020207D0A0A20202020696620287469702E70726F70732E6F6E53686F772874697029203D3D3D2066616C736529207B0A202020202020';
wwv_flow_api.g_varchar2_table(1466) := '72657475726E3B0A202020207D0A0A202020207469702E706F707065722E7374796C652E7669736962696C697479203D202776697369626C65273B0A202020207469702E73746174652E697356697369626C65203D20747275653B0A0A202020202F2F20';
wwv_flow_api.g_varchar2_table(1467) := '50726576656E742061207472616E736974696F6E2069662074686520706F7070657220697320617420746865206F70706F7369746520706C6163656D656E740A202020206170706C795472616E736974696F6E4475726174696F6E285B7469702E706F70';
wwv_flow_api.g_varchar2_table(1468) := '7065722C207469702E706F707065724368696C6472656E2E746F6F6C7469702C207469702E706F707065724368696C6472656E2E6261636B64726F705D2C2030293B0A0A202020206D6F756E742866756E6374696F6E202829207B0A2020202020206966';
wwv_flow_api.g_varchar2_table(1469) := '2028217469702E73746174652E697356697369626C6529207B0A202020202020202072657475726E3B0A2020202020207D0A0A2020202020202F2F204172726F772077696C6C20736F6D6574696D6573206E6F7420626520706F736974696F6E65642063';
wwv_flow_api.g_varchar2_table(1470) := '6F72726563746C792E20466F72636520616E6F74686572207570646174650A2020202020206966202821686173466F6C6C6F77437572736F724265686176696F72282929207B0A20202020202020207469702E706F70706572496E7374616E63652E7570';
wwv_flow_api.g_varchar2_table(1471) := '6461746528293B0A2020202020207D0A0A2020202020206170706C795472616E736974696F6E4475726174696F6E285B7469702E706F707065724368696C6472656E2E746F6F6C7469702C207469702E706F707065724368696C6472656E2E6261636B64';
wwv_flow_api.g_varchar2_table(1472) := '726F702C207469702E706F707065724368696C6472656E2E636F6E74656E745D2C206475726174696F6E293B0A202020202020696620287469702E706F707065724368696C6472656E2E6261636B64726F7029207B0A20202020202020207469702E706F';
wwv_flow_api.g_varchar2_table(1473) := '707065724368696C6472656E2E636F6E74656E742E7374796C652E7472616E736974696F6E44656C6179203D204D6174682E726F756E64286475726174696F6E202F203629202B20276D73273B0A2020202020207D0A0A20202020202069662028746970';
wwv_flow_api.g_varchar2_table(1474) := '2E70726F70732E696E74657261637469766529207B0A20202020202020207469702E7265666572656E63652E636C6173734C6973742E616464282774697070792D61637469766527293B0A2020202020207D0A0A202020202020696620287469702E7072';
wwv_flow_api.g_varchar2_table(1475) := '6F70732E737469636B7929207B0A20202020202020206D616B65537469636B7928293B0A2020202020207D0A0A2020202020207365745669736962696C6974795374617465285B7469702E706F707065724368696C6472656E2E746F6F6C7469702C2074';
wwv_flow_api.g_varchar2_table(1476) := '69702E706F707065724368696C6472656E2E6261636B64726F702C207469702E706F707065724368696C6472656E2E636F6E74656E745D2C202776697369626C6527293B0A0A2020202020206F6E5472616E736974696F6E6564496E286475726174696F';
wwv_flow_api.g_varchar2_table(1477) := '6E2C2066756E6374696F6E202829207B0A2020202020202020696620287469702E70726F70732E7570646174654475726174696F6E203D3D3D203029207B0A202020202020202020207469702E706F707065724368696C6472656E2E746F6F6C7469702E';
wwv_flow_api.g_varchar2_table(1478) := '636C6173734C6973742E616464282774697070792D6E6F7472616E736974696F6E27293B0A20202020202020207D0A0A2020202020202020696620287469702E70726F70732E6175746F466F637573202626207469702E70726F70732E696E7465726163';
wwv_flow_api.g_varchar2_table(1479) := '7469766520262620696E636C75646573285B27666F637573272C2027636C69636B275D2C206C617374547269676765724576656E742E747970652929207B0A20202020202020202020666F637573287469702E706F70706572293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(1480) := '7D0A0A2020202020202020696620287469702E70726F70732E6172696129207B0A202020202020202020207469702E7265666572656E63652E7365744174747269627574652827617269612D27202B207469702E70726F70732E617269612C207469702E';
wwv_flow_api.g_varchar2_table(1481) := '706F707065722E6964293B0A20202020202020207D0A0A20202020202020207469702E70726F70732E6F6E53686F776E28746970293B0A20202020202020207469702E73746174652E697353686F776E203D20747275653B0A2020202020207D293B0A20';
wwv_flow_api.g_varchar2_table(1482) := '2020207D293B0A20207D0A0A20202F2A2A0A2020202A2048696465732074686520746F6F6C7469700A2020202A2F0A202066756E6374696F6E20686964652829207B0A20202020766172206475726174696F6E203D20617267756D656E74732E6C656E67';
wwv_flow_api.g_varchar2_table(1483) := '7468203E203020262620617267756D656E74735B305D20213D3D20756E646566696E6564203F20617267756D656E74735B305D203A2067657456616C7565287469702E70726F70732E6475726174696F6E2C20312C2044656661756C74732E6475726174';
wwv_flow_api.g_varchar2_table(1484) := '696F6E5B315D293B0A0A20202020696620287469702E73746174652E697344657374726F796564207C7C20217469702E73746174652E6973456E61626C656429207B0A20202020202072657475726E3B0A202020207D0A0A20202020696620287469702E';
wwv_flow_api.g_varchar2_table(1485) := '70726F70732E6F6E486964652874697029203D3D3D2066616C736529207B0A20202020202072657475726E3B0A202020207D0A0A20202020696620287469702E70726F70732E7570646174654475726174696F6E203D3D3D203029207B0A202020202020';
wwv_flow_api.g_varchar2_table(1486) := '7469702E706F707065724368696C6472656E2E746F6F6C7469702E636C6173734C6973742E72656D6F7665282774697070792D6E6F7472616E736974696F6E27293B0A202020207D0A0A20202020696620287469702E70726F70732E696E746572616374';
wwv_flow_api.g_varchar2_table(1487) := '69766529207B0A2020202020207469702E7265666572656E63652E636C6173734C6973742E72656D6F7665282774697070792D61637469766527293B0A202020207D0A0A202020207469702E706F707065722E7374796C652E7669736962696C69747920';
wwv_flow_api.g_varchar2_table(1488) := '3D202768696464656E273B0A202020207469702E73746174652E697356697369626C65203D2066616C73653B0A202020207469702E73746174652E697353686F776E203D2066616C73653B0A0A202020206170706C795472616E736974696F6E44757261';
wwv_flow_api.g_varchar2_table(1489) := '74696F6E285B7469702E706F707065724368696C6472656E2E746F6F6C7469702C207469702E706F707065724368696C6472656E2E6261636B64726F702C207469702E706F707065724368696C6472656E2E636F6E74656E745D2C206475726174696F6E';
wwv_flow_api.g_varchar2_table(1490) := '293B0A0A202020207365745669736962696C6974795374617465285B7469702E706F707065724368696C6472656E2E746F6F6C7469702C207469702E706F707065724368696C6472656E2E6261636B64726F702C207469702E706F707065724368696C64';
wwv_flow_api.g_varchar2_table(1491) := '72656E2E636F6E74656E745D2C202768696464656E27293B0A0A20202020696620287469702E70726F70732E6175746F466F637573202626207469702E70726F70732E696E74657261637469766520262620217265666572656E63654A75737450726F67';
wwv_flow_api.g_varchar2_table(1492) := '72616D6D61746963616C6C79466F637573656420262620696E636C75646573285B27666F637573272C2027636C69636B275D2C206C617374547269676765724576656E742E747970652929207B0A202020202020696620286C6173745472696767657245';
wwv_flow_api.g_varchar2_table(1493) := '76656E742E74797065203D3D3D2027666F6375732729207B0A20202020202020207265666572656E63654A75737450726F6772616D6D61746963616C6C79466F6375736564203D20747275653B0A2020202020207D0A202020202020666F637573287469';
wwv_flow_api.g_varchar2_table(1494) := '702E7265666572656E6365293B0A202020207D0A0A202020206F6E5472616E736974696F6E65644F7574286475726174696F6E2C2066756E6374696F6E202829207B0A20202020202069662028216973507265706172696E67546F53686F7729207B0A20';
wwv_flow_api.g_varchar2_table(1495) := '2020202020202072656D6F7665466F6C6C6F77437572736F724C697374656E657228293B0A2020202020207D0A0A202020202020696620287469702E70726F70732E6172696129207B0A20202020202020207469702E7265666572656E63652E72656D6F';
wwv_flow_api.g_varchar2_table(1496) := '76654174747269627574652827617269612D27202B207469702E70726F70732E61726961293B0A2020202020207D0A0A2020202020207469702E706F70706572496E7374616E63652E64697361626C654576656E744C697374656E65727328293B0A0A20';
wwv_flow_api.g_varchar2_table(1497) := '20202020207469702E70726F70732E617070656E64546F2E72656D6F76654368696C64287469702E706F70706572293B0A2020202020207469702E73746174652E69734D6F756E746564203D2066616C73653B0A0A2020202020207469702E70726F7073';
wwv_flow_api.g_varchar2_table(1498) := '2E6F6E48696464656E28746970293B0A202020207D293B0A20207D0A0A20202F2A2A0A2020202A2044657374726F79732074686520746F6F6C7469700A2020202A2F0A202066756E6374696F6E2064657374726F792864657374726F7954617267657449';
wwv_flow_api.g_varchar2_table(1499) := '6E7374616E63657329207B0A20202020696620287469702E73746174652E697344657374726F79656429207B0A20202020202072657475726E3B0A202020207D0A0A202020202F2F2049662074686520706F707065722069732063757272656E746C7920';
wwv_flow_api.g_varchar2_table(1500) := '6D6F756E74656420746F2074686520444F4D2C2077652077616E7420746F20656E7375726520697420676574730A202020202F2F2068696464656E20616E6420756E6D6F756E74656420696E7374616E746C792075706F6E206465737472756374696F6E';
null;
end;
/
begin
wwv_flow_api.g_varchar2_table(1501) := '0A20202020696620287469702E73746174652E69734D6F756E74656429207B0A202020202020686964652830293B0A202020207D0A0A2020202072656D6F7665547269676765727346726F6D5265666572656E636528293B0A0A202020207469702E7265';
wwv_flow_api.g_varchar2_table(1502) := '666572656E63652E72656D6F76654576656E744C697374656E65722827636C69636B272C206F6E5265666572656E6365436C69636B293B0A0A2020202064656C657465207469702E7265666572656E63652E5F74697070793B0A0A202020206966202874';
wwv_flow_api.g_varchar2_table(1503) := '69702E70726F70732E7461726765742026262064657374726F79546172676574496E7374616E63657329207B0A202020202020617272617946726F6D287469702E7265666572656E63652E717565727953656C6563746F72416C6C287469702E70726F70';
wwv_flow_api.g_varchar2_table(1504) := '732E74617267657429292E666F72456163682866756E6374696F6E20286368696C6429207B0A202020202020202072657475726E206368696C642E5F7469707079202626206368696C642E5F74697070792E64657374726F7928293B0A2020202020207D';
wwv_flow_api.g_varchar2_table(1505) := '293B0A202020207D0A0A20202020696620287469702E706F70706572496E7374616E636529207B0A2020202020207469702E706F70706572496E7374616E63652E64657374726F7928293B0A202020207D0A0A2020202069662028706F707065724D7574';
wwv_flow_api.g_varchar2_table(1506) := '6174696F6E4F6273657276657229207B0A202020202020706F707065724D75746174696F6E4F627365727665722E646973636F6E6E65637428293B0A202020207D0A0A202020207469702E73746174652E697344657374726F796564203D20747275653B';
wwv_flow_api.g_varchar2_table(1507) := '0A20207D0A7D0A0A76617220676C6F62616C4576656E744C697374656E657273426F756E64203D2066616C73653B0A0A2F2A2A0A202A204578706F72746564206D6F64756C650A202A2040706172616D207B537472696E677C456C656D656E747C456C65';
wwv_flow_api.g_varchar2_table(1508) := '6D656E745B5D7C4E6F64654C6973747C4F626A6563747D20746172676574730A202A2040706172616D207B4F626A6563747D206F7074696F6E730A202A2040706172616D207B426F6F6C65616E7D206F6E650A202A204072657475726E207B4F626A6563';
wwv_flow_api.g_varchar2_table(1509) := '747D0A202A2F0A66756E6374696F6E20746970707928746172676574732C206F7074696F6E732C206F6E6529207B0A202076616C69646174654F7074696F6E73286F7074696F6E732C2044656661756C7473293B0A0A20206966202821676C6F62616C45';
wwv_flow_api.g_varchar2_table(1510) := '76656E744C697374656E657273426F756E6429207B0A2020202062696E64476C6F62616C4576656E744C697374656E65727328293B0A20202020676C6F62616C4576656E744C697374656E657273426F756E64203D20747275653B0A20207D0A0A202076';
wwv_flow_api.g_varchar2_table(1511) := '61722070726F7073203D205F657874656E64732431287B7D2C2044656661756C74732C206F7074696F6E73293B0A0A20202F2A2A0A2020202A2049662074686579206172652073706563696679696E672061207669727475616C20706F736974696F6E69';
wwv_flow_api.g_varchar2_table(1512) := '6E67207265666572656E63652C207765206E65656420746F20706F6C7966696C6C0A2020202A20736F6D65206E617469766520444F4D2070726F70730A2020202A2F0A2020696620286973506C61696E4F626A65637428746172676574732929207B0A20';
wwv_flow_api.g_varchar2_table(1513) := '202020706F6C7966696C6C456C656D656E7450726F746F7479706550726F706572746965732874617267657473293B0A20207D0A0A2020766172207265666572656E636573203D2067657441727261794F66456C656D656E74732874617267657473293B';
wwv_flow_api.g_varchar2_table(1514) := '0A20207661722066697273745265666572656E6365203D207265666572656E6365735B305D3B0A0A202076617220696E7374616E636573203D20286F6E652026262066697273745265666572656E6365203F205B66697273745265666572656E63655D20';
wwv_flow_api.g_varchar2_table(1515) := '3A207265666572656E636573292E7265647563652866756E6374696F6E20286163632C207265666572656E636529207B0A2020202076617220746970203D207265666572656E6365202626206372656174655469707079287265666572656E63652C2070';
wwv_flow_api.g_varchar2_table(1516) := '726F7073293B0A202020206966202874697029207B0A2020202020206163632E7075736828746970293B0A202020207D0A2020202072657475726E206163633B0A20207D2C205B5D293B0A0A202076617220636F6C6C656374696F6E203D207B0A202020';
wwv_flow_api.g_varchar2_table(1517) := '20746172676574733A20746172676574732C0A2020202070726F70733A2070726F70732C0A20202020696E7374616E6365733A20696E7374616E6365732C0A2020202064657374726F79416C6C3A2066756E6374696F6E2064657374726F79416C6C2829';
wwv_flow_api.g_varchar2_table(1518) := '207B0A202020202020636F6C6C656374696F6E2E696E7374616E6365732E666F72456163682866756E6374696F6E2028696E7374616E636529207B0A2020202020202020696E7374616E63652E64657374726F7928293B0A2020202020207D293B0A2020';
wwv_flow_api.g_varchar2_table(1519) := '20202020636F6C6C656374696F6E2E696E7374616E636573203D205B5D3B0A202020207D0A20207D3B0A0A202072657475726E20636F6C6C656374696F6E3B0A7D0A0A2F2A2A0A202A205374617469632070726F70730A202A2F0A74697070792E766572';
wwv_flow_api.g_varchar2_table(1520) := '73696F6E203D2076657273696F6E3B0A74697070792E64656661756C7473203D2044656661756C74733B0A0A2F2A2A0A202A20537461746963206D6574686F64730A202A2F0A74697070792E6F6E65203D2066756E6374696F6E2028746172676574732C';
wwv_flow_api.g_varchar2_table(1521) := '206F7074696F6E7329207B0A202072657475726E20746970707928746172676574732C206F7074696F6E732C2074727565292E696E7374616E6365735B305D3B0A7D3B0A74697070792E73657444656661756C7473203D2066756E6374696F6E20287061';
wwv_flow_api.g_varchar2_table(1522) := '727469616C44656661756C747329207B0A20204F626A6563742E6B657973287061727469616C44656661756C7473292E666F72456163682866756E6374696F6E20286B657929207B0A2020202044656661756C74735B6B65795D203D207061727469616C';
wwv_flow_api.g_varchar2_table(1523) := '44656661756C74735B6B65795D3B0A20207D293B0A7D3B0A74697070792E64697361626C65416E696D6174696F6E73203D2066756E6374696F6E202829207B0A202074697070792E73657444656661756C7473287B0A202020206475726174696F6E3A20';
wwv_flow_api.g_varchar2_table(1524) := '302C0A202020207570646174654475726174696F6E3A20302C0A20202020616E696D61746546696C6C3A2066616C73650A20207D293B0A7D3B0A74697070792E68696465416C6C506F7070657273203D2068696465416C6C506F70706572733B0A2F2F20';
wwv_flow_api.g_varchar2_table(1525) := '6E6F6F703A206465707265636174656420737461746963206D6574686F642061732063617074757265207068617365206973206E6F772064656661756C740A74697070792E75736543617074757265203D2066756E6374696F6E202829207B7D3B0A0A2F';
wwv_flow_api.g_varchar2_table(1526) := '2A2A0A202A204175746F2D696E697420746F6F6C7469707320666F7220656C656D656E7473207769746820612060646174612D74697070793D222E2E2E2260206174747269627574650A202A2F0A766172206175746F496E6974203D2066756E6374696F';
wwv_flow_api.g_varchar2_table(1527) := '6E206175746F496E69742829207B0A2020617272617946726F6D28646F63756D656E742E717565727953656C6563746F72416C6C28275B646174612D74697070795D2729292E666F72456163682866756E6374696F6E2028656C29207B0A202020207661';
wwv_flow_api.g_varchar2_table(1528) := '7220636F6E74656E74203D20656C2E6765744174747269627574652827646174612D746970707927293B0A2020202069662028636F6E74656E7429207B0A202020202020746970707928656C2C207B20636F6E74656E743A20636F6E74656E74207D293B';
wwv_flow_api.g_varchar2_table(1529) := '0A202020207D0A20207D293B0A7D3B0A69662028697342726F7773657229207B0A202073657454696D656F7574286175746F496E6974293B0A7D0A0A2F2A2A0A202A20496E6A65637473206120737472696E67206F6620435353207374796C657320746F';
wwv_flow_api.g_varchar2_table(1530) := '2061207374796C65206E6F646520696E203C686561643E0A202A2040706172616D207B537472696E677D206373730A202A2F0A66756E6374696F6E20696E6A6563744353532863737329207B0A202069662028697342726F77736572537570706F727465';
wwv_flow_api.g_varchar2_table(1531) := '6429207B0A20202020766172207374796C65203D20646F63756D656E742E637265617465456C656D656E7428277374796C6527293B0A202020207374796C652E74797065203D2027746578742F637373273B0A202020207374796C652E74657874436F6E';
wwv_flow_api.g_varchar2_table(1532) := '74656E74203D206373733B0A20202020646F63756D656E742E686561642E696E736572744265666F7265287374796C652C20646F63756D656E742E686561642E66697273744368696C64293B0A20207D0A7D0A0A696E6A656374435353287374796C6573';
wwv_flow_api.g_varchar2_table(1533) := '293B0A0A72657475726E2074697070793B0A0A7D2929293B0A2F2F2320736F757263654D617070696E6755524C3D74697070792E616C6C2E6A732E6D61700A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(6023119405863152)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_file_name=>'js/tippy.all.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2166756E6374696F6E28742C65297B226F626A656374223D3D747970656F66206578706F727473262622756E646566696E656422213D747970656F66206D6F64756C653F6D6F64756C652E6578706F7274733D6528293A2266756E6374696F6E223D3D74';
wwv_flow_api.g_varchar2_table(2) := '7970656F6620646566696E652626646566696E652E616D643F646566696E652865293A742E74697070793D6528297D28746869732C66756E6374696F6E28297B2275736520737472696374223B666F722876617220743D22756E646566696E656422213D';
wwv_flow_api.g_varchar2_table(3) := '747970656F662077696E646F772C653D743F6E6176696761746F723A7B7D2C723D743F77696E646F773A7B7D2C6E3D28224D75746174696F6E4F6273657276657222696E2072292C5F3D2F4D534945207C54726964656E745C2F2F2E7465737428652E75';
wwv_flow_api.g_varchar2_table(4) := '7365724167656E74292C6F3D2F6950686F6E657C695061647C69506F642F2E7465737428652E706C6174666F726D29262621722E4D5353747265616D2C6A3D28226F6E746F756368737461727422696E2072292C563D7B613131793A21302C616C6C6F77';
wwv_flow_api.g_varchar2_table(5) := '48544D4C3A21302C616E696D61746546696C6C3A21302C616E696D6174696F6E3A2273686966742D61776179222C617070656E64546F3A66756E6374696F6E28297B72657475726E20646F63756D656E742E626F64797D2C617269613A22646573637269';
wwv_flow_api.g_varchar2_table(6) := '6265646279222C6172726F773A21312C6172726F775472616E73666F726D3A22222C6172726F77547970653A227368617270222C6175746F466F6375733A21302C626F756E646172793A227363726F6C6C506172656E74222C636F6E74656E743A22222C';
wwv_flow_api.g_varchar2_table(7) := '64656C61793A5B302C32305D2C64697374616E63653A31302C6475726174696F6E3A5B3332352C3237355D2C666C69703A21302C666C69704265686176696F723A22666C6970222C666F6C6C6F77437572736F723A21312C686964654F6E436C69636B3A';
wwv_flow_api.g_varchar2_table(8) := '21302C696E65727469613A21312C696E7465726163746976653A21312C696E746572616374697665426F726465723A322C696E7465726163746976654465626F756E63653A302C6C617A793A21302C6C697665506C6163656D656E743A21302C6D617857';
wwv_flow_api.g_varchar2_table(9) := '696474683A22222C6D756C7469706C653A21312C6F66667365743A302C6F6E48696464656E3A66756E6374696F6E28297B7D2C6F6E486964653A66756E6374696F6E28297B7D2C6F6E4D6F756E743A66756E6374696F6E28297B7D2C6F6E53686F773A66';
wwv_flow_api.g_varchar2_table(10) := '756E6374696F6E28297B7D2C6F6E53686F776E3A66756E6374696F6E28297B7D2C706572666F726D616E63653A21312C706C6163656D656E743A22746F70222C706F707065724F7074696F6E733A7B7D2C73686F756C64506F70706572486964654F6E42';
wwv_flow_api.g_varchar2_table(11) := '6C75723A66756E6374696F6E28297B72657475726E21307D2C73686F774F6E496E69743A21312C73697A653A22726567756C6172222C737469636B793A21312C7461726765743A22222C7468656D653A226461726B222C746F7563683A21302C746F7563';
wwv_flow_api.g_varchar2_table(12) := '68486F6C643A21312C747269676765723A226D6F757365656E74657220666F637573222C7570646174654475726174696F6E3A3230302C776169743A6E756C6C2C7A496E6465783A393939397D2C553D5B226172726F77222C226172726F775479706522';
wwv_flow_api.g_varchar2_table(13) := '2C2264697374616E6365222C22666C6970222C22666C69704265686176696F72222C226F6666736574222C22706C6163656D656E74222C22706F707065724F7074696F6E73225D2C693D22756E646566696E656422213D747970656F662077696E646F77';
wwv_flow_api.g_varchar2_table(14) := '262622756E646566696E656422213D747970656F6620646F63756D656E742C613D5B2245646765222C2254726964656E74222C2246697265666F78225D2C703D302C733D303B733C612E6C656E6774683B732B3D3129696628692626303C3D6E61766967';
wwv_flow_api.g_varchar2_table(15) := '61746F722E757365724167656E742E696E6465784F6628615B735D29297B703D313B627265616B7D766172206C3D69262677696E646F772E50726F6D6973653F66756E6374696F6E2874297B76617220653D21313B72657475726E2066756E6374696F6E';
wwv_flow_api.g_varchar2_table(16) := '28297B657C7C28653D21302C77696E646F772E50726F6D6973652E7265736F6C766528292E7468656E2866756E6374696F6E28297B653D21312C7428297D29297D7D3A66756E6374696F6E2874297B76617220653D21313B72657475726E2066756E6374';
wwv_flow_api.g_varchar2_table(17) := '696F6E28297B657C7C28653D21302C73657454696D656F75742866756E6374696F6E28297B653D21312C7428297D2C7029297D7D3B66756E6374696F6E20632874297B72657475726E20742626225B6F626A6563742046756E6374696F6E5D223D3D3D7B';
wwv_flow_api.g_varchar2_table(18) := '7D2E746F537472696E672E63616C6C2874297D66756E6374696F6E207728742C65297B69662831213D3D742E6E6F6465547970652972657475726E5B5D3B76617220723D742E6F776E6572446F63756D656E742E64656661756C74566965772E67657443';
wwv_flow_api.g_varchar2_table(19) := '6F6D70757465645374796C6528742C6E756C6C293B72657475726E20653F725B655D3A727D66756E6374696F6E20752874297B72657475726E2248544D4C223D3D3D742E6E6F64654E616D653F743A742E706172656E744E6F64657C7C742E686F73747D';
wwv_flow_api.g_varchar2_table(20) := '66756E6374696F6E206D2874297B69662821742972657475726E20646F63756D656E742E626F64793B73776974636828742E6E6F64654E616D65297B636173652248544D4C223A6361736522424F4459223A72657475726E20742E6F776E6572446F6375';
wwv_flow_api.g_varchar2_table(21) := '6D656E742E626F64793B636173652223646F63756D656E74223A72657475726E20742E626F64797D76617220653D772874292C723D652E6F766572666C6F772C6E3D652E6F766572666C6F77582C6F3D652E6F766572666C6F77593B72657475726E2F28';
wwv_flow_api.g_varchar2_table(22) := '6175746F7C7363726F6C6C7C6F7665726C6179292F2E7465737428722B6F2B6E293F743A6D2875287429297D76617220663D69262621282177696E646F772E4D53496E7075744D6574686F64436F6E746578747C7C21646F63756D656E742E646F63756D';
wwv_flow_api.g_varchar2_table(23) := '656E744D6F6465292C643D6926262F4D5349452031302F2E74657374286E6176696761746F722E757365724167656E74293B66756E6374696F6E20682874297B72657475726E2031313D3D3D743F663A31303D3D3D743F643A667C7C647D66756E637469';
wwv_flow_api.g_varchar2_table(24) := '6F6E20582874297B69662821742972657475726E20646F63756D656E742E646F63756D656E74456C656D656E743B666F722876617220653D68283130293F646F63756D656E742E626F64793A6E756C6C2C723D742E6F6666736574506172656E747C7C6E';
wwv_flow_api.g_varchar2_table(25) := '756C6C3B723D3D3D652626742E6E657874456C656D656E745369626C696E673B29723D28743D742E6E657874456C656D656E745369626C696E67292E6F6666736574506172656E743B766172206E3D722626722E6E6F64654E616D653B72657475726E20';
wwv_flow_api.g_varchar2_table(26) := '6E262622424F445922213D3D6E26262248544D4C22213D3D6E3F2D31213D3D5B225448222C225444222C225441424C45225D2E696E6465784F6628722E6E6F64654E616D6529262622737461746963223D3D3D7728722C22706F736974696F6E22293F58';
wwv_flow_api.g_varchar2_table(27) := '2872293A723A743F742E6F776E6572446F63756D656E742E646F63756D656E74456C656D656E743A646F63756D656E742E646F63756D656E74456C656D656E747D66756E6374696F6E20622874297B72657475726E206E756C6C213D3D742E706172656E';
wwv_flow_api.g_varchar2_table(28) := '744E6F64653F6228742E706172656E744E6F6465293A747D66756E6374696F6E207628742C65297B6966282128742626742E6E6F6465547970652626652626652E6E6F646554797065292972657475726E20646F63756D656E742E646F63756D656E7445';
wwv_flow_api.g_varchar2_table(29) := '6C656D656E743B76617220723D742E636F6D70617265446F63756D656E74506F736974696F6E286529264E6F64652E444F43554D454E545F504F534954494F4E5F464F4C4C4F57494E472C6E3D723F743A652C6F3D723F653A742C693D646F63756D656E';
wwv_flow_api.g_varchar2_table(30) := '742E63726561746552616E676528293B692E7365745374617274286E2C30292C692E736574456E64286F2C30293B76617220612C702C733D692E636F6D6D6F6E416E636573746F72436F6E7461696E65723B69662874213D3D73262665213D3D737C7C6E';
wwv_flow_api.g_varchar2_table(31) := '2E636F6E7461696E73286F292972657475726E22424F4459223D3D3D28703D28613D73292E6E6F64654E616D65297C7C2248544D4C22213D3D7026265828612E6669727374456C656D656E744368696C6429213D3D613F582873293A733B766172206C3D';
wwv_flow_api.g_varchar2_table(32) := '622874293B72657475726E206C2E686F73743F76286C2E686F73742C65293A7628742C622865292E686F7374297D66756E6374696F6E20792874297B76617220653D22746F70223D3D3D28313C617267756D656E74732E6C656E6774682626766F696420';
wwv_flow_api.g_varchar2_table(33) := '30213D3D617267756D656E74735B315D3F617267756D656E74735B315D3A22746F7022293F227363726F6C6C546F70223A227363726F6C6C4C656674222C723D742E6E6F64654E616D653B69662822424F445922213D3D7226262248544D4C22213D3D72';
wwv_flow_api.g_varchar2_table(34) := '2972657475726E20745B655D3B766172206E3D742E6F776E6572446F63756D656E742E646F63756D656E74456C656D656E743B72657475726E28742E6F776E6572446F63756D656E742E7363726F6C6C696E67456C656D656E747C7C6E295B655D7D6675';
wwv_flow_api.g_varchar2_table(35) := '6E6374696F6E206728742C65297B76617220723D2278223D3D3D653F224C656674223A22546F70222C6E3D224C656674223D3D3D723F225269676874223A22426F74746F6D223B72657475726E207061727365466C6F617428745B22626F72646572222B';
wwv_flow_api.g_varchar2_table(36) := '722B225769647468225D2C3130292B7061727365466C6F617428745B22626F72646572222B6E2B225769647468225D2C3130297D66756E6374696F6E207828742C652C722C6E297B72657475726E204D6174682E6D617828655B226F6666736574222B74';
wwv_flow_api.g_varchar2_table(37) := '5D2C655B227363726F6C6C222B745D2C725B22636C69656E74222B745D2C725B226F6666736574222B745D2C725B227363726F6C6C222B745D2C68283130293F7061727365496E7428725B226F6666736574222B745D292B7061727365496E74286E5B22';
wwv_flow_api.g_varchar2_table(38) := '6D617267696E222B2822486569676874223D3D3D743F22546F70223A224C65667422295D292B7061727365496E74286E5B226D617267696E222B2822486569676874223D3D3D743F22426F74746F6D223A22526967687422295D293A30297D66756E6374';
wwv_flow_api.g_varchar2_table(39) := '696F6E206B2874297B76617220653D742E626F64792C723D742E646F63756D656E74456C656D656E742C6E3D68283130292626676574436F6D70757465645374796C652872293B72657475726E7B6865696768743A782822486569676874222C652C722C';
wwv_flow_api.g_varchar2_table(40) := '6E292C77696474683A7828225769647468222C652C722C6E297D7D76617220453D66756E6374696F6E28297B66756E6374696F6E206E28742C65297B666F722876617220723D303B723C652E6C656E6774683B722B2B297B766172206E3D655B725D3B6E';
wwv_flow_api.g_varchar2_table(41) := '2E656E756D657261626C653D6E2E656E756D657261626C657C7C21312C6E2E636F6E666967757261626C653D21302C2276616C756522696E206E2626286E2E7772697461626C653D2130292C4F626A6563742E646566696E6550726F706572747928742C';
wwv_flow_api.g_varchar2_table(42) := '6E2E6B65792C6E297D7D72657475726E2066756E6374696F6E28742C652C72297B72657475726E206526266E28742E70726F746F747970652C65292C7226266E28742C72292C747D7D28292C4F3D66756E6374696F6E28742C652C72297B72657475726E';
wwv_flow_api.g_varchar2_table(43) := '206520696E20743F4F626A6563742E646566696E6550726F706572747928742C652C7B76616C75653A722C656E756D657261626C653A21302C636F6E666967757261626C653A21302C7772697461626C653A21307D293A745B655D3D722C747D2C4E3D4F';
wwv_flow_api.g_varchar2_table(44) := '626A6563742E61737369676E7C7C66756E6374696F6E2874297B666F722876617220653D313B653C617267756D656E74732E6C656E6774683B652B2B297B76617220723D617267756D656E74735B655D3B666F7228766172206E20696E2072294F626A65';
wwv_flow_api.g_varchar2_table(45) := '63742E70726F746F747970652E6861734F776E50726F70657274792E63616C6C28722C6E29262628745B6E5D3D725B6E5D297D72657475726E20747D3B66756E6374696F6E20542874297B72657475726E204E287B7D2C742C7B72696768743A742E6C65';
wwv_flow_api.g_varchar2_table(46) := '66742B742E77696474682C626F74746F6D3A742E746F702B742E6865696768747D297D66756E6374696F6E20532874297B76617220653D7B7D3B7472797B6966286828313029297B653D742E676574426F756E64696E67436C69656E745265637428293B';
wwv_flow_api.g_varchar2_table(47) := '76617220723D7928742C22746F7022292C6E3D7928742C226C65667422293B652E746F702B3D722C652E6C6566742B3D6E2C652E626F74746F6D2B3D722C652E72696768742B3D6E7D656C736520653D742E676574426F756E64696E67436C69656E7452';
wwv_flow_api.g_varchar2_table(48) := '65637428297D63617463682874297B7D766172206F3D7B6C6566743A652E6C6566742C746F703A652E746F702C77696474683A652E72696768742D652E6C6566742C6865696768743A652E626F74746F6D2D652E746F707D2C693D2248544D4C223D3D3D';
wwv_flow_api.g_varchar2_table(49) := '742E6E6F64654E616D653F6B28742E6F776E6572446F63756D656E74293A7B7D2C613D692E77696474687C7C742E636C69656E7457696474687C7C6F2E72696768742D6F2E6C6566742C703D692E6865696768747C7C742E636C69656E74486569676874';
wwv_flow_api.g_varchar2_table(50) := '7C7C6F2E626F74746F6D2D6F2E746F702C733D742E6F666673657457696474682D612C6C3D742E6F66667365744865696768742D703B696628737C7C6C297B76617220633D772874293B732D3D6728632C227822292C6C2D3D6728632C227922292C6F2E';
wwv_flow_api.g_varchar2_table(51) := '77696474682D3D732C6F2E6865696768742D3D6C7D72657475726E2054286F297D66756E6374696F6E204C28742C65297B76617220723D323C617267756D656E74732E6C656E6774682626766F69642030213D3D617267756D656E74735B325D26266172';
wwv_flow_api.g_varchar2_table(52) := '67756D656E74735B325D2C6E3D68283130292C6F3D2248544D4C223D3D3D652E6E6F64654E616D652C693D532874292C613D532865292C703D6D2874292C733D772865292C6C3D7061727365466C6F617428732E626F72646572546F7057696474682C31';
wwv_flow_api.g_varchar2_table(53) := '30292C633D7061727365466C6F617428732E626F726465724C65667457696474682C3130293B7226266F262628612E746F703D4D6174682E6D617828612E746F702C30292C612E6C6566743D4D6174682E6D617828612E6C6566742C3029293B76617220';
wwv_flow_api.g_varchar2_table(54) := '663D54287B746F703A692E746F702D612E746F702D6C2C6C6566743A692E6C6566742D612E6C6566742D632C77696474683A692E77696474682C6865696768743A692E6865696768747D293B696628662E6D617267696E546F703D302C662E6D61726769';
wwv_flow_api.g_varchar2_table(55) := '6E4C6566743D302C216E26266F297B76617220643D7061727365466C6F617428732E6D617267696E546F702C3130292C753D7061727365466C6F617428732E6D617267696E4C6566742C3130293B662E746F702D3D6C2D642C662E626F74746F6D2D3D6C';
wwv_flow_api.g_varchar2_table(56) := '2D642C662E6C6566742D3D632D752C662E72696768742D3D632D752C662E6D617267696E546F703D642C662E6D617267696E4C6566743D757D72657475726E286E262621723F652E636F6E7461696E732870293A653D3D3D70262622424F445922213D3D';
wwv_flow_api.g_varchar2_table(57) := '702E6E6F64654E616D6529262628663D66756E6374696F6E28742C65297B76617220723D323C617267756D656E74732E6C656E6774682626766F69642030213D3D617267756D656E74735B325D2626617267756D656E74735B325D2C6E3D7928652C2274';
wwv_flow_api.g_varchar2_table(58) := '6F7022292C6F3D7928652C226C65667422292C693D723F2D313A313B72657475726E20742E746F702B3D6E2A692C742E626F74746F6D2B3D6E2A692C742E6C6566742B3D6F2A692C742E72696768742B3D6F2A692C747D28662C6529292C667D66756E63';
wwv_flow_api.g_varchar2_table(59) := '74696F6E20432874297B69662821747C7C21742E706172656E74456C656D656E747C7C6828292972657475726E20646F63756D656E742E646F63756D656E74456C656D656E743B666F722876617220653D742E706172656E74456C656D656E743B652626';
wwv_flow_api.g_varchar2_table(60) := '226E6F6E65223D3D3D7728652C227472616E73666F726D22293B29653D652E706172656E74456C656D656E743B72657475726E20657C7C646F63756D656E742E646F63756D656E74456C656D656E747D66756E6374696F6E204128742C652C722C6E297B';
wwv_flow_api.g_varchar2_table(61) := '766172206F3D343C617267756D656E74732E6C656E6774682626766F69642030213D3D617267756D656E74735B345D2626617267756D656E74735B345D2C693D7B746F703A302C6C6566743A307D2C613D6F3F432874293A7628742C65293B6966282276';
wwv_flow_api.g_varchar2_table(62) := '696577706F7274223D3D3D6E29693D66756E6374696F6E2874297B76617220653D313C617267756D656E74732E6C656E6774682626766F69642030213D3D617267756D656E74735B315D2626617267756D656E74735B315D2C723D742E6F776E6572446F';
wwv_flow_api.g_varchar2_table(63) := '63756D656E742E646F63756D656E74456C656D656E742C6E3D4C28742C72292C6F3D4D6174682E6D617828722E636C69656E7457696474682C77696E646F772E696E6E657257696474687C7C30292C693D4D6174682E6D617828722E636C69656E744865';
wwv_flow_api.g_varchar2_table(64) := '696768742C77696E646F772E696E6E65724865696768747C7C30292C613D653F303A792872292C703D653F303A7928722C226C65667422293B72657475726E2054287B746F703A612D6E2E746F702B6E2E6D617267696E546F702C6C6566743A702D6E2E';
wwv_flow_api.g_varchar2_table(65) := '6C6566742B6E2E6D617267696E4C6566742C77696474683A6F2C6865696768743A697D297D28612C6F293B656C73657B76617220703D766F696420303B227363726F6C6C506172656E74223D3D3D6E3F22424F4459223D3D3D28703D6D28752865292929';
wwv_flow_api.g_varchar2_table(66) := '2E6E6F64654E616D65262628703D742E6F776E6572446F63756D656E742E646F63756D656E74456C656D656E74293A703D2277696E646F77223D3D3D6E3F742E6F776E6572446F63756D656E742E646F63756D656E74456C656D656E743A6E3B76617220';
wwv_flow_api.g_varchar2_table(67) := '733D4C28702C612C6F293B6966282248544D4C22213D3D702E6E6F64654E616D657C7C66756E6374696F6E20742865297B76617220723D652E6E6F64654E616D653B72657475726E22424F445922213D3D7226262248544D4C22213D3D72262628226669';
wwv_flow_api.g_varchar2_table(68) := '786564223D3D3D7728652C22706F736974696F6E22297C7C74287528652929297D28612929693D733B656C73657B766172206C3D6B28742E6F776E6572446F63756D656E74292C633D6C2E6865696768742C663D6C2E77696474683B692E746F702B3D73';
wwv_flow_api.g_varchar2_table(69) := '2E746F702D732E6D617267696E546F702C692E626F74746F6D3D632B732E746F702C692E6C6566742B3D732E6C6566742D732E6D617267696E4C6566742C692E72696768743D662B732E6C6566747D7D76617220643D226E756D626572223D3D74797065';
wwv_flow_api.g_varchar2_table(70) := '6F6628723D727C7C30293B72657475726E20692E6C6566742B3D643F723A722E6C6566747C7C302C692E746F702B3D643F723A722E746F707C7C302C692E72696768742D3D643F723A722E72696768747C7C302C692E626F74746F6D2D3D643F723A722E';
wwv_flow_api.g_varchar2_table(71) := '626F74746F6D7C7C302C697D66756E6374696F6E205928742C652C6E2C722C6F297B76617220693D353C617267756D656E74732E6C656E6774682626766F69642030213D3D617267756D656E74735B355D3F617267756D656E74735B355D3A303B696628';
wwv_flow_api.g_varchar2_table(72) := '2D313D3D3D742E696E6465784F6628226175746F22292972657475726E20743B76617220613D41286E2C722C692C6F292C703D7B746F703A7B77696474683A612E77696474682C6865696768743A652E746F702D612E746F707D2C72696768743A7B7769';
wwv_flow_api.g_varchar2_table(73) := '6474683A612E72696768742D652E72696768742C6865696768743A612E6865696768747D2C626F74746F6D3A7B77696474683A612E77696474682C6865696768743A612E626F74746F6D2D652E626F74746F6D7D2C6C6566743A7B77696474683A652E6C';
wwv_flow_api.g_varchar2_table(74) := '6566742D612E6C6566742C6865696768743A612E6865696768747D7D2C733D4F626A6563742E6B6579732870292E6D61702866756E6374696F6E2874297B72657475726E204E287B6B65793A747D2C705B745D2C7B617265613A28653D705B745D2C652E';
wwv_flow_api.g_varchar2_table(75) := '77696474682A652E686569676874297D293B76617220657D292E736F72742866756E6374696F6E28742C65297B72657475726E20652E617265612D742E617265617D292C6C3D732E66696C7465722866756E6374696F6E2874297B76617220653D742E77';
wwv_flow_api.g_varchar2_table(76) := '696474682C723D742E6865696768743B72657475726E20653E3D6E2E636C69656E7457696474682626723E3D6E2E636C69656E744865696768747D292C633D303C6C2E6C656E6774683F6C5B305D2E6B65793A735B305D2E6B65792C663D742E73706C69';
wwv_flow_api.g_varchar2_table(77) := '7428222D22295B315D3B72657475726E20632B28663F222D222B663A2222297D66756E6374696F6E204428742C652C72297B766172206E3D333C617267756D656E74732E6C656E6774682626766F69642030213D3D617267756D656E74735B335D3F6172';
wwv_flow_api.g_varchar2_table(78) := '67756D656E74735B335D3A6E756C6C3B72657475726E204C28722C6E3F432865293A7628652C72292C6E297D66756E6374696F6E204D2874297B76617220653D742E6F776E6572446F63756D656E742E64656661756C74566965772E676574436F6D7075';
wwv_flow_api.g_varchar2_table(79) := '7465645374796C652874292C723D7061727365466C6F617428652E6D617267696E546F707C7C30292B7061727365466C6F617428652E6D617267696E426F74746F6D7C7C30292C6E3D7061727365466C6F617428652E6D617267696E4C6566747C7C3029';
wwv_flow_api.g_varchar2_table(80) := '2B7061727365466C6F617428652E6D617267696E52696768747C7C30293B72657475726E7B77696474683A742E6F666673657457696474682B6E2C6865696768743A742E6F66667365744865696768742B727D7D66756E6374696F6E20502874297B7661';
wwv_flow_api.g_varchar2_table(81) := '7220653D7B6C6566743A227269676874222C72696768743A226C656674222C626F74746F6D3A22746F70222C746F703A22626F74746F6D227D3B72657475726E20742E7265706C616365282F6C6566747C72696768747C626F74746F6D7C746F702F672C';
wwv_flow_api.g_varchar2_table(82) := '66756E6374696F6E2874297B72657475726E20655B745D7D297D66756E6374696F6E204928742C652C72297B723D722E73706C697428222D22295B305D3B766172206E3D4D2874292C6F3D7B77696474683A6E2E77696474682C6865696768743A6E2E68';
wwv_flow_api.g_varchar2_table(83) := '65696768747D2C693D2D31213D3D5B227269676874222C226C656674225D2E696E6465784F662872292C613D693F22746F70223A226C656674222C703D693F226C656674223A22746F70222C733D693F22686569676874223A227769647468222C6C3D69';
wwv_flow_api.g_varchar2_table(84) := '3F227769647468223A22686569676874223B72657475726E206F5B615D3D655B615D2B655B735D2F322D6E5B735D2F322C6F5B705D3D723D3D3D703F655B705D2D6E5B6C5D3A655B502870295D2C6F7D66756E6374696F6E204828742C65297B72657475';
wwv_flow_api.g_varchar2_table(85) := '726E2041727261792E70726F746F747970652E66696E643F742E66696E642865293A742E66696C7465722865295B305D7D66756E6374696F6E204628742C722C65297B72657475726E28766F696420303D3D3D653F743A742E736C69636528302C66756E';
wwv_flow_api.g_varchar2_table(86) := '6374696F6E28742C652C72297B69662841727261792E70726F746F747970652E66696E64496E6465782972657475726E20742E66696E64496E6465782866756E6374696F6E2874297B72657475726E20745B655D3D3D3D727D293B766172206E3D482874';
wwv_flow_api.g_varchar2_table(87) := '2C66756E6374696F6E2874297B72657475726E20745B655D3D3D3D727D293B72657475726E20742E696E6465784F66286E297D28742C226E616D65222C652929292E666F72456163682866756E6374696F6E2874297B742E66756E6374696F6E2626636F';
wwv_flow_api.g_varchar2_table(88) := '6E736F6C652E7761726E2822606D6F6469666965722E66756E6374696F6E6020697320646570726563617465642C2075736520606D6F6469666965722E666E602122293B76617220653D742E66756E6374696F6E7C7C742E666E3B742E656E61626C6564';
wwv_flow_api.g_varchar2_table(89) := '262663286529262628722E6F6666736574732E706F707065723D5428722E6F6666736574732E706F70706572292C722E6F6666736574732E7265666572656E63653D5428722E6F6666736574732E7265666572656E6365292C723D6528722C7429297D29';
wwv_flow_api.g_varchar2_table(90) := '2C727D66756E6374696F6E204228742C72297B72657475726E20742E736F6D652866756E6374696F6E2874297B76617220653D742E6E616D653B72657475726E20742E656E61626C65642626653D3D3D727D297D66756E6374696F6E20522874297B666F';
wwv_flow_api.g_varchar2_table(91) := '722876617220653D5B21312C226D73222C225765626B6974222C224D6F7A222C224F225D2C723D742E6368617241742830292E746F55707065724361736528292B742E736C6963652831292C6E3D303B6E3C652E6C656E6774683B6E2B2B297B76617220';
wwv_flow_api.g_varchar2_table(92) := '6F3D655B6E5D2C693D6F3F22222B6F2B723A743B696628766F69642030213D3D646F63756D656E742E626F64792E7374796C655B695D2972657475726E20697D72657475726E206E756C6C7D66756E6374696F6E20572874297B76617220653D742E6F77';
wwv_flow_api.g_varchar2_table(93) := '6E6572446F63756D656E743B72657475726E20653F652E64656661756C74566965773A77696E646F777D66756E6374696F6E207A28742C652C722C6E297B722E757064617465426F756E643D6E2C572874292E6164644576656E744C697374656E657228';
wwv_flow_api.g_varchar2_table(94) := '22726573697A65222C722E757064617465426F756E642C7B706173736976653A21307D293B766172206F3D6D2874293B72657475726E2066756E6374696F6E207428652C722C6E2C6F297B76617220693D22424F4459223D3D3D652E6E6F64654E616D65';
wwv_flow_api.g_varchar2_table(95) := '2C613D693F652E6F776E6572446F63756D656E742E64656661756C74566965773A653B612E6164644576656E744C697374656E657228722C6E2C7B706173736976653A21307D292C697C7C74286D28612E706172656E744E6F6465292C722C6E2C6F292C';
wwv_flow_api.g_varchar2_table(96) := '6F2E707573682861297D286F2C227363726F6C6C222C722E757064617465426F756E642C722E7363726F6C6C506172656E7473292C722E7363726F6C6C456C656D656E743D6F2C722E6576656E7473456E61626C65643D21302C727D66756E6374696F6E';
wwv_flow_api.g_varchar2_table(97) := '207128297B76617220742C653B746869732E73746174652E6576656E7473456E61626C656426262863616E63656C416E696D6174696F6E4672616D6528746869732E7363686564756C65557064617465292C746869732E73746174653D28743D74686973';
wwv_flow_api.g_varchar2_table(98) := '2E7265666572656E63652C653D746869732E73746174652C572874292E72656D6F76654576656E744C697374656E65722822726573697A65222C652E757064617465426F756E64292C652E7363726F6C6C506172656E74732E666F72456163682866756E';
wwv_flow_api.g_varchar2_table(99) := '6374696F6E2874297B742E72656D6F76654576656E744C697374656E657228227363726F6C6C222C652E757064617465426F756E64297D292C652E757064617465426F756E643D6E756C6C2C652E7363726F6C6C506172656E74733D5B5D2C652E736372';
wwv_flow_api.g_varchar2_table(100) := '6F6C6C456C656D656E743D6E756C6C2C652E6576656E7473456E61626C65643D21312C6529297D66756E6374696F6E20472874297B72657475726E2222213D3D7426262169734E614E287061727365466C6F6174287429292626697346696E6974652874';
wwv_flow_api.g_varchar2_table(101) := '297D66756E6374696F6E204B28722C6E297B4F626A6563742E6B657973286E292E666F72456163682866756E6374696F6E2874297B76617220653D22223B2D31213D3D5B227769647468222C22686569676874222C22746F70222C227269676874222C22';
wwv_flow_api.g_varchar2_table(102) := '626F74746F6D222C226C656674225D2E696E6465784F66287429262647286E5B745D29262628653D22707822292C722E7374796C655B745D3D6E5B745D2B657D297D766172204A3D6926262F46697265666F782F692E74657374286E6176696761746F72';
wwv_flow_api.g_varchar2_table(103) := '2E757365724167656E74293B66756E6374696F6E205128742C652C72297B766172206E3D4828742C66756E6374696F6E2874297B72657475726E20742E6E616D653D3D3D657D292C6F3D21216E2626742E736F6D652866756E6374696F6E2874297B7265';
wwv_flow_api.g_varchar2_table(104) := '7475726E20742E6E616D653D3D3D722626742E656E61626C65642626742E6F726465723C6E2E6F726465727D293B696628216F297B76617220693D2260222B652B2260222C613D2260222B722B2260223B636F6E736F6C652E7761726E28612B22206D6F';
wwv_flow_api.g_varchar2_table(105) := '64696669657220697320726571756972656420627920222B692B22206D6F64696669657220696E206F7264657220746F20776F726B2C206265207375726520746F20696E636C756465206974206265666F726520222B692B222122297D72657475726E20';
wwv_flow_api.g_varchar2_table(106) := '6F7D766172205A3D5B226175746F2D7374617274222C226175746F222C226175746F2D656E64222C22746F702D7374617274222C22746F70222C22746F702D656E64222C2272696768742D7374617274222C227269676874222C2272696768742D656E64';
wwv_flow_api.g_varchar2_table(107) := '222C22626F74746F6D2D656E64222C22626F74746F6D222C22626F74746F6D2D7374617274222C226C6566742D656E64222C226C656674222C226C6566742D7374617274225D2C243D5A2E736C6963652833293B66756E6374696F6E2074742874297B76';
wwv_flow_api.g_varchar2_table(108) := '617220653D313C617267756D656E74732E6C656E6774682626766F69642030213D3D617267756D656E74735B315D2626617267756D656E74735B315D2C723D242E696E6465784F662874292C6E3D242E736C69636528722B31292E636F6E63617428242E';
wwv_flow_api.g_varchar2_table(109) := '736C69636528302C7229293B72657475726E20653F6E2E7265766572736528293A6E7D7661722065743D22666C6970222C72743D22636C6F636B77697365222C6E743D22636F756E746572636C6F636B77697365223B66756E6374696F6E206F7428742C';
wwv_flow_api.g_varchar2_table(110) := '6F2C692C65297B76617220613D5B302C305D2C703D2D31213D3D5B227269676874222C226C656674225D2E696E6465784F662865292C723D742E73706C6974282F285C2B7C5C2D292F292E6D61702866756E6374696F6E2874297B72657475726E20742E';
wwv_flow_api.g_varchar2_table(111) := '7472696D28297D292C6E3D722E696E6465784F66284828722C66756E6374696F6E2874297B72657475726E2D31213D3D742E736561726368282F2C7C5C732F297D29293B725B6E5D26262D313D3D3D725B6E5D2E696E6465784F6628222C22292626636F';
wwv_flow_api.g_varchar2_table(112) := '6E736F6C652E7761726E28224F666673657473207365706172617465642062792077686974652073706163652873292061726520646570726563617465642C20757365206120636F6D6D6120282C2920696E73746561642E22293B76617220733D2F5C73';
wwv_flow_api.g_varchar2_table(113) := '2A2C5C732A7C5C732B2F2C6C3D2D31213D3D6E3F5B722E736C69636528302C6E292E636F6E636174285B725B6E5D2E73706C69742873295B305D5D292C5B725B6E5D2E73706C69742873295B315D5D2E636F6E63617428722E736C696365286E2B312929';
wwv_flow_api.g_varchar2_table(114) := '5D3A5B725D3B72657475726E286C3D6C2E6D61702866756E6374696F6E28742C65297B76617220723D28313D3D3D653F21703A70293F22686569676874223A227769647468222C6E3D21313B72657475726E20742E7265647563652866756E6374696F6E';
wwv_flow_api.g_varchar2_table(115) := '28742C65297B72657475726E22223D3D3D745B742E6C656E6774682D315D26262D31213D3D5B222B222C222D225D2E696E6465784F662865293F28745B742E6C656E6774682D315D3D652C6E3D21302C74293A6E3F28745B742E6C656E6774682D315D2B';
wwv_flow_api.g_varchar2_table(116) := '3D652C6E3D21312C74293A742E636F6E6361742865297D2C5B5D292E6D61702866756E6374696F6E2874297B72657475726E2066756E6374696F6E28742C652C722C6E297B766172206F3D742E6D61746368282F28283F3A5C2D7C5C2B293F5C642A5C2E';
wwv_flow_api.g_varchar2_table(117) := '3F5C642A29282E2A292F292C693D2B6F5B315D2C613D6F5B325D3B69662821692972657475726E20743B69662830213D3D612E696E6465784F6628222522292972657475726E22766822213D3D61262622767722213D3D613F693A28227668223D3D3D61';
wwv_flow_api.g_varchar2_table(118) := '3F4D6174682E6D617828646F63756D656E742E646F63756D656E74456C656D656E742E636C69656E744865696768742C77696E646F772E696E6E65724865696768747C7C30293A4D6174682E6D617828646F63756D656E742E646F63756D656E74456C65';
wwv_flow_api.g_varchar2_table(119) := '6D656E742E636C69656E7457696474682C77696E646F772E696E6E657257696474687C7C3029292F3130302A693B76617220703D766F696420303B7377697463682861297B63617365222570223A703D723B627265616B3B636173652225223A63617365';
wwv_flow_api.g_varchar2_table(120) := '222572223A64656661756C743A703D6E7D72657475726E20542870295B655D2F3130302A697D28742C722C6F2C69297D297D29292E666F72456163682866756E6374696F6E28722C6E297B722E666F72456163682866756E6374696F6E28742C65297B47';
wwv_flow_api.g_varchar2_table(121) := '287429262628615B6E5D2B3D742A28222D223D3D3D725B652D315D3F2D313A3129297D297D292C617D7661722069743D7B706C6163656D656E743A22626F74746F6D222C706F736974696F6E46697865643A21312C6576656E7473456E61626C65643A21';
wwv_flow_api.g_varchar2_table(122) := '302C72656D6F76654F6E44657374726F793A21312C6F6E4372656174653A66756E6374696F6E28297B7D2C6F6E5570646174653A66756E6374696F6E28297B7D2C6D6F646966696572733A7B73686966743A7B6F726465723A3130302C656E61626C6564';
wwv_flow_api.g_varchar2_table(123) := '3A21302C666E3A66756E6374696F6E2874297B76617220653D742E706C6163656D656E742C723D652E73706C697428222D22295B305D2C6E3D652E73706C697428222D22295B315D3B6966286E297B766172206F3D742E6F6666736574732C693D6F2E72';
wwv_flow_api.g_varchar2_table(124) := '65666572656E63652C613D6F2E706F707065722C703D2D31213D3D5B22626F74746F6D222C22746F70225D2E696E6465784F662872292C733D703F226C656674223A22746F70222C6C3D703F227769647468223A22686569676874222C633D7B73746172';
wwv_flow_api.g_varchar2_table(125) := '743A4F287B7D2C732C695B735D292C656E643A4F287B7D2C732C695B735D2B695B6C5D2D615B6C5D297D3B742E6F6666736574732E706F707065723D4E287B7D2C612C635B6E5D297D72657475726E20747D7D2C6F66667365743A7B6F726465723A3230';
wwv_flow_api.g_varchar2_table(126) := '302C656E61626C65643A21302C666E3A66756E6374696F6E28742C65297B76617220723D652E6F66667365742C6E3D742E706C6163656D656E742C6F3D742E6F6666736574732C693D6F2E706F707065722C613D6F2E7265666572656E63652C703D6E2E';
wwv_flow_api.g_varchar2_table(127) := '73706C697428222D22295B305D2C733D766F696420303B72657475726E20733D47282B72293F5B2B722C305D3A6F7428722C692C612C70292C226C656674223D3D3D703F28692E746F702B3D735B305D2C692E6C6566742D3D735B315D293A2272696768';
wwv_flow_api.g_varchar2_table(128) := '74223D3D3D703F28692E746F702B3D735B305D2C692E6C6566742B3D735B315D293A22746F70223D3D3D703F28692E6C6566742B3D735B305D2C692E746F702D3D735B315D293A22626F74746F6D223D3D3D70262628692E6C6566742B3D735B305D2C69';
wwv_flow_api.g_varchar2_table(129) := '2E746F702B3D735B315D292C742E706F707065723D692C747D2C6F66667365743A307D2C70726576656E744F766572666C6F773A7B6F726465723A3330302C656E61626C65643A21302C666E3A66756E6374696F6E28742C6E297B76617220653D6E2E62';
wwv_flow_api.g_varchar2_table(130) := '6F756E646172696573456C656D656E747C7C5828742E696E7374616E63652E706F70706572293B742E696E7374616E63652E7265666572656E63653D3D3D65262628653D58286529293B76617220723D5228227472616E73666F726D22292C6F3D742E69';
wwv_flow_api.g_varchar2_table(131) := '6E7374616E63652E706F707065722E7374796C652C693D6F2E746F702C613D6F2E6C6566742C703D6F5B725D3B6F2E746F703D22222C6F2E6C6566743D22222C6F5B725D3D22223B76617220733D4128742E696E7374616E63652E706F707065722C742E';
wwv_flow_api.g_varchar2_table(132) := '696E7374616E63652E7265666572656E63652C6E2E70616464696E672C652C742E706F736974696F6E4669786564293B6F2E746F703D692C6F2E6C6566743D612C6F5B725D3D702C6E2E626F756E6461726965733D733B766172206C3D6E2E7072696F72';
wwv_flow_api.g_varchar2_table(133) := '6974792C633D742E6F6666736574732E706F707065722C663D7B7072696D6172793A66756E6374696F6E2874297B76617220653D635B745D3B72657475726E20635B745D3C735B745D2626216E2E657363617065576974685265666572656E6365262628';
wwv_flow_api.g_varchar2_table(134) := '653D4D6174682E6D617828635B745D2C735B745D29292C4F287B7D2C742C65297D2C7365636F6E646172793A66756E6374696F6E2874297B76617220653D227269676874223D3D3D743F226C656674223A22746F70222C723D635B655D3B72657475726E';
wwv_flow_api.g_varchar2_table(135) := '20635B745D3E735B745D2626216E2E657363617065576974685265666572656E6365262628723D4D6174682E6D696E28635B655D2C735B745D2D28227269676874223D3D3D743F632E77696474683A632E6865696768742929292C4F287B7D2C652C7229';
wwv_flow_api.g_varchar2_table(136) := '7D7D3B72657475726E206C2E666F72456163682866756E6374696F6E2874297B76617220653D2D31213D3D5B226C656674222C22746F70225D2E696E6465784F662874293F227072696D617279223A227365636F6E64617279223B633D4E287B7D2C632C';
wwv_flow_api.g_varchar2_table(137) := '665B655D287429297D292C742E6F6666736574732E706F707065723D632C747D2C7072696F726974793A5B226C656674222C227269676874222C22746F70222C22626F74746F6D225D2C70616464696E673A352C626F756E646172696573456C656D656E';
wwv_flow_api.g_varchar2_table(138) := '743A227363726F6C6C506172656E74227D2C6B656570546F6765746865723A7B6F726465723A3430302C656E61626C65643A21302C666E3A66756E6374696F6E2874297B76617220653D742E6F6666736574732C723D652E706F707065722C6E3D652E72';
wwv_flow_api.g_varchar2_table(139) := '65666572656E63652C6F3D742E706C6163656D656E742E73706C697428222D22295B305D2C693D4D6174682E666C6F6F722C613D2D31213D3D5B22746F70222C22626F74746F6D225D2E696E6465784F66286F292C703D613F227269676874223A22626F';
wwv_flow_api.g_varchar2_table(140) := '74746F6D222C733D613F226C656674223A22746F70222C6C3D613F227769647468223A22686569676874223B72657475726E20725B705D3C69286E5B735D29262628742E6F6666736574732E706F707065725B735D3D69286E5B735D292D725B6C5D292C';
wwv_flow_api.g_varchar2_table(141) := '725B735D3E69286E5B705D29262628742E6F6666736574732E706F707065725B735D3D69286E5B705D29292C747D7D2C6172726F773A7B6F726465723A3530302C656E61626C65643A21302C666E3A66756E6374696F6E28742C65297B76617220723B69';
wwv_flow_api.g_varchar2_table(142) := '6628215128742E696E7374616E63652E6D6F646966696572732C226172726F77222C226B656570546F67657468657222292972657475726E20743B766172206E3D652E656C656D656E743B69662822737472696E67223D3D747970656F66206E297B6966';
wwv_flow_api.g_varchar2_table(143) := '2821286E3D742E696E7374616E63652E706F707065722E717565727953656C6563746F72286E29292972657475726E20747D656C73652069662821742E696E7374616E63652E706F707065722E636F6E7461696E73286E292972657475726E20636F6E73';
wwv_flow_api.g_varchar2_table(144) := '6F6C652E7761726E28225741524E494E473A20606172726F772E656C656D656E7460206D757374206265206368696C64206F662069747320706F7070657220656C656D656E742122292C743B766172206F3D742E706C6163656D656E742E73706C697428';
wwv_flow_api.g_varchar2_table(145) := '222D22295B305D2C693D742E6F6666736574732C613D692E706F707065722C703D692E7265666572656E63652C733D2D31213D3D5B226C656674222C227269676874225D2E696E6465784F66286F292C6C3D733F22686569676874223A22776964746822';
wwv_flow_api.g_varchar2_table(146) := '2C633D733F22546F70223A224C656674222C663D632E746F4C6F7765724361736528292C643D733F226C656674223A22746F70222C753D733F22626F74746F6D223A227269676874222C6D3D4D286E295B6C5D3B705B755D2D6D3C615B665D262628742E';
wwv_flow_api.g_varchar2_table(147) := '6F6666736574732E706F707065725B665D2D3D615B665D2D28705B755D2D6D29292C705B665D2B6D3E615B755D262628742E6F6666736574732E706F707065725B665D2B3D705B665D2B6D2D615B755D292C742E6F6666736574732E706F707065723D54';
wwv_flow_api.g_varchar2_table(148) := '28742E6F6666736574732E706F70706572293B76617220683D705B665D2B705B6C5D2F322D6D2F322C623D7728742E696E7374616E63652E706F70706572292C763D7061727365466C6F617428625B226D617267696E222B635D2C3130292C793D706172';
wwv_flow_api.g_varchar2_table(149) := '7365466C6F617428625B22626F72646572222B632B225769647468225D2C3130292C673D682D742E6F6666736574732E706F707065725B665D2D762D793B72657475726E20673D4D6174682E6D6178284D6174682E6D696E28615B6C5D2D6D2C67292C30';
wwv_flow_api.g_varchar2_table(150) := '292C742E6172726F77456C656D656E743D6E2C742E6F6666736574732E6172726F773D284F28723D7B7D2C662C4D6174682E726F756E64286729292C4F28722C642C2222292C72292C747D2C656C656D656E743A225B782D6172726F775D227D2C666C69';
wwv_flow_api.g_varchar2_table(151) := '703A7B6F726465723A3630302C656E61626C65643A21302C666E3A66756E6374696F6E286D2C68297B69662842286D2E696E7374616E63652E6D6F646966696572732C22696E6E657222292972657475726E206D3B6966286D2E666C697070656426266D';
wwv_flow_api.g_varchar2_table(152) := '2E706C6163656D656E743D3D3D6D2E6F726967696E616C506C6163656D656E742972657475726E206D3B76617220623D41286D2E696E7374616E63652E706F707065722C6D2E696E7374616E63652E7265666572656E63652C682E70616464696E672C68';
wwv_flow_api.g_varchar2_table(153) := '2E626F756E646172696573456C656D656E742C6D2E706F736974696F6E4669786564292C763D6D2E706C6163656D656E742E73706C697428222D22295B305D2C793D502876292C673D6D2E706C6163656D656E742E73706C697428222D22295B315D7C7C';
wwv_flow_api.g_varchar2_table(154) := '22222C773D5B5D3B73776974636828682E6265686176696F72297B636173652065743A773D5B762C795D3B627265616B3B636173652072743A773D74742876293B627265616B3B63617365206E743A773D747428762C2130293B627265616B3B64656661';
wwv_flow_api.g_varchar2_table(155) := '756C743A773D682E6265686176696F727D72657475726E20772E666F72456163682866756E6374696F6E28742C65297B69662876213D3D747C7C772E6C656E6774683D3D3D652B312972657475726E206D3B763D6D2E706C6163656D656E742E73706C69';
wwv_flow_api.g_varchar2_table(156) := '7428222D22295B305D2C793D502876293B76617220722C6E3D6D2E6F6666736574732E706F707065722C6F3D6D2E6F6666736574732E7265666572656E63652C693D4D6174682E666C6F6F722C613D226C656674223D3D3D76262669286E2E7269676874';
wwv_flow_api.g_varchar2_table(157) := '293E69286F2E6C656674297C7C227269676874223D3D3D76262669286E2E6C656674293C69286F2E7269676874297C7C22746F70223D3D3D76262669286E2E626F74746F6D293E69286F2E746F70297C7C22626F74746F6D223D3D3D76262669286E2E74';
wwv_flow_api.g_varchar2_table(158) := '6F70293C69286F2E626F74746F6D292C703D69286E2E6C656674293C6928622E6C656674292C733D69286E2E7269676874293E6928622E7269676874292C6C3D69286E2E746F70293C6928622E746F70292C633D69286E2E626F74746F6D293E6928622E';
wwv_flow_api.g_varchar2_table(159) := '626F74746F6D292C663D226C656674223D3D3D762626707C7C227269676874223D3D3D762626737C7C22746F70223D3D3D7626266C7C7C22626F74746F6D223D3D3D762626632C643D2D31213D3D5B22746F70222C22626F74746F6D225D2E696E646578';
wwv_flow_api.g_varchar2_table(160) := '4F662876292C753D2121682E666C6970566172696174696F6E73262628642626227374617274223D3D3D672626707C7C64262622656E64223D3D3D672626737C7C21642626227374617274223D3D3D6726266C7C7C2164262622656E64223D3D3D672626';
wwv_flow_api.g_varchar2_table(161) := '63293B28617C7C667C7C75292626286D2E666C69707065643D21302C28617C7C6629262628763D775B652B315D292C75262628673D22656E64223D3D3D28723D67293F227374617274223A227374617274223D3D3D723F22656E64223A72292C6D2E706C';
wwv_flow_api.g_varchar2_table(162) := '6163656D656E743D762B28673F222D222B673A2222292C6D2E6F6666736574732E706F707065723D4E287B7D2C6D2E6F6666736574732E706F707065722C49286D2E696E7374616E63652E706F707065722C6D2E6F6666736574732E7265666572656E63';
wwv_flow_api.g_varchar2_table(163) := '652C6D2E706C6163656D656E7429292C6D3D46286D2E696E7374616E63652E6D6F646966696572732C6D2C22666C69702229297D292C6D7D2C6265686176696F723A22666C6970222C70616464696E673A352C626F756E646172696573456C656D656E74';
wwv_flow_api.g_varchar2_table(164) := '3A2276696577706F7274227D2C696E6E65723A7B6F726465723A3730302C656E61626C65643A21312C666E3A66756E6374696F6E2874297B76617220653D742E706C6163656D656E742C723D652E73706C697428222D22295B305D2C6E3D742E6F666673';
wwv_flow_api.g_varchar2_table(165) := '6574732C6F3D6E2E706F707065722C693D6E2E7265666572656E63652C613D2D31213D3D5B226C656674222C227269676874225D2E696E6465784F662872292C703D2D313D3D3D5B22746F70222C226C656674225D2E696E6465784F662872293B726574';
wwv_flow_api.g_varchar2_table(166) := '75726E206F5B613F226C656674223A22746F70225D3D695B725D2D28703F6F5B613F227769647468223A22686569676874225D3A30292C742E706C6163656D656E743D502865292C742E6F6666736574732E706F707065723D54286F292C747D7D2C6869';
wwv_flow_api.g_varchar2_table(167) := '64653A7B6F726465723A3830302C656E61626C65643A21302C666E3A66756E6374696F6E2874297B696628215128742E696E7374616E63652E6D6F646966696572732C2268696465222C2270726576656E744F766572666C6F7722292972657475726E20';
wwv_flow_api.g_varchar2_table(168) := '743B76617220653D742E6F6666736574732E7265666572656E63652C723D4828742E696E7374616E63652E6D6F646966696572732C66756E6374696F6E2874297B72657475726E2270726576656E744F766572666C6F77223D3D3D742E6E616D657D292E';
wwv_flow_api.g_varchar2_table(169) := '626F756E6461726965733B696628652E626F74746F6D3C722E746F707C7C652E6C6566743E722E72696768747C7C652E746F703E722E626F74746F6D7C7C652E72696768743C722E6C656674297B69662821303D3D3D742E686964652972657475726E20';
wwv_flow_api.g_varchar2_table(170) := '743B742E686964653D21302C742E617474726962757465735B22782D6F75742D6F662D626F756E646172696573225D3D22227D656C73657B69662821313D3D3D742E686964652972657475726E20743B742E686964653D21312C742E6174747269627574';
wwv_flow_api.g_varchar2_table(171) := '65735B22782D6F75742D6F662D626F756E646172696573225D3D21317D72657475726E20747D7D2C636F6D707574655374796C653A7B6F726465723A3835302C656E61626C65643A21302C666E3A66756E6374696F6E28742C65297B76617220723D652E';
wwv_flow_api.g_varchar2_table(172) := '782C6E3D652E792C6F3D742E6F6666736574732E706F707065722C693D4828742E696E7374616E63652E6D6F646966696572732C66756E6374696F6E2874297B72657475726E226170706C795374796C65223D3D3D742E6E616D657D292E677075416363';
wwv_flow_api.g_varchar2_table(173) := '656C65726174696F6E3B766F69642030213D3D692626636F6E736F6C652E7761726E28225741524E494E473A2060677075416363656C65726174696F6E60206F7074696F6E206D6F76656420746F2060636F6D707574655374796C6560206D6F64696669';
wwv_flow_api.g_varchar2_table(174) := '657220616E642077696C6C206E6F7420626520737570706F7274656420696E206675747572652076657273696F6E73206F6620506F707065722E6A732122293B76617220612C702C732C6C2C632C662C642C752C6D2C682C622C762C792C672C773D766F';
wwv_flow_api.g_varchar2_table(175) := '69642030213D3D693F693A652E677075416363656C65726174696F6E2C783D5828742E696E7374616E63652E706F70706572292C6B3D532878292C453D7B706F736974696F6E3A6F2E706F736974696F6E7D2C4F3D28613D742C703D77696E646F772E64';
wwv_flow_api.g_varchar2_table(176) := '6576696365506978656C526174696F3C327C7C214A2C733D612E6F6666736574732C6C3D732E706F707065722C633D732E7265666572656E63652C663D4D6174682E726F756E642C643D4D6174682E666C6F6F722C753D66756E6374696F6E2874297B72';
wwv_flow_api.g_varchar2_table(177) := '657475726E20747D2C6D3D66286C2E7769647468292C683D6628632E7769647468292C623D2D31213D3D5B226C656674222C227269676874225D2E696E6465784F6628612E706C6163656D656E74292C763D2D31213D3D612E706C6163656D656E742E69';
wwv_flow_api.g_varchar2_table(178) := '6E6465784F6628222D22292C673D703F663A752C7B6C6566743A28793D703F627C7C767C7C6825323D3D6D25323F663A643A7529286825323D3D3126266D25323D3D31262621762626703F6C2E6C6566742D313A6C2E6C656674292C746F703A67286C2E';
wwv_flow_api.g_varchar2_table(179) := '746F70292C626F74746F6D3A67286C2E626F74746F6D292C72696768743A79286C2E7269676874297D292C543D22626F74746F6D223D3D3D723F22746F70223A22626F74746F6D222C4C3D227269676874223D3D3D6E3F226C656674223A227269676874';
wwv_flow_api.g_varchar2_table(180) := '222C433D5228227472616E73666F726D22292C413D766F696420302C593D766F696420303B696628593D22626F74746F6D223D3D3D543F2248544D4C223D3D3D782E6E6F64654E616D653F2D782E636C69656E744865696768742B4F2E626F74746F6D3A';
wwv_flow_api.g_varchar2_table(181) := '2D6B2E6865696768742B4F2E626F74746F6D3A4F2E746F702C413D227269676874223D3D3D4C3F2248544D4C223D3D3D782E6E6F64654E616D653F2D782E636C69656E7457696474682B4F2E72696768743A2D6B2E77696474682B4F2E72696768743A4F';
wwv_flow_api.g_varchar2_table(182) := '2E6C6566742C7726264329455B435D3D227472616E736C617465336428222B412B2270782C20222B592B2270782C203029222C455B545D3D302C455B4C5D3D302C452E77696C6C4368616E67653D227472616E73666F726D223B656C73657B7661722044';
wwv_flow_api.g_varchar2_table(183) := '3D22626F74746F6D223D3D3D543F2D313A312C4D3D227269676874223D3D3D4C3F2D313A313B455B545D3D592A442C455B4C5D3D412A4D2C452E77696C6C4368616E67653D542B222C20222B4C7D76617220503D7B22782D706C6163656D656E74223A74';
wwv_flow_api.g_varchar2_table(184) := '2E706C6163656D656E747D3B72657475726E20742E617474726962757465733D4E287B7D2C502C742E61747472696275746573292C742E7374796C65733D4E287B7D2C452C742E7374796C6573292C742E6172726F775374796C65733D4E287B7D2C742E';
wwv_flow_api.g_varchar2_table(185) := '6F6666736574732E6172726F772C742E6172726F775374796C6573292C747D2C677075416363656C65726174696F6E3A21302C783A22626F74746F6D222C793A227269676874227D2C6170706C795374796C653A7B6F726465723A3930302C656E61626C';
wwv_flow_api.g_varchar2_table(186) := '65643A21302C666E3A66756E6374696F6E2874297B76617220652C723B72657475726E204B28742E696E7374616E63652E706F707065722C742E7374796C6573292C653D742E696E7374616E63652E706F707065722C723D742E61747472696275746573';
wwv_flow_api.g_varchar2_table(187) := '2C4F626A6563742E6B6579732872292E666F72456163682866756E6374696F6E2874297B2131213D3D725B745D3F652E73657441747472696275746528742C725B745D293A652E72656D6F76654174747269627574652874297D292C742E6172726F7745';
wwv_flow_api.g_varchar2_table(188) := '6C656D656E7426264F626A6563742E6B65797328742E6172726F775374796C6573292E6C656E67746826264B28742E6172726F77456C656D656E742C742E6172726F775374796C6573292C747D2C6F6E4C6F61643A66756E6374696F6E28742C652C722C';
wwv_flow_api.g_varchar2_table(189) := '6E2C6F297B76617220693D44286F2C652C742C722E706F736974696F6E4669786564292C613D5928722E706C6163656D656E742C692C652C742C722E6D6F646966696572732E666C69702E626F756E646172696573456C656D656E742C722E6D6F646966';
wwv_flow_api.g_varchar2_table(190) := '696572732E666C69702E70616464696E67293B72657475726E20652E7365744174747269627574652822782D706C6163656D656E74222C61292C4B28652C7B706F736974696F6E3A722E706F736974696F6E46697865643F226669786564223A22616273';
wwv_flow_api.g_varchar2_table(191) := '6F6C757465227D292C727D2C677075416363656C65726174696F6E3A766F696420307D7D7D2C61743D66756E6374696F6E28297B66756E6374696F6E206928742C65297B76617220723D746869732C6E3D323C617267756D656E74732E6C656E67746826';
wwv_flow_api.g_varchar2_table(192) := '26766F69642030213D3D617267756D656E74735B325D3F617267756D656E74735B325D3A7B7D3B2166756E6374696F6E28742C65297B69662821287420696E7374616E63656F66206529297468726F77206E657720547970654572726F72282243616E6E';
wwv_flow_api.g_varchar2_table(193) := '6F742063616C6C206120636C61737320617320612066756E6374696F6E22297D28746869732C69292C746869732E7363686564756C655570646174653D66756E6374696F6E28297B72657475726E2072657175657374416E696D6174696F6E4672616D65';
wwv_flow_api.g_varchar2_table(194) := '28722E757064617465297D2C746869732E7570646174653D6C28746869732E7570646174652E62696E64287468697329292C746869732E6F7074696F6E733D4E287B7D2C692E44656661756C74732C6E292C746869732E73746174653D7B697344657374';
wwv_flow_api.g_varchar2_table(195) := '726F7965643A21312C6973437265617465643A21312C7363726F6C6C506172656E74733A5B5D7D2C746869732E7265666572656E63653D742626742E6A71756572793F745B305D3A742C746869732E706F707065723D652626652E6A71756572793F655B';
wwv_flow_api.g_varchar2_table(196) := '305D3A652C746869732E6F7074696F6E732E6D6F646966696572733D7B7D2C4F626A6563742E6B657973284E287B7D2C692E44656661756C74732E6D6F646966696572732C6E2E6D6F6469666965727329292E666F72456163682866756E6374696F6E28';
wwv_flow_api.g_varchar2_table(197) := '74297B722E6F7074696F6E732E6D6F646966696572735B745D3D4E287B7D2C692E44656661756C74732E6D6F646966696572735B745D7C7C7B7D2C6E2E6D6F646966696572733F6E2E6D6F646966696572735B745D3A7B7D297D292C746869732E6D6F64';
wwv_flow_api.g_varchar2_table(198) := '6966696572733D4F626A6563742E6B65797328746869732E6F7074696F6E732E6D6F64696669657273292E6D61702866756E6374696F6E2874297B72657475726E204E287B6E616D653A747D2C722E6F7074696F6E732E6D6F646966696572735B745D29';
wwv_flow_api.g_varchar2_table(199) := '7D292E736F72742866756E6374696F6E28742C65297B72657475726E20742E6F726465722D652E6F726465727D292C746869732E6D6F646966696572732E666F72456163682866756E6374696F6E2874297B742E656E61626C656426266328742E6F6E4C';
wwv_flow_api.g_varchar2_table(200) := '6F6164292626742E6F6E4C6F616428722E7265666572656E63652C722E706F707065722C722E6F7074696F6E732C742C722E7374617465297D292C746869732E75706461746528293B766172206F3D746869732E6F7074696F6E732E6576656E7473456E';
wwv_flow_api.g_varchar2_table(201) := '61626C65643B6F2626746869732E656E61626C654576656E744C697374656E65727328292C746869732E73746174652E6576656E7473456E61626C65643D6F7D72657475726E204528692C5B7B6B65793A22757064617465222C76616C75653A66756E63';
wwv_flow_api.g_varchar2_table(202) := '74696F6E28297B72657475726E2066756E6374696F6E28297B69662821746869732E73746174652E697344657374726F796564297B76617220743D7B696E7374616E63653A746869732C7374796C65733A7B7D2C6172726F775374796C65733A7B7D2C61';
wwv_flow_api.g_varchar2_table(203) := '7474726962757465733A7B7D2C666C69707065643A21312C6F6666736574733A7B7D7D3B742E6F6666736574732E7265666572656E63653D4428746869732E73746174652C746869732E706F707065722C746869732E7265666572656E63652C74686973';
wwv_flow_api.g_varchar2_table(204) := '2E6F7074696F6E732E706F736974696F6E4669786564292C742E706C6163656D656E743D5928746869732E6F7074696F6E732E706C6163656D656E742C742E6F6666736574732E7265666572656E63652C746869732E706F707065722C746869732E7265';
wwv_flow_api.g_varchar2_table(205) := '666572656E63652C746869732E6F7074696F6E732E6D6F646966696572732E666C69702E626F756E646172696573456C656D656E742C746869732E6F7074696F6E732E6D6F646966696572732E666C69702E70616464696E67292C742E6F726967696E61';
wwv_flow_api.g_varchar2_table(206) := '6C506C6163656D656E743D742E706C6163656D656E742C742E706F736974696F6E46697865643D746869732E6F7074696F6E732E706F736974696F6E46697865642C742E6F6666736574732E706F707065723D4928746869732E706F707065722C742E6F';
wwv_flow_api.g_varchar2_table(207) := '6666736574732E7265666572656E63652C742E706C6163656D656E74292C742E6F6666736574732E706F707065722E706F736974696F6E3D746869732E6F7074696F6E732E706F736974696F6E46697865643F226669786564223A226162736F6C757465';
wwv_flow_api.g_varchar2_table(208) := '222C743D4628746869732E6D6F646966696572732C74292C746869732E73746174652E6973437265617465643F746869732E6F7074696F6E732E6F6E5570646174652874293A28746869732E73746174652E6973437265617465643D21302C746869732E';
wwv_flow_api.g_varchar2_table(209) := '6F7074696F6E732E6F6E437265617465287429297D7D2E63616C6C2874686973297D7D2C7B6B65793A2264657374726F79222C76616C75653A66756E6374696F6E28297B72657475726E2066756E6374696F6E28297B72657475726E20746869732E7374';
wwv_flow_api.g_varchar2_table(210) := '6174652E697344657374726F7965643D21302C4228746869732E6D6F646966696572732C226170706C795374796C652229262628746869732E706F707065722E72656D6F76654174747269627574652822782D706C6163656D656E7422292C746869732E';
wwv_flow_api.g_varchar2_table(211) := '706F707065722E7374796C652E706F736974696F6E3D22222C746869732E706F707065722E7374796C652E746F703D22222C746869732E706F707065722E7374796C652E6C6566743D22222C746869732E706F707065722E7374796C652E72696768743D';
wwv_flow_api.g_varchar2_table(212) := '22222C746869732E706F707065722E7374796C652E626F74746F6D3D22222C746869732E706F707065722E7374796C652E77696C6C4368616E67653D22222C746869732E706F707065722E7374796C655B5228227472616E73666F726D22295D3D222229';
wwv_flow_api.g_varchar2_table(213) := '2C746869732E64697361626C654576656E744C697374656E65727328292C746869732E6F7074696F6E732E72656D6F76654F6E44657374726F792626746869732E706F707065722E706172656E744E6F64652E72656D6F76654368696C6428746869732E';
wwv_flow_api.g_varchar2_table(214) := '706F70706572292C746869737D2E63616C6C2874686973297D7D2C7B6B65793A22656E61626C654576656E744C697374656E657273222C76616C75653A66756E6374696F6E28297B72657475726E2066756E6374696F6E28297B746869732E7374617465';
wwv_flow_api.g_varchar2_table(215) := '2E6576656E7473456E61626C65647C7C28746869732E73746174653D7A28746869732E7265666572656E63652C746869732E6F7074696F6E732C746869732E73746174652C746869732E7363686564756C6555706461746529297D2E63616C6C28746869';
wwv_flow_api.g_varchar2_table(216) := '73297D7D2C7B6B65793A2264697361626C654576656E744C697374656E657273222C76616C75653A66756E6374696F6E28297B72657475726E20712E63616C6C2874686973297D7D5D292C697D28293B61742E5574696C733D2822756E646566696E6564';
wwv_flow_api.g_varchar2_table(217) := '22213D747970656F662077696E646F773F77696E646F773A676C6F62616C292E506F707065725574696C732C61742E706C6163656D656E74733D5A2C61742E44656661756C74733D69743B7661722070743D7B504F505045523A222E74697070792D706F';
wwv_flow_api.g_varchar2_table(218) := '70706572222C544F4F4C5449503A222E74697070792D746F6F6C746970222C434F4E54454E543A222E74697070792D636F6E74656E74222C4241434B44524F503A222E74697070792D6261636B64726F70222C4152524F573A222E74697070792D617272';
wwv_flow_api.g_varchar2_table(219) := '6F77222C524F554E445F4152524F573A222E74697070792D726F756E646172726F77227D2C73743D743F456C656D656E742E70726F746F747970653A7B7D2C6C743D73742E6D6174636865737C7C73742E6D61746368657353656C6563746F727C7C7374';
wwv_flow_api.g_varchar2_table(220) := '2E7765626B69744D61746368657353656C6563746F727C7C73742E6D6F7A4D61746368657353656C6563746F727C7C73742E6D734D61746368657353656C6563746F723B66756E6374696F6E2063742874297B72657475726E5B5D2E736C6963652E6361';
wwv_flow_api.g_varchar2_table(221) := '6C6C2874297D66756E6374696F6E20667428742C65297B72657475726E2873742E636C6F736573747C7C66756E6374696F6E2874297B666F722876617220653D746869733B653B297B6966286C742E63616C6C28652C74292972657475726E20653B653D';
wwv_flow_api.g_varchar2_table(222) := '652E706172656E74456C656D656E747D7D292E63616C6C28742C65297D66756E6374696F6E20647428742C65297B666F72283B743B297B696628652874292972657475726E20743B743D742E706172656E74456C656D656E747D7D7661722075743D7B70';
wwv_flow_api.g_varchar2_table(223) := '6173736976653A21307D2C6D743D7B783A21307D3B66756E6374696F6E20687428297B72657475726E20646F63756D656E742E637265617465456C656D656E74282264697622297D66756E6374696F6E20627428742C65297B745B6D742E78262622696E';
wwv_flow_api.g_varchar2_table(224) := '6E657248544D4C225D3D6520696E7374616E63656F6620456C656D656E743F655B6D742E78262622696E6E657248544D4C225D3A657D66756E6374696F6E20767428742C65297B652E636F6E74656E7420696E7374616E63656F6620456C656D656E743F';
wwv_flow_api.g_varchar2_table(225) := '28627428742C2222292C742E617070656E644368696C6428652E636F6E74656E7429293A745B652E616C6C6F7748544D4C3F22696E6E657248544D4C223A2274657874436F6E74656E74225D3D652E636F6E74656E747D66756E6374696F6E2079742874';
wwv_flow_api.g_varchar2_table(226) := '297B72657475726E7B746F6F6C7469703A742E717565727953656C6563746F722870742E544F4F4C544950292C6261636B64726F703A742E717565727953656C6563746F722870742E4241434B44524F50292C636F6E74656E743A742E71756572795365';
wwv_flow_api.g_varchar2_table(227) := '6C6563746F722870742E434F4E54454E54292C6172726F773A742E717565727953656C6563746F722870742E4152524F57297C7C742E717565727953656C6563746F722870742E524F554E445F4152524F57297D7D66756E6374696F6E2067742874297B';
wwv_flow_api.g_varchar2_table(228) := '742E7365744174747269627574652822646174612D696E6572746961222C2222297D66756E6374696F6E2077742874297B76617220653D687428293B72657475726E22726F756E64223D3D3D743F28652E636C6173734E616D653D2274697070792D726F';
wwv_flow_api.g_varchar2_table(229) := '756E646172726F77222C627428652C273C7376672076696577426F783D2230203020323420382220786D6C6E733D22687474703A2F2F7777772E77332E6F72672F323030302F737667223E3C7061746820643D224D33203873322E3032312D2E30313520';
wwv_flow_api.g_varchar2_table(230) := '352E3235332D342E32313843392E35383420322E3035312031302E37393720312E303037203132203163312E3230332D2E30303720322E34313620312E30333520332E37363120322E3738324331392E30313220382E3030352032312038203231203848';
wwv_flow_api.g_varchar2_table(231) := '337A222F3E3C2F7376673E2729293A652E636C6173734E616D653D2274697070792D6172726F77222C657D66756E6374696F6E20787428297B76617220743D687428293B72657475726E20742E636C6173734E616D653D2274697070792D6261636B6472';
wwv_flow_api.g_varchar2_table(232) := '6F70222C742E7365744174747269627574652822646174612D7374617465222C2268696464656E22292C747D66756E6374696F6E206B7428742C65297B742E7365744174747269627574652822746162696E646578222C222D3122292C652E7365744174';
wwv_flow_api.g_varchar2_table(233) := '747269627574652822646174612D696E746572616374697665222C2222297D66756E6374696F6E20457428742C65297B742E666F72456163682866756E6374696F6E2874297B74262628742E7374796C652E7472616E736974696F6E4475726174696F6E';
wwv_flow_api.g_varchar2_table(234) := '3D652B226D7322297D297D66756E6374696F6E204F7428742C652C72297B745B652B224576656E744C697374656E6572225D28227472616E736974696F6E656E64222C72297D66756E6374696F6E2054742874297B76617220653D742E67657441747472';
wwv_flow_api.g_varchar2_table(235) := '69627574652822782D706C6163656D656E7422293B72657475726E20653F652E73706C697428222D22295B305D3A22227D66756E6374696F6E204C7428742C65297B742E666F72456163682866756E6374696F6E2874297B742626742E73657441747472';
wwv_flow_api.g_varchar2_table(236) := '69627574652822646174612D7374617465222C65297D297D66756E6374696F6E2043742872297B637428646F63756D656E742E717565727953656C6563746F72416C6C2870742E504F5050455229292E666F72456163682866756E6374696F6E2874297B';
wwv_flow_api.g_varchar2_table(237) := '76617220653D742E5F74697070793B21657C7C2130213D3D652E70726F70732E686964654F6E436C69636B7C7C722626743D3D3D722E706F707065727C7C652E6869646528297D297D66756E6374696F6E20417428742C652C722C6E297B696628217429';
wwv_flow_api.g_varchar2_table(238) := '72657475726E21303B766172206F3D722E636C69656E74582C693D722E636C69656E74592C613D6E2E696E746572616374697665426F726465722C703D6E2E64697374616E63652C733D652E746F702D693E2822746F70223D3D3D743F612B703A61292C';
wwv_flow_api.g_varchar2_table(239) := '6C3D692D652E626F74746F6D3E2822626F74746F6D223D3D3D743F612B703A61292C633D652E6C6566742D6F3E28226C656674223D3D3D743F612B703A61292C663D6F2D652E72696768743E28227269676874223D3D3D743F612B703A61293B72657475';
wwv_flow_api.g_varchar2_table(240) := '726E20737C7C6C7C7C637C7C667D66756E6374696F6E20597428742C65297B72657475726E2D28742D65292B227078227D66756E6374696F6E2044742874297B72657475726E225B6F626A656374204F626A6563745D223D3D3D7B7D2E746F537472696E';
wwv_flow_api.g_varchar2_table(241) := '672E63616C6C2874297D66756E6374696F6E204D7428742C65297B72657475726E7B7D2E6861734F776E50726F70657274792E63616C6C28742C65297D66756E6374696F6E20507428742C652C72297B69662841727261792E6973417272617928742929';
wwv_flow_api.g_varchar2_table(242) := '7B766172206E3D745B655D3B72657475726E206E756C6C3D3D6E3F723A6E7D72657475726E20747D66756E6374696F6E2058742874297B76617220653D77696E646F772E7363726F6C6C587C7C77696E646F772E70616765584F66667365742C723D7769';
wwv_flow_api.g_varchar2_table(243) := '6E646F772E7363726F6C6C597C7C77696E646F772E70616765594F66667365743B742E666F63757328292C7363726F6C6C28652C72297D66756E6374696F6E204E7428722C6E297B766172206F3D766F696420303B72657475726E2066756E6374696F6E';
wwv_flow_api.g_varchar2_table(244) := '28297B76617220743D746869732C653D617267756D656E74733B636C65617254696D656F7574286F292C6F3D73657454696D656F75742866756E6374696F6E28297B72657475726E20722E6170706C7928742C65297D2C6E297D7D66756E6374696F6E20';
wwv_flow_api.g_varchar2_table(245) := '537428742C65297B72657475726E20742626742E6D6F646966696572732626742E6D6F646966696572735B655D7D66756E6374696F6E20497428742C65297B72657475726E2D313C742E696E6465784F662865297D7661722048743D21313B66756E6374';
wwv_flow_api.g_varchar2_table(246) := '696F6E20467428297B48747C7C2848743D21302C6F2626646F63756D656E742E626F64792E636C6173734C6973742E616464282274697070792D694F5322292C77696E646F772E706572666F726D616E63652626646F63756D656E742E6164644576656E';
wwv_flow_api.g_varchar2_table(247) := '744C697374656E657228226D6F7573656D6F7665222C527429297D7661722042743D303B66756E6374696F6E20527428297B76617220743D706572666F726D616E63652E6E6F7728293B742D42743C323026262848743D21312C646F63756D656E742E72';
wwv_flow_api.g_varchar2_table(248) := '656D6F76654576656E744C697374656E657228226D6F7573656D6F7665222C5274292C6F7C7C646F63756D656E742E626F64792E636C6173734C6973742E72656D6F7665282274697070792D694F532229292C42743D747D66756E6374696F6E20577428';
wwv_flow_api.g_varchar2_table(249) := '74297B76617220653D742E7461726765743B69662821286520696E7374616E63656F6620456C656D656E74292972657475726E20437428293B76617220723D667428652C70742E504F50504552293B6966282128722626722E5F74697070792626722E5F';
wwv_flow_api.g_varchar2_table(250) := '74697070792E70726F70732E696E74657261637469766529297B766172206E3D647428652C66756E6374696F6E2874297B72657475726E20742E5F74697070792626742E5F74697070792E7265666572656E63653D3D3D747D293B6966286E297B766172';
wwv_flow_api.g_varchar2_table(251) := '206F3D6E2E5F74697070792C693D4974286F2E70726F70732E747269676765722C22636C69636B22293B69662848747C7C692972657475726E204374286F293B6966282130213D3D6F2E70726F70732E686964654F6E436C69636B7C7C69297265747572';
wwv_flow_api.g_varchar2_table(252) := '6E3B6F2E636C65617244656C617954696D656F75747328297D437428297D7D66756E6374696F6E207A7428297B76617220743D646F63756D656E742E616374697665456C656D656E743B742626742E626C75722626742E5F74697070792626742E626C75';
wwv_flow_api.g_varchar2_table(253) := '7228297D66756E6374696F6E205F7428297B637428646F63756D656E742E717565727953656C6563746F72416C6C2870742E504F5050455229292E666F72456163682866756E6374696F6E2874297B76617220653D742E5F74697070793B652E70726F70';
wwv_flow_api.g_varchar2_table(254) := '732E6C697665506C6163656D656E747C7C652E706F70706572496E7374616E63652E7363686564756C6555706461746528297D297D766172206A743D4F626A6563742E6B6579732856293B66756E6374696F6E205674286F297B72657475726E206A742E';
wwv_flow_api.g_varchar2_table(255) := '7265647563652866756E6374696F6E28742C65297B76617220722C6E3D286F2E6765744174747269627574652822646174612D74697070792D222B65297C7C2222292E7472696D28293B72657475726E206E26262822636F6E74656E74223D3D3D653F74';
wwv_flow_api.g_varchar2_table(256) := '5B655D3D6E3A2274727565223D3D3D6E3F745B655D3D21303A2266616C7365223D3D3D6E3F745B655D3D21313A28723D6E2C69734E614E2872297C7C69734E614E287061727365466C6F6174287229293F225B223D3D3D6E5B305D7C7C227B223D3D3D6E';
wwv_flow_api.g_varchar2_table(257) := '5B305D3F745B655D3D4A534F4E2E7061727365286E293A745B655D3D6E3A745B655D3D4E756D626572286E2929292C747D2C7B7D297D7661722055743D4F626A6563742E61737369676E7C7C66756E6374696F6E2874297B666F722876617220653D313B';
wwv_flow_api.g_varchar2_table(258) := '653C617267756D656E74732E6C656E6774683B652B2B297B76617220723D617267756D656E74735B655D3B666F7228766172206E20696E2072294F626A6563742E70726F746F747970652E6861734F776E50726F70657274792E63616C6C28722C6E2926';
wwv_flow_api.g_varchar2_table(259) := '2628745B6E5D3D725B6E5D297D72657475726E20747D3B66756E6374696F6E20717428742C65297B76617220723D5574287B7D2C652C652E706572666F726D616E63653F7B7D3A5674287429293B72657475726E20722E6172726F77262628722E616E69';
wwv_flow_api.g_varchar2_table(260) := '6D61746546696C6C3D2131292C2266756E6374696F6E223D3D747970656F6620722E617070656E64546F262628722E617070656E64546F3D652E617070656E64546F287429292C2266756E6374696F6E223D3D747970656F6620722E636F6E74656E7426';
wwv_flow_api.g_varchar2_table(261) := '2628722E636F6E74656E743D652E636F6E74656E74287429292C727D66756E6374696F6E20477428297B76617220743D303C617267756D656E74732E6C656E6774682626766F69642030213D3D617267756D656E74735B305D3F617267756D656E74735B';
wwv_flow_api.g_varchar2_table(262) := '305D3A7B7D2C653D617267756D656E74735B315D3B4F626A6563742E6B6579732874292E666F72456163682866756E6374696F6E2874297B696628214D7428652C7429297468726F77206E6577204572726F7228225B74697070795D3A2060222B742B22';
wwv_flow_api.g_varchar2_table(263) := '60206973206E6F7420612076616C6964206F7074696F6E22297D297D766172204B743D7B7472616E736C6174653A2F7472616E736C617465583F593F5C28285B5E295D2B295C292F2C7363616C653A2F7363616C65583F593F5C28285B5E295D2B295C29';
wwv_flow_api.g_varchar2_table(264) := '2F7D3B66756E6374696F6E204A7428742C65297B72657475726E28653F743A7B583A2259222C593A2258227D5B745D297C7C22227D66756E6374696F6E20517428742C652C722C6E297B766172206F3D655B305D2C693D655B315D3B72657475726E206F';
wwv_flow_api.g_varchar2_table(265) := '7C7C693F7B7363616C653A693F723F6F2B222C20222B693A692B222C20222B6F3A22222B6F2C7472616E736C6174653A693F723F6E3F6F2B2270782C20222B2D692B227078223A6F2B2270782C20222B692B227078223A6E3F2D692B2270782C20222B6F';
wwv_flow_api.g_varchar2_table(266) := '2B227078223A692B2270782C20222B6F2B227078223A6E3F2D6F2B227078223A6F2B227078227D5B745D3A22227D66756E6374696F6E205A7428742C65297B76617220723D742E6D61746368286E65772052656745787028652B22285B58595D29222929';
wwv_flow_api.g_varchar2_table(267) := '3B72657475726E20723F725B315D3A22227D66756E6374696F6E20247428742C65297B76617220723D742E6D617463682865293B72657475726E20723F725B315D2E73706C697428222C22292E6D61702866756E6374696F6E2874297B72657475726E20';
wwv_flow_api.g_varchar2_table(268) := '7061727365466C6F617428742C3130297D293A5B5D7D66756E6374696F6E20746528742C65297B76617220723D547428667428742C70742E504F5050455229292C6E3D4974285B22746F70222C22626F74746F6D225D2C72292C6F3D4974285B22726967';
wwv_flow_api.g_varchar2_table(269) := '6874222C22626F74746F6D225D2C72292C693D7B7472616E736C6174653A7B617869733A5A7428652C227472616E736C61746522292C6E756D626572733A247428652C4B742E7472616E736C617465297D2C7363616C653A7B617869733A5A7428652C22';
wwv_flow_api.g_varchar2_table(270) := '7363616C6522292C6E756D626572733A247428652C4B742E7363616C65297D7D2C613D652E7265706C616365284B742E7472616E736C6174652C227472616E736C617465222B4A7428692E7472616E736C6174652E617869732C6E292B2228222B517428';
wwv_flow_api.g_varchar2_table(271) := '227472616E736C617465222C692E7472616E736C6174652E6E756D626572732C6E2C6F292B222922292E7265706C616365284B742E7363616C652C227363616C65222B4A7428692E7363616C652E617869732C6E292B2228222B517428227363616C6522';
wwv_flow_api.g_varchar2_table(272) := '2C692E7363616C652E6E756D626572732C6E2C6F292B222922293B742E7374796C655B766F69642030213D3D646F63756D656E742E626F64792E7374796C652E7472616E73666F726D3F227472616E73666F726D223A227765626B69745472616E73666F';
wwv_flow_api.g_varchar2_table(273) := '726D225D3D617D7661722065653D313B66756E6374696F6E20726528742C65297B76617220723D717428742C65293B69662821722E6D756C7469706C652626742E5F74697070792972657475726E206E756C6C3B766172206C3D6E756C6C2C633D7B7D2C';
wwv_flow_api.g_varchar2_table(274) := '6D3D6E756C6C2C6F3D302C6E3D302C693D21312C613D66756E6374696F6E28297B7D2C703D5B5D2C733D21312C643D303C722E696E7465726163746976654465626F756E63653F4E7428542C722E696E7465726163746976654465626F756E6365293A54';
wwv_flow_api.g_varchar2_table(275) := '2C663D65652B2B2C753D66756E6374696F6E28742C65297B76617220723D687428293B722E636C6173734E616D653D2274697070792D706F70706572222C722E7365744174747269627574652822726F6C65222C22746F6F6C74697022292C722E69643D';
wwv_flow_api.g_varchar2_table(276) := '2274697070792D222B742C722E7374796C652E7A496E6465783D652E7A496E6465783B766172206E3D687428293B6E2E636C6173734E616D653D2274697070792D746F6F6C746970222C6E2E7374796C652E6D617857696474683D652E6D617857696474';
wwv_flow_api.g_varchar2_table(277) := '682B28226E756D626572223D3D747970656F6620652E6D617857696474683F227078223A2222292C6E2E7365744174747269627574652822646174612D73697A65222C652E73697A65292C6E2E7365744174747269627574652822646174612D616E696D';
wwv_flow_api.g_varchar2_table(278) := '6174696F6E222C652E616E696D6174696F6E292C6E2E7365744174747269627574652822646174612D7374617465222C2268696464656E22292C652E7468656D652E73706C697428222022292E666F72456163682866756E6374696F6E2874297B6E2E63';
wwv_flow_api.g_varchar2_table(279) := '6C6173734C6973742E61646428742B222D7468656D6522297D293B766172206F3D687428293B72657475726E206F2E636C6173734E616D653D2274697070792D636F6E74656E74222C6F2E7365744174747269627574652822646174612D737461746522';
wwv_flow_api.g_varchar2_table(280) := '2C2268696464656E22292C652E696E74657261637469766526266B7428722C6E292C652E6172726F7726266E2E617070656E644368696C6428777428652E6172726F775479706529292C652E616E696D61746546696C6C2626286E2E617070656E644368';
wwv_flow_api.g_varchar2_table(281) := '696C642878742829292C6E2E7365744174747269627574652822646174612D616E696D61746566696C6C222C222229292C652E696E657274696126266774286E292C7674286F2C65292C6E2E617070656E644368696C64286F292C722E617070656E6443';
wwv_flow_api.g_varchar2_table(282) := '68696C64286E292C722E6164644576656E744C697374656E65722822666F6375736F7574222C66756E6374696F6E2874297B742E72656C617465645461726765742626722E5F7469707079262621647428742E72656C617465645461726765742C66756E';
wwv_flow_api.g_varchar2_table(283) := '6374696F6E2874297B72657475726E20743D3D3D727D292626742E72656C61746564546172676574213D3D722E5F74697070792E7265666572656E63652626722E5F74697070792E70726F70732E73686F756C64506F70706572486964654F6E426C7572';
wwv_flow_api.g_varchar2_table(284) := '2874292626722E5F74697070792E6869646528297D292C727D28662C72293B752E6164644576656E744C697374656E657228226D6F757365656E746572222C66756E6374696F6E2874297B762E70726F70732E696E7465726163746976652626762E7374';
wwv_flow_api.g_varchar2_table(285) := '6174652E697356697369626C652626226D6F757365656E746572223D3D3D632E747970652626772874297D292C752E6164644576656E744C697374656E657228226D6F7573656C65617665222C66756E6374696F6E2874297B762E70726F70732E696E74';
wwv_flow_api.g_varchar2_table(286) := '65726163746976652626226D6F757365656E746572223D3D3D632E747970652626303D3D3D762E70726F70732E696E7465726163746976654465626F756E6365262641742854742875292C752E676574426F756E64696E67436C69656E74526563742829';
wwv_flow_api.g_varchar2_table(287) := '2C742C762E70726F70732926267828297D293B76617220682C623D79742875292C763D7B69643A662C7265666572656E63653A742C706F707065723A752C706F707065724368696C6472656E3A622C706F70706572496E7374616E63653A6E756C6C2C70';
wwv_flow_api.g_varchar2_table(288) := '726F70733A722C73746174653A7B6973456E61626C65643A21302C697356697369626C653A21312C697344657374726F7965643A21312C69734D6F756E7465643A21312C697353686F776E3A21317D2C636C65617244656C617954696D656F7574733A46';
wwv_flow_api.g_varchar2_table(289) := '2C7365743A422C736574436F6E74656E743A66756E6374696F6E2874297B42287B636F6E74656E743A747D297D2C73686F773A522C686964653A572C656E61626C653A66756E6374696F6E28297B762E73746174652E6973456E61626C65643D21307D2C';
wwv_flow_api.g_varchar2_table(290) := '64697361626C653A66756E6374696F6E28297B762E73746174652E6973456E61626C65643D21317D2C64657374726F793A7A7D3B72657475726E204928292C742E6164644576656E744C697374656E65722822636C69636B222C79292C722E6C617A797C';
wwv_flow_api.g_varchar2_table(291) := '7C28762E706F70706572496E7374616E63653D4D28292C762E706F70706572496E7374616E63652E64697361626C654576656E744C697374656E6572732829292C722E73686F774F6E496E697426267728292C722E61313179262621722E746172676574';
wwv_flow_api.g_varchar2_table(292) := '26262828683D7429696E7374616E63656F6620456C656D656E74262628216C742E63616C6C28682C22615B687265665D2C617265615B687265665D2C627574746F6E2C64657461696C732C696E7075742C74657874617265612C73656C6563742C696672';
wwv_flow_api.g_varchar2_table(293) := '616D652C5B746162696E6465785D22297C7C682E686173417474726962757465282264697361626C6564222929292626742E7365744174747269627574652822746162696E646578222C223022292C742E5F74697070793D762C752E5F74697070793D76';
wwv_flow_api.g_varchar2_table(294) := '3B66756E6374696F6E207928297B73657454696D656F75742866756E6374696F6E28297B733D21317D2C31297D66756E6374696F6E20672874297B76617220653D6D3D742C723D652E636C69656E74582C6E3D652E636C69656E74593B696628762E706F';
wwv_flow_api.g_varchar2_table(295) := '70706572496E7374616E6365297B766172206F3D547428762E706F70706572292C693D762E706F707065724368696C6472656E2E6172726F773F32303A352C613D4974285B22746F70222C22626F74746F6D225D2C6F292C703D4974285B226C65667422';
wwv_flow_api.g_varchar2_table(296) := '2C227269676874225D2C6F292C733D613F4D6174682E6D617828692C72293A722C6C3D703F4D6174682E6D617828692C6E293A6E3B612626693C73262628733D4D6174682E6D696E28722C77696E646F772E696E6E657257696474682D6929292C702626';
wwv_flow_api.g_varchar2_table(297) := '693C6C2626286C3D4D6174682E6D696E286E2C77696E646F772E696E6E65724865696768742D6929293B76617220633D762E7265666572656E63652E676574426F756E64696E67436C69656E745265637428292C663D762E70726F70732E666F6C6C6F77';
wwv_flow_api.g_varchar2_table(298) := '437572736F722C643D22686F72697A6F6E74616C223D3D3D662C753D22766572746963616C223D3D3D663B762E706F70706572496E7374616E63652E7265666572656E63653D7B676574426F756E64696E67436C69656E74526563743A66756E6374696F';
wwv_flow_api.g_varchar2_table(299) := '6E28297B72657475726E7B77696474683A302C6865696768743A302C746F703A643F632E746F703A6C2C626F74746F6D3A643F632E626F74746F6D3A6C2C6C6566743A753F632E6C6566743A732C72696768743A753F632E72696768743A737D7D2C636C';
wwv_flow_api.g_varchar2_table(300) := '69656E7457696474683A302C636C69656E744865696768743A307D2C762E706F70706572496E7374616E63652E7363686564756C6555706461746528292C22696E697469616C223D3D3D662626762E73746174652E697356697369626C6526266B28297D';
wwv_flow_api.g_varchar2_table(301) := '7D66756E6374696F6E20772874297B6966284628292C21762E73746174652E697356697369626C6529696628762E70726F70732E7461726765742928723D66742828653D74292E7461726765742C762E70726F70732E7461726765742929262621722E5F';
wwv_flow_api.g_varchar2_table(302) := '7469707079262628726528722C5574287B7D2C762E70726F70732C7B7461726765743A22222C73686F774F6E496E69743A21307D29292C77286529293B656C73657B76617220652C723B696628693D21302C762E70726F70732E77616974297265747572';
wwv_flow_api.g_varchar2_table(303) := '6E20762E70726F70732E7761697428762C74293B582829262621762E73746174652E69734D6F756E7465642626646F63756D656E742E6164644576656E744C697374656E657228226D6F7573656D6F7665222C67293B766172206E3D507428762E70726F';
wwv_flow_api.g_varchar2_table(304) := '70732E64656C61792C302C562E64656C6179293B6E3F6F3D73657454696D656F75742866756E6374696F6E28297B5228297D2C6E293A5228297D7D66756E6374696F6E207828297B6966284628292C21762E73746174652E697356697369626C65297265';
wwv_flow_api.g_varchar2_table(305) := '7475726E206B28293B693D21313B76617220743D507428762E70726F70732E64656C61792C312C562E64656C6179293B743F6E3D73657454696D656F75742866756E6374696F6E28297B762E73746174652E697356697369626C6526265728297D2C7429';
wwv_flow_api.g_varchar2_table(306) := '3A5728297D66756E6374696F6E206B28297B646F63756D656E742E72656D6F76654576656E744C697374656E657228226D6F7573656D6F7665222C67292C6D3D6E756C6C7D66756E6374696F6E204528297B646F63756D656E742E626F64792E72656D6F';
wwv_flow_api.g_varchar2_table(307) := '76654576656E744C697374656E657228226D6F7573656C65617665222C78292C646F63756D656E742E72656D6F76654576656E744C697374656E657228226D6F7573656D6F7665222C64297D66756E6374696F6E204F2874297B762E73746174652E6973';
wwv_flow_api.g_varchar2_table(308) := '456E61626C656426262144287429262628762E73746174652E697356697369626C657C7C28633D74292C22636C69636B223D3D3D742E7479706526262131213D3D762E70726F70732E686964654F6E436C69636B2626762E73746174652E697356697369';
wwv_flow_api.g_varchar2_table(309) := '626C653F7828293A77287429297D66756E6374696F6E20542874297B76617220653D647428742E7461726765742C66756E6374696F6E2874297B72657475726E20742E5F74697070797D292C723D667428742E7461726765742C70742E504F5050455229';
wwv_flow_api.g_varchar2_table(310) := '3D3D3D762E706F707065722C6E3D653D3D3D762E7265666572656E63653B727C7C6E7C7C417428547428762E706F70706572292C762E706F707065722E676574426F756E64696E67436C69656E745265637428292C742C762E70726F7073292626284528';
wwv_flow_api.g_varchar2_table(311) := '292C782829297D66756E6374696F6E204C2874297B69662821442874292972657475726E20762E70726F70732E696E7465726163746976653F28646F63756D656E742E626F64792E6164644576656E744C697374656E657228226D6F7573656C65617665';
wwv_flow_api.g_varchar2_table(312) := '222C78292C766F696420646F63756D656E742E6164644576656E744C697374656E657228226D6F7573656D6F7665222C6429293A766F6964207828297D66756E6374696F6E20432874297B696628742E7461726765743D3D3D762E7265666572656E6365';
wwv_flow_api.g_varchar2_table(313) := '297B696628762E70726F70732E696E746572616374697665297B69662821742E72656C617465645461726765742972657475726E3B696628667428742E72656C617465645461726765742C70742E504F50504552292972657475726E7D7828297D7D6675';
wwv_flow_api.g_varchar2_table(314) := '6E6374696F6E20412874297B667428742E7461726765742C762E70726F70732E746172676574292626772874297D66756E6374696F6E20592874297B667428742E7461726765742C762E70726F70732E7461726765742926267828297D66756E6374696F';
wwv_flow_api.g_varchar2_table(315) := '6E20442874297B76617220653D497428742E747970652C22746F75636822292C723D6A262648742626762E70726F70732E746F756368486F6C64262621652C6E3D4874262621762E70726F70732E746F756368486F6C642626653B72657475726E20727C';
wwv_flow_api.g_varchar2_table(316) := '7C6E7D66756E6374696F6E204D28297B76617220743D762E70726F70732E706F707065724F7074696F6E732C653D762E706F707065724368696C6472656E2C723D652E746F6F6C7469702C6E3D652E6172726F773B72657475726E206E65772061742876';
wwv_flow_api.g_varchar2_table(317) := '2E7265666572656E63652C762E706F707065722C5574287B706C6163656D656E743A762E70726F70732E706C6163656D656E747D2C742C7B6D6F646966696572733A5574287B7D2C743F742E6D6F646966696572733A7B7D2C7B70726576656E744F7665';
wwv_flow_api.g_varchar2_table(318) := '72666C6F773A5574287B626F756E646172696573456C656D656E743A762E70726F70732E626F756E646172797D2C537428742C2270726576656E744F766572666C6F772229292C6172726F773A5574287B656C656D656E743A6E2C656E61626C65643A21';
wwv_flow_api.g_varchar2_table(319) := '216E7D2C537428742C226172726F772229292C666C69703A5574287B656E61626C65643A762E70726F70732E666C69702C70616464696E673A762E70726F70732E64697374616E63652B352C6265686176696F723A762E70726F70732E666C6970426568';
wwv_flow_api.g_varchar2_table(320) := '6176696F727D2C537428742C22666C69702229292C6F66667365743A5574287B6F66667365743A762E70726F70732E6F66667365747D2C537428742C226F66667365742229297D292C6F6E4372656174653A66756E6374696F6E28297B722E7374796C65';
wwv_flow_api.g_varchar2_table(321) := '5B547428762E706F70706572295D3D597428762E70726F70732E64697374616E63652C562E64697374616E6365292C6E2626762E70726F70732E6172726F775472616E73666F726D26267465286E2C762E70726F70732E6172726F775472616E73666F72';
wwv_flow_api.g_varchar2_table(322) := '6D297D2C6F6E5570646174653A66756E6374696F6E28297B76617220743D722E7374796C653B742E746F703D22222C742E626F74746F6D3D22222C742E6C6566743D22222C742E72696768743D22222C745B547428762E706F70706572295D3D59742876';
wwv_flow_api.g_varchar2_table(323) := '2E70726F70732E64697374616E63652C562E64697374616E6365292C6E2626762E70726F70732E6172726F775472616E73666F726D26267465286E2C762E70726F70732E6172726F775472616E73666F726D297D7D29297D66756E6374696F6E20502874';
wwv_flow_api.g_varchar2_table(324) := '297B762E706F70706572496E7374616E63653F5828297C7C28762E706F70706572496E7374616E63652E7363686564756C6555706461746528292C762E70726F70732E6C697665506C6163656D656E742626762E706F70706572496E7374616E63652E65';
wwv_flow_api.g_varchar2_table(325) := '6E61626C654576656E744C697374656E6572732829293A28762E706F70706572496E7374616E63653D4D28292C286C3D6E6577204D75746174696F6E4F627365727665722866756E6374696F6E28297B762E706F70706572496E7374616E63652E757064';
wwv_flow_api.g_varchar2_table(326) := '61746528297D29292E6F62736572766528752C7B6368696C644C6973743A21302C737562747265653A21302C636861726163746572446174613A21307D292C762E70726F70732E6C697665506C6163656D656E742626215828297C7C762E706F70706572';
wwv_flow_api.g_varchar2_table(327) := '496E7374616E63652E64697361626C654576656E744C697374656E6572732829292C762E706F70706572496E7374616E63652E7265666572656E63653D762E7265666572656E63653B76617220652C722C6E2C6F2C692C612C703D762E706F7070657243';
wwv_flow_api.g_varchar2_table(328) := '68696C6472656E2E6172726F773B696628582829297B70262628702E7374796C652E6D617267696E3D223022293B76617220733D507428762E70726F70732E64656C61792C302C562E64656C6179293B632E74797065262667287326266D3F6D3A63297D';
wwv_flow_api.g_varchar2_table(329) := '656C73652070262628702E7374796C652E6D617267696E3D2222293B653D762E706F70706572496E7374616E63652C723D742C6E3D652E706F707065722C6F3D652E6F7074696F6E732C693D6F2E6F6E4372656174652C613D6F2E6F6E5570646174652C';
wwv_flow_api.g_varchar2_table(330) := '6F2E6F6E4372656174653D6F2E6F6E5570646174653D66756E6374696F6E28297B6E2E6F66667365744865696768742C7228292C6128292C6F2E6F6E4372656174653D692C6F2E6F6E5570646174653D617D2C762E70726F70732E617070656E64546F2E';
wwv_flow_api.g_varchar2_table(331) := '636F6E7461696E7328762E706F70706572297C7C28762E70726F70732E617070656E64546F2E617070656E644368696C6428762E706F70706572292C762E70726F70732E6F6E4D6F756E742876292C762E73746174652E69734D6F756E7465643D213029';
wwv_flow_api.g_varchar2_table(332) := '7D66756E6374696F6E205828297B72657475726E20762E70726F70732E666F6C6C6F77437572736F722626214874262622666F63757322213D3D632E747970657D66756E6374696F6E204E28742C72297B696628303D3D3D742972657475726E20722829';
wwv_flow_api.g_varchar2_table(333) := '3B766172206E3D762E706F707065724368696C6472656E2E746F6F6C7469702C653D66756E6374696F6E20742865297B652E7461726765743D3D3D6E2626284F74286E2C2272656D6F7665222C74292C722829297D3B4F74286E2C2272656D6F7665222C';
wwv_flow_api.g_varchar2_table(334) := '61292C4F74286E2C22616464222C65292C613D657D66756E6374696F6E205328742C65297B76617220723D323C617267756D656E74732E6C656E6774682626766F69642030213D3D617267756D656E74735B325D2626617267756D656E74735B325D3B76';
wwv_flow_api.g_varchar2_table(335) := '2E7265666572656E63652E6164644576656E744C697374656E657228742C652C72292C702E70757368287B6576656E74547970653A742C68616E646C65723A652C6F7074696F6E733A727D297D66756E6374696F6E204928297B762E70726F70732E746F';
wwv_flow_api.g_varchar2_table(336) := '756368486F6C64262621762E70726F70732E746172676574262628532822746F7563687374617274222C4F2C7574292C532822746F756368656E64222C4C2C757429292C762E70726F70732E747269676765722E7472696D28292E73706C697428222022';
wwv_flow_api.g_varchar2_table(337) := '292E666F72456163682866756E6374696F6E2874297B696628226D616E75616C22213D3D7429696628762E70726F70732E746172676574297377697463682874297B63617365226D6F757365656E746572223A5328226D6F7573656F766572222C41292C';
wwv_flow_api.g_varchar2_table(338) := '5328226D6F7573656F7574222C59293B627265616B3B6361736522666F637573223A532822666F637573696E222C41292C532822666F6375736F7574222C59293B627265616B3B6361736522636C69636B223A5328742C41297D656C7365207377697463';
wwv_flow_api.g_varchar2_table(339) := '68285328742C4F292C74297B63617365226D6F757365656E746572223A5328226D6F7573656C65617665222C4C293B627265616B3B6361736522666F637573223A53285F3F22666F6375736F7574223A22626C7572222C43297D7D297D66756E6374696F';
wwv_flow_api.g_varchar2_table(340) := '6E204828297B702E666F72456163682866756E6374696F6E2874297B76617220653D742E6576656E74547970652C723D742E68616E646C65722C6E3D742E6F7074696F6E733B762E7265666572656E63652E72656D6F76654576656E744C697374656E65';
wwv_flow_api.g_varchar2_table(341) := '7228652C722C6E297D292C703D5B5D7D66756E6374696F6E204628297B636C65617254696D656F7574286F292C636C65617254696D656F7574286E297D66756E6374696F6E204228297B76617220653D303C617267756D656E74732E6C656E6774682626';
wwv_flow_api.g_varchar2_table(342) := '766F69642030213D3D617267756D656E74735B305D3F617267756D656E74735B305D3A7B7D3B477428652C56293B76617220742C722C6E2C6F2C692C612C702C732C6C2C633D762E70726F70732C663D717428762E7265666572656E63652C5574287B7D';
wwv_flow_api.g_varchar2_table(343) := '2C762E70726F70732C652C7B706572666F726D616E63653A21307D29293B662E706572666F726D616E63653D4D7428652C22706572666F726D616E636522293F652E706572666F726D616E63653A632E706572666F726D616E63652C762E70726F70733D';
wwv_flow_api.g_varchar2_table(344) := '662C284D7428652C227472696767657222297C7C4D7428652C22746F756368486F6C642229292626284828292C492829292C4D7428652C22696E7465726163746976654465626F756E636522292626284528292C643D4E7428542C652E696E7465726163';
wwv_flow_api.g_varchar2_table(345) := '746976654465626F756E636529292C743D762E706F707065722C723D632C6E3D662C693D79742874292C613D692E746F6F6C7469702C703D692E636F6E74656E742C733D692E6261636B64726F702C6C3D692E6172726F772C742E7374796C652E7A496E';
wwv_flow_api.g_varchar2_table(346) := '6465783D6E2E7A496E6465782C612E7365744174747269627574652822646174612D73697A65222C6E2E73697A65292C612E7365744174747269627574652822646174612D616E696D6174696F6E222C6E2E616E696D6174696F6E292C612E7374796C65';
wwv_flow_api.g_varchar2_table(347) := '2E6D617857696474683D6E2E6D617857696474682B28226E756D626572223D3D747970656F66206E2E6D617857696474683F227078223A2222292C722E636F6E74656E74213D3D6E2E636F6E74656E742626767428702C6E292C21722E616E696D617465';
wwv_flow_api.g_varchar2_table(348) := '46696C6C26266E2E616E696D61746546696C6C3F28612E617070656E644368696C642878742829292C612E7365744174747269627574652822646174612D616E696D61746566696C6C222C222229293A722E616E696D61746546696C6C2626216E2E616E';
wwv_flow_api.g_varchar2_table(349) := '696D61746546696C6C262628612E72656D6F76654368696C642873292C612E72656D6F76654174747269627574652822646174612D616E696D61746566696C6C2229292C21722E6172726F7726266E2E6172726F773F612E617070656E644368696C6428';
wwv_flow_api.g_varchar2_table(350) := '7774286E2E6172726F775479706529293A722E6172726F772626216E2E6172726F772626612E72656D6F76654368696C64286C292C722E6172726F7726266E2E6172726F772626722E6172726F7754797065213D3D6E2E6172726F77547970652626612E';
wwv_flow_api.g_varchar2_table(351) := '7265706C6163654368696C64287774286E2E6172726F7754797065292C6C292C21722E696E74657261637469766526266E2E696E7465726163746976653F6B7428742C61293A722E696E7465726163746976652626216E2E696E74657261637469766526';
wwv_flow_api.g_varchar2_table(352) := '26286F3D612C742E72656D6F76654174747269627574652822746162696E64657822292C6F2E72656D6F76654174747269627574652822646174612D696E7465726163746976652229292C21722E696E657274696126266E2E696E65727469613F677428';
wwv_flow_api.g_varchar2_table(353) := '61293A722E696E65727469612626216E2E696E65727469612626612E72656D6F76654174747269627574652822646174612D696E657274696122292C722E7468656D65213D3D6E2E7468656D65262628722E7468656D652E73706C697428222022292E66';
wwv_flow_api.g_varchar2_table(354) := '6F72456163682866756E6374696F6E2874297B612E636C6173734C6973742E72656D6F766528742B222D7468656D6522297D292C6E2E7468656D652E73706C697428222022292E666F72456163682866756E6374696F6E2874297B612E636C6173734C69';
wwv_flow_api.g_varchar2_table(355) := '73742E61646428742B222D7468656D6522297D29292C762E706F707065724368696C6472656E3D797428762E706F70706572292C762E706F70706572496E7374616E63652626552E736F6D652866756E6374696F6E2874297B72657475726E204D742865';
wwv_flow_api.g_varchar2_table(356) := '2C74297D29262628762E706F70706572496E7374616E63652E64657374726F7928292C762E706F70706572496E7374616E63653D4D28292C762E73746174652E697356697369626C657C7C762E706F70706572496E7374616E63652E64697361626C6545';
wwv_flow_api.g_varchar2_table(357) := '76656E744C697374656E65727328292C762E70726F70732E666F6C6C6F77437572736F7226266D262667286D29297D66756E6374696F6E205228297B76617220743D303C617267756D656E74732E6C656E6774682626766F69642030213D3D617267756D';
wwv_flow_api.g_varchar2_table(358) := '656E74735B305D3F617267756D656E74735B305D3A507428762E70726F70732E6475726174696F6E2C302C562E6475726174696F6E5B305D293B69662821762E73746174652E697344657374726F7965642626762E73746174652E6973456E61626C6564';
wwv_flow_api.g_varchar2_table(359) := '2626282148747C7C762E70726F70732E746F756368292972657475726E20762E7265666572656E63652E69735669727475616C7C7C646F63756D656E742E646F63756D656E74456C656D656E742E636F6E7461696E7328762E7265666572656E6365293F';
wwv_flow_api.g_varchar2_table(360) := '766F696428762E7265666572656E63652E686173417474726962757465282264697361626C656422297C7C28733F733D21313A2131213D3D762E70726F70732E6F6E53686F77287629262628762E706F707065722E7374796C652E7669736962696C6974';
wwv_flow_api.g_varchar2_table(361) := '793D2276697369626C65222C762E73746174652E697356697369626C653D21302C4574285B762E706F707065722C762E706F707065724368696C6472656E2E746F6F6C7469702C762E706F707065724368696C6472656E2E6261636B64726F705D2C3029';
wwv_flow_api.g_varchar2_table(362) := '2C502866756E6374696F6E28297B762E73746174652E697356697369626C652626285828297C7C762E706F70706572496E7374616E63652E75706461746528292C4574285B762E706F707065724368696C6472656E2E746F6F6C7469702C762E706F7070';
wwv_flow_api.g_varchar2_table(363) := '65724368696C6472656E2E6261636B64726F702C762E706F707065724368696C6472656E2E636F6E74656E745D2C74292C762E706F707065724368696C6472656E2E6261636B64726F70262628762E706F707065724368696C6472656E2E636F6E74656E';
wwv_flow_api.g_varchar2_table(364) := '742E7374796C652E7472616E736974696F6E44656C61793D4D6174682E726F756E6428742F36292B226D7322292C762E70726F70732E696E7465726163746976652626762E7265666572656E63652E636C6173734C6973742E616464282274697070792D';
wwv_flow_api.g_varchar2_table(365) := '61637469766522292C762E70726F70732E737469636B792626284574285B762E706F707065725D2C5F3F303A762E70726F70732E7570646174654475726174696F6E292C66756E6374696F6E207428297B762E706F70706572496E7374616E6365262676';
wwv_flow_api.g_varchar2_table(366) := '2E706F70706572496E7374616E63652E7363686564756C6555706461746528292C762E73746174652E69734D6F756E7465643F72657175657374416E696D6174696F6E4672616D652874293A4574285B762E706F707065725D2C30297D2829292C4C7428';
wwv_flow_api.g_varchar2_table(367) := '5B762E706F707065724368696C6472656E2E746F6F6C7469702C762E706F707065724368696C6472656E2E6261636B64726F702C762E706F707065724368696C6472656E2E636F6E74656E745D2C2276697369626C6522292C4E28742C66756E6374696F';
wwv_flow_api.g_varchar2_table(368) := '6E28297B303D3D3D762E70726F70732E7570646174654475726174696F6E2626762E706F707065724368696C6472656E2E746F6F6C7469702E636C6173734C6973742E616464282274697070792D6E6F7472616E736974696F6E22292C762E70726F7073';
wwv_flow_api.g_varchar2_table(369) := '2E6175746F466F6375732626762E70726F70732E696E74657261637469766526264974285B22666F637573222C22636C69636B225D2C632E74797065292626587428762E706F70706572292C762E70726F70732E617269612626762E7265666572656E63';
wwv_flow_api.g_varchar2_table(370) := '652E7365744174747269627574652822617269612D222B762E70726F70732E617269612C762E706F707065722E6964292C762E70726F70732E6F6E53686F776E2876292C762E73746174652E697353686F776E3D21307D29297D292929293A7A28297D66';
wwv_flow_api.g_varchar2_table(371) := '756E6374696F6E205728297B76617220742C653D303C617267756D656E74732E6C656E6774682626766F69642030213D3D617267756D656E74735B305D3F617267756D656E74735B305D3A507428762E70726F70732E6475726174696F6E2C312C562E64';
wwv_flow_api.g_varchar2_table(372) := '75726174696F6E5B315D293B21762E73746174652E697344657374726F7965642626762E73746174652E6973456E61626C65642626282131213D3D762E70726F70732E6F6E48696465287629262628303D3D3D762E70726F70732E757064617465447572';
wwv_flow_api.g_varchar2_table(373) := '6174696F6E2626762E706F707065724368696C6472656E2E746F6F6C7469702E636C6173734C6973742E72656D6F7665282274697070792D6E6F7472616E736974696F6E22292C762E70726F70732E696E7465726163746976652626762E726566657265';
wwv_flow_api.g_varchar2_table(374) := '6E63652E636C6173734C6973742E72656D6F7665282274697070792D61637469766522292C762E706F707065722E7374796C652E7669736962696C6974793D2268696464656E222C762E73746174652E697356697369626C653D21312C762E7374617465';
wwv_flow_api.g_varchar2_table(375) := '2E697353686F776E3D21312C4574285B762E706F707065724368696C6472656E2E746F6F6C7469702C762E706F707065724368696C6472656E2E6261636B64726F702C762E706F707065724368696C6472656E2E636F6E74656E745D2C65292C4C74285B';
wwv_flow_api.g_varchar2_table(376) := '762E706F707065724368696C6472656E2E746F6F6C7469702C762E706F707065724368696C6472656E2E6261636B64726F702C762E706F707065724368696C6472656E2E636F6E74656E745D2C2268696464656E22292C762E70726F70732E6175746F46';
wwv_flow_api.g_varchar2_table(377) := '6F6375732626762E70726F70732E696E7465726163746976652626217326264974285B22666F637573222C22636C69636B225D2C632E747970652926262822666F637573223D3D3D632E74797065262628733D2130292C587428762E7265666572656E63';
wwv_flow_api.g_varchar2_table(378) := '6529292C743D66756E6374696F6E28297B697C7C6B28292C762E70726F70732E617269612626762E7265666572656E63652E72656D6F76654174747269627574652822617269612D222B762E70726F70732E61726961292C762E706F70706572496E7374';
wwv_flow_api.g_varchar2_table(379) := '616E63652E64697361626C654576656E744C697374656E65727328292C762E70726F70732E617070656E64546F2E72656D6F76654368696C6428762E706F70706572292C762E73746174652E69734D6F756E7465643D21312C762E70726F70732E6F6E48';
wwv_flow_api.g_varchar2_table(380) := '696464656E2876297D2C4E28652C66756E6374696F6E28297B21762E73746174652E697356697369626C652626762E70726F70732E617070656E64546F2E636F6E7461696E7328762E706F707065722926267428297D2929297D66756E6374696F6E207A';
wwv_flow_api.g_varchar2_table(381) := '2874297B762E73746174652E697344657374726F7965647C7C28762E73746174652E69734D6F756E7465642626572830292C4828292C762E7265666572656E63652E72656D6F76654576656E744C697374656E65722822636C69636B222C79292C64656C';
wwv_flow_api.g_varchar2_table(382) := '65746520762E7265666572656E63652E5F74697070792C762E70726F70732E7461726765742626742626637428762E7265666572656E63652E717565727953656C6563746F72416C6C28762E70726F70732E74617267657429292E666F72456163682866';
wwv_flow_api.g_varchar2_table(383) := '756E6374696F6E2874297B72657475726E20742E5F74697070792626742E5F74697070792E64657374726F7928297D292C762E706F70706572496E7374616E63652626762E706F70706572496E7374616E63652E64657374726F7928292C6C26266C2E64';
wwv_flow_api.g_varchar2_table(384) := '6973636F6E6E65637428292C762E73746174652E697344657374726F7965643D2130297D7D766172206E653D21313B66756E6374696F6E206F6528742C652C72297B477428652C56292C6E657C7C28646F63756D656E742E6164644576656E744C697374';
wwv_flow_api.g_varchar2_table(385) := '656E65722822636C69636B222C57742C2130292C646F63756D656E742E6164644576656E744C697374656E65722822746F7563687374617274222C46742C7574292C77696E646F772E6164644576656E744C697374656E65722822626C7572222C7A7429';
wwv_flow_api.g_varchar2_table(386) := '2C77696E646F772E6164644576656E744C697374656E65722822726573697A65222C5F74292C6A7C7C216E6176696761746F722E6D6178546F756368506F696E74732626216E6176696761746F722E6D734D6178546F756368506F696E74737C7C646F63';
wwv_flow_api.g_varchar2_table(387) := '756D656E742E6164644576656E744C697374656E65722822706F696E746572646F776E222C4674292C6E653D2130293B766172206E3D5574287B7D2C562C65293B4474287429262666756E6374696F6E2872297B76617220743D7B69735669727475616C';
wwv_flow_api.g_varchar2_table(388) := '3A21302C617474726962757465733A722E617474726962757465737C7C7B7D2C7365744174747269627574653A66756E6374696F6E28742C65297B722E617474726962757465735B745D3D657D2C6765744174747269627574653A66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(389) := '74297B72657475726E20722E617474726962757465735B745D7D2C72656D6F76654174747269627574653A66756E6374696F6E2874297B64656C65746520722E617474726962757465735B745D7D2C6861734174747269627574653A66756E6374696F6E';
wwv_flow_api.g_varchar2_table(390) := '2874297B72657475726E207420696E20722E617474726962757465737D2C6164644576656E744C697374656E65723A66756E6374696F6E28297B7D2C72656D6F76654576656E744C697374656E65723A66756E6374696F6E28297B7D2C636C6173734C69';
wwv_flow_api.g_varchar2_table(391) := '73743A7B636C6173734E616D65733A7B7D2C6164643A66756E6374696F6E2874297B722E636C6173734C6973742E636C6173734E616D65735B745D3D21307D2C72656D6F76653A66756E6374696F6E2874297B64656C65746520722E636C6173734C6973';
wwv_flow_api.g_varchar2_table(392) := '742E636C6173734E616D65735B745D7D2C636F6E7461696E733A66756E6374696F6E2874297B72657475726E207420696E20722E636C6173734C6973742E636C6173734E616D65737D7D7D3B666F7228766172206520696E207429725B655D3D745B655D';
wwv_flow_api.g_varchar2_table(393) := '7D2874293B766172206F3D66756E6374696F6E2874297B6966287420696E7374616E63656F6620456C656D656E747C7C44742874292972657475726E5B745D3B6966287420696E7374616E63656F66204E6F64654C6973742972657475726E2063742874';
wwv_flow_api.g_varchar2_table(394) := '293B69662841727261792E697341727261792874292972657475726E20743B7472797B72657475726E20637428646F63756D656E742E717565727953656C6563746F72416C6C287429297D63617463682874297B72657475726E5B5D7D7D2874292C693D';
wwv_flow_api.g_varchar2_table(395) := '6F5B305D2C613D28722626693F5B695D3A6F292E7265647563652866756E6374696F6E28742C65297B76617220723D652626726528652C6E293B72657475726E20722626742E707573682872292C747D2C5B5D292C703D7B746172676574733A742C7072';
wwv_flow_api.g_varchar2_table(396) := '6F70733A6E2C696E7374616E6365733A612C64657374726F79416C6C3A66756E6374696F6E28297B702E696E7374616E6365732E666F72456163682866756E6374696F6E2874297B742E64657374726F7928297D292C702E696E7374616E6365733D5B5D';
wwv_flow_api.g_varchar2_table(397) := '7D7D3B72657475726E20707D6F652E76657273696F6E3D22332E342E31222C6F652E64656661756C74733D562C6F652E6F6E653D66756E6374696F6E28742C65297B72657475726E206F6528742C652C2130292E696E7374616E6365735B305D7D2C6F65';
wwv_flow_api.g_varchar2_table(398) := '2E73657444656661756C74733D66756E6374696F6E2865297B4F626A6563742E6B6579732865292E666F72456163682866756E6374696F6E2874297B565B745D3D655B745D7D297D2C6F652E64697361626C65416E696D6174696F6E733D66756E637469';
wwv_flow_api.g_varchar2_table(399) := '6F6E28297B6F652E73657444656661756C7473287B6475726174696F6E3A302C7570646174654475726174696F6E3A302C616E696D61746546696C6C3A21317D297D2C6F652E68696465416C6C506F70706572733D43742C6F652E757365436170747572';
wwv_flow_api.g_varchar2_table(400) := '653D66756E6374696F6E28297B7D3B72657475726E2074262673657454696D656F75742866756E6374696F6E28297B637428646F63756D656E742E717565727953656C6563746F72416C6C28225B646174612D74697070795D2229292E666F7245616368';
wwv_flow_api.g_varchar2_table(401) := '2866756E6374696F6E2874297B76617220653D742E6765744174747269627574652822646174612D746970707922293B6526266F6528742C7B636F6E74656E743A657D297D297D292C66756E6374696F6E2874297B6966286E297B76617220653D646F63';
wwv_flow_api.g_varchar2_table(402) := '756D656E742E637265617465456C656D656E7428227374796C6522293B652E747970653D22746578742F637373222C652E74657874436F6E74656E743D742C646F63756D656E742E686561642E696E736572744265666F726528652C646F63756D656E74';
wwv_flow_api.g_varchar2_table(403) := '2E686561642E66697273744368696C64297D7D28272E74697070792D694F537B637572736F723A706F696E74657221696D706F7274616E747D2E74697070792D6E6F7472616E736974696F6E7B7472616E736974696F6E3A6E6F6E6521696D706F727461';
wwv_flow_api.g_varchar2_table(404) := '6E747D2E74697070792D706F707065727B2D7765626B69742D70657273706563746976653A37303070783B70657273706563746976653A37303070783B7A2D696E6465783A393939393B6F75746C696E653A303B7472616E736974696F6E2D74696D696E';
wwv_flow_api.g_varchar2_table(405) := '672D66756E6374696F6E3A63756269632D62657A696572282E3136352C2E38342C2E34342C31293B706F696E7465722D6576656E74733A6E6F6E653B6C696E652D6865696768743A312E343B6D61782D77696474683A63616C632831303025202D203130';
wwv_flow_api.g_varchar2_table(406) := '7078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D202E74697070792D6261636B64726F707B626F726465722D7261646975733A34302520343025203020307D2E74697070792D706F707065725B782D706C6163656D';
wwv_flow_api.g_varchar2_table(407) := '656E745E3D746F705D202E74697070792D726F756E646172726F777B626F74746F6D3A2D3870783B2D7765626B69742D7472616E73666F726D2D6F726967696E3A35302520303B7472616E73666F726D2D6F726967696E3A35302520307D2E7469707079';
wwv_flow_api.g_varchar2_table(408) := '2D706F707065725B782D706C6163656D656E745E3D746F705D202E74697070792D726F756E646172726F77207376677B706F736974696F6E3A6162736F6C7574653B6C6566743A303B2D7765626B69742D7472616E73666F726D3A726F74617465283138';
wwv_flow_api.g_varchar2_table(409) := '30646567293B7472616E73666F726D3A726F7461746528313830646567297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D202E74697070792D6172726F777B626F726465722D746F703A38707820736F6C696420233333';
wwv_flow_api.g_varchar2_table(410) := '333B626F726465722D72696768743A38707820736F6C6964207472616E73706172656E743B626F726465722D6C6566743A38707820736F6C6964207472616E73706172656E743B626F74746F6D3A2D3770783B6D617267696E3A30203670783B2D776562';
wwv_flow_api.g_varchar2_table(411) := '6B69742D7472616E73666F726D2D6F726967696E3A35302520303B7472616E73666F726D2D6F726967696E3A35302520307D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D202E74697070792D6261636B64726F707B2D77';
wwv_flow_api.g_varchar2_table(412) := '65626B69742D7472616E73666F726D2D6F726967696E3A30203235253B7472616E73666F726D2D6F726967696E3A30203235257D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D202E74697070792D6261636B64726F705B';
wwv_flow_api.g_varchar2_table(413) := '646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7363616C65283129207472616E736C617465282D3530252C2D353525293B7472616E73666F726D3A7363616C65283129207472616E736C617465282D3530';
wwv_flow_api.g_varchar2_table(414) := '252C2D353525297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D202E74697070792D6261636B64726F705B646174612D73746174653D68696464656E5D7B2D7765626B69742D7472616E73666F726D3A7363616C65282E';
wwv_flow_api.g_varchar2_table(415) := '3229207472616E736C617465282D3530252C2D343525293B7472616E73666F726D3A7363616C65282E3229207472616E736C617465282D3530252C2D343525293B6F7061636974793A307D2E74697070792D706F707065725B782D706C6163656D656E74';
wwv_flow_api.g_varchar2_table(416) := '5E3D746F705D205B646174612D616E696D6174696F6E3D73686966742D746F776172645D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559282D31307078293B7472616E73666F';
wwv_flow_api.g_varchar2_table(417) := '726D3A7472616E736C61746559282D31307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D205B646174612D616E696D6174696F6E3D73686966742D746F776172645D5B646174612D73746174653D68696464656E';
wwv_flow_api.g_varchar2_table(418) := '5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559282D32307078293B7472616E73666F726D3A7472616E736C61746559282D32307078297D2E74697070792D706F707065725B782D706C6163656D656E';
wwv_flow_api.g_varchar2_table(419) := '745E3D746F705D205B646174612D616E696D6174696F6E3D70657273706563746976655D7B2D7765626B69742D7472616E73666F726D2D6F726967696E3A626F74746F6D3B7472616E73666F726D2D6F726967696E3A626F74746F6D7D2E74697070792D';
wwv_flow_api.g_varchar2_table(420) := '706F707065725B782D706C6163656D656E745E3D746F705D205B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C6174';
wwv_flow_api.g_varchar2_table(421) := '6559282D313070782920726F74617465582830293B7472616E73666F726D3A7472616E736C61746559282D313070782920726F74617465582830297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D205B646174612D616E';
wwv_flow_api.g_varchar2_table(422) := '696D6174696F6E3D70657273706563746976655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C6174655928302920726F7461746558283630646567293B747261';
wwv_flow_api.g_varchar2_table(423) := '6E73666F726D3A7472616E736C6174655928302920726F7461746558283630646567297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D205B646174612D616E696D6174696F6E3D666164655D5B646174612D7374617465';
wwv_flow_api.g_varchar2_table(424) := '3D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559282D31307078293B7472616E73666F726D3A7472616E736C61746559282D31307078297D2E74697070792D706F707065725B782D706C6163656D656E745E';
wwv_flow_api.g_varchar2_table(425) := '3D746F705D205B646174612D616E696D6174696F6E3D666164655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559282D31307078293B7472616E73666F';
wwv_flow_api.g_varchar2_table(426) := '726D3A7472616E736C61746559282D31307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D205B646174612D616E696D6174696F6E3D73686966742D617761795D5B646174612D73746174653D76697369626C655D';
wwv_flow_api.g_varchar2_table(427) := '7B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559282D31307078293B7472616E73666F726D3A7472616E736C61746559282D31307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D205B6461';
wwv_flow_api.g_varchar2_table(428) := '74612D616E696D6174696F6E3D73686966742D617761795D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592830293B7472616E73666F726D3A7472616E';
wwv_flow_api.g_varchar2_table(429) := '736C617465592830297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D205B646174612D616E696D6174696F6E3D7363616C655D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F';
wwv_flow_api.g_varchar2_table(430) := '726D3A7472616E736C61746559282D3130707829207363616C652831293B7472616E73666F726D3A7472616E736C61746559282D3130707829207363616C652831297D2E74697070792D706F707065725B782D706C6163656D656E745E3D746F705D205B';
wwv_flow_api.g_varchar2_table(431) := '646174612D616E696D6174696F6E3D7363616C655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559283029207363616C65282E35293B7472616E73666F';
wwv_flow_api.g_varchar2_table(432) := '726D3A7472616E736C61746559283029207363616C65282E35297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D202E74697070792D6261636B64726F707B626F726465722D7261646975733A3020302033302520';
wwv_flow_api.g_varchar2_table(433) := '3330257D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D202E74697070792D726F756E646172726F777B746F703A2D3870783B2D7765626B69742D7472616E73666F726D2D6F726967696E3A35302520313030253B';
wwv_flow_api.g_varchar2_table(434) := '7472616E73666F726D2D6F726967696E3A35302520313030257D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D202E74697070792D726F756E646172726F77207376677B706F736974696F6E3A6162736F6C757465';
wwv_flow_api.g_varchar2_table(435) := '3B6C6566743A303B2D7765626B69742D7472616E73666F726D3A726F746174652830293B7472616E73666F726D3A726F746174652830297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D202E74697070792D6172';
wwv_flow_api.g_varchar2_table(436) := '726F777B626F726465722D626F74746F6D3A38707820736F6C696420233333333B626F726465722D72696768743A38707820736F6C6964207472616E73706172656E743B626F726465722D6C6566743A38707820736F6C6964207472616E73706172656E';
wwv_flow_api.g_varchar2_table(437) := '743B746F703A2D3770783B6D617267696E3A30203670783B2D7765626B69742D7472616E73666F726D2D6F726967696E3A35302520313030253B7472616E73666F726D2D6F726967696E3A35302520313030257D2E74697070792D706F707065725B782D';
wwv_flow_api.g_varchar2_table(438) := '706C6163656D656E745E3D626F74746F6D5D202E74697070792D6261636B64726F707B2D7765626B69742D7472616E73666F726D2D6F726967696E3A30202D3530253B7472616E73666F726D2D6F726967696E3A30202D3530257D2E74697070792D706F';
wwv_flow_api.g_varchar2_table(439) := '707065725B782D706C6163656D656E745E3D626F74746F6D5D202E74697070792D6261636B64726F705B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7363616C65283129207472616E736C617465282D';
wwv_flow_api.g_varchar2_table(440) := '3530252C2D343525293B7472616E73666F726D3A7363616C65283129207472616E736C617465282D3530252C2D343525297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D202E74697070792D6261636B64726F70';
wwv_flow_api.g_varchar2_table(441) := '5B646174612D73746174653D68696464656E5D7B2D7765626B69742D7472616E73666F726D3A7363616C65282E3229207472616E736C617465282D353025293B7472616E73666F726D3A7363616C65282E3229207472616E736C617465282D353025293B';
wwv_flow_api.g_varchar2_table(442) := '6F7061636974793A307D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B646174612D616E696D6174696F6E3D73686966742D746F776172645D5B646174612D73746174653D76697369626C655D7B2D7765626B';
wwv_flow_api.g_varchar2_table(443) := '69742D7472616E73666F726D3A7472616E736C617465592831307078293B7472616E73666F726D3A7472616E736C617465592831307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B646174612D616E';
wwv_flow_api.g_varchar2_table(444) := '696D6174696F6E3D73686966742D746F776172645D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592832307078293B7472616E73666F726D3A7472616E';
wwv_flow_api.g_varchar2_table(445) := '736C617465592832307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B646174612D616E696D6174696F6E3D70657273706563746976655D7B2D7765626B69742D7472616E73666F726D2D6F72696769';
wwv_flow_api.g_varchar2_table(446) := '6E3A746F703B7472616E73666F726D2D6F726967696E3A746F707D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D73746174';
wwv_flow_api.g_varchar2_table(447) := '653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C6174655928313070782920726F74617465582830293B7472616E73666F726D3A7472616E736C6174655928313070782920726F74617465582830297D2E74697070';
wwv_flow_api.g_varchar2_table(448) := '792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E';
wwv_flow_api.g_varchar2_table(449) := '73666F726D3A7472616E736C6174655928302920726F7461746558282D3630646567293B7472616E73666F726D3A7472616E736C6174655928302920726F7461746558282D3630646567297D2E74697070792D706F707065725B782D706C6163656D656E';
wwv_flow_api.g_varchar2_table(450) := '745E3D626F74746F6D5D205B646174612D616E696D6174696F6E3D666164655D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592831307078293B7472616E73666F726D3A7472';
wwv_flow_api.g_varchar2_table(451) := '616E736C617465592831307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B646174612D616E696D6174696F6E3D666164655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A30';
wwv_flow_api.g_varchar2_table(452) := '3B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592831307078293B7472616E73666F726D3A7472616E736C617465592831307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B64';
wwv_flow_api.g_varchar2_table(453) := '6174612D616E696D6174696F6E3D73686966742D617761795D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592831307078293B7472616E73666F726D3A7472616E736C617465';
wwv_flow_api.g_varchar2_table(454) := '592831307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B646174612D616E696D6174696F6E3D73686966742D617761795D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B';
wwv_flow_api.g_varchar2_table(455) := '2D7765626B69742D7472616E73666F726D3A7472616E736C617465592830293B7472616E73666F726D3A7472616E736C617465592830297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B646174612D616E69';
wwv_flow_api.g_varchar2_table(456) := '6D6174696F6E3D7363616C655D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559283130707829207363616C652831293B7472616E73666F726D3A7472616E736C617465592831';
wwv_flow_api.g_varchar2_table(457) := '30707829207363616C652831297D2E74697070792D706F707065725B782D706C6163656D656E745E3D626F74746F6D5D205B646174612D616E696D6174696F6E3D7363616C655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A30';
wwv_flow_api.g_varchar2_table(458) := '3B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559283029207363616C65282E35293B7472616E73666F726D3A7472616E736C61746559283029207363616C65282E35297D2E74697070792D706F707065725B782D706C6163656D65';
wwv_flow_api.g_varchar2_table(459) := '6E745E3D6C6566745D202E74697070792D6261636B64726F707B626F726465722D7261646975733A35302520302030203530257D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D202E74697070792D726F756E64617272';
wwv_flow_api.g_varchar2_table(460) := '6F777B72696768743A2D313670783B2D7765626B69742D7472616E73666F726D2D6F726967696E3A33332E333333333333333325203530253B7472616E73666F726D2D6F726967696E3A33332E333333333333333325203530257D2E74697070792D706F';
wwv_flow_api.g_varchar2_table(461) := '707065725B782D706C6163656D656E745E3D6C6566745D202E74697070792D726F756E646172726F77207376677B706F736974696F6E3A6162736F6C7574653B6C6566743A303B2D7765626B69742D7472616E73666F726D3A726F746174652839306465';
wwv_flow_api.g_varchar2_table(462) := '67293B7472616E73666F726D3A726F74617465283930646567297D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D202E74697070792D6172726F777B626F726465722D6C6566743A38707820736F6C696420233333333B';
wwv_flow_api.g_varchar2_table(463) := '626F726465722D746F703A38707820736F6C6964207472616E73706172656E743B626F726465722D626F74746F6D3A38707820736F6C6964207472616E73706172656E743B72696768743A2D3770783B6D617267696E3A33707820303B2D7765626B6974';
wwv_flow_api.g_varchar2_table(464) := '2D7472616E73666F726D2D6F726967696E3A30203530253B7472616E73666F726D2D6F726967696E3A30203530257D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D202E74697070792D6261636B64726F707B2D776562';
wwv_flow_api.g_varchar2_table(465) := '6B69742D7472616E73666F726D2D6F726967696E3A35302520303B7472616E73666F726D2D6F726967696E3A35302520307D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D202E74697070792D6261636B64726F705B64';
wwv_flow_api.g_varchar2_table(466) := '6174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7363616C65283129207472616E736C617465282D3530252C2D353025293B7472616E73666F726D3A7363616C65283129207472616E736C617465282D353025';
wwv_flow_api.g_varchar2_table(467) := '2C2D353025297D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D202E74697070792D6261636B64726F705B646174612D73746174653D68696464656E5D7B2D7765626B69742D7472616E73666F726D3A7363616C65282E';
wwv_flow_api.g_varchar2_table(468) := '3229207472616E736C617465282D3735252C2D353025293B7472616E73666F726D3A7363616C65282E3229207472616E736C617465282D3735252C2D353025293B6F7061636974793A307D2E74697070792D706F707065725B782D706C6163656D656E74';
wwv_flow_api.g_varchar2_table(469) := '5E3D6C6566745D205B646174612D616E696D6174696F6E3D73686966742D746F776172645D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558282D31307078293B7472616E7366';
wwv_flow_api.g_varchar2_table(470) := '6F726D3A7472616E736C61746558282D31307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D205B646174612D616E696D6174696F6E3D73686966742D746F776172645D5B646174612D73746174653D68696464';
wwv_flow_api.g_varchar2_table(471) := '656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558282D32307078293B7472616E73666F726D3A7472616E736C61746558282D32307078297D2E74697070792D706F707065725B782D706C6163656D';
wwv_flow_api.g_varchar2_table(472) := '656E745E3D6C6566745D205B646174612D616E696D6174696F6E3D70657273706563746976655D7B2D7765626B69742D7472616E73666F726D2D6F726967696E3A72696768743B7472616E73666F726D2D6F726967696E3A72696768747D2E7469707079';
wwv_flow_api.g_varchar2_table(473) := '2D706F707065725B782D706C6163656D656E745E3D6C6566745D205B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C';
wwv_flow_api.g_varchar2_table(474) := '61746558282D313070782920726F74617465592830293B7472616E73666F726D3A7472616E736C61746558282D313070782920726F74617465592830297D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D205B64617461';
wwv_flow_api.g_varchar2_table(475) := '2D616E696D6174696F6E3D70657273706563746976655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C6174655828302920726F7461746559282D363064656729';
wwv_flow_api.g_varchar2_table(476) := '3B7472616E73666F726D3A7472616E736C6174655828302920726F7461746559282D3630646567297D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D205B646174612D616E696D6174696F6E3D666164655D5B64617461';
wwv_flow_api.g_varchar2_table(477) := '2D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558282D31307078293B7472616E73666F726D3A7472616E736C61746558282D31307078297D2E74697070792D706F707065725B782D706C6163';
wwv_flow_api.g_varchar2_table(478) := '656D656E745E3D6C6566745D205B646174612D616E696D6174696F6E3D666164655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558282D31307078293B';
wwv_flow_api.g_varchar2_table(479) := '7472616E73666F726D3A7472616E736C61746558282D31307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D205B646174612D616E696D6174696F6E3D73686966742D617761795D5B646174612D73746174653D';
wwv_flow_api.g_varchar2_table(480) := '76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558282D31307078293B7472616E73666F726D3A7472616E736C61746558282D31307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D';
wwv_flow_api.g_varchar2_table(481) := '6C6566745D205B646174612D616E696D6174696F6E3D73686966742D617761795D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C617465582830293B7472616E73';
wwv_flow_api.g_varchar2_table(482) := '666F726D3A7472616E736C617465582830297D2E74697070792D706F707065725B782D706C6163656D656E745E3D6C6566745D205B646174612D616E696D6174696F6E3D7363616C655D5B646174612D73746174653D76697369626C655D7B2D7765626B';
wwv_flow_api.g_varchar2_table(483) := '69742D7472616E73666F726D3A7472616E736C61746558282D3130707829207363616C652831293B7472616E73666F726D3A7472616E736C61746558282D3130707829207363616C652831297D2E74697070792D706F707065725B782D706C6163656D65';
wwv_flow_api.g_varchar2_table(484) := '6E745E3D6C6566745D205B646174612D616E696D6174696F6E3D7363616C655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558283029207363616C6528';
wwv_flow_api.g_varchar2_table(485) := '2E35293B7472616E73666F726D3A7472616E736C61746558283029207363616C65282E35297D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D202E74697070792D6261636B64726F707B626F726465722D7261646975';
wwv_flow_api.g_varchar2_table(486) := '733A30203530252035302520307D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D202E74697070792D726F756E646172726F777B6C6566743A2D313670783B2D7765626B69742D7472616E73666F726D2D6F72696769';
wwv_flow_api.g_varchar2_table(487) := '6E3A36362E363636363636363625203530253B7472616E73666F726D2D6F726967696E3A36362E363636363636363625203530257D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D202E74697070792D726F756E6461';
wwv_flow_api.g_varchar2_table(488) := '72726F77207376677B706F736974696F6E3A6162736F6C7574653B6C6566743A303B2D7765626B69742D7472616E73666F726D3A726F74617465282D3930646567293B7472616E73666F726D3A726F74617465282D3930646567297D2E74697070792D70';
wwv_flow_api.g_varchar2_table(489) := '6F707065725B782D706C6163656D656E745E3D72696768745D202E74697070792D6172726F777B626F726465722D72696768743A38707820736F6C696420233333333B626F726465722D746F703A38707820736F6C6964207472616E73706172656E743B';
wwv_flow_api.g_varchar2_table(490) := '626F726465722D626F74746F6D3A38707820736F6C6964207472616E73706172656E743B6C6566743A2D3770783B6D617267696E3A33707820303B2D7765626B69742D7472616E73666F726D2D6F726967696E3A31303025203530253B7472616E73666F';
wwv_flow_api.g_varchar2_table(491) := '726D2D6F726967696E3A31303025203530257D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D202E74697070792D6261636B64726F707B2D7765626B69742D7472616E73666F726D2D6F726967696E3A2D3530252030';
wwv_flow_api.g_varchar2_table(492) := '3B7472616E73666F726D2D6F726967696E3A2D35302520307D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D202E74697070792D6261636B64726F705B646174612D73746174653D76697369626C655D7B2D7765626B';
wwv_flow_api.g_varchar2_table(493) := '69742D7472616E73666F726D3A7363616C65283129207472616E736C617465282D3530252C2D353025293B7472616E73666F726D3A7363616C65283129207472616E736C617465282D3530252C2D353025297D2E74697070792D706F707065725B782D70';
wwv_flow_api.g_varchar2_table(494) := '6C6163656D656E745E3D72696768745D202E74697070792D6261636B64726F705B646174612D73746174653D68696464656E5D7B2D7765626B69742D7472616E73666F726D3A7363616C65282E3229207472616E736C617465282D3235252C2D35302529';
wwv_flow_api.g_varchar2_table(495) := '3B7472616E73666F726D3A7363616C65282E3229207472616E736C617465282D3235252C2D353025293B6F7061636974793A307D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D6174696F';
wwv_flow_api.g_varchar2_table(496) := '6E3D73686966742D746F776172645D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C617465582831307078293B7472616E73666F726D3A7472616E736C617465582831307078297D2E74';
wwv_flow_api.g_varchar2_table(497) := '697070792D706F707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D6174696F6E3D73686966742D746F776172645D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D74';
wwv_flow_api.g_varchar2_table(498) := '72616E73666F726D3A7472616E736C617465582832307078293B7472616E73666F726D3A7472616E736C617465582832307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D617469';
wwv_flow_api.g_varchar2_table(499) := '6F6E3D70657273706563746976655D7B2D7765626B69742D7472616E73666F726D2D6F726967696E3A6C6566743B7472616E73666F726D2D6F726967696E3A6C6566747D2E74697070792D706F707065725B782D706C6163656D656E745E3D7269676874';
wwv_flow_api.g_varchar2_table(500) := '5D205B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C6174655828313070782920726F74617465592830293B747261';
wwv_flow_api.g_varchar2_table(501) := '6E73666F726D3A7472616E736C6174655828313070782920726F74617465592830297D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D6174696F6E3D70657273706563746976655D5B6461';
wwv_flow_api.g_varchar2_table(502) := '74612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C6174655828302920726F7461746559283630646567293B7472616E73666F726D3A7472616E736C6174655828302920726F';
wwv_flow_api.g_varchar2_table(503) := '7461746559283630646567297D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D6174696F6E3D666164655D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D747261';
wwv_flow_api.g_varchar2_table(504) := '6E73666F726D3A7472616E736C617465582831307078293B7472616E73666F726D3A7472616E736C617465582831307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D6174696F6E';
wwv_flow_api.g_varchar2_table(505) := '3D666164655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C617465582831307078293B7472616E73666F726D3A7472616E736C617465582831307078297D2E74';
wwv_flow_api.g_varchar2_table(506) := '697070792D706F707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D6174696F6E3D73686966742D617761795D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472';
wwv_flow_api.g_varchar2_table(507) := '616E736C617465582831307078293B7472616E73666F726D3A7472616E736C617465582831307078297D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D6174696F6E3D73686966742D6177';
wwv_flow_api.g_varchar2_table(508) := '61795D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C617465582830293B7472616E73666F726D3A7472616E736C617465582830297D2E74697070792D706F7070';
wwv_flow_api.g_varchar2_table(509) := '65725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D6174696F6E3D7363616C655D5B646174612D73746174653D76697369626C655D7B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558283130707829';
wwv_flow_api.g_varchar2_table(510) := '207363616C652831293B7472616E73666F726D3A7472616E736C61746558283130707829207363616C652831297D2E74697070792D706F707065725B782D706C6163656D656E745E3D72696768745D205B646174612D616E696D6174696F6E3D7363616C';
wwv_flow_api.g_varchar2_table(511) := '655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558283029207363616C65282E35293B7472616E73666F726D3A7472616E736C61746558283029207363';
wwv_flow_api.g_varchar2_table(512) := '616C65282E35297D2E74697070792D746F6F6C7469707B706F736974696F6E3A72656C61746976653B636F6C6F723A236666663B626F726465722D7261646975733A3470783B666F6E742D73697A653A2E3972656D3B70616464696E673A2E3372656D20';
wwv_flow_api.g_varchar2_table(513) := '2E3672656D3B6D61782D77696474683A33353070783B746578742D616C69676E3A63656E7465723B77696C6C2D6368616E67653A7472616E73666F726D3B2D7765626B69742D666F6E742D736D6F6F7468696E673A616E7469616C69617365643B2D6D6F';
wwv_flow_api.g_varchar2_table(514) := '7A2D6F73782D666F6E742D736D6F6F7468696E673A677261797363616C653B6261636B67726F756E642D636F6C6F723A233333337D2E74697070792D746F6F6C7469705B646174612D73697A653D736D616C6C5D7B70616464696E673A2E3272656D202E';
wwv_flow_api.g_varchar2_table(515) := '3472656D3B666F6E742D73697A653A2E373572656D7D2E74697070792D746F6F6C7469705B646174612D73697A653D6C617267655D7B70616464696E673A2E3472656D202E3872656D3B666F6E742D73697A653A3172656D7D2E74697070792D746F6F6C';
wwv_flow_api.g_varchar2_table(516) := '7469705B646174612D616E696D61746566696C6C5D7B6F766572666C6F773A68696464656E3B6261636B67726F756E642D636F6C6F723A7472616E73706172656E747D2E74697070792D746F6F6C7469705B646174612D696E7465726163746976655D2C';
wwv_flow_api.g_varchar2_table(517) := '2E74697070792D746F6F6C7469705B646174612D696E7465726163746976655D20706174687B706F696E7465722D6576656E74733A6175746F7D2E74697070792D746F6F6C7469705B646174612D696E65727469615D5B646174612D73746174653D7669';
wwv_flow_api.g_varchar2_table(518) := '7369626C655D7B7472616E736974696F6E2D74696D696E672D66756E6374696F6E3A63756269632D62657A696572282E35342C312E352C2E33382C312E3131297D2E74697070792D746F6F6C7469705B646174612D696E65727469615D5B646174612D73';
wwv_flow_api.g_varchar2_table(519) := '746174653D68696464656E5D7B7472616E736974696F6E2D74696D696E672D66756E6374696F6E3A656173657D2E74697070792D6172726F772C2E74697070792D726F756E646172726F777B706F736974696F6E3A6162736F6C7574653B77696474683A';
wwv_flow_api.g_varchar2_table(520) := '303B6865696768743A307D2E74697070792D726F756E646172726F777B77696474683A323470783B6865696768743A3870783B66696C6C3A233333333B706F696E7465722D6576656E74733A6E6F6E657D2E74697070792D6261636B64726F707B706F73';
wwv_flow_api.g_varchar2_table(521) := '6974696F6E3A6162736F6C7574653B77696C6C2D6368616E67653A7472616E73666F726D3B6261636B67726F756E642D636F6C6F723A233333333B626F726465722D7261646975733A3530253B77696474683A63616C632831313025202B203272656D29';
wwv_flow_api.g_varchar2_table(522) := '3B6C6566743A3530253B746F703A3530253B7A2D696E6465783A2D313B7472616E736974696F6E3A616C6C2063756269632D62657A696572282E34362C2E312C2E35322C2E3938293B2D7765626B69742D6261636B666163652D7669736962696C697479';
wwv_flow_api.g_varchar2_table(523) := '3A68696464656E3B6261636B666163652D7669736962696C6974793A68696464656E7D2E74697070792D6261636B64726F703A61667465727B636F6E74656E743A22223B666C6F61743A6C6566743B70616464696E672D746F703A313030257D2E746970';
wwv_flow_api.g_varchar2_table(524) := '70792D6261636B64726F702B2E74697070792D636F6E74656E747B7472616E736974696F6E2D70726F70657274793A6F7061636974793B77696C6C2D6368616E67653A6F7061636974797D2E74697070792D6261636B64726F702B2E74697070792D636F';
wwv_flow_api.g_varchar2_table(525) := '6E74656E745B646174612D73746174653D76697369626C655D7B6F7061636974793A317D2E74697070792D6261636B64726F702B2E74697070792D636F6E74656E745B646174612D73746174653D68696464656E5D7B6F7061636974793A307D27292C6F';
wwv_flow_api.g_varchar2_table(526) := '657D293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(6025289922863252)
,p_plugin_id=>wwv_flow_api.id(4530505245571775)
,p_file_name=>'js/tippy.all.min.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
