// ==UserScript==
// @name         PEConsoleQRCodeHelper
// @namespace    http://tampermonkey.net/
// @version      0.1.0.0.0
// @description  For TamperMonkey or GreaseMonkey ... a helper to make the QR Code display nicer in the Puppet Enterprise Console
// @author       Sooyean-hoo
// @connect      *
// @match      *://*puppet*/*
// @run-at       document-end
// @copyright    2022, Sooyean (https://github.com/sooyean-hoo/bigbigpuppetfacts_qrcode)
// @icon         https://www.google.com/s2/favicons?sz=64&domain=opsworks-cm.io
// @grant        none
// @license MIT
// ==/UserScript==
// // @updateURL    https://openuserjs.org/meta/Sooyean-hoo/PEConsoleQRCodeHelper.meta.js
// /// @downloadURL  https://openuserjs.org/install/Sooyean-hoo/PEConsoleQRCodeHelper.js

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