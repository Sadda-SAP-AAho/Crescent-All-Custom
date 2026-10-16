@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'EPCG header'

define root view entity ZC_EPCG_HDR
  provider contract transactional_query
  as projection on ZI_EPCG_HDR
{
      @EndUserText.label: 'ID'
  key Id,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Ecom Number'
      Ecomno,
      @EndUserText.label: 'Currency'
      @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'I_Currency',
           element: 'Currency'
         }
       } ]
      Waers,
      @EndUserText.label: 'Total CIF Value'
      @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'I_Currency',
          element: 'Currency'
        }
      } ]
      Totalcifvalue,
      @EndUserText.label: 'Remain Duty Save'
      @Consumption.valueHelpDefinition: [ {
       entity: {
         name: 'I_Currency',
         element: 'Currency'
       }
      } ]
      Remaindutysave,
      @EndUserText.label: 'PO Number'
      Ponum,
      @EndUserText.label: 'Company Code'
      Bukrs,
      @EndUserText.label: 'Total Duty Save'
      @Consumption.valueHelpDefinition: [ {
       entity: {
         name: 'I_Currency',
         element: 'Currency'
            }
      } ]
      Totaldutysave,
      @EndUserText.label: 'File No'
      Fileno,
      @EndUserText.label: 'File Date'
      Filedate,
      @EndUserText.label: 'License No'
      Licno,
     @EndUserText.label: 'License Date'
      Licdate,
       @EndUserText.label: 'Actual Duty Save Value'
      @Consumption.valueHelpDefinition: [ {
       entity: {
         name: 'I_Currency',
         element: 'Currency'
            }
     } ]
      Dutysaveval,
      @EndUserText.label: 'Planned Export Obg.'
      @Consumption.valueHelpDefinition: [ {
       entity: {
         name: 'I_Currency',
         element: 'Currency'
            }
     } ]
      Plannedexpobg,
      @EndUserText.label: 'Average'
      @Consumption.valueHelpDefinition: [ {
       entity: {
         name: 'I_Currency',
         element: 'Currency'
            }
      } ]
      Average,
      @EndUserText.label: 'Export Obligation1'
      @Consumption.valueHelpDefinition: [ {
       entity: {
         name: 'I_Currency',
         element: 'Currency'
            }
     } ]
      Expobg1,
      /* Associations */
      _item : redirected to composition child ZC_EPCG_ITM

}
