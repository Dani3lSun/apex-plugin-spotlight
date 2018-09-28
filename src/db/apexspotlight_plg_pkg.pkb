/*-------------------------------------
 * APEX Spotlight Search
 * Version: 1.0.0
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
    l_placeholder_text      p_plugin.attribute_01%TYPE := p_plugin.attribute_01;
    l_more_chars_text       p_plugin.attribute_02%TYPE := p_plugin.attribute_02;
    l_no_match_text         p_plugin.attribute_03%TYPE := p_plugin.attribute_03;
    l_one_match_text        p_plugin.attribute_04%TYPE := p_plugin.attribute_04;
    l_multiple_matches_text p_plugin.attribute_05%TYPE := p_plugin.attribute_05;
    l_inpage_search_text    p_plugin.attribute_06%TYPE := p_plugin.attribute_06;
    --
    l_enable_keyboard_shortcuts VARCHAR2(5) := p_dynamic_action.attribute_01;
    l_keyboard_shortcuts        p_dynamic_action.attribute_02%TYPE := p_dynamic_action.attribute_02;
    l_submit_items              p_dynamic_action.attribute_04%TYPE := p_dynamic_action.attribute_04;
    l_enable_inpage_search      VARCHAR2(5) := p_dynamic_action.attribute_05;
    l_max_display_results       NUMBER := to_number(p_dynamic_action.attribute_06);
    l_width                     p_dynamic_action.attribute_07%TYPE := p_dynamic_action.attribute_07;
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
                                  p_directory             => p_plugin.file_prefix ||
                                                             'js/',
                                  p_version               => NULL,
                                  p_skip_extension        => FALSE,
                                  p_check_to_add_minified => TRUE);
    END IF;
    --
    IF l_enable_inpage_search = 'Y' THEN
      apex_javascript.add_library(p_name                  => 'jquery.mark',
                                  p_directory             => p_plugin.file_prefix ||
                                                             'js/',
                                  p_version               => NULL,
                                  p_skip_extension        => FALSE,
                                  p_check_to_add_minified => TRUE);
    END IF;
    --
    l_result.javascript_function := 'apexSpotlight.pluginHandler';
    l_result.ajax_identifier     := apex_plugin.get_ajax_identifier;
    l_result.attribute_01        := l_placeholder_text;
    l_result.attribute_02        := l_more_chars_text;
    l_result.attribute_03        := l_no_match_text;
    l_result.attribute_04        := l_one_match_text;
    l_result.attribute_05        := l_multiple_matches_text;
    l_result.attribute_06        := l_inpage_search_text;
    --
    l_result.attribute_08 := l_enable_keyboard_shortcuts;
    l_result.attribute_09 := l_keyboard_shortcuts;
    l_result.attribute_10 := l_submit_items;
    l_result.attribute_11 := l_enable_inpage_search;
    l_result.attribute_12 := l_max_display_results;
    l_result.attribute_13 := l_width;
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
                              p_plugin         IN apex_plugin.t_plugin)
    RETURN apex_plugin.t_dynamic_action_ajax_result IS
    --
    l_result apex_plugin.t_dynamic_action_ajax_result;
    --
    l_data_source_sql_query p_dynamic_action.attribute_03%TYPE := p_dynamic_action.attribute_03;
    l_data_type_list        apex_application_global.vc_arr2;
    l_column_value_list     apex_plugin_util.t_column_value_list2;
    l_row_count             NUMBER;
  BEGIN
    -- Data Types of SQL Source Columns
    l_data_type_list(1) := apex_plugin_util.c_data_type_varchar2;
    l_data_type_list(2) := apex_plugin_util.c_data_type_varchar2;
    l_data_type_list(3) := apex_plugin_util.c_data_type_varchar2;
    l_data_type_list(4) := apex_plugin_util.c_data_type_varchar2;
    -- Get Data from SQL Source
    l_column_value_list := apex_plugin_util.get_data2(p_sql_statement  => l_data_source_sql_query,
                                                      p_min_columns    => 4,
                                                      p_max_columns    => 4,
                                                      p_component_name => p_dynamic_action.action);
    -- loop over SQL Source results and write json
    apex_json.open_array();
    -- 
    l_row_count := l_column_value_list(1).value_list.count;
    --
    FOR i IN 1 .. l_row_count LOOP
      apex_json.open_object;
      -- name / title
      apex_json.write('n',
                      l_column_value_list(1).value_list(i).varchar2_value);
      -- description
      apex_json.write('d',
                      l_column_value_list(2).value_list(i).varchar2_value);
      -- link / URL
      apex_json.write('u',
                      l_column_value_list(3).value_list(i).varchar2_value);
      -- icon
      apex_json.write('i',
                      l_column_value_list(4).value_list(i).varchar2_value);
      -- type
      apex_json.write('t',
                      'redirect');
      apex_json.close_object;
    END LOOP;
    --
    apex_json.close_array;
    --
    RETURN l_result;
    --
  END ajax_apexspotlight;
  --
END apexspotlight_plg_pkg;
/
