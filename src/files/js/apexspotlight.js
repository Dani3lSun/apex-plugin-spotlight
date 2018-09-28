/**
 * APEX Spotlight Search
 * Author: Daniel Hochleitner
 * Credits: APEX Dev Team: /i/apex_ui/js/spotlight.js
 * Version: 1.0.0
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
  gKeywords: '',
  gAjaxIdentifier: null,
  gPlaceholderText: null,
  gMoreCharsText: null,
  gNoMatchText: null,
  gOneMatchText: null,
  gMultipleMatchesText: null,
  gInPageSearchText: null,
  gEnableKeyboardShortcuts: false,
  gEnableInPageSearch: true,
  gSubmitItemsArray: [],
  gKeyboardShortcutsArray: [],
  /**
   * Get JSON containing data for spotlight search entries from DB
   * @param {function} callback
   */
  getSpotlightData: function(callback) {
    try {
      apex.server.plugin(apexSpotlight.gAjaxIdentifier, {
        pageItems: apexSpotlight.gSubmitItemsArray
      }, {
        dataType: 'json',
        success: function(data) {
          apex.event.trigger('body', 'apexspotlight-ajax-success', data);
          callback(data);
        },
        error: function(xhr, pMessage) {
          apex.event.trigger('body', 'apexspotlight-ajax-error', {
            "message": pMessage
          });
          apex.debug.log("apexSpotlight.getSpotlightData AJAX Error", pMessage);
          callback([]);
        }
      });
    } catch (err) {
      apex.event.trigger('body', 'apexspotlight-ajax-error', {
        "message": err
      });
      callback([]);
    }
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
        apex.navigation.redirect(url);
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

    out = '<li class="apx-Spotlight-result apx-Spotlight-result--page">' +
      '<span class="apx-Spotlight-link" ' + dataAttr + '>' +
      '<span class="apx-Spotlight-icon" aria-hidden="true">' +
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

    if (apexSpotlight.gEnableInPageSearch == 'Y') {
      results.push({
        n: apexSpotlight.gInPageSearchText,
        u: '',
        i: apexSpotlight.ICONS.page,
        t: apexSpotlight.URL_TYPES.searchPage,
        shortcut: 'Ctrl + 1'
      });
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
        desc,
        url,
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
        url = item.u;
        desc = item.d;
        icon = item.i || apexSpotlight.ICONS.search;

        entry = {
          title: item.n,
          desc: desc,
          url: url,
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
            last4Results,
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
            // supports Ctrl + 1, 2, 3, 4 shortcuts
            last4Results = results$.find(apexSpotlight.DOT + apexSpotlight.SP_SHORTCUT).parent().get().reverse();
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
            }

            if (shortcutNumber) {
              apexSpotlight.goTo($(last4Results[shortcutNumber - 1]), e);
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
        apexSpotlight.gSearchIndex = data;
      });
    }
    focusElement = pFocusElement; // could be useful for shortcuts added by apex.action
  },
  /**
   * Open Spotlight Dialog via Moustrap keyboard shortcut
   * @param {object} pFocusElement
   */
  openSpotlightDialogKeyboardShortcut: function(pFocusElement) {
    Mousetrap.bind(apexSpotlight.gKeyboardShortcutsArray, function(e) {
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

    var enableKeyboardShortcuts = apexSpotlight.gEnableKeyboardShortcuts = daThis.action.attribute08;
    var keyboardShortcuts = daThis.action.attribute09;
    var submitItems = daThis.action.attribute10;
    var enableInPageSearch = apexSpotlight.gEnableInPageSearch = daThis.action.attribute11;
    var maxNavResult = apexSpotlight.gMaxNavResult = daThis.action.attribute12;
    var width = apexSpotlight.gWidth = daThis.action.attribute13;

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

    // build page items to submit array
    if (submitItems) {
      submitItemsArray = apexSpotlight.gSubmitItemsArray = submitItems.split(',');
    }

    // build keyboard shortcuts array
    if (enableKeyboardShortcuts == 'Y') {
      keyboardShortcutsArray = apexSpotlight.gKeyboardShortcutsArray = keyboardShortcuts.split(',');
    }

    // open dialog
    if (enableKeyboardShortcuts == 'Y') {
      apexSpotlight.openSpotlightDialogKeyboardShortcut($('body'));
    } else {
      apexSpotlight.openSpotlightDialog($('body'));
    }
  }
};
