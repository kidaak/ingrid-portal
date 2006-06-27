/*
 * Copyright (c) 2006 wemove digital solutions. All rights reserved.
 */
package de.ingrid.portal.portlets.myportal;

import java.io.IOException;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.PropertyResourceBundle;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletException;
import javax.portlet.PortletPreferences;
import javax.portlet.PortletRequest;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.jetspeed.CommonPortletServices;
import org.apache.jetspeed.components.portletregistry.PortletRegistry;
import org.apache.jetspeed.exception.JetspeedException;
import org.apache.jetspeed.om.common.portlet.PortletDefinitionComposite;
import org.apache.jetspeed.om.folder.Folder;
import org.apache.jetspeed.om.page.Fragment;
import org.apache.jetspeed.om.page.Page;
import org.apache.jetspeed.om.preference.FragmentPreference;
import org.apache.jetspeed.page.PageManager;
import org.apache.jetspeed.page.PageNotFoundException;
import org.apache.jetspeed.page.PageNotUpdatedException;
import org.apache.jetspeed.page.document.NodeException;
import org.apache.pluto.om.common.Preference;
import org.apache.pluto.om.portlet.PortletDefinition;
import org.apache.portals.bridges.velocity.GenericVelocityPortlet;
import org.apache.velocity.context.Context;

import de.ingrid.portal.global.IngridPersistencePrefs;
import de.ingrid.portal.global.IngridResourceBundle;
import de.ingrid.portal.global.Settings;
import de.ingrid.portal.global.Utils;
import de.ingrid.portal.search.DisplayTreeNode;
import de.ingrid.portal.search.UtilsSearch;

/**
 * TODO Describe your created type (class, etc.) here.
 * 
 * @author joachim@wemove.com
 */
public class MyPortalPersonalizeHomePortlet extends GenericVelocityPortlet {

    private final static Log log = LogFactory.getLog(MyPortalPersonalizeHomePortlet.class);

    private PageManager pageManager;

    private PortletRegistry registry;
    
    private ArrayList rightColumnPortlets = new ArrayList();
    private ArrayList leftColumnPortlets = new ArrayList();

    /**
     * @see org.apache.portals.bridges.velocity.GenericVelocityPortlet#init(javax.portlet.PortletConfig)
     */
    public void init(PortletConfig config) throws PortletException {
        super.init(config);
        pageManager = (PageManager) getPortletContext().getAttribute(CommonPortletServices.CPS_PAGE_MANAGER_COMPONENT);
        if (null == pageManager) {
            throw new PortletException("Failed to find the Page Manager on portlet initialization");
        }
        registry = (PortletRegistry) getPortletContext().getAttribute(CommonPortletServices.CPS_REGISTRY_COMPONENT);
        if (null == registry) {
            throw new PortletException("Failed to find the Portlet Registry on portlet initialization");
        }

    }

