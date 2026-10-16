@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Net Due Date Update'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_DUEDATE_HDR 
provider contract transactional_query
as projection on ZI_DUEDATE_HDR 
{  
    @EndUserText.label: 'ID'
    key Id,
    @EndUserText.label: 'Company Code'
    Ccode,
    @EndUserText.label: 'Customer'
    Customer,
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Invoice No.'
    Belnr,
    @EndUserText.label: 'Invoice Year'
    Gjahr,
    @EndUserText.label: 'Item'
    Buzei,
    @EndUserText.label: 'Invoice Date'
    Invdt,
    @EndUserText.label: 'Payment term'
    Zterm,
    @EndUserText.label: 'Payment Term Desc'
    Pdesc,
    @EndUserText.label: 'Due Date Change Basis Id'
    Basis,
    @EndUserText.label: 'Due Date Change Basis'
    Basistxt,
    @EndUserText.label: 'No Of Days'
    Noofday,
    @EndUserText.label: 'Baseline Date'
    Basedt,
    @EndUserText.label: 'Net Due Date'
    Duedt,
    @EndUserText.label: 'Amount'
    Amount,
    @EndUserText.label: 'Currency'
    Currency,
    @EndUserText.label: 'Document Sent to Customer date'
    Docsentcus,
    @EndUserText.label: 'Bill of Lading Date'
    Billoflad,
    @EndUserText.label: 'Invoice Date'
    Invoicedt,
    @EndUserText.label: 'Document Sent to Bank date'
    Docsentban,
    @EndUserText.label: 'Revised Due date'
    Revduedt,
    @EndUserText.label: 'Calculate'
    Cal,
    @EndUserText.label: 'Update'
    Post,
    @EndUserText.label: 'Status'
    Status,
    @EndUserText.label: 'Last Posted On'
    Lastposted,
    @EndUserText.label: 'Baseline Date system'
    Basedtsys,
    @EndUserText.label: 'Due Date System'
    Duedtsys,
    @EndUserText.label: 'Commercial Invoice No'
    Docref,
    @EndUserText.label: 'Refresh'
    Upd
}
