package org.openmrs.module.mchapp.api;

import org.hibernate.criterion.MatchMode;
import org.openmrs.Patient;
import org.openmrs.api.OpenmrsService;
import org.openmrs.api.db.DAOException;
import org.openmrs.module.mchapp.model.ImmunizationEquipment;
import org.openmrs.module.mchapp.model.ImmunizationStockout;
import org.openmrs.module.mchapp.model.ImmunizationStoreDrug;
import org.openmrs.module.mchapp.model.ImmunizationStoreDrugTransactionDetail;
import org.openmrs.module.mchapp.model.ImmunizationStorePatientTransaction;
import org.openmrs.module.mchapp.model.ImmunizationStoreTransactionType;
import org.openmrs.module.mchapp.model.TransactionType;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * @author HealthIT
 */
@Transactional
public interface ImmunizationService extends OpenmrsService {
	
	List<ImmunizationStoreTransactionType> getAllTransactionTypes();
	
	Integer getLastTetanusToxoidVaccineCount(Integer patientId);
	
	ImmunizationStoreTransactionType getTransactionTypeByName(String name);
	
	ImmunizationStoreTransactionType getTransactionTypeById(int id);
	
	ImmunizationStoreTransactionType saveImmunizationStoreTransactionType(ImmunizationStoreTransactionType type)
	        throws DAOException;
	
	/*        ImmunizationStoreDrug     */
	List<ImmunizationStoreDrug> getAllImmunizationStoreDrug();
	
	ImmunizationStoreDrug getImmunizationStoreDrugById(int id);
	
	ImmunizationStoreDrug getImmunizationStoreDrugByBatchNo(String batchNo);
	
	ImmunizationStoreDrug getImmunizationStoreDrugByBatchNo(String batchNo, String drugName);
	
	List<ImmunizationStoreDrug> getImmunizationStoreDrugByName(String drugName);
	
	ImmunizationStoreDrug saveImmunizationStoreDrug(ImmunizationStoreDrug storeDrug);
	
	/*  ImmunizationStoreDrugTransactionDetail    */
	ImmunizationStoreTransactionType getImmunizationStoreTransactionTypeById(int id);
	
	List<ImmunizationStoreTransactionType> getAllImmunizationStoreTransactionType();
	
	/*  ImmunizationStoreDrugTransactionDetail    */
	List<ImmunizationStoreDrugTransactionDetail> getImmunizationStoreDrugTransactionDetailByType(
	        ImmunizationStoreTransactionType transactionType);
	
	List<ImmunizationStoreDrugTransactionDetail> getImmunizationStoreDrugTransactionDetailByDrug(ImmunizationStoreDrug drug);
	
	List<ImmunizationStoreDrugTransactionDetail> getImmunizationStoreDrugTransactionDetailByDate(Date date);
	
	List<ImmunizationStoreDrugTransactionDetail> getImmunizationStoreDrugTransactionDetailByPatient(Patient patient);
	
	List<ImmunizationStoreDrugTransactionDetail> getAllImmunizationStoreDrugTransactionDetail();
	
	ImmunizationStoreDrugTransactionDetail getImmunizationStoreDrugTransactionDetailById(int id);
	
	ImmunizationStoreDrugTransactionDetail saveImmunizationStoreDrugTransactionDetail(
	        ImmunizationStoreDrugTransactionDetail transactionDetail);
	
	ImmunizationStorePatientTransaction saveImmunizationStorePatientTransaction(
	        ImmunizationStorePatientTransaction patientTransaction);
	
	/*        ImmunizationEquipment     */
	List<ImmunizationEquipment> getAllImmunizationEquipments();
	
	ImmunizationEquipment getImmunizationEquipmentById(int id);
	
	ImmunizationEquipment getImmunizationEquipmentByType(String type);
	
	ImmunizationEquipment saveImmunizationEquipment(ImmunizationEquipment immunizationEquipment);
	
	List<ImmunizationEquipment> listImmunizationEquipment(String equipmentName, String equipmentType);
	
	/*  ImmunizationStockout    */
	
	ImmunizationStockout getImmunizationStockoutById(int id);
	
	ImmunizationStockout saveImmunizationStockout(ImmunizationStockout immunizationStockout);
	
	List<ImmunizationStoreDrugTransactionDetail> listImmunizationTransactions(TransactionType type, String rcptNames,
	        Date fromDate, Date toDate);
	
	List<ImmunizationStoreDrugTransactionDetail> listImmunizationTransactions(Integer drugId);
	
	List<ImmunizationStoreDrugTransactionDetail> listImmunizationTransactionsByAccounts(TransactionType type,
	        String accountName, MatchMode mode);
	
	ImmunizationStoreDrug getImmunizationStoreDrugByExactName(String rcptBatchNo);
	
	List<ImmunizationStoreDrug> getAvailableDrugBatches(Integer drgId);
	
	List<ImmunizationStockout> listImmunizationStockouts(String outsNames, Date fromDate, Date toDate);
	
	List<ImmunizationStockout> listImmunizationStockouts(Integer drugId, Boolean currentlyOpen);
}
