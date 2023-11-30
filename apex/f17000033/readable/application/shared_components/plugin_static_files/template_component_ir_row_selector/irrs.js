var irrs = { 
    // PKs is the array that will hold the selected items
    PKs : [],

    // MngPK (short for "Manage Primary Key") either adds or subtracts a given PK from the array
    // parameter slctr (short for "Selector") is expecting "this"
    // parameter AllOrNone is expecting the values of All/None/Null - "All" will force the selection of a PK, even if it already selected
    MngPK : function (slctr,AllOrNone){
        apex.debug.info('MngPK > ',{slctr},
                        'AllOrNone', AllOrNone, 
                        'ariaChecked', slctr.getAttribute('aria-checked'));
        lSelectorID = "#"+slctr.id;
        lPK = slctr.dataset.primarykey;
        lOutputItem = slctr.dataset.outputitem;
        if ((slctr.getAttribute('aria-checked') === "false" || AllOrNone === "All") && AllOrNone !== "None") {
            apex.debug.info('MngPK > selecting row');
            irrs.PKs.push(lPK);
            $(lSelectorID).addClass("is-selected");
            $(lSelectorID).attr("aria-checked","true");
        } else {
            apex.debug.info('MngPK > unselecting row');
            var removeItemIdx = $.inArray(lPK,irrs.PKs);
            irrs.PKs.splice( removeItemIdx ,1 );
            $(lSelectorID).removeClass("is-selected");
            $(lSelectorID).attr("aria-checked","false");
        }
        apex.debug.info('MngPK >',irrs.PKs);
        if (lOutputItem != "") {
            apex.item(lOutputItem).setValue(irrs.PKs);
        }
    },
    
    // SelectAll selects all the visible rows
    // slctr (short for "Selector") is expecting "this"
    SelectAll : function  (slctr) {
        apex.debug.info('SelectAll',{slctr},
                        'aria-checked', slctr.getAttribute('aria-checked'));
        irrs.PKs.length = 0;
        var AllOrNone
        if (slctr.getAttribute('aria-checked') === "false") {
            apex.debug.info('SelectAll > selecting header');
            $(".irrsHeader").addClass("is-selected");
            $(".irrsHeader").attr("aria-checked","true");
            AllOrNone = "All";
        } else {
            apex.debug.info('SelectAll > unselecting header');
            $(".irrsHeader").removeClass("is-selected");
            $(".irrsHeader").attr("aria-checked","false");
            AllOrNone = "None";
        }
        $( ".irrs" ).each(function( index ) {
                apex.debug.info('SelectAll > ', $( this )[0].dataset.primarykey );
                irrs.MngPK($( this )[0],AllOrNone);
            });
    }
};