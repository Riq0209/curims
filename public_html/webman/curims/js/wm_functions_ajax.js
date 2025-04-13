var ajax_service_url = "index.cgi";

function request_ajax_get(param, popup_element) {
    var ajax = create_ajax();
    
    ajax.onreadystatechange=function() {
        if (ajax.readyState==4 && ajax.status==200) {
            var str = ajax.responseText;
            popup_element.innerHTML = "<div style=\"position:absolute; top:0; right:3; color:#8888FF; font-family:verdana;\" onMouseOver=\"this.style.cursor='pointer';\" onClick=\"popup_hide(document.getElementById('popup_div_onclick'));\"><b>X</b></div>\n" + str;
        }
    }    
    
    ajax.open("GET", ajax_service_url + "?" + param, true);
    ajax.send();
}

function create_ajax() {
    var xmlhttp;
    
    if (window.XMLHttpRequest) { // code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp = new XMLHttpRequest();
        
    } else { // code for IE6, IE5
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    
    return xmlhttp;
}