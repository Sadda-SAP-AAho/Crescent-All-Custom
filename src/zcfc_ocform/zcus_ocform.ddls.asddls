@ObjectModel.query.implementedBy: 'ABAP:ZCL_OCFORM_IMPL'
@EndUserText.label: 'Custom Entity for OC Form'
define custom entity ZCUS_OCFORM
{
  key ORDNO            : vbeln;
      Dt               : sydate;
      BillNm           : abap.char(100);
      ShpNm            : abap.char(100);
      BillAdd          : abap.char(256);
      ShpAdd           : abap.char(256);
      OrdCurrency      : abap.char(3);
      POD              : abap.char(100);
      ShippTyp         : abap.char(100);
      FnlDst           : abap.char(100);
      PaymentTerms     : abap.char(256);
      PlndMnthShipment : abap.char(256);
      _item            : association [1..*] to ZI_OCFORM_ITEM on $projection.ORDNO = _item.OrdNo;
}
