CLASS zyb_cl_ddls_custom DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zyb_cl_ddls_custom IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    DATA: ls_ddls TYPE zyb_ddls_custom,
          lt_ddls TYPE TABLE OF zyb_ddls_custom.

    IF io_request->is_data_requested( ).

      DATA(lt_range_table) = io_request->get_filter( )->get_as_ranges(  ).

      DATA(range) = lt_range_table[ name = 'DATADEFINITION' ]-range.

      SELECT abapobject
      FROM i_custabapobjdirectoryentry
      WHERE abapobjecttype = 'DDLS'
      AND abapobjectisdeleted <>'X'
      AND abapobject IN @range
      INTO TABLE @DATA(lt_ddls_object).

      LOOP AT lt_ddls_object ASSIGNING FIELD-SYMBOL(<lfs_ddls_object>).

        ls_ddls-datadefinition = <lfs_ddls_object>-abapobject.
        DATA(lo_domain) = xco_cp_abap_repository=>object->ddls->for( CONV #( <lfs_ddls_object>-abapobject ) ).

        LOOP AT lo_domain->view( )->fields->all->get(  ) ASSIGNING FIELD-SYMBOL(<lsf_field>).

          ls_ddls-iskeyfield = <lsf_field>->content(  )->get_key_indicator(  ).
          ls_ddls-aliasname = <lsf_field>->content(  )->get_alias( ).
          ls_ddls-fieldname = <lsf_field>->name.
          APPEND ls_ddls TO lt_ddls.
        ENDLOOP.

      ENDLOOP.


      DATA(lv_offset) = io_request->get_paging( )->get_offset( ).
      DATA(lv_page_size) = io_request->get_paging( )->get_page_size( ).
      DATA(lv_max_rows) = COND #( WHEN lv_page_size = if_rap_query_paging=>page_size_unlimited THEN 0
                                  ELSE lv_page_size ).

      DATA(sort_elements) = io_request->get_sort_elements( ).
      DATA(lt_sort_criteria) = VALUE string_table( FOR sort_element IN sort_elements
                                                 ( sort_element-element_name && COND #( WHEN sort_element-descending = abap_true
                                                                                        THEN ` descending`
                                                                                        ELSE ` ascending` ) ) ).
      DATA(lv_sort_string)  = COND #( WHEN lt_sort_criteria IS INITIAL
                                      THEN 'Fieldname'
                                      ELSE concat_lines_of( table = lt_sort_criteria sep = `, ` ) ).

      DATA(lt_req_elements) = io_request->get_requested_elements( ).
      DATA(lv_req_elements)  = concat_lines_of( table = lt_req_elements sep = `, ` ).


      DATA lt_ddls_response TYPE STANDARD TABLE OF zyb_ddls_custom.

      SELECT (lv_req_elements) FROM @lt_ddls AS ddls
               ORDER BY (lv_sort_string)
               INTO CORRESPONDING FIELDS OF TABLE @lt_ddls_response
               OFFSET @lv_offset UP TO @lv_max_rows ROWS.

      io_response->set_data( lt_ddls_response ).
    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).

      SELECT COUNT( * ) FROM @lt_ddls AS response
                        INTO @DATA(lv_ddls_count).

      io_response->set_total_number_of_records( lv_ddls_count ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
