CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TDAT_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZTABLEFORPSAINDICATO'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'TableForPsaIndicato' table = 'ZDT_PSA_INDC' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_TABLEFORPSAINDICATO_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR TableForPsaIndicAll
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TableForPsaIndicAll~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR TableForPsaIndicAll
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_TABLEFORPSAINDICATO_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled,
          edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    READ ENTITIES OF ZI_TableForPsaIndicato_S IN LOCAL MODE
    ENTITY TableForPsaIndicAll
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(all).
    IF all[ 1 ]-%IS_DRAFT = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %TKY = all[ 1 ]-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_TableForPsaIndicato = edit_flag
               %ACTION-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF ZI_TableForPsaIndicato_S IN LOCAL MODE
      ENTITY TableForPsaIndicAll
        UPDATE FIELDS ( TransportRequestID HideTransport )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                          HideTransport      = abap_false ) ).

    READ ENTITIES OF ZI_TableForPsaIndicato_S IN LOCAL MODE
      ENTITY TableForPsaIndicAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_TABLEFORPSAINDICATO' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_ZI_TABLEFORPSAINDICATO_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION,
      CLEANUP_FINALIZE REDEFINITION.
ENDCLASS.

CLASS LSC_ZI_TABLEFORPSAINDICATO_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    READ TABLE update-TableForPsaIndicAll INDEX 1 INTO DATA(all).
    IF all-TransportRequestID IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = all-TransportRequestID
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.
  METHOD CLEANUP_FINALIZE ##NEEDED.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_TABLEFORPSAINDICATO DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATEDATACONSISTENCY FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR TableForPsaIndicato~ValidateDataConsistency,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR TableForPsaIndicato
        RESULT result,
      DEPRECATE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TableForPsaIndicato~Deprecate
        RESULT result,
      INVALIDATE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TableForPsaIndicato~Invalidate
        RESULT result,
      COPYTABLEFORPSAINDICATO FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TableForPsaIndicato~CopyTableForPsaIndicato,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR TableForPsaIndicato
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR TableForPsaIndicato
        RESULT result,
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS_TABLEFORPSAINDICATO FOR TableForPsaIndicato~ValidateTransportRequest.
ENDCLASS.

