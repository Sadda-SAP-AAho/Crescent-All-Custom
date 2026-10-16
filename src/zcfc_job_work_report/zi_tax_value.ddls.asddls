@AbapCatalog.sqlViewName: 'ZTAXVALUE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tax Value-Calculation'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_TAX_VALUE
  as select distinct from I_BillingDocument              as a
    inner join            I_BillingDocumentItem          as b on a.BillingDocument = b.BillingDocument
    left outer join       I_BillingDocumentItemPrcgElmnt as c on  a.BillingDocument     = c.BillingDocument
                                                              and b.BillingDocumentItem = c.BillingDocumentItem
    left outer join       ZI_MATDOCITEM                  as d on  b.ReferenceSDDocument     = d.MaterialDocument
                                                              and b.ReferenceSDDocumentItem = d.RefDocumentItem
{
  key b.ReferenceSDDocument                                                                             as MaterialDocument,
  key d.MaterialDocumentYear,
  key d.MaterialDocumentItem                                                                            as MaterialDocumentItem,
      cast( sum( (case when c.ConditionType = 'JOIG' then c.ConditionAmount end ) ) as abap.dec(15,3) ) as IGST_Value,
      cast( sum( (case when c.ConditionType = 'JOCG' then c.ConditionAmount end ) ) as abap.dec(15,3) ) as CGST_Value,
      cast( sum( (case when c.ConditionType = 'JOSG' then c.ConditionAmount end ) ) as abap.dec(15,3) ) as SGST_Value


}

group by
  b.ReferenceSDDocument,
  d.MaterialDocumentYear,
  d.MaterialDocumentItem
