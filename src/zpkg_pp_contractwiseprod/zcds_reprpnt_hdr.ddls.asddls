@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View For Tax Invoice Header Details'
define root view entity ZCDS_REPRPNT_HDR
//  as select from    ZI_CONTRACT_HDR                 as i
 as select from    zdt_contract_hdr  as i
  left outer join ZI_CONTRACTOR_F4   as c on c.Zcon = i.cont
  
{
    key i.shpflrdt,
    key i.opr,
    key i.plant,
    key i.dept,
    key i.cont,
    c.Zcod as Contname,
    i.deptname,
    i.oprname,
    i.laboritemno1,
    i.laboritemno2,
    i.laboritemno3,
    i.laboritemno4 
}