    /**
     * @see org.apache.portals.bridges.velocity.GenericVelocityPortlet#doView(javax.portlet.RenderRequest,
     *      javax.portlet.RenderResponse)
     */
    public void doView(RenderRequest request, RenderResponse response) throws PortletException, IOException {

        Context context = getContext(request);
        IngridResourceBundle messages = new IngridResourceBundle(getPortletConfig().getResourceBundle(
                request.getLocale()));
        context.put("MESSAGES", messages);

        PortletPreferences prefs = request.getPreferences();
        String titleKey = prefs.getValue("titleKey", "searchSettings.title.rankingAndGrouping");
        response.setTitle(messages.getString(titleKey));

        Principal principal = request.getUserPrincipal();

        try {
            // get all portlets from the portlet registry
            getIngridPortlet(request);
            
            context.put("rightColumnPortlets", rightColumnPortlets);
            context.put("leftColumnPortlets", leftColumnPortlets);
            
            // get all fragments from the users page
            Page homePage = pageManager.getPage(Folder.USER_FOLDER + principal.getName() + "/default-page.psml");
            Fragment root = homePage.getRootFragment();
            List fragments = root.getFragments();
            ArrayList rightColumnFragments = new ArrayList();
            ArrayList leftColumnFragments = new ArrayList();
            for (int i = 0; i < fragments.size(); i++) {
                Fragment f = (Fragment) fragments.get(i);
                String resourceBundle = registry.getPortletDefinitionByUniqueName(f.getName()).getResourceBundle();
                IngridResourceBundle res = new IngridResourceBundle(PropertyResourceBundle.getBundle(resourceBundle,
                        request.getLocale()));
                HashMap portletProperties = new HashMap();
                portletProperties.put("fragment", f);
                List fragmentPrefs = f.getPreferences();
                for (int j = 0; j < fragmentPrefs.size(); j++) {
                    FragmentPreference pref = (FragmentPreference) fragmentPrefs.get(j);
                    String name = pref.getName();
                    if (name.equals("titleKey")) {
                        portletProperties.put("title", res.getString((String) pref.getValueList().get(0)));
                    }
                }
                if (f.getLayoutColumn() == 0) {
                    Utils.ensureArraySize(leftColumnFragments, f.getLayoutRow() + 1);
                    leftColumnFragments.set(f.getLayoutRow(), portletProperties);
                } else if (f.getLayoutColumn() == 1) {
                    Utils.ensureArraySize(rightColumnFragments, f.getLayoutRow() + 1);
                    rightColumnFragments.set(f.getLayoutRow(), portletProperties);
                }
            }
            context.put("rightColumnFragments", rightColumnFragments);
            context.put("leftColumnFragments", leftColumnFragments);
        } catch (PageNotFoundException e) {
            log.error("Error page not found '" + Folder.USER_FOLDER + principal.getName() + "/default-page.psml" + "'",
                    e);
            context.put("errorcode", "ERROR_GETTING_HOME_PAGE");
        } catch (NodeException e) {
            log
                    .error("Error getting page '" + Folder.USER_FOLDER + principal.getName() + "/default-page.psml"
                            + "'", e);
            context.put("errorcode", "ERROR_GETTING_HOME_PAGE");
        }

        super.doView(request, response);
    }

