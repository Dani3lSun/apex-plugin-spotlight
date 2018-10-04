/**
 * APEX Spotlight Search
 * Author: Daniel Hochleitner
 * Credits: APEX Dev Team: /i/apex_ui/js/spotlight.js
 * Version: 1.3.1
 */

/**
 * global namespace
 */
var apexSpotlight = {
  /**
   * Constants
   */
  DOT: '.',
  SP_DIALOG: 'apx-Spotlight',
  SP_INPUT: 'apx-Spotlight-input',
  SP_RESULTS: 'apx-Spotlight-results',
  SP_ACTIVE: 'is-active',
  SP_SHORTCUT: 'apx-Spotlight-shortcut',
  SP_ACTION_SHORTCUT: 'spotlight-search',
  SP_RESULT_LABEL: 'apx-Spotlight-label',
  SP_LIVE_REGION: 'sp-aria-match-found',
  SP_LIST: 'sp-result-list',
  KEYS: $.ui.keyCode,
  URL_TYPES: {
    redirect: 'redirect',
    searchPage: 'search-page'
  },
  ICONS: {
    page: 'fa-window-search',
    search: 'icon-search'
  },
  /**
   * global vars
   */
  gMaxNavResult: 50,
  gWidth: 650,
  gHasDialogCreated: false,
  gSearchIndex: [],
  gStaticIndex: [],
  gKeywords: '',
  gAjaxIdentifier: null,
  gPlaceholderText: null,
  gMoreCharsText: null,
  gNoMatchText: null,
  gOneMatchText: null,
  gMultipleMatchesText: null,
  gInPageSearchText: null,
  gEnableInPageSearch: true,
  gEnableDataCache: false,
  gSubmitItemsArray: [],
  gKeyboardShortcutsArray: [],
  gResultListThemeClass: '',
  gIconThemeClass: '',
  /**
   * Get JSON containing data for spotlight search entries from DB
   * @param {function} callback
   */
  getSpotlightData: function(callback) {
    var cacheData;
    if (apexSpotlight.gEnableDataCache) {
      cacheData = apexSpotlight.getSpotlightDataSessionStorage();
      if (cacheData) {
        callback(JSON.parse(cacheData));
        return;
      }
    }
    try {
      apex.server.plugin(apexSpotlight.gAjaxIdentifier, {
        pageItems: apexSpotlight.gSubmitItemsArray,
        x01: 'GET_DATA'
      }, {
        dataType: 'json',
        success: function(data) {
          apex.event.trigger('body', 'apexspotlight-ajax-success', data);
          apex.debug.log("apexSpotlight.getSpotlightData AJAX Success", data);
          if (apexSpotlight.gEnableDataCache) {
            apexSpotlight.setSpotlightDataSessionStorage(JSON.stringify(data));
          }
          callback(data);
        },
        error: function(jqXHR, textStatus, errorThrown) {
          apex.event.trigger('body', 'apexspotlight-ajax-error', {
            "message": errorThrown
          });
          apex.debug.log("apexSpotlight.getSpotlightData AJAX Error", errorThrown);
          callback([]);
        }
      });
    } catch (err) {
      apex.event.trigger('body', 'apexspotlight-ajax-error', {
        "message": err
      });
      apex.debug.log("apexSpotlight.getSpotlightData AJAX Error", err);
      callback([]);
    }
  },
  /**
   * Get JSON containing SSP URL with replaced search keyword value (~SEARCH_VALUE~ substitution string)
   * @param {string} pUrl
   * @param {function} callback
   */
  getProperApexUrl: function(pUrl, callback) {
    try {
      apex.server.plugin(apexSpotlight.gAjaxIdentifier, {
        x01: 'GET_URL',
        x02: apexSpotlight.gKeywords,
        x03: pUrl
      }, {
        dataType: 'json',
        success: function(data) {
          apex.debug.log("apexSpotlight.getProperApexUrl AJAX Success", data);
          callback(data);
        },
        error: function(jqXHR, textStatus, errorThrown) {
          apex.debug.log("apexSpotlight.getProperApexUrl AJAX Error", errorThrown);
          callback({
            "url": pUrl
          });
        }
      });
    } catch (err) {
      apex.debug.log("apexSpotlight.getProperApexUrl AJAX Error", err);
      callback({
        "url": pUrl
      });
    }
  },
  /**
   * Save JSON Data in local session storage of browser (apexSpotlight.<app_id>.data)
   * @param {object} pData
   */
  setSpotlightDataSessionStorage: function(pData) {
    var hasSessionStorageSupport = apex.storage.hasSessionStorageSupport;

    if (hasSessionStorageSupport) {
      var apexSession = $v('pInstance');
      var sessionStorage = apex.storage.getScopedSessionStorage({
        prefix: 'apexSpotlight',
        useAppId: true
      });

      sessionStorage.setItem(apexSession + '.data', pData);
    }
  },
  /**
   * Get JSON Data from local session storage of browser (apexSpotlight.<app_id>.data)
   */
  getSpotlightDataSessionStorage: function() {
    var hasSessionStorageSupport = apex.storage.hasSessionStorageSupport;

    var storageValue;
    if (hasSessionStorageSupport) {
      var apexSession = $v('pInstance');
      var sessionStorage = apex.storage.getScopedSessionStorage({
        prefix: 'apexSpotlight',
        useAppId: true
      });

      storageValue = sessionStorage.getItem(apexSession + '.data');
    }
    return storageValue;
  },
  /**
   * Handle aria attributes
   */
  handleAriaAttr: function() {
    var results$ = $(apexSpotlight.DOT + apexSpotlight.SP_RESULTS),
      input$ = $(apexSpotlight.DOT + apexSpotlight.SP_INPUT),
      activeId = results$.find(apexSpotlight.DOT + apexSpotlight.SP_ACTIVE).find(apexSpotlight.DOT + apexSpotlight.SP_RESULT_LABEL).attr('id'),
      activeElem$ = $('#' + activeId),
      activeText = activeElem$.text(),
      lis$ = results$.find('li'),
      isExpanded = lis$.length !== 0,
      liveText = '',
      resultsCount = lis$.filter(function() {
        // Exclude the global inserted <li>, which has shortcuts Ctrl + 1, 2, 3
        // such as "Search Workspace for x".
        return $(this).find(apexSpotlight.DOT + apexSpotlight.SP_SHORTCUT).length === 0;
      }).length;

    $(apexSpotlight.DOT + apexSpotlight.SP_RESULT_LABEL)
      .attr('aria-selected', 'false');

    activeElem$
      .attr('aria-selected', 'true');

    if (apexSpotlight.gKeywords === '') {
      liveText = apexSpotlight.gPlaceholderText;
    } else if (resultsCount === 0) {
      liveText = apexSpotlight.gNoMatchText;
    } else if (resultsCount === 1) {
      liveText = apexSpotlight.gOneMatchText;
    } else if (resultsCount > 1) {
      liveText = resultsCount + ' ' + apexSpotlight.gMultipleMatchesText;
    }

    liveText = activeText + ', ' + liveText;

    $('#' + apexSpotlight.SP_LIVE_REGION).text(liveText);

    input$
      // .parent()  // aria 1.1 pattern
      .attr('aria-activedescendant', activeId)
      .attr('aria-expanded', isExpanded);
  },
  /**
   * Close modal spotlight dialog
   */
  closeDialog: function() {
    $(apexSpotlight.DOT + apexSpotlight.SP_DIALOG).dialog('close');
  },
  /**
   * Reset spotlight
   */
  resetSpotlight: function() {
    $('#' + apexSpotlight.SP_LIST).empty();
    $(apexSpotlight.DOT + apexSpotlight.SP_INPUT).val('').focus();
    apexSpotlight.gKeywords = '';
    apexSpotlight.handleAriaAttr();
  },
  /**
   * Navigation to target which is contained in elem$ (<a> link)
   * @param {object} elem$
   * @param {object} event
   */
  goTo: function(elem$, event) {
    var url = elem$.data('url'),
      type = elem$.data('type');

    switch (type) {
      case apexSpotlight.URL_TYPES.searchPage:
        apexSpotlight.inPageSearch();
        break;

      case apexSpotlight.URL_TYPES.redirect:
        // replace ~SEARCH_VALUE~ substitution string
        if (url.includes('~SEARCH_VALUE~')) {
          // server side if APEX URL is detected
          if (url.startsWith('f?p=')) {
            apexSpotlight.getProperApexUrl(url, function(data) {
              apex.navigation.redirect(data.url);
            });
            // client side for all other URLs
          } else {
            url = url.replace('~SEARCH_VALUE~', apexSpotlight.gKeywords);
            apex.navigation.redirect(url);
          }
          // normal URL without substitution string
        } else {
          apex.navigation.redirect(url);
        }
        break;
    }

    apexSpotlight.closeDialog();
  },
  /**
   * Get HTML markup
   * @param {object} data
   */
  getMarkup: function(data) {
    var title = data.title,
      desc = data.desc || '',
      url = data.url,
      type = data.type,
      icon = data.icon,
      shortcut = data.shortcut,
      shortcutMarkup = shortcut ? '<span class="' + apexSpotlight.SP_SHORTCUT + '" >' + shortcut + '</span>' : '',
      dataAttr = '',
      iconString = '',
      out;

    if (url === 0 || url) {
      dataAttr = 'data-url="' + url + '" ';
    }

    if (type) {
      dataAttr = dataAttr + ' data-type="' + type + '" ';
    }

    if (icon.startsWith('fa-')) {
      iconString = 'fa ' + icon;
    } else if (icon.startsWith('icon-')) {
      iconString = 'a-Icon ' + icon;
    } else {
      iconString = 'a-Icon icon-search';
    }

    out = '<li class="apx-Spotlight-result ' + apexSpotlight.gResultListThemeClass + ' apx-Spotlight-result--page">' +
      '<span class="apx-Spotlight-link" ' + dataAttr + '>' +
      '<span class="apx-Spotlight-icon ' + apexSpotlight.gIconThemeClass + '" aria-hidden="true">' +
      '<span class="' + iconString + '"></span>' +
      '</span>' +
      '<span class="apx-Spotlight-info">' +
      '<span class="' + apexSpotlight.SP_RESULT_LABEL + '" role="option">' + title + '</span>' +
      '<span class="apx-Spotlight-desc">' + desc + '</span>' +
      '</span>' +
      shortcutMarkup +
      '</span>' +
      '</li>';

    return out;
  },
  /**
   * Push static list entries to resultset
   * @param {array} results
   */
  resultsAddOns: function(results) {

    var shortcutCounter = 0;

    if (apexSpotlight.gEnableInPageSearch == 'Y') {
      results.push({
        n: apexSpotlight.gInPageSearchText,
        u: '',
        i: apexSpotlight.ICONS.page,
        t: apexSpotlight.URL_TYPES.searchPage,
        shortcut: 'Ctrl + 1'
      });
      shortcutCounter = shortcutCounter + 1;
    }

    for (var i = 0; i < apexSpotlight.gStaticIndex.length; i++) {
      shortcutCounter = shortcutCounter + 1;
      if (shortcutCounter > 9) {
        results.push({
          n: apexSpotlight.gStaticIndex[i].n,
          d: apexSpotlight.gStaticIndex[i].d,
          u: apexSpotlight.gStaticIndex[i].u,
          i: apexSpotlight.gStaticIndex[i].i,
          t: apexSpotlight.gStaticIndex[i].t
        });
      } else {
        results.push({
          n: apexSpotlight.gStaticIndex[i].n,
          d: apexSpotlight.gStaticIndex[i].d,
          u: apexSpotlight.gStaticIndex[i].u,
          i: apexSpotlight.gStaticIndex[i].i,
          t: apexSpotlight.gStaticIndex[i].t,
          shortcut: 'Ctrl + ' + shortcutCounter
        });
      }
    }

    return results;
  },
  /**
   * Search Navigation
   * @param {array} patterns
   */
  searchNav: function(patterns) {
    var navResults = [],
      hasResults = false,
      pattern,
      patternLength = patterns.length,
      i;

    var narrowedSet = function() {
      return hasResults ? navResults : apexSpotlight.gSearchIndex;
    };

    var getScore = function(pos, wordsCount, fullTxt) {
      var score = 100,
        spaces = wordsCount - 1,
        positionOfWholeKeywords;

      if (pos === 0 && spaces === 0) {
        // perfect match ( matched from the first letter with no space )
        return score;
      } else {
        // when search 'sql c', 'SQL Commands' should score higher than 'SQL Scripts'
        // when search 'script', 'Script Planner' should score higher than 'SQL Scripts'
        positionOfWholeKeywords = fullTxt.indexOf(apexSpotlight.gKeywords);
        if (positionOfWholeKeywords === -1) {
          score = score - pos - spaces - wordsCount;
        } else {
          score = score - positionOfWholeKeywords;
        }
      }

      return score;
    };

    for (i = 0; i < patterns.length; i++) {
      pattern = patterns[i];

      navResults = narrowedSet()
        .filter(function(elem, index) {
          var name = elem.n.toLowerCase(),
            wordsCount = name.split(' ').length,
            position = name.search(pattern);

          if (patternLength > wordsCount) {
            // keywords contains more words than string to be searched
            return false;
          }

          if (position > -1) {
            elem.score = getScore(position, wordsCount, name);
            return true;
          } else if (elem.t) { // tokens (short description for nav entries.)
            if (elem.t.search(pattern) > -1) {
              elem.score = 1;
              return true;
            }
          }

        })
        .sort(function(a, b) {
          return b.score - a.score;
        });

      hasResults = true;
    }

    var formatNavResults = function(res) {
      var out = '',
        i,
        item,
        type,
        shortcut,
        icon,
        entry = {};

      if (res.length > apexSpotlight.gMaxNavResult) {
        res.length = apexSpotlight.gMaxNavResult;
      }

      for (i = 0; i < res.length; i++) {
        item = res[i];

        shortcut = item.shortcut;
        type = item.t || apexSpotlight.URL_TYPES.redirect;
        icon = item.i || apexSpotlight.ICONS.search;

        entry = {
          title: item.n,
          desc: item.d,
          url: item.u,
          icon: icon,
          type: type
        };

        if (shortcut) {
          entry.shortcut = shortcut;
        }

        out = out + apexSpotlight.getMarkup(entry);
      }
      return out;
    };
    return formatNavResults(apexSpotlight.resultsAddOns(navResults));
  },
  /**
   * Search
   * @param {string} k
   */
  search: function(k) {
    var PREFIX_ENTRY = 'sp-result-';
    // store keywords
    apexSpotlight.gKeywords = k.trim();

    var words = apexSpotlight.gKeywords.split(' '),
      res$ = $(apexSpotlight.DOT + apexSpotlight.SP_RESULTS),
      patterns = [],
      navOuput,
      i;
    for (i = 0; i < words.length; i++) {
      // store keys in array to support space in keywords for navigation entries,
      // e.g. 'sta f' finds 'Static Application Files'
      patterns.push(new RegExp(apex.util.escapeRegExp(words[i]), 'gi'));
    }

    navOuput = apexSpotlight.searchNav(patterns);

    $('#' + apexSpotlight.SP_LIST)
      .html(navOuput)
      .find('li')
      .each(function(i) {
        var that$ = $(this);
        that$
          .find(apexSpotlight.DOT + apexSpotlight.SP_RESULT_LABEL)
          .attr('id', PREFIX_ENTRY + i); // for accessibility
      })
      .first()
      .addClass(apexSpotlight.SP_ACTIVE);
  },
  /**
   * Creates the spotlight dialog markup
   * @param {string} pPlaceHolder
   */
  createSpotlightDialog: function(pPlaceHolder) {
    var createDialog = function() {
      var viewHeight,
        lineHeight,
        viewTop,
        rowsPerView;

      var initHeights = function() {
        var viewTop$ = $('div.apx-Spotlight-results');

        viewHeight = viewTop$.outerHeight();
        lineHeight = $('li.apx-Spotlight-result').outerHeight();
        viewTop = viewTop$.offset().top;
        rowsPerView = (viewHeight / lineHeight);
      };

      var scrolledDownOutOfView = function(elem$) {
        if (elem$[0]) {
          var top = elem$.offset().top;
          if (top < 0) {
            return true; // scroll bar was used to get active item out of view
          } else {
            return top > viewHeight;
          }
        }
      };

      var scrolledUpOutOfView = function(elem$) {
        if (elem$[0]) {
          var top = elem$.offset().top;
          if (top > viewHeight) {
            return true; // scroll bar was used to get active item out of view
          } else {
            return top <= viewTop;
          }
        }
      };

      // keyboard UP and DOWN support to go through results
      var getNext = function(res$) {
        var current$ = res$.find(apexSpotlight.DOT + apexSpotlight.SP_ACTIVE),
          sequence = current$.index(),
          next$;
        if (!rowsPerView) {
          initHeights();
        }

        if (!current$.length || current$.is(':last-child')) {
          // Hit bottom, scroll to top
          current$.removeClass(apexSpotlight.SP_ACTIVE);
          res$.find('li').first().addClass(apexSpotlight.SP_ACTIVE);
          res$.animate({
            scrollTop: 0
          });
        } else {
          next$ = current$.removeClass(apexSpotlight.SP_ACTIVE).next().addClass(apexSpotlight.SP_ACTIVE);
          if (scrolledDownOutOfView(next$)) {
            res$.animate({
              scrollTop: (sequence - rowsPerView + 2) * lineHeight
            }, 0);
          }
        }
      };

      var getPrev = function(res$) {
        var current$ = res$.find(apexSpotlight.DOT + apexSpotlight.SP_ACTIVE),
          sequence = current$.index(),
          prev$;

        if (!rowsPerView) {
          initHeights();
        }

        if (!res$.length || current$.is(':first-child')) {
          // Hit top, scroll to bottom
          current$.removeClass(apexSpotlight.SP_ACTIVE);
          res$.find('li').last().addClass(apexSpotlight.SP_ACTIVE);
          res$.animate({
            scrollTop: res$.find('li').length * lineHeight
          });
        } else {
          prev$ = current$.removeClass(apexSpotlight.SP_ACTIVE).prev().addClass(apexSpotlight.SP_ACTIVE);
          if (scrolledUpOutOfView(prev$)) {
            res$.animate({
              scrollTop: (sequence - 1) * lineHeight
            }, 0);
          }
        }
      };

      $(window).on('apexwindowresized', function() {
        initHeights();
      });

      $('body')
        .append(
          '<div class="' + apexSpotlight.SP_DIALOG + '">' +
          '<div class="apx-Spotlight-body">' +
          '<div class="apx-Spotlight-search">' +
          '<div class="apx-Spotlight-icon">' +
          '<span class="a-Icon icon-search" aria-hidden="true"></span>' +
          '</div>' +
          '<div class="apx-Spotlight-field">' +
          '<input type="text" role="combobox" aria-expanded="false" aria-autocomplete="none" aria-haspopup="true" aria-label="Spotlight Search" aria-owns="' + apexSpotlight.SP_LIST + '" autocomplete="off" autocorrect="off" spellcheck="false" class="' + apexSpotlight.SP_INPUT + '" placeholder="' + pPlaceHolder + '">' +
          '</div>' +
          '<div role="region" class="u-VisuallyHidden" aria-live="polite" id="' + apexSpotlight.SP_LIVE_REGION + '"></div>' +
          '</div>' +
          '<div class="' + apexSpotlight.SP_RESULTS + '">' +
          '<ul class="apx-Spotlight-resultsList" id="' + apexSpotlight.SP_LIST + '" tabindex="-1" role="listbox"></ul>' +
          '</div>' +
          '</div>' +
          '</div>'
        )
        .on('input', apexSpotlight.DOT + apexSpotlight.SP_INPUT, function() {
          var v = $(this).val().trim(),
            len = v.length;

          if (len === 0) {
            apexSpotlight.resetSpotlight(); // clears everything when keyword is removed.
          } else if (len > 1 || !isNaN(v)) {
            // search requires more than one character, or it is a number.
            if (v !== apexSpotlight.gKeywords) {
              apexSpotlight.search(v);
            }
          }
        })
        .on('keydown', apexSpotlight.DOT + apexSpotlight.SP_DIALOG, function(e) {
          var results$ = $(apexSpotlight.DOT + apexSpotlight.SP_RESULTS),
            last9Results,
            shortcutNumber;

          // up/down arrows
          switch (e.which) {
            case apexSpotlight.KEYS.DOWN:
              e.preventDefault();
              getNext(results$);
              break;

            case apexSpotlight.KEYS.UP:
              e.preventDefault();
              getPrev(results$);
              break;

            case apexSpotlight.KEYS.ENTER:
              e.preventDefault(); // don't submit on enter
              apexSpotlight.goTo(results$.find('li.is-active span'), e);
              break;
            case apexSpotlight.KEYS.TAB:
              apexSpotlight.closeDialog();
              break;
          }

          if (e.ctrlKey) {
            // supports Ctrl + 1, 2, 3, 4, 5, 6, 7, 8, 9 shortcuts
            last9Results = results$.find(apexSpotlight.DOT + apexSpotlight.SP_SHORTCUT).parent().get();
            switch (e.which) {
              case 49: // Ctrl + 1
                shortcutNumber = 1;
                break;
              case 50: // Ctrl + 2
                shortcutNumber = 2;
                break;

              case 51: // Ctrl + 3
                shortcutNumber = 3;
                break;

              case 52: // Ctrl + 4
                shortcutNumber = 4;
                break;

              case 53: // Ctrl + 5
                shortcutNumber = 5;
                break;

              case 54: // Ctrl + 6
                shortcutNumber = 6;
                break;

              case 55: // Ctrl + 7
                shortcutNumber = 7;
                break;

              case 56: // Ctrl + 8
                shortcutNumber = 8;
                break;

              case 57: // Ctrl + 9
                shortcutNumber = 9;
                break;
            }

            if (shortcutNumber) {
              apexSpotlight.goTo($(last9Results[shortcutNumber - 1]), e);
            }
          }

          // Shift + Tab to close and focus goes back to where it was.
          if (e.shiftKey) {
            if (e.which === apexSpotlight.KEYS.TAB) {
              apexSpotlight.closeDialog();
            }
          }

          apexSpotlight.handleAriaAttr();

        })
        .on('click', 'span.apx-Spotlight-link', function(e) {
          apexSpotlight.goTo($(this), e);
        })
        .on('mousemove', 'li.apx-Spotlight-result', function() {
          var highlight$ = $(this);
          highlight$
            .parent()
            .find(apexSpotlight.DOT + apexSpotlight.SP_ACTIVE)
            .removeClass(apexSpotlight.SP_ACTIVE);

          highlight$.addClass(apexSpotlight.SP_ACTIVE);
          // handleAriaAttr();
        })
        .on('blur', apexSpotlight.DOT + apexSpotlight.SP_DIALOG, function(e) {
          // don't do this if dialog is closed/closing
          if ($(apexSpotlight.DOT + apexSpotlight.SP_DIALOG).dialog("isOpen")) {
            // input takes focus dialog loses focus to scroll bar
            $(apexSpotlight.DOT + apexSpotlight.SP_INPUT).focus();
          }
        });

      // Escape key pressed once, clear field, twice, close dialog.
      $(apexSpotlight.DOT + apexSpotlight.SP_DIALOG).on('keydown', function(e) {
        var input$ = $(apexSpotlight.DOT + apexSpotlight.SP_INPUT);
        if (e.which === apexSpotlight.KEYS.ESCAPE) {
          if (input$.val()) {
            apexSpotlight.resetSpotlight();
            e.stopPropagation();
          } else {
            apexSpotlight.closeDialog();
          }
        }
      });

      apexSpotlight.gHasDialogCreated = true;
    };
    createDialog();
  },
  /**
   * Open Spotlight Dialog
   * @param {object} pFocusElement
   */
  openSpotlightDialog: function(pFocusElement) {
    // Disable Spotlight for Modal Dialog
    if ((window.self !== window.top)) {
      return false;
    }

    apexSpotlight.gHasDialogCreated = $(apexSpotlight.DOT + apexSpotlight.SP_DIALOG).length > 0;

    var openDialog = function() {
      var dlg$ = $(apexSpotlight.DOT + apexSpotlight.SP_DIALOG),
        scrollY = window.scrollY || window.pageYOffset;
      if (!dlg$.hasClass('ui-dialog-content') || !dlg$.dialog("isOpen")) {
        dlg$.dialog({
          width: apexSpotlight.gWidth,
          height: 'auto',
          modal: true,
          position: {
            my: "center top",
            at: "center top+" + (scrollY + 64),
            of: $('body')
          },
          dialogClass: 'ui-dialog--apexspotlight',
          open: function() {
            apex.event.trigger('body', 'apexspotlight-open-dialog');

            var dlg$ = $(this);

            dlg$
              .css('min-height', 'auto')
              .prev('.ui-dialog-titlebar')
              .remove();

            apex.navigation.beginFreezeScroll();

            $('.ui-widget-overlay').on('click', function() {
              apexSpotlight.closeDialog();
            });
          },
          close: function() {
            apex.event.trigger('body', 'apexspotlight-close-dialog');
            apexSpotlight.resetSpotlight();
            apex.navigation.endFreezeScroll();
          }
        });
      }
    };

    if (apexSpotlight.gHasDialogCreated) {
      openDialog();
    } else {
      apexSpotlight.createSpotlightDialog(apexSpotlight.gPlaceholderText);
      openDialog();
      apexSpotlight.getSpotlightData(function(data) {
        apexSpotlight.gSearchIndex = $.grep(data, function(e) {
          return e.s == false;
        });
        apexSpotlight.gStaticIndex = $.grep(data, function(e) {
          return e.s == true;
        });
      });
    }
    focusElement = pFocusElement; // could be useful for shortcuts added by apex.action
  },
  /**
   * Open Spotlight Dialog via Moustrap keyboard shortcut
   * @param {object} pFocusElement
   */
  openSpotlightDialogKeyboardShortcut: function(pFocusElement) {
    // disable default behavior to not bind in input fields
    Mousetrap.stopCallback = function(e, element, combo) {
      return true;
    };
    Mousetrap.prototype.stopCallback = function(e, element, combo) {
      return false;
    };

    // bind moustrap to keyboard shortcut
    Mousetrap.bind(apexSpotlight.gKeyboardShortcutsArray, function(e) {
      // prevent default behavior
      if (e.preventDefault) {
        e.preventDefault();
      } else {
        // internet explorer
        e.returnValue = false;
      }
      // open spotlight dialog
      apexSpotlight.openSpotlightDialog(pFocusElement);
    });
  },
  /**
   * In-Page search using mark.js
   * @param {string} pKeyword
   */
  inPageSearch: function(pKeyword) {
    var keyword = pKeyword || apexSpotlight.gKeywords;
    $('body').unmark({
      done: function() {
        apexSpotlight.closeDialog();
        apexSpotlight.resetSpotlight();
        $('body').mark(keyword, {});
        apex.event.trigger('body', 'apexspotlight-inpage-search', {
          "keyword": keyword
        });
      }
    });
  },
  /**
   * Plugin handler - called from plugin render function
   */
  pluginHandler: function() {
    // plugin attributes
    var daThis = this;
    var ajaxIdentifier = apexSpotlight.gAjaxIdentifier = daThis.action.ajaxIdentifier;
    var placeholderText = apexSpotlight.gPlaceholderText = daThis.action.attribute01;
    var moreCharsText = apexSpotlight.gMoreCharsText = daThis.action.attribute02;
    var noMatchText = apexSpotlight.gNoMatchText = daThis.action.attribute03;
    var oneMatchText = apexSpotlight.gOneMatchText = daThis.action.attribute04;
    var multipleMatchesText = apexSpotlight.gMultipleMatchesText = daThis.action.attribute05;
    var inPageSearchText = apexSpotlight.gInPageSearchText = daThis.action.attribute06;

    var enableKeyboardShortcuts = daThis.action.attribute08;
    var keyboardShortcuts = daThis.action.attribute09;
    var submitItems = daThis.action.attribute10;
    var enableInPageSearch = apexSpotlight.gEnableInPageSearch = daThis.action.attribute11;
    var maxNavResult = apexSpotlight.gMaxNavResult = daThis.action.attribute12;
    var width = apexSpotlight.gWidth = daThis.action.attribute13;
    var enableDataCache = daThis.action.attribute14;
    var spotlightTheme = daThis.action.attribute15;

    var keyboardShortcutsArray = [];
    var submitItemsArray = [];

    // debug
    apex.debug.log('apexSpotlight.pluginHandler - ajaxIdentifier', ajaxIdentifier);
    apex.debug.log('apexSpotlight.pluginHandler - placeholderText', placeholderText);
    apex.debug.log('apexSpotlight.pluginHandler - moreCharsText', moreCharsText);
    apex.debug.log('apexSpotlight.pluginHandler - noMatchText', noMatchText);
    apex.debug.log('apexSpotlight.pluginHandler - oneMatchText', oneMatchText);
    apex.debug.log('apexSpotlight.pluginHandler - multipleMatchesText', multipleMatchesText);
    apex.debug.log('apexSpotlight.pluginHandler - inPageSearchText', inPageSearchText);
    apex.debug.log('apexSpotlight.pluginHandler - enableKeyboardShortcuts', enableKeyboardShortcuts);
    apex.debug.log('apexSpotlight.pluginHandler - keyboardShortcuts', keyboardShortcuts);
    apex.debug.log('apexSpotlight.pluginHandler - submitItems', submitItems);
    apex.debug.log('apexSpotlight.pluginHandler - enableInPageSearch', enableInPageSearch);
    apex.debug.log('apexSpotlight.pluginHandler - maxNavResult', maxNavResult);
    apex.debug.log('apexSpotlight.pluginHandler - width', width);
    apex.debug.log('apexSpotlight.pluginHandler - enableDataCache', enableDataCache);
    apex.debug.log('apexSpotlight.pluginHandler - spotlightTheme', spotlightTheme);

    // polyfill for older browsers like IE (startsWith & includes functions)
    if (!String.prototype.startsWith) {
      String.prototype.startsWith = function(search, pos) {
        return this.substr(!pos || pos < 0 ? 0 : +pos, search.length) === search;
      };
    }
    if (!String.prototype.includes) {
      String.prototype.includes = function(search, start) {
        'use strict';
        if (typeof start !== 'number') {
          start = 0;
        }

        if (start + search.length > this.length) {
          return false;
        } else {
          return this.indexOf(search, start) !== -1;
        }
      };
    }

    // Enable local data cache
    if (enableDataCache == 'Y') {
      apexSpotlight.gEnableDataCache = true;
    } else {
      apexSpotlight.gEnableDataCache = false;
    }

    // build page items to submit array
    if (submitItems) {
      submitItemsArray = apexSpotlight.gSubmitItemsArray = submitItems.split(',');
    }

    // build keyboard shortcuts array
    if (enableKeyboardShortcuts == 'Y') {
      keyboardShortcutsArray = apexSpotlight.gKeyboardShortcutsArray = keyboardShortcuts.split(',');
    }

    // set spotlight theme
    if (spotlightTheme == 'ORANGE') {
      apexSpotlight.gResultListThemeClass = 'apx-Spotlight-result-orange';
      apexSpotlight.gIconThemeClass = 'apx-Spotlight-icon-orange';
    } else if (spotlightTheme == 'RED') {
      apexSpotlight.gResultListThemeClass = 'apx-Spotlight-result-red';
      apexSpotlight.gIconThemeClass = 'apx-Spotlight-icon-red';
    } else if (spotlightTheme == 'DARK') {
      apexSpotlight.gResultListThemeClass = 'apx-Spotlight-result-dark';
      apexSpotlight.gIconThemeClass = 'apx-Spotlight-icon-dark';
    }

    // open dialog
    if (enableKeyboardShortcuts == 'Y') {
      apexSpotlight.openSpotlightDialogKeyboardShortcut($('body'));
    } else {
      apexSpotlight.openSpotlightDialog($('body'));
    }
  }
};
