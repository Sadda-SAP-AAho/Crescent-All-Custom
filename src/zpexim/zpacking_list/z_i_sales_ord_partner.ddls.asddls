@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Partner'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_Sales_Ord_Partner  as select from I_SalesDocumentPartner as Partner
      
    association[1..1] to I_SalesOrder  as _SalesOrder on $projection.SalesOrder   = _SalesOrder.SalesOrder     
    
{
    key AddressID,
        @ObjectModel.foreignKey.association: '_SalesOrder'                                                                                                   
    key cast(Partner.SalesDocument as abap.char(10)) as SalesOrder,             
        @ObjectModel.foreignKey.association: '_PartnerFunction'
    key Partner.PartnerFunction,  
         
        Partner.Customer,          
        Partner.Supplier,           
        Partner.Personnel,           
        Partner.ContactPerson,       
        
        @ObjectModel.text.element: ['FullName']
        Partner.Partner,
        
        @Semantics: {
          text: true,
          name.fullName: true
        }
        Partner.FullName,
       
        Partner.ReferenceBusinessPartner,  
            
//        @ObjectModel.foreignKey.association: '_Address'
//        Partner.AddressID,
        Partner.AddressPersonID,
        Partner.AddressObjectType,
        Partner.SDDocPartnerAddressRefType,
        Partner.BPAddrDeterminationTransaction,
        Partner.BPRefAddressIDForDocSpcfcAddr, 
        Partner.SDDocPartnerAddrIsDocSpecific,
           
        Partner.VATRegistration,  
        @Semantics.text: true
        Partner.UnloadingPointName,
        
        Partner.CorrespondenceLanguage,
        Partner.FormOfAddress,
        
        Partner.InternationalPhoneNumber,
        Partner.InternationalMobilePhoneNumber,
        Partner.InternationalFaxNumber,
        Partner.EmailAddress,
        
        //Association
//        @ObjectModel.association.type: [#TO_COMPOSITION_PARENT, #TO_COMPOSITION_ROOT]    
        _SalesOrder,
        Partner._PartnerFunction,
        Partner._ContactPerson
//        Partner._Address,
//        Partner._DfltAddrRprstn,
//        Partner._BusinessPartnerAddress,
//        Partner._BPRefAddressForDocSpcfcAddr,
//        Partner._PersonAddress,
//        Partner._PersonName,
//        Partner._OrganizationAddress,
//        Partner._OrgNamePostalAddress 

}
where Partner.SDDocumentCategory = 'C';        
