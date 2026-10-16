@EndUserText.label: 'Copy Approval Matrix For Payments'
define abstract entity ZD_CopyApprovalMatrixForPaP
{
  @EndUserText.label: 'New Company Code'
  Companycode : BUKRS;
  @EndUserText.label: 'New Last changed by'
  Userid : UNAM;
  @EndUserText.label: 'New Apprlevel'
  Apprlevel : abap.numc( 1 );
  
}
