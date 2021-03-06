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
package de.ingrid.portal.portlets;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletException;
import javax.portlet.PortletPreferences;

import org.apache.portals.bridges.velocity.GenericVelocityPortlet;
import org.apache.velocity.context.Context;

import de.ingrid.iplug.sns.utils.DetailedTopic;
import de.ingrid.portal.global.IngridResourceBundle;
import de.ingrid.portal.global.Settings;
import de.ingrid.portal.global.Utils;
import de.ingrid.portal.global.UtilsString;
import de.ingrid.portal.interfaces.impl.DBAnniversaryInterfaceImpl;
import de.ingrid.portal.search.SearchState;
import de.ingrid.utils.IngridHitDetail;
import de.ingrid.utils.udk.UtilsDate;

public class ChronicleTeaserPortlet extends GenericVelocityPortlet {

    public void init(PortletConfig config) throws PortletException {
        super.init(config);
    }

    public void doView(javax.portlet.RenderRequest request, javax.portlet.RenderResponse response)
            throws PortletException, IOException {
        Context context = getContext(request);

        IngridResourceBundle messages = new IngridResourceBundle(getPortletConfig().getResourceBundle(
                request.getLocale()), request.getLocale());
        context.put("MESSAGES", messages);

        PortletPreferences prefs = request.getPreferences();
        String titleKey = prefs.getValue("titleKey", "chronicle.teaser.title");
        response.setTitle(messages.getString(titleKey));

        // NOTICE: WE FETCH FROM DATABASE AND DON'T HAVE ALL DETAILS !!!
        String lang = Utils.checkSupportedLanguage(request.getLocale().getLanguage());
        IngridHitDetail[] details = DBAnniversaryInterfaceImpl.getInstance().getAnniversaries(new Date(), lang);

        HashMap result = new HashMap();
        if (details.length > 0) {
            int entry = (int) (Math.random() * details.length);
            DetailedTopic detail = (DetailedTopic) details[entry];
            result.put("title", detail.getTopicName());
            // type NOT IN DATABASE 
            /*
             try {
             String urlWithType = (String) detail.getArrayList(DetailedTopic.INSTANCE_OF).get(0);
             String type = urlWithType.split("#")[1].split("Type")[0];
             result.put("type", type);
             } catch (Exception ex) {
             }
             */
            result.put("topicId", detail.get("topicId"));
            String topicFrom = detail.getFrom();
            if (topicFrom != null) {
                result.put("from", UtilsDate.parseDateToLocale(topicFrom, request.getLocale()));
            }
            String topicTo = detail.getTo();
            if (topicTo != null && !topicTo.equals(topicFrom)) {
                result.put("to", UtilsDate.parseDateToLocale(topicTo, request.getLocale()));
            }
            if (topicFrom != null) {
                int years = UtilsDate.yearsBetween(topicFrom, new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
                result.put("years", new Integer(years));
            }
            // fetch search term
            // TODO use longest word as sns search term ? us title if bug in iPlug is resolved, see INGRID-901 ?
            result.put("term", UtilsString.getSearchTerm(detail.getTopicName(), " "));
            //result.put("term", detail.getTopicName());

            /*
             String searchData = (String) detail.get(DetailedTopic.ASSICIATED_OCC);
             if (searchData != null) {
             String searchTerm = searchData;
             int endIndex = searchData.indexOf(',');
             if (endIndex != -1) {
             searchTerm = searchData.substring(0, endIndex);
             }
             if (searchTerm.charAt(0) == '"') {
             searchTerm = searchTerm.substring(1, searchTerm.length());
             }
             if (searchTerm.charAt(searchTerm.length() - 1) == '"') {
             searchTerm = searchTerm.substring(0, searchTerm.length() - 1);
             }
             result.put("term", searchTerm);
             } else {
             result.put("term", detail.getTopicName());
             }
             */
            /*
             ArrayList list = detail.getArrayList(DetailedTopic.INSTANCE_OF);
             System.out.println(list);
             */
        }

        context.put("snsAnniversary", result);
        super.doView(request, response);
    }

    public void processAction(ActionRequest request, ActionResponse actionResponse) throws PortletException,
            IOException {

        // redirect to our page with URL parameters for bookmarking
        actionResponse.sendRedirect(actionResponse.encodeURL(Settings.PAGE_CHRONICLE + SearchState.getURLParamsCatalogueSearch(request, null)));
    }
}
