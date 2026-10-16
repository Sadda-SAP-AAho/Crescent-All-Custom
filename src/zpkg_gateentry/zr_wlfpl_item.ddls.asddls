@EndUserText.label: 'WILD LOTUS ITEM CDS'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZR_WLFPL_ITEM
  as select distinct from I_BillingDocument     as a
    inner join            zi_ghead              as b on b.Challannumber = a.BillingDocument
    inner join            I_BillingDocumentItem as c on c.BillingDocument = b.Challannumber
    inner join            I_Customer            as d on d.Customer = a.SoldToParty
{
  key  a.BillingDocument,
       a.SoldToParty,
       c.OriginallyRequestedMaterial,
       c.BillingDocumentItemText,
       c.ItemWeightUnit,
       @Semantics.quantity.unitOfMeasure : 'BaseUnit'
       c.BillingQuantity,

       c.BaseUnit,
       d.CustomerFullName
}
