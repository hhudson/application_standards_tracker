/*!
* Copyright (c) 2014, 2021, Oracle and/or its affiliates.
*/

/**
 * @fileOverview
 * Search results functionality for navigating to the source of the search result items.
**/

function getBuilderInstance() {
    // var bInstance = $( "#pInstance" ).val(); //this is wrong if you are running from the browser
    // var bInstance = apex.item("P0_APX_BLDR_SESSION").getValue(); //this is wrong if you are running from the browser
    var bInstance = apex.util.getTopApex().item("P0_APX_BLDR_SESSION").getValue(); 
    apex.debug.info("getBuilderInstance :", bInstance);
    
    if (!bInstance) 
    {
        alert("Fatal error : Builder session is null!");
    } else {
        apex.debug.info("getBuilderInstance / sesssion :", bInstance);
    }
    return bInstance;
    };
    
    // (function( $, nav ) {
    //     "use strict";
    
        var BUILDER_WINDOW_NAME = "APEX_BUILDER";
    
        function isOpenerApexBuilder() {
            try {
                // builder urls are in the 4000s
                if ( window.opener && !window.opener.closed && window.opener.apex &&
                    window.opener.apex.jQuery &&
                    ( window.opener.location.href.match(/f?p=4\d\d\d:/) || window.opener.document.getElementById("pFlowId") ) ) {
                        apex.debug.info("isOpenerApexBuilder = true");
                        return true;
                    }
                } catch ( ex ) {
                    apex.debug.info("isOpenerApexBuilder = false");
                    return false; // window must contain a page from another domain
                }
                apex.debug.info("isOpenerApexBuilder = false");
                return false;
            }
            
        
        function navigateInPageDesigner( appId, pageId, typeId, componentId, errorFn ) {
            apex.debug.info("navigateInPageDesigner");
            if ( isOpenerApexBuilder() && window.opener.pageDesigner && 1==2) {
                apex.debug.info("clear to go");
                window.opener.pageDesigner.setPageSelection( appId, pageId, typeId, componentId, function( result ) {
                    apex.debug.info("result :", result);
                    if ( result !== "OK" ) {
                        // apex.debug.error("no OK");
                        errorFn();
                    }
                });
                // Focus the builder window now while still handling the click event even though controlling the page designer may still fail
                apex.navigation.openInNewWindow( "", BUILDER_WINDOW_NAME, { altSuffix: getBuilderInstance() } );
            } else {
                // apex.debug.error("error");
                errorFn();
            }
        }
        
        function navigateInBuilderWindow( url ) {
            var instance = getBuilderInstance();
            apex.debug.info("navigateInBuilderWindow :", instance);
            apex.debug.info("url :", url, "  / BUILDER_WINDOW_NAME: ", BUILDER_WINDOW_NAME, "> { altSuffix: instance } : ", { altSuffix: instance });
            
            apex.navigation.openInNewWindow( url, BUILDER_WINDOW_NAME, { altSuffix: instance } );
        }
        // expose these for use by DAs
        window.navigateInBuilderWindow = navigateInBuilderWindow;
        window.doSearch = function() {
            $("#search_results").hide();
            apex.submit({showWait: true});
        };
        
        function openDialog( url, options, classes, btn ) {
            apex.debug.info("openDialog");
            // Caution! this code makes many assumptions about how the builder opens modal dialog pages
            options = options.replace(/([-_a-zA-Z]*):/g, function(m, a) { return '"' + a + '":';} );
            options = options.replace(/'/g, "\"");
            options = options.replace(/\\u(\d\d\d\d)/, function(m,n) { return String.fromCharCode(parseInt(n, 16)); } );
            url = url.replace(/\\u(\d\d\d\d)/, function(m,n) { return String.fromCharCode(parseInt(n, 16)); } );
            apex.navigation.dialog( url, JSON.parse(options), classes, btn );
        }
        
        // $( function() {
            
        //     $( "button.edit-button" ).click( function( event ) {
        //         apex.debug.info("click event");
        //         var appId, pageId, componentId, url, match,
        //         btn$ = $( this ),
        //         instance = getBuilderInstance(),
        //         typeId = btn$.attr( "data-typeid" );
        //         apex.debug.info("typeId", typeId);
    
                
        //         if ( typeId ) {
        //             appId = btn$.attr( "data-appid" );
        //             apex.debug.info("appId", appId);
        //             pageId = btn$.attr( "data-pageid" );
        //             apex.debug.info("pageId", pageId);
        //             componentId = btn$.attr( "data-componentid" );
        //             apex.debug.info("componentId", componentId);
        //             var url = "f?p=4000:4500:" + instance +
        //                 "::NO:1:FB_FLOW_ID,FB_FLOW_PAGE_ID,F4000_P1_FLOW,F4000_P1_PAGE:" + appId +
        //                 "," + pageId +
        //                 "," + appId +
        //                 "," + pageId +
        //                 "#" + typeId + ":" + componentId;
        //              apex.debug.info("url", url);
        //             navigateInPageDesigner( appId, pageId, typeId, componentId, function() {
        //                 var url = "f?p=4000:4500:" + instance +
        //                 "::NO:1:FB_FLOW_ID,FB_FLOW_PAGE_ID,F4000_P1_FLOW,F4000_P1_PAGE:" + appId +
        //                 "," + pageId +
        //                 "," + appId +
        //                 "," + pageId +
        //                 "#" + typeId + ":" + componentId;
        //                 navigateInBuilderWindow( url );
        //             } );
        //         } else {
        //             url = btn$.attr( "data-link" );
        //             apex.debug.info("url", url);
        //             // in the case of a URL that opens a dialog we can't just eval that code
        //             // Caution! this code makes many assumptions about how the builder opens modal dialog pages
        //             match = /'(f\?p.*p_dialog_cs[^']*)',(\{.*\}),'([^']*)'/.exec( url );
        //             if ( match ) {
        //                 openDialog( match[1], match[2], match[3], btn$ );
        //             } else {
        //                 navigateInBuilderWindow( url );
        //             }
        //         }
        //         event.preventDefault();
        //     } );
        // });
    
    // })( apex.jQuery, apex.navigation );