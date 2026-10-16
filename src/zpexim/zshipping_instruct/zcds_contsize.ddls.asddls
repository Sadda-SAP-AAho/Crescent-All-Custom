@AbapCatalog.sqlViewName: 'ZSVIEW1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Shipping Instruction CONTSIZE'
define view ZCDS_CONTSIZE
    as select from ZVSHIPINST_ITM as a
        inner join ZVSHIPINST_HDR as b on a.Bookingno = b.Bookingno
{
  key a.Bookingno,
  a.ContainerSize,
  count( distinct a.Delivery) as NoOfCont
}
group by
a.Bookingno,
ContainerSize
