<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page errorPage="/error_action.jsp"%>
<%@page import="edu.opencampus.lms.modelo.Usuario"%>
<%@page import="edu.opencampus.lms.modelo.usuario.Persona"%>
<%@page import="edu.opencampus.lms.util.Formato"%>
<%@page import="edu.opencampus.lms.modelo.usuario.Rol"%>
<%@page import="edu.opencampus.lms.util.Constante"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ct" uri="/WEB-INF/CampusTags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="contextPath" value='${pageContext.request.contextPath}' />

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<s:include value="/comun/jslibs.jsp"/>
		
		<script language="javascript" type="text/javascript"
			src="<%=request.getContextPath()%>/js/passwordmeter.js"></script>
		<script language="javascript" type="text/javascript" 
			src='<%=request.getContextPath()%>/comun/misdatos/misdatos.js'></script>
			
	</head>
	<body>
		<div id="container">
		
			<s:include value="/comun/bienvenida.jsp"/>
			
			<div id="body">
			
					<%
						Usuario usuario = (Usuario) request.getSession().getAttribute(Constante.USUARIO_ACTUAL);
						Persona p = usuario.getPersona();
						//Empresa e = usuario.getEmpresa(); 
					%>
			
					<s:include value="/error_message.jsp"/>
			
					<table width="100%" cellpadding="3" cellspacing="0" class="open_table">
						<caption><s:text name="portal.misdatos.titulo"/> </caption> 
						<tbody>
							<tr>
								<td class="border-right" width="100" >
									<b><s:text name="portal.misdatos.contenido.usuario"/></b>
								</td>
								<td class="border-right">
									<%=usuario.getUsuario()%>&nbsp;&nbsp;&nbsp;<font color="#ffffff">(<%=usuario.getIdToString()%>)</font>
								</td>
								<td class="border-right" width="100">
									<b><s:text name="portal.misdatos.contenido.fechanac"/></b>
								</td>
								<td class="border-right">
									<%=Formato.calendarToString(p.getFecnacimiento(),Constante.FECHA_DIA_MES_ANO)%>
								</td>
								<td rowspan="6" align="center" valign="top" width="89">
									<img src="<%=request.getContextPath() %>/MiFoto.action" width="85" border="0"> 
								</td>
							</tr>
							<tr class="line">
								<td class="border-right">
									<b><s:text name="portal.misdatos.contenido.nombres"/></b>
								</td>
								<td class="border-right">
									<%=Formato.formatoTexto(p.getNomuno())%>
									<%=Formato.formatoTexto(p.getNomdos())%>
								</td>
								<td class="border-right">
									<b><s:text name="portal.misdatos.contenido.telefono"/></b>
								</td>
								<td class="border-right" id="telefono">
									<%=Formato.formatoTextoNull(p.getTeldomicilio())%>
								</td>
							</tr>
							<tr >
								<td class="border-right">
									<b><s:text name="portal.misdatos.contenido.paterno"/></b>
								</td>
								<td class="border-right">
									<%=Formato.formatoTexto(p.getApepaterno())%>
								</td>
								<td class="border-right">
									<b><s:text name="portal.misdatos.contenido.celular"/></b>
								</td>
								<td class="border-right">
									<%=Formato.formatoTextoNull(p.getTelcelular())%>&nbsp;
								</td>
							</tr>
							<tr  class="line">
								<td class="border-right">
									<b><s:text name="portal.misdatos.contenido.materno"/></b>
								</td>
								<td class="border-right">
									<%=Formato.formatoTexto(p.getApematerno())%>
								</td>
								<td class="border-right">
									<b><s:text name="portal.misdatos.contenido.direccion"/></b>
								</td>
								<td class="border-right">
									<%=Formato.formatoTextoNull(p.getDirdomicilio())%>
								</td>

							</tr>
							<tr >
								<td class="border-right">
									<b><s:text name="portal.misdatos.contenido.sexo"/></b>
								</td>
								<td class="border-right">
									<%=Formato.formatoTexto(p.getSexoCompleto())%>
								</td>
								<td class="border-right">
									<b><s:text name="portal.misdatos.contenido.ubicacion"/></b>
								</td>
								<td class="border-right">
									<%=Formato.formatoTexto(p.getUbigeo().getNombreCompleto())%>
								</td>
							</tr>
							<tr  class="line">
								<td class="border-right" valign="top">
									<b><s:text name="portal.misdatos.contenido.grupo"/></b>
								</td>
								<td class="border-right" valign="top">
									<%
										for (Rol rol : usuario.getRoles()) {
											out.println(rol.getNombre() + "<br>");
										}
									%>&nbsp;
								</td>
								<td  class="border-right" valign="top">
									<b><s:text name="portal.misdatos.contenido.correo"/></b>
								</td>
								<td  class="border-right" valign="top">
									<div id="theMail"><%
												String[] correos = new String[0];
												if (p.getEmail() != null) {
													correos = p.getEmail().split(",");
													if (correos.length == 1) {
														out.println(correos[0].trim());
													} else {
														for (int u = 0; u < correos.length; u++) {
															out.println(correos[u].trim() + "<br/>");
														}
													}
												}
											%></div>
								</td>
							</tr>
							</tbody>
							<tfoot>
								<tr>
									<td colspan="5" align="right">
										<input value="<s:text name="portal.misdatos.botones.solicitar"/>" 
											type="button" onClick="verPanelCambioDatos()" />
									
										<input value="<s:text name="portal.misdatos.botones.cambiar"/>" type="button"
											onClick="verPanelCambioPassword();"/>
									
										<input onClick="verPanelCambioCorreo();" style="display: none;"
											type="button" value="<s:text name="portal.misdatos.botones.modificar"/>" />
									</td>
								</tr>
							</tfoot>
						</table>
							
							
			</div>
			
			<s:include value="/comun/pie.jsp"/>
			
		</div>
		
		<!--  *******************************  CAMBIAR CLAVE *********************************** -->
		
		<div id="form_div_clave"  style="width: 260px;" class="open_modal" >
			<form id="form_clave" action="<%=request.getContextPath()%>/DatosClave.action" method="post">
			<table width="100%" cellpadding="3" cellspacing="0" class="open_table nogrid">
				<caption><s:text name="portal.misdatos.botones.cambiar.titulo"/></caption>
				<tbody>
					<tr>
						<td width="120" align="right">
							<b><s:text name="portal.misdatos.botones.cambiar.contenido.clave_actual"/></b>
						</td>
						<td>
							<input type="password" name="clave" size="17" maxlength="32" class="required">
						</td>
					</tr>
					<tr>
						<td align="right">
							<b><s:text name="portal.misdatos.botones.cambiar.contenido.nueva_clave"/></b>
						</td>
						<td>
							<input type="password" size="17" maxlength="32" name="claveTemp" class="required" alt="<c:out value="${PASSWORD_LONGITUD_MINIMA}"/>"
								onkeyup="validarClave(this.value);">
						</td>
					</tr>
					<tr>
						<td align="right">
							<b><s:text name="portal.misdatos.botones.cambiar.contenido.confirmar_nueva_clave"/></b>
						</td>
						<td>
							<input type="password" size="17" maxlength="32" name="claveTemp2" class="required">
						</td>
					</tr>
					<tr>
						<td align="right">
							<b><s:text name="portal.misdatos.botones.cambiar.contenido.nivel_seguridad"/></b>
						</td>
						<td>
							<div id="password_level"></div>
						</td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="2" align="right">
							<input type="reset" value="<s:text name="portal.misdatos.botones.cambiar.botones.cancelar"/>" 
								onclick="ocultarPanelCambioPassword();">
							<input type="submit" value="<s:text name="portal.misdatos.botones.cambiar.botones.aceptar"/>">
						</td>
					</tr>
				</tfoot>	
			</table>
			</form>
		</div>
		
		<!-- ************************************  MODIFICAR DATOS *************************************************** -->
		
		<div id="form_div_datos"  style="width: 720px;" class="open_modal">
			<form id="form_datos" action="<%=request.getContextPath()%>/SolicitarCambioDatos.action" method="post" enctype="multipart/form-data">
				<table width="100%" cellpadding="3" cellspacing="0" class="open_table">
					<caption><s:text name="portal.misdatos.botones.solicitar.titulo"/></caption>
					<colgroup>
						<col width="80"/>
						<col/>
						<col width="80"/>
						<col />
						<col width="80"/>
						<col />
					</colgroup>
					<thead>
						<tr>
							<!-- td width="80"></td><td></td><td width="80"></td><td></td><td width="80"></td><td></td></tr><tr-->
							<td colspan="6" align="center"><b><s:text name="portal.misdatos.botones.solicitar.comentario"/></b></td>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>
								<b><s:text name="portal.misdatos.botones.solicitar.contenido.nombres"/></b>
							</td>
							<td>
								<input type="text" name="nombres" size="24" maxlength="200"
									value="<%=Formato.formatoTexto(p.getNomuno())%> <%=Formato.formatoTexto(p.getNomdos())%>" />
							</td>
							<td>
								<b><s:text name="portal.misdatos.botones.solicitar.contenido.paterno"/></b>
							</td>
							<td>
								<input type="text" name="paterno" size="24" maxlength="100"
									value="<%=Formato.formatoTexto(p.getApepaterno())%>" />
							</td>
							<td>
								<b><s:text name="portal.misdatos.botones.solicitar.contenido.materno"/></b>
							</td>
							<td align="left">
								<input type="text" name="materno" size="24" maxlength="100"
									value="<%=Formato.formatoTexto(p.getApematerno())%>" />
							</td>
						</tr>
						<tr class="line">	
							<td>
								<b><s:text name="portal.misdatos.botones.solicitar.contenido.nacimiento"/></b>
							</td>
							<td>
								<input type="text" name="nacimiento" size="24" maxlength="20"
									value="<%=p.getFecnacimientoAsString()%>" />
							</td>
							<td>
								<b><s:text name="portal.misdatos.botones.solicitar.contenido.dni"/></b>
							</td>
							<td>
								<input type="text" name="dni" size="24" maxlength="20"
									value="<%=Formato.formatoTextoNull(p.getDni())%>" />
							</td>
							<td>
								<b><s:text name="portal.misdatos.botones.solicitar.contenido.sexo"/></b>
							</td>
							<td>
								<input type="radio" name="sexo" value="M" <%if(p.getSexo().equals("M"))out.print("checked");%>>Masculino
								<input type="radio" name="sexo" value="F" <%if(p.getSexo().equals("F"))out.print("checked");%>>Femenino	
							</td>
						</tr>
						<tr>	
							<td>
								<b><s:text name="portal.misdatos.botones.solicitar.contenido.email"/></b>
							</td>
							<td>
								<input name="email" type="text" size="24" maxlength="100"
									value="<%=Formato.formatoTextoNull(p.getEmail())%>" />
							</td>
							<td>
								<b><s:text name="portal.misdatos.botones.solicitar.contenido.telefono"/></b>
							</td>
							<td>
								<input name="telefono" type="text" size="24" maxlength="40"
									value="<%=Formato.formatoTextoNull(p.getTeldomicilio())%>" />
							</td>
							<td>
								<b><s:text name="portal.misdatos.botones.solicitar.contenido.celular"/></b>
							</td>
							<td>
								<input  name="celular" type="text" size="24" maxlength="40"
									value="<%=Formato.formatoTextoNull(p.getTelcelular())%>" />
							</td>
						</tr>
						<tr class="line">
							<td>
								<b><s:text name="portal.misdatos.botones.solicitar.contenido.departamento"/></b>
							</td>
							<td>
								<input name="departamento" type="text" size="24" maxlength="100"
									value="<%=p.getUbigeo().getDepartamento()%>" />
							</td>
							<td>
								<b><s:text name="portal.misdatos.botones.solicitar.contenido.provincia"/></b>
							</td>
							<td>
								<input name="provincia" type="text" size="24" maxlength="100"
									value="<%=p.getUbigeo().getProvincia()%>" />
							</td>
							<td>
								<b><s:text name="portal.misdatos.botones.solicitar.contenido.distrito"/></b>
							</td>
							<td>
								<input  name="distrito" type="text" size="24" maxlength="100"
									value="<%=p.getUbigeo().getDistrito()%>" />
							</td>
						</tr>
						<tr>
							<td>
								<b><s:text name="portal.misdatos.botones.solicitar.contenido.direccion"/></b>
							</td>
							<td  colspan="3">
								<input name="direccion" type="text" size="72" maxlength="100" 
									value="<%=Formato.formatoTextoNull(p.getDirdomicilio())%>" />
							</td>
							<td>
								<b><s:text name="portal.misdatos.botones.solicitar.contenido.foto"/></b>
							</td>
							<td>
								<input  name="doc" type="file"  value="" size="8" />
							</td>
						</tr>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="6" align="right">
								<input type="reset" value="<s:text name="portal.misdatos.botones.solicitar.botones.cancelar"/>" onClick="ocultarPanelCambioDatos()">
								<input type="submit" value="<s:text name="portal.misdatos.botones.solicitar.botones.enviar"/>">
							</td>
						</tr>
					</tfoot>
				</table>
			</form>
		</div>
		
		<!-- ********************************************* CORREO ******************************************************* -->
		
		<div id="form_div_correo" style="width: 300px;" class="open_modal">
			<table width="100%" cellpadding="3" cellspacing="0" class="open_table">
				<caption><s:text name="portal.misdatos.botones.modificar.titulo"/></caption>
				<tbody>
					<tr>
						<td>
							<b><s:text name="portal.misdatos.botones.modificar.contenido.correo"/></b>
						</td>
					</tr>
					<tr>
						<td>
							<textarea rows="2" cols="53" id="newMail"><%if(p.getEmail() != null)out.print(p.getEmail());%></textarea>
						</td>
					</tr>
					<tr>
						<td>
							<b><s:text name="portal.misdatos.botones.modificar.comentario"/></b>
						</td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td align="right">
							<input type="reset" value="<s:text name="portal.misdatos.botones.modificar.botones.cancelar"/>" onClick="ocultarPanelCambioCorreo()">
							<input type="button" value="<s:text name="portal.misdatos.botones.modificar.botones.grabar"/>" 
								onclick="grabarCorreo()">
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
		
	</body>
</html>
