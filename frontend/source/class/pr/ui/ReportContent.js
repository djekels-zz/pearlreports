/* ************************************************************************
   Copyright: 2013 OETIKER+PARTNER AG
   License:   GPLv3 or later
   Authors:   Tobi Oetiker <tobi@oetiker.ch>
   Utf8Check: äöü
************************************************************************ */

/**
 * Tabview holding the reports config and output tabs.
**/
qx.Class.define("pr.ui.ReportContent", {
    extend : qx.ui.tabview.Page,
    type: 'singleton',
    /**
     * @param table {pr.ui.Table} table controling the view content
     */
    construct : function() {
        this.base(arguments,this.tr("Output"));
    },
    members: {
        display: function(data){
            this.getChildControl('button').execute();
            console.log(data);
        }
    }
});
