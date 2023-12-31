/*
* Plugin:  Codemirror Plugin
* Version: 1.0.0 (20.08.2018.)
*
* Author:  Marko Goricki, BiLog
* Mail:    mgoricki@gmail.com
* Twitter: @mgoricki
* Blog:    apexbyg.blogspot.com 
*
* Depends:
*    apex/debug.js 
*
* Changes:
* 
* v.1.0.5 - 20211202 - Validate Code option
* v.1.0.4 - 20211123 - upgraded to CodeMirror 5.64.0, APEX version 21.2
* v.1.0.3 - 20191009 - setHeight and setWidth
* v.1.0.0 - 20180820 - Initial version
*
* Public Methods:
*
*   Get Options
*   $('#P2_EDITOR').codemirror_plugin('option');
*
*   Set Height
*   apex.item('P2_EDITOR').callbacks.setHeight('auto');
*   apex.item('P2_EDITOR').callbacks.setHeight('600'); -- in px
*   apex.item('P2_EDITOR').callbacks.setHeight('100%'); -- in %
*
* Notes:
*   - 
*
*/



(function ($, util, debug) {
  "use strict";

  var C_PLUGIN_NAME = "Code Mirror Editor";
  var C_TOOLBAR_CLASS = "codemirror-toolbar";
  var C_TOOLBAR_CLASS_READONLY = "codemirror-readonly";

  $.widget("apex.codemirror_plugin", {
    options : {
      itemName : null,
      readonly: false,
      ignoreChanged: false, // Warn On Unsaved Changes
      ajaxId: null,
      autocomplete: false,
      runInFullscreen: false,
      autocompleteHints: [],  
      validateCode: false,
      config: {} // override with JS initalization codes            
    },
    _privateStorage : function () {
      var uiw = this;
      uiw._obj = {
        wrapper$ : null
      }        
    },      
    changed: false,
    baseId:  "aCodeMirrorPlugin",

    // Log/Debug Function
    _log: function (pFunctionName, pLogMessage){
      Array.prototype.unshift.call(arguments, 'codemirror_custom.js');
      debug.apply(debug.log,arguments);
    },

    /**
     * Return Autocomplete Options
     * @param {} cm 
     * @param {*} option 
     */  
    _returnAutocompleteOptions: function(cm, options){      
      var comp = options.autocompleteHints;
      return new Promise(function(accept) {
        setTimeout(function() {          
          var cursor = cm.getCursor(), line = cm.getLine(cursor.line)
          var start = cursor.ch, end = cursor.ch
          while (start && /\w/.test(line.charAt(start - 1))) --start
          while (end < line.length && /\w/.test(line.charAt(end))) ++end
          var word = line.slice(start, end).toLowerCase()
          
          // filter array
          var vOutput = comp.filter(function(value, index, arr){    
            var vParam = value.text.toLowerCase();
            var vParamOnly = vParam.substr(vParam.indexOf('$')+1);
            if (vParam.indexOf(':')==0){
              vParam = vParam.substr(vParam.indexOf(':')+1);
            }
            
            return vParam.startsWith(word) || vParamOnly.startsWith(word);
          });

         if (vOutput.length>0){
           return accept({
                list: vOutput
              , from: CodeMirror.Pos(cursor.line, start)
              , to: CodeMirror.Pos(cursor.line, end)
            });
         }else{
           return accept(null);
         }

         
        }, 100)
      })      
    } ,   

    // init function
    _init : function () {
      var uiw = this;
      var vMasterOk = false;
      uiw._privateStorage();

      uiw.baseId = uiw.options.itemName;      

      $.extend(uiw.options,uiw.options.config);      

      uiw._editor = 
        CodeMirror.fromTextArea(document.getElementById(uiw.options.itemName),
          {
            mode:"text/x-plsql",
            indentWithTabs: true,
            martIndent: true,
            lineNumbers: true,
            matchBrackets : true,
            textWrapping : false,
            autofocus: false,
            indentUnit: 2,
            smartIndent: true,
            tabSize: 2,
            viewportMargin: 5,
            readOnly: uiw.options.readonly,//"nocursor"
            extraKeys: {              
              "Ctrl-Space": "autocomplete",
              "F11": function(cm) {
                cm.setOption("fullScreen", !cm.getOption("fullScreen"));
              },            
              "Esc": function(cm) {
                if (cm.getOption("fullScreen")) cm.setOption("fullScreen", false);
              },
              "Ctrl-Alt-V": function(){
                uiw._validateCode();
              }
              
            },
            autoCloseBrackets: true
          });      

      // event handlers
      // if Warn on unsaved changes is set to Yes
      if (!uiw.options.ignoreChanged){
        uiw._editor.on('change', function(){
          uiw.changed = true;
          
          var vHistory$ = uiw._editor.historySize();
          $("#" + uiw.baseId + "_undo")[0].disabled = vHistory$.undo === 0;
          $("#" + uiw.baseId + "_redo")[0].disabled = vHistory$.redo === 0;
        });  
      }

      // code complete
      uiw._initToolbar();

      // close validation message
      if (uiw.options.validateCode){
        uiw._obj.wrapper$.on('click', '.codemirror-msg-close', function(){
          var vThis$ = $(this);
          var vWrapper$ = vThis$.closest('.codemirror-msg-box');          
          if(vWrapper$.children().length==1){
            vWrapper$.remove();
          }else{
            vThis$.closest('.codemirror-msg').remove();          
          }                   
        });
      };

      if (uiw.options.runInFullscreen){
        uiw._editor.setOption('fullScreen', true);
      }    

      // if Editor is readonly add class to the wrapper 
      if (uiw._editor.isReadOnly()){
        uiw.element.closest('.codemirror-wrapper').addClass(C_TOOLBAR_CLASS_READONLY);
      }    

      // autocomplete
      if (uiw.options.autocomplete){
        CodeMirror.commands.autocomplete = function(pEditor) {
          var modeOption = pEditor.doc.modeOption,
              hint,
              options = {};
                        
          switch (modeOption) {
              case "text/javascript": 
                hint = CodeMirror.hint.javascript; 
                break;
              case "text/css":        
                hint = CodeMirror.hint.css; 
                break;
              case "text/html":       
                hint = CodeMirror.hint.html; 
                break;
              case "text/x-plsql":
                hint = uiw._returnAutocompleteOptions;
                options.autocompleteHints = uiw.options.autocompleteHints;
                /*
                options = {
                    async:        false,
                    dataCallback: function( pSearchOptions, pCallback ) {
                                    apex.server.plugin (uiw.options.ajaxId, {
                                      x01: "hint",
                                      x02: pSearchOptions.search,
                                      x03: pSearchOptions.parent,
                                      x04: pSearchOptions.grantParent
                                    }, {
                                      success: pCallback
                                    });  
                                  }                 
                };
                */
                break;
          }

          if (hint)  {                
            CodeMirror.showHint(pEditor, hint, options );
          }
        };
        
      }   
      
    
      // Init APEX item
      apex.item.create(uiw.options.itemName, {
        // get validity
        getValidity: function() {
          var lValidity = { valid: true };
          /*
          if (  item is not valid  ) {
              lValidity.valid = false;
          }
          */
          return lValidity;
        },

        // get value
        getValue: function(){
          uiw._log('CodeMirror Plugin', 'getValue');
          return uiw._editor.doc.getValue();
        },

        // set value
        setValue: function(pValue){
          uiw._log('CodeMirror Plugin', 'setValue');
          uiw._editor.doc.setValue(pValue);
        },
        
        // disable
        disable: function(){
          uiw._disable();
        },
        
        // enable
        enable: function(){
          uiw._enable();
        },    
        
        // show
        show: function(){
          uiw._log('CodeMirror Plugin', 'Not implemented');
        },  
        
        // hide
        hide: function(){
          uiw._log('CodeMirror Plugin', 'Not implemented');
        },  
        
        // is changed        
        isChanged: function() {
          return uiw.changed;
        },

        // setHeight - can be 'auto', or number in px or number in %
        setHeight: function(pHeight){
          uiw._editor.setSize(null,pHeight);
        },

        // setWidth - can be 'auto', or number in px or number in %
        setWidth: function(pWidth){
          uiw._editor.setSize(pWidth,null);
        }        
                
      });    
      
    },
  
    _destroy: function(){
      var uiw = this;
      uiw._editor.off('change');
    },

    _renderButton: function(toolbar, id, label, icon, extraClasses, disabled ) {
      var uiw = this;
      toolbar.markup( "<button" )
            .attr( "id", uiw.baseId + "_" +id )
            .optionalAttr( "title", label)
            .optionalAttr( "aria-label", label)
            .optionalBoolAttr( "disabled", disabled )
            .attr( "class", "a-Button a-Button--noLabel a-Button--withIcon" + ( extraClasses ? " " + extraClasses : "" ) )
            .markup(" type='button'>" )
            .markup( "<span class='a-Icon " )
            .attr(icon)
            .markup( "' aria-hidden='true'></span></button>" );  
    },
    
    /**
     * validateCode
     */
    _validateCode: function(){
      var uiw = this;
      uiw._log('_validateCode', arguments);
      var vValButton = uiw._obj.wrapper$.find('.codemirror-toolbar > button[id$=validate]')
      vValButton.prop('disabled', true);  
      uiw._obj.wrapper$.find('.codemirror-msg-box').remove();
      var vRequest = apex.server.plugin ( uiw.options.ajaxId, {
          x01: "VALIDATE",
          x02: uiw._editor.doc.getValue()
        }, {
          success: function(pData) {
            if (pData.msgType){
              vValButton.prop('disabled', false);  
              uiw._obj.wrapper$.find('.codemirror-toolbar').after(
                  '<div class="codemirror-msg-box">'+
                    '<div class="codemirror-msg codemirror-msg-type-'+pData.msgType+'">'+
                      '<div class="msg-text">'+pData.msg+'</div>'+
                      '<button type="button" title="Close" aria-label="My Button" class="codemirror-msg-close t-Button t-Button--noLabel t-Button--icon t-Button--small"><span aria-hidden="true" class="t-Icon fa fa-times"></span></button>'+
                    '</div>'+
                  '</div>');

              var vMsg =   uiw._obj.wrapper$.find('.codemirror-msg').delay(3000).fadeOut('slow');   
            }
          }        
        });      
    },

    _initToolbar: function(){
      var uiw = this,
      toolbar = util.htmlBuilder();

      // internal toolbar function for adding button action
      function addAction(pCommand ) {
        $(document).on('click', "#" + uiw.baseId + "_" + pCommand, function() {
            if (uiw._editor) {
              uiw._editor.focus();
              switch (pCommand){
                case 'fullScreenOn':
                  uiw._editor.setOption("fullScreen", !uiw._editor.getOption("fullScreen"));
                  break;
                case 'fullScreenOff':
                  if (uiw._editor.getOption("fullScreen")) uiw._editor.setOption("fullScreen", false);
                  break;
                case 'validate':
                  uiw._validateCode();
                  break;  
                default:
                  setTimeout(function() {
                    uiw._editor.execCommand( pCommand );
                  }, 10);
                  break;
              }

            }
        } );
      }

      
      // generate toolbar markdown
      toolbar.markup('<div class="'+C_TOOLBAR_CLASS+'">');
      if(!uiw.options.readonly){
        uiw._renderButton(toolbar, 'undo', 'Undo' , 'icon-undo', 'a-Button--small a-Button--pillStart', true);
        uiw._renderButton(toolbar, 'redo', 'Redo' , 'icon-redo', 'a-Button--small a-Button--pill', true);
        addAction('undo');
        addAction('redo');                
      } 
      
      if (uiw.options.validateCode){
        uiw._renderButton(toolbar, 'validate', 'Validate Code (Ctrl+Alt+V)' , 'icon-check', 'a-Button--small a-Button--pillStart');
        addAction('validate');                
      }
      uiw._renderButton(toolbar, 'fullScreenOn' , 'Full Screen On (F11)' , 'icon-maximize', 'a-Button--small a-Button--pillEnd aCodeMirrorPluginFullScreenOn u-pullRight');
      uiw._renderButton(toolbar, 'fullScreenOff', 'Full Screen Off (Esc)', 'icon-restore', 'a-Button--small a-Button--pillEnd aCodeMirrorPluginFullScreenOff u-pullRight');
      toolbar.markup('</div>');

      // generate actions
      addAction('fullScreenOn');
      addAction('fullScreenOff');

      uiw.element.after(toolbar.toString());
      uiw.element.closest('div').addClass('codemirror-wrapper');
      uiw.element.closest('div.t-Form-fieldContainer').addClass('codemirror-container-wrapper');

      uiw._obj.wrapper$ = $(uiw.element).closest('.codemirror-wrapper');
      
/*
      uiw.settingsMenu$ = $(toolbar);
      uiw.settingsMenu$.menu({
        items: [
          {
            type: "toggle", 
            labelKey: "Full Screen", 
            get: function(){
              alert('aaa');
            }
          }
        ]}
      );
      */
    },
    _enable: function(){
      var uiw = this;
      uiw._log(C_PLUGIN_NAME, '_enable');
      uiw._editor.setOption('readOnly', false);      
      uiw._obj.wrapper$.removeClass(C_TOOLBAR_CLASS_READONLY);
      uiw._obj.wrapper$.find('.codemirror-toolbar > button[id$=undo]').prop('disabled', false);
      uiw._obj.wrapper$.find('.codemirror-toolbar > button[id$=redo]').prop('disabled', false);
      uiw._obj.wrapper$.find('.codemirror-toolbar > button[id$=validate]').prop('disabled', false);      
    },
    _disable: function(){
      var uiw = this;
      uiw._log(C_PLUGIN_NAME, '_disable');
      uiw._editor.setOption('readOnly', true);
      uiw._obj.wrapper$.addClass(C_TOOLBAR_CLASS_READONLY);
      uiw._obj.wrapper$.find('.codemirror-toolbar > button[id$=undo]').prop('disabled', true);
      uiw._obj.wrapper$.find('.codemirror-toolbar > button[id$=redo]').prop('disabled', true);
      uiw._obj.wrapper$.find('.codemirror-toolbar > button[id$=validate]').prop('disabled', true);            
    }


  });  

})(apex.jQuery, apex.util, apex.debug);


