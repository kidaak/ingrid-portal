package de.ingrid.mdek.dwr.services;

import java.util.List;
import java.util.Map;

import de.ingrid.mdek.beans.address.MdekAddressBean;

public interface AddressService {

	public MdekAddressBean getAddressData(String nodeUuid, Boolean useWorkingCopy);
	public MdekAddressBean saveAddressData(MdekAddressBean data, Boolean useWorkingCopy);
	public MdekAddressBean assignAddressToQA(MdekAddressBean data);
	public Map<String, Object> copyAddress(String nodeUuid, String dstNodeUuid, Boolean includeChildren, Boolean copyToFreeAddress);
	public void moveAddress(String nodeUuid, String dstNodeUuid, boolean moveToFreeAddress);
	public void deleteAddress(String nodeUuid, Boolean forceDeleteReferences, Boolean markOnly);
	public MdekAddressBean deleteAddressWorkingCopy(String nodeUuid, Boolean forceDeleteReferences, Boolean markOnly);
	public MdekAddressBean createNewAddress(String parentUuid);
	public List<String> getPathToAddress(String targetUuid);
	public boolean canCutAddress(String parentUuid);
	public boolean canCopyAddress(String parentUuid);
	public MdekAddressBean fetchAddressObjectReferences(String addrUuid, int startIndex, int numRefs);
}