package de.ingrid.mdek.handler;

import java.util.ArrayList;

import de.ingrid.mdek.beans.address.MdekAddressBean;
import de.ingrid.mdek.beans.query.AddressExtSearchParamsBean;
import de.ingrid.mdek.beans.query.AddressSearchResultBean;
import de.ingrid.mdek.beans.query.AddressWorkflowResultBean;
import de.ingrid.mdek.beans.query.ObjectExtSearchParamsBean;
import de.ingrid.mdek.beans.query.ObjectSearchResultBean;
import de.ingrid.mdek.beans.query.ObjectWorkflowResultBean;
import de.ingrid.mdek.beans.query.SearchResultBean;

public interface QueryRequestHandler {

	public AddressSearchResultBean searchAddresses(MdekAddressBean adr, int startHit, int numHits);

	public AddressSearchResultBean queryAddressesExtended(AddressExtSearchParamsBean query, int startHit, int numHits);
	public ObjectSearchResultBean queryObjectsExtended(ObjectExtSearchParamsBean query, int startHit, int numHits);

	public AddressSearchResultBean queryAddressesFullText(String searchTerm, int startHit, int numHits);
	public ObjectSearchResultBean queryObjectsFullText(String searchTerm, int startHit, int numHits);

	public AddressSearchResultBean queryAddressesThesaurusTerm(String topicId, int startHit, int numHits);
	public ObjectSearchResultBean queryObjectsThesaurusTerm(String topicId, int startHit, int numHits);
	
	public SearchResultBean queryHQL(String hqlQuery, int startHit, int numHits);
	public SearchResultBean queryHQLToCSV(String hqlQuery);

	public ArrayList<AddressWorkflowResultBean> getExpiredAddresses(int numHits);
	public ArrayList<ObjectWorkflowResultBean> getExpiredObjects(int numHits);

	public ArrayList<AddressWorkflowResultBean> getModifiedAddresses(int numHits);
	public ArrayList<ObjectWorkflowResultBean> getModifiedObjects(int numHits);

	public ArrayList<AddressWorkflowResultBean> getQAAddresses(int numHits);
	public ArrayList<ObjectWorkflowResultBean> getQAObjects(int numHits);

	public ArrayList<ObjectWorkflowResultBean> getAllObjectsForQAAssignedToQA(int numHits, boolean userIsCatAdmin);
	public ArrayList<AddressWorkflowResultBean> getAllAddressesForQAAssignedToQA(int numHits, boolean userIsCatAdmin);

	public ArrayList<ObjectWorkflowResultBean> getAllModifiedObjectsForQA(int numHits, boolean userIsCatAdmin);
	public ArrayList<AddressWorkflowResultBean> getAllModifiedAddressesForQA(int numHits, boolean userIsCatAdmin);

	public ArrayList<ObjectWorkflowResultBean> getAllExpiredObjectsForQA(int numHits, boolean userIsCatAdmin);
	public ArrayList<AddressWorkflowResultBean> getAllExpiredAddressesForQA(int numHits, boolean userIsCatAdmin);
}
