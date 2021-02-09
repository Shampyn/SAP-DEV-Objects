@EndUserText.label: 'select data definition'
@ObjectModel.query.implementedBy: 'ABAP:ZYB_CL_DDLS_CUSTOM'
define custom entity ZYB_DDLS_CUSTOM
{
      @UI.hidden     : true
  key DataDefinition : zyb_ddls_object;
      @UI            : { lineItem:       [ { position: 10, importance: #HIGH, label:'Field Name' }] ,
                            identification: [ { position: 10, label:'Field Name' } ] }
  key fieldName      : zyb_field_name;
      @UI            : { lineItem:       [ { position: 10, importance: #HIGH, label:'Is Key?' }] ,
                            identification: [ { position: 10, label:'Is Key?' } ] }
      IsKeyField     : zyb_iskey;
      @UI            : { lineItem:       [ { position: 20, importance: #HIGH, label:'Alias' }] ,
                        identification: [ { position: 20, label:'Alias' } ] }
      AliasName      : zyb_alias_name;
}
