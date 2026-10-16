@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Plan Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PRODPLANDATA
  as select distinct from ZI_PRODPLANDATA_BASE as a

{


  key cast(
        concat( concat(
            substring( a.Proddate, 5, 4 ),   -- YYYY
            substring( a.Proddate, 3, 2 ) ),   -- MM
            substring( a.Proddate, 1, 2 ) )    -- DD
        as abap.dats )                                as Proddate,

  key a.Plantcode,
  key a.Prodcode,
  key concat( concat( cast(
        concat( concat(
            substring( a.Proddate, 5, 4 ),   -- YYYY
            substring( a.Proddate, 3, 2 ) ),   -- MM
            substring( a.Proddate, 1, 2 ) )    -- DD
        as abap.dats ) , a.Plantcode ) , a.Prodcode ) as comb,
      a.Quantity
}

where Quantity > 0