    /**
     * @see org.apache.portals.bridges.velocity.GenericVelocityPortlet#processAction(javax.portlet.ActionRequest,
     *      javax.portlet.ActionResponse)
     */
    public void processAction(ActionRequest request, ActionResponse actionResponse) throws PortletException,
            IOException {
        Principal principal = request.getUserPrincipal();

        String action = request.getParameter(Settings.PARAM_ACTION);
        if (action == null) {
            action = "";
        }

        try {
            if (action.equalsIgnoreCase("doOriginalSettings")) {
                // get ingrid portlets from the portlet registry
                Page homePage = pageManager.getPage(Folder.USER_FOLDER + principal.getName() + "/default-page.psml");
                Fragment root = homePage.getRootFragment();
                List fragments = root.getFragments();
                

            } else {
                Page homePage = pageManager.getPage(Folder.USER_FOLDER + principal.getName() + "/default-page.psml");
                // TODO:
                // iterate over the left portlets
                  // get the configured portlet from the request params
                  // if 'none' remove the fragment with this position from the page
                  // find the portlet in the current page
                  // move the portlet to the configured position
                  // if not found add the portlet to the fragmenet at the spwcified position (see LayoutPortlet)
                
                // remove ragment structure
                homePage.removeFragmentById(homePage.getRootFragment().getId());
                
                
                
                // build new fragment structure
                
                
                // remove all  
                pageManager.newPortletFragment();
                
                Fragment root = homePage.getRootFragment();
                List fragments = root.getFragments();
                ArrayList rightColumnFragments = new ArrayList();
                ArrayList leftColumnFragments = new ArrayList();
                for (int i = 0; i < fragments.size(); i++) {
                    Fragment f = (Fragment) fragments.get(i);
                    if (f.getLayoutColumn() == 0) {
                        Utils.ensureArraySize(rightColumnFragments, f.getLayoutRow() + 1);
                        rightColumnFragments.set(f.getLayoutRow(), f);
                    } else if (f.getLayoutColumn() == 1) {
                        Utils.ensureArraySize(leftColumnFragments, f.getLayoutRow() + 1);
                        leftColumnFragments.set(f.getLayoutRow(), f);
                    }
                }

                boolean isHidden = true;
                for (int i = 0; i < leftColumnFragments.size(); i++) {
                    Fragment f = (Fragment) leftColumnFragments.get(i);
                    isHidden = true;
                    for (int j = 0; j < leftColumnFragments.size(); j++) {
                        String slotId = request.getParameter("c1r" + j);
                        if (slotId.equals(f.getId())) {
                            f.setLayoutRow(j);
                            isHidden = false;
                        }
                    }
                    if (isHidden) {
                    }
                }
                pageManager.updatePage(homePage);
            }

        } catch (PageNotFoundException e) {
            log.error("Error page not found '" + Folder.USER_FOLDER + principal.getName() + "/default-page.psml" + "'",
                    e);
        } catch (NodeException e) {
            log
                    .error("Error getting page '" + Folder.USER_FOLDER + principal.getName() + "/default-page.psml"
                            + "'", e);
        } catch (PageNotUpdatedException e) {
            log.error("Error updating page '" + Folder.USER_FOLDER + principal.getName() + "/default-page.psml" + "'",
                    e);
        } catch (JetspeedException e) {
            log.error("General Error handling '" + Folder.USER_FOLDER + principal.getName() + "/default-page.psml"
                    + "'", e);
        }
    }
    
    private void getIngridPortlet(PortletRequest request) {
        Collection portletDefs = registry.getPortletApplication("ingrid-portal-apps").getPortletDefinitions();
        Iterator it = portletDefs.iterator();

        while (it.hasNext()) {
            PortletDefinitionComposite portlet = (PortletDefinitionComposite) it.next();
            Preference p = portlet.getPreferenceSet().get("portlet-type");
            if (p != null) {
                String type = (String) p.getValues().next();
                p = portlet.getPreferenceSet().get("default-vertical-position");
                int defaultPos = Integer.parseInt((String) p.getValues().next());
                String resourceBundle = portlet.getResourceBundle();
                IngridResourceBundle res = new IngridResourceBundle(PropertyResourceBundle.getBundle(
                        resourceBundle, request.getLocale()));
                p = portlet.getPreferenceSet().get("titleKey");
                String portletTitle = res.getString((String) p.getValues().next());
                if (type.equals("ingrid-home")) {
                    HashMap portletProperties = new HashMap();
                    portletProperties.put("portlet", portlet);
                    portletProperties.put("title", portletTitle);
                    synchronized (this) {
                        Utils.ensureArraySize(leftColumnPortlets, defaultPos + 1);
                        leftColumnPortlets.set(defaultPos, portletProperties);
                    }
                } else if (type.equals("ingrid-home-marginal")) {
                    HashMap portletProperties = new HashMap();
                    portletProperties.put("portlet", portlet);
                    portletProperties.put("title", portletTitle);
                    synchronized (this) {
                        Utils.ensureArraySize(rightColumnPortlets, defaultPos + 1);
                        rightColumnPortlets.set(defaultPos, portletProperties);
                    }
                }
            }
        }
        
    }
    
    private void removeFragmentByPosition(Page page, int x, int y) {
        //TODO: implement
    }
    
    private void moveFragmentToPosition(Page page, Fragment fragment, int x, int y) {
        //TODO: implement
    }

    private void addPortletToPosition(Page page, String portletUniqueName, int x, int y) {
        //TODO: implement
    }
    
}
