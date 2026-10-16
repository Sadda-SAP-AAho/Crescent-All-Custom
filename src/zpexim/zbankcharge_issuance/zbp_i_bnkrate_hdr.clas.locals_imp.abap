CLASS lhc_zi_bnkrate_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_bnkrate_hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_bnkrate_hdr RESULT result.

*    METHODS updatedata FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR zi_bnkrate_hdr~updatedata.

    METHODS checkbank FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_bnkrate_hdr~checkbank.

ENDCLASS.

CLASS lhc_zi_bnkrate_hdr IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD checkbank.

    DATA: lv_msg1 TYPE char200.

    READ ENTITIES OF zi_bnkrate_hdr IN LOCAL MODE
           ENTITY zi_bnkrate_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header1).


    DATA(gfs_header1) = VALUE #( header1[ 1 ]  OPTIONAL ).
    IF ( gfs_header1-housebnkid IS NOT INITIAL AND gfs_header1-bankname IS NOT INITIAL
        AND gfs_header1-accountid IS NOT INITIAL ).
      SELECT SINGLE * FROM zdt_bnkrate_hdr
      WHERE bankname = @gfs_header1-bankname AND housebnkid = @gfs_header1-housebnkid
      AND accountid = @gfs_header1-accountid
      INTO @DATA(ls_del2).
      IF ls_del2 IS NOT INITIAL.

        lv_msg1 = |Combination HouseBank & AccountId Already Exists|.
        APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_bnkrate_hdr.

        APPEND VALUE #( %tky        = gfs_header1-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_bnkrate_hdr.
      ENDIF.
    ENDIF.
    IF gfs_header1-bankname IS  INITIAL.
      DATA(lv_msg2) = |Bankname Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_bnkrate_hdr.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg2 ) )
      TO reported-zi_bnkrate_hdr.
    ENDIF.
    IF gfs_header1-housebnkid IS INITIAL.
      DATA(lv_msg3) = |HouseBank Id Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_bnkrate_hdr.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg3 ) )
      TO reported-zi_bnkrate_hdr.
    ENDIF.
  ENDMETHOD.




*  METHOD updatedata.
**    DATA : gs_item TYPE zdt_bnkexp_itm.
**    DATA : gs_item1 TYPE zdt_bnkimp_itm.
**    DATA : gs_item2 TYPE zdt_bnkbg_itm.
*
*    READ ENTITIES OF zi_bnkrate_hdr IN LOCAL MODE
*           ENTITY zi_bnkrate_hdr
*           ALL FIELDS
*           WITH CORRESPONDING #( keys )
*           RESULT FINAL(header).
*
*    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
*
*    READ ENTITY zi_bnkrate_hdr
*             BY \_item
*             ALL FIELDS
*             WITH CORRESPONDING #( keys )
*             RESULT DATA(item).
*
*    LOOP AT item ASSIGNING FIELD-SYMBOL(<lfs_item>).
*
*      MODIFY ENTITIES OF zi_bnkrate_hdr IN LOCAL MODE
*                     ENTITY zi_bnkrateexp
*                     UPDATE
*                     FIELDS ( waers )
*                     WITH VALUE #( FOR key IN keys
*                                   ( %tky       = <lfs_item>-%tky
*                                     waers      = gfs_header-waers
*                                     %control-waers   = if_abap_behv=>mk-on
*                                      ) ).
*    ENDLOOP.
*    READ ENTITY zi_bnkrate_hdr
*            BY \_item1
*            ALL FIELDS
*            WITH CORRESPONDING #( keys )
*            RESULT DATA(item1).
*
*    LOOP AT item1 ASSIGNING FIELD-SYMBOL(<lfs_item1>).
*
*      MODIFY ENTITIES OF zi_bnkrate_hdr IN LOCAL MODE
*                     ENTITY zi_bnkrateimp
*                     UPDATE
*                     FIELDS ( waers )
*                     WITH VALUE #( FOR key IN keys
*                                   ( %tky       = <lfs_item1>-%tky
*                                     waers      = gfs_header-waers
*                                     %control-waers   = if_abap_behv=>mk-on
*                                      ) ).
*    ENDLOOP.
*

