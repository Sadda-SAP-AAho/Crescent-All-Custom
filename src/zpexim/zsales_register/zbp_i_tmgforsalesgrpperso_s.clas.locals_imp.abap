CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TDAT_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZTMGFORSALESGRPPERSON'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'TmgForSalesGrpPerso' table = 'ZTMG_SALESGRP' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_TMGFORSALESGRPPERSO_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR TmgForSalesGrpPeAll
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TmgForSalesGrpPeAll~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR TmgForSalesGrpPeAll
        RESULT result,
      EDIT FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TmgForSalesGrpPeAll~edit.
ENDCLASS.

CLASS LHC_ZI_TMGFORSALESGRPPERSO_S IMPLEMENTATION.
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
    result = VALUE #( FOR key in keys (
               %TKY = key-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_TmgForSalesGrpPerso = edit_flag
               %FIELD-TransportRequestID = transport_feature
               %ACTION-SelectCustomizingTransptReq = COND #( WHEN key-%IS_DRAFT = if_abap_behv=>mk-off
                                                             THEN if_abap_behv=>fc-o-disabled
                                                             ELSE selecttransport_flag ) ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF ZI_TmgForSalesGrpPerso_S IN LOCAL MODE
      ENTITY TmgForSalesGrpPeAll
        UPDATE FIELDS ( TransportRequestID )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                         ) ).

    READ ENTITIES OF ZI_TmgForSalesGrpPerso_S IN LOCAL MODE
      ENTITY TmgForSalesGrpPeAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_TMGFORSALESGRPPERSO' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
  METHOD EDIT.
    CHECK lhc_rap_tdat_cts=>get( )->is_transport_mandatory( ).
    DATA(transport_request) = lhc_rap_tdat_cts=>get( )->get_transport_request( ).
    IF transport_request IS NOT INITIAL.
      MODIFY ENTITY IN LOCAL MODE ZI_TmgForSalesGrpPerso_S
        EXECUTE SelectCustomizingTransptReq FROM VALUE #( ( %IS_DRAFT = if_abap_behv=>mk-on
                                                            SingletonID = 1
                                                            %PARAM-transportrequestid = transport_request ) ).
      reported-TmgForSalesGrpPeAll = VALUE #( ( %IS_DRAFT = if_abap_behv=>mk-on
                                     SingletonID = 1
                                     %MSG = mbc_cp_api=>message( )->get_transport_selected( transport_request ) ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_ZI_TMGFORSALESGRPPERSO_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION.
ENDCLASS.

CLASS LSC_ZI_TMGFORSALESGRPPERSO_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    DATA(transport_from_singleton) = VALUE #( update-TmgForSalesGrpPeAll[ 1 ]-TransportRequestID OPTIONAL ).
    IF transport_from_singleton IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = transport_from_singleton
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_TMGFORSALESGRPPERSO DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR TmgForSalesGrpPerso
        RESULT result,
      DEPRECATE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TmgForSalesGrpPerso~Deprecate
        RESULT result,
      INVALIDATE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TmgForSalesGrpPerso~Invalidate
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR TmgForSalesGrpPerso
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR TmgForSalesGrpPerso
        RESULT result,
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS_TMGFORSALESGRPPEALL FOR TmgForSalesGrpPeAll~ValidateTransportRequest
          KEYS_TMGFORSALESGRPPERSO FOR TmgForSalesGrpPerso~ValidateTransportRequest.
ENDCLASS.

