CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TDAT_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZTABLEFORLCSTATUS'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'TableForLcStatus' table = 'ZDT_LCSTATUSF4' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_TABLEFORLCSTATUS_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR TableForLcStatus
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TableForLcStatus~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR TableForLcStatus
        RESULT result.
*      EDIT FOR MODIFY
*        IMPORTING
*          KEYS FOR ACTION TableForLcStatus~edit.
ENDCLASS.

CLASS LHC_ZI_TABLEFORLCSTATUS_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: edit_flag            TYPE abp_behv_op_ctrl    VALUE if_abap_behv=>fc-o-enabled
         ,transport_feature    TYPE abp_behv_field_ctrl VALUE if_abap_behv=>fc-f-mandatory
         ,selecttransport_flag TYPE abp_behv_op_ctrl    VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_mandatory( ) = abap_false.
      transport_feature = if_abap_behv=>fc-f-unrestricted.
    ENDIF.
    IF keys[ 1 ]-%IS_DRAFT = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %TKY = keys[ 1 ]-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_TableForLcStatus = edit_flag
*               %FIELD-TransportRequestID = transport_feature
               %ACTION-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF ZI_TableForLcStatus_S IN LOCAL MODE
      ENTITY TableForLcStatus
        UPDATE FIELDS ( TransportRequestID )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                         ) ).

    READ ENTITIES OF ZI_TableForLcStatus_S IN LOCAL MODE
      ENTITY TableForLcStatus
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_TABLEFORLCSTATUS' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
*  METHOD EDIT.
*    CHECK lhc_rap_tdat_cts=>get( )->is_transport_mandatory( ).
*    DATA(transport_request) = lhc_rap_tdat_cts=>get( )->get_transport_request( ).
*    IF transport_request IS NOT INITIAL.
*      MODIFY ENTITY IN LOCAL MODE ZI_TableForLcStatus_S
*        EXECUTE SelectCustomizingTransptReq FROM VALUE #( ( %IS_DRAFT = if_abap_behv=>mk-on
*                                                            SingletonID = 1
*                                                            %PARAM-transportrequestid = transport_request ) ).
*      reported-TableForLcStatusAll = VALUE #( ( %IS_DRAFT = if_abap_behv=>mk-on
*                                     SingletonID = 1
*                                     %MSG = mbc_cp_api=>message( )->get_transport_selected( transport_request ) ) ).
*    ENDIF.
*  ENDMETHOD.
ENDCLASS.
CLASS LSC_ZI_TABLEFORLCSTATUS_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION,
      CLEANUP_FINALIZE REDEFINITION.
ENDCLASS.

CLASS LSC_ZI_TABLEFORLCSTATUS_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
*    READ TABLE update-TableForLcStatusAll INDEX 1 INTO DATA(all).
*    IF all-TransportRequestID IS NOT INITIAL.
*      lhc_rap_tdat_cts=>get( )->record_changes(
*                                  transport_request = all-TransportRequestID
*                                  create            = REF #( create )
*                                  update            = REF #( update )
*                                  delete            = REF #( delete ) )->update_last_changed_date_time( view_entity_name   = 'ZI_TABLEFORLCSTATUS'
*                                                                                                        maintenance_object = 'ZTABLEFORLCSTATUS' ).
*    ENDIF.
  ENDMETHOD.
  METHOD CLEANUP_FINALIZE ##NEEDED.
  ENDMETHOD.
ENDCLASS.
*CLASS LHC_ZI_TABLEFORLCSTATUS DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
*  PRIVATE SECTION.
*    METHODS:
**      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
**        IMPORTING
**          REQUEST REQUESTED_FEATURES FOR TableForLcStatus
**        RESULT result,
**      DEPRECATE FOR MODIFY
**        IMPORTING
**          KEYS FOR ACTION TableForLcStatus~Deprecate
**        RESULT result,
**      INVALIDATE FOR MODIFY
**        IMPORTING
**          KEYS FOR ACTION TableForLcStatus~Invalidate
**        RESULT result,
**      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
**        IMPORTING
**           REQUEST requested_authorizations FOR TableForLcStatus
**        RESULT result,
**      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
**        IMPORTING
**          KEYS REQUEST requested_features FOR TableForLcStatus
**        RESULT result,
*      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
*        IMPORTING
*          KEYS_TABLEFORLCSTATUS FOR TableForLcStatus~.
*ENDCLASS.

