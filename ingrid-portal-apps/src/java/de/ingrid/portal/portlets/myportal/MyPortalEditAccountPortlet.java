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
import java.util.Map;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.apache.jetspeed.CommonPortletServices;
import org.apache.jetspeed.administration.PortalAdministration;
import org.apache.jetspeed.exception.JetspeedException;
import org.apache.jetspeed.security.InvalidPasswordException;
import org.apache.jetspeed.security.PasswordAlreadyUsedException;
import org.apache.jetspeed.security.PasswordCredential;
import org.apache.jetspeed.security.SecurityException;
import org.apache.jetspeed.security.User;
import org.apache.jetspeed.security.UserManager;
import org.apache.portals.bridges.common.GenericServletPortlet;
import org.apache.portals.bridges.velocity.GenericVelocityPortlet;
import org.apache.velocity.context.Context;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import de.ingrid.portal.config.PortalConfig;
import de.ingrid.portal.forms.AdminUserForm;
import de.ingrid.portal.forms.EditAccountForm;
import de.ingrid.portal.global.IngridResourceBundle;
import de.ingrid.portal.global.Utils;

/**
 * TODO Describe your created type (class, etc.) here.
 *
 * @author joachim@wemove.com
 */
public class MyPortalEditAccountPortlet extends GenericVelocityPortlet {

    private final static Logger log = LoggerFactory.getLogger(MyPortalEditAccountPortlet.class);

    private static final String STATE_ACCOUNT_SAVED = "account_saved";

    private PortalAdministration admin;

    private UserManager userManager;

    private static final String TEMPLATE_ACCOUNT_DONE = "/WEB-INF/templates/myportal/myportal_edit_account_done.vm";

    /**
     * @see org.apache.portals.bridges.velocity.GenericVelocityPortlet#init(javax.portlet.PortletConfig)
     */
    public void init(PortletConfig config) throws PortletException {
        super.init(config);

        admin = (PortalAdministration) getPortletContext()
                .getAttribute(CommonPortletServices.CPS_PORTAL_ADMINISTRATION);
        if (null == admin) {
            throw new PortletException("Failed to find the Portal Administration on portlet initialization");
        }
        userManager = (UserManager) getPortletContext().getAttribute(CommonPortletServices.CPS_USER_MANAGER_COMPONENT);
        if (null == userManager) {
            throw new PortletException("Failed to find the User Manager on portlet initialization");
        }
    }

    /**
     * @see org.apache.portals.bridges.velocity.GenericVelocityPortlet#doView(javax.portlet.RenderRequest, javax.portlet.RenderResponse)
     */
    public void doView(RenderRequest request, RenderResponse response) throws PortletException, IOException {
        Context context = getContext(request);

        IngridResourceBundle messages = new IngridResourceBundle(getPortletConfig().getResourceBundle(
                request.getLocale()), request.getLocale());
        context.put("MESSAGES", messages);

        response.setTitle(messages.getString(messages.getString("account.edit.title")));

        EditAccountForm f = (EditAccountForm) Utils.getActionForm(request, EditAccountForm.SESSION_KEY,
                EditAccountForm.class);

        String cmd = request.getParameter("cmd");

        if (cmd == null) {
            f.clear();
            String userName = request.getUserPrincipal().getName();
            User user;
            try {
                user = userManager.getUser(userName);
                Map<String, String> userAttributes = user.getInfoMap();
                f.setInput(EditAccountForm.FIELD_SALUTATION, replaceNull(userAttributes.get("user.name.prefix")));
                f.setInput(EditAccountForm.FIELD_FIRSTNAME, replaceNull(userAttributes.get("user.name.given")));
                f.setInput(EditAccountForm.FIELD_LASTNAME, replaceNull(userAttributes.get("user.name.family")));
                f.setInput(EditAccountForm.FIELD_EMAIL, replaceNull(userAttributes.get("user.business-info.online.email")));
                f.setInput(EditAccountForm.FIELD_STREET, replaceNull(userAttributes.get("user.business-info.postal.street")));
                f.setInput(EditAccountForm.FIELD_POSTALCODE, replaceNull(userAttributes.get("user.business-info.postal.postalcode")));
                f.setInput(EditAccountForm.FIELD_CITY, replaceNull(userAttributes.get("user.business-info.postal.city")));

                f.setInput(EditAccountForm.FIELD_AGE, replaceNull(userAttributes.get("user.custom.ingrid.user.age.group")));
                f.setInput(EditAccountForm.FIELD_ATTENTION, replaceNull(userAttributes.get(
                        "user.custom.ingrid.user.attention.from")));
                f.setInput(EditAccountForm.FIELD_INTEREST, replaceNull(userAttributes.get("user.custom.ingrid.user.interest")));
                f.setInput(EditAccountForm.FIELD_PROFESSION, replaceNull(userAttributes.get("user.custom.ingrid.user.profession")));
                f.setInput(EditAccountForm.FIELD_SUBSCRIBE_NEWSLETTER, replaceNull(userAttributes.get(
                        "user.custom.ingrid.user.subscribe.newsletter")));

            } catch (SecurityException e) {
                f.setError("", "account.edit.error.user.notfound");
                log.error("Error getting current user.", e);
            }

        } else if (cmd.equals(STATE_ACCOUNT_SAVED)) {
            response.setTitle(messages.getString("account.edited.title"));
            request.setAttribute(GenericServletPortlet.PARAM_VIEW_PAGE, TEMPLATE_ACCOUNT_DONE);
        }

        context.put("actionForm", f);
        
        // show newsletter option if configured that way
        context.put("enableNewsletter", PortalConfig.getInstance().getBoolean(PortalConfig.PORTAL_ENABLE_NEWSLETTER, Boolean.TRUE));
        // show question options
        context.put("enableAccountQuestion", PortalConfig.getInstance().getBoolean(PortalConfig.PORTAL_ENABLE_ACCOUNT_QUESTION, Boolean.TRUE));
        super.doView(request, response);
    }

