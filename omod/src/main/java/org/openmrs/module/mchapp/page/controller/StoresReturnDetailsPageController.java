package org.openmrs.module.mchapp.page.controller;

import org.openmrs.api.context.Context;
import org.openmrs.module.ehrinventory.InventoryService;
import org.openmrs.module.kenyaui.annotation.AppPage;
import org.openmrs.module.mchapp.model.ImmunizationStoreDrugTransactionDetail;
import org.openmrs.module.mchapp.api.ImmunizationService;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 */
@AppPage("mchapp.stores")
public class StoresReturnDetailsPageController {
	
	private ImmunizationService immunizationService = Context.getService(ImmunizationService.class);
	
	public void get(@RequestParam("returnId") Integer returnId, PageModel model, UiUtils uiUtils) {
		model.addAttribute("receiptId", returnId);
		model.addAttribute("title", returnId);
		InventoryService service = Context.getService(InventoryService.class);
		
		ImmunizationStoreDrugTransactionDetail drugTransactionDetail = immunizationService
		        .getImmunizationStoreDrugTransactionDetailById(returnId);
		model.addAttribute("drugTransactionDetail", drugTransactionDetail);
		SimpleObject object = SimpleObject.fromObject(drugTransactionDetail, uiUtils, "id", "vvmStage", "remark",
		    "quantity", "createdOn", "createdBy", "storeDrug.inventoryDrug.name", "storeDrug.batchNo",
		    "transactionType.transactionType", "patient");
		model.addAttribute("drugTransactionDetails", drugTransactionDetail);
		model.addAttribute("drugObject", object);
		
	}
}
