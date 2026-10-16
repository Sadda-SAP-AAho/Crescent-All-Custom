    @AccessControl.authorizationCheck: #NOT_REQUIRED
    @Metadata.allowExtensions: true
    @EndUserText.label: 'Create service PO and SES based on action'
    //@ObjectModel.usageType.serviceQuality: #A
    //@ObjectModel.usageType.sizeCategory: #L
    //@ObjectModel.usageType.dataClass: #TRANSACTIONAL
    //@Metadata.ignorePropagatedAnnotations:true
    
    define root view entity ZI_SPO_SES
    //  provider contract transactional_query
    //  as projection on ZI_EXPENSECAL
      //  // as select from ZI_EXPENSECAL
    
    as select from ZI_EXPENSECAL
      //composition of target_data_source_name as _association_nameI as _item
    {
    
          //KEY commid       as Commid,
//           @Consumption.hidden: true
//          @EndUserText.label: 'ID'
     //key Id,
    //  
         @Consumption.valueHelpDefinition: [{
             entity: {
               name: 'ZI_COMM_ID_VH',
               element: 'Commid'
             }
           }]
          @EndUserText.label: 'Commercial Invoice'
          key Commid,
    
          //      commid       as Commid,
          @Consumption.hidden: true
          Commdate     as Commdate,
          @Consumption.hidden: true
          servicepobt  as servicepobt,
          @Consumption.hidden: true
          poupd        as poupd,
          @Consumption.hidden: true
          Taxcode      as Taxcode,
          @Consumption.hidden: true
          Profitcenter as Profitcenter,
          @Consumption.hidden: true
          Costcenter   as Costcenter
          
         // _item
          
    
    
    }
