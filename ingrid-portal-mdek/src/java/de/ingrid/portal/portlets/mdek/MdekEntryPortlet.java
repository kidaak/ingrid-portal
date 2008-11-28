/*
 * Copyright (c) 2006 wemove digital solutions. All rights reserved.
 */
package de.ingrid.portal.portlets.mdek;

import java.io.IOException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.jetspeed.CommonPortletServices;
import org.apache.jetspeed.security.RoleManager;
import org.apache.jetspeed.security.SecurityException;
import org.apache.jetspeed.security.UserManager;
import org.apache.portals.bridges.velocity.GenericVelocityPortlet;
import org.apache.velocity.context.Context;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;

import de.ingrid.mdek.MdekKeysSecurity;
import de.ingrid.mdek.caller.IMdekCallerSecurity;
import de.ingrid.mdek.caller.MdekCallerSecurity;
import de.ingrid.mdek.persistence.db.model.UserData;
import de.ingrid.mdek.util.MdekUtils;
import de.ingrid.portal.hibernate.HibernateUtil;
import de.ingrid.utils.IngridDocument;


/**
 * This portlet handles the entry to the mdek application
 *
 * @author michael.benz@wemove.com
 */
public class MdekEntryPortlet extends GenericVelocityPortlet {

    private final static Log log = LogFactory.getLog(MdekEntryPortlet.class);

    // VIEW TEMPLATES
    private final static String TEMPLATE_START = "/WEB-INF/templates/mdek/mdek_entry.vm";

    // Parameters set on init
    private UserManager userManager;
    private RoleManager roleManager;
	IMdekCallerSecurity mdekCallerSecurity;

    public void init(PortletConfig config) throws PortletException {
    	super.init(config);

    	mdekCallerSecurity = MdekCallerSecurity.getInstance();

        userManager = (UserManager) getPortletContext().getAttribute(CommonPortletServices.CPS_USER_MANAGER_COMPONENT);
        if (null == userManager) {
            throw new PortletException("Failed to find the User Manager on portlet initialization");
        }
        roleManager = (RoleManager) getPortletContext().getAttribute(CommonPortletServices.CPS_ROLE_MANAGER_COMPONENT);
        if (null == roleManager) {
            throw new PortletException("Failed to find the Role Manager on portlet initialization");
        }

    	// Add the user and role manager to the context
    	// This has to be done so we can access the jetspeed managers in the mdek app
        getPortletContext().setAttribute(CommonPortletServices.CPS_USER_MANAGER_COMPONENT, userManager);
    	getPortletContext().setAttribute(CommonPortletServices.CPS_ROLE_MANAGER_COMPONENT, roleManager);
    }


    public void doView(javax.portlet.RenderRequest request, javax.portlet.RenderResponse response)
            throws PortletException, IOException {
    	Context context = getContext(request);
    	
    	String userName = request.getRemoteUser();
    	try {
    		if (hasUserAccessToMdekAdmin(userName)) {
    			context.put("showMdekAdmin", true);    		
    		} else {
    			context.put("showMdekAdmin", false);
    		}
    	} catch (SecurityException e) {
    		log.debug(e);
    	}
    	
    	// get auto startup parameter from request
    	String nodeType = request.getParameter("nodeType");
    	String nodeId = request.getParameter("nodeId");
    	String autoStartQueryString = "";
    	if (nodeType != null && nodeType.length() > 0) {
    		autoStartQueryString = "nodeType=" + nodeType;
    	}
    	if (nodeId != null && nodeId.length() > 0) {
    		if (autoStartQueryString.length() > 0) {
    			autoStartQueryString = autoStartQueryString + "&";
    		}
			autoStartQueryString = autoStartQueryString + "nodeId=" + nodeId;
    	}
    	context.put("autoStartQueryString", autoStartQueryString);

    	setDefaultViewPage(TEMPLATE_START);
        super.doView(request, response);
	}

    public void processAction(ActionRequest request, ActionResponse actionResponse) throws PortletException,
            IOException {
    }
    
    private boolean hasUserAccessToMdekAdmin(String userName) throws SecurityException, PortletException {
    	if (!roleManager.isUserInRole(userName, "mdek")) {
    		return false;
    	}

    	Session s = HibernateUtil.currentSession();
    	s.beginTransaction();
    	UserData userData = (UserData) s.createCriteria(UserData.class).add(Restrictions.eq("portalLogin", userName)).uniqueResult();
    	s.getTransaction().commit();
    	HibernateUtil.closeSession();

    	// Check for the idcRole of the user
    	IngridDocument response = null;
    	try {
    		response = mdekCallerSecurity.getUserDetails(userData.getPlugId(), userData.getAddressUuid(), userData.getAddressUuid());

    	} catch (Exception e) {
			throw new PortletException ("The connection to the iPlug with id '"+userData.getPlugId()+"' could not be established.", e);    		
    	}

    	IngridDocument userDoc = MdekUtils.getResultFromResponse(response);

		try {
			Integer role = (Integer) userDoc.get(MdekKeysSecurity.IDC_ROLE);
			return (role == 1 || role == 2);

		} catch (Exception e) {
			throw new PortletException ("The connection to the iPlug with id '"+userData.getPlugId()+"' could not be established. The user with name '"+userName+"' and addressUuid '"+userData.getAddressUuid()+"' could not be found by the iPlug.", e);
		}
    }
}