*  SELECT * FROM zdt_bnkch_hdr
*  INTO TABLE @DATA(lt_docitm).
*
*  LOOP AT lt_docitm INTO DATA(ls_docitm).
*  if ls_docitm-category = 'EXPORT'.
*    gs_item-chargehead    = ls_docitm-bnkchargename.
*
* MODIFY ENTITIES OF zi_bnkrate_hdr IN LOCAL MODE
*   ENTITY zi_bnkrate_hdr
*   CREATE BY \_item
*   FROM VALUE #( ( id      = gfs_header-id
*                   %target = VALUE #( (     %cid                = gs_item-id && gs_item-chargehead
*
*                                            Chargehead          = gs_item-chargehead
*                                            %control-Chargehead   = if_abap_behv=>mk-on
*                                     ) ) ) )
*                   MAPPED FINAL(ls_mapped)
*                   FAILED FINAL(ls_failed)
*                   REPORTED FINAL(ls_reported).
*
*  elseif ls_docitm-category = 'IMPORT'.
*    gs_item1-chargehead1    = ls_docitm-bnkchargename.
*
*  MODIFY ENTITIES OF zi_bnkrate_hdr IN LOCAL MODE
*   ENTITY zi_bnkrate_hdr
*   CREATE BY \_item1
*   FROM VALUE #( ( id      = gfs_header-id
*                   %target = VALUE #( (     %cid                = gs_item1-id && gs_item1-chargehead1
*
*                                            Chargehead1         = gs_item1-chargehead1
*                                            %control-Chargehead1   = if_abap_behv=>mk-on
*                                     ) ) ) )
*                   MAPPED FINAL(ls_mapped1)
*                   FAILED FINAL(ls_failed1)
*                   REPORTED FINAL(ls_reported1).
*  elseif ls_docitm-category = 'BG'.
*    gs_item2-chargehead2    = ls_docitm-bnkchargename.
*    MODIFY ENTITIES OF zi_bnkrate_hdr IN LOCAL MODE
*   ENTITY zi_bnkrate_hdr
*   CREATE BY \_item2
*   FROM VALUE #( ( id      = gfs_header-id
*                   %target = VALUE #( (     %cid                = gs_item2-id && gs_item2-chargehead2
*
*                                            Chargehead2         = gs_item2-chargehead2
*                                            %control-Chargehead2   = if_abap_behv=>mk-on
*                                     ) ) ) )
*                   MAPPED FINAL(ls_mapped2)
*                   FAILED FINAL(ls_failed2)
*                   REPORTED FINAL(ls_reported2).
*  endif.
*
*
*
*  ENDLOOP.

*
*  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_bnkratebg DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_bnkratebg RESULT result.

    METHODS checkbgcharges FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_bnkratebg~checkbgcharges.
    METHODS updatebg FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_bnkratebg~updatebg.

ENDCLASS.

CLASS lhc_zi_bnkratebg IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_bnkrate_hdr IN LOCAL MODE
            ENTITY zi_bnkrate_hdr
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(header)
            " TODO: variable is assigned but never used (ABAP cleaner)
            FAILED FINAL(header_failed).

    IF header IS INITIAL.
      RETURN.
    ENDIF.

    FINAL(ls_head) = VALUE #( header[ 1 ] OPTIONAL ).
    READ ENTITIES OF zi_bnkrate_hdr IN LOCAL MODE
         ENTITY zi_bnkratebg
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(fg)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(fg_failed).

  ENDMETHOD.

  METHOD checkbgcharges.
    READ ENTITIES OF zi_bnkrate_hdr IN LOCAL MODE
          ENTITY zi_bnkrate_hdr
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header).

    READ ENTITY zi_bnkrate_hdr " IN LOCAL MODE
          BY \_item2
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(bnkbgitm1).


    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    LOOP AT bnkbgitm1 INTO DATA(gfs_bnkbgitm1) .
      DATA(lt_bnkitm) = bnkbgitm1[].
      IF gfs_bnkbgitm1-chargehead2 IS NOT INITIAL.
        DELETE lt_bnkitm WHERE chargehead2 <> gfs_bnkbgitm1-chargehead2 .
        IF  lines( lt_bnkitm ) > 1 .

          DATA(lv_msg1) = |Duplicate Entry For | &&  gfs_bnkbgitm1-chargehead2 && | For BG|.
          APPEND VALUE #( %tky = gfs_bnkbgitm1-%tky ) TO failed-zi_bnkrate_hdr.

          APPEND VALUE #( %tky        = gfs_bnkbgitm1-%tky
                          %state_area = 'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg1 ) )
          TO reported-zi_bnkrate_hdr.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD updatebg.

    READ ENTITIES OF zi_bnkrate_hdr IN LOCAL MODE
             ENTITY zi_bnkrate_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_bnkrate_hdr
             BY \_item2
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT DATA(item2).

    DATA(gfs_item2) = VALUE #( item2[ 1 ]  OPTIONAL ).

*    LOOP AT item2 ASSIGNING FIELD-SYMBOL(<lfs_item2>).

    MODIFY ENTITIES OF zi_bnkrate_hdr IN LOCAL MODE
                   ENTITY zi_bnkratebg
                   UPDATE
                   FIELDS ( waers )
                   WITH VALUE #( FOR key IN keys
                                 ( %tky       = gfs_item2-%tky
                                   waers      = gfs_header-waers
                                   %control-waers   = if_abap_behv=>mk-on
                                    ) ).
