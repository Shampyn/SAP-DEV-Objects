CLASS zyb_cl_virtual DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zyb_cl_virtual IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA lt_original_data TYPE STANDARD TABLE OF zyb_c_ddic_components WITH DEFAULT KEY.
    lt_original_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_original_data>).
      IF <fs_original_data>-abapobjectisdeleted <> abap_true.
        TRY.
            CASE <fs_original_data>-abapobjecttype.
              WHEN 'APLO'.
                <fs_original_data>-description = xco_cp_abap_repository=>object->aplo->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_description(  ).
              WHEN 'BDEF'.
                <fs_original_data>-description = xco_cp_abap_repository=>object->bdef->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_short_description(  ).
              WHEN 'CLAS'.
                <fs_original_data>-description = xco_cp_abap_repository=>object->clas->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_short_description(  ).
              WHEN 'DCLS'.
                CONTINUE.
              WHEN 'DDLS'.
                DATA(lo_view) = xco_cp_abap_repository=>object->ddls->for( CONV #( <fs_original_data>-abapobject ) )->view( CONV #( CONV #( <fs_original_data>-abapobject ) ) ).
                <fs_original_data>-description = lo_view->content( )->get_short_description( ).
              WHEN 'DDLX'.
                CONTINUE.
              WHEN 'DEVC'.
                CONTINUE.
              WHEN 'DOMA'.
                <fs_original_data>-description = xco_cp_abap_repository=>object->doma->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_short_description(  ).
              WHEN 'DTEL'.
                <fs_original_data>-description = xco_cp_abap_repository=>object->dtel->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_short_description(  ).
              WHEN 'INTF'.
                <fs_original_data>-description = xco_cp_abap_repository=>object->intf->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_short_description(  ).
              WHEN 'MSAG'.
                <fs_original_data>-description = xco_cp_abap_repository=>object->msag->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_short_description(  ).
              WHEN 'SRVB'.
                <fs_original_data>-description = xco_cp_abap_repository=>object->srvb->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_short_description(  ).
              WHEN 'SRVD'.
                <fs_original_data>-description = xco_cp_abap_repository=>object->srvd->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_short_description(  ).
              WHEN 'STOB'.
                CONTINUE.
              WHEN 'TABL'.

                DATA(lo_tbl) = xco_cp_abap_repository=>object->tabl->for( CONV #( <fs_original_data>-abapobject ) ).

                IF lo_tbl->is_database_table( ).
                  <fs_original_data>-description = lo_tbl->get_database_table(  )->content(  )->get_short_description( ).
                ELSEIF lo_tbl->is_structure( ).
                  <fs_original_data>-description = lo_tbl->get_structure(  )->content(  )->get_short_description( ).
                ENDIF.

              WHEN 'TTYP'.
                <fs_original_data>-description = xco_cp_abap_repository=>object->ttyp->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_short_description(  ).

            ENDCASE.
          CATCH cx_xco_runtime_exception INTO DATA(lr_error). "cx_xco_dep_fm_call_exception
        ENDTRY.
      ENDIF.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    LOOP AT it_requested_calc_elements ASSIGNING FIELD-SYMBOL(<fs_calc_element>).
      CASE <fs_calc_element>.
        WHEN 'DESCRIPTION'.
          APPEND 'ABAPOBJECT' TO et_requested_orig_elements.
          APPEND 'ABAPOBJECTISDELETED' TO et_requested_orig_elements.
          APPEND 'ABAPOBJECTTYPE' TO et_requested_orig_elements.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
