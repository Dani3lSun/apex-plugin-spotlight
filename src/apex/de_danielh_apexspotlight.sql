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
,p_default_workspace_id=>2842970987618181
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
--   Date and Time:   14:12 Tuesday October 16, 2018
--   Exported By:     APEX_PLUGIN
--   Flashback:       0
--   Export Type:     Application Export
--   Version:         5.1.4.00.08
--   Instance ID:     108881281547065
--

-- Application Statistics:
--   Pages:                     25
--     Items:                   25
--     Validations:              1
--     Processes:                5
--     Regions:                 74
--     Buttons:                 25
--     Dynamic Actions:         44
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
' * Version: 1.3.5',
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
'  l_placeholder_text      p_plugin.attribute_01%TYPE := p_plugin.attribute_01;',
'  l_more_chars_text       p_plugin.attribute_02%TYPE := p_plugin.attribute_02;',
'  l_no_match_text         p_plugin.attribute_03%TYPE := p_plugin.attribute_03;',
'  l_one_match_text        p_plugin.attribute_04%TYPE := p_plugin.attribute_04;',
'  l_multiple_matches_text p_plugin.attribute_05%TYPE := p_plugin.attribute_05;',
'  l_inpage_search_text    p_plugin.attribute_06%TYPE := p_plugin.attribute_06;',
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
'  --',
'  l_component_config_json CLOB := empty_clob();',
'  --',
'BEGIN',
'  -- Debug',
'  IF apex_application.g_debug THEN',
'    apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin,',
'                                          p_dynamic_action => p_dynamic_action);',
'  END IF;',
'  --',
'  -- add mousetrap.js and mark.js libs',
'  IF l_enable_keyboard_shortcuts = ''Y'' THEN',
'    apex_javascript.add_library(p_name                  => ''mousetrap'',',
'                                p_directory             => p_plugin.file_prefix ||',
'                                                           ''js/'',',
'                                p_version               => NULL,',
'                                p_skip_extension        => FALSE,',
'                                p_check_to_add_minified => TRUE);',
'  END IF;',
'  --',
'  IF l_enable_inpage_search = ''Y'' THEN',
'    apex_javascript.add_library(p_name                  => ''jquery.mark'',',
'                                p_directory             => p_plugin.file_prefix ||',
'                                                           ''js/'',',
'                                p_version               => NULL,',
'                                p_skip_extension        => FALSE,',
'                                p_check_to_add_minified => TRUE);',
'  END IF;',
'  -- build component config json',
'  apex_json.initialize_clob_output;',
'  apex_json.open_object();',
'  -- general',
'  apex_json.write(''dynamicActionId'',',
'                  p_dynamic_action.id);',
'  apex_json.write(''ajaxIdentifier'',',
'                  apex_plugin.get_ajax_identifier);',
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
'  apex_json.close_object();',
'  --',
'  l_component_config_json := apex_json.get_clob_output;',
'  --',
'  l_result.javascript_function := ''function() { apex.da.apexSpotlight.pluginHandler('' ||',
'                                  l_component_config_json || ''); }'';',
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
'                            p_plugin         IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_dynamic_action_ajax_result IS',
'  --',
'  l_result apex_plugin.t_dynamic_action_ajax_result;',
'  --',
'  l_request_type VARCHAR2(50);',
'  --',
'  -- Execute Spotlight GET_DATA Request',
'  PROCEDURE exec_get_data_request(p_dynamic_action IN apex_plugin.t_dynamic_action,',
'                                  p_plugin         IN apex_plugin.t_plugin) IS',
'    l_data_source_sql_query p_dynamic_action.attribute_03%TYPE := p_dynamic_action.attribute_03;',
'    l_data_type_list        apex_application_global.vc_arr2;',
'    l_column_value_list     apex_plugin_util.t_column_value_list2;',
'    l_row_count             NUMBER;',
'  BEGIN',
'    -- Data Types of SQL Source Columns',
'    l_data_type_list(1) := apex_plugin_util.c_data_type_varchar2;',
'    l_data_type_list(2) := apex_plugin_util.c_data_type_varchar2;',
'    l_data_type_list(3) := apex_plugin_util.c_data_type_varchar2;',
'    l_data_type_list(4) := apex_plugin_util.c_data_type_varchar2;',
'    -- Get Data from SQL Source',
'    l_column_value_list := apex_plugin_util.get_data2(p_sql_statement  => l_data_source_sql_query,',
'                                                      p_min_columns    => 4,',
'                                                      p_max_columns    => 4,',
'                                                      p_data_type_list => l_data_type_list,',
'                                                      p_component_name => p_dynamic_action.action);',
'    -- loop over SQL Source results and write json',
'    apex_json.open_array();',
'    --',
'    l_row_count := l_column_value_list(1).value_list.count;',
'    --',
'    FOR i IN 1 .. l_row_count LOOP',
'      apex_json.open_object;',
'      -- name / title',
'      apex_json.write(''n'',',
'                      l_column_value_list(1).value_list(i).varchar2_value);',
'      -- description',
'      apex_json.write(''d'',',
'                      l_column_value_list(2).value_list(i).varchar2_value);',
'      -- link / URL',
'      apex_json.write(''u'',',
'                      l_column_value_list(3).value_list(i).varchar2_value);',
'      -- icon',
'      apex_json.write(''i'',',
'                      l_column_value_list(4).value_list(i).varchar2_value);',
'      -- if URL contains ~SEARCH_VALUE~, make list entry static',
'      IF instr(l_column_value_list(3).value_list(i).varchar2_value,',
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
'  END;',
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
'             ''f?p='') > 0 AND',
'       instr(l_url,',
'             ''~SEARCH_VALUE~'') > 0 THEN',
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
'  END;',
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
,p_version_identifier=>'1.3.5'
,p_about_url=>'https://github.com/Dani3lSun/apex-plugin-spotlight'
,p_files_version=>952
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
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Enables you to add custom keyboard shortcuts to open spotlight search</p>',
'<p><strong>Important: If you enable this feature, the dynamic action must be executed on page load!</strong></p>'))
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
,p_sql_max_column_count=>4
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
'  FROM apex_application_pages aap',
' WHERE aap.application_id = :app_id',
'   AND aap.page_id = 1',
'</pre>',
'<pre>',
'SELECT ''Set a item'' AS title',
'      ,''Set item with search keyword on client side'' AS description',
'      ,''javascript:$s(''''P1_ITEM'''',''''~SEARCH_VALUE~'''');'' AS link',
'      ,''fa-home'' AS icon',
'  FROM dual',
'</pre>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>SQL Query which returns the data which can be searched through spotlight search</p>',
'<p>',
'<strong>Column 1:</strong> Title<br>',
'<strong>Column 2:</strong> Description<br>',
'<strong>Column 3:</strong> Link / URL<br>',
'<strong>Column 4:</strong> Icon',
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
,p_help_text=>'<p>Specify whether a waiting / processing indicator is displayed or not. This will replace the default search icon with an spinner as long as data is fetched from database.</p>'
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
wwv_flow_api.g_varchar2_table(9) := '2D53706F746C696768742D6C696E6B202E6170782D53706F746C696768742D73686F72746375747B636F6C6F723A236666667D2E6170782D53706F746C696768742D726573756C742E69732D616374697665202E6170782D53706F746C696768742D6C69';
wwv_flow_api.g_varchar2_table(10) := '6E6B202E6170782D53706F746C696768742D73686F72746375747B6261636B67726F756E642D636F6C6F723A72676261283235352C3235352C3235352C2E3135297D2E6170782D53706F746C696768742D7365617263687B70616464696E673A31367078';
wwv_flow_api.g_varchar2_table(11) := '3B666C65782D736872696E6B3A303B646973706C61793A666C65783B706F736974696F6E3A72656C61746976653B626F726465722D626F74746F6D3A31707820736F6C6964207267626128302C302C302C2E3035293B6D617267696E2D626F74746F6D3A';
wwv_flow_api.g_varchar2_table(12) := '2D3170787D2E6170782D53706F746C696768742D736561726368202E6170782D53706F746C696768742D69636F6E7B706F736974696F6E3A72656C61746976653B7A2D696E6465783A313B6261636B67726F756E642D636F6C6F723A236264633363377D';
wwv_flow_api.g_varchar2_table(13) := '2E6170782D53706F746C696768742D6669656C647B666C65782D67726F773A313B706F736974696F6E3A6162736F6C7574653B746F703A303B6C6566743A303B72696768743A303B626F74746F6D3A307D2E6170782D53706F746C696768742D696E7075';
wwv_flow_api.g_varchar2_table(14) := '747B666F6E742D73697A653A3230707821696D706F7274616E743B6C696E652D6865696768743A333270783B6865696768743A363470783B70616464696E673A313670782031367078203136707820363470783B626F726465722D77696474683A303B64';
wwv_flow_api.g_varchar2_table(15) := '6973706C61793A626C6F636B3B77696474683A313030253B6261636B67726F756E642D636F6C6F723A72676261283235352C3235352C3235352C2E3938297D2E6170782D53706F746C696768742D696E7075743A666F6375732C2E6170782D53706F746C';
wwv_flow_api.g_varchar2_table(16) := '696768742D6C696E6B3A666F6375737B6F75746C696E653A307D2E6170782D53706F746C696768742D6C696E6B7B646973706C61793A626C6F636B3B646973706C61793A666C65783B70616464696E673A313670783B636F6C6F723A233230323032303B';
wwv_flow_api.g_varchar2_table(17) := '616C69676E2D6974656D733A63656E7465727D2E6170782D53706F746C696768742D69636F6E7B6D617267696E2D72696768743A313670783B70616464696E673A3870783B77696474683A333270783B6865696768743A333270783B626F782D73686164';
wwv_flow_api.g_varchar2_table(18) := '6F773A30203020302031707820236666663B626F726465722D7261646975733A3270783B6261636B67726F756E642D636F6C6F723A233339396265613B636F6C6F723A236666667D2E6170782D53706F746C696768742D726573756C742D2D617070202E';
wwv_flow_api.g_varchar2_table(19) := '6170782D53706F746C696768742D69636F6E7B6261636B67726F756E642D636F6C6F723A236635346232317D2E6170782D53706F746C696768742D726573756C742D2D7773202E6170782D53706F746C696768742D69636F6E7B6261636B67726F756E64';
wwv_flow_api.g_varchar2_table(20) := '2D636F6C6F723A233234636237667D2E6170782D53706F746C696768742D696E666F7B666C65782D67726F773A313B646973706C61793A666C65783B666C65782D646972656374696F6E3A636F6C756D6E3B6A7573746966792D636F6E74656E743A6365';
wwv_flow_api.g_varchar2_table(21) := '6E7465727D2E6170782D53706F746C696768742D6C6162656C7B666F6E742D73697A653A313470783B666F6E742D7765696768743A3530307D2E6170782D53706F746C696768742D646573637B666F6E742D73697A653A313170783B636F6C6F723A7267';
wwv_flow_api.g_varchar2_table(22) := '626128302C302C302C2E3635297D2E6170782D53706F746C696768742D73686F72746375747B6C696E652D6865696768743A313670783B666F6E742D73697A653A313270783B636F6C6F723A7267626128302C302C302C2E3635293B70616464696E673A';
wwv_flow_api.g_varchar2_table(23) := '34707820313270783B626F726465722D7261646975733A323470783B6261636B67726F756E642D636F6C6F723A7267626128302C302C302C2E303235297D626F6479202E75692D6469616C6F672E75692D6469616C6F672D2D6170657873706F746C6967';
wwv_flow_api.g_varchar2_table(24) := '68747B626F726465722D77696474683A303B626F782D736861646F773A30203870782031367078207267626128302C302C302C2E3235292C302031707820327078207267626128302C302C302C2E3135292C302030203020317078207267626128302C30';
wwv_flow_api.g_varchar2_table(25) := '2C302C2E3035293B6261636B67726F756E642D636F6C6F723A7472616E73706172656E747D626F6479202E75692D6469616C6F672E75692D6469616C6F672D2D6170657873706F746C69676874202E75692D6469616C6F672D7469746C656261727B6469';
wwv_flow_api.g_varchar2_table(26) := '73706C61793A6E6F6E657D406D65646961206F6E6C792073637265656E20616E6420286D61782D6865696768743A3736387078297B2E6170782D53706F746C696768742D726573756C74737B6D61782D6865696768743A33393070787D7D2E6170782D53';
wwv_flow_api.g_varchar2_table(27) := '706F746C696768742D726573756C742D6F72616E67652E69732D616374697665202E6170782D53706F746C696768742D6C696E6B7B6261636B67726F756E642D636F6C6F723A236635396533333B636F6C6F723A236666667D2E6170782D53706F746C69';
wwv_flow_api.g_varchar2_table(28) := '6768742D69636F6E2D6F72616E67657B6261636B67726F756E642D636F6C6F723A233739373837653B636F6C6F723A236666667D2E6170782D53706F746C696768742D726573756C742D7265642E69732D616374697665202E6170782D53706F746C6967';
wwv_flow_api.g_varchar2_table(29) := '68742D6C696E6B7B6261636B67726F756E642D636F6C6F723A236461316231623B636F6C6F723A236666667D2E6170782D53706F746C696768742D69636F6E2D7265647B6261636B67726F756E642D636F6C6F723A233630363036303B636F6C6F723A23';
wwv_flow_api.g_varchar2_table(30) := '6666667D2E6170782D53706F746C696768742D726573756C742D6461726B2E69732D616374697665202E6170782D53706F746C696768742D6C696E6B7B6261636B67726F756E642D636F6C6F723A233332333333363B636F6C6F723A236666667D2E6170';
wwv_flow_api.g_varchar2_table(31) := '782D53706F746C696768742D69636F6E2D6461726B7B6261636B67726F756E642D636F6C6F723A236536653665363B636F6C6F723A233430343034303B626F782D736861646F773A30203020302031707820233430343034307D';
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
wwv_flow_api.g_varchar2_table(2) := '2F636F72652F53706F746C696768742E6373730A202A2056657273696F6E3A20312E332E350A202A2F0A2E6170782D53706F746C69676874207B0A2020646973706C61793A20666C65783B0A20206F766572666C6F773A2068696464656E3B0A20206865';
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
wwv_flow_api.g_varchar2_table(35) := '65696768743A20373638707829207B0A20202E6170782D53706F746C696768742D726573756C7473207B0A202020206D61782D6865696768743A2033393070783B0A20207D0A7D0A0A2F2A20415045582053706F746C6967687420536561726368204F72';
wwv_flow_api.g_varchar2_table(36) := '616E6765205468656D65202A2F0A2E6170782D53706F746C696768742D726573756C742D6F72616E67652E69732D616374697665202E6170782D53706F746C696768742D6C696E6B207B0A20206261636B67726F756E642D636F6C6F723A202366353965';
wwv_flow_api.g_varchar2_table(37) := '33333B0A2020636F6C6F723A20236666663B0A7D0A0A2E6170782D53706F746C696768742D69636F6E2D6F72616E6765207B0A20206261636B67726F756E642D636F6C6F723A20233739373837653B0A2020636F6C6F723A20236666663B0A7D0A0A2F2A';
wwv_flow_api.g_varchar2_table(38) := '20415045582053706F746C696768742053656172636820526564205468656D65202A2F0A2E6170782D53706F746C696768742D726573756C742D7265642E69732D616374697665202E6170782D53706F746C696768742D6C696E6B207B0A20206261636B';
wwv_flow_api.g_varchar2_table(39) := '67726F756E642D636F6C6F723A20236461316231623B0A2020636F6C6F723A20236666663B0A7D0A0A2E6170782D53706F746C696768742D69636F6E2D726564207B0A20206261636B67726F756E642D636F6C6F723A20233630363036303B0A2020636F';
wwv_flow_api.g_varchar2_table(40) := '6C6F723A20236666663B0A7D0A0A2F2A20415045582053706F746C6967687420536561726368204461726B205468656D65202A2F0A2E6170782D53706F746C696768742D726573756C742D6461726B2E69732D616374697665202E6170782D53706F746C';
wwv_flow_api.g_varchar2_table(41) := '696768742D6C696E6B207B0A20206261636B67726F756E642D636F6C6F723A20233332333333363B0A2020636F6C6F723A20236666663B0A7D0A0A2E6170782D53706F746C696768742D69636F6E2D6461726B207B0A20206261636B67726F756E642D63';
wwv_flow_api.g_varchar2_table(42) := '6F6C6F723A20236536653665363B0A2020636F6C6F723A20233430343034303B0A2020626F782D736861646F773A2030203020302031707820233430343034303B0A7D0A';
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
wwv_flow_api.g_varchar2_table(8) := '2065787465726E616C20646570656E64656E636965730A202A0A202A204076657273696F6E20312E362E320A202A204075726C2063726169672E69732F6B696C6C696E672F6D6963650A202A2F0A2866756E6374696F6E2877696E646F772C20646F6375';
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
wwv_flow_api.g_varchar2_table(313) := '202F2F2073746F7020666F7220696E7075742C2073656C6563742C20616E642074657874617265610A202020202020202072657475726E20656C656D656E742E7461674E616D65203D3D2027494E50555427207C7C20656C656D656E742E7461674E616D';
wwv_flow_api.g_varchar2_table(314) := '65203D3D202753454C45435427207C7C20656C656D656E742E7461674E616D65203D3D2027544558544152454127207C7C20656C656D656E742E6973436F6E74656E744564697461626C653B0A202020207D3B0A0A202020202F2A2A0A20202020202A20';
wwv_flow_api.g_varchar2_table(315) := '6578706F736573205F68616E646C654B6579207075626C69636C7920736F2069742063616E206265206F7665727772697474656E20627920657874656E73696F6E730A20202020202A2F0A202020204D6F757365747261702E70726F746F747970652E68';
wwv_flow_api.g_varchar2_table(316) := '616E646C654B6579203D2066756E6374696F6E2829207B0A20202020202020207661722073656C66203D20746869733B0A202020202020202072657475726E2073656C662E5F68616E646C654B65792E6170706C792873656C662C20617267756D656E74';
wwv_flow_api.g_varchar2_table(317) := '73293B0A202020207D3B0A0A202020202F2A2A0A20202020202A20616C6C6F7720637573746F6D206B6579206D617070696E67730A20202020202A2F0A202020204D6F757365747261702E6164644B6579636F646573203D2066756E6374696F6E286F62';
wwv_flow_api.g_varchar2_table(318) := '6A65637429207B0A2020202020202020666F722028766172206B657920696E206F626A65637429207B0A202020202020202020202020696620286F626A6563742E6861734F776E50726F7065727479286B65792929207B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(319) := '202020205F4D41505B6B65795D203D206F626A6563745B6B65795D3B0A2020202020202020202020207D0A20202020202020207D0A20202020202020205F524556455253455F4D4150203D206E756C6C3B0A202020207D3B0A0A202020202F2A2A0A2020';
wwv_flow_api.g_varchar2_table(320) := '2020202A20496E69742074686520676C6F62616C206D6F757365747261702066756E6374696F6E730A20202020202A0A20202020202A2054686973206D6574686F64206973206E656564656420746F20616C6C6F772074686520676C6F62616C206D6F75';
wwv_flow_api.g_varchar2_table(321) := '7365747261702066756E6374696F6E7320746F20776F726B0A20202020202A206E6F772074686174206D6F75736574726170206973206120636F6E7374727563746F722066756E6374696F6E2E0A20202020202A2F0A202020204D6F757365747261702E';
wwv_flow_api.g_varchar2_table(322) := '696E6974203D2066756E6374696F6E2829207B0A202020202020202076617220646F63756D656E744D6F75736574726170203D204D6F7573657472617028646F63756D656E74293B0A2020202020202020666F722028766172206D6574686F6420696E20';
wwv_flow_api.g_varchar2_table(323) := '646F63756D656E744D6F7573657472617029207B0A202020202020202020202020696620286D6574686F642E63686172417428302920213D3D20275F2729207B0A202020202020202020202020202020204D6F757365747261705B6D6574686F645D203D';
wwv_flow_api.g_varchar2_table(324) := '202866756E6374696F6E286D6574686F6429207B0A202020202020202020202020202020202020202072657475726E2066756E6374696F6E2829207B0A20202020202020202020202020202020202020202020202072657475726E20646F63756D656E74';
wwv_flow_api.g_varchar2_table(325) := '4D6F757365747261705B6D6574686F645D2E6170706C7928646F63756D656E744D6F757365747261702C20617267756D656E7473293B0A20202020202020202020202020202020202020207D3B0A202020202020202020202020202020207D20286D6574';
wwv_flow_api.g_varchar2_table(326) := '686F6429293B0A2020202020202020202020207D0A20202020202020207D0A202020207D3B0A0A202020204D6F757365747261702E696E697428293B0A0A202020202F2F206578706F7365206D6F7573657472617020746F2074686520676C6F62616C20';
wwv_flow_api.g_varchar2_table(327) := '6F626A6563740A2020202077696E646F772E4D6F75736574726170203D204D6F757365747261703B0A0A202020202F2F206578706F7365206173206120636F6D6D6F6E206A73206D6F64756C650A2020202069662028747970656F66206D6F64756C6520';
wwv_flow_api.g_varchar2_table(328) := '213D3D2027756E646566696E656427202626206D6F64756C652E6578706F72747329207B0A20202020202020206D6F64756C652E6578706F727473203D204D6F757365747261703B0A202020207D0A0A202020202F2F206578706F7365206D6F75736574';
wwv_flow_api.g_varchar2_table(329) := '72617020617320616E20414D44206D6F64756C650A2020202069662028747970656F6620646566696E65203D3D3D202766756E6374696F6E2720262620646566696E652E616D6429207B0A2020202020202020646566696E652866756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(330) := '207B0A20202020202020202020202072657475726E204D6F757365747261703B0A20202020202020207D293B0A202020207D0A7D292028747970656F662077696E646F7720213D3D2027756E646566696E656427203F2077696E646F77203A206E756C6C';
wwv_flow_api.g_varchar2_table(331) := '2C20747970656F66202077696E646F7720213D3D2027756E646566696E656427203F20646F63756D656E74203A206E756C6C293B0A';
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
wwv_flow_api.g_varchar2_table(1) := '617065782E64612E6170657853706F746C696768743D7B706C7567696E48616E646C65723A66756E6374696F6E2865297B76617220743D7B444F543A222E222C53505F4449414C4F473A226170782D53706F746C69676874222C53505F494E5055543A22';
wwv_flow_api.g_varchar2_table(2) := '6170782D53706F746C696768742D696E707574222C53505F524553554C54533A226170782D53706F746C696768742D726573756C7473222C53505F4143544956453A2269732D616374697665222C53505F53484F52544355543A226170782D53706F746C';
wwv_flow_api.g_varchar2_table(3) := '696768742D73686F7274637574222C53505F414354494F4E5F53484F52544355543A2273706F746C696768742D736561726368222C53505F524553554C545F4C4142454C3A226170782D53706F746C696768742D6C6162656C222C53505F4C4956455F52';
wwv_flow_api.g_varchar2_table(4) := '4547494F4E3A2273702D617269612D6D617463682D666F756E64222C53505F4C4953543A2273702D726573756C742D6C697374222C4B4559533A242E75692E6B6579436F64652C55524C5F54595045533A7B72656469726563743A227265646972656374';
wwv_flow_api.g_varchar2_table(5) := '222C736561726368506167653A227365617263682D70616765227D2C49434F4E533A7B706167653A2266612D77696E646F772D736561726368222C7365617263683A2269636F6E2D736561726368227D2C674D61784E6176526573756C743A35302C6757';
wwv_flow_api.g_varchar2_table(6) := '696474683A3635302C674861734469616C6F67437265617465643A21312C67536561726368496E6465783A5B5D2C67537461746963496E6465783A5B5D2C674B6579776F7264733A22222C67416A61784964656E7469666965723A6E756C6C2C67506C61';
wwv_flow_api.g_varchar2_table(7) := '6365686F6C646572546578743A6E756C6C2C674D6F72654368617273546578743A6E756C6C2C674E6F4D61746368546578743A6E756C6C2C674F6E654D61746368546578743A6E756C6C2C674D756C7469706C654D617463686573546578743A6E756C6C';
wwv_flow_api.g_varchar2_table(8) := '2C67496E50616765536561726368546578743A6E756C6C2C67456E61626C65496E506167655365617263683A21302C67456E61626C654461746143616368653A21312C67456E61626C6550726566696C6C53656C6563746564546578743A21312C675375';
wwv_flow_api.g_varchar2_table(9) := '626D69744974656D7341727261793A5B5D2C674B6579626F61726453686F72746375747341727261793A5B5D2C67526573756C744C6973745468656D65436C6173733A22222C6749636F6E5468656D65436C6173733A22222C6753686F7750726F636573';
wwv_flow_api.g_varchar2_table(10) := '73696E673A21312C67657453706F746C69676874446174613A66756E6374696F6E2865297B76617220613B696628742E67456E61626C65446174614361636865262628613D742E67657453706F746C696768744461746153657373696F6E53746F726167';
wwv_flow_api.g_varchar2_table(11) := '652829292965284A534F4E2E7061727365286129293B656C7365207472797B742E73686F77576169745370696E6E657228292C617065782E7365727665722E706C7567696E28742E67416A61784964656E7469666965722C7B706167654974656D733A74';
wwv_flow_api.g_varchar2_table(12) := '2E675375626D69744974656D7341727261792C7830313A224745545F44415441227D2C7B64617461547970653A226A736F6E222C737563636573733A66756E6374696F6E2861297B617065782E6576656E742E747269676765722822626F6479222C2261';
wwv_flow_api.g_varchar2_table(13) := '70657873706F746C696768742D616A61782D73756363657373222C61292C617065782E64656275672E6C6F6728226170657853706F746C696768742E67657453706F746C696768744461746120414A41582053756363657373222C61292C742E67456E61';
wwv_flow_api.g_varchar2_table(14) := '626C654461746143616368652626742E73657453706F746C696768744461746153657373696F6E53746F72616765284A534F4E2E737472696E67696679286129292C742E68696465576169745370696E6E657228292C652861297D2C6572726F723A6675';
wwv_flow_api.g_varchar2_table(15) := '6E6374696F6E28612C692C6F297B617065782E6576656E742E747269676765722822626F6479222C226170657873706F746C696768742D616A61782D6572726F72222C7B6D6573736167653A6F7D292C617065782E64656275672E6C6F67282261706578';
wwv_flow_api.g_varchar2_table(16) := '53706F746C696768742E67657453706F746C696768744461746120414A4158204572726F72222C6F292C742E68696465576169745370696E6E657228292C65285B5D297D7D297D63617463682861297B617065782E6576656E742E747269676765722822';
wwv_flow_api.g_varchar2_table(17) := '626F6479222C226170657873706F746C696768742D616A61782D6572726F72222C7B6D6573736167653A617D292C617065782E64656275672E6C6F6728226170657853706F746C696768742E67657453706F746C696768744461746120414A4158204572';
wwv_flow_api.g_varchar2_table(18) := '726F72222C61292C742E68696465576169745370696E6E657228292C65285B5D297D7D2C67657450726F7065724170657855726C3A66756E6374696F6E28652C61297B7472797B617065782E7365727665722E706C7567696E28742E67416A6178496465';
wwv_flow_api.g_varchar2_table(19) := '6E7469666965722C7B7830313A224745545F55524C222C7830323A742E674B6579776F7264732C7830333A657D2C7B64617461547970653A226A736F6E222C737563636573733A66756E6374696F6E2865297B617065782E64656275672E6C6F67282261';
wwv_flow_api.g_varchar2_table(20) := '70657853706F746C696768742E67657450726F7065724170657855726C20414A41582053756363657373222C65292C612865297D2C6572726F723A66756E6374696F6E28742C692C6F297B617065782E64656275672E6C6F6728226170657853706F746C';
wwv_flow_api.g_varchar2_table(21) := '696768742E67657450726F7065724170657855726C20414A4158204572726F72222C6F292C61287B75726C3A657D297D7D297D63617463682874297B617065782E64656275672E6C6F6728226170657853706F746C696768742E67657450726F70657241';
wwv_flow_api.g_varchar2_table(22) := '70657855726C20414A4158204572726F72222C74292C61287B75726C3A657D297D7D2C73657453706F746C696768744461746153657373696F6E53746F726167653A66756E6374696F6E2865297B696628617065782E73746F726167652E686173536573';
wwv_flow_api.g_varchar2_table(23) := '73696F6E53746F72616765537570706F7274297B76617220743D2476282270496E7374616E636522293B617065782E73746F726167652E67657453636F70656453657373696F6E53746F72616765287B7072656669783A226170657853706F746C696768';
wwv_flow_api.g_varchar2_table(24) := '74222C75736541707049643A21307D292E7365744974656D28742B222E64617461222C65297D7D2C67657453706F746C696768744461746153657373696F6E53746F726167653A66756E6374696F6E28297B76617220653B696628617065782E73746F72';
wwv_flow_api.g_varchar2_table(25) := '6167652E68617353657373696F6E53746F72616765537570706F7274297B76617220743D2476282270496E7374616E636522293B653D617065782E73746F726167652E67657453636F70656453657373696F6E53746F72616765287B7072656669783A22';
wwv_flow_api.g_varchar2_table(26) := '6170657853706F746C69676874222C75736541707049643A21307D292E6765744974656D28742B222E6461746122297D72657475726E20657D2C73686F77576169745370696E6E65723A66756E6374696F6E28297B742E6753686F7750726F6365737369';
wwv_flow_api.g_varchar2_table(27) := '6E6726262428226469762E6170782D53706F746C696768742D69636F6E207370616E22292E72656D6F7665436C61737328292E616464436C617373282266612066612D726566726573682066612D616E696D2D7370696E22297D2C686964655761697453';
wwv_flow_api.g_varchar2_table(28) := '70696E6E65723A66756E6374696F6E28297B742E6753686F7750726F63657373696E6726262428226469762E6170782D53706F746C696768742D69636F6E207370616E22292E72656D6F7665436C61737328292E616464436C6173732822612D49636F6E';
wwv_flow_api.g_varchar2_table(29) := '2069636F6E2D73656172636822297D2C67657453656C6563746564546578743A66756E6374696F6E28297B72657475726E2077696E646F772E67657453656C656374696F6E3F77696E646F772E67657453656C656374696F6E28292E746F537472696E67';
wwv_flow_api.g_varchar2_table(30) := '28292E7472696D28293A646F63756D656E742E73656C656374696F6E2E63726561746552616E67653F646F63756D656E742E73656C656374696F6E2E63726561746552616E676528292E746578742E7472696D28293A766F696420307D2C73657453656C';
wwv_flow_api.g_varchar2_table(31) := '6563746564546578743A66756E6374696F6E28297B76617220653D742E67657453656C65637465645465787428293B65262628742E674861734469616C6F67437265617465643F2428742E444F542B742E53505F494E505554292E76616C2865292E7472';
wwv_flow_api.g_varchar2_table(32) := '69676765722822696E70757422293A242822626F647922292E6F6E28226170657873706F746C696768742D6765742D64617461222C66756E6374696F6E28297B2428742E444F542B742E53505F494E505554292E76616C2865292E747269676765722822';
wwv_flow_api.g_varchar2_table(33) := '696E70757422297D29297D2C68616E646C6541726961417474723A66756E6374696F6E28297B76617220653D2428742E444F542B742E53505F524553554C5453292C613D2428742E444F542B742E53505F494E505554292C693D652E66696E6428742E44';
wwv_flow_api.g_varchar2_table(34) := '4F542B742E53505F414354495645292E66696E6428742E444F542B742E53505F524553554C545F4C4142454C292E617474722822696422292C6F3D24282223222B69292C6E3D6F2E7465787428292C723D652E66696E6428226C6922292C6C3D30213D3D';
wwv_flow_api.g_varchar2_table(35) := '722E6C656E6774682C733D22222C673D722E66696C7465722866756E6374696F6E28297B72657475726E20303D3D3D242874686973292E66696E6428742E444F542B742E53505F53484F5254435554292E6C656E6774687D292E6C656E6774683B242874';
wwv_flow_api.g_varchar2_table(36) := '2E444F542B742E53505F524553554C545F4C4142454C292E617474722822617269612D73656C6563746564222C2266616C736522292C6F2E617474722822617269612D73656C6563746564222C227472756522292C22223D3D3D742E674B6579776F7264';
wwv_flow_api.g_varchar2_table(37) := '733F733D742E67506C616365686F6C646572546578743A303D3D3D673F733D742E674E6F4D61746368546578743A313D3D3D673F733D742E674F6E654D61746368546578743A673E31262628733D672B2220222B742E674D756C7469706C654D61746368';
wwv_flow_api.g_varchar2_table(38) := '657354657874292C733D6E2B222C20222B732C24282223222B742E53505F4C4956455F524547494F4E292E746578742873292C612E617474722822617269612D61637469766564657363656E64616E74222C69292E617474722822617269612D65787061';
wwv_flow_api.g_varchar2_table(39) := '6E646564222C6C297D2C636C6F73654469616C6F673A66756E6374696F6E28297B2428742E444F542B742E53505F4449414C4F47292E6469616C6F672822636C6F736522297D2C726573657453706F746C696768743A66756E6374696F6E28297B242822';
wwv_flow_api.g_varchar2_table(40) := '23222B742E53505F4C495354292E656D70747928292C2428742E444F542B742E53505F494E505554292E76616C282222292E666F63757328292C742E674B6579776F7264733D22222C742E68616E646C65417269614174747228297D2C676F546F3A6675';
wwv_flow_api.g_varchar2_table(41) := '6E6374696F6E28652C61297B76617220693D652E64617461282275726C22293B73776974636828652E646174612822747970652229297B6361736520742E55524C5F54595045532E736561726368506167653A742E696E5061676553656172636828293B';
wwv_flow_api.g_varchar2_table(42) := '627265616B3B6361736520742E55524C5F54595045532E72656469726563743A692E696E636C7564657328227E5345415243485F56414C55457E22293F28742E674B6579776F7264733D742E674B6579776F7264732E7265706C616365282F3A7C2C7C22';
wwv_flow_api.g_varchar2_table(43) := '7C272F672C222022292E7472696D28292C692E737461727473576974682822663F703D22293F742E67657450726F7065724170657855726C28692C66756E6374696F6E2865297B617065782E6E617669676174696F6E2E726564697265637428652E7572';
wwv_flow_api.g_varchar2_table(44) := '6C297D293A28693D692E7265706C61636528227E5345415243485F56414C55457E222C742E674B6579776F726473292C617065782E6E617669676174696F6E2E726564697265637428692929293A617065782E6E617669676174696F6E2E726564697265';
wwv_flow_api.g_varchar2_table(45) := '63742869297D742E636C6F73654469616C6F6728297D2C6765744D61726B75703A66756E6374696F6E2865297B76617220613D652E7469746C652C693D652E646573637C7C22222C6F3D652E75726C2C6E3D652E747970652C723D652E69636F6E2C6C3D';
wwv_flow_api.g_varchar2_table(46) := '652E73686F72746375742C733D6C3F273C7370616E20636C6173733D22272B742E53505F53484F52544355542B2722203E272B6C2B223C2F7370616E3E223A22222C673D22222C703D22223B72657475726E28303D3D3D6F7C7C6F29262628673D276461';
wwv_flow_api.g_varchar2_table(47) := '74612D75726C3D22272B6F2B27222027292C6E262628673D672B2720646174612D747970653D22272B6E2B27222027292C703D722E73746172747357697468282266612D22293F22666120222B723A722E73746172747357697468282269636F6E2D2229';
wwv_flow_api.g_varchar2_table(48) := '3F22612D49636F6E20222B723A22612D49636F6E2069636F6E2D736561726368222C273C6C6920636C6173733D226170782D53706F746C696768742D726573756C7420272B742E67526573756C744C6973745468656D65436C6173732B27206170782D53';
wwv_flow_api.g_varchar2_table(49) := '706F746C696768742D726573756C742D2D70616765223E3C7370616E20636C6173733D226170782D53706F746C696768742D6C696E6B2220272B672B273E3C7370616E20636C6173733D226170782D53706F746C696768742D69636F6E20272B742E6749';
wwv_flow_api.g_varchar2_table(50) := '636F6E5468656D65436C6173732B272220617269612D68696464656E3D2274727565223E3C7370616E20636C6173733D22272B702B27223E3C2F7370616E3E3C2F7370616E3E3C7370616E20636C6173733D226170782D53706F746C696768742D696E66';
wwv_flow_api.g_varchar2_table(51) := '6F223E3C7370616E20636C6173733D22272B742E53505F524553554C545F4C4142454C2B272220726F6C653D226F7074696F6E223E272B612B273C2F7370616E3E3C7370616E20636C6173733D226170782D53706F746C696768742D64657363223E272B';
wwv_flow_api.g_varchar2_table(52) := '692B223C2F7370616E3E3C2F7370616E3E222B732B223C2F7370616E3E3C2F6C693E227D2C726573756C74734164644F6E733A66756E6374696F6E2865297B76617220613D303B742E67456E61626C65496E50616765536561726368262628652E707573';
wwv_flow_api.g_varchar2_table(53) := '68287B6E3A742E67496E50616765536561726368546578742C753A22222C693A742E49434F4E532E706167652C743A742E55524C5F54595045532E736561726368506167652C73686F72746375743A224374726C202B2031227D292C612B3D31293B666F';
wwv_flow_api.g_varchar2_table(54) := '722876617220693D303B693C742E67537461746963496E6465782E6C656E6774683B692B2B2928612B3D31293E393F652E70757368287B6E3A742E67537461746963496E6465785B695D2E6E2C643A742E67537461746963496E6465785B695D2E642C75';
wwv_flow_api.g_varchar2_table(55) := '3A742E67537461746963496E6465785B695D2E752C693A742E67537461746963496E6465785B695D2E692C743A742E67537461746963496E6465785B695D2E747D293A652E70757368287B6E3A742E67537461746963496E6465785B695D2E6E2C643A74';
wwv_flow_api.g_varchar2_table(56) := '2E67537461746963496E6465785B695D2E642C753A742E67537461746963496E6465785B695D2E752C693A742E67537461746963496E6465785B695D2E692C743A742E67537461746963496E6465785B695D2E742C73686F72746375743A224374726C20';
wwv_flow_api.g_varchar2_table(57) := '2B20222B617D293B72657475726E20657D2C7365617263684E61763A66756E6374696F6E2865297B76617220612C692C6F3D5B5D2C6E3D21312C723D652E6C656E6774682C6C3D66756E6374696F6E28297B72657475726E206E3F6F3A742E6753656172';
wwv_flow_api.g_varchar2_table(58) := '6368496E6465787D2C733D66756E6374696F6E28652C612C69297B766172206F2C6E3D3130302C723D612D313B72657475726E20303D3D3D652626303D3D3D723F6E3A282D313D3D3D286F3D692E696E6465784F6628742E674B6579776F72647329293F';
wwv_flow_api.g_varchar2_table(59) := '6E3D6E2D652D722D613A6E2D3D6F2C6E297D3B666F7228693D303B693C652E6C656E6774683B692B2B29613D655B695D2C6F3D6C28292E66696C7465722866756E6374696F6E28652C74297B76617220693D652E6E2E746F4C6F7765724361736528292C';
wwv_flow_api.g_varchar2_table(60) := '6F3D692E73706C697428222022292E6C656E6774682C6E3D692E7365617263682861293B72657475726E2128723E6F292626286E3E2D313F28652E73636F72653D73286E2C6F2C69292C2130293A652E742626652E742E7365617263682861293E2D313F';
wwv_flow_api.g_varchar2_table(61) := '28652E73636F72653D312C2130293A766F69642030297D292E736F72742866756E6374696F6E28652C74297B72657475726E20742E73636F72652D652E73636F72657D292C6E3D21303B72657475726E2066756E6374696F6E2865297B76617220612C69';
wwv_flow_api.g_varchar2_table(62) := '2C6F2C6E2C722C6C3D22222C733D7B7D3B666F7228652E6C656E6774683E742E674D61784E6176526573756C74262628652E6C656E6774683D742E674D61784E6176526573756C74292C613D303B613C652E6C656E6774683B612B2B296E3D28693D655B';
wwv_flow_api.g_varchar2_table(63) := '615D292E73686F72746375742C6F3D692E747C7C742E55524C5F54595045532E72656469726563742C723D692E697C7C742E49434F4E532E7365617263682C733D7B7469746C653A692E6E2C646573633A692E642C75726C3A692E752C69636F6E3A722C';
wwv_flow_api.g_varchar2_table(64) := '747970653A6F7D2C6E262628732E73686F72746375743D6E292C6C2B3D742E6765744D61726B75702873293B72657475726E206C7D28742E726573756C74734164644F6E73286F29297D2C7365617263683A66756E6374696F6E2865297B742E674B6579';
wwv_flow_api.g_varchar2_table(65) := '776F7264733D652E7472696D28293B76617220612C692C6F3D742E674B6579776F7264732E73706C697428222022292C6E3D282428742E444F542B742E53505F524553554C5453292C5B5D293B666F7228693D303B693C6F2E6C656E6774683B692B2B29';
wwv_flow_api.g_varchar2_table(66) := '6E2E70757368286E65772052656745787028617065782E7574696C2E657363617065526567457870286F5B695D292C2267692229293B613D742E7365617263684E6176286E292C24282223222B742E53505F4C495354292E68746D6C2861292E66696E64';
wwv_flow_api.g_varchar2_table(67) := '28226C6922292E656163682866756E6374696F6E2865297B242874686973292E66696E6428742E444F542B742E53505F524553554C545F4C4142454C292E6174747228226964222C2273702D726573756C742D222B65297D292E666972737428292E6164';
wwv_flow_api.g_varchar2_table(68) := '64436C61737328742E53505F414354495645297D2C63726561746553706F746C696768744469616C6F673A66756E6374696F6E2865297B2166756E6374696F6E28297B76617220612C692C6F2C6E2C723D66756E6374696F6E28297B76617220653D2428';
wwv_flow_api.g_varchar2_table(69) := '226469762E6170782D53706F746C696768742D726573756C747322293B613D652E6F7574657248656967687428292C693D2428226C692E6170782D53706F746C696768742D726573756C7422292E6F7574657248656967687428292C6F3D652E6F666673';
wwv_flow_api.g_varchar2_table(70) := '657428292E746F702C6E3D612F697D3B242877696E646F77292E6F6E28226170657877696E646F77726573697A6564222C66756E6374696F6E28297B7228297D292C242822626F647922292E617070656E6428273C64697620636C6173733D22272B742E';
wwv_flow_api.g_varchar2_table(71) := '53505F4449414C4F472B27223E3C64697620636C6173733D226170782D53706F746C696768742D626F6479223E3C64697620636C6173733D226170782D53706F746C696768742D736561726368223E3C64697620636C6173733D226170782D53706F746C';
wwv_flow_api.g_varchar2_table(72) := '696768742D69636F6E223E3C7370616E20636C6173733D22612D49636F6E2069636F6E2D7365617263682220617269612D68696464656E3D2274727565223E3C2F7370616E3E3C2F6469763E3C64697620636C6173733D226170782D53706F746C696768';
wwv_flow_api.g_varchar2_table(73) := '742D6669656C64223E3C696E70757420747970653D22746578742220726F6C653D22636F6D626F626F782220617269612D657870616E6465643D2266616C73652220617269612D6175746F636F6D706C6574653D226E6F6E652220617269612D68617370';
wwv_flow_api.g_varchar2_table(74) := '6F7075703D22747275652220617269612D6C6162656C3D2253706F746C69676874205365617263682220617269612D6F776E733D22272B742E53505F4C4953542B2722206175746F636F6D706C6574653D226F666622206175746F636F72726563743D22';
wwv_flow_api.g_varchar2_table(75) := '6F666622207370656C6C636865636B3D2266616C73652220636C6173733D22272B742E53505F494E5055542B272220706C616365686F6C6465723D22272B652B27223E3C2F6469763E3C64697620726F6C653D22726567696F6E2220636C6173733D2275';
wwv_flow_api.g_varchar2_table(76) := '2D56697375616C6C7948696464656E2220617269612D6C6976653D22706F6C697465222069643D22272B742E53505F4C4956455F524547494F4E2B27223E3C2F6469763E3C2F6469763E3C64697620636C6173733D22272B742E53505F524553554C5453';
wwv_flow_api.g_varchar2_table(77) := '2B27223E3C756C20636C6173733D226170782D53706F746C696768742D726573756C74734C697374222069643D22272B742E53505F4C4953542B272220746162696E6465783D222D312220726F6C653D226C697374626F78223E3C2F756C3E3C2F646976';
wwv_flow_api.g_varchar2_table(78) := '3E3C2F6469763E3C2F6469763E27292E6F6E2822696E707574222C742E444F542B742E53505F494E5055542C66756E6374696F6E28297B76617220653D242874686973292E76616C28292E7472696D28292C613D652E6C656E6774683B303D3D3D613F74';
wwv_flow_api.g_varchar2_table(79) := '2E726573657453706F746C6967687428293A28613E317C7C2169734E614E28652929262665213D3D742E674B6579776F7264732626742E7365617263682865297D292E6F6E28226B6579646F776E222C742E444F542B742E53505F4449414C4F472C6675';
wwv_flow_api.g_varchar2_table(80) := '6E6374696F6E2865297B766172206C2C732C673D2428742E444F542B742E53505F524553554C5453293B73776974636828652E7768696368297B6361736520742E4B4559532E444F574E3A652E70726576656E7444656661756C7428292C66756E637469';
wwv_flow_api.g_varchar2_table(81) := '6F6E2865297B766172206F3D652E66696E6428742E444F542B742E53505F414354495645292C6C3D6F2E696E64657828293B6E7C7C7228292C216F2E6C656E6774687C7C6F2E697328223A6C6173742D6368696C6422293F286F2E72656D6F7665436C61';
wwv_flow_api.g_varchar2_table(82) := '737328742E53505F414354495645292C652E66696E6428226C6922292E666972737428292E616464436C61737328742E53505F414354495645292C652E616E696D617465287B7363726F6C6C546F703A307D29293A66756E6374696F6E2865297B696628';
wwv_flow_api.g_varchar2_table(83) := '655B305D297B76617220743D652E6F666673657428292E746F703B72657475726E20743C307C7C743E617D7D286F2E72656D6F7665436C61737328742E53505F414354495645292E6E65787428292E616464436C61737328742E53505F41435449564529';
wwv_flow_api.g_varchar2_table(84) := '292626652E616E696D617465287B7363726F6C6C546F703A286C2D6E2B32292A697D2C30297D2867293B627265616B3B6361736520742E4B4559532E55503A652E70726576656E7444656661756C7428292C66756E6374696F6E2865297B766172206C3D';
wwv_flow_api.g_varchar2_table(85) := '652E66696E6428742E444F542B742E53505F414354495645292C733D6C2E696E64657828293B6E7C7C7228292C21652E6C656E6774687C7C6C2E697328223A66697273742D6368696C6422293F286C2E72656D6F7665436C61737328742E53505F414354';
wwv_flow_api.g_varchar2_table(86) := '495645292C652E66696E6428226C6922292E6C61737428292E616464436C61737328742E53505F414354495645292C652E616E696D617465287B7363726F6C6C546F703A652E66696E6428226C6922292E6C656E6774682A697D29293A66756E6374696F';
wwv_flow_api.g_varchar2_table(87) := '6E2865297B696628655B305D297B76617220743D652E6F666673657428292E746F703B72657475726E20743E617C7C743C3D6F7D7D286C2E72656D6F7665436C61737328742E53505F414354495645292E7072657628292E616464436C61737328742E53';
wwv_flow_api.g_varchar2_table(88) := '505F41435449564529292626652E616E696D617465287B7363726F6C6C546F703A28732D31292A697D2C30297D2867293B627265616B3B6361736520742E4B4559532E454E5445523A652E70726576656E7444656661756C7428292C742E676F546F2867';
wwv_flow_api.g_varchar2_table(89) := '2E66696E6428226C692E69732D616374697665207370616E22292C65293B627265616B3B6361736520742E4B4559532E5441423A742E636C6F73654469616C6F6728297D696628652E6374726C4B6579297B737769746368286C3D672E66696E6428742E';
wwv_flow_api.g_varchar2_table(90) := '444F542B742E53505F53484F5254435554292E706172656E7428292E67657428292C652E7768696368297B636173652034393A733D313B627265616B3B636173652035303A733D323B627265616B3B636173652035313A733D333B627265616B3B636173';
wwv_flow_api.g_varchar2_table(91) := '652035323A733D343B627265616B3B636173652035333A733D353B627265616B3B636173652035343A733D363B627265616B3B636173652035353A733D373B627265616B3B636173652035363A733D383B627265616B3B636173652035373A733D397D73';
wwv_flow_api.g_varchar2_table(92) := '2626742E676F546F2824286C5B732D315D292C65297D652E73686966744B65792626652E77686963683D3D3D742E4B4559532E5441422626742E636C6F73654469616C6F6728292C742E68616E646C65417269614174747228297D292E6F6E2822636C69';
wwv_flow_api.g_varchar2_table(93) := '636B222C227370616E2E6170782D53706F746C696768742D6C696E6B222C66756E6374696F6E2865297B742E676F546F28242874686973292C65297D292E6F6E28226D6F7573656D6F7665222C226C692E6170782D53706F746C696768742D726573756C';
wwv_flow_api.g_varchar2_table(94) := '74222C66756E6374696F6E28297B76617220653D242874686973293B652E706172656E7428292E66696E6428742E444F542B742E53505F414354495645292E72656D6F7665436C61737328742E53505F414354495645292C652E616464436C6173732874';
wwv_flow_api.g_varchar2_table(95) := '2E53505F414354495645297D292E6F6E2822626C7572222C742E444F542B742E53505F4449414C4F472C66756E6374696F6E2865297B2428742E444F542B742E53505F4449414C4F47292E6469616C6F67282269734F70656E222926262428742E444F54';
wwv_flow_api.g_varchar2_table(96) := '2B742E53505F494E505554292E666F63757328297D292C2428742E444F542B742E53505F4449414C4F47292E6F6E28226B6579646F776E222C66756E6374696F6E2865297B76617220613D2428742E444F542B742E53505F494E505554293B652E776869';
wwv_flow_api.g_varchar2_table(97) := '63683D3D3D742E4B4559532E455343415045262628612E76616C28293F28742E726573657453706F746C6967687428292C652E73746F7050726F7061676174696F6E2829293A742E636C6F73654469616C6F672829297D292C742E674861734469616C6F';
wwv_flow_api.g_varchar2_table(98) := '67437265617465643D21307D28297D2C6F70656E53706F746C696768744469616C6F673A66756E6374696F6E2865297B69662877696E646F772E73656C66213D3D77696E646F772E746F702972657475726E21313B742E67456E61626C6550726566696C';
wwv_flow_api.g_varchar2_table(99) := '6C53656C6563746564546578742626742E73657453656C65637465645465787428292C742E674861734469616C6F67437265617465643D2428742E444F542B742E53505F4449414C4F47292E6C656E6774683E303B76617220613D66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(100) := '297B76617220653D2428742E444F542B742E53505F4449414C4F47292C613D77696E646F772E7363726F6C6C597C7C77696E646F772E70616765594F66667365743B652E686173436C617373282275692D6469616C6F672D636F6E74656E742229262665';
wwv_flow_api.g_varchar2_table(101) := '2E6469616C6F67282269734F70656E22297C7C652E6469616C6F67287B77696474683A742E6757696474682C6865696768743A226175746F222C6D6F64616C3A21302C706F736974696F6E3A7B6D793A2263656E74657220746F70222C61743A2263656E';
wwv_flow_api.g_varchar2_table(102) := '74657220746F702B222B28612B3634292C6F663A242822626F647922297D2C6469616C6F67436C6173733A2275692D6469616C6F672D2D6170657873706F746C69676874222C6F70656E3A66756E6374696F6E28297B617065782E6576656E742E747269';
wwv_flow_api.g_varchar2_table(103) := '676765722822626F6479222C226170657873706F746C696768742D6F70656E2D6469616C6F6722293B242874686973292E63737328226D696E2D686569676874222C226175746F22292E7072657628222E75692D6469616C6F672D7469746C6562617222';
wwv_flow_api.g_varchar2_table(104) := '292E72656D6F766528292C617065782E6E617669676174696F6E2E626567696E467265657A655363726F6C6C28292C2428222E75692D7769646765742D6F7665726C617922292E6F6E2822636C69636B222C66756E6374696F6E28297B742E636C6F7365';
wwv_flow_api.g_varchar2_table(105) := '4469616C6F6728297D297D2C636C6F73653A66756E6374696F6E28297B617065782E6576656E742E747269676765722822626F6479222C226170657873706F746C696768742D636C6F73652D6469616C6F6722292C742E726573657453706F746C696768';
wwv_flow_api.g_varchar2_table(106) := '7428292C617065782E6E617669676174696F6E2E656E64467265657A655363726F6C6C28297D7D297D3B742E674861734469616C6F67437265617465643F6128293A28742E63726561746553706F746C696768744469616C6F6728742E67506C61636568';
wwv_flow_api.g_varchar2_table(107) := '6F6C64657254657874292C6128292C742E67657453706F746C69676874446174612866756E6374696F6E2865297B742E67536561726368496E6465783D242E6772657028652C66756E6374696F6E2865297B72657475726E20303D3D652E737D292C742E';
wwv_flow_api.g_varchar2_table(108) := '67537461746963496E6465783D242E6772657028652C66756E6374696F6E2865297B72657475726E20313D3D652E737D292C617065782E6576656E742E747269676765722822626F6479222C226170657873706F746C696768742D6765742D6461746122';
wwv_flow_api.g_varchar2_table(109) := '2C65297D29292C666F637573456C656D656E743D657D2C6F70656E53706F746C696768744469616C6F674B6579626F61726453686F72746375743A66756E6374696F6E2865297B4D6F757365747261702E73746F7043616C6C6261636B3D66756E637469';
wwv_flow_api.g_varchar2_table(110) := '6F6E28652C742C61297B72657475726E21307D2C4D6F757365747261702E70726F746F747970652E73746F7043616C6C6261636B3D66756E6374696F6E28652C742C61297B72657475726E21317D2C4D6F757365747261702E62696E6428742E674B6579';
wwv_flow_api.g_varchar2_table(111) := '626F61726453686F72746375747341727261792C66756E6374696F6E2861297B612E70726576656E7444656661756C743F612E70726576656E7444656661756C7428293A612E72657475726E56616C75653D21312C742E6F70656E53706F746C69676874';
wwv_flow_api.g_varchar2_table(112) := '4469616C6F672865297D297D2C696E506167655365617263683A66756E6374696F6E2865297B76617220613D657C7C742E674B6579776F7264733B242822626F647922292E756E6D61726B287B646F6E653A66756E6374696F6E28297B742E636C6F7365';
wwv_flow_api.g_varchar2_table(113) := '4469616C6F6728292C742E726573657453706F746C6967687428292C242822626F647922292E6D61726B28612C7B7D292C617065782E6576656E742E747269676765722822626F6479222C226170657873706F746C696768742D696E706167652D736561';
wwv_flow_api.g_varchar2_table(114) := '726368222C7B6B6579776F72643A617D297D7D297D2C706C7567696E48616E646C65723A66756E6374696F6E2865297B76617220613D742E6744796E616D6963416374696F6E49643D652E64796E616D6963416374696F6E49642C693D742E67416A6178';
wwv_flow_api.g_varchar2_table(115) := '4964656E7469666965723D652E616A61784964656E7469666965722C6F3D742E67506C616365686F6C646572546578743D652E706C616365686F6C646572546578742C6E3D742E674D6F72654368617273546578743D652E6D6F72654368617273546578';
wwv_flow_api.g_varchar2_table(116) := '742C723D742E674E6F4D61746368546578743D652E6E6F4D61746368546578742C6C3D742E674F6E654D61746368546578743D652E6F6E654D61746368546578742C733D742E674D756C7469706C654D617463686573546578743D652E6D756C7469706C';
wwv_flow_api.g_varchar2_table(117) := '654D617463686573546578742C673D742E67496E50616765536561726368546578743D652E696E50616765536561726368546578742C703D652E656E61626C654B6579626F61726453686F7274637574732C633D652E6B6579626F61726453686F727463';
wwv_flow_api.g_varchar2_table(118) := '7574732C643D652E7375626D69744974656D732C683D652E656E61626C65496E506167655365617263682C533D742E674D61784E6176526573756C743D652E6D61784E6176526573756C742C753D742E6757696474683D652E77696474682C783D652E65';
wwv_flow_api.g_varchar2_table(119) := '6E61626C654461746143616368652C543D652E73706F746C696768745468656D652C663D652E656E61626C6550726566696C6C53656C6563746564546578742C503D652E73686F7750726F63657373696E673B73776974636828617065782E6465627567';
wwv_flow_api.g_varchar2_table(120) := '2E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D2064796E616D6963416374696F6E4964222C61292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C657220';
wwv_flow_api.g_varchar2_table(121) := '2D20616A61784964656E746966696572222C69292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D20706C616365686F6C64657254657874222C6F292C617065782E64656275672E6C6F';
wwv_flow_api.g_varchar2_table(122) := '6728226170657853706F746C696768742E706C7567696E48616E646C6572202D206D6F7265436861727354657874222C6E292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D206E6F4D';
wwv_flow_api.g_varchar2_table(123) := '6174636854657874222C72292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D206F6E654D6174636854657874222C6C292C617065782E64656275672E6C6F6728226170657853706F74';
wwv_flow_api.g_varchar2_table(124) := '6C696768742E706C7567696E48616E646C6572202D206D756C7469706C654D61746368657354657874222C73292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D20696E506167655365';
wwv_flow_api.g_varchar2_table(125) := '6172636854657874222C67292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D20656E61626C654B6579626F61726453686F727463757473222C70292C617065782E64656275672E6C6F';
wwv_flow_api.g_varchar2_table(126) := '6728226170657853706F746C696768742E706C7567696E48616E646C6572202D206B6579626F61726453686F727463757473222C63292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D';
wwv_flow_api.g_varchar2_table(127) := '207375626D69744974656D73222C64292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D20656E61626C65496E50616765536561726368222C68292C617065782E64656275672E6C6F67';
wwv_flow_api.g_varchar2_table(128) := '28226170657853706F746C696768742E706C7567696E48616E646C6572202D206D61784E6176526573756C74222C53292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D207769647468';
wwv_flow_api.g_varchar2_table(129) := '222C75292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D20656E61626C65446174614361636865222C78292C617065782E64656275672E6C6F6728226170657853706F746C69676874';
wwv_flow_api.g_varchar2_table(130) := '2E706C7567696E48616E646C6572202D2073706F746C696768745468656D65222C54292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D20656E61626C6550726566696C6C53656C6563';
wwv_flow_api.g_varchar2_table(131) := '74656454657874222C66292C617065782E64656275672E6C6F6728226170657853706F746C696768742E706C7567696E48616E646C6572202D2073686F7750726F63657373696E67222C50292C537472696E672E70726F746F747970652E737461727473';
wwv_flow_api.g_varchar2_table(132) := '576974687C7C28537472696E672E70726F746F747970652E737461727473576974683D66756E6374696F6E28652C74297B72657475726E20746869732E7375627374722821747C7C743C303F303A2B742C652E6C656E677468293D3D3D657D292C537472';
wwv_flow_api.g_varchar2_table(133) := '696E672E70726F746F747970652E696E636C756465737C7C28537472696E672E70726F746F747970652E696E636C756465733D66756E6374696F6E28652C74297B2275736520737472696374223B72657475726E226E756D62657222213D747970656F66';
wwv_flow_api.g_varchar2_table(134) := '2074262628743D30292C2128742B652E6C656E6774683E746869732E6C656E6774682926262D31213D3D746869732E696E6465784F6628652C74297D292C742E67456E61626C65496E506167655365617263683D2259223D3D682C742E67456E61626C65';
wwv_flow_api.g_varchar2_table(135) := '4461746143616368653D2259223D3D782C742E67456E61626C6550726566696C6C53656C6563746564546578743D2259223D3D662C742E6753686F7750726F63657373696E673D2259223D3D502C64262628742E675375626D69744974656D7341727261';
wwv_flow_api.g_varchar2_table(136) := '793D642E73706C697428222C2229292C2259223D3D70262628742E674B6579626F61726453686F72746375747341727261793D632E73706C697428222C2229292C54297B63617365224F52414E4745223A742E67526573756C744C6973745468656D6543';
wwv_flow_api.g_varchar2_table(137) := '6C6173733D226170782D53706F746C696768742D726573756C742D6F72616E6765222C742E6749636F6E5468656D65436C6173733D226170782D53706F746C696768742D69636F6E2D6F72616E6765223B627265616B3B6361736522524544223A742E67';
wwv_flow_api.g_varchar2_table(138) := '526573756C744C6973745468656D65436C6173733D226170782D53706F746C696768742D726573756C742D726564222C742E6749636F6E5468656D65436C6173733D226170782D53706F746C696768742D69636F6E2D726564223B627265616B3B636173';
wwv_flow_api.g_varchar2_table(139) := '65224441524B223A742E67526573756C744C6973745468656D65436C6173733D226170782D53706F746C696768742D726573756C742D6461726B222C742E6749636F6E5468656D65436C6173733D226170782D53706F746C696768742D69636F6E2D6461';
wwv_flow_api.g_varchar2_table(140) := '726B227D2259223D3D703F742E6F70656E53706F746C696768744469616C6F674B6579626F61726453686F727463757428293A742E6F70656E53706F746C696768744469616C6F6728297D7D3B742E706C7567696E48616E646C65722865297D7D3B';
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
wwv_flow_api.g_varchar2_table(2) := '73706F746C696768742E6A730A202A2056657273696F6E3A20312E332E350A202A2F0A0A2F2A2A0A202A20457874656E6420617065782E64610A202A2F0A617065782E64612E6170657853706F746C69676874203D207B0A20202F2A2A0A2020202A2050';
wwv_flow_api.g_varchar2_table(3) := '6C7567696E2068616E646C6572202D2063616C6C65642066726F6D20706C7567696E2072656E6465722066756E6374696F6E0A2020202A2040706172616D207B6F626A6563747D20704F7074696F6E730A2020202A2F0A2020706C7567696E48616E646C';
wwv_flow_api.g_varchar2_table(4) := '65723A2066756E6374696F6E28704F7074696F6E7329207B0A202020202F2A2A0A20202020202A204D61696E204E616D6573706163650A20202020202A2F0A20202020766172206170657853706F746C69676874203D207B0A2020202020202F2A2A0A20';
wwv_flow_api.g_varchar2_table(5) := '2020202020202A20436F6E7374616E74730A202020202020202A2F0A202020202020444F543A20272E272C0A20202020202053505F4449414C4F473A20276170782D53706F746C69676874272C0A20202020202053505F494E5055543A20276170782D53';
wwv_flow_api.g_varchar2_table(6) := '706F746C696768742D696E707574272C0A20202020202053505F524553554C54533A20276170782D53706F746C696768742D726573756C7473272C0A20202020202053505F4143544956453A202769732D616374697665272C0A20202020202053505F53';
wwv_flow_api.g_varchar2_table(7) := '484F52544355543A20276170782D53706F746C696768742D73686F7274637574272C0A20202020202053505F414354494F4E5F53484F52544355543A202773706F746C696768742D736561726368272C0A20202020202053505F524553554C545F4C4142';
wwv_flow_api.g_varchar2_table(8) := '454C3A20276170782D53706F746C696768742D6C6162656C272C0A20202020202053505F4C4956455F524547494F4E3A202773702D617269612D6D617463682D666F756E64272C0A20202020202053505F4C4953543A202773702D726573756C742D6C69';
wwv_flow_api.g_varchar2_table(9) := '7374272C0A2020202020204B4559533A20242E75692E6B6579436F64652C0A20202020202055524C5F54595045533A207B0A202020202020202072656469726563743A20277265646972656374272C0A2020202020202020736561726368506167653A20';
wwv_flow_api.g_varchar2_table(10) := '277365617263682D70616765270A2020202020207D2C0A20202020202049434F4E533A207B0A2020202020202020706167653A202766612D77696E646F772D736561726368272C0A20202020202020207365617263683A202769636F6E2D736561726368';
wwv_flow_api.g_varchar2_table(11) := '270A2020202020207D2C0A2020202020202F2A2A0A202020202020202A20676C6F62616C20766172730A202020202020202A2F0A202020202020674D61784E6176526573756C743A2035302C0A2020202020206757696474683A203635302C0A20202020';
wwv_flow_api.g_varchar2_table(12) := '2020674861734469616C6F67437265617465643A2066616C73652C0A20202020202067536561726368496E6465783A205B5D2C0A20202020202067537461746963496E6465783A205B5D2C0A202020202020674B6579776F7264733A2027272C0A202020';
wwv_flow_api.g_varchar2_table(13) := '20202067416A61784964656E7469666965723A206E756C6C2C0A20202020202067506C616365686F6C646572546578743A206E756C6C2C0A202020202020674D6F72654368617273546578743A206E756C6C2C0A202020202020674E6F4D617463685465';
wwv_flow_api.g_varchar2_table(14) := '78743A206E756C6C2C0A202020202020674F6E654D61746368546578743A206E756C6C2C0A202020202020674D756C7469706C654D617463686573546578743A206E756C6C2C0A20202020202067496E50616765536561726368546578743A206E756C6C';
wwv_flow_api.g_varchar2_table(15) := '2C0A20202020202067456E61626C65496E506167655365617263683A20747275652C0A20202020202067456E61626C654461746143616368653A2066616C73652C0A20202020202067456E61626C6550726566696C6C53656C6563746564546578743A20';
wwv_flow_api.g_varchar2_table(16) := '66616C73652C0A202020202020675375626D69744974656D7341727261793A205B5D2C0A202020202020674B6579626F61726453686F72746375747341727261793A205B5D2C0A20202020202067526573756C744C6973745468656D65436C6173733A20';
wwv_flow_api.g_varchar2_table(17) := '27272C0A2020202020206749636F6E5468656D65436C6173733A2027272C0A2020202020206753686F7750726F63657373696E673A2066616C73652C0A2020202020202F2A2A0A202020202020202A20476574204A534F4E20636F6E7461696E696E6720';
wwv_flow_api.g_varchar2_table(18) := '6461746120666F722073706F746C696768742073656172636820656E74726965732066726F6D2044420A202020202020202A2040706172616D207B66756E6374696F6E7D2063616C6C6261636B0A202020202020202A2F0A20202020202067657453706F';
wwv_flow_api.g_varchar2_table(19) := '746C69676874446174613A2066756E6374696F6E2863616C6C6261636B29207B0A2020202020202020766172206361636865446174613B0A2020202020202020696620286170657853706F746C696768742E67456E61626C654461746143616368652920';
wwv_flow_api.g_varchar2_table(20) := '7B0A20202020202020202020636163686544617461203D206170657853706F746C696768742E67657453706F746C696768744461746153657373696F6E53746F7261676528293B0A202020202020202020206966202863616368654461746129207B0A20';
wwv_flow_api.g_varchar2_table(21) := '202020202020202020202063616C6C6261636B284A534F4E2E70617273652863616368654461746129293B0A20202020202020202020202072657475726E3B0A202020202020202020207D0A20202020202020207D0A2020202020202020747279207B0A';
wwv_flow_api.g_varchar2_table(22) := '202020202020202020206170657853706F746C696768742E73686F77576169745370696E6E657228293B0A20202020202020202020617065782E7365727665722E706C7567696E286170657853706F746C696768742E67416A61784964656E7469666965';
wwv_flow_api.g_varchar2_table(23) := '722C207B0A202020202020202020202020706167654974656D733A206170657853706F746C696768742E675375626D69744974656D7341727261792C0A2020202020202020202020207830313A20274745545F44415441270A202020202020202020207D';
wwv_flow_api.g_varchar2_table(24) := '2C207B0A20202020202020202020202064617461547970653A20276A736F6E272C0A202020202020202020202020737563636573733A2066756E6374696F6E286461746129207B0A2020202020202020202020202020617065782E6576656E742E747269';
wwv_flow_api.g_varchar2_table(25) := '676765722827626F6479272C20276170657873706F746C696768742D616A61782D73756363657373272C2064617461293B0A2020202020202020202020202020617065782E64656275672E6C6F6728226170657853706F746C696768742E67657453706F';
wwv_flow_api.g_varchar2_table(26) := '746C696768744461746120414A41582053756363657373222C2064617461293B0A2020202020202020202020202020696620286170657853706F746C696768742E67456E61626C6544617461436163686529207B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(27) := '206170657853706F746C696768742E73657453706F746C696768744461746153657373696F6E53746F72616765284A534F4E2E737472696E67696679286461746129293B0A20202020202020202020202020207D0A202020202020202020202020202061';
wwv_flow_api.g_varchar2_table(28) := '70657853706F746C696768742E68696465576169745370696E6E657228293B0A202020202020202020202020202063616C6C6261636B2864617461293B0A2020202020202020202020207D2C0A2020202020202020202020206572726F723A2066756E63';
wwv_flow_api.g_varchar2_table(29) := '74696F6E286A715848522C20746578745374617475732C206572726F725468726F776E29207B0A2020202020202020202020202020617065782E6576656E742E747269676765722827626F6479272C20276170657873706F746C696768742D616A61782D';
wwv_flow_api.g_varchar2_table(30) := '6572726F72272C207B0A20202020202020202020202020202020226D657373616765223A206572726F725468726F776E0A20202020202020202020202020207D293B0A2020202020202020202020202020617065782E64656275672E6C6F672822617065';
wwv_flow_api.g_varchar2_table(31) := '7853706F746C696768742E67657453706F746C696768744461746120414A4158204572726F72222C206572726F725468726F776E293B0A20202020202020202020202020206170657853706F746C696768742E68696465576169745370696E6E65722829';
wwv_flow_api.g_varchar2_table(32) := '3B0A202020202020202020202020202063616C6C6261636B285B5D293B0A2020202020202020202020207D0A202020202020202020207D293B0A20202020202020207D206361746368202865727229207B0A20202020202020202020617065782E657665';
wwv_flow_api.g_varchar2_table(33) := '6E742E747269676765722827626F6479272C20276170657873706F746C696768742D616A61782D6572726F72272C207B0A202020202020202020202020226D657373616765223A206572720A202020202020202020207D293B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(34) := '617065782E64656275672E6C6F6728226170657853706F746C696768742E67657453706F746C696768744461746120414A4158204572726F72222C20657272293B0A202020202020202020206170657853706F746C696768742E68696465576169745370';
wwv_flow_api.g_varchar2_table(35) := '696E6E657228293B0A2020202020202020202063616C6C6261636B285B5D293B0A20202020202020207D0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A20476574204A534F4E20636F6E7461696E696E67205353502055524C2077';
wwv_flow_api.g_varchar2_table(36) := '697468207265706C6163656420736561726368206B6579776F72642076616C756520287E5345415243485F56414C55457E20737562737469747574696F6E20737472696E67290A202020202020202A2040706172616D207B737472696E677D207055726C';
wwv_flow_api.g_varchar2_table(37) := '0A202020202020202A2040706172616D207B66756E6374696F6E7D2063616C6C6261636B0A202020202020202A2F0A20202020202067657450726F7065724170657855726C3A2066756E6374696F6E287055726C2C2063616C6C6261636B29207B0A2020';
wwv_flow_api.g_varchar2_table(38) := '202020202020747279207B0A20202020202020202020617065782E7365727665722E706C7567696E286170657853706F746C696768742E67416A61784964656E7469666965722C207B0A2020202020202020202020207830313A20274745545F55524C27';
wwv_flow_api.g_varchar2_table(39) := '2C0A2020202020202020202020207830323A206170657853706F746C696768742E674B6579776F7264732C0A2020202020202020202020207830333A207055726C0A202020202020202020207D2C207B0A20202020202020202020202064617461547970';
wwv_flow_api.g_varchar2_table(40) := '653A20276A736F6E272C0A202020202020202020202020737563636573733A2066756E6374696F6E286461746129207B0A2020202020202020202020202020617065782E64656275672E6C6F6728226170657853706F746C696768742E67657450726F70';
wwv_flow_api.g_varchar2_table(41) := '65724170657855726C20414A41582053756363657373222C2064617461293B0A202020202020202020202020202063616C6C6261636B2864617461293B0A2020202020202020202020207D2C0A2020202020202020202020206572726F723A2066756E63';
wwv_flow_api.g_varchar2_table(42) := '74696F6E286A715848522C20746578745374617475732C206572726F725468726F776E29207B0A2020202020202020202020202020617065782E64656275672E6C6F6728226170657853706F746C696768742E67657450726F7065724170657855726C20';
wwv_flow_api.g_varchar2_table(43) := '414A4158204572726F72222C206572726F725468726F776E293B0A202020202020202020202020202063616C6C6261636B287B0A202020202020202020202020202020202275726C223A207055726C0A20202020202020202020202020207D293B0A2020';
wwv_flow_api.g_varchar2_table(44) := '202020202020202020207D0A202020202020202020207D293B0A20202020202020207D206361746368202865727229207B0A20202020202020202020617065782E64656275672E6C6F6728226170657853706F746C696768742E67657450726F70657241';
wwv_flow_api.g_varchar2_table(45) := '70657855726C20414A4158204572726F72222C20657272293B0A2020202020202020202063616C6C6261636B287B0A2020202020202020202020202275726C223A207055726C0A202020202020202020207D293B0A20202020202020207D0A2020202020';
wwv_flow_api.g_varchar2_table(46) := '207D2C0A2020202020202F2A2A0A202020202020202A2053617665204A534F4E204461746120696E206C6F63616C2073657373696F6E2073746F72616765206F662062726F7773657220286170657853706F746C696768742E3C6170705F69643E2E6461';
wwv_flow_api.g_varchar2_table(47) := '7461290A202020202020202A2040706172616D207B6F626A6563747D2070446174610A202020202020202A2F0A20202020202073657453706F746C696768744461746153657373696F6E53746F726167653A2066756E6374696F6E28704461746129207B';
wwv_flow_api.g_varchar2_table(48) := '0A20202020202020207661722068617353657373696F6E53746F72616765537570706F7274203D20617065782E73746F726167652E68617353657373696F6E53746F72616765537570706F72743B0A0A2020202020202020696620286861735365737369';
wwv_flow_api.g_varchar2_table(49) := '6F6E53746F72616765537570706F727429207B0A20202020202020202020766172206170657853657373696F6E203D202476282770496E7374616E636527293B0A202020202020202020207661722073657373696F6E53746F72616765203D2061706578';
wwv_flow_api.g_varchar2_table(50) := '2E73746F726167652E67657453636F70656453657373696F6E53746F72616765287B0A2020202020202020202020207072656669783A20276170657853706F746C69676874272C0A20202020202020202020202075736541707049643A20747275650A20';
wwv_flow_api.g_varchar2_table(51) := '2020202020202020207D293B0A0A2020202020202020202073657373696F6E53746F726167652E7365744974656D286170657853657373696F6E202B20272E64617461272C207044617461293B0A20202020202020207D0A2020202020207D2C0A202020';
wwv_flow_api.g_varchar2_table(52) := '2020202F2A2A0A202020202020202A20476574204A534F4E20446174612066726F6D206C6F63616C2073657373696F6E2073746F72616765206F662062726F7773657220286170657853706F746C696768742E3C6170705F69643E2E64617461290A2020';
wwv_flow_api.g_varchar2_table(53) := '20202020202A2F0A20202020202067657453706F746C696768744461746153657373696F6E53746F726167653A2066756E6374696F6E2829207B0A20202020202020207661722068617353657373696F6E53746F72616765537570706F7274203D206170';
wwv_flow_api.g_varchar2_table(54) := '65782E73746F726167652E68617353657373696F6E53746F72616765537570706F72743B0A0A20202020202020207661722073746F7261676556616C75653B0A20202020202020206966202868617353657373696F6E53746F72616765537570706F7274';
wwv_flow_api.g_varchar2_table(55) := '29207B0A20202020202020202020766172206170657853657373696F6E203D202476282770496E7374616E636527293B0A202020202020202020207661722073657373696F6E53746F72616765203D20617065782E73746F726167652E67657453636F70';
wwv_flow_api.g_varchar2_table(56) := '656453657373696F6E53746F72616765287B0A2020202020202020202020207072656669783A20276170657853706F746C69676874272C0A20202020202020202020202075736541707049643A20747275650A202020202020202020207D293B0A0A2020';
wwv_flow_api.g_varchar2_table(57) := '202020202020202073746F7261676556616C7565203D2073657373696F6E53746F726167652E6765744974656D286170657853657373696F6E202B20272E6461746127293B0A20202020202020207D0A202020202020202072657475726E2073746F7261';
wwv_flow_api.g_varchar2_table(58) := '676556616C75653B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A2053686F772077616974207370696E6E657220746F2073686F772070726F6772657373206F6620414A41582063616C6C0A202020202020202A2F0A2020202020';
wwv_flow_api.g_varchar2_table(59) := '2073686F77576169745370696E6E65723A2066756E6374696F6E2829207B0A2020202020202020696620286170657853706F746C696768742E6753686F7750726F63657373696E6729207B0A202020202020202020202428276469762E6170782D53706F';
wwv_flow_api.g_varchar2_table(60) := '746C696768742D69636F6E207370616E27292E72656D6F7665436C61737328292E616464436C617373282766612066612D726566726573682066612D616E696D2D7370696E27293B0A20202020202020207D0A2020202020207D2C0A2020202020202F2A';
wwv_flow_api.g_varchar2_table(61) := '2A0A202020202020202A20486964652077616974207370696E6E657220616E6420646973706C61792064656661756C74207365617263682069636F6E0A202020202020202A2F0A20202020202068696465576169745370696E6E65723A2066756E637469';
wwv_flow_api.g_varchar2_table(62) := '6F6E2829207B0A2020202020202020696620286170657853706F746C696768742E6753686F7750726F63657373696E6729207B0A202020202020202020202428276469762E6170782D53706F746C696768742D69636F6E207370616E27292E72656D6F76';
wwv_flow_api.g_varchar2_table(63) := '65436C61737328292E616464436C6173732827612D49636F6E2069636F6E2D73656172636827293B0A20202020202020207D0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A204765742074657874206F662073656C656374656420';
wwv_flow_api.g_varchar2_table(64) := '74657874206F6E20646F63756D656E740A202020202020202A2F0A20202020202067657453656C6563746564546578743A2066756E6374696F6E2829207B0A20202020202020207661722072616E67653B0A20202020202020206966202877696E646F77';
wwv_flow_api.g_varchar2_table(65) := '2E67657453656C656374696F6E29207B0A2020202020202020202072616E6765203D2077696E646F772E67657453656C656374696F6E28293B0A2020202020202020202072657475726E2072616E67652E746F537472696E6728292E7472696D28293B0A';
wwv_flow_api.g_varchar2_table(66) := '20202020202020207D20656C7365207B0A2020202020202020202069662028646F63756D656E742E73656C656374696F6E2E63726561746552616E676529207B0A20202020202020202020202072616E6765203D20646F63756D656E742E73656C656374';
wwv_flow_api.g_varchar2_table(67) := '696F6E2E63726561746552616E676528293B0A20202020202020202020202072657475726E2072616E67652E746578742E7472696D28293B0A202020202020202020207D0A20202020202020207D0A2020202020207D2C0A2020202020202F2A2A0A2020';
wwv_flow_api.g_varchar2_table(68) := '20202020202A2046657463682073656C6563746564207465787420616E642073657420697420746F2073706F746C696768742073656172636820696E7075740A202020202020202A2F0A20202020202073657453656C6563746564546578743A2066756E';
wwv_flow_api.g_varchar2_table(69) := '6374696F6E2829207B0A20202020202020202F2F206765742073656C656374656420746578740A20202020202020207661722073656C656374656454657874203D206170657853706F746C696768742E67657453656C65637465645465787428293B0A0A';
wwv_flow_api.g_varchar2_table(70) := '20202020202020202F2F207365742073656C6563746564207465787420746F2073706F746C6967687420696E7075740A20202020202020206966202873656C65637465645465787429207B0A202020202020202020202F2F206966206469616C6F672026';
wwv_flow_api.g_varchar2_table(71) := '206461746120616C72656164792074686572650A20202020202020202020696620286170657853706F746C696768742E674861734469616C6F674372656174656429207B0A20202020202020202020202024286170657853706F746C696768742E444F54';
wwv_flow_api.g_varchar2_table(72) := '202B206170657853706F746C696768742E53505F494E505554292E76616C2873656C656374656454657874292E747269676765722827696E70757427293B0A2020202020202020202020202F2F206469616C6F672068617320746F206265206F70656E65';
wwv_flow_api.g_varchar2_table(73) := '6420262064617461206D75737420626520666574636865640A202020202020202020207D20656C7365207B0A2020202020202020202020202F2F206E6F7420756E74696C206461746120686173206265656E20696E20706C6163650A2020202020202020';
wwv_flow_api.g_varchar2_table(74) := '20202020242827626F647927292E6F6E28276170657873706F746C696768742D6765742D64617461272C2066756E6374696F6E2829207B0A202020202020202020202020202024286170657853706F746C696768742E444F54202B206170657853706F74';
wwv_flow_api.g_varchar2_table(75) := '6C696768742E53505F494E505554292E76616C2873656C656374656454657874292E747269676765722827696E70757427293B0A2020202020202020202020207D293B0A202020202020202020207D0A20202020202020207D0A2020202020207D2C0A20';
wwv_flow_api.g_varchar2_table(76) := '20202020202F2A2A0A202020202020202A2048616E646C65206172696120617474726962757465730A202020202020202A2F0A20202020202068616E646C6541726961417474723A2066756E6374696F6E2829207B0A2020202020202020766172207265';
wwv_flow_api.g_varchar2_table(77) := '73756C747324203D2024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F524553554C5453292C0A20202020202020202020696E70757424203D2024286170657853706F746C696768742E444F54202B2061';
wwv_flow_api.g_varchar2_table(78) := '70657853706F746C696768742E53505F494E505554292C0A202020202020202020206163746976654964203D20726573756C7473242E66696E64286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F41435449';
wwv_flow_api.g_varchar2_table(79) := '5645292E66696E64286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F524553554C545F4C4142454C292E617474722827696427292C0A20202020202020202020616374697665456C656D24203D2024282723';
wwv_flow_api.g_varchar2_table(80) := '27202B206163746976654964292C0A2020202020202020202061637469766554657874203D20616374697665456C656D242E7465787428292C0A202020202020202020206C697324203D20726573756C7473242E66696E6428276C6927292C0A20202020';
wwv_flow_api.g_varchar2_table(81) := '2020202020206973457870616E646564203D206C6973242E6C656E67746820213D3D20302C0A202020202020202020206C69766554657874203D2027272C0A20202020202020202020726573756C7473436F756E74203D206C6973242E66696C74657228';
wwv_flow_api.g_varchar2_table(82) := '66756E6374696F6E2829207B0A2020202020202020202020202F2F204578636C7564652074686520676C6F62616C20696E736572746564203C6C693E2C207768696368206861732073686F727463757473204374726C202B20312C20322C20330A202020';
wwv_flow_api.g_varchar2_table(83) := '2020202020202020202F2F2073756368206173202253656172636820576F726B737061636520666F722078222E0A20202020202020202020202072657475726E20242874686973292E66696E64286170657853706F746C696768742E444F54202B206170';
wwv_flow_api.g_varchar2_table(84) := '657853706F746C696768742E53505F53484F5254435554292E6C656E677468203D3D3D20303B0A202020202020202020207D292E6C656E6774683B0A0A202020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C';
wwv_flow_api.g_varchar2_table(85) := '696768742E53505F524553554C545F4C4142454C290A202020202020202020202E617474722827617269612D73656C6563746564272C202766616C736527293B0A0A2020202020202020616374697665456C656D240A202020202020202020202E617474';
wwv_flow_api.g_varchar2_table(86) := '722827617269612D73656C6563746564272C20277472756527293B0A0A2020202020202020696620286170657853706F746C696768742E674B6579776F726473203D3D3D20272729207B0A202020202020202020206C69766554657874203D2061706578';
wwv_flow_api.g_varchar2_table(87) := '53706F746C696768742E67506C616365686F6C646572546578743B0A20202020202020207D20656C73652069662028726573756C7473436F756E74203D3D3D203029207B0A202020202020202020206C69766554657874203D206170657853706F746C69';
wwv_flow_api.g_varchar2_table(88) := '6768742E674E6F4D61746368546578743B0A20202020202020207D20656C73652069662028726573756C7473436F756E74203D3D3D203129207B0A202020202020202020206C69766554657874203D206170657853706F746C696768742E674F6E654D61';
wwv_flow_api.g_varchar2_table(89) := '746368546578743B0A20202020202020207D20656C73652069662028726573756C7473436F756E74203E203129207B0A202020202020202020206C69766554657874203D20726573756C7473436F756E74202B20272027202B206170657853706F746C69';
wwv_flow_api.g_varchar2_table(90) := '6768742E674D756C7469706C654D617463686573546578743B0A20202020202020207D0A0A20202020202020206C69766554657874203D2061637469766554657874202B20272C2027202B206C697665546578743B0A0A20202020202020202428272327';
wwv_flow_api.g_varchar2_table(91) := '202B206170657853706F746C696768742E53505F4C4956455F524547494F4E292E74657874286C69766554657874293B0A0A2020202020202020696E707574240A202020202020202020202F2F202E706172656E74282920202F2F206172696120312E31';
wwv_flow_api.g_varchar2_table(92) := '207061747465726E0A202020202020202020202E617474722827617269612D61637469766564657363656E64616E74272C206163746976654964290A202020202020202020202E617474722827617269612D657870616E646564272C206973457870616E';
wwv_flow_api.g_varchar2_table(93) := '646564293B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A20436C6F7365206D6F64616C2073706F746C69676874206469616C6F670A202020202020202A2F0A202020202020636C6F73654469616C6F673A2066756E6374696F6E';
wwv_flow_api.g_varchar2_table(94) := '2829207B0A202020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F47292E6469616C6F672827636C6F736527293B0A2020202020207D2C0A2020202020202F2A2A0A20202020';
wwv_flow_api.g_varchar2_table(95) := '2020202A2052657365742073706F746C696768740A202020202020202A2F0A202020202020726573657453706F746C696768743A2066756E6374696F6E2829207B0A20202020202020202428272327202B206170657853706F746C696768742E53505F4C';
wwv_flow_api.g_varchar2_table(96) := '495354292E656D70747928293B0A202020202020202024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E76616C282727292E666F63757328293B0A20202020202020206170657853706F';
wwv_flow_api.g_varchar2_table(97) := '746C696768742E674B6579776F726473203D2027273B0A20202020202020206170657853706F746C696768742E68616E646C65417269614174747228293B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A204E617669676174696F';
wwv_flow_api.g_varchar2_table(98) := '6E20746F2074617267657420776869636820697320636F6E7461696E656420696E20656C656D2420283C613E206C696E6B290A202020202020202A2040706172616D207B6F626A6563747D20656C656D240A202020202020202A2040706172616D207B6F';
wwv_flow_api.g_varchar2_table(99) := '626A6563747D206576656E740A202020202020202A2F0A202020202020676F546F3A2066756E6374696F6E28656C656D242C206576656E7429207B0A20202020202020207661722075726C203D20656C656D242E64617461282775726C27292C0A202020';
wwv_flow_api.g_varchar2_table(100) := '2020202020202074797065203D20656C656D242E6461746128277479706527293B0A0A202020202020202073776974636820287479706529207B0A2020202020202020202063617365206170657853706F746C696768742E55524C5F54595045532E7365';
wwv_flow_api.g_varchar2_table(101) := '61726368506167653A0A2020202020202020202020206170657853706F746C696768742E696E5061676553656172636828293B0A202020202020202020202020627265616B3B0A0A2020202020202020202063617365206170657853706F746C69676874';
wwv_flow_api.g_varchar2_table(102) := '2E55524C5F54595045532E72656469726563743A0A2020202020202020202020202F2F207265706C616365207E5345415243485F56414C55457E20737562737469747574696F6E20737472696E670A2020202020202020202020206966202875726C2E69';
wwv_flow_api.g_varchar2_table(103) := '6E636C7564657328277E5345415243485F56414C55457E272929207B0A20202020202020202020202020202F2F2065736361706520736F6D652070726F626C656D61746963206368617273203A2C22270A20202020202020202020202020206170657853';
wwv_flow_api.g_varchar2_table(104) := '706F746C696768742E674B6579776F726473203D206170657853706F746C696768742E674B6579776F7264732E7265706C616365282F3A7C2C7C227C272F672C20272027292E7472696D28293B0A20202020202020202020202020202F2F207365727665';
wwv_flow_api.g_varchar2_table(105) := '72207369646520696620415045582055524C2069732064657465637465640A20202020202020202020202020206966202875726C2E737461727473576974682827663F703D272929207B0A202020202020202020202020202020206170657853706F746C';
wwv_flow_api.g_varchar2_table(106) := '696768742E67657450726F7065724170657855726C2875726C2C2066756E6374696F6E286461746129207B0A202020202020202020202020202020202020617065782E6E617669676174696F6E2E726564697265637428646174612E75726C293B0A2020';
wwv_flow_api.g_varchar2_table(107) := '20202020202020202020202020207D293B0A202020202020202020202020202020202F2F20636C69656E74207369646520666F7220616C6C206F746865722055524C730A20202020202020202020202020207D20656C7365207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(108) := '2020202020202075726C203D2075726C2E7265706C61636528277E5345415243485F56414C55457E272C206170657853706F746C696768742E674B6579776F726473293B0A20202020202020202020202020202020617065782E6E617669676174696F6E';
wwv_flow_api.g_varchar2_table(109) := '2E72656469726563742875726C293B0A20202020202020202020202020207D0A20202020202020202020202020202F2F206E6F726D616C2055524C20776974686F757420737562737469747574696F6E20737472696E670A202020202020202020202020';
wwv_flow_api.g_varchar2_table(110) := '7D20656C7365207B0A2020202020202020202020202020617065782E6E617669676174696F6E2E72656469726563742875726C293B0A2020202020202020202020207D0A202020202020202020202020627265616B3B0A20202020202020207D0A0A2020';
wwv_flow_api.g_varchar2_table(111) := '2020202020206170657853706F746C696768742E636C6F73654469616C6F6728293B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A204765742048544D4C206D61726B75700A202020202020202A2040706172616D207B6F626A65';
wwv_flow_api.g_varchar2_table(112) := '63747D20646174610A202020202020202A2F0A2020202020206765744D61726B75703A2066756E6374696F6E286461746129207B0A2020202020202020766172207469746C65203D20646174612E7469746C652C0A202020202020202020206465736320';
wwv_flow_api.g_varchar2_table(113) := '3D20646174612E64657363207C7C2027272C0A2020202020202020202075726C203D20646174612E75726C2C0A2020202020202020202074797065203D20646174612E747970652C0A2020202020202020202069636F6E203D20646174612E69636F6E2C';
wwv_flow_api.g_varchar2_table(114) := '0A2020202020202020202073686F7274637574203D20646174612E73686F72746375742C0A2020202020202020202073686F72746375744D61726B7570203D2073686F7274637574203F20273C7370616E20636C6173733D2227202B206170657853706F';
wwv_flow_api.g_varchar2_table(115) := '746C696768742E53505F53484F5254435554202B202722203E27202B2073686F7274637574202B20273C2F7370616E3E27203A2027272C0A202020202020202020206461746141747472203D2027272C0A2020202020202020202069636F6E537472696E';
wwv_flow_api.g_varchar2_table(116) := '67203D2027272C0A202020202020202020206F75743B0A0A20202020202020206966202875726C203D3D3D2030207C7C2075726C29207B0A202020202020202020206461746141747472203D2027646174612D75726C3D2227202B2075726C202B202722';
wwv_flow_api.g_varchar2_table(117) := '20273B0A20202020202020207D0A0A2020202020202020696620287479706529207B0A202020202020202020206461746141747472203D206461746141747472202B202720646174612D747970653D2227202B2074797065202B20272220273B0A202020';
wwv_flow_api.g_varchar2_table(118) := '20202020207D0A0A20202020202020206966202869636F6E2E73746172747357697468282766612D272929207B0A2020202020202020202069636F6E537472696E67203D202766612027202B2069636F6E3B0A20202020202020207D20656C7365206966';
wwv_flow_api.g_varchar2_table(119) := '202869636F6E2E73746172747357697468282769636F6E2D272929207B0A2020202020202020202069636F6E537472696E67203D2027612D49636F6E2027202B2069636F6E3B0A20202020202020207D20656C7365207B0A202020202020202020206963';
wwv_flow_api.g_varchar2_table(120) := '6F6E537472696E67203D2027612D49636F6E2069636F6E2D736561726368273B0A20202020202020207D0A0A20202020202020206F7574203D20273C6C6920636C6173733D226170782D53706F746C696768742D726573756C742027202B206170657853';
wwv_flow_api.g_varchar2_table(121) := '706F746C696768742E67526573756C744C6973745468656D65436C617373202B2027206170782D53706F746C696768742D726573756C742D2D70616765223E27202B0A20202020202020202020273C7370616E20636C6173733D226170782D53706F746C';
wwv_flow_api.g_varchar2_table(122) := '696768742D6C696E6B222027202B206461746141747472202B20273E27202B0A20202020202020202020273C7370616E20636C6173733D226170782D53706F746C696768742D69636F6E2027202B206170657853706F746C696768742E6749636F6E5468';
wwv_flow_api.g_varchar2_table(123) := '656D65436C617373202B20272220617269612D68696464656E3D2274727565223E27202B0A20202020202020202020273C7370616E20636C6173733D2227202B2069636F6E537472696E67202B2027223E3C2F7370616E3E27202B0A2020202020202020';
wwv_flow_api.g_varchar2_table(124) := '2020273C2F7370616E3E27202B0A20202020202020202020273C7370616E20636C6173733D226170782D53706F746C696768742D696E666F223E27202B0A20202020202020202020273C7370616E20636C6173733D2227202B206170657853706F746C69';
wwv_flow_api.g_varchar2_table(125) := '6768742E53505F524553554C545F4C4142454C202B20272220726F6C653D226F7074696F6E223E27202B207469746C65202B20273C2F7370616E3E27202B0A20202020202020202020273C7370616E20636C6173733D226170782D53706F746C69676874';
wwv_flow_api.g_varchar2_table(126) := '2D64657363223E27202B2064657363202B20273C2F7370616E3E27202B0A20202020202020202020273C2F7370616E3E27202B0A2020202020202020202073686F72746375744D61726B7570202B0A20202020202020202020273C2F7370616E3E27202B';
wwv_flow_api.g_varchar2_table(127) := '0A20202020202020202020273C2F6C693E273B0A0A202020202020202072657475726E206F75743B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A205075736820737461746963206C69737420656E747269657320746F20726573';
wwv_flow_api.g_varchar2_table(128) := '756C747365740A202020202020202A2040706172616D207B61727261797D20726573756C74730A202020202020202A2F0A202020202020726573756C74734164644F6E733A2066756E6374696F6E28726573756C747329207B0A0A202020202020202076';
wwv_flow_api.g_varchar2_table(129) := '61722073686F7274637574436F756E746572203D20303B0A0A2020202020202020696620286170657853706F746C696768742E67456E61626C65496E5061676553656172636829207B0A20202020202020202020726573756C74732E70757368287B0A20';
wwv_flow_api.g_varchar2_table(130) := '20202020202020202020206E3A206170657853706F746C696768742E67496E50616765536561726368546578742C0A202020202020202020202020753A2027272C0A202020202020202020202020693A206170657853706F746C696768742E49434F4E53';
wwv_flow_api.g_varchar2_table(131) := '2E706167652C0A202020202020202020202020743A206170657853706F746C696768742E55524C5F54595045532E736561726368506167652C0A20202020202020202020202073686F72746375743A20274374726C202B2031270A202020202020202020';
wwv_flow_api.g_varchar2_table(132) := '207D293B0A2020202020202020202073686F7274637574436F756E746572203D2073686F7274637574436F756E746572202B20313B0A20202020202020207D0A0A2020202020202020666F7220287661722069203D20303B2069203C206170657853706F';
wwv_flow_api.g_varchar2_table(133) := '746C696768742E67537461746963496E6465782E6C656E6774683B20692B2B29207B0A2020202020202020202073686F7274637574436F756E746572203D2073686F7274637574436F756E746572202B20313B0A20202020202020202020696620287368';
wwv_flow_api.g_varchar2_table(134) := '6F7274637574436F756E746572203E203929207B0A202020202020202020202020726573756C74732E70757368287B0A20202020202020202020202020206E3A206170657853706F746C696768742E67537461746963496E6465785B695D2E6E2C0A2020';
wwv_flow_api.g_varchar2_table(135) := '202020202020202020202020643A206170657853706F746C696768742E67537461746963496E6465785B695D2E642C0A2020202020202020202020202020753A206170657853706F746C696768742E67537461746963496E6465785B695D2E752C0A2020';
wwv_flow_api.g_varchar2_table(136) := '202020202020202020202020693A206170657853706F746C696768742E67537461746963496E6465785B695D2E692C0A2020202020202020202020202020743A206170657853706F746C696768742E67537461746963496E6465785B695D2E740A202020';
wwv_flow_api.g_varchar2_table(137) := '2020202020202020207D293B0A202020202020202020207D20656C7365207B0A202020202020202020202020726573756C74732E70757368287B0A20202020202020202020202020206E3A206170657853706F746C696768742E67537461746963496E64';
wwv_flow_api.g_varchar2_table(138) := '65785B695D2E6E2C0A2020202020202020202020202020643A206170657853706F746C696768742E67537461746963496E6465785B695D2E642C0A2020202020202020202020202020753A206170657853706F746C696768742E67537461746963496E64';
wwv_flow_api.g_varchar2_table(139) := '65785B695D2E752C0A2020202020202020202020202020693A206170657853706F746C696768742E67537461746963496E6465785B695D2E692C0A2020202020202020202020202020743A206170657853706F746C696768742E67537461746963496E64';
wwv_flow_api.g_varchar2_table(140) := '65785B695D2E742C0A202020202020202020202020202073686F72746375743A20274374726C202B2027202B2073686F7274637574436F756E7465720A2020202020202020202020207D293B0A202020202020202020207D0A20202020202020207D0A0A';
wwv_flow_api.g_varchar2_table(141) := '202020202020202072657475726E20726573756C74733B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A20536561726368204E617669676174696F6E0A202020202020202A2040706172616D207B61727261797D20706174746572';
wwv_flow_api.g_varchar2_table(142) := '6E730A202020202020202A2F0A2020202020207365617263684E61763A2066756E6374696F6E287061747465726E7329207B0A2020202020202020766172206E6176526573756C7473203D205B5D2C0A20202020202020202020686173526573756C7473';
wwv_flow_api.g_varchar2_table(143) := '203D2066616C73652C0A202020202020202020207061747465726E2C0A202020202020202020207061747465726E4C656E677468203D207061747465726E732E6C656E6774682C0A20202020202020202020693B0A0A2020202020202020766172206E61';
wwv_flow_api.g_varchar2_table(144) := '72726F776564536574203D2066756E6374696F6E2829207B0A2020202020202020202072657475726E20686173526573756C7473203F206E6176526573756C7473203A206170657853706F746C696768742E67536561726368496E6465783B0A20202020';
wwv_flow_api.g_varchar2_table(145) := '202020207D3B0A0A20202020202020207661722067657453636F7265203D2066756E6374696F6E28706F732C20776F726473436F756E742C2066756C6C54787429207B0A202020202020202020207661722073636F7265203D203130302C0A2020202020';
wwv_flow_api.g_varchar2_table(146) := '20202020202020737061636573203D20776F726473436F756E74202D20312C0A202020202020202020202020706F736974696F6E4F6657686F6C654B6579776F7264733B0A0A2020202020202020202069662028706F73203D3D3D203020262620737061';
wwv_flow_api.g_varchar2_table(147) := '636573203D3D3D203029207B0A2020202020202020202020202F2F2070657266656374206D617463682028206D6174636865642066726F6D20746865206669727374206C65747465722077697468206E6F20737061636520290A20202020202020202020';
wwv_flow_api.g_varchar2_table(148) := '202072657475726E2073636F72653B0A202020202020202020207D20656C7365207B0A2020202020202020202020202F2F207768656E20736561726368202773716C2063272C202753514C20436F6D6D616E6473272073686F756C642073636F72652068';
wwv_flow_api.g_varchar2_table(149) := '6967686572207468616E202753514C2053637269707473270A2020202020202020202020202F2F207768656E207365617263682027736372697074272C202753637269707420506C616E6E6572272073686F756C642073636F7265206869676865722074';
wwv_flow_api.g_varchar2_table(150) := '68616E202753514C2053637269707473270A202020202020202020202020706F736974696F6E4F6657686F6C654B6579776F726473203D2066756C6C5478742E696E6465784F66286170657853706F746C696768742E674B6579776F726473293B0A2020';
wwv_flow_api.g_varchar2_table(151) := '2020202020202020202069662028706F736974696F6E4F6657686F6C654B6579776F726473203D3D3D202D3129207B0A202020202020202020202020202073636F7265203D2073636F7265202D20706F73202D20737061636573202D20776F726473436F';
wwv_flow_api.g_varchar2_table(152) := '756E743B0A2020202020202020202020207D20656C7365207B0A202020202020202020202020202073636F7265203D2073636F7265202D20706F736974696F6E4F6657686F6C654B6579776F7264733B0A2020202020202020202020207D0A2020202020';
wwv_flow_api.g_varchar2_table(153) := '20202020207D0A0A2020202020202020202072657475726E2073636F72653B0A20202020202020207D3B0A0A2020202020202020666F72202869203D20303B2069203C207061747465726E732E6C656E6774683B20692B2B29207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(154) := '20207061747465726E203D207061747465726E735B695D3B0A0A202020202020202020206E6176526573756C7473203D206E6172726F77656453657428290A2020202020202020202020202E66696C7465722866756E6374696F6E28656C656D2C20696E';
wwv_flow_api.g_varchar2_table(155) := '64657829207B0A2020202020202020202020202020766172206E616D65203D20656C656D2E6E2E746F4C6F7765724361736528292C0A20202020202020202020202020202020776F726473436F756E74203D206E616D652E73706C697428272027292E6C';
wwv_flow_api.g_varchar2_table(156) := '656E6774682C0A20202020202020202020202020202020706F736974696F6E203D206E616D652E736561726368287061747465726E293B0A0A2020202020202020202020202020696620287061747465726E4C656E677468203E20776F726473436F756E';
wwv_flow_api.g_varchar2_table(157) := '7429207B0A202020202020202020202020202020202F2F206B6579776F72647320636F6E7461696E73206D6F726520776F726473207468616E20737472696E6720746F2062652073656172636865640A2020202020202020202020202020202072657475';
wwv_flow_api.g_varchar2_table(158) := '726E2066616C73653B0A20202020202020202020202020207D0A0A202020202020202020202020202069662028706F736974696F6E203E202D3129207B0A20202020202020202020202020202020656C656D2E73636F7265203D2067657453636F726528';
wwv_flow_api.g_varchar2_table(159) := '706F736974696F6E2C20776F726473436F756E742C206E616D65293B0A2020202020202020202020202020202072657475726E20747275653B0A20202020202020202020202020207D20656C73652069662028656C656D2E7429207B202F2F20746F6B65';
wwv_flow_api.g_varchar2_table(160) := '6E73202873686F7274206465736372697074696F6E20666F72206E617620656E74726965732E290A2020202020202020202020202020202069662028656C656D2E742E736561726368287061747465726E29203E202D3129207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(161) := '202020202020202020656C656D2E73636F7265203D20313B0A20202020202020202020202020202020202072657475726E20747275653B0A202020202020202020202020202020207D0A20202020202020202020202020207D0A0A202020202020202020';
wwv_flow_api.g_varchar2_table(162) := '2020207D290A2020202020202020202020202E736F72742866756E6374696F6E28612C206229207B0A202020202020202020202020202072657475726E20622E73636F7265202D20612E73636F72653B0A2020202020202020202020207D293B0A0A2020';
wwv_flow_api.g_varchar2_table(163) := '2020202020202020686173526573756C7473203D20747275653B0A20202020202020207D0A0A202020202020202076617220666F726D61744E6176526573756C7473203D2066756E6374696F6E2872657329207B0A20202020202020202020766172206F';
wwv_flow_api.g_varchar2_table(164) := '7574203D2027272C0A202020202020202020202020692C0A2020202020202020202020206974656D2C0A202020202020202020202020747970652C0A20202020202020202020202073686F72746375742C0A20202020202020202020202069636F6E2C0A';
wwv_flow_api.g_varchar2_table(165) := '202020202020202020202020656E747279203D207B7D3B0A0A20202020202020202020696620287265732E6C656E677468203E206170657853706F746C696768742E674D61784E6176526573756C7429207B0A2020202020202020202020207265732E6C';
wwv_flow_api.g_varchar2_table(166) := '656E677468203D206170657853706F746C696768742E674D61784E6176526573756C743B0A202020202020202020207D0A0A20202020202020202020666F72202869203D20303B2069203C207265732E6C656E6774683B20692B2B29207B0A2020202020';
wwv_flow_api.g_varchar2_table(167) := '202020202020206974656D203D207265735B695D3B0A0A20202020202020202020202073686F7274637574203D206974656D2E73686F72746375743B0A20202020202020202020202074797065203D206974656D2E74207C7C206170657853706F746C69';
wwv_flow_api.g_varchar2_table(168) := '6768742E55524C5F54595045532E72656469726563743B0A20202020202020202020202069636F6E203D206974656D2E69207C7C206170657853706F746C696768742E49434F4E532E7365617263683B0A0A202020202020202020202020656E74727920';
wwv_flow_api.g_varchar2_table(169) := '3D207B0A20202020202020202020202020207469746C653A206974656D2E6E2C0A2020202020202020202020202020646573633A206974656D2E642C0A202020202020202020202020202075726C3A206974656D2E752C0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(170) := '202069636F6E3A2069636F6E2C0A2020202020202020202020202020747970653A20747970650A2020202020202020202020207D3B0A0A2020202020202020202020206966202873686F727463757429207B0A2020202020202020202020202020656E74';
wwv_flow_api.g_varchar2_table(171) := '72792E73686F7274637574203D2073686F72746375743B0A2020202020202020202020207D0A0A2020202020202020202020206F7574203D206F7574202B206170657853706F746C696768742E6765744D61726B757028656E747279293B0A2020202020';
wwv_flow_api.g_varchar2_table(172) := '20202020207D0A2020202020202020202072657475726E206F75743B0A20202020202020207D3B0A202020202020202072657475726E20666F726D61744E6176526573756C7473286170657853706F746C696768742E726573756C74734164644F6E7328';
wwv_flow_api.g_varchar2_table(173) := '6E6176526573756C747329293B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A205365617263680A202020202020202A2040706172616D207B737472696E677D206B0A202020202020202A2F0A2020202020207365617263683A20';
wwv_flow_api.g_varchar2_table(174) := '66756E6374696F6E286B29207B0A2020202020202020766172205052454649585F454E545259203D202773702D726573756C742D273B0A20202020202020202F2F2073746F7265206B6579776F7264730A20202020202020206170657853706F746C6967';
wwv_flow_api.g_varchar2_table(175) := '68742E674B6579776F726473203D206B2E7472696D28293B0A0A202020202020202076617220776F726473203D206170657853706F746C696768742E674B6579776F7264732E73706C697428272027292C0A2020202020202020202072657324203D2024';
wwv_flow_api.g_varchar2_table(176) := '286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F524553554C5453292C0A202020202020202020207061747465726E73203D205B5D2C0A202020202020202020206E61764F757075742C0A20202020202020';
wwv_flow_api.g_varchar2_table(177) := '202020693B0A2020202020202020666F72202869203D20303B2069203C20776F7264732E6C656E6774683B20692B2B29207B0A202020202020202020202F2F2073746F7265206B65797320696E20617272617920746F20737570706F7274207370616365';
wwv_flow_api.g_varchar2_table(178) := '20696E206B6579776F72647320666F72206E617669676174696F6E20656E74726965732C0A202020202020202020202F2F20652E672E20277374612066272066696E64732027537461746963204170706C69636174696F6E2046696C6573270A20202020';
wwv_flow_api.g_varchar2_table(179) := '2020202020207061747465726E732E70757368286E65772052656745787028617065782E7574696C2E65736361706552656745787028776F7264735B695D292C202767692729293B0A20202020202020207D0A0A20202020202020206E61764F75707574';
wwv_flow_api.g_varchar2_table(180) := '203D206170657853706F746C696768742E7365617263684E6176287061747465726E73293B0A0A20202020202020202428272327202B206170657853706F746C696768742E53505F4C495354290A202020202020202020202E68746D6C286E61764F7570';
wwv_flow_api.g_varchar2_table(181) := '7574290A202020202020202020202E66696E6428276C6927290A202020202020202020202E656163682866756E6374696F6E286929207B0A202020202020202020202020766172207468617424203D20242874686973293B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(182) := '2074686174240A20202020202020202020202020202E66696E64286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F524553554C545F4C4142454C290A20202020202020202020202020202E61747472282769';
wwv_flow_api.g_varchar2_table(183) := '64272C205052454649585F454E545259202B2069293B202F2F20666F72206163636573736962696C6974790A202020202020202020207D290A202020202020202020202E666972737428290A202020202020202020202E616464436C6173732861706578';
wwv_flow_api.g_varchar2_table(184) := '53706F746C696768742E53505F414354495645293B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A2043726561746573207468652073706F746C69676874206469616C6F67206D61726B75700A202020202020202A204070617261';
wwv_flow_api.g_varchar2_table(185) := '6D207B737472696E677D2070506C616365486F6C6465720A202020202020202A2F0A20202020202063726561746553706F746C696768744469616C6F673A2066756E6374696F6E2870506C616365486F6C64657229207B0A202020202020202076617220';
wwv_flow_api.g_varchar2_table(186) := '6372656174654469616C6F67203D2066756E6374696F6E2829207B0A2020202020202020202076617220766965774865696768742C0A2020202020202020202020206C696E654865696768742C0A20202020202020202020202076696577546F702C0A20';
wwv_flow_api.g_varchar2_table(187) := '2020202020202020202020726F7773506572566965773B0A0A2020202020202020202076617220696E697448656967687473203D2066756E6374696F6E2829207B0A2020202020202020202020207661722076696577546F7024203D202428276469762E';
wwv_flow_api.g_varchar2_table(188) := '6170782D53706F746C696768742D726573756C747327293B0A0A20202020202020202020202076696577486569676874203D2076696577546F70242E6F7574657248656967687428293B0A2020202020202020202020206C696E65486569676874203D20';
wwv_flow_api.g_varchar2_table(189) := '2428276C692E6170782D53706F746C696768742D726573756C7427292E6F7574657248656967687428293B0A20202020202020202020202076696577546F70203D2076696577546F70242E6F666673657428292E746F703B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(190) := '20726F777350657256696577203D202876696577486569676874202F206C696E65486569676874293B0A202020202020202020207D3B0A0A20202020202020202020766172207363726F6C6C6564446F776E4F75744F6656696577203D2066756E637469';
wwv_flow_api.g_varchar2_table(191) := '6F6E28656C656D2429207B0A20202020202020202020202069662028656C656D245B305D29207B0A202020202020202020202020202076617220746F70203D20656C656D242E6F666673657428292E746F703B0A20202020202020202020202020206966';
wwv_flow_api.g_varchar2_table(192) := '2028746F70203C203029207B0A2020202020202020202020202020202072657475726E20747275653B202F2F207363726F6C6C2062617220776173207573656420746F2067657420616374697665206974656D206F7574206F6620766965770A20202020';
wwv_flow_api.g_varchar2_table(193) := '202020202020202020207D20656C7365207B0A2020202020202020202020202020202072657475726E20746F70203E20766965774865696768743B0A20202020202020202020202020207D0A2020202020202020202020207D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(194) := '7D3B0A0A20202020202020202020766172207363726F6C6C656455704F75744F6656696577203D2066756E6374696F6E28656C656D2429207B0A20202020202020202020202069662028656C656D245B305D29207B0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(195) := '76617220746F70203D20656C656D242E6F666673657428292E746F703B0A202020202020202020202020202069662028746F70203E207669657748656967687429207B0A2020202020202020202020202020202072657475726E20747275653B202F2F20';
wwv_flow_api.g_varchar2_table(196) := '7363726F6C6C2062617220776173207573656420746F2067657420616374697665206974656D206F7574206F6620766965770A20202020202020202020202020207D20656C7365207B0A2020202020202020202020202020202072657475726E20746F70';
wwv_flow_api.g_varchar2_table(197) := '203C3D2076696577546F703B0A20202020202020202020202020207D0A2020202020202020202020207D0A202020202020202020207D3B0A0A202020202020202020202F2F206B6579626F61726420555020616E6420444F574E20737570706F72742074';
wwv_flow_api.g_varchar2_table(198) := '6F20676F207468726F75676820726573756C74730A20202020202020202020766172206765744E657874203D2066756E6374696F6E287265732429207B0A2020202020202020202020207661722063757272656E7424203D20726573242E66696E642861';
wwv_flow_api.g_varchar2_table(199) := '70657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F414354495645292C0A202020202020202020202020202073657175656E6365203D2063757272656E74242E696E64657828292C0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(200) := '20206E657874243B0A2020202020202020202020206966202821726F77735065725669657729207B0A2020202020202020202020202020696E69744865696768747328293B0A2020202020202020202020207D0A0A202020202020202020202020696620';
wwv_flow_api.g_varchar2_table(201) := '282163757272656E74242E6C656E677468207C7C2063757272656E74242E697328273A6C6173742D6368696C64272929207B0A20202020202020202020202020202F2F2048697420626F74746F6D2C207363726F6C6C20746F20746F700A202020202020';
wwv_flow_api.g_varchar2_table(202) := '202020202020202063757272656E74242E72656D6F7665436C617373286170657853706F746C696768742E53505F414354495645293B0A2020202020202020202020202020726573242E66696E6428276C6927292E666972737428292E616464436C6173';
wwv_flow_api.g_varchar2_table(203) := '73286170657853706F746C696768742E53505F414354495645293B0A2020202020202020202020202020726573242E616E696D617465287B0A202020202020202020202020202020207363726F6C6C546F703A20300A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(204) := '7D293B0A2020202020202020202020207D20656C7365207B0A20202020202020202020202020206E65787424203D2063757272656E74242E72656D6F7665436C617373286170657853706F746C696768742E53505F414354495645292E6E65787428292E';
wwv_flow_api.g_varchar2_table(205) := '616464436C617373286170657853706F746C696768742E53505F414354495645293B0A2020202020202020202020202020696620287363726F6C6C6564446F776E4F75744F6656696577286E657874242929207B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(206) := '20726573242E616E696D617465287B0A2020202020202020202020202020202020207363726F6C6C546F703A202873657175656E6365202D20726F777350657256696577202B203229202A206C696E654865696768740A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(207) := '2020207D2C2030293B0A20202020202020202020202020207D0A2020202020202020202020207D0A202020202020202020207D3B0A0A202020202020202020207661722067657450726576203D2066756E6374696F6E287265732429207B0A2020202020';
wwv_flow_api.g_varchar2_table(208) := '202020202020207661722063757272656E7424203D20726573242E66696E64286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F414354495645292C0A202020202020202020202020202073657175656E6365';
wwv_flow_api.g_varchar2_table(209) := '203D2063757272656E74242E696E64657828292C0A202020202020202020202020202070726576243B0A0A2020202020202020202020206966202821726F77735065725669657729207B0A2020202020202020202020202020696E697448656967687473';
wwv_flow_api.g_varchar2_table(210) := '28293B0A2020202020202020202020207D0A0A2020202020202020202020206966202821726573242E6C656E677468207C7C2063757272656E74242E697328273A66697273742D6368696C64272929207B0A20202020202020202020202020202F2F2048';
wwv_flow_api.g_varchar2_table(211) := '697420746F702C207363726F6C6C20746F20626F74746F6D0A202020202020202020202020202063757272656E74242E72656D6F7665436C617373286170657853706F746C696768742E53505F414354495645293B0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(212) := '726573242E66696E6428276C6927292E6C61737428292E616464436C617373286170657853706F746C696768742E53505F414354495645293B0A2020202020202020202020202020726573242E616E696D617465287B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(213) := '2020207363726F6C6C546F703A20726573242E66696E6428276C6927292E6C656E677468202A206C696E654865696768740A20202020202020202020202020207D293B0A2020202020202020202020207D20656C7365207B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(214) := '2020207072657624203D2063757272656E74242E72656D6F7665436C617373286170657853706F746C696768742E53505F414354495645292E7072657628292E616464436C617373286170657853706F746C696768742E53505F414354495645293B0A20';
wwv_flow_api.g_varchar2_table(215) := '20202020202020202020202020696620287363726F6C6C656455704F75744F66566965772870726576242929207B0A20202020202020202020202020202020726573242E616E696D617465287B0A2020202020202020202020202020202020207363726F';
wwv_flow_api.g_varchar2_table(216) := '6C6C546F703A202873657175656E6365202D203129202A206C696E654865696768740A202020202020202020202020202020207D2C2030293B0A20202020202020202020202020207D0A2020202020202020202020207D0A202020202020202020207D3B';
wwv_flow_api.g_varchar2_table(217) := '0A0A20202020202020202020242877696E646F77292E6F6E28276170657877696E646F77726573697A6564272C2066756E6374696F6E2829207B0A202020202020202020202020696E69744865696768747328293B0A202020202020202020207D293B0A';
wwv_flow_api.g_varchar2_table(218) := '0A20202020202020202020242827626F647927290A2020202020202020202020202E617070656E64280A2020202020202020202020202020273C64697620636C6173733D2227202B206170657853706F746C696768742E53505F4449414C4F47202B2027';
wwv_flow_api.g_varchar2_table(219) := '223E27202B0A2020202020202020202020202020273C64697620636C6173733D226170782D53706F746C696768742D626F6479223E27202B0A2020202020202020202020202020273C64697620636C6173733D226170782D53706F746C696768742D7365';
wwv_flow_api.g_varchar2_table(220) := '61726368223E27202B0A2020202020202020202020202020273C64697620636C6173733D226170782D53706F746C696768742D69636F6E223E27202B0A2020202020202020202020202020273C7370616E20636C6173733D22612D49636F6E2069636F6E';
wwv_flow_api.g_varchar2_table(221) := '2D7365617263682220617269612D68696464656E3D2274727565223E3C2F7370616E3E27202B0A2020202020202020202020202020273C2F6469763E27202B0A2020202020202020202020202020273C64697620636C6173733D226170782D53706F746C';
wwv_flow_api.g_varchar2_table(222) := '696768742D6669656C64223E27202B0A2020202020202020202020202020273C696E70757420747970653D22746578742220726F6C653D22636F6D626F626F782220617269612D657870616E6465643D2266616C73652220617269612D6175746F636F6D';
wwv_flow_api.g_varchar2_table(223) := '706C6574653D226E6F6E652220617269612D686173706F7075703D22747275652220617269612D6C6162656C3D2253706F746C69676874205365617263682220617269612D6F776E733D2227202B206170657853706F746C696768742E53505F4C495354';
wwv_flow_api.g_varchar2_table(224) := '202B202722206175746F636F6D706C6574653D226F666622206175746F636F72726563743D226F666622207370656C6C636865636B3D2266616C73652220636C6173733D2227202B206170657853706F746C696768742E53505F494E505554202B202722';
wwv_flow_api.g_varchar2_table(225) := '20706C616365686F6C6465723D2227202B2070506C616365486F6C646572202B2027223E27202B0A2020202020202020202020202020273C2F6469763E27202B0A2020202020202020202020202020273C64697620726F6C653D22726567696F6E222063';
wwv_flow_api.g_varchar2_table(226) := '6C6173733D22752D56697375616C6C7948696464656E2220617269612D6C6976653D22706F6C697465222069643D2227202B206170657853706F746C696768742E53505F4C4956455F524547494F4E202B2027223E3C2F6469763E27202B0A2020202020';
wwv_flow_api.g_varchar2_table(227) := '202020202020202020273C2F6469763E27202B0A2020202020202020202020202020273C64697620636C6173733D2227202B206170657853706F746C696768742E53505F524553554C5453202B2027223E27202B0A202020202020202020202020202027';
wwv_flow_api.g_varchar2_table(228) := '3C756C20636C6173733D226170782D53706F746C696768742D726573756C74734C697374222069643D2227202B206170657853706F746C696768742E53505F4C495354202B20272220746162696E6465783D222D312220726F6C653D226C697374626F78';
wwv_flow_api.g_varchar2_table(229) := '223E3C2F756C3E27202B0A2020202020202020202020202020273C2F6469763E27202B0A2020202020202020202020202020273C2F6469763E27202B0A2020202020202020202020202020273C2F6469763E270A202020202020202020202020290A2020';
wwv_flow_api.g_varchar2_table(230) := '202020202020202020202E6F6E2827696E707574272C206170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E5055542C2066756E6374696F6E2829207B0A2020202020202020202020202020766172207620';
wwv_flow_api.g_varchar2_table(231) := '3D20242874686973292E76616C28292E7472696D28292C0A202020202020202020202020202020206C656E203D20762E6C656E6774683B0A0A2020202020202020202020202020696620286C656E203D3D3D203029207B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(232) := '202020206170657853706F746C696768742E726573657453706F746C6967687428293B202F2F20636C656172732065766572797468696E67207768656E206B6579776F72642069732072656D6F7665642E0A20202020202020202020202020207D20656C';
wwv_flow_api.g_varchar2_table(233) := '736520696620286C656E203E2031207C7C202169734E614E28762929207B0A202020202020202020202020202020202F2F20736561726368207265717569726573206D6F7265207468616E206F6E65206368617261637465722C206F7220697420697320';
wwv_flow_api.g_varchar2_table(234) := '61206E756D6265722E0A20202020202020202020202020202020696620287620213D3D206170657853706F746C696768742E674B6579776F72647329207B0A2020202020202020202020202020202020206170657853706F746C696768742E7365617263';
wwv_flow_api.g_varchar2_table(235) := '682876293B0A202020202020202020202020202020207D0A20202020202020202020202020207D0A2020202020202020202020207D290A2020202020202020202020202E6F6E28276B6579646F776E272C206170657853706F746C696768742E444F5420';
wwv_flow_api.g_varchar2_table(236) := '2B206170657853706F746C696768742E53505F4449414C4F472C2066756E6374696F6E286529207B0A202020202020202020202020202076617220726573756C747324203D2024286170657853706F746C696768742E444F54202B206170657853706F74';
wwv_flow_api.g_varchar2_table(237) := '6C696768742E53505F524553554C5453292C0A202020202020202020202020202020206C61737439526573756C74732C0A2020202020202020202020202020202073686F72746375744E756D6265723B0A0A20202020202020202020202020202F2F2075';
wwv_flow_api.g_varchar2_table(238) := '702F646F776E206172726F77730A20202020202020202020202020207377697463682028652E776869636829207B0A2020202020202020202020202020202063617365206170657853706F746C696768742E4B4559532E444F574E3A0A20202020202020';
wwv_flow_api.g_varchar2_table(239) := '2020202020202020202020652E70726576656E7444656661756C7428293B0A2020202020202020202020202020202020206765744E65787428726573756C747324293B0A202020202020202020202020202020202020627265616B3B0A0A202020202020';
wwv_flow_api.g_varchar2_table(240) := '2020202020202020202063617365206170657853706F746C696768742E4B4559532E55503A0A202020202020202020202020202020202020652E70726576656E7444656661756C7428293B0A202020202020202020202020202020202020676574507265';
wwv_flow_api.g_varchar2_table(241) := '7628726573756C747324293B0A202020202020202020202020202020202020627265616B3B0A0A2020202020202020202020202020202063617365206170657853706F746C696768742E4B4559532E454E5445523A0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(242) := '20202020652E70726576656E7444656661756C7428293B202F2F20646F6E2774207375626D6974206F6E20656E7465720A2020202020202020202020202020202020206170657853706F746C696768742E676F546F28726573756C7473242E66696E6428';
wwv_flow_api.g_varchar2_table(243) := '276C692E69732D616374697665207370616E27292C2065293B0A202020202020202020202020202020202020627265616B3B0A2020202020202020202020202020202063617365206170657853706F746C696768742E4B4559532E5441423A0A20202020';
wwv_flow_api.g_varchar2_table(244) := '20202020202020202020202020206170657853706F746C696768742E636C6F73654469616C6F6728293B0A202020202020202020202020202020202020627265616B3B0A20202020202020202020202020207D0A0A202020202020202020202020202069';
wwv_flow_api.g_varchar2_table(245) := '662028652E6374726C4B657929207B0A202020202020202020202020202020202F2F20737570706F727473204374726C202B20312C20322C20332C20342C20352C20362C20372C20382C20392073686F7274637574730A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(246) := '2020206C61737439526573756C7473203D20726573756C7473242E66696E64286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F53484F5254435554292E706172656E7428292E67657428293B0A2020202020';
wwv_flow_api.g_varchar2_table(247) := '20202020202020202020207377697463682028652E776869636829207B0A202020202020202020202020202020202020636173652034393A202F2F204374726C202B20310A202020202020202020202020202020202020202073686F72746375744E756D';
wwv_flow_api.g_varchar2_table(248) := '626572203D20313B0A2020202020202020202020202020202020202020627265616B3B0A202020202020202020202020202020202020636173652035303A202F2F204374726C202B20320A202020202020202020202020202020202020202073686F7274';
wwv_flow_api.g_varchar2_table(249) := '6375744E756D626572203D20323B0A2020202020202020202020202020202020202020627265616B3B0A0A202020202020202020202020202020202020636173652035313A202F2F204374726C202B20330A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(250) := '202073686F72746375744E756D626572203D20333B0A2020202020202020202020202020202020202020627265616B3B0A0A202020202020202020202020202020202020636173652035323A202F2F204374726C202B20340A2020202020202020202020';
wwv_flow_api.g_varchar2_table(251) := '20202020202020202073686F72746375744E756D626572203D20343B0A2020202020202020202020202020202020202020627265616B3B0A0A202020202020202020202020202020202020636173652035333A202F2F204374726C202B20350A20202020';
wwv_flow_api.g_varchar2_table(252) := '2020202020202020202020202020202073686F72746375744E756D626572203D20353B0A2020202020202020202020202020202020202020627265616B3B0A0A202020202020202020202020202020202020636173652035343A202F2F204374726C202B';
wwv_flow_api.g_varchar2_table(253) := '20360A202020202020202020202020202020202020202073686F72746375744E756D626572203D20363B0A2020202020202020202020202020202020202020627265616B3B0A0A202020202020202020202020202020202020636173652035353A202F2F';
wwv_flow_api.g_varchar2_table(254) := '204374726C202B20370A202020202020202020202020202020202020202073686F72746375744E756D626572203D20373B0A2020202020202020202020202020202020202020627265616B3B0A0A20202020202020202020202020202020202063617365';
wwv_flow_api.g_varchar2_table(255) := '2035363A202F2F204374726C202B20380A202020202020202020202020202020202020202073686F72746375744E756D626572203D20383B0A2020202020202020202020202020202020202020627265616B3B0A0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(256) := '202020636173652035373A202F2F204374726C202B20390A202020202020202020202020202020202020202073686F72746375744E756D626572203D20393B0A2020202020202020202020202020202020202020627265616B3B0A202020202020202020';
wwv_flow_api.g_varchar2_table(257) := '202020202020207D0A0A202020202020202020202020202020206966202873686F72746375744E756D62657229207B0A2020202020202020202020202020202020206170657853706F746C696768742E676F546F2824286C61737439526573756C74735B';
wwv_flow_api.g_varchar2_table(258) := '73686F72746375744E756D626572202D20315D292C2065293B0A202020202020202020202020202020207D0A20202020202020202020202020207D0A0A20202020202020202020202020202F2F205368696674202B2054616220746F20636C6F73652061';
wwv_flow_api.g_varchar2_table(259) := '6E6420666F63757320676F6573206261636B20746F207768657265206974207761732E0A202020202020202020202020202069662028652E73686966744B657929207B0A2020202020202020202020202020202069662028652E7768696368203D3D3D20';
wwv_flow_api.g_varchar2_table(260) := '6170657853706F746C696768742E4B4559532E54414229207B0A2020202020202020202020202020202020206170657853706F746C696768742E636C6F73654469616C6F6728293B0A202020202020202020202020202020207D0A202020202020202020';
wwv_flow_api.g_varchar2_table(261) := '20202020207D0A0A20202020202020202020202020206170657853706F746C696768742E68616E646C65417269614174747228293B0A0A2020202020202020202020207D290A2020202020202020202020202E6F6E2827636C69636B272C20277370616E';
wwv_flow_api.g_varchar2_table(262) := '2E6170782D53706F746C696768742D6C696E6B272C2066756E6374696F6E286529207B0A20202020202020202020202020206170657853706F746C696768742E676F546F28242874686973292C2065293B0A2020202020202020202020207D290A202020';
wwv_flow_api.g_varchar2_table(263) := '2020202020202020202E6F6E28276D6F7573656D6F7665272C20276C692E6170782D53706F746C696768742D726573756C74272C2066756E6374696F6E2829207B0A202020202020202020202020202076617220686967686C6967687424203D20242874';
wwv_flow_api.g_varchar2_table(264) := '686973293B0A2020202020202020202020202020686967686C69676874240A202020202020202020202020202020202E706172656E7428290A202020202020202020202020202020202E66696E64286170657853706F746C696768742E444F54202B2061';
wwv_flow_api.g_varchar2_table(265) := '70657853706F746C696768742E53505F414354495645290A202020202020202020202020202020202E72656D6F7665436C617373286170657853706F746C696768742E53505F414354495645293B0A0A2020202020202020202020202020686967686C69';
wwv_flow_api.g_varchar2_table(266) := '676874242E616464436C617373286170657853706F746C696768742E53505F414354495645293B0A20202020202020202020202020202F2F2068616E646C65417269614174747228293B0A2020202020202020202020207D290A20202020202020202020';
wwv_flow_api.g_varchar2_table(267) := '20202E6F6E2827626C7572272C206170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F472C2066756E6374696F6E286529207B0A20202020202020202020202020202F2F20646F6E277420646F2074';
wwv_flow_api.g_varchar2_table(268) := '686973206966206469616C6F6720697320636C6F7365642F636C6F73696E670A20202020202020202020202020206966202824286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F47292E646961';
wwv_flow_api.g_varchar2_table(269) := '6C6F67282269734F70656E222929207B0A202020202020202020202020202020202F2F20696E7075742074616B657320666F637573206469616C6F67206C6F73657320666F63757320746F207363726F6C6C206261720A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(270) := '20202024286170657853706F746C696768742E444F54202B206170657853706F746C696768742E53505F494E505554292E666F63757328293B0A20202020202020202020202020207D0A2020202020202020202020207D293B0A0A202020202020202020';
wwv_flow_api.g_varchar2_table(271) := '202F2F20457363617065206B65792070726573736564206F6E63652C20636C656172206669656C642C2074776963652C20636C6F7365206469616C6F672E0A2020202020202020202024286170657853706F746C696768742E444F54202B206170657853';
wwv_flow_api.g_varchar2_table(272) := '706F746C696768742E53505F4449414C4F47292E6F6E28276B6579646F776E272C2066756E6374696F6E286529207B0A20202020202020202020202076617220696E70757424203D2024286170657853706F746C696768742E444F54202B206170657853';
wwv_flow_api.g_varchar2_table(273) := '706F746C696768742E53505F494E505554293B0A20202020202020202020202069662028652E7768696368203D3D3D206170657853706F746C696768742E4B4559532E45534341504529207B0A202020202020202020202020202069662028696E707574';
wwv_flow_api.g_varchar2_table(274) := '242E76616C282929207B0A202020202020202020202020202020206170657853706F746C696768742E726573657453706F746C6967687428293B0A20202020202020202020202020202020652E73746F7050726F7061676174696F6E28293B0A20202020';
wwv_flow_api.g_varchar2_table(275) := '202020202020202020207D20656C7365207B0A202020202020202020202020202020206170657853706F746C696768742E636C6F73654469616C6F6728293B0A20202020202020202020202020207D0A2020202020202020202020207D0A202020202020';
wwv_flow_api.g_varchar2_table(276) := '202020207D293B0A0A202020202020202020206170657853706F746C696768742E674861734469616C6F6743726561746564203D20747275653B0A20202020202020207D3B0A20202020202020206372656174654469616C6F6728293B0A202020202020';
wwv_flow_api.g_varchar2_table(277) := '7D2C0A2020202020202F2A2A0A202020202020202A204F70656E2053706F746C69676874204469616C6F670A202020202020202A2040706172616D207B6F626A6563747D2070466F637573456C656D656E740A202020202020202A2F0A2020202020206F';
wwv_flow_api.g_varchar2_table(278) := '70656E53706F746C696768744469616C6F673A2066756E6374696F6E2870466F637573456C656D656E7429207B0A20202020202020202F2F2044697361626C652053706F746C6967687420666F72204D6F64616C204469616C6F670A2020202020202020';
wwv_flow_api.g_varchar2_table(279) := '696620282877696E646F772E73656C6620213D3D2077696E646F772E746F702929207B0A2020202020202020202072657475726E2066616C73653B0A20202020202020207D0A0A20202020202020202F2F207365742073656C6563746564207465787420';
wwv_flow_api.g_varchar2_table(280) := '746F2073706F746C6967687420696E7075740A2020202020202020696620286170657853706F746C696768742E67456E61626C6550726566696C6C53656C65637465645465787429207B0A202020202020202020206170657853706F746C696768742E73';
wwv_flow_api.g_varchar2_table(281) := '657453656C65637465645465787428293B0A20202020202020207D0A0A20202020202020206170657853706F746C696768742E674861734469616C6F6743726561746564203D2024286170657853706F746C696768742E444F54202B206170657853706F';
wwv_flow_api.g_varchar2_table(282) := '746C696768742E53505F4449414C4F47292E6C656E677468203E20303B0A0A2020202020202020766172206F70656E4469616C6F67203D2066756E6374696F6E2829207B0A2020202020202020202076617220646C6724203D2024286170657853706F74';
wwv_flow_api.g_varchar2_table(283) := '6C696768742E444F54202B206170657853706F746C696768742E53505F4449414C4F47292C0A2020202020202020202020207363726F6C6C59203D2077696E646F772E7363726F6C6C59207C7C2077696E646F772E70616765594F66667365743B0A2020';
wwv_flow_api.g_varchar2_table(284) := '20202020202020206966202821646C67242E686173436C617373282775692D6469616C6F672D636F6E74656E742729207C7C2021646C67242E6469616C6F67282269734F70656E222929207B0A202020202020202020202020646C67242E6469616C6F67';
wwv_flow_api.g_varchar2_table(285) := '287B0A202020202020202020202020202077696474683A206170657853706F746C696768742E6757696474682C0A20202020202020202020202020206865696768743A20276175746F272C0A20202020202020202020202020206D6F64616C3A20747275';
wwv_flow_api.g_varchar2_table(286) := '652C0A2020202020202020202020202020706F736974696F6E3A207B0A202020202020202020202020202020206D793A202263656E74657220746F70222C0A2020202020202020202020202020202061743A202263656E74657220746F702B22202B2028';
wwv_flow_api.g_varchar2_table(287) := '7363726F6C6C59202B203634292C0A202020202020202020202020202020206F663A20242827626F647927290A20202020202020202020202020207D2C0A20202020202020202020202020206469616C6F67436C6173733A202775692D6469616C6F672D';
wwv_flow_api.g_varchar2_table(288) := '2D6170657873706F746C69676874272C0A20202020202020202020202020206F70656E3A2066756E6374696F6E2829207B0A20202020202020202020202020202020617065782E6576656E742E747269676765722827626F6479272C2027617065787370';
wwv_flow_api.g_varchar2_table(289) := '6F746C696768742D6F70656E2D6469616C6F6727293B0A0A2020202020202020202020202020202076617220646C6724203D20242874686973293B0A0A20202020202020202020202020202020646C67240A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(290) := '2E63737328276D696E2D686569676874272C20276175746F27290A2020202020202020202020202020202020202E7072657628272E75692D6469616C6F672D7469746C6562617227290A2020202020202020202020202020202020202E72656D6F766528';
wwv_flow_api.g_varchar2_table(291) := '293B0A0A20202020202020202020202020202020617065782E6E617669676174696F6E2E626567696E467265657A655363726F6C6C28293B0A0A202020202020202020202020202020202428272E75692D7769646765742D6F7665726C617927292E6F6E';
wwv_flow_api.g_varchar2_table(292) := '2827636C69636B272C2066756E6374696F6E2829207B0A2020202020202020202020202020202020206170657853706F746C696768742E636C6F73654469616C6F6728293B0A202020202020202020202020202020207D293B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(293) := '202020207D2C0A2020202020202020202020202020636C6F73653A2066756E6374696F6E2829207B0A20202020202020202020202020202020617065782E6576656E742E747269676765722827626F6479272C20276170657873706F746C696768742D63';
wwv_flow_api.g_varchar2_table(294) := '6C6F73652D6469616C6F6727293B0A202020202020202020202020202020206170657853706F746C696768742E726573657453706F746C6967687428293B0A20202020202020202020202020202020617065782E6E617669676174696F6E2E656E644672';
wwv_flow_api.g_varchar2_table(295) := '65657A655363726F6C6C28293B0A20202020202020202020202020207D0A2020202020202020202020207D293B0A202020202020202020207D0A20202020202020207D3B0A0A2020202020202020696620286170657853706F746C696768742E67486173';
wwv_flow_api.g_varchar2_table(296) := '4469616C6F674372656174656429207B0A202020202020202020206F70656E4469616C6F6728293B0A20202020202020207D20656C7365207B0A202020202020202020206170657853706F746C696768742E63726561746553706F746C69676874446961';
wwv_flow_api.g_varchar2_table(297) := '6C6F67286170657853706F746C696768742E67506C616365686F6C64657254657874293B0A202020202020202020206F70656E4469616C6F6728293B0A202020202020202020206170657853706F746C696768742E67657453706F746C69676874446174';
wwv_flow_api.g_varchar2_table(298) := '612866756E6374696F6E286461746129207B0A2020202020202020202020206170657853706F746C696768742E67536561726368496E646578203D20242E6772657028646174612C2066756E6374696F6E286529207B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(299) := '2072657475726E20652E73203D3D2066616C73653B0A2020202020202020202020207D293B0A2020202020202020202020206170657853706F746C696768742E67537461746963496E646578203D20242E6772657028646174612C2066756E6374696F6E';
wwv_flow_api.g_varchar2_table(300) := '286529207B0A202020202020202020202020202072657475726E20652E73203D3D20747275653B0A2020202020202020202020207D293B0A202020202020202020202020617065782E6576656E742E747269676765722827626F6479272C202761706578';
wwv_flow_api.g_varchar2_table(301) := '73706F746C696768742D6765742D64617461272C2064617461293B0A202020202020202020207D293B0A20202020202020207D0A2020202020202020666F637573456C656D656E74203D2070466F637573456C656D656E743B202F2F20636F756C642062';
wwv_flow_api.g_varchar2_table(302) := '652075736566756C20666F722073686F72746375747320616464656420627920617065782E616374696F6E0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A204F70656E2053706F746C69676874204469616C6F6720766961204D6F';
wwv_flow_api.g_varchar2_table(303) := '757374726170206B6579626F6172642073686F72746375740A202020202020202A2040706172616D207B6F626A6563747D2070466F637573456C656D656E740A202020202020202A2F0A2020202020206F70656E53706F746C696768744469616C6F674B';
wwv_flow_api.g_varchar2_table(304) := '6579626F61726453686F72746375743A2066756E6374696F6E2870466F637573456C656D656E7429207B0A20202020202020202F2F2064697361626C652064656661756C74206265686176696F7220746F206E6F742062696E6420696E20696E70757420';
wwv_flow_api.g_varchar2_table(305) := '6669656C64730A20202020202020204D6F757365747261702E73746F7043616C6C6261636B203D2066756E6374696F6E28652C20656C656D656E742C20636F6D626F29207B0A2020202020202020202072657475726E20747275653B0A20202020202020';
wwv_flow_api.g_varchar2_table(306) := '207D3B0A20202020202020204D6F757365747261702E70726F746F747970652E73746F7043616C6C6261636B203D2066756E6374696F6E28652C20656C656D656E742C20636F6D626F29207B0A2020202020202020202072657475726E2066616C73653B';
wwv_flow_api.g_varchar2_table(307) := '0A20202020202020207D3B0A0A20202020202020202F2F2062696E64206D6F75737472617020746F206B6579626F6172642073686F72746375740A20202020202020204D6F757365747261702E62696E64286170657853706F746C696768742E674B6579';
wwv_flow_api.g_varchar2_table(308) := '626F61726453686F72746375747341727261792C2066756E6374696F6E286529207B0A202020202020202020202F2F2070726576656E742064656661756C74206265686176696F720A2020202020202020202069662028652E70726576656E7444656661';
wwv_flow_api.g_varchar2_table(309) := '756C7429207B0A202020202020202020202020652E70726576656E7444656661756C7428293B0A202020202020202020207D20656C7365207B0A2020202020202020202020202F2F20696E7465726E6574206578706C6F7265720A202020202020202020';
wwv_flow_api.g_varchar2_table(310) := '202020652E72657475726E56616C7565203D2066616C73653B0A202020202020202020207D0A202020202020202020202F2F206F70656E2073706F746C69676874206469616C6F670A202020202020202020206170657853706F746C696768742E6F7065';
wwv_flow_api.g_varchar2_table(311) := '6E53706F746C696768744469616C6F672870466F637573456C656D656E74293B0A20202020202020207D293B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A20496E2D5061676520736561726368207573696E67206D61726B2E6A';
wwv_flow_api.g_varchar2_table(312) := '730A202020202020202A2040706172616D207B737472696E677D20704B6579776F72640A202020202020202A2F0A202020202020696E506167655365617263683A2066756E6374696F6E28704B6579776F726429207B0A2020202020202020766172206B';
wwv_flow_api.g_varchar2_table(313) := '6579776F7264203D20704B6579776F7264207C7C206170657853706F746C696768742E674B6579776F7264733B0A2020202020202020242827626F647927292E756E6D61726B287B0A20202020202020202020646F6E653A2066756E6374696F6E282920';
wwv_flow_api.g_varchar2_table(314) := '7B0A2020202020202020202020206170657853706F746C696768742E636C6F73654469616C6F6728293B0A2020202020202020202020206170657853706F746C696768742E726573657453706F746C6967687428293B0A20202020202020202020202024';
wwv_flow_api.g_varchar2_table(315) := '2827626F647927292E6D61726B286B6579776F72642C207B7D293B0A202020202020202020202020617065782E6576656E742E747269676765722827626F6479272C20276170657873706F746C696768742D696E706167652D736561726368272C207B0A';
wwv_flow_api.g_varchar2_table(316) := '2020202020202020202020202020226B6579776F7264223A206B6579776F72640A2020202020202020202020207D293B0A202020202020202020207D0A20202020202020207D293B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A';
wwv_flow_api.g_varchar2_table(317) := '205265616C20506C7567696E2068616E646C6572202D2063616C6C65642066726F6D206F7574657220706C7567696E48616E646C65722066756E6374696F6E0A202020202020202A2040706172616D207B6F626A6563747D20704F7074696F6E730A2020';
wwv_flow_api.g_varchar2_table(318) := '20202020202A2F0A202020202020706C7567696E48616E646C65723A2066756E6374696F6E28704F7074696F6E7329207B0A20202020202020202F2F20706C7567696E20617474726962757465730A20202020202020207661722064796E616D69634163';
wwv_flow_api.g_varchar2_table(319) := '74696F6E4964203D206170657853706F746C696768742E6744796E616D6963416374696F6E4964203D20704F7074696F6E732E64796E616D6963416374696F6E49643B0A202020202020202076617220616A61784964656E746966696572203D20617065';
wwv_flow_api.g_varchar2_table(320) := '7853706F746C696768742E67416A61784964656E746966696572203D20704F7074696F6E732E616A61784964656E7469666965723B0A0A202020202020202076617220706C616365686F6C64657254657874203D206170657853706F746C696768742E67';
wwv_flow_api.g_varchar2_table(321) := '506C616365686F6C64657254657874203D20704F7074696F6E732E706C616365686F6C646572546578743B0A2020202020202020766172206D6F7265436861727354657874203D206170657853706F746C696768742E674D6F7265436861727354657874';
wwv_flow_api.g_varchar2_table(322) := '203D20704F7074696F6E732E6D6F72654368617273546578743B0A2020202020202020766172206E6F4D6174636854657874203D206170657853706F746C696768742E674E6F4D6174636854657874203D20704F7074696F6E732E6E6F4D617463685465';
wwv_flow_api.g_varchar2_table(323) := '78743B0A2020202020202020766172206F6E654D6174636854657874203D206170657853706F746C696768742E674F6E654D6174636854657874203D20704F7074696F6E732E6F6E654D61746368546578743B0A2020202020202020766172206D756C74';
wwv_flow_api.g_varchar2_table(324) := '69706C654D61746368657354657874203D206170657853706F746C696768742E674D756C7469706C654D61746368657354657874203D20704F7074696F6E732E6D756C7469706C654D617463686573546578743B0A202020202020202076617220696E50';
wwv_flow_api.g_varchar2_table(325) := '61676553656172636854657874203D206170657853706F746C696768742E67496E5061676553656172636854657874203D20704F7074696F6E732E696E50616765536561726368546578743B0A0A202020202020202076617220656E61626C654B657962';
wwv_flow_api.g_varchar2_table(326) := '6F61726453686F727463757473203D20704F7074696F6E732E656E61626C654B6579626F61726453686F7274637574733B0A2020202020202020766172206B6579626F61726453686F727463757473203D20704F7074696F6E732E6B6579626F61726453';
wwv_flow_api.g_varchar2_table(327) := '686F7274637574733B0A2020202020202020766172207375626D69744974656D73203D20704F7074696F6E732E7375626D69744974656D733B0A202020202020202076617220656E61626C65496E50616765536561726368203D20704F7074696F6E732E';
wwv_flow_api.g_varchar2_table(328) := '656E61626C65496E506167655365617263683B0A2020202020202020766172206D61784E6176526573756C74203D206170657853706F746C696768742E674D61784E6176526573756C74203D20704F7074696F6E732E6D61784E6176526573756C743B0A';
wwv_flow_api.g_varchar2_table(329) := '2020202020202020766172207769647468203D206170657853706F746C696768742E675769647468203D20704F7074696F6E732E77696474683B0A202020202020202076617220656E61626C65446174614361636865203D20704F7074696F6E732E656E';
wwv_flow_api.g_varchar2_table(330) := '61626C654461746143616368653B0A20202020202020207661722073706F746C696768745468656D65203D20704F7074696F6E732E73706F746C696768745468656D653B0A202020202020202076617220656E61626C6550726566696C6C53656C656374';
wwv_flow_api.g_varchar2_table(331) := '656454657874203D20704F7074696F6E732E656E61626C6550726566696C6C53656C6563746564546578743B0A20202020202020207661722073686F7750726F63657373696E67203D20704F7074696F6E732E73686F7750726F63657373696E673B0A0A';
wwv_flow_api.g_varchar2_table(332) := '2020202020202020766172206B6579626F61726453686F7274637574734172726179203D205B5D3B0A2020202020202020766172207375626D69744974656D734172726179203D205B5D3B0A0A20202020202020202F2F2064656275670A202020202020';
wwv_flow_api.g_varchar2_table(333) := '2020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D2064796E616D6963416374696F6E4964272C2064796E616D6963416374696F6E4964293B0A2020202020202020617065782E646562';
wwv_flow_api.g_varchar2_table(334) := '75672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D20616A61784964656E746966696572272C20616A61784964656E746966696572293B0A0A2020202020202020617065782E64656275672E6C6F672827617065';
wwv_flow_api.g_varchar2_table(335) := '7853706F746C696768742E706C7567696E48616E646C6572202D20706C616365686F6C64657254657874272C20706C616365686F6C64657254657874293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C69676874';
wwv_flow_api.g_varchar2_table(336) := '2E706C7567696E48616E646C6572202D206D6F7265436861727354657874272C206D6F7265436861727354657874293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572';
wwv_flow_api.g_varchar2_table(337) := '202D206E6F4D6174636854657874272C206E6F4D6174636854657874293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D206F6E654D6174636854657874272C20';
wwv_flow_api.g_varchar2_table(338) := '6F6E654D6174636854657874293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D206D756C7469706C654D61746368657354657874272C206D756C7469706C654D';
wwv_flow_api.g_varchar2_table(339) := '61746368657354657874293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D20696E5061676553656172636854657874272C20696E506167655365617263685465';
wwv_flow_api.g_varchar2_table(340) := '7874293B0A0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D20656E61626C654B6579626F61726453686F727463757473272C20656E61626C654B6579626F617264';
wwv_flow_api.g_varchar2_table(341) := '53686F727463757473293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D206B6579626F61726453686F727463757473272C206B6579626F61726453686F727463';
wwv_flow_api.g_varchar2_table(342) := '757473293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D207375626D69744974656D73272C207375626D69744974656D73293B0A202020202020202061706578';
wwv_flow_api.g_varchar2_table(343) := '2E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D20656E61626C65496E50616765536561726368272C20656E61626C65496E50616765536561726368293B0A2020202020202020617065782E646562';
wwv_flow_api.g_varchar2_table(344) := '75672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D206D61784E6176526573756C74272C206D61784E6176526573756C74293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F74';
wwv_flow_api.g_varchar2_table(345) := '6C696768742E706C7567696E48616E646C6572202D207769647468272C207769647468293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D20656E61626C654461';
wwv_flow_api.g_varchar2_table(346) := '74614361636865272C20656E61626C65446174614361636865293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D2073706F746C696768745468656D65272C2073';
wwv_flow_api.g_varchar2_table(347) := '706F746C696768745468656D65293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D20656E61626C6550726566696C6C53656C656374656454657874272C20656E';
wwv_flow_api.g_varchar2_table(348) := '61626C6550726566696C6C53656C656374656454657874293B0A2020202020202020617065782E64656275672E6C6F6728276170657853706F746C696768742E706C7567696E48616E646C6572202D2073686F7750726F63657373696E67272C2073686F';
wwv_flow_api.g_varchar2_table(349) := '7750726F63657373696E67293B0A0A20202020202020202F2F20706F6C7966696C6C20666F72206F6C6465722062726F7773657273206C696B65204945202873746172747357697468202620696E636C756465732066756E6374696F6E73290A20202020';
wwv_flow_api.g_varchar2_table(350) := '202020206966202821537472696E672E70726F746F747970652E7374617274735769746829207B0A20202020202020202020537472696E672E70726F746F747970652E73746172747357697468203D2066756E6374696F6E287365617263682C20706F73';
wwv_flow_api.g_varchar2_table(351) := '29207B0A20202020202020202020202072657475726E20746869732E7375627374722821706F73207C7C20706F73203C2030203F2030203A202B706F732C207365617263682E6C656E67746829203D3D3D207365617263683B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(352) := '7D3B0A20202020202020207D0A20202020202020206966202821537472696E672E70726F746F747970652E696E636C7564657329207B0A20202020202020202020537472696E672E70726F746F747970652E696E636C75646573203D2066756E6374696F';
wwv_flow_api.g_varchar2_table(353) := '6E287365617263682C20737461727429207B0A2020202020202020202020202775736520737472696374273B0A20202020202020202020202069662028747970656F6620737461727420213D3D20276E756D6265722729207B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(354) := '202020207374617274203D20303B0A2020202020202020202020207D0A0A202020202020202020202020696620287374617274202B207365617263682E6C656E677468203E20746869732E6C656E67746829207B0A202020202020202020202020202072';
wwv_flow_api.g_varchar2_table(355) := '657475726E2066616C73653B0A2020202020202020202020207D20656C7365207B0A202020202020202020202020202072657475726E20746869732E696E6465784F66287365617263682C2073746172742920213D3D202D313B0A202020202020202020';
wwv_flow_api.g_varchar2_table(356) := '2020207D0A202020202020202020207D3B0A20202020202020207D0A0A20202020202020202F2F2073657420626F6F6C65616E20676C6F62616C20766172730A20202020202020206170657853706F746C696768742E67456E61626C65496E5061676553';
wwv_flow_api.g_varchar2_table(357) := '6561726368203D2028656E61626C65496E50616765536561726368203D3D2027592729203F2074727565203A2066616C73653B0A20202020202020206170657853706F746C696768742E67456E61626C65446174614361636865203D2028656E61626C65';
wwv_flow_api.g_varchar2_table(358) := '446174614361636865203D3D2027592729203F2074727565203A2066616C73653B0A20202020202020206170657853706F746C696768742E67456E61626C6550726566696C6C53656C656374656454657874203D2028656E61626C6550726566696C6C53';
wwv_flow_api.g_varchar2_table(359) := '656C656374656454657874203D3D2027592729203F2074727565203A2066616C73653B0A20202020202020206170657853706F746C696768742E6753686F7750726F63657373696E67203D202873686F7750726F63657373696E67203D3D202759272920';
wwv_flow_api.g_varchar2_table(360) := '3F2074727565203A2066616C73653B0A0A0A20202020202020202F2F206275696C642070616765206974656D7320746F207375626D69742061727261790A2020202020202020696620287375626D69744974656D7329207B0A2020202020202020202073';
wwv_flow_api.g_varchar2_table(361) := '75626D69744974656D734172726179203D206170657853706F746C696768742E675375626D69744974656D734172726179203D207375626D69744974656D732E73706C697428272C27293B0A20202020202020207D0A0A20202020202020202F2F206275';
wwv_flow_api.g_varchar2_table(362) := '696C64206B6579626F6172642073686F7274637574732061727261790A202020202020202069662028656E61626C654B6579626F61726453686F727463757473203D3D2027592729207B0A202020202020202020206B6579626F61726453686F72746375';
wwv_flow_api.g_varchar2_table(363) := '74734172726179203D206170657853706F746C696768742E674B6579626F61726453686F7274637574734172726179203D206B6579626F61726453686F7274637574732E73706C697428272C27293B0A20202020202020207D0A0A20202020202020202F';
wwv_flow_api.g_varchar2_table(364) := '2F207365742073706F746C69676874207468656D650A2020202020202020737769746368202873706F746C696768745468656D6529207B0A202020202020202020206361736520274F52414E4745273A0A2020202020202020202020206170657853706F';
wwv_flow_api.g_varchar2_table(365) := '746C696768742E67526573756C744C6973745468656D65436C617373203D20276170782D53706F746C696768742D726573756C742D6F72616E6765273B0A2020202020202020202020206170657853706F746C696768742E6749636F6E5468656D65436C';
wwv_flow_api.g_varchar2_table(366) := '617373203D20276170782D53706F746C696768742D69636F6E2D6F72616E6765273B0A202020202020202020202020627265616B3B0A20202020202020202020636173652027524544273A0A2020202020202020202020206170657853706F746C696768';
wwv_flow_api.g_varchar2_table(367) := '742E67526573756C744C6973745468656D65436C617373203D20276170782D53706F746C696768742D726573756C742D726564273B0A2020202020202020202020206170657853706F746C696768742E6749636F6E5468656D65436C617373203D202761';
wwv_flow_api.g_varchar2_table(368) := '70782D53706F746C696768742D69636F6E2D726564273B0A202020202020202020202020627265616B3B0A202020202020202020206361736520274441524B273A0A2020202020202020202020206170657853706F746C696768742E67526573756C744C';
wwv_flow_api.g_varchar2_table(369) := '6973745468656D65436C617373203D20276170782D53706F746C696768742D726573756C742D6461726B273B0A2020202020202020202020206170657853706F746C696768742E6749636F6E5468656D65436C617373203D20276170782D53706F746C69';
wwv_flow_api.g_varchar2_table(370) := '6768742D69636F6E2D6461726B273B0A202020202020202020202020627265616B3B0A20202020202020207D0A0A20202020202020202F2F206F70656E206469616C6F670A202020202020202069662028656E61626C654B6579626F61726453686F7274';
wwv_flow_api.g_varchar2_table(371) := '63757473203D3D2027592729207B0A202020202020202020206170657853706F746C696768742E6F70656E53706F746C696768744469616C6F674B6579626F61726453686F727463757428293B0A20202020202020207D20656C7365207B0A2020202020';
wwv_flow_api.g_varchar2_table(372) := '20202020206170657853706F746C696768742E6F70656E53706F746C696768744469616C6F6728293B0A20202020202020207D0A2020202020207D0A202020207D3B202F2F20656E64206E616D657370616365206170657853706F746C696768740A0A20';
wwv_flow_api.g_varchar2_table(373) := '2020202F2F2063616C6C207265616C20706C7567696E48616E646C65722066756E6374696F6E0A202020206170657853706F746C696768742E706C7567696E48616E646C657228704F7074696F6E73293B0A20207D0A7D3B0A';
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
wwv_flow_api.g_varchar2_table(1) := '2166756E6374696F6E28652C742C6E297B66756E6374696F6E207228652C742C6E297B652E6164644576656E744C697374656E65723F652E6164644576656E744C697374656E657228742C6E2C2131293A652E6174746163684576656E7428226F6E222B';
wwv_flow_api.g_varchar2_table(2) := '742C6E297D66756E6374696F6E20692865297B696628226B65797072657373223D3D652E74797065297B76617220743D537472696E672E66726F6D43686172436F646528652E7768696368293B72657475726E20652E73686966744B65797C7C28743D74';
wwv_flow_api.g_varchar2_table(3) := '2E746F4C6F776572436173652829292C747D72657475726E20705B652E77686963685D3F705B652E77686963685D3A685B652E77686963685D3F685B652E77686963685D3A537472696E672E66726F6D43686172436F646528652E7768696368292E746F';
wwv_flow_api.g_varchar2_table(4) := '4C6F7765724361736528297D66756E6374696F6E206F28652C74297B72657475726E20652E736F727428292E6A6F696E28222C22293D3D3D742E736F727428292E6A6F696E28222C22297D66756E6374696F6E20612865297B72657475726E2273686966';
wwv_flow_api.g_varchar2_table(5) := '74223D3D657C7C226374726C223D3D657C7C22616C74223D3D657C7C226D657461223D3D657D66756E6374696F6E206328652C742C6E297B72657475726E206E7C7C286E3D66756E6374696F6E28297B6966282166297B663D7B7D3B666F722876617220';
wwv_flow_api.g_varchar2_table(6) := '6520696E207029653E39352626653C3131327C7C702E6861734F776E50726F7065727479286529262628665B705B655D5D3D65297D72657475726E20667D28295B655D3F226B6579646F776E223A226B6579707265737322292C226B6579707265737322';
wwv_flow_api.g_varchar2_table(7) := '3D3D6E2626742E6C656E6774682626286E3D226B6579646F776E22292C6E7D66756E6374696F6E207328652C74297B766172206E2C722C692C6F3D5B5D3B666F72286E3D66756E6374696F6E2865297B72657475726E222B223D3D3D653F5B222B225D3A';
wwv_flow_api.g_varchar2_table(8) := '28653D652E7265706C616365282F5C2B7B327D2F672C222B706C75732229292E73706C697428222B22297D2865292C693D303B693C6E2E6C656E6774683B2B2B6929723D6E5B695D2C795B725D262628723D795B725D292C742626226B65797072657373';
wwv_flow_api.g_varchar2_table(9) := '22213D742626645B725D262628723D645B725D2C6F2E70757368282273686966742229292C6128722926266F2E707573682872293B72657475726E20743D6328722C6F2C74292C7B6B65793A722C6D6F646966696572733A6F2C616374696F6E3A747D7D';
wwv_flow_api.g_varchar2_table(10) := '66756E6374696F6E207528652C6E297B72657475726E206E756C6C213D3D65262665213D3D74262628653D3D3D6E7C7C7528652E706172656E744E6F64652C6E29297D66756E6374696F6E206C2865297B66756E6374696F6E206E2865297B653D657C7C';
wwv_flow_api.g_varchar2_table(11) := '7B7D3B76617220742C6E3D21313B666F72287420696E206D29655B745D3F6E3D21303A6D5B745D3D303B6E7C7C28623D2131297D66756E6374696F6E206328652C742C6E2C722C692C63297B76617220732C752C6C3D5B5D2C663D6E2E747970653B6966';
wwv_flow_api.g_varchar2_table(12) := '2821642E5F63616C6C6261636B735B655D2972657475726E5B5D3B666F7228226B65797570223D3D66262661286529262628743D5B655D292C733D303B733C642E5F63616C6C6261636B735B655D2E6C656E6774683B2B2B7329696628753D642E5F6361';
wwv_flow_api.g_varchar2_table(13) := '6C6C6261636B735B655D5B735D2C28727C7C21752E7365717C7C6D5B752E7365715D3D3D752E6C6576656C292626663D3D752E616374696F6E262628226B65797072657373223D3D662626216E2E6D6574614B65792626216E2E6374726C4B65797C7C6F';
wwv_flow_api.g_varchar2_table(14) := '28742C752E6D6F646966696572732929297B76617220703D21722626752E636F6D626F3D3D692C683D722626752E7365713D3D722626752E6C6576656C3D3D633B28707C7C68292626642E5F63616C6C6261636B735B655D2E73706C69636528732C3129';
wwv_flow_api.g_varchar2_table(15) := '2C6C2E707573682875297D72657475726E206C7D66756E6374696F6E207528652C742C6E2C72297B642E73746F7043616C6C6261636B28742C742E7461726765747C7C742E737263456C656D656E742C6E2C72297C7C21313D3D3D6528742C6E29262628';
wwv_flow_api.g_varchar2_table(16) := '66756E6374696F6E2865297B652E70726576656E7444656661756C743F652E70726576656E7444656661756C7428293A652E72657475726E56616C75653D21317D2874292C66756E6374696F6E2865297B652E73746F7050726F7061676174696F6E3F65';
wwv_flow_api.g_varchar2_table(17) := '2E73746F7050726F7061676174696F6E28293A652E63616E63656C427562626C653D21307D287429297D66756E6374696F6E20662865297B226E756D62657222213D747970656F6620652E7768696368262628652E77686963683D652E6B6579436F6465';
wwv_flow_api.g_varchar2_table(18) := '293B76617220743D692865293B74262628226B6579757022213D652E747970657C7C6B213D3D743F642E68616E646C654B657928742C66756E6374696F6E2865297B76617220743D5B5D3B72657475726E20652E73686966744B65792626742E70757368';
wwv_flow_api.g_varchar2_table(19) := '2822736869667422292C652E616C744B65792626742E707573682822616C7422292C652E6374726C4B65792626742E7075736828226374726C22292C652E6D6574614B65792626742E7075736828226D65746122292C747D2865292C65293A6B3D213129';
wwv_flow_api.g_varchar2_table(20) := '7D66756E6374696F6E207028652C742C722C6F297B66756E6374696F6E20612874297B72657475726E2066756E6374696F6E28297B623D742C2B2B6D5B655D2C636C65617254696D656F75742879292C793D73657454696D656F7574286E2C316533297D';
wwv_flow_api.g_varchar2_table(21) := '7D66756E6374696F6E20632874297B7528722C742C65292C226B6579757022213D3D6F2626286B3D69287429292C73657454696D656F7574286E2C3130297D6D5B655D3D303B666F7228766172206C3D303B6C3C742E6C656E6774683B2B2B6C297B7661';
wwv_flow_api.g_varchar2_table(22) := '7220663D6C2B313D3D3D742E6C656E6774683F633A61286F7C7C7328745B6C2B315D292E616374696F6E293B6828745B6C5D2C662C6F2C652C6C297D7D66756E6374696F6E206828652C742C6E2C722C69297B642E5F6469726563744D61705B652B223A';
wwv_flow_api.g_varchar2_table(23) := '222B6E5D3D743B766172206F2C613D28653D652E7265706C616365282F5C732B2F672C22202229292E73706C697428222022293B612E6C656E6774683E313F7028652C612C742C6E293A286F3D7328652C6E292C642E5F63616C6C6261636B735B6F2E6B';
wwv_flow_api.g_varchar2_table(24) := '65795D3D642E5F63616C6C6261636B735B6F2E6B65795D7C7C5B5D2C63286F2E6B65792C6F2E6D6F646966696572732C7B747970653A6F2E616374696F6E7D2C722C652C69292C642E5F63616C6C6261636B735B6F2E6B65795D5B723F22756E73686966';
wwv_flow_api.g_varchar2_table(25) := '74223A2270757368225D287B63616C6C6261636B3A742C6D6F646966696572733A6F2E6D6F646966696572732C616374696F6E3A6F2E616374696F6E2C7365713A722C6C6576656C3A692C636F6D626F3A657D29297D76617220643D746869733B696628';
wwv_flow_api.g_varchar2_table(26) := '653D657C7C742C21286420696E7374616E63656F66206C292972657475726E206E6577206C2865293B642E7461726765743D652C642E5F63616C6C6261636B733D7B7D2C642E5F6469726563744D61703D7B7D3B76617220792C6D3D7B7D2C6B3D21312C';
wwv_flow_api.g_varchar2_table(27) := '763D21312C623D21313B642E5F68616E646C654B65793D66756E6374696F6E28652C742C72297B76617220692C6F3D6328652C742C72292C733D7B7D2C6C3D302C663D21313B666F7228693D303B693C6F2E6C656E6774683B2B2B69296F5B695D2E7365';
wwv_flow_api.g_varchar2_table(28) := '712626286C3D4D6174682E6D6178286C2C6F5B695D2E6C6576656C29293B666F7228693D303B693C6F2E6C656E6774683B2B2B69296966286F5B695D2E736571297B6966286F5B695D2E6C6576656C213D6C29636F6E74696E75653B663D21302C735B6F';
wwv_flow_api.g_varchar2_table(29) := '5B695D2E7365715D3D312C75286F5B695D2E63616C6C6261636B2C722C6F5B695D2E636F6D626F2C6F5B695D2E736571297D656C736520667C7C75286F5B695D2E63616C6C6261636B2C722C6F5B695D2E636F6D626F293B76617220703D226B65797072';
wwv_flow_api.g_varchar2_table(30) := '657373223D3D722E747970652626763B722E74797065213D627C7C612865297C7C707C7C6E2873292C763D662626226B6579646F776E223D3D722E747970657D2C642E5F62696E644D756C7469706C653D66756E6374696F6E28652C742C6E297B666F72';
wwv_flow_api.g_varchar2_table(31) := '2876617220723D303B723C652E6C656E6774683B2B2B72296828655B725D2C742C6E297D2C7228652C226B65797072657373222C66292C7228652C226B6579646F776E222C66292C7228652C226B65797570222C66297D69662865297B666F7228766172';
wwv_flow_api.g_varchar2_table(32) := '20662C703D7B383A226261636B7370616365222C393A22746162222C31333A22656E746572222C31363A227368696674222C31373A226374726C222C31383A22616C74222C32303A22636170736C6F636B222C32373A22657363222C33323A2273706163';
wwv_flow_api.g_varchar2_table(33) := '65222C33333A22706167657570222C33343A2270616765646F776E222C33353A22656E64222C33363A22686F6D65222C33373A226C656674222C33383A227570222C33393A227269676874222C34303A22646F776E222C34353A22696E73222C34363A22';
wwv_flow_api.g_varchar2_table(34) := '64656C222C39313A226D657461222C39333A226D657461222C3232343A226D657461227D2C683D7B3130363A222A222C3130373A222B222C3130393A222D222C3131303A222E222C3131313A222F222C3138363A223B222C3138373A223D222C3138383A';
wwv_flow_api.g_varchar2_table(35) := '222C222C3138393A222D222C3139303A222E222C3139313A222F222C3139323A2260222C3231393A225B222C3232303A225C5C222C3232313A225D222C3232323A2227227D2C643D7B227E223A2260222C2221223A2231222C2240223A2232222C222322';
wwv_flow_api.g_varchar2_table(36) := '3A2233222C243A2234222C2225223A2235222C225E223A2236222C2226223A2237222C222A223A2238222C2228223A2239222C2229223A2230222C5F3A222D222C222B223A223D222C223A223A223B222C2722273A2227222C223C223A222C222C223E22';
wwv_flow_api.g_varchar2_table(37) := '3A222E222C223F223A222F222C227C223A225C5C227D2C793D7B6F7074696F6E3A22616C74222C636F6D6D616E643A226D657461222C72657475726E3A22656E746572222C6573636170653A22657363222C706C75733A222B222C6D6F643A2F4D61637C';
wwv_flow_api.g_varchar2_table(38) := '69506F647C6950686F6E657C695061642F2E74657374286E6176696761746F722E706C6174666F726D293F226D657461223A226374726C227D2C6D3D313B6D3C32303B2B2B6D29705B3131312B6D5D3D2266222B6D3B666F72286D3D303B6D3C3D393B2B';
wwv_flow_api.g_varchar2_table(39) := '2B6D29705B6D2B39365D3D6D2E746F537472696E6728293B6C2E70726F746F747970652E62696E643D66756E6374696F6E28652C742C6E297B72657475726E20653D6520696E7374616E63656F662041727261793F653A5B655D2C746869732E5F62696E';
wwv_flow_api.g_varchar2_table(40) := '644D756C7469706C652E63616C6C28746869732C652C742C6E292C746869737D2C6C2E70726F746F747970652E756E62696E643D66756E6374696F6E28652C74297B72657475726E20746869732E62696E642E63616C6C28746869732C652C66756E6374';
wwv_flow_api.g_varchar2_table(41) := '696F6E28297B7D2C74297D2C6C2E70726F746F747970652E747269676765723D66756E6374696F6E28652C74297B72657475726E20746869732E5F6469726563744D61705B652B223A222B745D2626746869732E5F6469726563744D61705B652B223A22';
wwv_flow_api.g_varchar2_table(42) := '2B745D287B7D2C65292C746869737D2C6C2E70726F746F747970652E72657365743D66756E6374696F6E28297B72657475726E20746869732E5F63616C6C6261636B733D7B7D2C746869732E5F6469726563744D61703D7B7D2C746869737D2C6C2E7072';
wwv_flow_api.g_varchar2_table(43) := '6F746F747970652E73746F7043616C6C6261636B3D66756E6374696F6E28652C74297B72657475726E2128282220222B742E636C6173734E616D652B222022292E696E6465784F662822206D6F757365747261702022293E2D3129262628217528742C74';
wwv_flow_api.g_varchar2_table(44) := '6869732E7461726765742926262822494E505554223D3D742E7461674E616D657C7C2253454C454354223D3D742E7461674E616D657C7C225445585441524541223D3D742E7461674E616D657C7C742E6973436F6E74656E744564697461626C6529297D';
wwv_flow_api.g_varchar2_table(45) := '2C6C2E70726F746F747970652E68616E646C654B65793D66756E6374696F6E28297B72657475726E20746869732E5F68616E646C654B65792E6170706C7928746869732C617267756D656E7473297D2C6C2E6164644B6579636F6465733D66756E637469';
wwv_flow_api.g_varchar2_table(46) := '6F6E2865297B666F7228766172207420696E206529652E6861734F776E50726F7065727479287429262628705B745D3D655B745D293B663D6E756C6C7D2C6C2E696E69743D66756E6374696F6E28297B76617220653D6C2874293B666F7228766172206E';
wwv_flow_api.g_varchar2_table(47) := '20696E206529225F22213D3D6E2E6368617241742830292626286C5B6E5D3D66756E6374696F6E2874297B72657475726E2066756E6374696F6E28297B72657475726E20655B745D2E6170706C7928652C617267756D656E7473297D7D286E29297D2C6C';
wwv_flow_api.g_varchar2_table(48) := '2E696E697428292C652E4D6F757365747261703D6C2C22756E646566696E656422213D747970656F66206D6F64756C6526266D6F64756C652E6578706F7274732626286D6F64756C652E6578706F7274733D6C292C2266756E6374696F6E223D3D747970';
wwv_flow_api.g_varchar2_table(49) := '656F6620646566696E652626646566696E652E616D642626646566696E652866756E6374696F6E28297B72657475726E206C7D297D7D2822756E646566696E656422213D747970656F662077696E646F773F77696E646F773A6E756C6C2C22756E646566';
wwv_flow_api.g_varchar2_table(50) := '696E656422213D747970656F662077696E646F773F646F63756D656E743A6E756C6C293B';
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
wwv_flow_api.g_varchar2_table(3) := '2275736520737472696374223B653D652626652E6861734F776E50726F7065727479282264656661756C7422293F652E64656661756C743A653B76617220743D2266756E6374696F6E223D3D747970656F662053796D626F6C26262273796D626F6C223D';
wwv_flow_api.g_varchar2_table(4) := '3D747970656F662053796D626F6C2E6974657261746F723F66756E6374696F6E2865297B72657475726E20747970656F6620657D3A66756E6374696F6E2865297B72657475726E206526262266756E6374696F6E223D3D747970656F662053796D626F6C';
wwv_flow_api.g_varchar2_table(5) := '2626652E636F6E7374727563746F723D3D3D53796D626F6C262665213D3D53796D626F6C2E70726F746F747970653F2273796D626F6C223A747970656F6620657D2C6E3D66756E6374696F6E28652C74297B69662821286520696E7374616E63656F6620';
wwv_flow_api.g_varchar2_table(6) := '7429297468726F77206E657720547970654572726F72282243616E6E6F742063616C6C206120636C61737320617320612066756E6374696F6E22297D2C723D66756E6374696F6E28297B66756E6374696F6E206528652C74297B666F7228766172206E3D';
wwv_flow_api.g_varchar2_table(7) := '303B6E3C742E6C656E6774683B6E2B2B297B76617220723D745B6E5D3B722E656E756D657261626C653D722E656E756D657261626C657C7C21312C722E636F6E666967757261626C653D21302C2276616C756522696E2072262628722E7772697461626C';
wwv_flow_api.g_varchar2_table(8) := '653D2130292C4F626A6563742E646566696E6550726F706572747928652C722E6B65792C72297D7D72657475726E2066756E6374696F6E28742C6E2C72297B72657475726E206E26266528742E70726F746F747970652C6E292C7226266528742C72292C';
wwv_flow_api.g_varchar2_table(9) := '747D7D28292C693D4F626A6563742E61737369676E7C7C66756E6374696F6E2865297B666F722876617220743D313B743C617267756D656E74732E6C656E6774683B742B2B297B766172206E3D617267756D656E74735B745D3B666F7228766172207220';
wwv_flow_api.g_varchar2_table(10) := '696E206E294F626A6563742E70726F746F747970652E6861734F776E50726F70657274792E63616C6C286E2C7229262628655B725D3D6E5B725D297D72657475726E20657D2C6F3D66756E6374696F6E28297B66756E6374696F6E20652874297B766172';
wwv_flow_api.g_varchar2_table(11) := '20723D2128617267756D656E74732E6C656E6774683E312626766F69642030213D3D617267756D656E74735B315D297C7C617267756D656E74735B315D2C693D617267756D656E74732E6C656E6774683E322626766F69642030213D3D617267756D656E';
wwv_flow_api.g_varchar2_table(12) := '74735B325D3F617267756D656E74735B325D3A5B5D2C6F3D617267756D656E74732E6C656E6774683E332626766F69642030213D3D617267756D656E74735B335D3F617267756D656E74735B335D3A3565333B6E28746869732C65292C746869732E6374';
wwv_flow_api.g_varchar2_table(13) := '783D742C746869732E696672616D65733D722C746869732E6578636C7564653D692C746869732E696672616D657354696D656F75743D6F7D72657475726E207228652C5B7B6B65793A22676574436F6E7465787473222C76616C75653A66756E6374696F';
wwv_flow_api.g_varchar2_table(14) := '6E28297B76617220653D5B5D3B72657475726E28766F69642030213D3D746869732E6374782626746869732E6374783F4E6F64654C6973742E70726F746F747970652E697350726F746F747970654F6628746869732E637478293F41727261792E70726F';
wwv_flow_api.g_varchar2_table(15) := '746F747970652E736C6963652E63616C6C28746869732E637478293A41727261792E6973417272617928746869732E637478293F746869732E6374783A22737472696E67223D3D747970656F6620746869732E6374783F41727261792E70726F746F7479';
wwv_flow_api.g_varchar2_table(16) := '70652E736C6963652E63616C6C28646F63756D656E742E717565727953656C6563746F72416C6C28746869732E63747829293A5B746869732E6374785D3A5B5D292E666F72456163682866756E6374696F6E2874297B766172206E3D652E66696C746572';
wwv_flow_api.g_varchar2_table(17) := '2866756E6374696F6E2865297B72657475726E20652E636F6E7461696E732874297D292E6C656E6774683E303B2D31213D3D652E696E6465784F662874297C7C6E7C7C652E707573682874297D292C657D7D2C7B6B65793A22676574496672616D65436F';
wwv_flow_api.g_varchar2_table(18) := '6E74656E7473222C76616C75653A66756E6374696F6E28652C74297B766172206E3D617267756D656E74732E6C656E6774683E322626766F69642030213D3D617267756D656E74735B325D3F617267756D656E74735B325D3A66756E6374696F6E28297B';
wwv_flow_api.g_varchar2_table(19) := '7D2C723D766F696420303B7472797B76617220693D652E636F6E74656E7457696E646F773B696628723D692E646F63756D656E742C21697C7C2172297468726F77206E6577204572726F722822696672616D6520696E61636365737369626C6522297D63';
wwv_flow_api.g_varchar2_table(20) := '617463682865297B6E28297D722626742872297D7D2C7B6B65793A226973496672616D65426C616E6B222C76616C75653A66756E6374696F6E2865297B76617220743D2261626F75743A626C616E6B222C6E3D652E676574417474726962757465282273';
wwv_flow_api.g_varchar2_table(21) := '726322292E7472696D28293B72657475726E20652E636F6E74656E7457696E646F772E6C6F636174696F6E2E687265663D3D3D7426266E213D3D7426266E7D7D2C7B6B65793A226F627365727665496672616D654C6F6164222C76616C75653A66756E63';
wwv_flow_api.g_varchar2_table(22) := '74696F6E28652C742C6E297B76617220723D746869732C693D21312C6F3D6E756C6C2C613D66756E6374696F6E206128297B6966282169297B693D21302C636C65617254696D656F7574286F293B7472797B722E6973496672616D65426C616E6B286529';
wwv_flow_api.g_varchar2_table(23) := '7C7C28652E72656D6F76654576656E744C697374656E657228226C6F6164222C61292C722E676574496672616D65436F6E74656E747328652C742C6E29297D63617463682865297B6E28297D7D7D3B652E6164644576656E744C697374656E657228226C';
wwv_flow_api.g_varchar2_table(24) := '6F6164222C61292C6F3D73657454696D656F757428612C746869732E696672616D657354696D656F7574297D7D2C7B6B65793A226F6E496672616D655265616479222C76616C75653A66756E6374696F6E28652C742C6E297B7472797B22636F6D706C65';
wwv_flow_api.g_varchar2_table(25) := '7465223D3D3D652E636F6E74656E7457696E646F772E646F63756D656E742E726561647953746174653F746869732E6973496672616D65426C616E6B2865293F746869732E6F627365727665496672616D654C6F616428652C742C6E293A746869732E67';
wwv_flow_api.g_varchar2_table(26) := '6574496672616D65436F6E74656E747328652C742C6E293A746869732E6F627365727665496672616D654C6F616428652C742C6E297D63617463682865297B6E28297D7D7D2C7B6B65793A2277616974466F72496672616D6573222C76616C75653A6675';
wwv_flow_api.g_varchar2_table(27) := '6E6374696F6E28652C74297B766172206E3D746869732C723D303B746869732E666F7245616368496672616D6528652C66756E6374696F6E28297B72657475726E21307D2C66756E6374696F6E2865297B722B2B2C6E2E77616974466F72496672616D65';
wwv_flow_api.g_varchar2_table(28) := '7328652E717565727953656C6563746F72282268746D6C22292C66756E6374696F6E28297B2D2D727C7C7428297D297D2C66756E6374696F6E2865297B657C7C7428297D297D7D2C7B6B65793A22666F7245616368496672616D65222C76616C75653A66';
wwv_flow_api.g_varchar2_table(29) := '756E6374696F6E28742C6E2C72297B76617220693D746869732C6F3D617267756D656E74732E6C656E6774683E332626766F69642030213D3D617267756D656E74735B335D3F617267756D656E74735B335D3A66756E6374696F6E28297B7D2C613D742E';
wwv_flow_api.g_varchar2_table(30) := '717565727953656C6563746F72416C6C2822696672616D6522292C733D612E6C656E6774682C633D303B613D41727261792E70726F746F747970652E736C6963652E63616C6C2861293B76617220753D66756E6374696F6E28297B2D2D733C3D3026266F';
wwv_flow_api.g_varchar2_table(31) := '2863297D3B737C7C7528292C612E666F72456163682866756E6374696F6E2874297B652E6D61746368657328742C692E6578636C756465293F7528293A692E6F6E496672616D65526561647928742C66756E6374696F6E2865297B6E287429262628632B';
wwv_flow_api.g_varchar2_table(32) := '2B2C72286529292C7528297D2C75297D297D7D2C7B6B65793A226372656174654974657261746F72222C76616C75653A66756E6374696F6E28652C742C6E297B72657475726E20646F63756D656E742E6372656174654E6F64654974657261746F722865';
wwv_flow_api.g_varchar2_table(33) := '2C742C6E2C2131297D7D2C7B6B65793A22637265617465496E7374616E63654F6E496672616D65222C76616C75653A66756E6374696F6E2874297B72657475726E206E6577206528742E717565727953656C6563746F72282268746D6C22292C74686973';
wwv_flow_api.g_varchar2_table(34) := '2E696672616D6573297D7D2C7B6B65793A22636F6D706172654E6F6465496672616D65222C76616C75653A66756E6374696F6E28652C742C6E297B696628652E636F6D70617265446F63756D656E74506F736974696F6E286E29264E6F64652E444F4355';
wwv_flow_api.g_varchar2_table(35) := '4D454E545F504F534954494F4E5F505245434544494E47297B6966286E756C6C3D3D3D742972657475726E21303B696628742E636F6D70617265446F63756D656E74506F736974696F6E286E29264E6F64652E444F43554D454E545F504F534954494F4E';
wwv_flow_api.g_varchar2_table(36) := '5F464F4C4C4F57494E472972657475726E21307D72657475726E21317D7D2C7B6B65793A226765744974657261746F724E6F6465222C76616C75653A66756E6374696F6E2865297B76617220743D652E70726576696F75734E6F646528292C6E3D766F69';
wwv_flow_api.g_varchar2_table(37) := '6420303B72657475726E206E3D6E756C6C3D3D3D743F652E6E6578744E6F646528293A652E6E6578744E6F646528292626652E6E6578744E6F646528292C7B707265764E6F64653A742C6E6F64653A6E7D7D7D2C7B6B65793A22636865636B496672616D';
wwv_flow_api.g_varchar2_table(38) := '6546696C746572222C76616C75653A66756E6374696F6E28652C742C6E2C72297B76617220693D21312C6F3D21313B72657475726E20722E666F72456163682866756E6374696F6E28652C74297B652E76616C3D3D3D6E262628693D742C6F3D652E6861';
wwv_flow_api.g_varchar2_table(39) := '6E646C6564297D292C746869732E636F6D706172654E6F6465496672616D6528652C742C6E293F282131213D3D697C7C6F3F21313D3D3D697C7C6F7C7C28725B695D2E68616E646C65643D2130293A722E70757368287B76616C3A6E2C68616E646C6564';
wwv_flow_api.g_varchar2_table(40) := '3A21307D292C2130293A2821313D3D3D692626722E70757368287B76616C3A6E2C68616E646C65643A21317D292C2131297D7D2C7B6B65793A2268616E646C654F70656E496672616D6573222C76616C75653A66756E6374696F6E28652C742C6E2C7229';
wwv_flow_api.g_varchar2_table(41) := '7B76617220693D746869733B652E666F72456163682866756E6374696F6E2865297B652E68616E646C65647C7C692E676574496672616D65436F6E74656E747328652E76616C2C66756E6374696F6E2865297B692E637265617465496E7374616E63654F';
wwv_flow_api.g_varchar2_table(42) := '6E496672616D652865292E666F72456163684E6F646528742C6E2C72297D297D297D7D2C7B6B65793A22697465726174655468726F7567684E6F646573222C76616C75653A66756E6374696F6E28652C742C6E2C722C69297B666F7228766172206F3D74';
wwv_flow_api.g_varchar2_table(43) := '6869732C613D746869732E6372656174654974657261746F7228742C652C72292C733D5B5D2C633D5B5D2C753D766F696420302C6C3D766F696420302C683D66756E6374696F6E28297B76617220653D6F2E6765744974657261746F724E6F6465286129';
wwv_flow_api.g_varchar2_table(44) := '3B72657475726E206C3D652E707265764E6F64652C753D652E6E6F64657D3B6828293B29746869732E696672616D65732626746869732E666F7245616368496672616D6528742C66756E6374696F6E2865297B72657475726E206F2E636865636B496672';
wwv_flow_api.g_varchar2_table(45) := '616D6546696C74657228752C6C2C652C73297D2C66756E6374696F6E2874297B6F2E637265617465496E7374616E63654F6E496672616D652874292E666F72456163684E6F646528652C66756E6374696F6E2865297B72657475726E20632E7075736828';
wwv_flow_api.g_varchar2_table(46) := '65297D2C72297D292C632E707573682875293B632E666F72456163682866756E6374696F6E2865297B6E2865297D292C746869732E696672616D65732626746869732E68616E646C654F70656E496672616D657328732C652C6E2C72292C6928297D7D2C';
wwv_flow_api.g_varchar2_table(47) := '7B6B65793A22666F72456163684E6F6465222C76616C75653A66756E6374696F6E28652C742C6E297B76617220723D746869732C693D617267756D656E74732E6C656E6774683E332626766F69642030213D3D617267756D656E74735B335D3F61726775';
wwv_flow_api.g_varchar2_table(48) := '6D656E74735B335D3A66756E6374696F6E28297B7D2C6F3D746869732E676574436F6E746578747328292C613D6F2E6C656E6774683B617C7C6928292C6F2E666F72456163682866756E6374696F6E286F297B76617220733D66756E6374696F6E28297B';
wwv_flow_api.g_varchar2_table(49) := '722E697465726174655468726F7567684E6F64657328652C6F2C742C6E2C66756E6374696F6E28297B2D2D613C3D3026266928297D297D3B722E696672616D65733F722E77616974466F72496672616D6573286F2C73293A7328297D297D7D5D2C5B7B6B';
wwv_flow_api.g_varchar2_table(50) := '65793A226D617463686573222C76616C75653A66756E6374696F6E28652C74297B766172206E3D22737472696E67223D3D747970656F6620743F5B745D3A742C723D652E6D6174636865737C7C652E6D61746368657353656C6563746F727C7C652E6D73';
wwv_flow_api.g_varchar2_table(51) := '4D61746368657353656C6563746F727C7C652E6D6F7A4D61746368657353656C6563746F727C7C652E6F4D61746368657353656C6563746F727C7C652E7765626B69744D61746368657353656C6563746F723B69662872297B76617220693D21313B7265';
wwv_flow_api.g_varchar2_table(52) := '7475726E206E2E65766572792866756E6374696F6E2874297B72657475726E21722E63616C6C28652C74297C7C28693D21302C2131297D292C697D72657475726E21317D7D5D292C657D28292C613D66756E6374696F6E28297B66756E6374696F6E2065';
wwv_flow_api.g_varchar2_table(53) := '2874297B6E28746869732C65292C746869732E6374783D742C746869732E69653D21313B76617220723D77696E646F772E6E6176696761746F722E757365724167656E743B28722E696E6465784F6628224D53494522293E2D317C7C722E696E6465784F';
wwv_flow_api.g_varchar2_table(54) := '66282254726964656E7422293E2D3129262628746869732E69653D2130297D72657475726E207228652C5B7B6B65793A226C6F67222C76616C75653A66756E6374696F6E2865297B766172206E3D617267756D656E74732E6C656E6774683E312626766F';
wwv_flow_api.g_varchar2_table(55) := '69642030213D3D617267756D656E74735B315D3F617267756D656E74735B315D3A226465627567222C723D746869732E6F70742E6C6F673B746869732E6F70742E64656275672626226F626A656374223D3D3D28766F696420303D3D3D723F22756E6465';
wwv_flow_api.g_varchar2_table(56) := '66696E6564223A742872292926262266756E6374696F6E223D3D747970656F6620725B6E5D2626725B6E5D28226D61726B2E6A733A20222B65297D7D2C7B6B65793A22657363617065537472222C76616C75653A66756E6374696F6E2865297B72657475';
wwv_flow_api.g_varchar2_table(57) := '726E20652E7265706C616365282F5B5C2D5C5B5C5D5C2F5C7B5C7D5C285C295C2A5C2B5C3F5C2E5C5C5C5E5C245C7C5D2F672C225C5C242622297D7D2C7B6B65793A22637265617465526567457870222C76616C75653A66756E6374696F6E2865297B72';
wwv_flow_api.g_varchar2_table(58) := '657475726E2264697361626C656422213D3D746869732E6F70742E77696C646361726473262628653D746869732E736574757057696C646361726473526567457870286529292C653D746869732E6573636170655374722865292C4F626A6563742E6B65';
wwv_flow_api.g_varchar2_table(59) := '797328746869732E6F70742E73796E6F6E796D73292E6C656E677468262628653D746869732E63726561746553796E6F6E796D73526567457870286529292C28746869732E6F70742E69676E6F72654A6F696E6572737C7C746869732E6F70742E69676E';
wwv_flow_api.g_varchar2_table(60) := '6F726550756E6374756174696F6E2E6C656E67746829262628653D746869732E736574757049676E6F72654A6F696E657273526567457870286529292C746869732E6F70742E64696163726974696373262628653D746869732E63726561746544696163';
wwv_flow_api.g_varchar2_table(61) := '726974696373526567457870286529292C653D746869732E6372656174654D6572676564426C616E6B735265674578702865292C28746869732E6F70742E69676E6F72654A6F696E6572737C7C746869732E6F70742E69676E6F726550756E6374756174';
wwv_flow_api.g_varchar2_table(62) := '696F6E2E6C656E67746829262628653D746869732E6372656174654A6F696E657273526567457870286529292C2264697361626C656422213D3D746869732E6F70742E77696C646361726473262628653D746869732E63726561746557696C6463617264';
wwv_flow_api.g_varchar2_table(63) := '73526567457870286529292C653D746869732E63726561746541636375726163795265674578702865297D7D2C7B6B65793A2263726561746553796E6F6E796D73526567457870222C76616C75653A66756E6374696F6E2865297B76617220743D746869';
wwv_flow_api.g_varchar2_table(64) := '732E6F70742E73796E6F6E796D732C6E3D746869732E6F70742E6361736553656E7369746976653F22223A2269222C723D746869732E6F70742E69676E6F72654A6F696E6572737C7C746869732E6F70742E69676E6F726550756E6374756174696F6E2E';
wwv_flow_api.g_varchar2_table(65) := '6C656E6774683F225C30223A22223B666F7228766172206920696E207429696628742E6861734F776E50726F7065727479286929297B766172206F3D745B695D2C613D2264697361626C656422213D3D746869732E6F70742E77696C6463617264733F74';
wwv_flow_api.g_varchar2_table(66) := '6869732E736574757057696C6463617264735265674578702869293A746869732E6573636170655374722869292C733D2264697361626C656422213D3D746869732E6F70742E77696C6463617264733F746869732E736574757057696C64636172647352';
wwv_flow_api.g_varchar2_table(67) := '6567457870286F293A746869732E657363617065537472286F293B2222213D3D6126262222213D3D73262628653D652E7265706C616365286E657720526567457870282228222B746869732E6573636170655374722861292B227C222B746869732E6573';
wwv_flow_api.g_varchar2_table(68) := '636170655374722873292B2229222C22676D222B6E292C722B2228222B746869732E70726F6365737353796E6F6D796D732861292B227C222B746869732E70726F6365737353796E6F6D796D732873292B2229222B7229297D72657475726E20657D7D2C';
wwv_flow_api.g_varchar2_table(69) := '7B6B65793A2270726F6365737353796E6F6D796D73222C76616C75653A66756E6374696F6E2865297B72657475726E28746869732E6F70742E69676E6F72654A6F696E6572737C7C746869732E6F70742E69676E6F726550756E6374756174696F6E2E6C';
wwv_flow_api.g_varchar2_table(70) := '656E67746829262628653D746869732E736574757049676E6F72654A6F696E657273526567457870286529292C657D7D2C7B6B65793A22736574757057696C646361726473526567457870222C76616C75653A66756E6374696F6E2865297B7265747572';
wwv_flow_api.g_varchar2_table(71) := '6E28653D652E7265706C616365282F283F3A5C5C292A5C3F2F672C66756E6374696F6E2865297B72657475726E225C5C223D3D3D652E6368617241742830293F223F223A2201227D29292E7265706C616365282F283F3A5C5C292A5C2A2F672C66756E63';
wwv_flow_api.g_varchar2_table(72) := '74696F6E2865297B72657475726E225C5C223D3D3D652E6368617241742830293F222A223A2202227D297D7D2C7B6B65793A2263726561746557696C646361726473526567457870222C76616C75653A66756E6374696F6E2865297B76617220743D2277';
wwv_flow_api.g_varchar2_table(73) := '697468537061636573223D3D3D746869732E6F70742E77696C6463617264733B72657475726E20652E7265706C616365282F5C75303030312F672C743F225B5C5C535C5C735D3F223A225C5C533F22292E7265706C616365282F5C75303030322F672C74';
wwv_flow_api.g_varchar2_table(74) := '3F225B5C5C535C5C735D2A3F223A225C5C532A22297D7D2C7B6B65793A22736574757049676E6F72654A6F696E657273526567457870222C76616C75653A66756E6374696F6E2865297B72657475726E20652E7265706C616365282F5B5E287C295C5C5D';
wwv_flow_api.g_varchar2_table(75) := '2F672C66756E6374696F6E28652C742C6E297B76617220723D6E2E63686172417428742B31293B72657475726E2F5B287C295C5C5D2F2E746573742872297C7C22223D3D3D723F653A652B225C30227D297D7D2C7B6B65793A226372656174654A6F696E';
wwv_flow_api.g_varchar2_table(76) := '657273526567457870222C76616C75653A66756E6374696F6E2865297B76617220743D5B5D2C6E3D746869732E6F70742E69676E6F726550756E6374756174696F6E3B72657475726E2041727261792E69734172726179286E2926266E2E6C656E677468';
wwv_flow_api.g_varchar2_table(77) := '2626742E7075736828746869732E657363617065537472286E2E6A6F696E2822222929292C746869732E6F70742E69676E6F72654A6F696E6572732626742E7075736828225C5C75303061645C5C75323030625C5C75323030635C5C753230306422292C';
wwv_flow_api.g_varchar2_table(78) := '742E6C656E6774683F652E73706C6974282F5C75303030302B2F292E6A6F696E28225B222B742E6A6F696E282222292B225D2A22293A657D7D2C7B6B65793A2263726561746544696163726974696373526567457870222C76616C75653A66756E637469';
wwv_flow_api.g_varchar2_table(79) := '6F6E2865297B76617220743D746869732E6F70742E6361736553656E7369746976653F22223A2269222C6E3D746869732E6F70742E6361736553656E7369746976653F5B2261C3A0C3A1E1BAA3C3A3E1BAA1C483E1BAB1E1BAAFE1BAB3E1BAB5E1BAB7C3';
wwv_flow_api.g_varchar2_table(80) := 'A2E1BAA7E1BAA5E1BAA9E1BAABE1BAADC3A4C3A5C481C485222C2241C380C381E1BAA2C383E1BAA0C482E1BAB0E1BAAEE1BAB2E1BAB4E1BAB6C382E1BAA6E1BAA4E1BAA8E1BAAAE1BAACC384C385C480C484222C2263C3A7C487C48D222C2243C387C486';
wwv_flow_api.g_varchar2_table(81) := 'C48C222C2264C491C48F222C2244C490C48E222C2265C3A8C3A9E1BABBE1BABDE1BAB9C3AAE1BB81E1BABFE1BB83E1BB85E1BB87C3ABC49BC493C499222C2245C388C389E1BABAE1BABCE1BAB8C38AE1BB80E1BABEE1BB82E1BB84E1BB86C38BC49AC492';
wwv_flow_api.g_varchar2_table(82) := 'C498222C2269C3ACC3ADE1BB89C4A9E1BB8BC3AEC3AFC4AB222C2249C38CC38DE1BB88C4A8E1BB8AC38EC38FC4AA222C226CC582222C224CC581222C226EC3B1C588C584222C224EC391C587C583222C226FC3B2C3B3E1BB8FC3B5E1BB8DC3B4E1BB93E1';
wwv_flow_api.g_varchar2_table(83) := 'BB91E1BB95E1BB97E1BB99C6A1E1BB9FE1BBA1E1BB9BE1BB9DE1BBA3C3B6C3B8C58D222C224FC392C393E1BB8EC395E1BB8CC394E1BB92E1BB90E1BB94E1BB96E1BB98C6A0E1BB9EE1BBA0E1BB9AE1BB9CE1BBA2C396C398C58C222C2272C599222C2252';
wwv_flow_api.g_varchar2_table(84) := 'C598222C2273C5A1C59BC899C59F222C2253C5A0C59AC898C59E222C2274C5A5C89BC5A3222C2254C5A4C89AC5A2222C2275C3B9C3BAE1BBA7C5A9E1BBA5C6B0E1BBABE1BBA9E1BBADE1BBAFE1BBB1C3BBC3BCC5AFC5AB222C2255C399C39AE1BBA6C5A8';
wwv_flow_api.g_varchar2_table(85) := 'E1BBA4C6AFE1BBAAE1BBA8E1BBACE1BBAEE1BBB0C39BC39CC5AEC5AA222C2279C3BDE1BBB3E1BBB7E1BBB9E1BBB5C3BF222C2259C39DE1BBB2E1BBB6E1BBB8E1BBB4C5B8222C227AC5BEC5BCC5BA222C225AC5BDC5BBC5B9225D3A5B2261C3A0C3A1E1BA';
wwv_flow_api.g_varchar2_table(86) := 'A3C3A3E1BAA1C483E1BAB1E1BAAFE1BAB3E1BAB5E1BAB7C3A2E1BAA7E1BAA5E1BAA9E1BAABE1BAADC3A4C3A5C481C48541C380C381E1BAA2C383E1BAA0C482E1BAB0E1BAAEE1BAB2E1BAB4E1BAB6C382E1BAA6E1BAA4E1BAA8E1BAAAE1BAACC384C385C4';
wwv_flow_api.g_varchar2_table(87) := '80C484222C2263C3A7C487C48D43C387C486C48C222C2264C491C48F44C490C48E222C2265C3A8C3A9E1BABBE1BABDE1BAB9C3AAE1BB81E1BABFE1BB83E1BB85E1BB87C3ABC49BC493C49945C388C389E1BABAE1BABCE1BAB8C38AE1BB80E1BABEE1BB82';
wwv_flow_api.g_varchar2_table(88) := 'E1BB84E1BB86C38BC49AC492C498222C2269C3ACC3ADE1BB89C4A9E1BB8BC3AEC3AFC4AB49C38CC38DE1BB88C4A8E1BB8AC38EC38FC4AA222C226CC5824CC581222C226EC3B1C588C5844EC391C587C583222C226FC3B2C3B3E1BB8FC3B5E1BB8DC3B4E1';
wwv_flow_api.g_varchar2_table(89) := 'BB93E1BB91E1BB95E1BB97E1BB99C6A1E1BB9FE1BBA1E1BB9BE1BB9DE1BBA3C3B6C3B8C58D4FC392C393E1BB8EC395E1BB8CC394E1BB92E1BB90E1BB94E1BB96E1BB98C6A0E1BB9EE1BBA0E1BB9AE1BB9CE1BBA2C396C398C58C222C2272C59952C59822';
wwv_flow_api.g_varchar2_table(90) := '2C2273C5A1C59BC899C59F53C5A0C59AC898C59E222C2274C5A5C89BC5A354C5A4C89AC5A2222C2275C3B9C3BAE1BBA7C5A9E1BBA5C6B0E1BBABE1BBA9E1BBADE1BBAFE1BBB1C3BBC3BCC5AFC5AB55C399C39AE1BBA6C5A8E1BBA4C6AFE1BBAAE1BBA8E1';
wwv_flow_api.g_varchar2_table(91) := 'BBACE1BBAEE1BBB0C39BC39CC5AEC5AA222C2279C3BDE1BBB3E1BBB7E1BBB9E1BBB5C3BF59C39DE1BBB2E1BBB6E1BBB8E1BBB4C5B8222C227AC5BEC5BCC5BA5AC5BDC5BBC5B9225D2C723D5B5D3B72657475726E20652E73706C6974282222292E666F72';
wwv_flow_api.g_varchar2_table(92) := '456163682866756E6374696F6E2869297B6E2E65766572792866756E6374696F6E286E297B6966282D31213D3D6E2E696E6465784F66286929297B696628722E696E6465784F66286E293E2D312972657475726E21313B653D652E7265706C616365286E';
wwv_flow_api.g_varchar2_table(93) := '65772052656745787028225B222B6E2B225D222C22676D222B74292C225B222B6E2B225D22292C722E70757368286E297D72657475726E21307D297D292C657D7D2C7B6B65793A226372656174654D6572676564426C616E6B73526567457870222C7661';
wwv_flow_api.g_varchar2_table(94) := '6C75653A66756E6374696F6E2865297B72657475726E20652E7265706C616365282F5B5C735D2B2F67696D2C225B5C5C735D2B22297D7D2C7B6B65793A226372656174654163637572616379526567457870222C76616C75653A66756E6374696F6E2865';
wwv_flow_api.g_varchar2_table(95) := '297B76617220743D746869732C6E3D746869732E6F70742E61636375726163792C723D22737472696E67223D3D747970656F66206E3F6E3A6E2E76616C75652C693D22223B737769746368282822737472696E67223D3D747970656F66206E3F5B5D3A6E';
wwv_flow_api.g_varchar2_table(96) := '2E6C696D6974657273292E666F72456163682866756E6374696F6E2865297B692B3D227C222B742E6573636170655374722865297D292C72297B63617365227061727469616C6C79223A64656661756C743A72657475726E22282928222B652B2229223B';
wwv_flow_api.g_varchar2_table(97) := '6361736522636F6D706C656D656E74617279223A72657475726E222829285B5E222B28693D225C5C73222B28697C7C746869732E6573636170655374722822215C22232425262728292A2B2C2D2E2F3A3B3C3D3E3F405B5C5C5D5E5F607B7C7D7EC2A1C2';
wwv_flow_api.g_varchar2_table(98) := 'BF222929292B225D2A222B652B225B5E222B692B225D2A29223B636173652265786163746C79223A72657475726E22285E7C5C5C73222B692B222928222B652B2229283F3D247C5C5C73222B692B2229227D7D7D2C7B6B65793A22676574536570617261';
wwv_flow_api.g_varchar2_table(99) := '7465644B6579776F726473222C76616C75653A66756E6374696F6E2865297B76617220743D746869732C6E3D5B5D3B72657475726E20652E666F72456163682866756E6374696F6E2865297B742E6F70742E7365706172617465576F7264536561726368';
wwv_flow_api.g_varchar2_table(100) := '3F652E73706C697428222022292E666F72456163682866756E6374696F6E2865297B652E7472696D282926262D313D3D3D6E2E696E6465784F6628652926266E2E707573682865297D293A652E7472696D282926262D313D3D3D6E2E696E6465784F6628';
wwv_flow_api.g_varchar2_table(101) := '652926266E2E707573682865297D292C7B6B6579776F7264733A6E2E736F72742866756E6374696F6E28652C74297B72657475726E20742E6C656E6774682D652E6C656E6774687D292C6C656E6774683A6E2E6C656E6774687D7D7D2C7B6B65793A2269';
wwv_flow_api.g_varchar2_table(102) := '734E756D65726963222C76616C75653A66756E6374696F6E2865297B72657475726E204E756D626572287061727365466C6F6174286529293D3D657D7D2C7B6B65793A22636865636B52616E676573222C76616C75653A66756E6374696F6E2865297B76';
wwv_flow_api.g_varchar2_table(103) := '617220743D746869733B6966282141727261792E697341727261792865297C7C225B6F626A656374204F626A6563745D22213D3D4F626A6563742E70726F746F747970652E746F537472696E672E63616C6C28655B305D292972657475726E2074686973';
wwv_flow_api.g_varchar2_table(104) := '2E6C6F6728226D61726B52616E67657328292077696C6C206F6E6C792061636365707420616E206172726179206F66206F626A6563747322292C746869732E6F70742E6E6F4D617463682865292C5B5D3B766172206E3D5B5D2C723D303B72657475726E';
wwv_flow_api.g_varchar2_table(105) := '20652E736F72742866756E6374696F6E28652C74297B72657475726E20652E73746172742D742E73746172747D292E666F72456163682866756E6374696F6E2865297B76617220693D742E63616C6C4E6F4D617463684F6E496E76616C696452616E6765';
wwv_flow_api.g_varchar2_table(106) := '7328652C72292C6F3D692E73746172742C613D692E656E643B692E76616C6964262628652E73746172743D6F2C652E6C656E6774683D612D6F2C6E2E707573682865292C723D61297D292C6E7D7D2C7B6B65793A2263616C6C4E6F4D617463684F6E496E';
wwv_flow_api.g_varchar2_table(107) := '76616C696452616E676573222C76616C75653A66756E6374696F6E28652C74297B766172206E3D766F696420302C723D766F696420302C693D21313B72657475726E20652626766F69642030213D3D652E73746172743F28723D286E3D7061727365496E';
wwv_flow_api.g_varchar2_table(108) := '7428652E73746172742C313029292B7061727365496E7428652E6C656E6774682C3130292C746869732E69734E756D6572696328652E7374617274292626746869732E69734E756D6572696328652E6C656E677468292626722D743E302626722D6E3E30';
wwv_flow_api.g_varchar2_table(109) := '3F693D21303A28746869732E6C6F67282249676E6F72696E6720696E76616C6964206F72206F7665726C617070696E672072616E67653A20222B4A534F4E2E737472696E67696679286529292C746869732E6F70742E6E6F4D6174636828652929293A28';
wwv_flow_api.g_varchar2_table(110) := '746869732E6C6F67282249676E6F72696E6720696E76616C69642072616E67653A20222B4A534F4E2E737472696E67696679286529292C746869732E6F70742E6E6F4D61746368286529292C7B73746172743A6E2C656E643A722C76616C69643A697D7D';
wwv_flow_api.g_varchar2_table(111) := '7D2C7B6B65793A22636865636B5768697465737061636552616E676573222C76616C75653A66756E6374696F6E28652C742C6E297B76617220723D766F696420302C693D21302C6F3D6E2E6C656E6774682C613D742D6F2C733D7061727365496E742865';
wwv_flow_api.g_varchar2_table(112) := '2E73746172742C3130292D613B72657475726E20733D733E6F3F6F3A732C28723D732B7061727365496E7428652E6C656E6774682C313029293E6F262628723D6F2C746869732E6C6F672822456E642072616E6765206175746F6D61746963616C6C7920';
wwv_flow_api.g_varchar2_table(113) := '73657420746F20746865206D61782076616C7565206F6620222B6F29292C733C307C7C722D733C307C7C733E6F7C7C723E6F3F28693D21312C746869732E6C6F672822496E76616C69642072616E67653A20222B4A534F4E2E737472696E676966792865';
wwv_flow_api.g_varchar2_table(114) := '29292C746869732E6F70742E6E6F4D61746368286529293A22223D3D3D6E2E737562737472696E6728732C72292E7265706C616365282F5C732B2F672C222229262628693D21312C746869732E6C6F672822536B697070696E6720776869746573706163';
wwv_flow_api.g_varchar2_table(115) := '65206F6E6C792072616E67653A20222B4A534F4E2E737472696E67696679286529292C746869732E6F70742E6E6F4D61746368286529292C7B73746172743A732C656E643A722C76616C69643A697D7D7D2C7B6B65793A22676574546578744E6F646573';
wwv_flow_api.g_varchar2_table(116) := '222C76616C75653A66756E6374696F6E2865297B76617220743D746869732C6E3D22222C723D5B5D3B746869732E6974657261746F722E666F72456163684E6F6465284E6F646546696C7465722E53484F575F544558542C66756E6374696F6E2865297B';
wwv_flow_api.g_varchar2_table(117) := '722E70757368287B73746172743A6E2E6C656E6774682C656E643A286E2B3D652E74657874436F6E74656E74292E6C656E6774682C6E6F64653A657D297D2C66756E6374696F6E2865297B72657475726E20742E6D6174636865734578636C7564652865';
wwv_flow_api.g_varchar2_table(118) := '2E706172656E744E6F6465293F4E6F646546696C7465722E46494C5445525F52454A4543543A4E6F646546696C7465722E46494C5445525F4143434550547D2C66756E6374696F6E28297B65287B76616C75653A6E2C6E6F6465733A727D297D297D7D2C';
wwv_flow_api.g_varchar2_table(119) := '7B6B65793A226D6174636865734578636C756465222C76616C75653A66756E6374696F6E2865297B72657475726E206F2E6D61746368657328652C746869732E6F70742E6578636C7564652E636F6E636174285B22736372697074222C227374796C6522';
wwv_flow_api.g_varchar2_table(120) := '2C227469746C65222C2268656164222C2268746D6C225D29297D7D2C7B6B65793A227772617052616E6765496E546578744E6F6465222C76616C75653A66756E6374696F6E28652C742C6E297B76617220723D746869732E6F70742E656C656D656E743F';
wwv_flow_api.g_varchar2_table(121) := '746869732E6F70742E656C656D656E743A226D61726B222C693D652E73706C6974546578742874292C6F3D692E73706C697454657874286E2D74292C613D646F63756D656E742E637265617465456C656D656E742872293B72657475726E20612E736574';
wwv_flow_api.g_varchar2_table(122) := '4174747269627574652822646174612D6D61726B6A73222C227472756522292C746869732E6F70742E636C6173734E616D652626612E7365744174747269627574652822636C617373222C746869732E6F70742E636C6173734E616D65292C612E746578';
wwv_flow_api.g_varchar2_table(123) := '74436F6E74656E743D692E74657874436F6E74656E742C692E706172656E744E6F64652E7265706C6163654368696C6428612C69292C6F7D7D2C7B6B65793A227772617052616E6765496E4D6170706564546578744E6F6465222C76616C75653A66756E';
wwv_flow_api.g_varchar2_table(124) := '6374696F6E28652C742C6E2C722C69297B766172206F3D746869733B652E6E6F6465732E65766572792866756E6374696F6E28612C73297B76617220633D652E6E6F6465735B732B315D3B696628766F696420303D3D3D637C7C632E73746172743E7429';
wwv_flow_api.g_varchar2_table(125) := '7B696628217228612E6E6F6465292972657475726E21313B76617220753D742D612E73746172742C6C3D286E3E612E656E643F612E656E643A6E292D612E73746172742C683D652E76616C75652E73756273747228302C612E7374617274292C663D652E';
wwv_flow_api.g_varchar2_table(126) := '76616C75652E737562737472286C2B612E7374617274293B696628612E6E6F64653D6F2E7772617052616E6765496E546578744E6F646528612E6E6F64652C752C6C292C652E76616C75653D682B662C652E6E6F6465732E666F72456163682866756E63';
wwv_flow_api.g_varchar2_table(127) := '74696F6E28742C6E297B6E3E3D73262628652E6E6F6465735B6E5D2E73746172743E3026266E213D3D73262628652E6E6F6465735B6E5D2E73746172742D3D6C292C652E6E6F6465735B6E5D2E656E642D3D6C297D292C6E2D3D6C2C6928612E6E6F6465';
wwv_flow_api.g_varchar2_table(128) := '2E70726576696F75735369626C696E672C612E7374617274292C21286E3E612E656E64292972657475726E21313B743D612E656E647D72657475726E21307D297D7D2C7B6B65793A22777261704D617463686573222C76616C75653A66756E6374696F6E';
wwv_flow_api.g_varchar2_table(129) := '28652C742C6E2C722C69297B766172206F3D746869732C613D303D3D3D743F303A742B313B746869732E676574546578744E6F6465732866756E6374696F6E2874297B742E6E6F6465732E666F72456163682866756E6374696F6E2874297B743D742E6E';
wwv_flow_api.g_varchar2_table(130) := '6F64653B666F722876617220693D766F696420303B6E756C6C213D3D28693D652E6578656328742E74657874436F6E74656E74292926262222213D3D695B615D3B296966286E28695B615D2C7429297B76617220733D692E696E6465783B69662830213D';
wwv_flow_api.g_varchar2_table(131) := '3D6129666F722876617220633D313B633C613B632B2B29732B3D695B635D2E6C656E6774683B743D6F2E7772617052616E6765496E546578744E6F646528742C732C732B695B615D2E6C656E677468292C7228742E70726576696F75735369626C696E67';
wwv_flow_api.g_varchar2_table(132) := '292C652E6C617374496E6465783D307D7D292C6928297D297D7D2C7B6B65793A22777261704D6174636865734163726F7373456C656D656E7473222C76616C75653A66756E6374696F6E28652C742C6E2C722C69297B766172206F3D746869732C613D30';
wwv_flow_api.g_varchar2_table(133) := '3D3D3D743F303A742B313B746869732E676574546578744E6F6465732866756E6374696F6E2874297B666F722876617220733D766F696420303B6E756C6C213D3D28733D652E6578656328742E76616C7565292926262222213D3D735B615D3B297B7661';
wwv_flow_api.g_varchar2_table(134) := '7220633D732E696E6465783B69662830213D3D6129666F722876617220753D313B753C613B752B2B29632B3D735B755D2E6C656E6774683B766172206C3D632B735B615D2E6C656E6774683B6F2E7772617052616E6765496E4D6170706564546578744E';
wwv_flow_api.g_varchar2_table(135) := '6F646528742C632C6C2C66756E6374696F6E2865297B72657475726E206E28735B615D2C65297D2C66756E6374696F6E28742C6E297B652E6C617374496E6465783D6E2C722874297D297D6928297D297D7D2C7B6B65793A227772617052616E67654672';
wwv_flow_api.g_varchar2_table(136) := '6F6D496E646578222C76616C75653A66756E6374696F6E28652C742C6E2C72297B76617220693D746869733B746869732E676574546578744E6F6465732866756E6374696F6E286F297B76617220613D6F2E76616C75652E6C656E6774683B652E666F72';
wwv_flow_api.g_varchar2_table(137) := '456163682866756E6374696F6E28652C72297B76617220733D692E636865636B5768697465737061636552616E67657328652C612C6F2E76616C7565292C633D732E73746172742C753D732E656E643B732E76616C69642626692E7772617052616E6765';
wwv_flow_api.g_varchar2_table(138) := '496E4D6170706564546578744E6F6465286F2C632C752C66756E6374696F6E286E297B72657475726E2074286E2C652C6F2E76616C75652E737562737472696E6728632C75292C72297D2C66756E6374696F6E2874297B6E28742C65297D297D292C7228';
wwv_flow_api.g_varchar2_table(139) := '297D297D7D2C7B6B65793A22756E777261704D617463686573222C76616C75653A66756E6374696F6E2865297B666F722876617220743D652E706172656E744E6F64652C6E3D646F63756D656E742E637265617465446F63756D656E74467261676D656E';
wwv_flow_api.g_varchar2_table(140) := '7428293B652E66697273744368696C643B296E2E617070656E644368696C6428652E72656D6F76654368696C6428652E66697273744368696C6429293B742E7265706C6163654368696C64286E2C65292C746869732E69653F746869732E6E6F726D616C';
wwv_flow_api.g_varchar2_table(141) := '697A65546578744E6F64652874293A742E6E6F726D616C697A6528297D7D2C7B6B65793A226E6F726D616C697A65546578744E6F6465222C76616C75653A66756E6374696F6E2865297B69662865297B696628333D3D3D652E6E6F64655479706529666F';
wwv_flow_api.g_varchar2_table(142) := '72283B652E6E6578745369626C696E672626333D3D3D652E6E6578745369626C696E672E6E6F6465547970653B29652E6E6F646556616C75652B3D652E6E6578745369626C696E672E6E6F646556616C75652C652E706172656E744E6F64652E72656D6F';
wwv_flow_api.g_varchar2_table(143) := '76654368696C6428652E6E6578745369626C696E67293B656C736520746869732E6E6F726D616C697A65546578744E6F646528652E66697273744368696C64293B746869732E6E6F726D616C697A65546578744E6F646528652E6E6578745369626C696E';
wwv_flow_api.g_varchar2_table(144) := '67297D7D7D2C7B6B65793A226D61726B526567457870222C76616C75653A66756E6374696F6E28652C74297B766172206E3D746869733B746869732E6F70743D742C746869732E6C6F672827536561726368696E6720776974682065787072657373696F';
wwv_flow_api.g_varchar2_table(145) := '6E2022272B652B272227293B76617220723D302C693D22777261704D617463686573223B746869732E6F70742E6163726F7373456C656D656E7473262628693D22777261704D6174636865734163726F7373456C656D656E747322292C746869735B695D';
wwv_flow_api.g_varchar2_table(146) := '28652C746869732E6F70742E69676E6F726547726F7570732C66756E6374696F6E28652C74297B72657475726E206E2E6F70742E66696C74657228742C652C72297D2C66756E6374696F6E2865297B722B2B2C6E2E6F70742E656163682865297D2C6675';
wwv_flow_api.g_varchar2_table(147) := '6E6374696F6E28297B303D3D3D7226266E2E6F70742E6E6F4D617463682865292C6E2E6F70742E646F6E652872297D297D7D2C7B6B65793A226D61726B222C76616C75653A66756E6374696F6E28652C74297B766172206E3D746869733B746869732E6F';
wwv_flow_api.g_varchar2_table(148) := '70743D743B76617220723D302C693D22777261704D617463686573222C6F3D746869732E6765745365706172617465644B6579776F7264732822737472696E67223D3D747970656F6620653F5B655D3A65292C613D6F2E6B6579776F7264732C733D6F2E';
wwv_flow_api.g_varchar2_table(149) := '6C656E6774682C633D746869732E6F70742E6361736553656E7369746976653F22223A2269223B746869732E6F70742E6163726F7373456C656D656E7473262628693D22777261704D6174636865734163726F7373456C656D656E747322292C303D3D3D';
wwv_flow_api.g_varchar2_table(150) := '733F746869732E6F70742E646F6E652872293A66756E6374696F6E20652874297B766172206F3D6E657720526567457870286E2E6372656174655265674578702874292C22676D222B63292C753D303B6E2E6C6F672827536561726368696E6720776974';
wwv_flow_api.g_varchar2_table(151) := '682065787072657373696F6E2022272B6F2B272227292C6E5B695D286F2C312C66756E6374696F6E28652C69297B72657475726E206E2E6F70742E66696C74657228692C742C722C75297D2C66756E6374696F6E2865297B752B2B2C722B2B2C6E2E6F70';
wwv_flow_api.g_varchar2_table(152) := '742E656163682865297D2C66756E6374696F6E28297B303D3D3D7526266E2E6F70742E6E6F4D617463682874292C615B732D315D3D3D3D743F6E2E6F70742E646F6E652872293A6528615B612E696E6465784F662874292B315D297D297D28615B305D29';
wwv_flow_api.g_varchar2_table(153) := '7D7D2C7B6B65793A226D61726B52616E676573222C76616C75653A66756E6374696F6E28652C74297B766172206E3D746869733B746869732E6F70743D743B76617220723D302C693D746869732E636865636B52616E6765732865293B692626692E6C65';
wwv_flow_api.g_varchar2_table(154) := '6E6774683F28746869732E6C6F6728225374617274696E6720746F206D61726B20776974682074686520666F6C6C6F77696E672072616E6765733A20222B4A534F4E2E737472696E67696679286929292C746869732E7772617052616E676546726F6D49';
wwv_flow_api.g_varchar2_table(155) := '6E64657828692C66756E6374696F6E28652C742C722C69297B72657475726E206E2E6F70742E66696C74657228652C742C722C69297D2C66756E6374696F6E28652C74297B722B2B2C6E2E6F70742E6561636828652C74297D2C66756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(156) := '7B6E2E6F70742E646F6E652872297D29293A746869732E6F70742E646F6E652872297D7D2C7B6B65793A22756E6D61726B222C76616C75653A66756E6374696F6E2865297B76617220743D746869733B746869732E6F70743D653B766172206E3D746869';
wwv_flow_api.g_varchar2_table(157) := '732E6F70742E656C656D656E743F746869732E6F70742E656C656D656E743A222A223B6E2B3D225B646174612D6D61726B6A735D222C746869732E6F70742E636C6173734E616D652626286E2B3D222E222B746869732E6F70742E636C6173734E616D65';
wwv_flow_api.g_varchar2_table(158) := '292C746869732E6C6F67282752656D6F76616C2073656C6563746F722022272B6E2B272227292C746869732E6974657261746F722E666F72456163684E6F6465284E6F646546696C7465722E53484F575F454C454D454E542C66756E6374696F6E286529';
wwv_flow_api.g_varchar2_table(159) := '7B742E756E777261704D6174636865732865297D2C66756E6374696F6E2865297B76617220723D6F2E6D61746368657328652C6E292C693D742E6D6174636865734578636C7564652865293B72657475726E21727C7C693F4E6F646546696C7465722E46';
wwv_flow_api.g_varchar2_table(160) := '494C5445525F52454A4543543A4E6F646546696C7465722E46494C5445525F4143434550547D2C746869732E6F70742E646F6E65297D7D2C7B6B65793A226F7074222C7365743A66756E6374696F6E2865297B746869732E5F6F70743D69287B7D2C7B65';
wwv_flow_api.g_varchar2_table(161) := '6C656D656E743A22222C636C6173734E616D653A22222C6578636C7564653A5B5D2C696672616D65733A21312C696672616D657354696D656F75743A3565332C7365706172617465576F72645365617263683A21302C646961637269746963733A21302C';
wwv_flow_api.g_varchar2_table(162) := '73796E6F6E796D733A7B7D2C61636375726163793A227061727469616C6C79222C6163726F7373456C656D656E74733A21312C6361736553656E7369746976653A21312C69676E6F72654A6F696E6572733A21312C69676E6F726547726F7570733A302C';
wwv_flow_api.g_varchar2_table(163) := '69676E6F726550756E6374756174696F6E3A5B5D2C77696C6463617264733A2264697361626C6564222C656163683A66756E6374696F6E28297B7D2C6E6F4D617463683A66756E6374696F6E28297B7D2C66696C7465723A66756E6374696F6E28297B72';
wwv_flow_api.g_varchar2_table(164) := '657475726E21307D2C646F6E653A66756E6374696F6E28297B7D2C64656275673A21312C6C6F673A77696E646F772E636F6E736F6C657D2C65297D2C6765743A66756E6374696F6E28297B72657475726E20746869732E5F6F70747D7D2C7B6B65793A22';
wwv_flow_api.g_varchar2_table(165) := '6974657261746F72222C6765743A66756E6374696F6E28297B72657475726E206E6577206F28746869732E6374782C746869732E6F70742E696672616D65732C746869732E6F70742E6578636C7564652C746869732E6F70742E696672616D657354696D';
wwv_flow_api.g_varchar2_table(166) := '656F7574297D7D5D292C657D28293B72657475726E20652E666E2E6D61726B3D66756E6374696F6E28652C74297B72657475726E206E6577206128746869732E6765742829292E6D61726B28652C74292C746869737D2C652E666E2E6D61726B52656745';
wwv_flow_api.g_varchar2_table(167) := '78703D66756E6374696F6E28652C74297B72657475726E206E6577206128746869732E6765742829292E6D61726B52656745787028652C74292C746869737D2C652E666E2E6D61726B52616E6765733D66756E6374696F6E28652C74297B72657475726E';
wwv_flow_api.g_varchar2_table(168) := '206E6577206128746869732E6765742829292E6D61726B52616E67657328652C74292C746869737D2C652E666E2E756E6D61726B3D66756E6374696F6E2865297B72657475726E206E6577206128746869732E6765742829292E756E6D61726B2865292C';
wwv_flow_api.g_varchar2_table(169) := '746869737D2C657D293B';
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
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
