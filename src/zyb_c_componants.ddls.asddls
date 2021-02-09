@EndUserText.label: 'projection for components'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
  headerInfo: { typeName: 'SAP Development Object', typeNamePlural: 'SAP Development Objects',
                title: { type: #STANDARD, value: 'ABAPObject'} } }

define root view entity ZYB_C_COMPONANTS
  as projection on ZYB_I_COMPONENTS
{
          @UI.facet: [
                           { id:            'General_Info',
                             purpose:       #STANDARD,
                             type:          #IDENTIFICATION_REFERENCE,
                             label:         'General Info',
                             position:      10
                           },
                           { id:            'Fields',
                             purpose:       #STANDARD,
                             type:          #LINEITEM_REFERENCE,
                             label:         'Table Fields',
                             position:      20,
                             hidden: #(IsTable),
  targetElement: '_fields'},
  { id:            'SubObject',
  purpose:       #STANDARD,
  type:          #LINEITEM_REFERENCE,
  label:         'Subobjects',
  position:      30,
  hidden: #(IsAPLO),
  targetElement: '_subObj'},
  { id:            'Fixed_value',
  purpose:       #STANDARD,
  type:          #LINEITEM_REFERENCE,
  label:         'Fixed Values',
  position:      40,
  hidden: #(IsDomain),
  targetElement: '_domain'},
  { id:            'Message',
  purpose:       #STANDARD,
  type:          #LINEITEM_REFERENCE,
  label:         'Message',
  position:      40,
  hidden: #(IsMSAG),
  targetElement: '_msag'},
  { id:            'ServiceDEfinition',
  purpose:       #STANDARD,
  type:          #LINEITEM_REFERENCE,
  label:         'Service Definition',
  position:      40,
  hidden: #(IsSRVD),
  targetElement: '_srvd'},
  { id:            'Data_Definition',
  purpose:       #STANDARD,
  type:          #LINEITEM_REFERENCE,
  label:         'Data Definition',
  position:      40,
  hidden: #(IsDDLS),
  targetElement: '_ddls'},
  { id:            'DTEL',
  purpose:       #STANDARD,
  type:          #IDENTIFICATION_REFERENCE,
  label:         'Data Definition',
  position:      40,
  hidden: #(IsDTEL),
  targetElement: '_dtel'},
  { id:            'SRVB',
  purpose:       #STANDARD,
  type:          #IDENTIFICATION_REFERENCE,
  label:         'Service Binding',
  position:      40,
  hidden: #(IsSRVB),
  targetElement: '_srvb'}
  ]
          @UI.hidden: true
  key     ABAPObjectCategory,
          @UI: { lineItem:       [ { position: 20, importance: #HIGH, label:'Object Type' }] ,
                 identification: [ { position: 20, label:'Object Type' } ],
                 selectionField: [ { position: 20 } ] }
          @Consumption.valueHelpDefinition: [{ entity : {name: 'ZYB_I_OBJECT_TEXT', element: 'Objecttype'  } }]
          @ObjectModel.text.element: ['Objecttypetext']
  key     ABAPObjectType,
          @UI: { lineItem:       [ { position: 10, importance: #HIGH, label:'Object Name' }] ,
                 identification: [ { position: 10, label:'Object Name' } ],
                 selectionField: [ { position: 10 } ] }
  key     ABAPObject,
          @UI: { lineItem:       [ { position: 40, importance: #HIGH, label:'Responsible User' }] ,
                 identification: [ { position: 40, label:'Responsible User' } ] }
          ABAPObjectResponsibleUser,
          @UI: { identification: [ { position: 60, label:'Is Deleted?' } ] }
          ABAPObjectIsDeleted,
          @UI: { lineItem:       [ { position: 30, importance: #HIGH, label:'Package' }] ,
                 identification: [ { position: 30, label:'Package' } ],
                 selectionField: [ { position: 30 } ] }
          @Consumption.valueHelpDefinition: [{ entity : {name: 'ZYB_PACKAGE_VALUE_HELP', element: 'ABAPPackage'  } }]
          ABAPPackage,
          Objecttypetext,
          @UI: { identification: [ { position: 50, label:'Software Component' } ] }
          ABAPSoftwareComponent,

          @UI: { lineItem:       [ { position: 60, importance: #HIGH, label:'Description' }] ,
                 identification: [ { position: 60, label:'Description' } ] }
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZYB_CL_VIRTUAL'
  virtual Description : zyb_obj_description,
          @UI.hidden: true
          IsTable,
          @UI.hidden: true
          IsAPLO,
          @UI.hidden: true
          IsDomain,
          @UI.hidden: true
          IsDDLS,
          @UI.hidden: true
          IsMSAG,
          @UI.hidden: true
          IsSRVD,
          @UI.hidden: true
          IsDTEL,
          @UI.hidden: true
          IsSRVB,
          /* Associations */
          _CustABAPPackage,
          _fields,
          _subObj,
          _domain,
          _ddls,
          _msag,
          _srvd,
          _dtel,
          _srvb

}
