package org.openmrs.module.mchapp.api.impl;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.criterion.MatchMode;
import org.openmrs.Patient;
import org.openmrs.api.db.DAOException;
import org.openmrs.api.impl.BaseOpenmrsService;
import org.openmrs.module.mchapp.api.ImmunizationService;
import org.openmrs.module.mchapp.db.ImmunizationCommoditiesDAO;
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
 * @author HealthIT
 */
public class ImmunizationServiceImpl extends BaseOpenmrsService implements ImmunizationService {
	
	private ImmunizationCommoditiesDAO dao;
	
	protected final Log log = LogFactory.getLog(this.getClass());
	
	public ImmunizationCommoditiesDAO getDao() {
		return dao;
	}
	
	public void setDao(ImmunizationCommoditiesDAO dao) {
		this.dao = dao;
	}
	
	@Override
	public List<ImmunizationStoreTransactionType> getAllTransactionTypes() {
		return dao.getAllTransactionTypes();
	}
	
	@Override
	public Integer getLastTetanusToxoidVaccineCount(Integer patientId) {
		return dao.getLastTetanusToxoidVaccineCount(patientId);
	}
	
	@Override
	public ImmunizationStoreTransactionType getTransactionTypeByName(String name) {
		return dao.getTransactionTypeByName(name);
	}
	
	@Override
	public ImmunizationStoreTransactionType getTransactionTypeById(int id) {
		return dao.getTransactionTypeById(id);
	}
	
	@Override
	public ImmunizationStoreTransactionType saveImmunizationStoreTransactionType(ImmunizationStoreTransactionType type)
	        throws DAOException {
		return dao.saveImmunizationStoreTransactionType(type);
	}
	
	@Override
	public List<ImmunizationStoreDrug> getAllImmunizationStoreDrug() {
		return dao.getAllImmunizationStoreDrug();
	}
	
	@Override
	public ImmunizationStoreDrug getImmunizationStoreDrugById(int id) {
		return dao.getImmunizationStoreDrugById(id);
	}
	
	@Override
	public ImmunizationStoreDrug getImmunizationStoreDrugByBatchNo(String batchNo) {
		return dao.getImmunizationStoreDrugByBatchNo(batchNo);
	}
	
	@Override
	public ImmunizationStoreDrug getImmunizationStoreDrugByBatchNo(String batchNo, String drugName) {
		return dao.getImmunizationStoreDrugByBatchNo(batchNo, drugName);
	}
	
	@Override
	public List<ImmunizationStoreDrug> getImmunizationStoreDrugByName(String drugName) {
		return dao.getImmunizationStoreDrugByName(drugName);
	}
	
	@Override
	public ImmunizationStoreDrug saveImmunizationStoreDrug(ImmunizationStoreDrug storeDrug) {
		return dao.saveImmunizationStoreDrug(storeDrug);
	}
	
	@Override
	public ImmunizationStoreTransactionType getImmunizationStoreTransactionTypeById(int id) {
		return dao.getImmunizationStoreTransactionTypeById(id);
	}
	
	@Override
	public List<ImmunizationStoreTransactionType> getAllImmunizationStoreTransactionType() {
		return dao.getAllImmunizationStoreTransactionType();
	}
	
	@Override
	public List<ImmunizationStoreDrugTransactionDetail> getImmunizationStoreDrugTransactionDetailByType(
	        ImmunizationStoreTransactionType transactionType) {
		return dao.getImmunizationStoreDrugTransactionDetailByType(transactionType);
	}
	
	@Override
	public List<ImmunizationStoreDrugTransactionDetail> getImmunizationStoreDrugTransactionDetailByDrug(
	        ImmunizationStoreDrug drug) {
		return dao.getImmunizationStoreDrugTransactionDetailByDrug(drug);
	}
	
	@Override
	public List<ImmunizationStoreDrugTransactionDetail> getImmunizationStoreDrugTransactionDetailByDate(Date date) {
		return dao.getImmunizationStoreDrugTransactionDetailByDate(date);
	}
	
