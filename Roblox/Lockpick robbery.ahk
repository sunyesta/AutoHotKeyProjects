{


<style> img{
   width: 100%;
 
}</style>
<==



(print: '<img src="'+ _imgs's ($imgIndex)+'" >' )
=><=

(if: $imgIndex < (_imgs's length))[
(css: "color: "+ $whiteThemeColor +"; font-family: typewriter")[
click page for next slide
]
	(set: $imgIndex to $imgIndex+1)
	(click-goto:?page,(passage:)'s name)
](else:)[
(css: "color: "+ $whiteThemeColor +"; font-family: typewriter")[
	
	(link:"Restart")[
		(goto:"Start")
		(c)
		(restart:)
		
	]
]

]


}