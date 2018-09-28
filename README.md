# Oracle Dynamic Action Plugin - APEX Spotlight Search
APEX Spotlight Search is a powerful search feature (like on MacOS) to search. It provides quick navigation and unified search experience across an APEX application.

## Preview
![](https://github.com/Dani3lSun/apex-plugin-spotlight/blob/master/preview.gif)

## Changelog

#### 1.0.0 - Initial Release


## Install
- Import plugin file "dynamic_action_plugin_de_danielh_apexspotlight.sql" from **dist** directory into your application
- *Optional:* Deploy the JS/CSS files from **src/files** directory on your web server and change the "Plugin File Prefix" to web servers folder path.


## Plugin Settings
The plugin settings are highly customizable and you can change:

### Application settings
- **Search Placeholder Text** - Text that is displayed in the spotlight search input field as an placeholder
- **More Characters Text** - Text that is displayed when not enough characters are entered to activate search feature
- **No Match Found Text** - Text that is displayed when no search result was found
- **1 Match Found Text** - Text that is displayed when 1 search result was found
- **Multiple Matches Found Text** - Text that is displayed when multiple search results were found
- **In-Page Search Text** - Text that is displayed in the spotlight search list for in-page search feature

### Component settings
- **Enable Keyboard Shortcuts** - Enables you to add custom keyboard shortcuts to open spotlight search
- **Keyboard Shortcuts** - You can specify multiple keyboard shortcuts, just separate the different shortcuts by a comma
- **Data Source SQL** - SQL Query which returns the data which can be searched through spotlight search
  - **Column 1:** - Name / Title
  - **Column 2:** - Description
  - **Column 3:** - Link / URL
  - **Column 4:** - Icon
- **Page Items to Submit** - Enter page or application items to be set into session state when the SQL query is executed via an AJAX request
- **Enable In-Page Search** - Enable in-page search to highlight found results on the current page depending on the search keyword
- **Max. Search Display Results** - The maximum allowed search results displayed at once
- **Width** - Width of the Spotlight search dialog. Enter either numbers for pixel values or percentage values


## Plugin Events
- **On Open** - DA event that fires when the Spotlight Search dialog opens
- **On Close** - DA event that fires when the Spotlight Search dialog closes
- **Executed In-Page Search** - DA event that fires when an in-page search is executed - *this.data* holds the search keyword
- **Get Server Data Error** - DA event that fires when the AJAX functions which returns the data (based on your SQL Query) has an error - *this.data* holds the error message
- **Get Server Data Success** - DA event that fires when the AJAX functions which returns the data (based on your SQL Query) is successful - *this.data* holds the JSON object returned by the server


## How to use
- New DA on an certain event, e.g *Page Load* or *Click*
- New Action: *APEX Spotlight Search*
- Choose best fitting settings


#### Sample SQL Query for data source

```language-sql
SELECT aap.page_title AS title
      ,'Go to page > ' || aap.page_title AS description
      ,apex_page.get_url(p_page => aap.page_id) AS link
      ,'fa-arrow-right' AS icon
  FROM apex_application_pages aap
 WHERE aap.application_id = :app_id
   AND aap.page_mode = 'Normal'
   AND aap.page_requires_authentication = 'Yes'
 ORDER BY aap.page_id
```


## Demo Application
https://apex.oracle.com/pls/apex/f?p=APEXPLUGIN


## License
MIT