// CodeMirror, copyright (c) by Marijn Haverbeke and others
// Distributed under an MIT license: http://codemirror.net/LICENSE
 
(function(mod) {
  if (typeof exports == "object" && typeof module == "object") // CommonJS
    mod(require("../../lib/codemirror"));
  else if (typeof define == "function" && define.amd) // AMD
    define(["../../lib/codemirror"], mod);
  else // Plain browser env
    mod(CodeMirror);
})(function(CodeMirror) {
  "use strict";

  CodeMirror.defineOption("fullScreen", false, function(cm, val, old) {
    if (old == CodeMirror.Init) old = false;
    if (!old == !val) return;
    if (val) setFullscreen(cm);
    else setNormal(cm);
  });

  function setFullscreen(cm) {
    var wrap = cm.getWrapperElement();
    $(wrap).closest('div.codemirror-wrapper').addClass('codemirror-wrapp-fullscreen');
    cm.state.fullScreenRestore = {scrollTop: window.pageYOffset, scrollLeft: window.pageXOffset,
                                  width: wrap.style.width, height: wrap.style.height};
    wrap.style.width = "";
    wrap.style.height = "auto";
    wrap.className += " CodeMirror-fullscreen";
    document.documentElement.style.overflow = "hidden";
    cm.refresh();
  }

  function setNormal(cm) {
    var wrap = cm.getWrapperElement();
    $(wrap).closest('div.codemirror-wrapper').removeClass('codemirror-wrapp-fullscreen');
    wrap.className = wrap.className.replace(/\s*CodeMirror-fullscreen\b/, "");
    document.documentElement.style.overflow = "";
    var info = cm.state.fullScreenRestore;
    wrap.style.width = info.width; wrap.style.height = info.height;
    window.scrollTo(info.scrollLeft, info.scrollTop);
    cm.refresh();
  }
});

//# sourceMappingURL=fullscreen.js.map

//# sourceMappingURL=codemirror_custom.js.map
