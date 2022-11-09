package org.openmrs.module.treatmentapp.page.controller;

import org.openmrs.api.context.Context;
import org.openmrs.module.kenyaui.annotation.AppPage;
import org.openmrs.module.treatmentapp.model.ImmunizationStoreDrug;
import org.openmrs.module.treatmentapp.model.ImmunizationStoreDrugTransactionDetail;
import org.openmrs.module.hospitalcore.model.InventoryDrug;
import org.openmrs.module.ehrinventory.InventoryService;
import org.openmrs.module.treatmentapp.api.ImmunizationService;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * @author
 */
@AppPage("treatmentapp.stores")
public class StoresVaccinesPageController {
	
	private ImmunizationService immunizationService = Context.getService(ImmunizationService.class);
	
	public void get(@RequestParam("drugId") Integer drugId, PageModel model) {
		InventoryService service = Context.getService(InventoryService.class);
		InventoryDrug inventoryDrug = service.getDrugById(drugId);
		
		List<ImmunizationStoreDrug> drugs = immunizationService.getImmunizationStoreDrugByName(inventoryDrug.getName());
		int quantity = 0;
		
		for (ImmunizationStoreDrug drug : drugs) {
			quantity += drug.getCurrentQuantity();
		}
		
		if (inventoryDrug != null) {
			List<ImmunizationStoreDrugTransactionDetail> storeDrugs = immunizationService
			        .listImmunizationTransactions(drugId);
			model.addAttribute("storeDrugs", storeDrugs);
			model.addAttribute("drug", inventoryDrug);
		}
		
		model.addAttribute("quantity", quantity);
		model.addAttribute("userLocation", Context.getAdministrationService().getGlobalProperty("hospital.location_user"));
	}
}
