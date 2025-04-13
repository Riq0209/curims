function popup_show_onmove(parent_element, popup_element, str) {    
    var parent_post = get_elementposition(parent_element);
    
    var doc_width = 0;

    if (window.innerWidth != undefined) { // Mozilla
        doc_width = window.innerWidth - 22;
        parent_post.top += 2;

    } else if (document.body.clientWidth) { // IE
        doc_width = document.body.clientWidth;
    }    
    
    if (parent_post.left > doc_width/2) {        
        var parent_element_width = parent_element.style.width.replace(/px$/, "");
        
        /* alert("parent_post.left = " + parent_post.left + 
              "\ndoc_width = " + doc_width +
              "\nparent_element_width = " + parent_element_width); */
              
        popup_element.style.right = doc_width - (parent_post.left  + parseInt(parent_element_width));
        
    } else { 
        popup_element.style.left = parent_post.left;
    }
    
    popup_element.innerHTML = str;
    
    popup_element.style.top = parent_post.top;
    popup_element.style.visibility = "visible";
}

function popup_show_onclick(parent_element, popup_element, top, left, bottom, right, close_button, page_dimmer) {    
    var parent_post = get_elementposition(parent_element);
    
    var doc_width = 0;

    if (window.innerWidth != undefined) { // Mozilla
        doc_width = window.innerWidth - 22;
        parent_post.top += 2;

    } else if (document.body.clientWidth) { // IE
        doc_width = document.body.clientWidth;
    }
    
    if (top) {
        popup_element.style.top = top;
        
    } else {
        if (bottom) {
            popup_element.style.bottom = bottom;
            
        } else {
            if (parent_element) {
                popup_element.style.top = parent_post.top;
            }
        }
    }    
    
    if (left) {
        popup_element.style.left = left;
        
    } else {
        if (right) {
            popup_element.style.right = right;
        } else {
            if (parent_element) {
                if (parent_post.left > doc_width/2) {        
                    var parent_element_width = parent_element.style.width.replace(/px$/, "");

                    if (parent_element_width == "") {
                        parent_element_width = "0";
                    }

                    /* alert("parent_post.top = " + parent_post.top + 
                          "\nparent_post.left = " + parent_post.left + 
                          "\ndoc_width = " + doc_width +
                          "\nparent_element_width = " + parent_element.style.width); */

                    popup_element.style.right = doc_width - (parent_post.left  + parseInt(parent_element_width));

                } else { 
                    popup_element.style.left = parent_post.left;
                }
            }
        }
    }
    
    if (close_button == "left") {
        popup_element.style.padding = "17px 10px 10px 23px";
        
        if (page_dimmer) {
            popup_element.innerHTML = "<div style=\"position:absolute; top:2; left:2; color:#8888FF; font-family:verdana;\" onMouseOver=\"this.style.cursor='pointer';\" onClick=\"popup_hide(" + popup_element.id + ", document.getElementById('div_page_dimmer'));\"><img src=\"../../../webman/iwtp/img/icon_close_button.gif\" /></div>\n" + popup_element.innerHTML;                         
            page_dimmer.style.visibility = "visible";

        } else {
            popup_element.innerHTML = "<div style=\"position:absolute; top:2; left:2; color:#8888FF; font-family:verdana;\" onMouseOver=\"this.style.cursor='pointer';\" onClick=\"popup_hide(" + popup_element.id + ", '');\"><img src=\"../../../webman/iwtp/img/icon_close_button.gif\" /></div>\n" + popup_element.innerHTML;                             
        }    
    
    } else {
        if (page_dimmer) {
            popup_element.innerHTML = "<div style=\"position:absolute; top:2; right:2; color:#8888FF; font-family:verdana;\" onMouseOver=\"this.style.cursor='pointer';\" onClick=\"popup_hide(" + popup_element.id + ", document.getElementById('div_page_dimmer'));\"><img src=\"../../../webman/iwtp/img/icon_close_button.gif\" /></div>\n" + popup_element.innerHTML;                         
            page_dimmer.style.visibility = "visible";

        } else {
            popup_element.innerHTML = "<div style=\"position:absolute; top:2; right:2; color:#8888FF; font-family:verdana;\" onMouseOver=\"this.style.cursor='pointer';\" onClick=\"popup_hide(" + popup_element.id + ", '');\"><img src=\"../../../webman/iwtp/img/icon_close_button.gif\" /></div>\n" + popup_element.innerHTML;                             
        }
    }
    
    popup_element.style.visibility = "visible";
}

function popup_hide(popup_element, page_dimmer) { 
    //popup_element.innerHTML = "";
    popup_element.style.visibility = "hidden";
    
    if (page_dimmer) {
        page_dimmer.style.visibility = "hidden";
    }
}

function blink_text(txt_element, color1, color2) {
    var color_current = color1;

    function blink_text_internal() {
        if (color1 == undefined || color2 == undefined) {
            if (txt_element.style.visibility == "hidden") {
                txt_element.style.visibility = "visible";

            } else {
                txt_element.style.visibility = "hidden";
            }
            
        } else {
            txt_element.style.color = color_current;
            
            if (color_current == color1) {
                color_current = color2;

            } else {
                color_current = color1;
            }            
        }
    }
   
    setInterval(blink_text_internal, 500);
}

function blink_div(div_element, style, color1, color2) {
    var color_current = color1;
    
    function blink_div_internal() {
        if (style == "border") {
            div_element.style.border = "1px solid " + color_current;
            
        } else if (style == "background") {
            div_element.style.background = color_current;
        }
        
        if (color_current == color1) {
            color_current = color2;
            
        } else {
            color_current = color1;
        }
    }
   
    setInterval(blink_div_internal, 750);
}

function get_elementposition(element){
    var post = {left:0, top:0};
    
    while(element){
        post.left += element.offsetLeft;
        post.top  += element.offsetTop;
        element = element.offsetParent;
    }
    
    return post;
}

function pick2input(value, input_element, display_element) {
    if (value && input_element) {
        input_element.value = value;
    }
    
    if (value && display_element) {
        display_element.value = value;
    }    
}

function checkbox_select_all(prefix, inl, dbisn) {
    var idx_start = (dbisn - 1) * inl;
    var idx_stop = inl * dbisn;
    
    for (var i = idx_start; i < idx_stop; i++) {
        var element_id_str = prefix + i.toString();
    
        //alert(element_id_str);
        
        if (!document.getElementById(element_id_str).disabled) {
            document.getElementById(element_id_str).checked = true;
        }
    }
}

function checkbox_select_none(prefix, inl, dbisn) {
    var idx_start = (dbisn - 1) * inl;
    var idx_stop = inl * dbisn;
    
    for (var i = idx_start; i < idx_stop; i++) {
        var element_id_str = prefix + i.toString();
    
        //alert(element_id_str);
        if (!document.getElementById(element_id_str).disabled) {
            document.getElementById(element_id_str).checked = false;
        }
    }
}

function checkbox_select_invert(prefix, inl, dbisn) {
    var idx_start = (dbisn - 1) * inl;
    var idx_stop = inl * dbisn;
    
    for (var i = idx_start; i < idx_stop; i++) {
        var element_id_str = prefix + i.toString();
    
        //alert(element_id_str);
        if (!document.getElementById(element_id_str).disabled) {
            if (document.getElementById(element_id_str).checked) {
                document.getElementById(element_id_str).checked = false;

            } else {
                document.getElementById(element_id_str).checked = true;
            }
        }
    }
}