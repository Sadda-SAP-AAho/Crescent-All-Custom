@AbapCatalog.sqlViewName: 'YCOMMFINALSPLIT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Final Commercial Split Value'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_COMM_INV_SPLT_VALUE as select from ZI_COMM_INV_SPLT_VAL_Final
{
    key Billingdocument,
    key Billingdocumentitem,
    Col1,
    Col2,
    Col3,
    Col4,
    Col5,
    Col6,
    Col7,
    Col8,
    Col9,
    Col10,
    Col11,
    Col12,
    Col13,
    Col14
//    Col15,
//    Col16,
//    Col17,
//    Col18,
//    Col19,
//    Col20,
//    Col21,
//    Col22
}