CLASS LHC_ZI_TMGFORSALESGRPPERSO IMPLEMENTATION.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_op_ctrl VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
  ENDMETHOD.
  METHOD DEPRECATE.
    MODIFY ENTITIES OF ZI_TmgForSalesGrpPerso_S IN LOCAL MODE
      ENTITY TmgForSalesGrpPerso
      UPDATE
        FIELDS ( ConfigDeprecationCode ConfigDeprecationCode_Critlty )
        WITH VALUE #( FOR key IN keys
                       ( %TKY            = key-%TKY
                         ConfigDeprecationCode            = 'W'
                         ConfigDeprecationCode_Critlty = 2 ) ).
    READ ENTITIES OF ZI_TmgForSalesGrpPerso_S IN LOCAL MODE
      ENTITY TmgForSalesGrpPerso
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(TmgForSalesGrpPerso).
    result = VALUE #( FOR row IN TmgForSalesGrpPerso
                        ( %TKY   = row-%TKY
                          %PARAM  = row ) ).
    reported-TmgForSalesGrpPerso = VALUE #( FOR key IN keys ( %CID = key-%CID_REF
                                                   %TKY = key-%TKY
                                                   %ACTION-Deprecate = if_abap_behv=>mk-on
                                                   %ELEMENT-ConfigDeprecationCode = if_abap_behv=>mk-on
                                                   %msg = mbc_cp_api=>message( )->get_item_deprecated( )
                                                   %PATH-TmgForSalesGrpPeAll-%IS_DRAFT = key-%IS_DRAFT
                                                   %PATH-TmgForSalesGrpPeAll-SingletonID = 1
          ) ).
  ENDMETHOD.
  METHOD INVALIDATE.
    MODIFY ENTITIES OF ZI_TmgForSalesGrpPerso_S IN LOCAL MODE
      ENTITY TmgForSalesGrpPerso
      UPDATE
        FIELDS ( ConfigDeprecationCode ConfigDeprecationCode_Critlty )
        WITH VALUE #( FOR key IN keys
                       ( %TKY            = key-%TKY
                         ConfigDeprecationCode            = 'E'
                         ConfigDeprecationCode_Critlty = 1 ) ).
    READ ENTITIES OF ZI_TmgForSalesGrpPerso_S IN LOCAL MODE
      ENTITY TmgForSalesGrpPerso
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(TmgForSalesGrpPerso).
    result = VALUE #( FOR row IN TmgForSalesGrpPerso
                        ( %TKY   = row-%TKY
                          %PARAM  = row ) ).
    reported-TmgForSalesGrpPerso = VALUE #( FOR key IN keys ( %CID = key-%CID_REF
                                                   %TKY = key-%TKY
                                                   %ACTION-Invalidate = if_abap_behv=>mk-on
                                                   %ELEMENT-ConfigDeprecationCode = if_abap_behv=>mk-on
                                                   %msg = mbc_cp_api=>message( )->get_item_invalidated( )
                                                   %PATH-TmgForSalesGrpPeAll-%IS_DRAFT = key-%IS_DRAFT
                                                   %PATH-TmgForSalesGrpPeAll-SingletonID = 1
          ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_TMGFORSALESGRPPERSO' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-Deprecate = is_authorized.
    result-%ACTION-Invalidate = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    READ ENTITIES OF ZI_TmgForSalesGrpPerso_S IN LOCAL MODE
      ENTITY TmgForSalesGrpPerso
      FIELDS ( ConfigDeprecationCode ) WITH CORRESPONDING #( keys )
      RESULT DATA(TmgForSalesGrpPerso).
    DATA keys_act LIKE keys.
    LOOP AT keys INTO DATA(key) USING KEY draft WHERE %is_draft = if_abap_behv=>mk-on.
      key-%is_draft = if_abap_behv=>mk-off.
      INSERT key INTO TABLE keys_act.
    ENDLOOP.
    READ ENTITIES OF ZI_TmgForSalesGrpPerso_S IN LOCAL MODE
      ENTITY TmgForSalesGrpPerso
      FIELDS ( ConfigDeprecationCode ) WITH CORRESPONDING #( keys_act )
      RESULT DATA(TmgForSalesGrpPerso_act).
    LOOP AT keys INTO key.
      DATA(delete) = if_abap_behv=>fc-o-disabled.
      DATA(deprecate) = if_abap_behv=>fc-o-disabled.
      DATA(invalidate) = if_abap_behv=>fc-o-disabled.
      IF key-%IS_DRAFT = if_abap_behv=>mk-on.
        READ TABLE TmgForSalesGrpPerso WITH KEY draft COMPONENTS %TKY = key-%TKY ASSIGNING FIELD-SYMBOL(<TmgForSalesGrpPerso>).
        IF <TmgForSalesGrpPerso>-ConfigDeprecationCode = ''.
          deprecate = if_abap_behv=>fc-o-enabled.
          invalidate = if_abap_behv=>fc-o-enabled.
        ELSEIF <TmgForSalesGrpPerso>-ConfigDeprecationCode = 'W'.
          invalidate = if_abap_behv=>fc-o-enabled.
        ENDIF.
        IF NOT line_exists( TmgForSalesGrpPerso_act[ KEY entity COMPONENTS %KEY = key-%KEY ] ).
          delete = if_abap_behv=>fc-o-enabled.
        ENDIF.
      ENDIF.
      INSERT VALUE #( %TKY = key-%TKY
                      %DELETE = delete
                      %ACTION-deprecate = deprecate
                      %ACTION-invalidate = invalidate ) INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.
  METHOD VALIDATETRANSPORTREQUEST.
    CHECK keys_TmgForSalesGrpPerso IS NOT INITIAL.
    DATA change TYPE REQUEST FOR CHANGE ZI_TmgForSalesGrpPerso_S.
    READ ENTITY IN LOCAL MODE ZI_TmgForSalesGrpPerso_S
    FIELDS ( TransportRequestID ) WITH CORRESPONDING #( keys_TmgForSalesGrpPeAll )
    RESULT FINAL(transport_from_singleton).
    lhc_rap_tdat_cts=>get( )->validate_all_changes(
                                transport_request     = VALUE #( transport_from_singleton[ 1 ]-TransportRequestID OPTIONAL )
                                table_validation_keys = VALUE #(
                                                          ( table = 'ZTMG_SALESGRP' keys = REF #( keys_TmgForSalesGrpPerso ) )
                                                               )
                                reported              = REF #( reported )
                                failed                = REF #( failed )
                                change                = REF #( change ) ).
  ENDMETHOD.
ENDCLASS.