	@Override
	public List<ImmunizationStoreDrugTransactionDetail> getImmunizationStoreDrugTransactionDetailByPatient(Patient patient) {
		return dao.getImmunizationStoreDrugTransactionDetailByPatient(patient);
	}
	
	@Override
	public List<ImmunizationStoreDrugTransactionDetail> getAllImmunizationStoreDrugTransactionDetail() {
		return dao.getAllImmunizationStoreDrugTransactionDetail();
	}
	
	@Override
	public ImmunizationStoreDrugTransactionDetail getImmunizationStoreDrugTransactionDetailById(int id) {
		return dao.getImmunizationStoreDrugTransactionDetailById(id);
	}
	
	@Override
	public ImmunizationStoreDrugTransactionDetail saveImmunizationStoreDrugTransactionDetail(
	        ImmunizationStoreDrugTransactionDetail transactionDetail) {
		return dao.saveImmunizationStoreDrugTransactionDetail(transactionDetail);
	}
	
	@Override
	public ImmunizationStorePatientTransaction saveImmunizationStorePatientTransaction(
	        ImmunizationStorePatientTransaction patientTransaction) {
		return dao.saveImmunizationStorePatientTransaction(patientTransaction);
	}
	
	@Override
	public List<ImmunizationEquipment> getAllImmunizationEquipments() {
		return dao.getAllImmunizationEquipments();
	}
	
	@Override
	public ImmunizationEquipment getImmunizationEquipmentById(int id) {
		return dao.getImmunizationEquipmentById(id);
	}
	
	@Override
	public ImmunizationEquipment getImmunizationEquipmentByType(String type) {
		return dao.getImmunizationEquipmentByType(type);
	}
	
	@Override
	public ImmunizationEquipment saveImmunizationEquipment(ImmunizationEquipment immunizationEquipment) {
		return dao.saveImmunizationEquipment(immunizationEquipment);
	}
	
	@Override
	public List<ImmunizationEquipment> listImmunizationEquipment(String equipmentName, String equipmentType) {
		return dao.listImmunizationEquipment(equipmentName, equipmentType);
	}
	
	@Override
	public ImmunizationStockout getImmunizationStockoutById(int id) {
		return dao.getImmunizationStockoutById(id);
	}
	
	@Override
	public ImmunizationStockout saveImmunizationStockout(ImmunizationStockout immunizationStockout) {
		return dao.saveImmunizationStockout(immunizationStockout);
	}
	
	@Override
	public List<ImmunizationStoreDrugTransactionDetail> listImmunizationTransactions(TransactionType type, String rcptNames,
	        Date fromDate, Date toDate) {
		return dao.listImmunizationTransactions(type, rcptNames, fromDate, toDate);
	}
	
	@Override
	public List<ImmunizationStoreDrugTransactionDetail> listImmunizationTransactions(Integer drugId) {
		return dao.listImmunizationTransactions(drugId);
	}
	
	@Override
	public List<ImmunizationStoreDrugTransactionDetail> listImmunizationTransactionsByAccounts(TransactionType type,
	        String accountName, MatchMode mode) {
		return dao.listImmunizationTransactionsByAccounts(type, accountName, mode);
	}
	
	@Override
	public ImmunizationStoreDrug getImmunizationStoreDrugByExactName(String drugName) {
		return dao.getImmunizationStoreDrugByExactName(drugName);
	}
	
	@Override
	public List<ImmunizationStoreDrug> getAvailableDrugBatches(Integer drgId) {
		return dao.getAvailableDrugBatches(drgId);
	}
	
	@Override
	public List<ImmunizationStockout> listImmunizationStockouts(String outsNames, Date fromDate, Date toDate) {
		return dao.listImmunizationStockouts(outsNames, fromDate, toDate);
	}
	
	@Override
	public List<ImmunizationStockout> listImmunizationStockouts(Integer drugId, Boolean currentlyOpen) {
		return dao.listImmunizationStockouts(drugId, currentlyOpen);
	}
}
