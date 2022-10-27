package org.openmrs.module.mchapp.db;

import org.hibernate.criterion.MatchMode;
import org.openmrs.Patient;
import org.openmrs.api.db.DAOException;
import org.openmrs.module.mchapp.model.ImmunizationEquipment;
import org.openmrs.module.mchapp.model.ImmunizationStockout;
import org.openmrs.module.mchapp.model.ImmunizationStoreDrug;
import org.openmrs.module.mchapp.model.ImmunizationStoreDrugTransactionDetail;
import org.openmrs.module.mchapp.model.ImmunizationStorePatientTransaction;
import org.openmrs.module.mchapp.model.ImmunizationStoreTransactionType;
import org.openmrs.module.mchapp.model.TransactionType;

import java.util.Date;
import java.util.List;

/**
 * @author Stanslaus Odhiambo Create on 8/24/2016. Interface that declares the functionalities to be
 *         implemented by the implementing class that enters into a contract with it
 */
public interface ImmunizationCommoditiesDAO {
	
	Integer getLastTetanusToxoidVaccineCount(Integer patientId);
	
	//    TODO Behaviours for implementing the Immunization functionalities
	List<ImmunizationStoreDrug> listImmunizationStoreDrug(String name, int min, int max) throws DAOException;
	
	/*    ImmunizationStoreTransactionType     */
	
	/**
	 * Gets the list of all @see ImmunizationStoreTransactionType stored in the database
	 * 
	 * @return list of all ImmunizationStoreTransactionType
	 */
	List<ImmunizationStoreTransactionType> getAllTransactionTypes();
	
	ImmunizationStoreTransactionType getTransactionTypeByName(String name);
	
	ImmunizationStoreTransactionType getTransactionTypeById(int id);
	
	ImmunizationStoreTransactionType saveImmunizationStoreTransactionType(ImmunizationStoreTransactionType type)
	        throws DAOException;
	
	/*        ImmunizationStoreDrug     */
	List<ImmunizationStoreDrug> getAllImmunizationStoreDrug();
	
	ImmunizationStoreDrug getImmunizationStoreDrugById(int id);
	
	ImmunizationStoreDrug getImmunizationStoreDrugByBatchNo(String batchNo);
	
	ImmunizationStoreDrug getImmunizationStoreDrugByBatchNo(String batchNo, String drugName);
	
	ImmunizationStoreDrug saveImmunizationStoreDrug(ImmunizationStoreDrug storeDrug);
	
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
	
	//List<ImmunizationStockout> getImmunizationStockoutByDrug(InventoryDrug drug);
	
	ImmunizationStockout getImmunizationStockoutById(int id);
	
	ImmunizationStockout saveImmunizationStockout(ImmunizationStockout immunizationStockout);
	
	/* ImmunizationStoreTransactionType */
	ImmunizationStoreTransactionType getImmunizationStoreTransactionTypeById(int id);
	
	List<ImmunizationStoreTransactionType> getAllImmunizationStoreTransactionType();
	
	List<ImmunizationStoreDrug> getImmunizationStoreDrugByName(String drugName);
	
	List<ImmunizationStoreDrug> getAvailableDrugBatches(Integer drgId);
	
	ImmunizationStoreDrug getImmunizationStoreDrugByExactName(String drugName);
	
	List<ImmunizationStoreDrugTransactionDetail> listImmunizationTransactions(TransactionType type, String rcptNames,
	        Date fromDate, Date toDate);
	
	List<ImmunizationStoreDrugTransactionDetail> listImmunizationTransactionsByAccounts(TransactionType type,
	        String accountName, MatchMode mode);
	
	List<ImmunizationStoreDrugTransactionDetail> listImmunizationTransactions(Integer drugId);
	
	List<ImmunizationStockout> listImmunizationStockouts(String outsNames, Date fromDate, Date toDate);
	
	List<ImmunizationStockout> listImmunizationStockouts(Integer drugId, Boolean currentlyOpen);
	
}
