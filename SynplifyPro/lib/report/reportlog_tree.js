var reportLogObj=new Object()

// load images to for open and close folder 
reportLogObj.loadImage=function(closeImg, openImg){
reportLogObj.closefolder=closeImg;
reportLogObj.openfolder=openImg;
}

reportLogObj.generateLog=function(treeNode){
var ultags=document.getElementById(treeNode).getElementsByTagName("ul")
for (var i=0; i<ultags.length; i++)
reportLogObj.generateLinkItems(treeNode, ultags[i], i)
}

reportLogObj.generateLinkItems=function(treeid, ulelement, index){
ulelement.parentNode.className="submenu"
if (ulelement.getAttribute("rel")==null || ulelement.getAttribute("rel")==false) 
ulelement.setAttribute("rel", "closed")
else if (ulelement.getAttribute("rel")=="open") 
reportLogObj.expandSubTree(treeid, ulelement) //expand this UL plus all parent ULs (so the most inner UL is revealed!)
ulelement.parentNode.onclick=function(e){
var submenu=this.getElementsByTagName("ul")[0]
if (submenu.getAttribute("rel")=="closed"){
submenu.style.display="block"
submenu.setAttribute("rel", "open")
ulelement.parentNode.style.backgroundImage="url("+reportLogObj.openfolder+")"
}
else if (submenu.getAttribute("rel")=="open"){
submenu.style.display="none"
submenu.setAttribute("rel", "closed")
ulelement.parentNode.style.backgroundImage="url("+reportLogObj.closefolder+")"
}
reportLogObj.preventpropagate(e)
}
ulelement.onclick=function(e){
reportLogObj.preventpropagate(e)
}
}

reportLogObj.expandSubTree=function(treeid, ulelement){ //expand a UL element and any of its parent ULs
var rootnode=document.getElementById(treeid)
var currentnode=ulelement
currentnode.style.display="block"
currentnode.parentNode.style.backgroundImage="url("+reportLogObj.openfolder+")"
while (currentnode!=rootnode){
if (currentnode.tagName=="ul"){ //if parent node is a UL, expand it too
currentnode.style.display="block"
currentnode.setAttribute("rel", "open") //indicate it's open
currentnode.parentNode.style.backgroundImage="url("+reportLogObj.openfolder+")"
}
currentnode=currentnode.parentNode
}
}

////A few utility functions below//////////////////////

reportLogObj.searcharray=function(thearray, value){ //searches an array for the entered value. If found, delete value from array
var isfound=false
for (var i=0; i<thearray.length; i++){
if (thearray[i]==value){
isfound=true
thearray.shift() //delete this element from array for efficiency sake
break
}
}
return isfound
}

reportLogObj.preventpropagate=function(e){ //prevent action from bubbling upwards
if (typeof e!="undefined")
e.stopPropagation()
else
event.cancelBubble=true
}