CLASS LHC_ZI_TABLEFORPSAINDICATO IMPLEMENTATION.
  METHOD VALIDATEDATACONSISTENCY.
    READ ENTITIES OF ZI_TableForPsaIndicato_S IN LOCAL MODE
      ENTITY TableForPsaIndicato
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(TableForPsaIndicato).
    DATA(table) = xco_cp_abap_repository=>object->tabl->database_table->for( 'ZDT_PSA_INDC' ).
    DATA: BEGIN OF element_check,
            element  TYPE string,
            check    TYPE REF TO if_xco_dp_check,
          END OF element_check,
          element_checks LIKE TABLE OF element_check WITH EMPTY KEY.
    LOOP AT TableForPsaIndicato ASSIGNING FIELD-SYMBOL(<TableForPsaIndicato>).
      element_checks = VALUE #(
        ( element = 'ConfigDeprecationCode' check = table->field( 'CONFIGDEPRECATIONCODE' )->get_value_check( ia_value = <TableForPsaIndicato>-ConfigDeprecationCode  ) )
      ).
      LOOP AT element_checks INTO element_check.
        INSERT VALUE #( %TKY        = <TableForPsaIndicato>-%TKY
                        %STATE_AREA = |TableForPsaIndicato_{ element_check-element }| ) INTO TABLE reported-TableForPsaIndicato.
        element_check-check->execute( ).
        CHECK element_check-check->passed = xco_cp=>boolean->false.
        INSERT VALUE #( %TKY        = <TableForPsaIndicato>-%TKY ) INTO TABLE failed-TableForPsaIndicato.
        LOOP AT element_check-check->messages ASSIGNING FIELD-SYMBOL(<msg>).
          INSERT VALUE #( %TKY = <TableForPsaIndicato>-%TKY
                          %STATE_AREA = |TableForPsaIndicato_{ element_check-element }|
                          %PATH-TableForPsaIndicAll-SingletonID = 1
                          %PATH-TableForPsaIndicAll-%IS_DRAFT = <TableForPsaIndicato>-%IS_DRAFT
                          %msg = mbc_cp_api=>message( )->get_behv_msg_from_value_check( <msg> ) ) INTO TABLE reported-TableForPsaIndicato ASSIGNING FIELD-SYMBOL(<rep>).
          ASSIGN COMPONENT element_check-element OF STRUCTURE <rep>-%ELEMENT TO FIELD-SYMBOL(<comp>).
          <comp> = if_abap_behv=>mk-on.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
  ENDMETHOD.
  METHOD DEPRECATE.
    MODIFY ENTITIES OF ZI_TableForPsaIndicato_S IN LOCAL MODE
      ENTITY TableForPsaIndicato
      UPDATE
        FIELDS ( ConfigDeprecationCode ConfigDeprecationCode_Critlty )
        WITH VALUE #( FOR key IN keys
                       ( %TKY            = key-%TKY
                         ConfigDeprecationCode            = 'W'
                         ConfigDeprecationCode_Critlty = 2 ) ).
    READ ENTITIES OF ZI_TableForPsaIndicato_S IN LOCAL MODE
      ENTITY TableForPsaIndicato
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(TableForPsaIndicato).
    result = VALUE #( FOR row IN TableForPsaIndicato
                        ( %TKY   = row-%TKY
                          %PARAM  = row ) ).
    reported-TableForPsaIndicato = VALUE #( FOR key IN keys ( %CID = key-%CID_REF
                                                   %TKY = key-%TKY
                                                   %ACTION-Deprecate = if_abap_behv=>mk-on
                                                   %ELEMENT-ConfigDeprecationCode = if_abap_behv=>mk-on
                                                   %msg = mbc_cp_api=>message( )->get_item_deprecated( )
                                                   %PATH-TableForPsaIndicAll-%IS_DRAFT = key-%IS_DRAFT
                                                   %PATH-TableForPsaIndicAll-SingletonID = 1
          ) ).
  ENDMETHOD.
  METHOD INVALIDATE.
    MODIFY ENTITIES OF ZI_TableForPsaIndicato_S IN LOCAL MODE
      ENTITY TableForPsaIndicato
      UPDATE
        FIELDS ( ConfigDeprecationCode ConfigDeprecationCode_Critlty )
        WITH VALUE #( FOR key IN keys
                       ( %TKY            = key-%TKY
                         ConfigDeprecationCode            = 'E'
                         ConfigDeprecationCode_Critlty = 1 ) ).
    READ ENTITIES OF ZI_TableForPsaIndicato_S IN LOCAL MODE
      ENTITY TableForPsaIndicato
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(TableForPsaIndicato).
    result = VALUE #( FOR row IN TableForPsaIndicato
                        ( %TKY   = row-%TKY
                          %PARAM  = row ) ).
    reported-TableForPsaIndicato = VALUE #( FOR key IN keys ( %CID = key-%CID_REF
                                                   %TKY = key-%TKY
                                                   %ACTION-Invalidate = if_abap_behv=>mk-on
                                                   %ELEMENT-ConfigDeprecationCode = if_abap_behv=>mk-on
                                                   %msg = mbc_cp_api=>message( )->get_item_invalidated( )
                                                   %PATH-TableForPsaIndicAll-%IS_DRAFT = key-%IS_DRAFT
                                                   %PATH-TableForPsaIndicAll-SingletonID = 1
          ) ).
  ENDMETHOD.
  METHOD COPYTABLEFORPSAINDICATO.
    DATA new_TableForPsaIndicato TYPE TABLE FOR CREATE ZI_TableForPsaIndicato_S\_TableForPsaIndicato.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-TableForPsaIndicato = VALUE #( FOR fkey IN keys ( %TKY = fkey-%TKY ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF ZI_TableForPsaIndicato_S IN LOCAL MODE
      ENTITY TableForPsaIndicato
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(ref_TableForPsaIndicato)
        FAILED DATA(read_failed).

    IF ref_TableForPsaIndicato IS NOT INITIAL.
      ASSIGN ref_TableForPsaIndicato[ 1 ] TO FIELD-SYMBOL(<ref_TableForPsaIndicato>).
      DATA(key) = keys[ KEY draft %TKY = <ref_TableForPsaIndicato>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_TableForPsaIndicato>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_TableForPsaIndicato>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_TableForPsaIndicato> EXCEPT
          SingletonID
          ConfigDeprecationCode
          LastChangedAt
          LocalLastChangedAt
        ) ) )
      ) TO new_TableForPsaIndicato ASSIGNING FIELD-SYMBOL(<new_TableForPsaIndicato>).
      <new_TableForPsaIndicato>-%TARGET[ 1 ]-PsaIndc = key-%PARAM-PsaIndc.

      MODIFY ENTITIES OF ZI_TableForPsaIndicato_S IN LOCAL MODE
        ENTITY TableForPsaIndicAll CREATE BY \_TableForPsaIndicato
        FIELDS (
                 PsaIndc
                 PsaDesc
               ) WITH new_TableForPsaIndicato
        MAPPED DATA(mapped_create)
        FAILED failed
        REPORTED reported.

      mapped-TableForPsaIndicato = mapped_create-TableForPsaIndicato.
    ENDIF.

    INSERT LINES OF read_failed-TableForPsaIndicato INTO TABLE failed-TableForPsaIndicato.

    IF failed-TableForPsaIndicato IS INITIAL.
      reported-TableForPsaIndicato = VALUE #( FOR created IN mapped-TableForPsaIndicato (
                                                 %CID = created-%CID
                                                 %ACTION-CopyTableForPsaIndicato = if_abap_behv=>mk-on
                                                 %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                                 %PATH-TableForPsaIndicAll-%IS_DRAFT = created-%IS_DRAFT
                                                 %PATH-TableForPsaIndicAll-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_TABLEFORPSAINDICATO' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-Deprecate = is_authorized.
    result-%ACTION-Invalidate = is_authorized.
    result-%ACTION-CopyTableForPsaIndicato = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    READ ENTITIES OF ZI_TableForPsaIndicato_S IN LOCAL MODE
      ENTITY TableForPsaIndicato
      FIELDS ( ConfigDeprecationCode ) WITH CORRESPONDING #( keys )
      RESULT DATA(TableForPsaIndicato).
    DATA keys_act LIKE keys.
    LOOP AT keys INTO DATA(key) USING KEY draft WHERE %is_draft = if_abap_behv=>mk-on.
      key-%is_draft = if_abap_behv=>mk-off.
      INSERT key INTO TABLE keys_act.
    ENDLOOP.
    READ ENTITIES OF ZI_TableForPsaIndicato_S IN LOCAL MODE
      ENTITY TableForPsaIndicato
      FIELDS ( ConfigDeprecationCode ) WITH CORRESPONDING #( keys_act )
      RESULT DATA(TableForPsaIndicato_act).
    LOOP AT keys INTO key.
      DATA(delete) = if_abap_behv=>fc-o-disabled.
      DATA(deprecate) = if_abap_behv=>fc-o-disabled.
      DATA(invalidate) = if_abap_behv=>fc-o-disabled.
      DATA(copy) = if_abap_behv=>fc-o-disabled.
      IF key-%IS_DRAFT = if_abap_behv=>mk-on.
        copy = if_abap_behv=>fc-o-enabled.
        READ TABLE TableForPsaIndicato WITH KEY draft COMPONENTS %TKY = key-%TKY ASSIGNING FIELD-SYMBOL(<TableForPsaIndicato>).
        IF <TableForPsaIndicato>-ConfigDeprecationCode = ''.
          deprecate = if_abap_behv=>fc-o-enabled.
          invalidate = if_abap_behv=>fc-o-enabled.
        ELSEIF <TableForPsaIndicato>-ConfigDeprecationCode = 'W'.
          invalidate = if_abap_behv=>fc-o-enabled.
        ENDIF.
        IF NOT line_exists( TableForPsaIndicato_act[ KEY entity COMPONENTS %KEY = key-%KEY ] ).
          delete = if_abap_behv=>fc-o-enabled.
        ENDIF.
      ENDIF.
      INSERT VALUE #( %TKY = key-%TKY
                      %DELETE = delete
                      %ACTION-CopyTableForPsaIndicato = copy
                      %ACTION-deprecate = deprecate
                      %ACTION-invalidate = invalidate ) INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE ZI_TableForPsaIndicato_S.
    IF keys_TableForPsaIndicato IS NOT INITIAL.
      DATA(is_draft) = keys_TableForPsaIndicato[ 1 ]-%IS_DRAFT.
    ELSE.
      RETURN.
    ENDIF.
    READ ENTITY IN LOCAL MODE ZI_TableForPsaIndicato_S
    FROM VALUE #( ( %IS_DRAFT = is_draft
                    SingletonID = 1
                    %CONTROL-TransportRequestID = if_abap_behv=>mk-on ) )
    RESULT FINAL(transport_from_singleton).
    IF lines( transport_from_singleton ) = 1.
      DATA(transport_request) = transport_from_singleton[ 1 ]-TransportRequestID.
    ENDIF.
    lhc_rap_tdat_cts=>get( )->validate_all_changes(
                                transport_request     = transport_request
                                table_validation_keys = VALUE #(
                                                          ( table = 'ZDT_PSA_INDC' keys = REF #( keys_TableForPsaIndicato ) )
                                                               )
                                reported              = REF #( reported )
                                failed                = REF #( failed )
                                change                = REF #( change ) ).
  ENDMETHOD.
ENDCLASS.
