// using { anubhav.db.master, anubhav.db.transaction } from '../db/datamodel';
// using { cappo.cds } from '../db/CDSView';
 
 
// service CatalogService @(path: 'CatalogService',requires: 'authenticated-user') {
 
//     entity ProductSet as projection on master.product;
//     entity BusinessPartnerSet as projection on master.businesspartner;
//     entity BusinessAddressSet as projection on master.address;
//    // @readonly
//     entity EmployeeSet @(restrict: [
//                         { grant: ['READ'], to: 'Viewer', where: 'bankName = $user.BankName' },
//                         { grant: ['WRITE'], to: 'Admin' }
//                         ])as projection on master.employees;
//     //@Capabilities : { Deletable: false }
//     entity POs @(odata.draft.enabled: true) as projection on transaction.purchaseorder{
//         *,
//         Items,
//         case OVERALL_STATUS
//             when 'P' then 'Pending'
//             when 'N' then 'New'
//             when 'A' then 'Approved'
//             when 'X' then 'Rejected'
//             end as OverallStatus : String(10),
//         case OVERALL_STATUS
//             when 'P' then 2
//             when 'N' then 2
//             when 'A' then 3
//             when 'X' then 1
//             end as ColorCode : Integer,
//     }
//     actions{
//         @Common.SideEffects : {
//             TargetProperties : [
//                 'in/GROSS_AMOUNT',
//             ]
//         }
//         action boost() returns POs
//     };
//     //definition of the function
//     function getOrderDefaults() returns POs;
//     function largestOrder() returns array of  POs;
//     entity POItems as projection on transaction.poitems;
//     // entity OrderItems as projection on cds.CDSViews.ItemView;
//     // entity Products as projection on cds.CDSViews.ProductView;
 
// }


// using { anubhav.db.master, anubhav.db.transaction } from '../db/datamodel';
using { anubhav.db } from '../db/datamodel';
using { cappo.cds } from '../db/CDSView';
// using { anubhav.cds } from '../db/CDSViews';


service CatalogService @(path : 'CatalogService', requires: 'authenticated-user') {
    //@Capabilities.Updatable: false
    entity BusinessPartnerSet as projection on db.master.businesspartner;
    entity AddressSet as projection on db.master.address;
    //@readonly
    entity EmployeeSet @(restrict: [ 
                        { grant: ['READ'], to: 'Viewer', where: 'bankName = $user.BankName' },
                        { grant: ['WRITE'], to: 'Admin' }
                        ]) as projection on db.master.employees;
    entity PurchaseOrder @(
        odata.draft.enabled: true
    ) as projection on db.transaction.purchaseorder{
        *,
        case OVERALL_STATUS
            when 'N' then 'New'
            when 'P' then 'Paid'
            when 'B' then 'Blocked'
            else 'Delivered' end as OVERALL_STATUS: String(20),
        case OVERALL_STATUS
            when 'N' then 0
            when 'P' then 1
            when 'B' then 2
            else 3 end as Criticality: Integer,
            Items

    }
    actions{
        @cds.odata.bindingparameter.name : '_anubhav'
        @Common.SideEffects : {
                TargetProperties : ['_anubhav/GROSS_AMOUNT']
            }  
        action boost() returns PurchaseOrder;
        @cds.odata.bindingparameter.name : '_ananya'
        @Common.SideEffects : {
                TargetProperties : ['_ananya/OVERALL_STATUS']
            }  
        action setOrderProcessing();
        function largestOrder() returns array of PurchaseOrder;
    };

    function getOrderDefaults() returns PurchaseOrder;
    entity PurchaseOrderItems as projection on db.transaction.poitems;
    entity ProductSet as projection on db.master.product;
    //entity PurchaseOrderSet as projection on cds.CDSViews.POWorklist;
    //entity ItemView as projection on cds.CDSViews.ItemView;
    //entity ProductSet as projection on cds.CDSViews.ProductView;
    ///entity ProductSales as projection on cds.CDSViews.CProductValuesView;
}
