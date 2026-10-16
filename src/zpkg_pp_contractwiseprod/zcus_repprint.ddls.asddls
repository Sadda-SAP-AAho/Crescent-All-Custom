@ObjectModel.query.implementedBy: 'ABAP:ZCL_REP_IMPL'
@EndUserText.label: 'Custom Entity '
define custom entity ZCUS_REPPRINT
{
    key Shpflrdt    : sydate;
    key Opr         : abap.char(4);
    key Plant       : werks_d;
    key Dept        : abap.char(10);
    key Cont        : abap.char(20);
    Contname        : abap.char(200);
    Deptname        : abap.char(200);
    Oprname         : abap.char(40);
    laboritemno1    : abap.char(10);
    laboritemno2    : abap.char(10);
    laboritemno3    : abap.char(10);
    laboritemno4    : abap.char(10);
    _item                       : association [1..*] to ZCDS_REPPRNT_ITM on  $projection.Cont     = _item.cont
                                                                         and $projection.Dept     = _item.dept
                                                                         and $projection.Opr      = _item.opr
                                                                         and $projection.Plant    = _item.plant;
//                                                                         and $projection.Shpflrdt = _item.shpflrdt;
}
