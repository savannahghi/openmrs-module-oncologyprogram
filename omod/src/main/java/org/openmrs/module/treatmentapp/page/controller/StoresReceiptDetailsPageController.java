package org.openmrs.module.treatmentapp.page.controller;

import org.openmrs.api.context.Context;
import org.openmrs.module.ehrinventory.InventoryService;
import org.openmrs.module.kenyaui.annotation.AppPage;
import org.openmrs.module.treatmentapp.model.ImmunizationStoreDrugTransactionDetail;
import org.openmrs.module.treatmentapp.api.ImmunizationService;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 */
@AppPage("treatmentapp.stores")
public class StoresReceiptDetailsPageController {
	
	private ImmunizationService immunizationService = Context.getService(ImmunizationService.class);
	
	public void get(@RequestParam("receiptId") Integer receiptId, PageModel model, UiUtils uiUtils) {
		model.addAttribute("receiptId", receiptId);
		model.addAttribute("title", receiptId);
		InventoryService service = Context.getService(InventoryService.class);
		
		ImmunizationStoreDrugTransactionDetail drugTransactionDetail = immunizationService
		        .getImmunizationStoreDrugTransactionDetailById(receiptId);
		model.addAttribute("drugTransactionDetail", drugTransactionDetail);
		SimpleObject object = SimpleObject.fromObject(drugTransactionDetail, uiUtils, "id", "vvmStage", "remark",
		    "quantity", "createdOn", "createdBy", "storeDrug.inventoryDrug.name", "storeDrug.batchNo",
		    "transactionType.transactionType", "patient");
		model.addAttribute("drugTransactionDetails", drugTransactionDetail);
		model.addAttribute("drugObject", object);
		
	}
}
