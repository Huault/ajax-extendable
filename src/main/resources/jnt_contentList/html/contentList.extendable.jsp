<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="s" uri="http://www.jahia.org/tags/search" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>


<c:if test="${renderContext.editMode}">
	<c:forEach items="${currentNode.nodes}" var="child">
		<template:module node="${child}" />
	</c:forEach>
	<template:module path="*" nodeTypes="jnt:bigText" />
</c:if>

<c:if test="${not renderContext.editMode}">
	<jcr:nodeProperty name="inital_list_size" node="${currentNode}" var="inital_size_value"/>
	<c:set var="inital_size" value="${inital_size_value.long}" />
	<c:if test="${empty inital_size}">
		<c:set var="inital_size" value="3" />
	</c:if>
	
	<jcr:nodeProperty name="extend_list_step" node="${currentNode}" var="extend_step_value"/>
	<c:set var="extend_step" value="${extend_step_value.long}" />
	<c:if test="${empty extend_step}">
		<c:set var="extend_step" value="3" />
	</c:if>
	
	<div id="extendable" >
		<c:set var="index" value="0"/>
		
		<c:forEach items="${currentNode.nodes}" var="child">
			<c:if test="${index < inital_size }">
				<div class="part"><template:module node="${child}" /></div>
				
			</c:if>
			<c:set var="index" value="${index + 1 }"/>
		</c:forEach>
	
		
	</div>
	<div id="more" class="extends">...</div>
	<template:addResources>
		<script>
			$(document).ready(function(){
				
				<c:url var="actionUrl" value="${url.base}${currentNode.path}.extend.do" context="/" />
				
				$( "#more" ).mouseover(function( event ) {
					url = "${actionUrl}";
					var $divExtend = $( "#extendable" );
					var $divMore = $(this);
					
					var $size = $("#extendable").find('div.part').length;
					var form_data =  { 
						size: $size, 
						step: ${extend_step}
					};
					
					$divMore.empty().append("loading...");
					$.post( url, form_data,	function( response ) {
						var output="";
						var count = 0;
						for (var i in response.items) {
							output+= '<div class="part">'+response.items[i]+'</div>' ;
							count++;
					    }
						if (count > 0){
							$divExtend.append(output);
							$divMore.empty().append("...");
						} else {
							$divMore.parent().find("#more").remove();
						}
					} ,"json" );
				});
				
				
			});
			
			
			
			
			
		</script>
	</template:addResources>	
</c:if>


	


