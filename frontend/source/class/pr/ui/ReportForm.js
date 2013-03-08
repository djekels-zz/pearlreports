/* ************************************************************************
   Copyright: 2013 OETIKER+PARTNER AG
   License:   GPLv3 or later
   Authors:   Tobi Oetiker <tobi@oetiker.ch>
   Utf8Check: äöü
************************************************************************ */

/**
 * Tabview holding the reports config and output tabs.
**/
qx.Class.define("pr.ui.ReportForm", {
    extend : qx.ui.tabview.Page,
    type: 'singleton',
    /**
     * @param table {pr.ui.Table} table controling the view content
     */
    construct : function() {
        this.base(arguments,this.tr("Config"));
        this.set({
            layout: new qx.ui.layout.Grow(),
            padding: [ 20,20,20,20]
        });
        this._tree = pr.ui.Tree.getInstance();
        this._treeSelection = this._tree.getSelection();
        this._treeSelection.addListener('change',this._showForm,this);
    },
    members: {
        _treeSelection: null,
        _showForm: function(e){
            this.getChildControl('button').execute();
            var item = this._treeSelection.getItem(0);
            if (item.getForm != null){
                var form = item.getForm();
                if (!form){
                    form = this._buildFormAndButtons(this._tree.getCfg(item.getId()));
                    item.setForm(form);
                }
                this.removeAll();
                this.add(form);
            }
            else {                
                this.removeAll();
            }        
        },
        _buildFormAndButtons: function(cfg) {
            var box = new qx.ui.container.Composite(new qx.ui.layout.VBox(20));
            var form = new pr.ui.AutoForm(cfg.formCfg);
            box.add(form);
            var buttonBox = new qx.ui.container.Composite(new qx.ui.layout.HBox(5,'right'));
            cfg.submitCfg.forEach(function(buttonCfg){
                var button = new qx.ui.form.Button(buttonCfg.label).set({
                    minWidth: 200
                });
                buttonBox.add(button);
                button.addListener('execute',function(){
                    switch (buttonCfg.action) {
                        case 'view':
                            var rpcArgs = form.getData();
                            qx.lang.Object.mergeWith(rpcArgs,buttonCfg.extraParams);
                            pr.data.Server.getInstance().callAsyncSmart(function(ret){
                                pr.ui.ReportContent.getInstance().display(ret);
                            },'getReport',cfg.id,rpcArgs);
                            break;
                        case 'download':
                            var argList = [];
                            for (var key in rpcArgs){
                                argList.push(key+'='+encodeURIComponent(rpcArgs[key]));
                            }
                            var win = qx.bom.Window.open('/report/' + cfg.id+'/?' + argList.join(';'), '_blank');
                            qx.bom.Event.addNativeListener(win, 'load', function(e) {
                                var body = qx.dom.Node.getBodyElement(win);
                                var doc = qx.dom.Node.getDocumentElement(win);
                                /* if the window is empty, then it got opened externally */
                                if ((doc && qx.dom.Hierarchy.isEmpty(doc)) || (body && qx.dom.Hierarchy.isEmpty(body))) {
                                    win.close();
                                }
                            });
                            break;
                        default:
                            this.debug('Invalid Action'); 
                    }
                },this);
            },this);
            box.add(buttonBox);
            return box;
        }
    }    
});
