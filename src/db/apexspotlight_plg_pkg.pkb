/*-------------------------------------
 * APEX Spotlight Search
 * Version: 1.5.1
 * Author:  Daniel Hochleitner
 *-------------------------------------
*/
CREATE OR REPLACE PACKAGE BODY apexspotlight_plg_pkg IS
  --
  -- Plug-in Render Function
  -- #param p_dynamic_action
  -- #param p_plugin
  -- #return apex_plugin.t_dynamic_action_render_result
  FUNCTION render_apexspotlight(p_dynamic_action IN apex_plugin.t_dynamic_action,
                                p_plugin         IN apex_plugin.t_plugin)
    RETURN apex_plugin.t_dynamic_action_render_result IS
    --
    l_result apex_plugin.t_dynamic_action_render_result;
    --
    -- plugin attributes
    l_placeholder_text      p_plugin.attribute_01%TYPE := nvl(p_dynamic_action.attribute_12,
                                                              p_plugin.attribute_01);
    l_more_chars_text       p_plugin.attribute_02%TYPE := p_plugin.attribute_02;
    l_no_match_text         p_plugin.attribute_03%TYPE := p_plugin.attribute_03;
    l_one_match_text        p_plugin.attribute_04%TYPE := p_plugin.attribute_04;
    l_multiple_matches_text p_plugin.attribute_05%TYPE := p_plugin.attribute_05;
    l_inpage_search_text    p_plugin.attribute_06%TYPE := p_plugin.attribute_06;
    --
    l_enable_keyboard_shortcuts    VARCHAR2(5) := nvl(p_dynamic_action.attribute_01,
                                                      'N');
    l_keyboard_shortcuts           p_dynamic_action.attribute_02%TYPE := p_dynamic_action.attribute_02;
    l_submit_items                 p_dynamic_action.attribute_04%TYPE := p_dynamic_action.attribute_04;
    l_enable_inpage_search         VARCHAR2(5) := nvl(p_dynamic_action.attribute_05,
                                                      'Y');
    l_max_display_results          NUMBER := to_number(p_dynamic_action.attribute_06);
    l_width                        p_dynamic_action.attribute_07%TYPE := p_dynamic_action.attribute_07;
    l_enable_data_cache            VARCHAR2(5) := nvl(p_dynamic_action.attribute_08,
                                                      'N');
    l_theme                        p_dynamic_action.attribute_09%TYPE := nvl(p_dynamic_action.attribute_09,
                                                                             'STANDARD');
    l_enable_prefill_selected_text VARCHAR2(5) := nvl(p_dynamic_action.attribute_10,
                                                      'N');
    l_show_processing              VARCHAR2(5) := nvl(p_dynamic_action.attribute_11,
                                                      'N');
    l_placeholder_icon             p_dynamic_action.attribute_13%TYPE := nvl(p_dynamic_action.attribute_13,
                                                                             'DEFAULT');
    l_escape_special_chars         VARCHAR2(5) := nvl(p_dynamic_action.attribute_14,
                                                      'Y');
    --
    l_component_config_json CLOB := empty_clob();
    --
    -- Get DA internal event name
    FUNCTION get_da_event_name(p_action_id IN NUMBER) RETURN VARCHAR2 IS
      --
      l_da_event_name apex_application_page_da.when_event_internal_name%TYPE;
      --
      CURSOR l_cur_da_event IS
        SELECT aapd.when_event_internal_name
          FROM apex_application_page_da      aapd,
               apex_application_page_da_acts aapda
         WHERE aapd.dynamic_action_id = aapda.dynamic_action_id
           AND aapd.application_id = (SELECT nv('APP_ID')
                                        FROM dual)
           AND aapda.action_id = p_action_id;
      --
    BEGIN
      --
      OPEN l_cur_da_event;
      FETCH l_cur_da_event
        INTO l_da_event_name;
      CLOSE l_cur_da_event;
      --
      RETURN nvl(l_da_event_name,
                 'ready');
      --
    END get_da_event_name;
    --
    -- Get DA Fire on Initialization property
    FUNCTION get_da_fire_on_init(p_action_id IN NUMBER) RETURN VARCHAR2 IS
      --
      l_da_fire_on_init apex_application_page_da_acts.execute_on_page_init%TYPE;
      --
      CURSOR l_cur_da_fire_on_init IS
        SELECT decode(aapda.execute_on_page_init,
                      'Yes',
                      'Y',
                      'No',
                      'N') AS execute_on_page_init
          FROM apex_application_page_da_acts aapda
         WHERE aapda.application_id = (SELECT nv('APP_ID')
                                         FROM dual)
           AND aapda.action_id = p_action_id;
      --
    BEGIN
      --
      OPEN l_cur_da_fire_on_init;
      FETCH l_cur_da_fire_on_init
        INTO l_da_fire_on_init;
      CLOSE l_cur_da_fire_on_init;
      --
      RETURN nvl(l_da_fire_on_init,
                 'N');
      --
    END get_da_fire_on_init;
    --
  BEGIN
    -- Debug
    IF apex_application.g_debug THEN
      apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin,
                                            p_dynamic_action => p_dynamic_action);
    END IF;
    --
    -- add mousetrap.js and mark.js libs
    IF l_enable_keyboard_shortcuts = 'Y' THEN
      apex_javascript.add_library(p_name                  => 'mousetrap',
                                  p_directory             => p_plugin.file_prefix || 'js/',
                                  p_version               => NULL,
                                  p_skip_extension        => FALSE,
                                  p_check_to_add_minified => TRUE);
    END IF;
    --
    IF l_enable_inpage_search = 'Y' THEN
      apex_javascript.add_library(p_name                  => 'jquery.mark',
                                  p_directory             => p_plugin.file_prefix || 'js/',
                                  p_version               => NULL,
                                  p_skip_extension        => FALSE,
                                  p_check_to_add_minified => TRUE);
    END IF;
    -- escape input
    IF l_escape_special_chars = 'Y' THEN
      l_placeholder_text      := apex_escape.html(l_placeholder_text);
      l_more_chars_text       := apex_escape.html(l_more_chars_text);
      l_no_match_text         := apex_escape.html(l_no_match_text);
      l_one_match_text        := apex_escape.html(l_one_match_text);
      l_multiple_matches_text := apex_escape.html(l_multiple_matches_text);
      l_inpage_search_text    := apex_escape.html(l_inpage_search_text);
      l_placeholder_icon      := apex_escape.html(l_placeholder_icon);
    END IF;
    -- build component config json
    apex_json.initialize_clob_output;
    apex_json.open_object();
    -- general
    apex_json.write('dynamicActionId',
                    p_dynamic_action.id);
    apex_json.write('ajaxIdentifier',
                    apex_plugin.get_ajax_identifier);
    apex_json.write('eventName',
                    get_da_event_name(p_action_id => p_dynamic_action.id));
    apex_json.write('fireOnInit',
                    get_da_fire_on_init(p_action_id => p_dynamic_action.id));
    -- app wide attributes
    apex_json.write('placeholderText',
                    l_placeholder_text);
    apex_json.write('moreCharsText',
                    l_more_chars_text);
    apex_json.write('noMatchText',
                    l_no_match_text);
    apex_json.write('oneMatchText',
                    l_one_match_text);
    apex_json.write('multipleMatchesText',
                    l_multiple_matches_text);
    apex_json.write('inPageSearchText',
                    l_inpage_search_text);
    -- component attributes
    apex_json.write('enableKeyboardShortcuts',
                    l_enable_keyboard_shortcuts);
    apex_json.write('keyboardShortcuts',
                    l_keyboard_shortcuts);
    apex_json.write('submitItems',
                    l_submit_items);
    apex_json.write('enableInPageSearch',
                    l_enable_inpage_search);
    apex_json.write('maxNavResult',
                    l_max_display_results);
    apex_json.write('width',
                    l_width);
    apex_json.write('enableDataCache',
                    l_enable_data_cache);
    apex_json.write('spotlightTheme',
                    l_theme);
    apex_json.write('enablePrefillSelectedText',
                    l_enable_prefill_selected_text);
    apex_json.write('showProcessing',
                    l_show_processing);
    apex_json.write('placeHolderIcon',
                    l_placeholder_icon);
    apex_json.close_object();
    --
    l_component_config_json := apex_json.get_clob_output;
    apex_json.free_output;
    -- init keyboard shortcut
    IF l_enable_keyboard_shortcuts = 'Y' THEN
      apex_javascript.add_inline_code(p_code => 'function apexSpotlightInitKeyboardShortcuts' || p_dynamic_action.id ||
                                                '() { apex.da.apexSpotlight.initKeyboardShortcuts(' ||
                                                l_component_config_json || '); }');
      apex_javascript.add_onload_code(p_code => 'apexSpotlightInitKeyboardShortcuts' || p_dynamic_action.id || '();');
    END IF;
    -- DA javascript function
    l_result.javascript_function := 'function() { apex.da.apexSpotlight.pluginHandler(' || l_component_config_json ||
                                    '); }';
    --
    RETURN l_result;
    --
  END render_apexspotlight;
  --
  -- Plug-in AJAX Function
  -- #param p_dynamic_action
  -- #param p_plugin
  -- #return apex_plugin.t_dynamic_action_ajax_result
  FUNCTION ajax_apexspotlight(p_dynamic_action IN apex_plugin.t_dynamic_action,
                              p_plugin         IN apex_plugin.t_plugin) RETURN apex_plugin.t_dynamic_action_ajax_result IS
    --
    l_result apex_plugin.t_dynamic_action_ajax_result;
    --
    l_request_type VARCHAR2(50);
    --
    -- Execute Spotlight GET_DATA Request
    PROCEDURE exec_get_data_request(p_dynamic_action IN apex_plugin.t_dynamic_action,
                                    p_plugin         IN apex_plugin.t_plugin) IS
      l_data_source_sql_query p_dynamic_action.attribute_03%TYPE := p_dynamic_action.attribute_03;
      l_escape_special_chars  VARCHAR2(5) := nvl(p_dynamic_action.attribute_14,
                                                 'Y');
      l_data_type_list        apex_application_global.vc_arr2;
      l_column_value_list     apex_plugin_util.t_column_value_list2;
      l_row_count             NUMBER;
      l_name                  VARCHAR2(4000);
      l_description           VARCHAR2(4000);
      l_link                  VARCHAR2(4000);
      l_icon                  VARCHAR2(4000);
      l_icon_color            VARCHAR2(4000);
    BEGIN
      -- Data Types of SQL Source Columns
      l_data_type_list(1) := apex_plugin_util.c_data_type_varchar2;
      l_data_type_list(2) := apex_plugin_util.c_data_type_varchar2;
      l_data_type_list(3) := apex_plugin_util.c_data_type_varchar2;
      l_data_type_list(4) := apex_plugin_util.c_data_type_varchar2;
      l_data_type_list(5) := apex_plugin_util.c_data_type_varchar2;
      -- Get Data from SQL Source
      l_column_value_list := apex_plugin_util.get_data2(p_sql_statement  => l_data_source_sql_query,
                                                        p_min_columns    => 4,
                                                        p_max_columns    => 5,
                                                        p_data_type_list => l_data_type_list,
                                                        p_component_name => p_dynamic_action.action);
      -- loop over SQL Source results and write json
      apex_json.open_array();
      --
      l_row_count := l_column_value_list(1).value_list.count;
      --
      FOR i IN 1 .. l_row_count LOOP
        -- escape input
        IF l_escape_special_chars = 'Y' THEN
          l_name        := apex_escape.html(l_column_value_list(1).value_list(i).varchar2_value);
          l_description := apex_escape.html(l_column_value_list(2).value_list(i).varchar2_value);
          l_link        := l_column_value_list(3).value_list(i).varchar2_value;
          l_icon        := apex_escape.html(l_column_value_list(4).value_list(i).varchar2_value);
          IF l_column_value_list.last = 5 THEN
            l_icon_color := apex_escape.html(l_column_value_list(5).value_list(i).varchar2_value);
          END IF;
        ELSE
          l_name        := l_column_value_list(1).value_list(i).varchar2_value;
          l_description := l_column_value_list(2).value_list(i).varchar2_value;
          l_link        := l_column_value_list(3).value_list(i).varchar2_value;
          l_icon        := l_column_value_list(4).value_list(i).varchar2_value;
          IF l_column_value_list.last = 5 THEN
            l_icon_color := l_column_value_list(5).value_list(i).varchar2_value;
          END IF;
        END IF;
        -- write json
        apex_json.open_object;
        -- name / title
        apex_json.write('n',
                        l_name);
        -- description
        apex_json.write('d',
                        l_description);
        -- link / URL
        apex_json.write('u',
                        l_link);
        -- icon
        apex_json.write('i',
                        l_icon);
        -- icon color (optional)
        IF l_column_value_list.last = 5 THEN
          apex_json.write('ic',
                          nvl(l_icon_color,
                              'DEFAULT'));
        END IF;
        -- if URL contains ~SEARCH_VALUE~, make list entry static
        IF instr(l_link,
                 '~SEARCH_VALUE~') > 0 THEN
          apex_json.write('s',
                          TRUE);
        ELSE
          apex_json.write('s',
                          FALSE);
        END IF;
        -- type
        apex_json.write('t',
                        'redirect');
        apex_json.close_object;
      END LOOP;
      --
      apex_json.close_array;
    END exec_get_data_request;
    --
    -- Execute Spotlight GET_URL Request
    PROCEDURE exec_get_url_request(p_dynamic_action IN apex_plugin.t_dynamic_action,
                                   p_plugin         IN apex_plugin.t_plugin) IS
      l_search_value VARCHAR2(1000);
      l_url          VARCHAR2(4000);
      l_url_new      VARCHAR2(4000);
    BEGIN
      -- get values from AJAX call X02/X03
      l_search_value := apex_application.g_x02;
      l_url          := apex_application.g_x03;
      -- Check for f?p URL and if URL contains ~SEARCH_VALUE~ substitution string
      IF instr(l_url,
               'f?p=') > 0
         AND instr(l_url,
                   '~SEARCH_VALUE~') > 0 THEN
        -- replace substitution string with real search value
        l_url := REPLACE(l_url,
                         '~SEARCH_VALUE~',
                         l_search_value);
        -- if input URL already contains a checksum > remove checksum
        IF instr(l_url,
                 '&cs=') > 0 THEN
          l_url := substr(l_url,
                          1,
                          instr(l_url,
                                '&cs=') - 1);
        END IF;
        -- get SSP URL
        l_url_new := apex_util.prepare_url(p_url => l_url);
        --
        apex_json.open_object;
        apex_json.write('url',
                        l_url_new);
        apex_json.close_object;
        -- if checks don't succeed return input URL back
      ELSE
        apex_json.open_object;
        apex_json.write('url',
                        l_url);
        apex_json.close_object;
      END IF;
    END exec_get_url_request;
    --
  BEGIN
    -- Check request type in X01
    l_request_type := apex_application.g_x01;
    -- GET_DATA Request
    IF l_request_type = 'GET_DATA' THEN
      exec_get_data_request(p_dynamic_action => p_dynamic_action,
                            p_plugin         => p_plugin);
      -- GET_URL Request
    ELSIF l_request_type = 'GET_URL' THEN
      exec_get_url_request(p_dynamic_action => p_dynamic_action,
                           p_plugin         => p_plugin);
      --
    END IF;
    --
    RETURN l_result;
    --
  END ajax_apexspotlight;
  --
END apexspotlight_plg_pkg;
/