*CLASS LHC_ZI_TABLEFORLCSTATUS IMPLEMENTATION.
*  METHOD GET_GLOBAL_FEATURES.
*    DATA edit_flag TYPE abp_behv_op_ctrl VALUE if_abap_behv=>fc-o-enabled.
*    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
*      edit_flag = if_abap_behv=>fc-o-disabled.
*    ENDIF.
*    result-%UPDATE = edit_flag.
*  ENDMETHOD.
*  METHOD DEPRECATE.
*    MODIFY ENTITIES OF ZI_TableForLcStatus_S IN LOCAL MODE
*      ENTITY TableForLcStatus
*      UPDATE
*        FIELDS ( ConfigDeprecationCode ConfigDeprecationCode_Critlty )
*        WITH VALUE #( FOR key IN keys
*                       ( %TKY            = key-%TKY
*                         ConfigDeprecationCode            = 'W'
*                         ConfigDeprecationCode_Critlty = 2 ) ).
*    READ ENTITIES OF ZI_TableForLcStatus_S IN LOCAL MODE
*      ENTITY TableForLcStatus
*      ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(TableForLcStatus).
*    result = VALUE #( FOR row IN TableForLcStatus
*                        ( %TKY   = row-%TKY
*                          %PARAM  = row ) ).
*    reported-TableForLcStatus = VALUE #( FOR key IN keys ( %CID = key-%CID_REF
*                                                   %TKY = key-%TKY
*                                                   %ACTION-Deprecate = if_abap_behv=>mk-on
*                                                   %ELEMENT-ConfigDeprecationCode = if_abap_behv=>mk-on
*                                                   %msg = mbc_cp_api=>message( )->get_item_deprecated( )
*                                                   %PATH-TableForLcStatusAll-%IS_DRAFT = key-%IS_DRAFT
*                                                   %PATH-TableForLcStatusAll-SingletonID = 1
*          ) ).
*  ENDMETHOD.
*  METHOD INVALIDATE.
*    MODIFY ENTITIES OF ZI_TableForLcStatus_S IN LOCAL MODE
*      ENTITY TableForLcStatus
*      UPDATE
*        FIELDS ( ConfigDeprecationCode ConfigDeprecationCode_Critlty )
*        WITH VALUE #( FOR key IN keys
*                       ( %TKY            = key-%TKY
*                         ConfigDeprecationCode            = 'E'
*                         ConfigDeprecationCode_Critlty = 1 ) ).
*    READ ENTITIES OF ZI_TableForLcStatus_S IN LOCAL MODE
*      ENTITY TableForLcStatus
*      ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(TableForLcStatus).
*    result = VALUE #( FOR row IN TableForLcStatus
*                        ( %TKY   = row-%TKY
*                          %PARAM  = row ) ).
*    reported-TableForLcStatus = VALUE #( FOR key IN keys ( %CID = key-%CID_REF
*                                                   %TKY = key-%TKY
*                                                   %ACTION-Invalidate = if_abap_behv=>mk-on
*                                                   %ELEMENT-ConfigDeprecationCode = if_abap_behv=>mk-on
*                                                   %msg = mbc_cp_api=>message( )->get_item_invalidated( )
*                                                   %PATH-TableForLcStatusAll-%IS_DRAFT = key-%IS_DRAFT
*                                                   %PATH-TableForLcStatusAll-SingletonID = 1
*          ) ).
*  ENDMETHOD.
*  METHOD GET_GLOBAL_AUTHORIZATIONS.
*    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_TABLEFORLCSTATUS' ID 'ACTVT' FIELD '02'.
*    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
*                                  ELSE if_abap_behv=>auth-unauthorized ).
*    result-%ACTION-Deprecate = is_authorized.
*    result-%ACTION-Invalidate = is_authorized.
*  ENDMETHOD.
*  METHOD GET_INSTANCE_FEATURES.
*    READ ENTITIES OF ZI_TableForLcStatus_S IN LOCAL MODE
*      ENTITY TableForLcStatus
*      FIELDS ( ConfigDeprecationCode ) WITH CORRESPONDING #( keys )
*      RESULT DATA(TableForLcStatus).
*    DATA keys_act LIKE keys.
*    LOOP AT keys INTO DATA(key) USING KEY draft WHERE %is_draft = if_abap_behv=>mk-on.
*      key-%is_draft = if_abap_behv=>mk-off.
*      INSERT key INTO TABLE keys_act.
*    ENDLOOP.
*    READ ENTITIES OF ZI_TableForLcStatus_S IN LOCAL MODE
*      ENTITY TableForLcStatus
*      FIELDS ( ConfigDeprecationCode ) WITH CORRESPONDING #( keys_act )
*      RESULT DATA(TableForLcStatus_act).
*    LOOP AT keys INTO key.
*      DATA(delete) = if_abap_behv=>fc-o-disabled.
*      DATA(deprecate) = if_abap_behv=>fc-o-disabled.
*      DATA(invalidate) = if_abap_behv=>fc-o-disabled.
*      IF key-%IS_DRAFT = if_abap_behv=>mk-on.
*        READ TABLE TableForLcStatus WITH KEY draft COMPONENTS %TKY = key-%TKY ASSIGNING FIELD-SYMBOL(<TableForLcStatus>).
*        IF <TableForLcStatus>-ConfigDeprecationCode = ''.
*          deprecate = if_abap_behv=>fc-o-enabled.
*          invalidate = if_abap_behv=>fc-o-enabled.
*        ELSEIF <TableForLcStatus>-ConfigDeprecationCode = 'W'.
*          invalidate = if_abap_behv=>fc-o-enabled.
*        ENDIF.
*        IF NOT line_exists( TableForLcStatus_act[ KEY entity COMPONENTS %KEY = key-%KEY ] ).
*          delete = if_abap_behv=>fc-o-enabled.
*        ENDIF.
*      ENDIF.
*      INSERT VALUE #( %TKY = key-%TKY
*                      %DELETE = delete
*                      %ACTION-deprecate = deprecate
*                      %ACTION-invalidate = invalidate ) INTO TABLE result.
*    ENDLOOP.
*  ENDMETHOD.
*  METHOD VALIDATETRANSPORTREQUEST.
*    DATA change TYPE REQUEST FOR CHANGE ZI_TableForLcStatus_S.
*    IF keys_TableForLcStatus IS NOT INITIAL.
*      DATA(is_draft) = keys_TableForLcStatus[ 1 ]-%IS_DRAFT.
*    ELSE.
*      RETURN.
*    ENDIF.
*    READ ENTITY IN LOCAL MODE ZI_TableForLcStatus_S
*    FROM VALUE #( ( %IS_DRAFT = is_draft
*                    SingletonID = 1
*                    %CONTROL-TransportRequestID = if_abap_behv=>mk-on ) )
*    RESULT FINAL(transport_from_singleton).
*    lhc_rap_tdat_cts=>get( )->validate_all_changes(
*                                transport_request     = VALUE #( transport_from_singleton[ 1 ]-TransportRequestID OPTIONAL )
*                                table_validation_keys = VALUE #(
*                                                          ( table = 'ZDT_LCSTATUSF4' keys = REF #( keys_TableForLcStatus ) )
*                                                               )
*                                reported              = REF #( reported )
*                                failed                = REF #( failed )
*                                change                = REF #( change ) ).
*  ENDMETHOD.
*ENDCLASS.
