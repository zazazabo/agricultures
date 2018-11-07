var eText=0;
var tarObject;
var d = new Date();
sYear = d.getFullYear();
sMonth = d.getMonth() + 1;

popup = window.createPopup();
popBody = popup.document.body;
popBody.style.border = "outset   1pt   #cccccc";
popBody.style.fontSize = "9pt";
popBody.style.backgroundColor = "#F7FBFF";
popBody.style.cursor = "hand";
var strPop = "<table   id=\"yMonth\"   author=\"liuzxit\"   border=\"1\"   bordercolorlight=\"#ffffff\"   bordercolordark=\"#ffffff\"   cellpadding=\"1\"   cellspacing=\"0\"   style=\"font-size:9pt;\">";
strPop += "<th   width=\"28\"   bgcolor=\"#101073\"   onclick=\"parent.yearChange(-4)\"   style=\"color:#ffffff;\"><<";
strPop += "<th   width=\"28\"   bgcolor=\"#101073\"   style=\"color:#ffffff\"   onclick=\"parent.selectClicked(this)\">" + (sYear - 2);
strPop += "<th   width=\"28\"   bgcolor=\"#101073\"   style=\"color:#ffffff\"   onclick=\"parent.selectClicked(this)\">" + (sYear - 1);
strPop += "<th   width=\"28\"   bgcolor=\"#ffffff\"   style=\"color:#ff0000\"   onclick=\"parent.selectClicked(this)\">" + sYear;
strPop += "<th   width=\"28\"   bgcolor=\"#101073\"   style=\"color:#ffffff\"   onclick=\"parent.selectClicked(this)\">" + (sYear + 1);
strPop += "<th   width=\"28\"   bgcolor=\"#101073\"   onclick=\"parent.yearChange(4)\"   style=\"color:#ffffff;\">>></th>";
strPop += "<tr   align=\"center\"><td   style=\"border:solid   1pt   #F7FBFF;\"   onmouseover=\"parent.tdMove(this)\"   onmouseout=\"parent.tdOut(this)\"   onclick=\"parent.selectClicked(this)\">1";
strPop += "<td   style=\"border:solid   1pt   #F7FBFF;\"   onmouseover=\"parent.tdMove(this)\"   onmouseout=\"parent.tdOut(this)\"   onclick=\"parent.selectClicked(this)\">2";
strPop += "<td   style=\"border:solid   1pt   #F7FBFF;\"   onmouseover=\"parent.tdMove(this)\"   onmouseout=\"parent.tdOut(this)\"   onclick=\"parent.selectClicked(this)\">3";
strPop += "<td   style=\"border:solid   1pt   #F7FBFF;\"   onmouseover=\"parent.tdMove(this)\"   onmouseout=\"parent.tdOut(this)\"   onclick=\"parent.selectClicked(this)\">4";
strPop += "<td   style=\"border:solid   1pt   #F7FBFF;\"   onmouseover=\"parent.tdMove(this)\"   onmouseout=\"parent.tdOut(this)\"   onclick=\"parent.selectClicked(this)\">5";
strPop += "<td   style=\"border:solid   1pt   #F7FBFF;\"   onmouseover=\"parent.tdMove(this)\"   onmouseout=\"parent.tdOut(this)\"   onclick=\"parent.selectClicked(this)\">6</td></tr>";
strPop += "<tr   align=\"center\"><td   style=\"border:solid   1pt   #F7FBFF;\"   onmouseover=\"parent.tdMove(this)\"   onmouseout=\"parent.tdOut(this)\"   onclick=\"parent.selectClicked(this)\">7";
strPop += "<td   style=\"border:solid   1pt   #F7FBFF;\"   onmouseover=\"parent.tdMove(this)\"   onmouseout=\"parent.tdOut(this)\"   onclick=\"parent.selectClicked(this)\">8";
strPop += "<td   style=\"border:solid   1pt   #F7FBFF;\"   onmouseover=\"parent.tdMove(this)\"   onmouseout=\"parent.tdOut(this)\"   onclick=\"parent.selectClicked(this)\">9";
strPop += "<td   style=\"border:solid   1pt   #F7FBFF;\"   onmouseover=\"parent.tdMove(this)\"   onmouseout=\"parent.tdOut(this)\"   onclick=\"parent.selectClicked(this)\">10";
strPop += "<td   style=\"border:solid   1pt   #F7FBFF;\"   onmouseover=\"parent.tdMove(this)\"   onmouseout=\"parent.tdOut(this)\"   onclick=\"parent.selectClicked(this)\">11";
strPop += "<td   style=\"border:solid   1pt   #F7FBFF;\"   onmouseover=\"parent.tdMove(this)\"   onmouseout=\"parent.tdOut(this)\"   onclick=\"parent.selectClicked(this)\">12</td></tr>";
strPop +="<tr><td height='3' colspan=6 style='background-color:#000000;'></td></tr>"
strPop += "<tr   align=\"center\"   bgcolor=\"#ffffff\"   style=\"color:#000000\"><td   colspan=3   onclick=\"parent.selectClicked(this)\">\u672c\u6708";
strPop += "<td   colspan=3   onclick=\"parent.hidePop();\">\u6e05\u7a7a</td></tr>";
strPop += "</table>";
popBody.innerHTML = strPop;
function tdMove(e) {
	e.style.border = "outset   1pt   blue";
}
function tdOut(e) {
	e.style.border = "solid   1pt   #F7FBFF";
}
function yearChange(n) {
	var e = popup.document.all("yMonth");
	
	e.cells[1].innerText = parseInt(e.cells[1].innerText) + parseInt(n);

	e.cells[2].innerText = parseInt(e.cells[2].innerText) + parseInt(n);

	e.cells[3].innerText = parseInt(e.cells[3].innerText) + parseInt(n);

	e.cells[4].innerText = parseInt(e.cells[4].innerText) + parseInt(n);

	var reg = /(\d{4})(\-)(\d{1,2})/;
	if(tarObject.value=='')
		tarObject.value=sYear+'-'+sMonth;
	var r = reg.exec(tarObject.value);
	tarObject.value = (parseInt(r[1]) + n) + "-" + r[3];

	
}
function selectClicked(e) {
	var sysdate=sYear+'-'+sMonth;

	var p = e.parentElement;
	switch (p.rowIndex) {
	  case 0:
	  // alert('0');
		for (var i = 1; i < 5; i++) {
			p.cells[i].style.backgroundColor = "#101073";
			p.cells[i].style.color = "#ffffff";
		}
		e.style.backgroundColor = "#ffffff";
		e.style.color = "#ff0000";
		eText=e.innerText;
		//alert(e.innerText);
		tarObject.value = tarObject.value.replace(/(\d{4})(\-)(\d{1,2})/, e.innerText + "-$3");
	
		//tarObject.value = tarObject.value.replace("/","-");
		break;
	  case 4:
	 // alert('4');
	  	var Pmonth= sMonth;
	  	if(Pmonth<10)
	  		Pmonth='0'+sMonth;
		tarObject.value = sYear + "-" + Pmonth;
		
		popup.hide();
		break;
	  default:
		//var reg = /(\d{4})(\-)(\d{1,2})/;
		//var r = reg.exec(tarObject.value);


	 // var eeeee = popup.document.all("yMonth");
	 // var chenliang= eeeee.rows;
	  	var tLength=tarObject.value.length;
	  	var pInnerText=e.innerText;
	  	if(pInnerText<10)
	  		pInnerText='0'+pInnerText;
	  			
	  	if(tLength<1){
	  	
	  		if(eText==0){
			var eee = popup.document.all("yMonth").rows[0];
			for (var i = 1; i < 5; i++) {
				if (eee.cells[i].style.color == "#ff0000") {
					
					sYear=eee.cells[i].innerText;		
				}
			}
	  			eText=sYear;
	  		
	  		}
	  		eText=eText+'-'+sMonth
	  		
	  		tarObject.value = eText.replace(/(\d{4})(\-)(\d{1,2})/, "$1-" + pInnerText);
	  		
	  		eText='';
	  	}
		tarObject.value = tarObject.value.replace(/(\d{4})(\-)(\d{1,2})/, "$1-" + pInnerText);
		e.style.border = "solid   1pt   #F7FBFF";
		popup.hide();
		break;
	}
}
function hidePop() {
	//popup.hide();
	tarObject.value ='';
	
}
function getYM(s) {
	tarObject = s;   
  //if   (s.value=='')s.value=sYear+'/'+sMonth   
	var reg = /(\d{4})(\-)(\d{1,2})/;
	var r = reg.exec(s.value);

	if (r != null) {
		var e = popup.document.all("yMonth").rows[0];
		for (var i = 1; i < 5; i++) {
			if (e.cells[i].style.color == "#ff0000") {
				s.value = e.cells[i].innerText + "-" + r[3];
				yearChange(r[1] - e.cells[i].innerText);
				break;
			}
		}
		
		sYear=e.cells[i].innerText;
		
	}
	var e = event.srcElement;
	
	popup.show(e.pixelLeft, e.clientHeight + 5, 190, 75, e);
}

