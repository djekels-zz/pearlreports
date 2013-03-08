/* ************************************************************************
   Copyright: 2011 OETIKER+PARTNER AG
   License:   GPLv3 or later
   Authors:   Tobi Oetiker <tobi@oetiker.ch>
   Utf8Check: äöü
************************************************************************ */
/**
 * Build the desktop. This is a singleton. So that the desktop
 * object and with it the treeView and the searchView are universaly accessible
 */
qx.Class.define("pr.ui.Desktop", {
    extend : qx.ui.splitpane.Pane,
    type : 'singleton',

    construct : function() {
        this.base(arguments,'horizontal');
        this.add(pr.ui.Tree.getInstance(),0);
        this.add(pr.ui.Report.getInstance(),1);
    }
});
