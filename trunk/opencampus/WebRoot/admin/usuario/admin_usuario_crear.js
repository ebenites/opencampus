Event.observe(window, 'load', function() { 
	$$('div.file').each(stylizeInput);   
	$('ptrash').hide();
	Calendar.setup({inputField:"nacimiento", ifFormat:"%d-%m-%Y", singleClick:true});
});

var verify = null;
var usernameTMP = null; 
var usernameTMP2 = false; 
function verificaUsuarioOnKeyUp(texto){
	hideErrorForm('username');
	$('user_ok').setValue('0');
	clearTimeout(verify);
	usernameTMP = texto.value;
	if(!usernameTMP2)usernameTMP2 = usernameTMP; //Este metodo no sirve
	//verify = setTimeout("verificaUsuario('"+texto.value+"')", 1000); INSEGUROOO XSS. Pon esto en el input->'); alert('XSS
	if(usernameTMP2 != usernameTMP)verify = setTimeout("verificaUsuario()", 1000);	
}


///*************************
/*CORRIGE verificaUsuarioOnKeyUp, no debe bloquear si vuelvo a poner ebenitesX, no me deja regresarlo como antes
TMB los mensajes de errores, que no chancke el mensaje de "clave insegura", ya hice que use los mensajes del wforms
***///
function verificaUsuario(){
	try{
		var query = function(transport) {
			//alert(transport.responseText)
			var msg = transport.responseText.strip();
			if(msg == 'OK'){
				$('email_ok').setValue('1');
				hideErrorForm('username');
			}else if(msg == 'USED'){
				showErrorForm('username','Nombre de usuario en uso.');
			}else{
				showErrorForm('username','No fue posible verificar.');
			}
		};
		
		var params = "username="+usernameTMP;
		new Ajax.Request(xGetContextPath()+"/admin/usuario/Verificar.action", { method: 'post', parameters: params, onSuccess: query }); 
	}catch(e){
		if(e.description)
			alert(e.description);
		else
			alert(e);
	}
}

function comparaClave(){
	if(!$F('clave').blank()){
		if($F('clave').length < 6){
			showErrorForm('clave',"Longitud m�nima 6 caracteres.");
			return false;
		}
		hideErrorForm('clave');
		
		if($('clave').getValue() != $('clave2').getValue()){
			showErrorForm('clave2',"Clave no coincide.");
			return false;
		}
	}
	hideErrorForm('clave');
	hideErrorForm('clave2');
	return true;
}

function cargarCombo(combo,accion,subCombo){
	try{	
		if(subCombo){
			for(i=0; i<subCombo.length; i++){
				if(subselect = eval("combo.form."+subCombo[i])){
					clearCombo(subselect);
					$(subselect).disable();
				}
			}
		}
		var select = eval("combo.form."+accion);
		clearCombo(select);
		
		if(combo.selectedIndex != 0){
			var query = function(transport) {     
				var xml = transport.responseXML;
				for (var x = 0; x < xml.getElementsByTagName("item").length; x = x + 1) {
					var item = xml.getElementsByTagName("item")[x];
					
					var codigo = item.getElementsByTagName("codigo")[0].childNodes[0].nodeValue;
					var nombre = item.getElementsByTagName("nombre")[0].childNodes[0].nodeValue;
					
					var newOpt = new Option(nombre, codigo);
					select.options[select.length] = newOpt;
					$(select).enable();
				}
			}
	
			var params = "tipo="+accion+"&ubigeo="+combo.value;
			new Ajax.Request(xGetContextPath()+"/admin/usuario/Ubigeo.action", { method: 'post', parameters: params, onSuccess: query }); 
		}	
	}catch(e){
		if(e.description)
			alert(e.description);
		else
			alert(e);
	}
}

function clearCombo(select){
	if(select){
		for(var a = select.length; a >= 0; a--){
			select.options[a] = null;
		}
		select.options[0] = new Option("Elija un valor","");
		$(select).disable();
	}
}

function stylizeInput (el) {   
    if (!el) return;   
    var input = el.down('input[type=file]');   
    if (input) {   
        el.observe("mousemove", function(event) {   
            input.setStyle({   
                left: (event.pointerX() - this.positionedOffset()['left']) - (input.getWidth() - 30) + 'px'  
            });   
        }).wrap('div', {'class' : 'solidhex-stylized'});   

    }   
}

