package org.openmrs.module.treatmentapp.page.controller;

import org.openmrs.api.context.Context;
import org.openmrs.module.kenyaui.annotation.AppPage;
import org.openmrs.module.treatmentapp.api.ImmunizationService;
import org.openmrs.module.treatmentapp.model.ImmunizationStockout;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 */
@AppPage("treatmentapp.stores")
public class StockoutsDetailsPageController {
	
	private ImmunizationService immunizationService = Context.getService(ImmunizationService.class);
	
	public void get(@RequestParam("transactionId") Integer transactionId, PageModel model, UiUtils uiUtils) {
		ImmunizationStockout stockout = immunizationService.getImmunizationStockoutById(transactionId);
		model.addAttribute("transactionId", transactionId);
		model.addAttribute("stockout", stockout);
		
	}
}
