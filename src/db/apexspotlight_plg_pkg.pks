/*-------------------------------------
 * APEX Spotlight Search
 * Version: 1.6.1
 * Author:  Daniel Hochleitner
 *-------------------------------------
*/
CREATE OR REPLACE PACKAGE apexspotlight_plg_pkg IS
  --
  -- Plug-in Render Function
  -- #param p_dynamic_action
  -- #param p_plugin
  -- #return apex_plugin.t_dynamic_action_render_result
  FUNCTION render_apexspotlight(p_dynamic_action IN apex_plugin.t_dynamic_action,
                                p_plugin         IN apex_plugin.t_plugin)
    RETURN apex_plugin.t_dynamic_action_render_result;
  --
  -- Plug-in AJAX Function
  -- #param p_dynamic_action
  -- #param p_plugin
  -- #return apex_plugin.t_dynamic_action_ajax_result
  FUNCTION ajax_apexspotlight(p_dynamic_action IN apex_plugin.t_dynamic_action,
                              p_plugin         IN apex_plugin.t_plugin) RETURN apex_plugin.t_dynamic_action_ajax_result;
  --
END apexspotlight_plg_pkg;
/
