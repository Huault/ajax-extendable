package com.huault.action;

import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.jcr.PathNotFoundException;
import javax.jcr.RepositoryException;
import javax.jcr.ValueFormatException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.jahia.ajax.gwt.helper.TemplateHelper;
import org.jahia.bin.Action;
import org.jahia.bin.ActionResult;
import org.jahia.registries.ServicesRegistry;
import org.jahia.services.SpringContextSingleton;
import org.jahia.services.content.JCRNodeIteratorWrapper;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.content.nodetypes.ExtendedNodeType;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.RenderService;
import org.jahia.services.render.Resource;
import org.jahia.services.render.URLResolver;
import org.jahia.services.render.View;
import org.jahia.services.render.scripting.RequestDispatcherScript;
import org.jahia.services.render.scripting.RequestDispatcherScriptFactory;
import org.jahia.services.render.scripting.Script;
import org.jahia.services.render.scripting.bundle.BundleScriptResolver;
import org.json.JSONArray;
import org.json.JSONObject;

public class Extend extends Action{
	
	private static final Logger LOG = Logger.getLogger(Extend.class);
	
	public ActionResult doExecute(HttpServletRequest req,
			RenderContext renderContext, Resource resource,
			JCRSessionWrapper session, Map<String, List<String>> parameters,
			URLResolver urlResolver) throws Exception {
		 
		JCRNodeWrapper node = session.getNodeByUUID(resource.getNode().getIdentifier());
		LOG.debug("Calling Action Extend for node : " + node + " : isRequireAuthenticatedUser= " + isRequireAuthenticatedUser() + " resource : " + resource);
		
		int size = 0;
		if (parameters.containsKey("size")){
			String sizeString =  parameters.get("size").get(0);
			try{
				size = Integer.parseInt(sizeString);
			} catch(NumberFormatException e){}
		}
		int step = 1;
		if (parameters.containsKey("step")){
			String stepString =  parameters.get("step").get(0);
			try{
				step = Integer.parseInt(stepString);
			} catch(NumberFormatException e){}
		}
		
		LOG.debug("Size : " + size + " ; Step : " + step);
				
		int index = 0;
		JSONArray items = new JSONArray();
		JCRNodeIteratorWrapper iter = node.getNodes();
		while (iter.hasNext() && index < (size+step)) {
			try{
				JCRNodeWrapper child = (JCRNodeWrapper) iter.nextNode();
				if (index >= size ){
					LOG.debug("process node " + child + " : "+ child.getPath());
					String value = child.getPropertyAsString("text");
					items.put(value);
					LOG.debug("DEBUG value : " + value);
				}
			} catch (Exception e){
				LOG.error(e);
				if(LOG.isDebugEnabled()){
					items.put("ERROR : " + e.getMessage());
				} else{
					items.put("ERROR");
				}
			}
			index++;
		}
		
		JSONObject json = new JSONObject();
		json.put("items", items);
		
		ActionResult result = new ActionResult(HttpServletResponse.SC_OK, null, json);
		
		return result;

	}
	

}
