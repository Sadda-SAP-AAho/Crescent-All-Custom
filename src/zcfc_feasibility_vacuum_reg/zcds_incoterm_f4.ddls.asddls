@AbapCatalog.sqlViewName: 'Z_INCOTERM_F4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'INCOTERM - F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_INCOTERM_F4
  as select distinct from I_IncotermsClassification as a
{
  key a.IncotermsClassification as incoterm
}
where
  (
       a.IncotermsClassification = 'DDP'
    or a.IncotermsClassification = 'DAP'
    or a.IncotermsClassification = 'CIF'
    or a.IncotermsClassification = 'DDU'
    or a.IncotermsClassification = 'FCA'
  )
