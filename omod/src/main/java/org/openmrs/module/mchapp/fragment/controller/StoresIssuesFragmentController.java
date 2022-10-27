package org.openmrs.module.mchapp.fragment.controller;

import org.openmrs.Patient;
import org.openmrs.Person;
import org.openmrs.api.context.Context;
import org.openmrs.module.mchapp.model.ImmunizationStoreDrug;
import org.openmrs.module.mchapp.model.ImmunizationStoreDrugTransactionDetail;
import org.openmrs.module.mchapp.model.ImmunizationStoreTransactionType;
import org.openmrs.module.mchapp.MchStores;
import org.openmrs.module.mchapp.api.ImmunizationService;
import org.openmrs.module.mchapp.model.TransactionType;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Date;
import java.util.List;

/**
 * @author Stanslaus Odhiambo Created on 8/29/2016.
 */
public class StoresIssuesFragmentController {
	
	private ImmunizationService immunizationService = Context.getService(ImmunizationService.class);
	
	//    Default handler for GET and POST requests if none exist
	public void controller() {
	}
	
	public List<SimpleObject> listImmunizationIssues(UiUtils uiUtils,
	        @RequestParam(value = "issueNames", required = false) String rcptNames,
	        @RequestParam(value = "fromDate", required = false) Date fromDate,
	        @RequestParam(value = "toDate", required = false) Date toDate) {
		
		List<ImmunizationStoreDrugTransactionDetail> transactionDetails = immunizationService.listImmunizationTransactions(
		    TransactionType.ISSUES, rcptNames, fromDate, toDate);
		return SimpleObject.fromCollection(transactionDetails, uiUtils, "createdOn", "storeDrug.inventoryDrug.name",
		    "storeDrug.inventoryDrug.id", "quantity", "vvmStage", "remark", "id");
	}
	
	public SimpleObject getBatchesForSelectedDrug(UiUtils uiUtils, @RequestParam("drgId") Integer drgId,
	        @RequestParam("drgName") String drgName) {
		return MchStores.getBatchesForSelectedDrug(uiUtils, drgId);
		
	}
	
	public SimpleObject getImmunizationDrugDetailByBatch(UiUtils uiUtils,
	        @RequestParam(value = "issueBatchNo", required = false) String issueBatchNo) {
		ImmunizationStoreDrug storeDrug = immunizationService.getImmunizationStoreDrugByBatchNo(issueBatchNo, null);
		return SimpleObject.fromObject(storeDrug, uiUtils, "currentQuantity");
	}
	
	public SimpleObject saveImmunizationIssues(UiUtils uiUtils, @RequestParam("issueName") String issueName,
	        @RequestParam("issueQuantity") Integer issueQuantity, @RequestParam("issueStage") Integer issueStage,
	        @RequestParam("issueBatchNo") String issueBatchNo,
	        @RequestParam(value = "patientId", required = false) Patient patient,
	        @RequestParam(value = "issueAccount", required = false) String issueAccount,
	        @RequestParam(value = "issueRemarks", required = false) String issueRemarks) {
		Person person = Context.getAuthenticatedUser().getPerson();
		ImmunizationStoreDrugTransactionDetail transactionDetail = new ImmunizationStoreDrugTransactionDetail();
		
		ImmunizationStoreDrug drugBatch = immunizationService.getImmunizationStoreDrugByBatchNo(issueBatchNo, issueName);
		List<ImmunizationStoreDrug> drugs = immunizationService.getImmunizationStoreDrugByName(drugBatch.getInventoryDrug()
		        .getName());
		
		int cummulativeQuantity = 0; //GET QUANTITY FROM THE LAST TRANSACTION IN THE immunization_store_drug_transaction_detail TABLE
		for (ImmunizationStoreDrug drug : drugs) {
			cummulativeQuantity += drug.getCurrentQuantity();
		}
		
		transactionDetail.setCreatedBy(person);
		transactionDetail.setCreatedOn(new Date());
		transactionDetail.setQuantity(issueQuantity);
		
		transactionDetail.setOpeningBalance(cummulativeQuantity);
		transactionDetail.setClosingBalance(cummulativeQuantity - issueQuantity);
		
		//        TODO need rework
		if (patient != null) {
			transactionDetail.setPatient(patient);
		}
		
		if (drugBatch != null) {
			//            drugBatch exists with the given batch
			int currentQuantity = drugBatch.getCurrentQuantity();
			int i = currentQuantity - issueQuantity;
			
			drugBatch.setCurrentQuantity(i);
			transactionDetail.setStoreDrug(drugBatch);
		} else {
			//            no current drugBatch with this batch ae the drugBatch, then assign
			return SimpleObject.create("status", "error", "message", "No Drug Found for selected Batch");
		}
		//process the batch
		transactionDetail.setVvmStage(issueStage);
		transactionDetail.setRemark(issueRemarks);
		transactionDetail.setTransactionAccount(issueAccount);
		
		ImmunizationStoreTransactionType transactionType = immunizationService.getTransactionTypeById(TransactionType.ISSUES
		        .getValue());
		transactionDetail.setTransactionType(transactionType);
		ImmunizationStoreDrugTransactionDetail storeDrugTransactionDetail = immunizationService
		        .saveImmunizationStoreDrugTransactionDetail(transactionDetail);
		if (storeDrugTransactionDetail != null) {
			return SimpleObject.create("status", "success", "message", "Drug Issue Saved Successfully");
		} else {
			return SimpleObject.create("status", "error", "message", "Error occurred while saving Issue");
		}
		
	}
	
