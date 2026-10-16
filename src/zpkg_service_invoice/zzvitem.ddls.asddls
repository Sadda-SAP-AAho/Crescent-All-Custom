@EndUserText.label: 'Item Print'
//@ClientHandling.type: #CLIENT_DEPENDENT
@AccessControl.authorizationCheck: #NOT_REQUIRED
//@AbapCatalog.sqlViewName: 'ZVINVITM'
@UI: {
  presentationVariant: [{ sortOrder: [{ by: 'InvoiceNo', direction: #ASC },
                                      { by: 'FiscalYear', direction: #ASC } ],
                          visualizations: [{type: #AS_LINEITEM}]
                           }]
                          }
define view entity ZZVITEM
  as select from ZTBL_FUCN_ITEMINV
{
  key InvoiceNo,
  key FiscalYear,
  key Item,
      Description,
      HSNCode,
      UOM,
      Amount,
      IGSTAmount,
      Total
}
