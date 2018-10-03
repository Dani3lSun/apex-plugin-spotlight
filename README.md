# Oracle APEX Dynamic Action Plugin - APEX Spotlight Search

[![APEX Community](https://cdn.rawgit.com/Dani3lSun/apex-github-badges/78c5adbe/badges/apex-community-badge.svg)](https://github.com/Dani3lSun/apex-github-badges) [![APEX Plugin](https://cdn.rawgit.com/Dani3lSun/apex-github-badges/b7e95341/badges/apex-plugin-badge.svg)](https://github.com/Dani3lSun/apex-github-badges)
[![APEX Built with Love](https://cdn.rawgit.com/Dani3lSun/apex-github-badges/7919f913/badges/apex-love-badge.svg)](https://github.com/Dani3lSun/apex-github-badges)

APEX Spotlight Search is a powerful search feature (like on MacOS) to search. It provides quick navigation and unified search experience across an APEX application.

## Preview
![](https://github.com/Dani3lSun/apex-plugin-spotlight/blob/master/preview.gif)

## Changelog

#### 1.2.3 - Allow up to 9 shortcuts (ctrl + 1, ctrl + 2, ...) for static list entries / prevent default browser shortcuts and always prefer spotlight search / allow shortcuts even if focus is e.g. on an input field

#### 1.2.2 - Fixed IE issue for non working string methods > polyfill for string.startsWith & string.includes

#### 1.2.1 - URLs containing substitution string (\~SEARCH_VALUE\~) are now shown as static list entries which are always present

#### 1.2.0 - Added possibility to include a substitution string (\~SEARCH_VALUE\~) in the target link or URL, which gets replaced with the actual search keyword

#### 1.1.0 - Added possibility to cache server response in browsers session storage (reduce number of AJAX calls)

#### 1.0.0 - Initial Release


## Install
- Import plugin file "dynamic_action_plugin_de_danielh_apexspotlight.sql" from **dist** directory into your application
- *Optional:* Deploy the JS/CSS files from **src/files** directory on your web server and change the "Plugin File Prefix" to web servers folder path.
- *Optional:* Compile the plugin PL/SQL package in your APEX parsing schema and change the plugin render/ajax function to include the package object name. The package files are located in **src/db** directory.

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
- **Enable Local Data Cache** - Enable data cache to save the complete server response (from Data Source AJAX call) in session storage of browser. This helps to reduce calls from browser to server side
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

*Enable Keyboard Shortcuts should be used when the DA executes on page load!*


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
   AND aap.page_id != 0
 ORDER BY aap.page_id
```

**Use the search keyword in your link target or URL using substitution string "\~SEARCH_VALUE\~"**

*Note: If an URL contains the substitution string "\~SEARCH_VALUE\~" the resulting list entry is always shown*

```language-sql
SELECT aap.page_title AS title
      ,'Set item with search keyword' AS description
      ,apex_page.get_url(p_page   => aap.page_id
                        ,p_items  => 'P1_ITEM'
                        ,p_values => '~SEARCH_VALUE~') AS link
      ,'fa-home' AS icon
  FROM apex_application_pages aap
 WHERE aap.application_id = :app_id
   AND aap.page_id = 1
```

```language-sql
SELECT 'Set a item' AS title
      ,'Set item with search keyword on client side' AS description
      ,'javascript:$s(''P1_ITEM'',''~SEARCH_VALUE~'');' AS link
      ,'fa-home' AS icon
  FROM dual
```


## Demo Application
https://apex.oracle.com/pls/apex/f?p=APEXPLUGIN


## License
MIT
