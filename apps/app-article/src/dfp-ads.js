var googletag=googletag||{};var ksfDfp={};(function(){"use strict";googletag.cmd=googletag.cmd||[];ksfDfp.consentCookieChecker=function(consentCookieName){var consentAlternatives=[true,false,false,false,false];var adConsent=false;var adConsentValue=1;var adConsentCookie=document.cookie.match("(^|;) ?"+consentCookieName+"=([^;]*)(;|$)");if(adConsentCookie){var adConsentCookieValue=typeof(adConsentCookie[2]!=="undefined")?Number(adConsentCookie[2]):undefined;if(typeof adConsentCookieValue!=="undefined"&&Number.isInteger(adConsentCookieValue)&&adConsentCookieValue<consentAlternatives.length&&adConsentCookieValue>-1){adConsent=consentAlternatives[adConsentCookieValue];adConsentValue=adConsentCookieValue}}var consentResponse=[adConsent,adConsentValue];return consentResponse};ksfDfp.displayBanner=function(id){googletag.cmd.push(function(){googletag.display(id)})};ksfDfp.getBannerWidth=function(banner){var bannerWidth;if(!Array.isArray(banner[1][0])){bannerWidth=banner[1][0]}else{bannerWidth=banner[1][0][0]}return bannerWidth};ksfDfp.onSwitch=true;if(window.disableAds===true){ksfDfp.onSwitch=false;console.log("We will not show ads on this page load!")}if(ksfDfp.onSwitch){ksfDfp.consentKeyName="consent";ksfDfp.consentCookieName="gdpr_ads";ksfDfp.gdprConsentObj=ksfDfp.consentCookieChecker(ksfDfp.consentCookieName);if(typeof ksfDfp.gdprConsentObj!=="undefined"&&ksfDfp.gdprConsentObj[1]<=2){ksfDfp.gdprConsentDfpInt=ksfDfp.gdprConsentObj[1]}else{ksfDfp.gdprConsentDfpInt=1}document.onreadystatechange=function(){if(document.readyState==="interactive"){var n=ksfDfp.numberOfSlots-1,slotId=[],slotW=[],slotOK=[];while(n>-1){slotId[n]=ksfDfp.slots[n][0];slotW[n]=ksfDfp.getBannerWidth(ksfDfp.slots[n]);slotOK[n]=false;if(slotW[n]<=ksfDfp.w){slotOK[n]=true}if(window.document.getElementById(slotId[n])&&slotOK[n]){ksfDfp.displayBanner(slotId[n])}n=n-1}ksfDfp.DisplayDiligentSlots()}};ksfDfp.account="/21664538223/";ksfDfp.didScroll=false;ksfDfp.w=Math.max(document.documentElement.clientWidth,window.innerWidth||0);ksfDfp.mobileLimit=768;ksfDfp.mobile=false;ksfDfp.LazyBannerDeflectionAmount=Math.floor(window.innerHeight/1.3);ksfDfp.LazyBannerDeflectionAmountMobile=Math.floor(window.innerHeight/2);if(ksfDfp.w<=ksfDfp.mobileLimit){ksfDfp.mobile=true}ksfDfp.site=typeof ksf.settings.brand.id!=="undefined"?ksf.settings.brand.id:"hbl";ksfDfp.diligentSlots=["MOBPARAD"];ksfDfp.mobileOnlySlots=[["MOBPARAD",[[300,100],[300,250],[300,300],[300,600]]],["MOBMITT",[[300,100],[300,250],[300,300],[300,600]]],["MOBNER",[[300,100],[300,250],[300,300],[300,600]]],["DIGIHELMOB",[300,431]]];ksfDfp.LazyBannerDeflectionAmount=ksfDfp.LazyBannerDeflectionAmountMobile;ksfDfp.slots=[];ksfDfp.slots=ksfDfp.mobileOnlySlots;ksfDfp.numberOfSlots=ksfDfp.slots.length;ksfDfp.lazySlotNames=[];ksfDfp.slotObjects=[];googletag.cmd.push(function(){var n=ksfDfp.numberOfSlots-1,bannerWidthInstance,bannerSizeList;ksfDfp.activeSlotsFlatArray=[];while(n>=0){bannerWidthInstance=ksfDfp.getBannerWidth(ksfDfp.slots[n]);if(bannerWidthInstance<=ksfDfp.w){ksfDfp.activeSlotsFlatArray.push(ksfDfp.slots[n][0]);bannerSizeList=ksfDfp.slots[n][1];ksfDfp.slotObjects[ksfDfp.slots[n][0]]=googletag.defineSlot(ksfDfp.account+ksfDfp.slots[n][0],bannerSizeList,ksfDfp.slots[n][0]).addService(googletag.pubads());if(ksfDfp.diligentSlots.indexOf(ksfDfp.slots[n][0])<0){ksfDfp.lazySlotNames.push(ksfDfp.slots[n][0])}ksfDfp.slotObjects[ksfDfp.slots[n][0]].setTargeting("newspaper",[ksfDfp.site]);ksfDfp.slotObjects[ksfDfp.slots[n][0]].setTargeting(ksfDfp.consentKeyName,[ksfDfp.gdprConsentObj[1]])}n-=1}googletag.pubads().disableInitialLoad();googletag.pubads().setRequestNonPersonalizedAds(ksfDfp.gdprConsentDfpInt);googletag.pubads().collapseEmptyDivs();googletag.enableServices();googletag.pubads().addEventListener("slotRenderEnded",function(event){if(typeof event!=="undefined"&&event.size!==null){var headerToShow,contentUnitDiv=event.slot.getSlotElementId();document.body.classList.add("noScroll");contentUnitDiv=event.slot.getSlotElementId();headerToShow=document.getElementById(contentUnitDiv);headerToShow.insertAdjacentHTML("beforebegin",'<header class="ksfDFPadHeader '+contentUnitDiv+'" style="width: '+event.size[0]+'px">annons</header>')}})});ksfDfp.activateBanner=function(id){googletag.pubads().refresh([id])};ksfDfp.getOffset=function(el){var _y=0;while(el&&!isNaN(el.offsetTop)){_y+=el.offsetTop-el.scrollTop;el=el.offsetParent}return _y};ksfDfp.visibilityController=function(element){var evaluation="visible",vpH=window.innerHeight||document.documentElement.clientHeight||document.body.clientHeight,st=window.pageYOffset!==undefined?window.pageYOffset:(document.documentElement||document.body.parentNode||document.body).scrollTop,yelement=document.getElementById(element),y=ksfDfp.getOffset(yelement),elementHeight=0;if(evaluation=="visible")return y<vpH+(st+ksfDfp.LazyBannerDeflectionAmount)&&y>st-elementHeight;if(evaluation=="above")return y<vpH+st};ksfDfp.runLazyValidation=function(){if(ksfDfp.didScroll){var n=ksfDfp.lazySlotNames.length-1;while(n>=0){var bannerId=ksfDfp.lazySlotNames[n];var checkAdVisibility=ksfDfp.visibilityController(bannerId);if(checkAdVisibility){var adToActivate=ksfDfp.slotObjects[ksfDfp.lazySlotNames[n]];ksfDfp.activateBanner(adToActivate);ksfDfp.lazySlotNames.splice(n,1);if(ksfDfp.lazySlotNames.length===0){clearInterval(ksfDfp.intervallRunner)}}n-=1}ksfDfp.didScroll=false}};ksfDfp.DisplayDiligentSlots=function(){googletag.cmd.push(function(){var n=ksfDfp.diligentSlots.length-1;while(n>-1){if(typeof ksfDfp.slotObjects[ksfDfp.diligentSlots[n]]!=="undefined"){ksfDfp.activateBanner(ksfDfp.slotObjects[ksfDfp.diligentSlots[n]])}n-=1}})};document.addEventListener("DOMContentLoaded",function(){ksfDfp.intervallRunner=window.setInterval(ksfDfp.runLazyValidation,400)});window.onscroll=function(){ksfDfp.didScroll=true}}})();