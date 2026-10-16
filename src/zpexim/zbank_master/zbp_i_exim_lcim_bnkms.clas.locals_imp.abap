 CLASS lhc_zi_exim_lcim_bnkms DEFINITION INHERITING FROM cl_abap_behavior_handler.
   PRIVATE SECTION.

     METHODS get_instance_features FOR INSTANCE FEATURES
       IMPORTING keys REQUEST requested_features FOR zi_exim_lcim_bnkms RESULT result.

     METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION IMPORTING REQUEST requested_authorizations FOR zi_exim_lcim_bnkms RESULT result.
     METHODS updatetotallmit FOR DETERMINE ON SAVE           IMPORTING keys FOR zi_exim_lcim_bnkms~updatetotallmit.
     METHODS validtotallimit FOR VALIDATE ON SAVE           IMPORTING keys FOR zi_exim_lcim_bnkms~validtotallimit.
     METHODS updatetotallmit1 FOR DETERMINE ON SAVE          IMPORTING keys FOR zi_exim_lcim_bnkms~updatetotallmit1.
     METHODS validtotallimit1 FOR VALIDATE ON SAVE          IMPORTING keys FOR zi_exim_lcim_bnkms~validtotallimit1.
     METHODS year FOR VALIDATE ON SAVE
       IMPORTING keys FOR zi_exim_lcim_bnkms~year.
     METHODS refresh FOR MODIFY
       IMPORTING keys FOR ACTION zi_exim_lcim_bnkms~refresh RESULT result.
     METHODS updatetotallmit2 FOR DETERMINE ON SAVE
       IMPORTING keys FOR zi_exim_lcim_bnkms~updatetotallmit2.
     METHODS updatetotallmit3 FOR DETERMINE ON MODIFY
       IMPORTING keys FOR zi_exim_lcim_bnkms~updatetotallmit3.

 ENDCLASS.


 CLASS lhc_zi_exim_lcim_bnkms IMPLEMENTATION.

   METHOD get_instance_features.
     READ ENTITIES OF zi_exim_lcim_bnkms IN LOCAL MODE
          ENTITY zi_exim_lcim_bnkms
          ALL FIELDS  WITH CORRESPONDING #( keys )
          RESULT FINAL(gt_header)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(gt_failed).

     result = VALUE #( FOR gs_header IN gt_header
                       ( %tky              = gs_header-%tky

                         %action-refresh   = if_abap_behv=>fc-o-enabled
                     ) ).

   ENDMETHOD.

   METHOD get_global_authorizations.
   ENDMETHOD.

   METHOD updatetotallmit.

     READ ENTITIES OF zi_exim_lcim_bnkms IN LOCAL MODE
          ENTITY zi_exim_lcim_bnkms
          FIELDS ( fundbasedlimit ) WITH CORRESPONDING #( keys )
          RESULT DATA(lcimset).

     LOOP AT lcimset ASSIGNING FIELD-SYMBOL(<lsset>).
       IF <lsset>-fundbasedlimit IS NOT INITIAL OR <lsset>-totalnonfundbased IS NOT INITIAL.
         <lsset>-totallimit = <lsset>-fundbasedlimit + <lsset>-totalnonfundbased.
         MODIFY ENTITIES OF zi_exim_lcim_bnkms IN LOCAL MODE ENTITY zi_exim_lcim_bnkms
                UPDATE FIELDS ( totallimit ) WITH VALUE #( ( %tky = <lsset>-%tky totallimit = <lsset>-totallimit ) ).
       ENDIF.

     ENDLOOP.
   ENDMETHOD.

   METHOD validtotallimit.

     DATA lv_n TYPE i.

     IF lv_n = 0.
       lv_n += 1.
     ENDIF.

     READ ENTITIES OF zi_exim_lcim_bnkms IN LOCAL MODE
          ENTITY zi_exim_lcim_bnkms
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lctotal).

     LOOP AT lctotal ASSIGNING FIELD-SYMBOL(<lstotal>).

       IF <lstotal>-totalnonfundbased <> (  <lstotal>-bclimit + <lstotal>-bglimit + <lstotal>-lclimit ).

         APPEND VALUE #( %tky = <lstotal>-%tky ) TO failed-zi_exim_lcim_bnkms.

         APPEND VALUE #( %tky = keys[ lv_n ]-%tky
                         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                       text     = 'Error in Non Fund Based Limit' ) )
                TO reported-zi_exim_lcim_bnkms.

       ENDIF.
       RETURN.
     ENDLOOP.

     lv_n += 1.

   ENDMETHOD.

   METHOD updatetotallmit1.

     READ ENTITIES OF zi_exim_lcim_bnkms IN LOCAL MODE
          ENTITY zi_exim_lcim_bnkms
          FIELDS ( fundbasedlimit ) WITH CORRESPONDING #( keys )
          RESULT DATA(lcimset2).

     LOOP AT lcimset2 ASSIGNING FIELD-SYMBOL(<lsset>).
       IF <lsset>-fundbasedlimit IS NOT INITIAL OR <lsset>-totalnonfundbased IS NOT INITIAL.
         <lsset>-totallimit = <lsset>-fundbasedlimit + <lsset>-totalnonfundbased.
         MODIFY ENTITIES OF zi_exim_lcim_bnkms IN LOCAL MODE ENTITY zi_exim_lcim_bnkms
                UPDATE FIELDS ( totallimit ) WITH VALUE #( ( %tky = <lsset>-%tky totallimit = <lsset>-totallimit ) ).
       ENDIF.

     ENDLOOP.

   ENDMETHOD.

   METHOD validtotallimit1.

     DATA lv_n TYPE i.

     IF lv_n = 0.
       lv_n += 1.
     ENDIF.

     READ ENTITIES OF zi_exim_lcim_bnkms IN LOCAL MODE
          ENTITY zi_exim_lcim_bnkms
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lctotal).

     LOOP AT lctotal ASSIGNING FIELD-SYMBOL(<lstotal>).

       IF <lstotal>-fundbasedlimit <> ( <lstotal>-packcredit + <lstotal>-wcdc + <lstotal>-fcnr + <lstotal>-cashc ).
         APPEND VALUE #( %tky = <lstotal>-%tky ) TO failed-zi_exim_lcim_bnkms.

         APPEND VALUE #( %tky = keys[ lv_n ]-%tky
                         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                       text     = 'Error in Fund Based Limit' ) )
                TO reported-zi_exim_lcim_bnkms.
         RETURN.

       ENDIF.

     ENDLOOP.

     lv_n += 1.

   ENDMETHOD.

   METHOD year.

     DATA lv_n TYPE i.

     IF lv_n = 0.
       lv_n += 1.
     ENDIF.

     READ ENTITIES OF zi_exim_lcim_bnkms IN LOCAL MODE
           ENTITY zi_exim_lcim_bnkms
           ALL FIELDS WITH CORRESPONDING #( keys )
           RESULT FINAL(ltyearbnkms).

     LOOP AT ltyearbnkms ASSIGNING FIELD-SYMBOL(<lsyearbnkms>).

       IF strlen( <lsyearbnkms>-gjahr ) <> 4.
         APPEND VALUE #( %tky = <lsyearbnkms>-%tky ) TO failed-zi_exim_lcim_bnkms.

         APPEND VALUE #( %tky = keys[ lv_n ]-%tky
                         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                       text     = 'Error in Year' ) )
                TO reported-zi_exim_lcim_bnkms.
         RETURN.

       ENDIF.

     ENDLOOP.

     lv_n += 1.

   ENDMETHOD.

   METHOD refresh.

     "Read changed data for action result
     READ ENTITIES OF zi_exim_lcim_bnkms IN LOCAL MODE
       ENTITY zi_exim_lcim_bnkms
       ALL FIELDS WITH
       CORRESPONDING #( keys )
       RESULT DATA(lt_header).
     IF lt_header IS NOT INITIAL.
       DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
       IF ls_header IS NOT INITIAL.

         SELECT SINGLE *
             FROM zr_bank_limit
             WHERE bukrs = @ls_header-bukrs
               AND hktid = @ls_header-hktid
               AND hbkid = @ls_header-hbkid
               INTO @DATA(ls_banklimit).
         IF ls_banklimit IS NOT INITIAL.

           MODIFY ENTITIES OF zi_exim_lcim_bnkms IN LOCAL MODE
                  ENTITY zi_exim_lcim_bnkms
                  UPDATE FIELDS ( bgutilised bgavailable ref )
                  WITH VALUE #( ( %tky = ls_header-%tky

                                  ref = 'X'
                                  bgutilised = ls_banklimit-bgutilised
                                  bgavailable = ls_header-bglimit - ls_banklimit-bgutilised

                                  %control-bgutilised   = if_abap_behv=>mk-on
                                  %control-ref          = if_abap_behv=>mk-on
                                  %control-bgavailable  = if_abap_behv=>mk-on
                                  ) ).

         ENDIF.

         SELECT * FROM zr_bank_fund_limit_1 INTO TABLE @DATA(lt_fundutilise).

         ls_header-cashcutilised = VALUE #( lt_fundutilise[ bukrs = ls_header-bukrs
                                                          hbkid = ls_header-hbkid
                                                          hktid = ls_header-hktid
                                                          loantype = 'CASHC'
                                                         ]-amountincompanycodecurrency OPTIONAL ).
         ls_header-fcnrutilised = VALUE #( lt_fundutilise[ bukrs = ls_header-bukrs
                                                          hbkid = ls_header-hbkid
                                                          hktid = ls_header-hktid
                                                          loantype = 'FCNR'
                                                         ]-amountincompanycodecurrency OPTIONAL ).
         ls_header-wcdcutilised = VALUE #( lt_fundutilise[ bukrs = ls_header-bukrs
                                                          hbkid = ls_header-hbkid
                                                          hktid = ls_header-hktid
                                                          loantype = 'WCDL'
                                                         ]-amountincompanycodecurrency OPTIONAL ).
         ls_header-packcreditutilised = VALUE #( lt_fundutilise[ bukrs = ls_header-bukrs
                                                          hbkid = ls_header-hbkid
                                                          hktid = ls_header-hktid
                                                          loantype = 'PCR'
                                                         ]-amountincompanycodecurrency OPTIONAL ).

         MODIFY ENTITIES OF zi_exim_lcim_bnkms
            IN LOCAL MODE ENTITY zi_exim_lcim_bnkms
              UPDATE FIELDS ( cashcutilised fcnrutilised wcdcutilised packcreditutilised )
              WITH VALUE #( ( %tky                 = ls_header-%tky
                               cashcutilised       = ls_header-cashcutilised
                               fcnrutilised        = ls_header-fcnrutilised
                               wcdcutilised        = ls_header-wcdcutilised
                               packcreditutilised  = ls_header-packcreditutilised
                          ) ).
       ENDIF.
     ENDIF.

     "Read changed data for action result
     READ ENTITIES OF zi_exim_lcim_bnkms IN LOCAL MODE
          ENTITY zi_exim_lcim_bnkms
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header_result).

     result = VALUE #( FOR ls_header_result IN header_result
                       ( %tky   = ls_header_result-%tky
                         %param = ls_header_result ) ).

   ENDMETHOD.

   METHOD updatetotallmit2.

     READ ENTITIES OF zi_exim_lcim_bnkms IN LOCAL MODE
       ENTITY zi_exim_lcim_bnkms
       ALL FIELDS WITH
       CORRESPONDING #( keys )
       RESULT DATA(lt_header).
     IF lt_header IS NOT INITIAL.
       DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
       IF ls_header IS NOT INITIAL.

         SELECT SINGLE *
             FROM zr_bank_limit
             WHERE bukrs = @ls_header-bukrs
               AND hktid = @ls_header-hktid
               AND hbkid = @ls_header-hbkid
               INTO @DATA(ls_banklimit).
         IF ls_banklimit IS NOT INITIAL.

           MODIFY ENTITIES OF zi_exim_lcim_bnkms IN LOCAL MODE
                  ENTITY zi_exim_lcim_bnkms
                  UPDATE FIELDS ( bgutilised bgavailable )
                  WITH VALUE #( ( %tky = ls_header-%tky

                                  bgutilised = ls_banklimit-bgutilised
                                  bgavailable = ls_header-bglimit - ls_banklimit-bgutilised

                                  %control-bgutilised  = if_abap_behv=>mk-on
                                  %control-bgavailable  = if_abap_behv=>mk-on
                                  ) ).

         ENDIF.
       ENDIF.
     ENDIF.

   ENDMETHOD.

   METHOD updatetotallmit3.

     READ ENTITIES OF zi_exim_lcim_bnkms IN LOCAL MODE
          ENTITY zi_exim_lcim_bnkms
          FIELDS ( fundbasedlimit ) WITH CORRESPONDING #( keys )
          RESULT DATA(lcimset3).

     SELECT * FROM zr_bank_fund_limit_1 INTO TABLE @DATA(lt_fundutilise).


     LOOP AT lcimset3 ASSIGNING FIELD-SYMBOL(<lsset>).
       READ TABLE lt_fundutilise INTO DATA(ls_fundutilise)
                                  WITH KEY bukrs = <lsset>-bukrs
                                           hbkid = <lsset>-hbkid
                                           hktid = <lsset>-hktid.
       IF sy-subrc EQ 0.
         <lsset>-cashcutilised = VALUE #( lt_fundutilise[ bukrs = <lsset>-bukrs
                                                          hbkid = <lsset>-hbkid
                                                          hktid = <lsset>-hktid
                                                          loantype = 'CASHC'
                                                         ]-amountincompanycodecurrency OPTIONAL ).
         <lsset>-fcnrutilised = VALUE #( lt_fundutilise[ bukrs = <lsset>-bukrs
                                                          hbkid = <lsset>-hbkid
                                                          hktid = <lsset>-hktid
                                                          loantype = 'FCNR'
                                                         ]-amountincompanycodecurrency OPTIONAL ).
         <lsset>-wcdcutilised = VALUE #( lt_fundutilise[ bukrs = <lsset>-bukrs
                                                          hbkid = <lsset>-hbkid
                                                          hktid = <lsset>-hktid
                                                          loantype = 'WCDL'
                                                         ]-amountincompanycodecurrency OPTIONAL ).
         <lsset>-packcreditutilised = VALUE #( lt_fundutilise[ bukrs = <lsset>-bukrs
                                                          hbkid = <lsset>-hbkid
                                                          hktid = <lsset>-hktid
                                                          loantype = 'PCR'
                                                         ]-amountincompanycodecurrency OPTIONAL ).

         MODIFY ENTITIES OF zi_exim_lcim_bnkms
            IN LOCAL MODE ENTITY zi_exim_lcim_bnkms
              UPDATE FIELDS ( cashcutilised fcnrutilised wcdcutilised packcreditutilised )
              WITH VALUE #( ( %tky                 = <lsset>-%tky
                               cashcutilised       = <lsset>-cashcutilised
                               fcnrutilised        = <lsset>-fcnrutilised
                               wcdcutilised        = <lsset>-wcdcutilised
                               packcreditutilised  = <lsset>-packcreditutilised
                          ) ).
       ENDIF.

     ENDLOOP.

   ENDMETHOD.

 ENDCLASS.
