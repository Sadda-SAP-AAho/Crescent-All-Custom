@EndUserText.label: 'Expense Type Maintain Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'ExpenseTypeMaintAll'
  }
}
define root view entity ZI_ExpenseTypeMaintain_S
  as select from    I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_EXPENSETYPEMAINTAIN'
  association [0..*] to I_ABAPTransportRequestText as _I_ABAPTransportRequestText on $projection.TransportRequestID = _I_ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_ExpenseTypeMaintain     as _ExpenseTypeMaintain
{
      @UI.facet: [ {
        id: 'ZI_ExpenseTypeMaintain',
        purpose: #STANDARD,
        type: #LINEITEM_REFERENCE,
        label: 'Expense Type Maintain',
        position: 1 ,
        targetElement: '_ExpenseTypeMaintain'
      } ]
      @UI.lineItem: [ {
        position: 1
      } ]
  key 1                                            as SingletonID,
      _ExpenseTypeMaintain,
      @UI.hidden: true
      I_CstmBizConfignLastChgd.LastChangedDateTime as LastChangedAtMax,
      @ObjectModel.text.association: '_I_ABAPTransportRequestText'
      @UI.identification: [ {
        position: 2 ,
        type: #WITH_INTENT_BASED_NAVIGATION,
        semanticObjectAction: 'manage'
      } ]
      @Consumption.semanticObject: 'CustomizingTransport'
      cast( '' as sxco_transport)                  as TransportRequestID,
      _I_ABAPTransportRequestText

}
where
  I_Language.Language = $session.system_language
