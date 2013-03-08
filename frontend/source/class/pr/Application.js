/* ************************************************************************
   Copyright: 2009 OETIKER+PARTNER AG
   License:   GPLv3 or later
   Authors:   Tobi Oetiker <tobi@oetiker.ch>
   Utf8Check: äöü
************************************************************************ */

/* ************************************************************************

************************************************************************ */

/**
 * Main extopus application class.
 */
qx.Class.define("pr.Application", {
    extend : qx.application.Standalone,

    members : {
        /**
         * Launch the extopus application.
         *
         * @return {void} 
         */
        main : function() {
            // Call super class
            this.base(arguments);
            qx.Class.include(qx.ui.treevirtual.TreeVirtual, qx.ui.treevirtual.MNode);

            // Enable logging in debug variant
            if (qx.core.Environment.get("qx.debug")) {
                // support native logging capabilities, e.g. Firebug for Firefox
                qx.log.appender.Native;

                // support additional cross-browser console. Press F7 to toggle visibility
                qx.log.appender.Console;
            }

            var root = this.getRoot();
            var desktop = pr.ui.Desktop.getInstance();
            root.add(desktop, {
                left   : 3,
                top    : 3,
                right  : 3,
                bottom : 3
            });

            var rpc = pr.data.Server.getInstance();

            rpc.callAsyncSmart(function(cfg) {
                pr.data.Config.getInstance().setData(cfg);
            },
            'getConfig');
        }
    }
});
