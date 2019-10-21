**Some brief documentation for the script**
Requirements:
**The gpt.js from Google**
`<script async='async' src='https://www.googletagservices.com/tag/js/gpt.js'></script>`


**The script itself from where ever it is hosted**
`<script async='async' src='https://script.ksfmedia.fi/app/gamAppAds.js'></script>`

DIV tags in the HTML that correspond to the ones known by the script:
The script is currently looking for div:s in the HTML, with an id among these:
**MOBPARAD 300x300, 300x250, 300x100,  300x600
MOBBOX1 300x300, 300x250, 300x100,  300x600
MOBBOX2 300x300, 300x250, 300x100,  300x600
MOBBOX5 300x300, 300x250, 300x100,  300x600
DIGIHELMOB 300x431**
These names are not final. The expected HTML is this:
`<div id = "string"></div>`
** Example **
`<div id = "MOBPARAD"></div>`

/Requirements

GPDR consent is hard-coded as using the app will require consent.

The code listens for ads marked 
newspaper > app
and there is an order set up in Google Ad Manager to populate the app during testing.

In production there will presumably be three values for newspaper, one for each paper.

The div tags above all currently support these sizes: 
300*100, 300*250, 300*300, 300*600
The sizes are also not final.

OnSwitch is hard-coded as true at the moment. Should probably be set according to something it can listen for. There is a requirement for this functionality but it cannot be provided by Google Ad Manager. So it has to be set here.