/* ************************************************************************
   Copyright: 2013 OETIKER+PARTNER AG
   License:   GPLv3 or later
   Authors:   Tobi Oetiker <tobi@oetiker.ch>
   Utf8Check: äöü
************************************************************************ */

/* ************************************************************************


************************************************************************ */

/**
 * The Report Tree
 */
qx.Class.define("pr.ui.Tree", {
    extend : qx.ui.tree.VirtualTree,
    type: 'singleton',
    /**
     * create a navigator tree view
     *
     * @param colDef {Map} column definitions
     * @param treeOpen {Integer} how many tree nodes to open initially
     * @return {void} 
     */
    construct : function() {
        var nodes = qx.data.marshal.Json.createModel([{name: "Loading ..."}], true);
        this.base(arguments,nodes.getItem(0),"name","kids");
        this.set({
            width: 200,
            height: 200,
            enabled: false,
            openMode: 'click'
        });
        this._cfgMap = {};
        pr.data.Config.getInstance().addListener('changeData',this._populateTree,this);
    },
    members: {
        _cfgMap: null,

        _populateTree: function(e){
            var config = e.getData();
            var data = { name: 'root' };
            config.reports.forEach(function(report){
                var p = data;
                report.name.forEach(function(key){
                    if (p.index == null){
                        p.index = {};
                        p.kids = [];
                    }
                    if (p.index[key] == null){
                        var node = {name: key};
                        p.kids.push(node);
                        p.index[key] = node;
                    }
                    p = p.index[key];
                });
                p.form = null;
                p.id = report.id;
                this._cfgMap[p.id] = report;
            },this);
            var model = qx.data.marshal.Json.createModel(data,true);
            this.set({
                model: model,
                enabled: true,
                hideRoot: true
            });
        },
        getCfg: function(id){
            return this._cfgMap[id];
        }
    }
});
