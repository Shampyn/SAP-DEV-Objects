CLASS zyb_cl_virtual_field_preview DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zyb_cl_virtual_field_preview IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA lt_original_data TYPE STANDARD TABLE OF zyb_c_ddic_components WITH DEFAULT KEY.
    lt_original_data = CORRESPONDING #( it_original_data ).

    TRY.
        DATA(lv_tenant_url) = cl_abap_context_info=>get_system_url( ).

        DATA(lv_system_url) = |https://{ lv_tenant_url }:443|.

        LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_original_data>)
          WHERE abapobjectisdeleted = abap_false.

          CASE <fs_original_data>-abapobjecttype.
*              WHEN 'APLO'.
*                <fs_original_data>-description = xco_cp_abap_repository=>object->aplo->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_description(  ).
*              WHEN 'BDEF'.
*                <fs_original_data>-description = xco_cp_abap_repository=>object->bdef->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_short_description(  ).

            WHEN 'CLAS'.
              " /sap/bc/adt/oo/classes/zyb_cl_virtual_field_preview/source/main?version=active&sap-client=100#start=1,0
              DATA(lv_path) = |/sap/bc/adt/oo/classes/{ <fs_original_data>-abapobject }/source/main|.

*              WHEN 'DCLS'.
*                CONTINUE.

            WHEN 'DDLS'.
              lv_path = |/sap/bc/adt/ddic/ddl/sources/{ <fs_original_data>-abapobject }/source/main|.

*              WHEN 'DDLX'.
*                CONTINUE.
*              WHEN 'DEVC'.
*                CONTINUE.
*              WHEN 'DOMA'.
*                <fs_original_data>-description = xco_cp_abap_repository=>object->doma->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_short_description(  ).
*              WHEN 'DTEL'.
*                <fs_original_data>-description = xco_cp_abap_repository=>object->dtel->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_short_description(  ).
*              WHEN 'INTF'.
*                <fs_original_data>-description = xco_cp_abap_repository=>object->intf->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_short_description(  ).
*              WHEN 'MSAG'.
*                <fs_original_data>-description = xco_cp_abap_repository=>object->msag->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_short_description(  ).
*              WHEN 'SRVB'.
*                <fs_original_data>-description = xco_cp_abap_repository=>object->srvb->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_short_description(  ).
*              WHEN 'SRVD'.
*                <fs_original_data>-description = xco_cp_abap_repository=>object->srvd->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_short_description(  ).
*              WHEN 'STOB'.
*
            WHEN 'TABL'.

              DATA(lo_tbl) = xco_cp_abap_repository=>object->tabl->for( CONV #( <fs_original_data>-abapobject ) ).

              IF lo_tbl->is_database_table( ).
                " /sap/bc/adt/ddic/tables/zyb_d_object_txt/source/main?version=active&sap-client=100#start=1,0
                lv_path = |/sap/bc/adt/ddic/tables/{ <fs_original_data>-abapobject }/source/main|.
              ELSEIF lo_tbl->is_structure( ).
                " /sap/bc/adt/ddic/structures/zsorch_context_attr/source/main?version=active&sap-client=100#start=1,0
                lv_path = |/sap/bc/adt/ddic/structures/{ <fs_original_data>-abapobject }/source/main|.
              ENDIF.

*              WHEN 'TTYP'.
*                <fs_original_data>-description = xco_cp_abap_repository=>object->ttyp->for( iv_name = CONV #( <fs_original_data>-abapobject ) )->content(  )->get_short_description(  ).

            WHEN OTHERS.
              CONTINUE.

          ENDCASE.

          <fs_original_data>-previewlink = |javascript:window.open('{ lv_system_url }{ lv_path }?version=active&sap-client={ sy-mandt }#start=1,0','_blank')|.

        ENDLOOP.

      CATCH cx_abap_context_info_error.
        "handle exception
    ENDTRY.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    LOOP AT it_requested_calc_elements ASSIGNING FIELD-SYMBOL(<fs_calc_element>).
      CASE <fs_calc_element>.
        WHEN 'PREVIEWLINK'.
          APPEND 'ABAPOBJECT' TO et_requested_orig_elements.
          APPEND 'ABAPOBJECTISDELETED' TO et_requested_orig_elements.
          APPEND 'ABAPOBJECTTYPE' TO et_requested_orig_elements.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