function setPhoto(file){
	var name = file.value.substring(file.value.lastIndexOf('\\')+1);
	$('plabel').update(name);
	$('ptrash').show();
}
function delPhoto(){
	clearFileInput('photo');
	$('plabel').update('');
	$('ptrash').hide();
}

function clearFileInput(tagId) {
    document.getElementById(tagId).innerHTML = document.getElementById(tagId).innerHTML;
}

function agregarRegla(select){
	var theSel = $(select);
	var theSelSource = $(select+'_source');
	if(theSel && theSelSource){
		var theValue = theSelSource.value;
		if(yaExiste(theValue, theSel)){
			alert("Esta regla ya esta inclu�da en el grupo.");
			return false;
		}
		var theText = theSelSource.options[theSelSource.selectedIndex ].text;
		//theText = theText.substring(0,theText.length-1);
		//theText = theText.substring(theText.lastIndexOf("/")+1);		
		addOption(theSel, theText, theValue);
	}
}

function quitarRegla(select){
	var theSel = $(select);
	if(theSel){
		var selLength = theSel.length;
		for (i = selLength-1; 0<=i; i = i - 1) {
			if (theSel.options[i].selected) {
				deleteOption(theSel, i);
			}
		}
	}
}

function yaExiste(valor, theSel){
	var selLength = theSel.length;
	for (i = selLength-1; 0<=i; i = i - 1) {
		if (theSel.options[i].value === valor) {
			return true;
		}
	}
	return false;
}

function addOption(theSel, theText, theValue) {
	var newOpt = new Option(theText, theValue);
	var selLength = theSel.length;
	theSel.options[selLength] = newOpt;
}

function deleteOption(theSel, theIndex) {
	var selLength = theSel.length;
	if (selLength > 0) {
		theSel.options[theIndex] = null;
	}
}

wf.functionName_formValidation = "myCustomValidation";
function myCustomValidation (evt) {
	if (evt.srcElement.id == 'form_usuario_crear'){
		
		var isValidate = wf.formValidation(evt);
		
		if(!validarAdjunto($('foto').value)){
			showErrorForm('bloque_foto',"&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; Se permiten �nicamente archivos JPG.");
			isValidate = false;
		}else{
			hideErrorForm('bloque_foto');
		}
		
		if($('user_ok')){
		
			if(!comparaClave()){
				isValidate = false;
			}
			
			if($F('user_ok') != '1'){
				showErrorForm('username','Nombre de usuario no v�lido.');
				isValidate = false;
			}else{
				hideErrorForm('username');
			}
			
		}
		
		if(!isValidate)
			return wf.utilities.XBrowserPreventEventDefault(evt);
		
		selectAll($('rols'));
		selectAll($('permisos'));
		$('btn_usuario_crear').disable();
		//return wf.utilities.XBrowserPreventEventDefault(evt);
		//loading();
	}
}

function showErrorForm(id,m){
	/*var msg = $(id+'errMsg');
	if(!msg) msg = new Element('div', { 'id': id+'errMsg' , 'class': 'errMsg' }).update(m);
	$(id).parentNode.appendChild(msg);	
	$(id).addClassName('errFld');
	*/
	wFORMS.behaviors['validation'].showError($(id),m);
}

function hideErrorForm(id){
	/*var msg = $(id+'errMsg');
	if(msg) msg.parentNode.removeChild(msg); 	
	$(id).removeClassName('errFld');*/
	wFORMS.behaviors['validation'].removeErrorMessage($(id));
}

function selectAll(theSel){
	var selLength = theSel.length;
	for (i = 0; i<selLength; i = i + 1) {
		theSel.options[i].selected = true;
	}
}

extArray = new Array(".jpg");
function validarAdjunto(file){
	if(file == "") return true;
	while (file.indexOf("\\") != -1)
	file = file.slice(file.indexOf("\\") + 1);
	ext = file.slice(file.indexOf(".")).toLowerCase();
	for (var i = 0; i < extArray.length; i++) {
		if (extArray[i] == ext) {
			return true;
		}
	}
	//alert("Se permiten �nicamente archivos con la extenci�n: " 
	//+ (extArray.join(" ")) + "\nPor favor, seleccione otro archivo "
	//+ "e intente de nuevo.");
	return false;
}