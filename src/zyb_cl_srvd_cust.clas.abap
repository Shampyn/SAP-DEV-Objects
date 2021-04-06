CLASS zyb_cl_srvd_cust DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zyb_cl_srvd_cust IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    DATA: ls_srvd TYPE zyb_srvd_cust,
          lt_srvd TYPE TABLE OF zyb_srvd_cust.

    IF io_request->is_data_requested( ).


      DATA(lt_range_table) = io_request->get_filter( )->get_as_ranges(  ).

      DATA(range) = lt_range_table[ name = 'SERVICEDEFINITION' ]-range.

      SELECT abapobject
      FROM i_custabapobjdirectoryentry
      WHERE abapobjecttype = 'SRVD'
      AND abapobjectisdeleted <>'X'
      AND abapobject IN @range
      INTO TABLE @DATA(lt_srvd_object).

      LOOP AT lt_srvd_object ASSIGNING FIELD-SYMBOL(<lfs_srvd_object>).

        ls_srvd-ServiceDefinition = <lfs_srvd_object>-abapobject.
        DATA(lo_service_definition) = xco_cp_abap_repository=>object->srvd->for( CONV #( <lfs_srvd_object>-abapobject ) ).
        DATA(lt_entity) =  lo_service_definition->exposures->all->get(  ).

        LOOP AT lt_entity ASSIGNING FIELD-SYMBOL(<lfs_entity>).
          DATA(ls_entity) = <lfs_entity>->content(  )->get(  ).
          ls_srvd-AliasName = ls_entity-alias.
          ls_srvd-entity = ls_entity-cds_entity->name.

          APPEND ls_srvd TO lt_srvd.
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
                                      THEN 'ENTITY'
                                      ELSE concat_lines_of( table = lt_sort_criteria sep = `, ` ) ).

      DATA(lt_req_elements) = io_request->get_requested_elements( ).
      DATA(lv_req_elements)  = concat_lines_of( table = lt_req_elements sep = `, ` ).


      DATA lt_srvd_response TYPE STANDARD TABLE OF zyb_srvd_cust.

      SELECT (lv_req_elements) FROM @lt_srvd AS object
               ORDER BY (lv_sort_string)
               INTO CORRESPONDING FIELDS OF TABLE @lt_srvd_response
               OFFSET @lv_offset UP TO @lv_max_rows ROWS.

      io_response->set_data( lt_srvd_response ).
    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).

      SELECT COUNT( * ) FROM @lt_srvd AS response
                        INTO @DATA(lv_srvd_count).

      io_response->set_total_number_of_records( lv_srvd_count ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
