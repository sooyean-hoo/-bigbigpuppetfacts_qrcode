// ==UserScript==
// @name         PEConsoleQRCodeHelper
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  For TamperMonkey or GreaseMonkey ... a helper to make the QR Code display nicer in the Puppet Enterprise Console
// @author       Hoo Sooyean 何書淵
// @connect     *
// @include     *://*puppet*/*
// @run-at      document-end
// @icon         https://www.google.com/s2/favicons?sz=64&domain=opsworks-cm.io
// @grant        none
// @updateURL   https://openuserjs.org/meta/Sooyean-hoo/PEConsoleQRCodeHelper.meta.js
// @downloadURL https://openuserjs.org/install/Sooyean-hoo/PEConsoleQRCodeHelper.user.js
// @license MIT
// ==/UserScript==

(function() {
    'use strict';

    setTimeout( f=>{

        let nodes=document.querySelectorAll(".node-fact-value")

        for( let index=0; index < nodes.length ; index++){
            let n = nodes[index];
            if ( n.innerText.startsWith( '███████' ) ){
                n.style.lineHeight='1.2ch' ;
            }
        }
    }, 5000)
    // Your code here...
})();