package de.ingrid.mdek.servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import de.ingrid.mdek.beans.ProfileBean;
import de.ingrid.mdek.dwr.services.CatalogServiceImpl;
import de.ingrid.mdek.profile.ProfileConverter;

public class ProfileServlet extends HttpServlet {

    /**
     * 
     */
    private static final long serialVersionUID = 2186538892678490988L;

    private PrintWriter out;

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException {
        try {
            // type and encoding has to be set BEFORE writer is fetched!!!
            response.setContentType("text/javascript");
            response.setCharacterEncoding("UTF-8");
            out = response.getWriter();
        } catch (IOException e) {
            // log.error("Could not open PrintWriter.", e);
            throw new ServletException(e);
        }

        String lang = request.getParameter("lang");
        if (lang == null ) lang = "en";
        ProfileConverter converter = new ProfileConverter(out, lang);

        // get bean to access backend
        ServletContext context = getServletContext();
        WebApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(context);
        CatalogServiceImpl catalog = (CatalogServiceImpl) applicationContext.getBean("catalogService");
        ProfileBean profileBean = catalog.getProfileData(request);
        
        out.println("function createAdditionalFieldsDynamically() {");
        //ProfileMapper pM = new ProfileMapper();
        converter.convertProfileBeanToJS(profileBean);
        //out.println("addEmptySpan(\"contentDiv2\");");
        out.println("}");
        
        converter.printVisibilityJSCode(profileBean);

    }
    
}