/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.jetspeed.security.impl.shibboleth;

import java.io.IOException;
import java.security.Principal;
import java.util.Enumeration;

import javax.security.auth.Subject;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.jetspeed.Jetspeed;
import org.apache.jetspeed.PortalReservedParameters;
import org.apache.jetspeed.audit.AuditActivity;
import org.apache.jetspeed.components.ComponentManager;
import org.apache.jetspeed.container.session.PortalSessionValidationFilter;
import org.apache.jetspeed.login.LoginConstants;
import org.apache.jetspeed.login.filter.PortalRequestWrapper;
import org.apache.jetspeed.security.AuthenticationProvider;
import org.apache.jetspeed.security.SecurityException;
import org.apache.jetspeed.security.SubjectHelper;
import org.apache.jetspeed.security.User;
import org.apache.jetspeed.security.UserManager;
import org.apache.jetspeed.security.UserSubjectPrincipal;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ShibbolethPortalFilter implements Filter
{
    private static final Logger log = LoggerFactory.getLogger(ShibbolethPortalFilter.class);
	protected String userNameHeader;
	protected String roleNameHeader;
	protected String[] adminNameHeader;
	protected String[] roleNamesToMapToAdminPortal;

	protected Object sem = new Object();

	public void init(FilterConfig filterConfig) throws ServletException
	{
	}

	public void doFilter(ServletRequest sRequest, ServletResponse sResponse, FilterChain filterChain) throws IOException, ServletException
	{
        ComponentManager cm = Jetspeed.getComponentManager();
		AuthenticationProvider authProvider = cm.lookupComponent("org.apache.jetspeed.security.AuthenticationProvider");
		if (sRequest instanceof HttpServletRequest)
		{
			HttpServletRequest request = (HttpServletRequest) sRequest;
            HttpSession httpSession = PortalSessionValidationFilter.getValidSession(request);
			if (userNameHeader == null)
			{
				synchronized (sem)
				{
					ShibbolethConfiguration config = cm.lookupComponent("org.apache.jetspeed.security.shibboleth.ShibbolethConfiguration");
					userNameHeader = config.getHeaderMapping().get(ShibbolethConfiguration.USERNAME);
					roleNameHeader = config.getHeaderMapping().get(ShibbolethConfiguration.ROLENAME);
					adminNameHeader = config.getHeaderMapping().get(ShibbolethConfiguration.ADMINNAME).split(";");
					roleNamesToMapToAdminPortal = config.getHeaderMapping().get(ShibbolethConfiguration.ROLENAMESTOMAP).split(";");
				}
			}
			String username = request.getHeader(userNameHeader);
			if (username != null && !username.isEmpty() && isAdminUser(username))
			{
				if (log.isDebugEnabled()) {
					log.debug("username found which will be matched to admin: " + username);
				}
				UserManager userManager = cm.lookupComponent("org.apache.jetspeed.security.UserManager");
				try {
					User admin = userManager.getUser("admin");
					Subject subject = userManager.getSubject(admin);
					sRequest = wrapperRequest(request, subject, admin);
				} catch (SecurityException e) {
					log.error("Could not get subject of user 'admin'!", e);
				}
			}
			else if (username != null)
			{
				log.debug("username found: " + username);
				
				Subject subject = (Subject) request.getSession().getAttribute(PortalReservedParameters.SESSION_KEY_SUBJECT);
				if (subject != null)
				{
					Principal principal = SubjectHelper.getPrincipal(subject, UserSubjectPrincipal.class);
					if (principal != null)
					{
						if (principal.getName().equals(username))
						{
							sRequest = wrapperRequest(request, subject, principal);
							if (filterChain != null)
							{
								filterChain.doFilter(sRequest, sResponse);
								return;
							}
						}
					}
				}
				UserManager userManager = cm.lookupComponent("org.apache.jetspeed.security.UserManager");
				AuditActivity audit = cm.lookupComponent("org.apache.jetspeed.audit.AuditActivity");
				ShibbolethConfiguration config = cm.lookupComponent(
						"org.apache.jetspeed.security.shibboleth.ShibbolethConfiguration");
				boolean success = false;
				if (config.isAuthenticate())
				{
					try
					{
						// wemove: NO authentification, already authenticated  
						//!!! authProvider.authenticate(username, username);
						success = true;
					}
					catch (Exception e) //(SecurityException e)
					{
						throw new ServletException();
					}
				}
				else
				{
					try
					{
						// load the user principals (roles, groups, credentials)
						User user = userManager.getUser(username);
						if (user != null)
						{
							subject = userManager.getSubject(user);
						}
						success = true;
					}
					catch (SecurityException sex)
					{
						success = false;
						sRequest = wrapperRequest(request, subject, null);
					}
				}
				if (success)
				{
					audit.logUserActivity(username, request.getRemoteAddr(), AuditActivity.AUTHENTICATION_SUCCESS, "ShibbolethFilter");					
					/*PortalAuthenticationConfiguration authenticationConfiguration =
							cm.lookupComponent("org.apache.jetspeed.administration.PortalAuthenticationConfiguration");
					if (authenticationConfiguration.isCreateNewSessionOnLogin() && httpSession != null && !httpSession.isNew())
					{
						request.getSession().invalidate();
					}
					else
					{
                        UserContentCacheManager userContentCacheManager = cm.lookupComponent("userContentCacheManager");
                        userContentCacheManager.evictUserContentCache(username, request.getSession().getId());
					}*/
					subject = null;
					try
					{
						// load the user principals (roles, groups, credentials)
						User user = userManager.getUser(username);
						if (user != null)
						{
							subject = userManager.getSubject(user);
						}
					}
					catch (SecurityException sex)
					{
					}
					Principal principal = SubjectHelper.getPrincipal(subject, User.class);
					sRequest = wrapperRequest(request, subject, principal);
					request.getSession().removeAttribute(LoginConstants.ERRORCODE);
					HttpSession session = request.getSession(true);
					session.setAttribute(PortalReservedParameters.SESSION_KEY_SUBJECT, subject);
				}
				else
				{
					audit.logUserActivity(username, request.getRemoteAddr(), AuditActivity.AUTHENTICATION_FAILURE, "ShibbolethFilter");
					request.getSession().setAttribute(LoginConstants.ERRORCODE, LoginConstants.ERROR_INVALID_PASSWORD);
				}
			}
			else
			{
				if (log.isDebugEnabled()) {
					String header = "";
                    Enumeration headerNames = request.getHeaderNames();
                    while (headerNames.hasMoreElements()) 
                        header += headerNames.nextElement() + ";";
					log.debug("username not found! Header: " + header);
				}

				Subject subject = (Subject) request.getSession().getAttribute(PortalReservedParameters.SESSION_KEY_SUBJECT);
				if (subject != null)
				{
					Principal principal = SubjectHelper.getPrincipal(subject, User.class);
					ShibbolethConfiguration config = Jetspeed.getComponentManager().lookupComponent(
							"org.apache.jetspeed.security.shibboleth.ShibbolethConfiguration");
					if (principal != null && principal.getName().equals(config.getGuestUser()))
					{
					}
					else
					{
						sRequest = wrapperRequest(request, subject, principal);
					}
				}
			}
			sRequest.setAttribute(PortalReservedParameters.PORTAL_FILTER_ATTRIBUTE, "true");
			if (username != null) {
				sRequest.setAttribute("de.ingrid.user.auth.info", username);
				sRequest.setAttribute("de.ingrid.user.auth.isAdminPartner", checkForAdminPortalRole(request));
			}
			if (log.isDebugEnabled()) {
				showRequestHeader(request);
			}
		}

		if (filterChain != null)
		{
			filterChain.doFilter(sRequest, sResponse);
		}
	}

	private void showRequestHeader(HttpServletRequest request) {
		Enumeration headerNames = request.getHeaderNames();
        log.debug("HEADER INFORMATION");
		while (headerNames.hasMoreElements()) { 
            String header = (String) headerNames.nextElement();
            String value = request.getHeader(header);
            log.debug(header + ": " + value);
        }
		
	}

	private Boolean checkForAdminPortalRole(HttpServletRequest request) {
		String rolesInRequest = request.getHeader(roleNameHeader);
		if (rolesInRequest == null) return false; 
		
		for (String role : roleNamesToMapToAdminPortal) {
			if (role.equals(rolesInRequest))
				return true;
		}
		return false;
	}

	private boolean isAdminUser(String username) {
		for (String name: this.adminNameHeader) {
			if (username.equals(name)) return true;
		}
		return false;
	}

	private ServletRequest wrapperRequest(HttpServletRequest request, Subject subject, Principal principal)
	{
		PortalRequestWrapper wrapper = new PortalRequestWrapper(request, subject, principal);
		return wrapper;
	}

	public void destroy()
	{
	}
}