	public SimpleObject saveImmunizationIssuesToAccount(UiUtils uiUtils, @RequestParam("accountName") String accountName,
	        @RequestParam("issueAccountName") String issueAccountName,
	        @RequestParam("issueAccountQuantity") Integer issueAccountQuantity,
	        @RequestParam("issueAccountStage") Integer issueAccountStage,
	        @RequestParam("issueAccountBatchNo") String issueAccountBatchNo,
	        @RequestParam(value = "issueAccountRemarks", required = false) String issueAccountRemarks) {
		Person person = Context.getAuthenticatedUser().getPerson();
		ImmunizationStoreDrugTransactionDetail transactionDetail = new ImmunizationStoreDrugTransactionDetail();
		
		ImmunizationStoreDrug drugBatch = immunizationService.getImmunizationStoreDrugByBatchNo(issueAccountBatchNo,
		    issueAccountName);
		List<ImmunizationStoreDrug> drugs = immunizationService.getImmunizationStoreDrugByName(drugBatch.getInventoryDrug()
		        .getName());
		
		int cummulativeQuantity = 0; //GET QUANTITY FROM THE LAST TRANSACTION IN THE immunization_store_drug_transaction_detail TABLE
		for (ImmunizationStoreDrug drug : drugs) {
			cummulativeQuantity += drug.getCurrentQuantity();
		}
		
		transactionDetail.setCreatedBy(person);
		transactionDetail.setCreatedOn(new Date());
		transactionDetail.setQuantity(issueAccountQuantity);
		
		transactionDetail.setOpeningBalance(cummulativeQuantity);
		transactionDetail.setClosingBalance(cummulativeQuantity - issueAccountQuantity);
		
		if (drugBatch != null) {
			//            drugBatch exists with the given batch
			int currentQuantity = drugBatch.getCurrentQuantity();
			int i = currentQuantity - issueAccountQuantity;
			
			drugBatch.setCurrentQuantity(i);
			transactionDetail.setStoreDrug(drugBatch);
		} else {
			//            no current drugBatch with this batch ae the drugBatch, then assign
			return SimpleObject.create("status", "error", "message", "No Drug Found for selected Batch");
		}
		//process the batch
		transactionDetail.setVvmStage(issueAccountStage);
		transactionDetail.setRemark(issueAccountRemarks);
		transactionDetail.setTransactionAccount(accountName);
		
		ImmunizationStoreTransactionType transactionType = immunizationService
		        .getTransactionTypeById(TransactionType.ISSUE_TO_ACCOUNT.getValue());
		transactionDetail.setTransactionType(transactionType);
		ImmunizationStoreDrugTransactionDetail storeDrugTransactionDetail = immunizationService
		        .saveImmunizationStoreDrugTransactionDetail(transactionDetail);
		if (storeDrugTransactionDetail != null) {
			return SimpleObject.create("status", "success", "message", "Issue To Account Successfully Saved");
		} else {
			return SimpleObject.create("status", "error", "message", "Error occurred while saving Issue");
		}
		
	}
	
}