    /** Replaces the input with "" if input is null. */
    private String replaceNull(String input) {
    	return input == null ? "" : input;
    }

    /**
     * @see org.apache.portals.bridges.velocity.GenericVelocityPortlet#processAction(javax.portlet.ActionRequest, javax.portlet.ActionResponse)
     */
    public void processAction(ActionRequest request, ActionResponse actionResponse) throws PortletException,
            IOException {

        actionResponse.setRenderParameter("cmd", request.getParameter("cmd"));

        EditAccountForm f = (EditAccountForm) Utils.getActionForm(request, EditAccountForm.SESSION_KEY,
                EditAccountForm.class);
        f.clearErrors();
        f.populate(request);
        if (!f.validate()) {
            return;
        }

        String userName = null;
        User user = null;
        try {
            userName = request.getUserPrincipal().getName();
            user = userManager.getUser(userName);
        } catch (JetspeedException e) {
            f.setError("", "account.edit.error.user.notfound");
            log.error("Error getting current user.", e);
            return;
        }

        try {
            user.getSecurityAttributes().getAttribute("user.name.prefix", true).setStringValue(f.getInput(AdminUserForm.FIELD_SALUTATION));
            user.getSecurityAttributes().getAttribute("user.name.given", true).setStringValue(f.getInput(AdminUserForm.FIELD_FIRSTNAME));
            user.getSecurityAttributes().getAttribute("user.name.family", true).setStringValue(f.getInput(AdminUserForm.FIELD_LASTNAME));
            user.getSecurityAttributes().getAttribute("user.business-info.online.email", true).setStringValue(f.getInput(AdminUserForm.FIELD_EMAIL));
            user.getSecurityAttributes().getAttribute("user.business-info.postal.street", true).setStringValue(f.getInput(AdminUserForm.FIELD_STREET));
            user.getSecurityAttributes().getAttribute("user.business-info.postal.postalcode", true).setStringValue(f.getInput(AdminUserForm.FIELD_POSTALCODE));
            user.getSecurityAttributes().getAttribute("user.business-info.postal.city", true).setStringValue(f.getInput(AdminUserForm.FIELD_CITY));

            // theses are not PLT.D values but ingrid specifics
            user.getSecurityAttributes().getAttribute("user.custom.ingrid.user.age.group", true).setStringValue(f.getInput(AdminUserForm.FIELD_AGE));
            user.getSecurityAttributes().getAttribute("user.custom.ingrid.user.attention.from", true).setStringValue(f.getInput(AdminUserForm.FIELD_ATTENTION));
            user.getSecurityAttributes().getAttribute("user.custom.ingrid.user.interest", true).setStringValue(f.getInput(AdminUserForm.FIELD_INTEREST));
            user.getSecurityAttributes().getAttribute("user.custom.ingrid.user.profession", true).setStringValue(f.getInput(AdminUserForm.FIELD_PROFESSION));
            user.getSecurityAttributes().getAttribute("user.custom.ingrid.user.subscribe.newsletter", true).setStringValue(f.getInput(AdminUserForm.FIELD_SUBSCRIBE_NEWSLETTER));

            userManager.updateUser(user);
        } catch (Exception e) {
            if (log.isErrorEnabled()) {
                log.error("Problems saving user.", e);
            }
        }

        try {
            // update password only if a old password was provided
            String oldPassword = f.getInput(EditAccountForm.FIELD_PASSWORD_OLD);
            if (oldPassword != null && oldPassword.length() > 0) {
        		PasswordCredential credential = userManager.getPasswordCredential(user);
        		credential.setPassword(oldPassword, f.getInput(EditAccountForm.FIELD_PASSWORD_NEW));
        		userManager.storePasswordCredential(credential);
            }
        } catch (PasswordAlreadyUsedException e) {
            f.setError(EditAccountForm.FIELD_PASSWORD_NEW, "account.edit.error.password.in.use");
            return;
        } catch (InvalidPasswordException e) {
            f.setError(EditAccountForm.FIELD_PASSWORD_OLD, "account.edit.error.wrong.password");
            return;
        } catch (SecurityException e) {
            f.setError("", "account.edit.error.wrong.password");
            return;
        }

        actionResponse.setRenderParameter("cmd", STATE_ACCOUNT_SAVED);
    }
}
