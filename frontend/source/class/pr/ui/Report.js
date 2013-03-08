/* ************************************************************************
   Copyright: 2013 OETIKER+PARTNER AG
   License:   GPLv3 or later
   Authors:   Tobi Oetiker <tobi@oetiker.ch>
   Utf8Check: äöü
************************************************************************ */

/**
 * Tabview holding the reports config and output tabs.
**/
qx.Class.define("pr.ui.Report", {
    extend : qx.ui.tabview.TabView,
    type: 'singleton',
    /**
     * @param table {pr.ui.Table} table controling the view content
     */
    construct : function() {
        this.base(arguments);
        this.add(pr.ui.ReportForm.getInstance());
        this.add(pr.ui.ReportContent.getInstance());
    }
});
