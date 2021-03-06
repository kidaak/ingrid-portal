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
package de.ingrid.portal.portlets.myportal;

import java.io.IOException;
import java.security.Principal;
import java.util.HashMap;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.PortletPreferences;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.apache.portals.bridges.velocity.GenericVelocityPortlet;
import org.apache.velocity.context.Context;

import de.ingrid.portal.config.IngridSessionPreferences;
import de.ingrid.portal.config.PortalConfig;
import de.ingrid.portal.forms.SearchSettingsForm;
import de.ingrid.portal.global.IngridPersistencePrefs;
import de.ingrid.portal.global.IngridResourceBundle;
import de.ingrid.portal.global.Settings;
import de.ingrid.portal.global.Utils;

/**
 * TODO Describe your created type (class, etc.) here.
 *
 * @author joachim@wemove.com
 */
public class MyPortalPersonalizeSearchSettingsPortlet extends GenericVelocityPortlet {

    /**
     * @see org.apache.portals.bridges.velocity.GenericVelocityPortlet#doView(javax.portlet.RenderRequest, javax.portlet.RenderResponse)
     */
    public void doView(RenderRequest request, RenderResponse response) throws PortletException, IOException {
        Context context = getContext(request);
        
        IngridResourceBundle messages = new IngridResourceBundle(getPortletConfig().getResourceBundle(request.getLocale()), request.getLocale());
        context.put("MESSAGES", messages);

        String partnerRestriction = PortalConfig.getInstance().getString(
                PortalConfig.PORTAL_SEARCH_RESTRICT_PARTNER);
        if (partnerRestriction != null && partnerRestriction.length() > 0) {
            context.put("onePartnerOnly", "true");
        }

        PortletPreferences prefs = request.getPreferences();
        String titleKey = prefs.getValue("titleKey", "personalize.settings.title.rankingAndGrouping");
        response.setTitle(messages.getString(titleKey));
        
        SearchSettingsForm f = (SearchSettingsForm) Utils.getActionForm(request, SearchSettingsForm.SESSION_KEY, SearchSettingsForm.class);

        String cmd = request.getParameter("cmd");
        if (cmd == null) {
            f.clear();
            Principal principal = request.getUserPrincipal();
            HashMap searchSettings = (HashMap)IngridPersistencePrefs.getPref(principal.getName(), IngridPersistencePrefs.SEARCH_SETTINGS);
            // get default settings if settings never have been set
            if (searchSettings == null) {
                searchSettings = Utils.getSessionPreferences(request, IngridSessionPreferences.SESSION_KEY, IngridSessionPreferences.class);
            }
            if (searchSettings != null) {
                f.setInput(SearchSettingsForm.FIELD_RANKING, (String)searchSettings.get(IngridSessionPreferences.SEARCH_SETTING_RANKING));
                f.setInput(SearchSettingsForm.FIELD_GROUPING, (String)searchSettings.get(IngridSessionPreferences.SEARCH_SETTING_GROUPING));
                f.setInput(SearchSettingsForm.FIELD_INCL_META, (String)searchSettings.get(IngridSessionPreferences.SEARCH_SETTING_INCL_META));
            }
        }
        
        context.put("actionForm", f);
        
        super.doView(request, response);
    }

    /**
     * @see org.apache.portals.bridges.velocity.GenericVelocityPortlet#processAction(javax.portlet.ActionRequest, javax.portlet.ActionResponse)
     */
    public void processAction(ActionRequest request, ActionResponse actionResponse) throws PortletException, IOException {
        String action = request.getParameter("action");
        actionResponse.setRenderParameter("cmd", action);
        
        if (action == null) {
            action = "";
        }
        SearchSettingsForm f = (SearchSettingsForm) Utils.getActionForm(request, SearchSettingsForm.SESSION_KEY, SearchSettingsForm.class);
        
        if (action.equalsIgnoreCase(Settings.PARAMV_ACTION_SUBMIT)) {

            f.clearErrors();
            f.populate(request);
            if (!f.validate()) {
                return;
            }
            
            f.setError("", "personalize.settings.message.settings.stored");
        } else if (action.equalsIgnoreCase(Settings.PARAMV_ACTION_ORIGINAL_SETTINGS)) {
            f.init();
            f.setError("", "personalize.settings.message.settings.resetted");
        }

        Principal principal = request.getUserPrincipal();
        
        HashMap searchSettings = new HashMap();
        searchSettings.put(IngridSessionPreferences.SEARCH_SETTING_RANKING, f.getInput(SearchSettingsForm.FIELD_RANKING));
        searchSettings.put(IngridSessionPreferences.SEARCH_SETTING_GROUPING, f.getInput(SearchSettingsForm.FIELD_GROUPING));
        searchSettings.put(IngridSessionPreferences.SEARCH_SETTING_INCL_META, f.getInput(SearchSettingsForm.FIELD_INCL_META));
        //update the session preference with the persistent data
        IngridSessionPreferences sessionPrefs = Utils.getSessionPreferences(request, IngridSessionPreferences.SESSION_KEY, IngridSessionPreferences.class);
        if (sessionPrefs != null) {
            sessionPrefs.putAll(searchSettings);
        }
        
        IngridPersistencePrefs.setPref(principal.getName(), IngridPersistencePrefs.SEARCH_SETTINGS, searchSettings);
    }

    
    
    
}
