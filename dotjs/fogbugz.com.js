// ==UserScript==
// @name         FogBugz Helper
// @namespace    http://ziprecruiter.github.io/
// @version      0.1
// @description  Various alterations to FogBugz's UI
// @author       ZipRecruiter
// @match        https://*.fogbugz.com/*
// @grant        none
// @run-at       document-start
// ==/UserScript==

javascript:(function(){url='//ziprecruiter.github.io/greasemonkey/fogbugz-helper/fogbugz-helper.js';document.head.appendChild(document.createElement('script')).src=url+'?'+new Date().getTime();})();
