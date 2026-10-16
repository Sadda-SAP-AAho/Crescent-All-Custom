@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Forex Contract Item'
@Metadata.allowExtensions: true
@Search.searchable: true
define  view entity ZC_FOREXITMTP 
as projection on ZI_FOREXTPITM
{
    
            @EndUserText.label: 'ID'
    key     Id,
            @Search.defaultSearchElement: true
            @EndUserText.label: 'Item'
    key     Item,
            @EndUserText.label:'Code'
            Contnoext,      
            @EndUserText.label:'Adj Document Type'
            Adjustdoctype,
            @EndUserText.label:'Invoice Number'
            Docno, 
            @EndUserText.label:'Invoice Date'
            Docdate,
            @EndUserText.label:'Currency'
            @Consumption.valueHelpDefinition: [ {
            entity: {
            name: 'I_Currency',
            element: 'Currency'
            }
            } ]
            Waers,
            @EndUserText.label:'Invoice Amount'
            @Consumption.valueHelpDefinition: [ {
            entity: {
            name: 'I_Currency',
            element: 'Currency'
            }
            } ]
            Amt,
            @EndUserText.label:'Remarks'
            Remarks,
            @EndUserText.label:'Instruction Date'
            Instructdate,
            @EndUserText.label:'Adjusted Val'
            @Consumption.valueHelpDefinition: [ {
            entity: {
            name: 'I_Currency',
            element: 'Currency'
            }
            } ]
            Adjustval,
            @EndUserText.label:'Customer Reference'
            Custref,
           @EndUserText.label:'Loan Amount'
            Loanamt,
            Loancurr,
           @EndUserText.label:'Sales Order Value'
            Salesamt,
            Salecurr,
           @EndUserText.label:'Sales Order Date'
            Salesdate,
           @EndUserText.label:'Sales Order'
            Salesorder,
            Lcamt,
           @EndUserText.label:'Loan Account No'
            Loanaccno,
            Lcnum,
            Lcurr,
           @EndUserText.label:'Other Text'
            Othertext,
           @EndUserText.label:'Other Amount'
           @Consumption.valueHelpDefinition: [ {
            entity: {
            name: 'I_Currency',
            element: 'Currency'
            }
            } ]
            Otheramt,
            Othercurr,
            @EndUserText.label:'Fiscal Year'
            Fiscalyear,
            @EndUserText.label:'Company Code'
            Companycode,
    /* Associations */
    _head :redirected to parent ZC_FOREXTP
}
