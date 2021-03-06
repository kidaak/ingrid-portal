/*
 * **************************************************-
 * Ingrid Portal Apps
 * ==================================================
 * Copyright (C) 2014 - 2015 wemove digital solutions GmbH
 * ==================================================
 * Licensed under the EUPL, Version 1.1 or – as soon they will be
 * approved by the European Commission - subsequent versions of the
 * EUPL (the "Licence");
 * 
 * You may not use this work except in compliance with the Licence.
 * You may obtain a copy of the Licence at:
 * 
 * http://ec.europa.eu/idabc/eupl5
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the Licence is distributed on an "AS IS" basis,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the Licence for the specific language governing permissions and
 * limitations under the Licence.
 * **************************************************#
 */
package de.ingrid.portal.portlets.searchcatalog;

import java.io.IOException;
import java.util.ArrayList;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.PortletSession;

import org.apache.velocity.context.Context;

import de.ingrid.portal.config.PortalConfig;
import de.ingrid.portal.global.CodeListServiceFactory;
import de.ingrid.portal.global.IPlugHelper;
import de.ingrid.portal.global.IPlugHelperDscEcs;
import de.ingrid.portal.global.IngridResourceBundle;
import de.ingrid.portal.global.Settings;
import de.ingrid.portal.global.UtilsVelocity;
import de.ingrid.portal.interfaces.impl.IBUSInterfaceImpl;
import de.ingrid.portal.search.DisplayTreeFactory;
import de.ingrid.portal.search.DisplayTreeNode;
import de.ingrid.portal.search.PageState;
import de.ingrid.utils.PlugDescription;

/**
 * This portlet handles the fragment of the hierarchy browser in the
 * search/catalog section.
 * 
 * @author martin@wemove.com
 */
public class SearchCatalogHierarchyPortlet extends SearchCatalog {

    // VIEW TEMPLATES
    private final static String TEMPLATE_START = "/WEB-INF/templates/search_catalog/search_cat_hierarchy.vm";
    //scroll top value
    private String scrollTop = "0";
    public void doView(javax.portlet.RenderRequest request, javax.portlet.RenderResponse response)
            throws PortletException, IOException {
        
    	IngridResourceBundle messages = new IngridResourceBundle(getPortletConfig().getResourceBundle(
                request.getLocale()), request.getLocale());
       
    	Context context = getContext(request);

        // add velocity utils class
        context.put("tool", new UtilsVelocity());
        //add scolling info
        context.put("scrollTop", scrollTop);
        // set positions in main tab
        context.put(VAR_MAIN_TAB, PARAMV_TAB_HIERARCHY);
        
        context.put("Codelists", CodeListServiceFactory.instance());
        // add request language, used to localize the map client
        context.put("languageCode", request.getLocale().getLanguage());

        setDefaultViewPage(TEMPLATE_START);

        // TODO remove page state in future, when separate portlets
        // use messages and render parameters instead !!!
        PortletSession session = request.getPortletSession();
        PageState ps = (PageState) session.getAttribute("portlet_state");
        if (ps == null) {
            ps = new PageState(this.getClass().getName());
            ps = initPageState(ps);
            session.setAttribute("portlet_state", ps);
        }
        context.put("ps", ps);

        // ----------------------------------
        // check for passed RENDER PARAMETERS and react
        // ----------------------------------
        String action = request.getParameter(Settings.PARAM_ACTION);
        if (action == null) {
            action = "";
        }

        if (ps.get("plugsRoot") == null) {

            // set up ECS plug list for view

            // all iplugs
            PlugDescription[] allPlugs = IBUSInterfaceImpl.getInstance().getAllActiveIPlugs();

            // filter types
            String[] plugTypes = new String[] { Settings.QVALUE_DATATYPE_IPLUG_DSC_ECS,
                    Settings.QVALUE_DATATYPE_IPLUG_DSC_ECS_ADDRESS };
            PlugDescription[] plugs = IPlugHelper.filterIPlugsByType(allPlugs, plugTypes);

            // filter corrupt ones
            plugs = IPlugHelper.filterCorruptECSIPlugs(plugs);

            // filter partners
            String partnerRestriction = PortalConfig.getInstance().getString(
                    PortalConfig.PORTAL_SEARCH_RESTRICT_PARTNER);
            if (partnerRestriction != null && partnerRestriction.length() > 0) {
                ArrayList filter = new ArrayList();
                filter.add(partnerRestriction);
                plugs = IPlugHelper.filterIPlugsByPartner(plugs, filter);
            }

            // sort
            plugs = IPlugHelper.sortPlugs(plugs, new IPlugHelperDscEcs.PlugComparatorECS());

            DisplayTreeNode plugsRoot = DisplayTreeFactory.getTreeFromECSIPlugs(plugs);
            String restrictPartner = PortalConfig.getInstance().getString(PortalConfig.PORTAL_SEARCH_RESTRICT_PARTNER);
            if (restrictPartner != null && restrictPartner.length() > 0) {
                openNodesUntilHierarchyLevel(plugsRoot, plugsRoot);
            }
            ps.put("plugsRoot", plugsRoot);
        }
        response.setTitle(messages.getString("searchCatHierarchy.portlet.title"));
        
        super.doView(request, response);
    }