*    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_bnkrateexp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_bnkrateexp RESULT result.

    METHODS checkexpcharges FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_bnkrateexp~checkexpcharges.
    METHODS updateexp FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_bnkrateexp~updateexp.

ENDCLASS.

CLASS lhc_zi_bnkrateexp IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD checkexpcharges.
    READ ENTITIES OF zi_bnkrate_hdr IN LOCAL MODE
           ENTITY zi_bnkrate_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    READ ENTITY zi_bnkrate_hdr " IN LOCAL MODE
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(bnkexpitm1).


    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    LOOP AT bnkexpitm1 INTO DATA(gfs_bnkexpitm1) .
      DATA(lt_bnkitm) = bnkexpitm1[].
      IF gfs_bnkexpitm1-chargehead IS NOT INITIAL.
        DELETE lt_bnkitm WHERE chargehead <> gfs_bnkexpitm1-chargehead .
        IF  lines( lt_bnkitm ) > 1 .

          DATA(lv_msg1) = |Duplicate Entry For | &&  gfs_bnkexpitm1-chargehead && | For EXPORT|.
          APPEND VALUE #( %tky = gfs_bnkexpitm1-%tky ) TO failed-zi_bnkrate_hdr.

          APPEND VALUE #( %tky        = gfs_bnkexpitm1-%tky
                          %state_area = 'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg1 ) )
          TO reported-zi_bnkrate_hdr.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD updateexp.
    READ ENTITIES OF zi_bnkrate_hdr IN LOCAL MODE
             ENTITY zi_bnkrate_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_bnkrate_hdr
             BY \_item
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT DATA(item).

    DATA(gfs_item) = VALUE #( item[ 1 ]  OPTIONAL ).

*    LOOP AT item2 ASSIGNING FIELD-SYMBOL(<lfs_item2>).

    MODIFY ENTITIES OF zi_bnkrate_hdr IN LOCAL MODE
                   ENTITY zi_bnkrateexp
                   UPDATE
                   FIELDS ( waers )
                   WITH VALUE #( FOR key IN keys
                                 ( %tky       = gfs_item-%tky
                                   waers      = gfs_header-waers
                                   %control-waers   = if_abap_behv=>mk-on
                                    ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_bnkrateimp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_bnkrateimp RESULT result.

    METHODS checkimpcharges FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_bnkrateimp~checkimpcharges.
    METHODS updateimp FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_bnkrateimp~updateimp.

ENDCLASS.

CLASS lhc_zi_bnkrateimp IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD checkimpcharges.
    READ ENTITIES OF zi_bnkrate_hdr IN LOCAL MODE
           ENTITY zi_bnkrate_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    READ ENTITY zi_bnkrate_hdr " IN LOCAL MODE
          BY \_item1
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(bnkimpitm1).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    LOOP AT bnkimpitm1 INTO DATA(gfs_bnkimpitm1) .
      DATA(lt_bnkitm) = bnkimpitm1[].
      IF gfs_bnkimpitm1-chargehead1 IS NOT INITIAL.
        DELETE lt_bnkitm WHERE chargehead1 <> gfs_bnkimpitm1-chargehead1 .
        IF  lines( lt_bnkitm ) > 1 .

          DATA(lv_msg1) = |Duplicate Entry For | &&  gfs_bnkimpitm1-chargehead1 && | For IMPORT|.
          APPEND VALUE #( %tky = gfs_bnkimpitm1-%tky ) TO failed-zi_bnkrate_hdr.

          APPEND VALUE #( %tky        = gfs_bnkimpitm1-%tky
                          %state_area = 'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg1 ) )
          TO reported-zi_bnkrate_hdr.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD updateimp.
    READ ENTITIES OF zi_bnkrate_hdr IN LOCAL MODE
             ENTITY zi_bnkrate_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_bnkrate_hdr
             BY \_item1
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT DATA(item1).

    DATA(gfs_item1) = VALUE #( item1[ 1 ]  OPTIONAL ).

*    LOOP AT item2 ASSIGNING FIELD-SYMBOL(<lfs_item2>).

    MODIFY ENTITIES OF zi_bnkrate_hdr IN LOCAL MODE
                   ENTITY zi_bnkrateimp
                   UPDATE
                   FIELDS ( waers )
                   WITH VALUE #( FOR key IN keys
                                 ( %tky       = gfs_item1-%tky
                                   waers      = gfs_header-waers
                                   %control-waers   = if_abap_behv=>mk-on
                                    ) ).
  ENDMETHOD.

ENDCLASS.