    public void processAction(ActionRequest request, ActionResponse actionResponse) throws PortletException,
            IOException {
        String action = request.getParameter(Settings.PARAM_ACTION);
        scrollTop = request.getParameter("scrollTop");
        if (action == null) {
            action = "";
        }

        PortletSession session = request.getPortletSession();
        PageState ps = (PageState) session.getAttribute("portlet_state");
        if (ps == null) {
            ps = new PageState(this.getClass().getName());
            ps = initPageState(ps);
            session.setAttribute("portlet_state", ps);
        }

        String submittedReload = request.getParameter("submitReload");

        if (submittedReload != null) {
            initPageState(ps);

        } else if (action.equalsIgnoreCase("doOpenNode")) {
            DisplayTreeNode root = (DisplayTreeNode) ps.get("plugsRoot");
            if (root != null) {
                openNode(root, request.getParameter("nodeId"));
            }

        } else if (action.equalsIgnoreCase("doCloseNode")) {
            DisplayTreeNode root = (DisplayTreeNode) ps.get("plugsRoot");
            if (root != null) {
                DisplayTreeNode node = root.getChild(request.getParameter("nodeId"));
                if (node != null) {
                    node.setOpen(false);
                }
            }

        } else if (action.equalsIgnoreCase(Settings.PARAMV_ACTION_CHANGE_TAB)) {
            // TODO: comment this block???
            // changed main or sub tab
            String newTab = request.getParameter(Settings.PARAM_TAB);
            processTab(actionResponse, newTab);
        }
    }

    private PageState initPageState(PageState ps) {
        ps.put("plugsRoot", null);
        return ps;
    }

    private void openNode(DisplayTreeNode rootNode, String nodeId) {
        DisplayTreeNode node = rootNode.getChild(nodeId);
        if (node != null) {
            node.setOpen(true);

            // only load if not loaded yet !
            if (!node.isLoading() && node.getChildren().size() == 0) {
                node.setLoading(true);

                // handles all stuff
                DisplayTreeFactory.openECSNode(rootNode, node);

                node.setLoading(false);
            }
        }
    }

    /**
     * Open nodes if restrict partner and restrict partner level is set.
     * 
     * @param node
     *            to check for sub nodes
     * @param rootNode
     *            need for open sub nodes by node ID (must always be root node)
     */
    private void openNodesUntilHierarchyLevel(DisplayTreeNode node, DisplayTreeNode rootNode) {
        ArrayList list = new ArrayList();
        list = node.getChildren();
        String rootNodeLevel = PortalConfig.getInstance().getString(PortalConfig.PORTAL_SEARCH_RESTRICT_PARTNER_LEVEL);

        if (rootNodeLevel != null)
            for (int i = 0; i < list.size(); i++) {
                if (node.get("level").toString().equals(rootNodeLevel)) {
                    break;
                }
                DisplayTreeNode subNode = (DisplayTreeNode) list.get(i);
                if ((Boolean) subNode.get("expandable")) {
                    openNode(rootNode, subNode.getId());
                    openNodesUntilHierarchyLevel(subNode, rootNode);
                }
            }
    }
    
}
