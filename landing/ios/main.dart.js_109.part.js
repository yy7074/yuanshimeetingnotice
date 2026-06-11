((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,B,S,Z,K,C={
aRM(d,e){return new C.rF(e,null)},
bgn(d){var x,w,v,u,t,s
if(d.a==="1528024"){x=d.w
w=A.a3(x).i("ah<1>")
x=A.U(new A.ah(x,new C.aOx(),w),w.i("w.E"))
return x}x=A.aL(y.N)
for(w=d.w,v=w.length,u=0;u<w.length;w.length===v||(0,A.y)(w),++u){t=w[u]
if(t.a==="image"&&t.c.length!==0)x.A(0,t.c)}v=d.f
s=A.a3(v)
x=A.U(new A.eu(new A.ah(v,new C.aOy(x),s.i("ah<1>")),new C.aOz(),s.i("eu<1,i1>")),y.c)
B.b.J(x,w)
return x},
bh7(){var x=$.O(),w=$.c7().xr.gM()
if((w==null?null:w.k8())===!0)A.cG(x,null)
else A.hb(x,"/main",y.z)},
bej(d){return new C.qR(null,d)},
aPn(d){return C.bhO(d)},
bhO(d){var x=0,w=A.t(y.r),v,u=2,t=[],s,r,q,p
var $async$aPn=A.u(function(e,f){if(e===1){t.push(f)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.j(A.mT(d.d),$async$aPn)
case 7:s=f
r=C.bi6(s,d.f)
v=r
x=1
break
u=2
x=6
break
case 4:u=3
p=t.pop()
v=D.ti
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.q(v,w)
case 2:return A.p(t.at(-1),w)}})
return A.r($async$aPn,w)},
bi6(d,a0){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f="data-original",e=y.N
e=A.B(e,e)
for(x=a0.length,w=0;w<a0.length;a0.length===x||(0,A.y)(a0),++w){v=a0[w]
e.p(0,B.c.aA(C.aOE(v.b)),v.a)}u=new A.a9(a0,new C.aPI(),A.a3(a0).i("a9<1,k>")).m7(0,new C.aPJ(),new C.aPK())
t=A.b([],y.J)
for(x=A.ar("<li\\b(?=[^>]*mui-indexed-list-item)([\\s\\S]*?)</li>",!0,!1).fd(0,d),x=new A.mv(x.a,x.b,x.c),s=y.a0;x.u();){r=x.d
q=(r==null?s.a(r):r).b[0]
if(q==null)q=""
p=A.ar("<li\\b([^>]*)>",!0,!1).da(q)
o=p==null?null:p.b[1]
if(o==null)o=""
n=C.Ob(o,"data-user_id")
m=C.Ob(o,"data-value").toUpperCase()
p=A.ar("<h2\\b[^>]*talker-name[^>]*>([\\s\\S]*?)</h2>",!0,!1).da(q)
p=p==null?null:p.b[1]
l=C.mF(p==null?"":p)
p=A.ar("<p\\b[^>]*talker-unit[^>]*>([\\s\\S]*?)</p\\s*>",!0,!1).da(q)
p=p==null?null:p.b[1]
k=C.mF(p==null?"":p)
if(l.length===0)continue
j=B.c.aA(C.aOE(C.Ob(q,f).length!==0?C.Ob(q,f):C.Ob(q,"src")))
i=e.h(0,j)
if(i==null)i=B.c.q(j,"person-default")?u:""
if(m.length!==0)h=m[0]
else{p=B.c.aA(l)
p=(p.length===0?B.bG:new A.e1(p)).a
g=p.length
p=g===0?A.T(A.aB("No element")):B.c.R(p,0,new A.kK(p,g,0,240).jD())
h=p.toUpperCase()}p=A.ar("^[A-Z]$",!0,!1)
t.push(new C.fa(n,l,k,p.b.test(h)?h:"#",i))}B.b.d5(t,new C.aPL())
return t},
bhb(d){var x,w,v,u=A.B(y.N,y.r)
for(x=d.length,w=0;w<d.length;d.length===x||(0,A.y)(d),++w){v=d[w]
J.dA(u.bP(v.d,new C.aOV()),v)}return u},
bgP(d){var x,w,v,u=A.b([],y.W)
for(x=new A.dO(d,A.v(d).i("dO<1,2>")).ga5(0),w=y.aX;x.u();){v=x.d
u.push(new C.qR(v.a,null))
B.b.J(u,J.ea(v.b,C.biH(),w))}return u},
bgO(d){var x=J.ea(d,new C.aOO(),y.N).hs(0),w=A.U(x,A.v(x).c)
B.b.h5(w)
return w},
Ob(d,e){var x=A.ar(A.a7L(e)+"=[\"']([^\"']*)[\"']",!0,!1).da(d),w=x==null?null:x.b[1]
return C.aOE(w==null?"":w)},
aOE(d){var x=A.aG(d,"&nbsp;"," ")
x=A.aG(x,"&amp;","&")
x=A.aG(x,"&lt;","<")
x=A.aG(x,"&gt;",">")
x=A.aG(x,"&quot;",'"')
x=A.aG(x,"&#39;","'")
x=A.aG(x,"&apos;","'")
x=A.aG(x,"&rsquo;","'")
x=A.aG(x,"&lsquo;","'")
x=A.aG(x,"&ldquo;",'"')
return A.a7N(A.a7N(A.aG(x,"&rdquo;",'"'),A.ar("&#(\\d+);",!0,!1),new C.aOF(),null),A.ar("&#x([0-9a-fA-F]+);",!0,!1),new C.aOG(),null)},
aPo(d){return C.bhP(d)},
bhP(d){var x=0,w=A.t(y.U),v,u=2,t=[],s,r,q,p
var $async$aPo=A.u(function(e,f){if(e===1){t.push(f)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.j(A.mT(d.d),$async$aPo)
case 7:s=f
r=C.bi7(s)
v=r
x=1
break
u=2
x=6
break
case 4:u=3
p=t.pop()
v=D.mZ
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.q(v,w)
case 2:return A.p(t.at(-1),w)}})
return A.r($async$aPo,w)},
bi7(a0){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=A.ar('<div class="hotel-card">',!0,!1).fd(0,a0)
d=A.fO(d,new C.aPM(),A.v(d).i("w.E"),y.q)
x=A.U(d,A.v(d).i("w.E"))
if(x.length===0)return D.mZ
w=B.c.fw(a0,"<style>",B.b.gY(x))
v=A.b([],y.s)
for(d=a0.length,u=0;t=x.length,u<t;){s=x[u];++u
if(u<t)r=x[u]
else r=w>s?w:d
v.push(B.c.R(a0,s,r))}q=A.b([],y.X)
for(d=v.length,p=0;p<v.length;v.length===d||(0,A.y)(v),++p){o=v[p]
n=C.aUo(o,"hotel-name")
t=A.ar("<a\\b(?=[^>]*book-button)[^>]*>",!0,!1).da(o)
t=t==null?null:t.b[0]
m=C.bi_(C.Ob(t==null?"":t,"href"))
if(n.length===0||m.length===0)continue
l=C.bhd(o)
t=B.b.m7(l,new C.aPN(),new C.aPO())
k=A.a3(l).i("ah<1>")
j=A.U(new A.ah(l,new C.aPP(),k),k.i("w.E"))
i=C.bhe(o)
k=A.a3(i)
h=k.c
k=k.i("hH<1>")
g=new A.hH(i,0,2,k)
g.tg(i,0,2,h)
f=g.e9(0)
k=new A.hH(i,2,null,k)
k.tg(i,2,null,h)
e=k.kB(0,2).e9(0)
q.push(new C.qV(n,C.aUo(o,"hotel-brand"),C.aUo(o,"hotel-stars"),t.b,m,f,e,j))}return q},
aUo(d,e){var x=A.ar('<div\\b[^>]*class="'+e+'"[^>]*>([\\s\\S]*?)</div>',!0,!1).da(d),w=x==null?null:x.b[1]
return C.mF(w==null?"":w)},
bhe(d){var x,w=A.ar('<div class="price-item">\\s*<span>([\\s\\S]*?)</span>\\s*<span class="price-value">([\\s\\S]*?)</span>',!0,!1).fd(0,d)
w=A.fO(w,new C.aOZ(),A.v(w).i("w.E"),y.o)
x=A.v(w).i("ah<w.E>")
w=A.U(new A.ah(w,new C.aP_(),x),x.i("w.E"))
return w},
bhd(d){var x,w=A.ar('<div class="info-item">\\s*<span class="info-label">([\\s\\S]*?)</span>\\s*<span\\b[^>]*>([\\s\\S]*?)</span>',!0,!1).fd(0,d)
w=A.fO(w,new C.aOX(),A.v(w).i("w.E"),y.o)
x=A.v(w).i("ah<w.E>")
w=A.U(new A.ah(w,new C.aOY(),x),x.i("w.E"))
return w},
b1k(d){var x=C.mF(d),w=A.ar("\\s+",!0,!1)
x=A.aG(x,w," ")
return B.c.aA(A.aG(x,":",""))},
bi_(d){var x,w=B.c.aA(C.aOE(d)),v=A.jA(w)
if(v==null)return w
if(B.c.q(v.geA(),"safelinks.protection.outlook.com")){x=v.gG7().h(0,"url")
if(x!=null&&B.c.aA(x).length!==0)return B.c.aA(x)}return w},
aPc(d){var x=0,w=A.t(y.H),v,u
var $async$aPc=A.u(function(e,f){if(e===1)return A.p(f,w)
for(;;)switch(x){case 0:u=A.jA(d.e)
if(u==null||!u.gEY()){C.b27(d)
x=1
break}x=3
return A.j(A.lv(u,B.de),$async$aPc)
case 3:if(!f)C.b27(d)
case 1:return A.q(v,w)}})
return A.r($async$aPc,w)},
b27(d){A.e8($.O(),"Unable to Open Booking",d.a,B.d6,B.e,B.E,B.au)},
aPd(d){var x=0,w=A.t(y.H),v,u
var $async$aPd=A.u(function(e,f){if(e===1)return A.p(f,w)
for(;;)switch(x){case 0:u=A.jA(d)
if(u==null){x=1
break}x=3
return A.j(A.lv(u,B.de),$async$aPd)
case 3:if(!f)A.e8($.O(),"Unable to Open Visa Policy",d,B.d6,B.e,B.E,B.au)
case 1:return A.q(v,w)}})
return A.r($async$aPd,w)},
b6G(d){return new C.kG(d,null)},
bi4(d){var x=C.bi3(d)
if(x.length===0)return""
return"https://www.apscvir2026.com/en/minisite/program-detail/29839?program_id="+x},
bi3(d){var x,w=d.a
if(!B.c.b1(w,"apscvir-2026-"))return""
x=B.c.bF(w,13)
w=A.ar("^\\d+$",!0,!1)
return w.b.test(x)?x:""},
aPv(d){return C.bhQ(d)},
bhQ(d){var x=0,w=A.t(y.cc),v,u=2,t=[],s,r,q,p
var $async$aPv=A.u(function(e,f){if(e===1){t.push(f)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.j(A.mT("assets/apscvir2026/site/pages/1814797-detailed-program.html"),$async$aPv)
case 7:s=f
r=C.bi8(s,d)
v=r
x=1
break
u=2
x=6
break
case 4:u=3
p=t.pop()
v=D.jg
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.q(v,w)
case 2:return A.p(t.at(-1),w)}})
return A.r($async$aPv,w)},
bi8(d,e){var x,w,v,u,t,s,r,q,p,o,n,m=null,l=C.bgQ(d,e),k=l.length
if(k===0)return D.jg
x=A.ar('<div class="program-style-content-wrapper">',!0,!1).fd(0,l)
x=A.fO(x,new C.aPQ(),A.v(x).i("w.E"),y.q)
w=A.U(x,A.v(x).i("w.E"))
if(w.length===0)return D.jg
v=A.b([],y.n)
for(u=0;x=w.length,u<x;){t=w[u];++u
s=B.c.R(l,t,u<x?w[u]:k)
r=A.ar('<div class="time common">([\\s\\S]*?)</div>',!0,!1).da(s)
x=r==null?m:r.b[1]
q=C.mF(x==null?"":x)
x=A.ar('<div class="type">[\\s\\S]*?<p>([\\s\\S]*?)</p>',!0,!1).da(s)
x=x==null?m:x.b[1]
p=C.mF(x==null?"":x)
x=A.ar("<a\\b[^>]*>([\\s\\S]*?)</a>",!0,!1).da(s)
x=x==null?m:x.b[1]
o=C.mF(x==null?"":x)
x=A.ar('<span class="td-org">([\\s\\S]*?)</span>',!0,!1).da(s)
x=x==null?m:x.b[1]
n=C.mF(x==null?"":x)
if(q.length===0&&p.length===0&&o.length===0)continue
v.push(new C.r5(q,p.length===0?"TBD":p,o,n))}return v},
bgQ(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l='<div class="program-style-title',k=d.toLowerCase(),j=e.c,i=j.toLowerCase()
for(x=k.length,w=i.length,v=y.c4,u=d.length,t=0,s="";t<x;){r=B.c.fw(k,i,t)
if(r<0)break
q=B.c.yI(k,l,r)
if(q<0){t=r+w
continue}p=q+1
o=B.c.R(d,q,C.bhY(A.b([B.c.fw(k,l,p),B.c.fw(k,'<div class="program-style-place"',p),B.c.fw(k,'<div class="program-style-time"',p)],v),u))
p=C.mF(o)
n=A.ar("\\s+",!0,!1)
m=A.aG(p.toLowerCase(),n,"")
p=A.ar("\\s+",!0,!1)
if(B.c.q(m,A.aG(j.toLowerCase(),p,""))){p=e.glt()
n=A.ar("\\s+",!0,!1)
if(B.c.q(m,A.aG(p.toLowerCase(),n,"")))return o
s=o}t=r+w}return s},
bhY(d,e){var x=A.a3(d).i("ah<1>"),w=A.U(new A.ah(d,new C.aPy(),x),x.i("w.E"))
B.b.h5(w)
return w.length===0?e:B.b.gY(w)},
mF(d){var x,w=A.ar("<!--[\\s\\S]*?-->",!0,!1)
w=A.aG(d,w," ")
x=A.ar("<[^>]+>",!0,!1)
w=A.aG(w,x," ")
w=A.aG(w,"&nbsp;"," ")
w=A.aG(w,"&amp;","&")
w=A.aG(w,"&lt;","<")
w=A.aG(w,"&gt;",">")
w=A.aG(w,"&quot;",'"')
w=A.aG(w,"&#39;","'")
w=A.aG(w,"&rsquo;","'")
w=A.aG(w,"&lsquo;","'")
w=A.aG(w,"&ldquo;",'"')
w=A.aG(w,"&rdquo;",'"')
x=A.ar("\\s+",!0,!1)
return B.c.aA(A.aG(w,x," "))},
rq(d,e){return C.bij(d,e)},
bij(d,e){var x=0,w=A.t(y.H),v,u=2,t=[],s,r,q,p,o,n,m,l
var $async$rq=A.u(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
s=A.a8S(d)
x=s!=null?7:8
break
case 7:r=A.jA(s)
x=r!=null?9:10
break
case 9:x=11
return A.j(A.lv(r,B.de),$async$rq)
case 11:x=1
break
case 10:case 8:x=12
return A.j($.rw().lk(d),$async$rq)
case 12:q=g
p=J.fD(J.aW8(q),q.byteOffset,q.byteLength)
x=13
return A.j(A.wt(),$async$rq)
case 13:o=g
n=A.aeH(o.a+"/"+C.bid(d))
x=14
return A.j(n.a6I(p,!0),$async$rq)
case 14:x=15
return A.j(A9.Hr(A.b([A.axX(n.a,null,null)],y.T),null,e),$async$rq)
case 15:u=2
x=6
break
case 4:u=3
l=t.pop()
A.e8($.O(),"File Unavailable","This local file could not be opened.",B.d6,B.e,B.E,B.au)
x=6
break
case 3:x=2
break
case 6:case 1:return A.q(v,w)
case 2:return A.p(t.at(-1),w)}})
return A.r($async$rq,w)},
bid(d){var x=B.c.aA(B.b.gaf(d.split("/"))),w=A.ar("[^A-Za-z0-9._-]",!0,!1),v=A.aG(x,w,"_")
return v.length===0?"apscvir-download":v},
bhj(d){var x=d.toLowerCase()
if(B.c.q(x,"schedule")||B.c.q(x,"program"))return B.j5
if(B.c.q(x,"faculty")||B.c.q(x,"committee"))return B.j6
if(B.c.q(x,"registration"))return B.rw
if(B.c.q(x,"hotel"))return B.mN
if(B.c.q(x,"visa"))return B.j4
if(B.c.q(x,"venue")||B.c.q(x,"transport"))return B.j7
if(B.c.q(x,"download"))return B.mL
if(B.c.q(x,"contact"))return B.rv
if(B.c.q(x,"sponsor"))return B.rD
if(B.c.q(x,"abstract"))return B.ru
return B.rn},
rF:function rF(d,e){this.c=d
this.a=e},
a8L:function a8L(){},
aOx:function aOx(){},
aOy:function aOy(d){this.a=d},
aOz:function aOz(){},
a1l:function a1l(d,e,f){this.c=d
this.d=e
this.a=f},
Ap:function Ap(d,e,f){this.c=d
this.d=e
this.a=f},
aAC:function aAC(d){this.a=d},
a4K:function a4K(d,e,f){this.c=d
this.d=e
this.a=f},
a1d:function a1d(d,e){this.c=d
this.a=e},
Ka:function Ka(d,e,f){this.c=d
this.d=e
this.a=f},
ZU:function ZU(){var _=this
_.d=$
_.f=_.e=""
_.c=_.a=null},
aDl:function aDl(d){this.a=d},
aDi:function aDi(d){this.a=d},
aDh:function aDh(d,e){this.a=d
this.b=e},
aDj:function aDj(d){this.a=d},
aDg:function aDg(d,e){this.a=d
this.b=e},
aDk:function aDk(d,e){this.a=d
this.b=e},
aDf:function aDf(d,e){this.a=d
this.b=e},
a_1:function a_1(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
a_0:function a_0(d,e,f){this.c=d
this.d=e
this.a=f},
ZX:function ZX(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
aDm:function aDm(d,e){this.a=d
this.b=e},
ZW:function ZW(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
ZV:function ZV(d,e,f){this.c=d
this.d=e
this.a=f},
ZZ:function ZZ(d,e,f){this.c=d
this.d=e
this.a=f},
aDo:function aDo(d){this.a=d},
aDn:function aDn(d){this.a=d},
K9:function K9(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
aDe:function aDe(d){this.a=d},
vN:function vN(d,e,f){this.c=d
this.d=e
this.a=f},
ZY:function ZY(d,e){this.c=d
this.a=e},
a__:function a__(d,e){this.c=d
this.a=e},
Ag:function Ag(d,e){this.c=d
this.a=e},
fa:function fa(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
aDp:function aDp(){},
aDq:function aDq(){},
qR:function qR(d,e){this.a=d
this.b=e},
aPI:function aPI(){},
aPJ:function aPJ(){},
aPK:function aPK(){},
aPL:function aPL(){},
aOV:function aOV(){},
aOO:function aOO(){},
aOF:function aOF(){},
aOG:function aOG(){},
a_L:function a_L(d,e,f){this.c=d
this.d=e
this.a=f},
aFk:function aFk(d){this.a=d},
a_M:function a_M(d,e,f){this.c=d
this.d=e
this.a=f},
a_K:function a_K(d,e,f){this.c=d
this.d=e
this.a=f},
aFj:function aFj(d){this.a=d},
Kz:function Kz(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
KA:function KA(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
a_I:function a_I(d,e,f){this.c=d
this.d=e
this.a=f},
a_J:function a_J(d,e){this.c=d
this.a=e},
qV:function qV(d,e,f,g,h,i,j,k){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k},
kn:function kn(d,e){this.a=d
this.b=e},
aPM:function aPM(){},
aPN:function aPN(){},
aPO:function aPO(){},
aPP:function aPP(){},
aOZ:function aOZ(){},
aP_:function aP_(){},
aOX:function aOX(){},
aOY:function aOY(){},
a61:function a61(d,e){this.c=d
this.a=e},
a66:function a66(d,e){this.c=d
this.a=e},
a65:function a65(d,e){this.c=d
this.a=e},
a64:function a64(d,e,f){this.c=d
this.d=e
this.a=f},
a63:function a63(d,e,f){this.c=d
this.d=e
this.a=f},
a62:function a62(d,e){this.c=d
this.a=e},
aNX:function aNX(){},
rl:function rl(d,e,f){this.a=d
this.b=e
this.c=f},
wh:function wh(d,e,f){this.a=d
this.b=e
this.c=f},
Js:function Js(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a1c:function a1c(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
aII:function aII(d){this.a=d},
vD:function vD(d,e,f){this.c=d
this.d=e
this.a=f},
aAp:function aAp(){},
Ls:function Ls(d,e){this.c=d
this.a=e},
a24:function a24(){var _=this
_.d=$
_.e=0
_.c=_.a=null},
aJz:function aJz(d,e){this.a=d
this.b=e},
aJx:function aJx(d){this.a=d},
aJy:function aJy(d){this.a=d},
aJw:function aJw(d,e){this.a=d
this.b=e},
aJt:function aJt(){},
aJu:function aJu(){},
aJv:function aJv(){},
a2i:function a2i(d,e,f){this.c=d
this.d=e
this.a=f},
a2h:function a2h(d,e,f){this.c=d
this.d=e
this.a=f},
aJG:function aJG(d){this.a=d},
aJF:function aJF(d){this.a=d},
a26:function a26(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
aJA:function aJA(d,e,f){this.a=d
this.b=e
this.c=f},
w1:function w1(d,e,f){this.a=d
this.c=e
this.d=f},
a25:function a25(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a2g:function a2g(d,e,f){this.c=d
this.d=e
this.a=f},
a2k:function a2k(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
a2l:function a2l(d,e,f){this.c=d
this.d=e
this.a=f},
aJI:function aJI(d){this.a=d},
aJH:function aJH(d){this.a=d},
kG:function kG(d,e){this.c=d
this.a=e},
XU:function XU(){this.d=$
this.c=this.a=null},
ayz:function ayz(){},
a2b:function a2b(d,e,f){this.c=d
this.d=e
this.a=f},
a2c:function a2c(d,e,f){this.c=d
this.d=e
this.a=f},
r6:function r6(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a2a:function a2a(d,e,f){this.c=d
this.d=e
this.a=f},
aJB:function aJB(){},
aJC:function aJC(){},
a2f:function a2f(d,e,f){this.c=d
this.d=e
this.a=f},
aJE:function aJE(d,e){this.a=d
this.b=e},
aJD:function aJD(d,e){this.a=d
this.b=e},
a2e:function a2e(d,e,f){this.c=d
this.d=e
this.a=f},
a2d:function a2d(d,e){this.c=d
this.a=e},
a29:function a29(d,e){this.c=d
this.a=e},
a27:function a27(d,e,f){this.c=d
this.d=e
this.a=f},
a28:function a28(d,e,f){this.c=d
this.d=e
this.a=f},
r5:function r5(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
aPQ:function aPQ(){},
aPy:function aPy(){},
JS:function JS(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
Zr:function Zr(d,e){this.c=d
this.a=e},
Zs:function Zs(d,e,f){this.c=d
this.d=e
this.a=f},
aBT:function aBT(d){this.a=d},
aBS:function aBS(d){this.a=d},
Zt:function Zt(d,e,f){this.c=d
this.d=e
this.a=f},
aBU:function aBU(d){this.a=d},
IZ:function IZ(d,e){this.c=d
this.a=e},
AB:function AB(d,e){this.c=d
this.a=e},
vT:function vT(d,e){this.c=d
this.a=e},
b7L(d){var x,w,v,u
for(x=d.length,w=null,v=0;v<x;u=v+1,w=v,v=u)if(w!=null)return null
return w},
bda(d,e,f,g,h,i){var x=null
return new C.I6(d,h,x,x,x,x,g,x,x,x,x,x,x,f,e,!0,B.o,x,x,x,x,x,x,i,x,x,!0,!1,x,!1,x,!0,x,x,x)},
Qt:function Qt(d){this.a=d},
xx:function xx(d){this.f=d},
Qs:function Qs(d){this.a=d},
Qv:function Qv(d,e,f,g,h,i,j){var _=this
_.c=d
_.x=e
_.y=f
_.Q=g
_.CW=h
_.fr=i
_.a=j},
abB:function abB(d){this.a=d},
abx:function abx(){},
aby:function aby(){},
abz:function abz(){},
abA:function abA(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
abC:function abC(d,e){this.a=d
this.b=e},
I6:function I6(d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.r=h
_.w=i
_.x=j
_.y=k
_.z=l
_.Q=m
_.as=n
_.at=o
_.ax=p
_.ay=q
_.ch=r
_.CW=s
_.cx=t
_.cy=u
_.db=v
_.dx=w
_.dy=x
_.fr=a0
_.fx=a1
_.fy=a2
_.go=a3
_.id=a4
_.k1=a5
_.k2=a6
_.k3=a7
_.k4=a8
_.ok=a9
_.p1=b0
_.p2=b1
_.p3=b2
_.a=b3},
aw5:function aw5(d){this.a=d},
a15:function a15(){},
a1a:function a1a(d){this.a=d},
aXz(d,e,f,g){var x=null
return new A.tb(!0,f,x,x,x,g,B.i,x,!1,x,!0,x,new C.ZO(e,d,g,x,x),x)},
ZO:function ZO(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
Um:function Um(d,e,f,g,h){var _=this
_.bg=null
_.dD=$
_.C=d
_.T=null
_.ad=e
_.bS=null
_.F$=f
_.dy=g
_.b=_.fy=null
_.c=0
_.y=_.d=null
_.z=!0
_.Q=null
_.as=!1
_.at=null
_.ay=$
_.ch=h
_.CW=!1
_.cx=$
_.cy=!0
_.db=!1
_.dx=$},
mk:function mk(d){this.d=this.b=null
this.a=d},
qA:function qA(){},
Ez:function Ez(d){this.a=d},
Rl:function Rl(d){this.a=d},
Rn:function Rn(){},
qz:function qz(d,e){this.a=d
this.b=e},
qg:function qg(d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s){var _=this
_.t=d
_.K=e
_.P=f
_.a2=g
_.U=h
_.ac=i
_.a4=j
_.aZ=_.al=null
_.b3=k
_.aD=l
_.c5=m
_.cn=n
_.cf=o
_.cb=p
_.bR=null
_.aw=q
_.bH=null
_.bl=$
_.dy=r
_.b=_.fy=null
_.c=0
_.y=_.d=null
_.z=!0
_.Q=null
_.as=!1
_.at=null
_.ay=$
_.ch=s
_.CW=!1
_.cx=$
_.cy=!0
_.db=!1
_.dx=$},
aqE:function aqE(){},
aqD:function aqD(d){this.a=d},
aqC:function aqC(d){this.a=d},
aqF:function aqF(){},
aqA:function aqA(d,e){this.a=d
this.b=e},
aqB:function aqB(){},
aqG:function aqG(){},
aqH:function aqH(d){this.a=d},
AP:function AP(d,e){this.a=d
this.b=e},
Q4:function Q4(d,e){this.c=d
this.a=e},
bd9(d,e,f,g){var x
if(B.b.eO(e,new C.aw6())){x=A.a3(e).i("a9<1,h7?>")
x=A.U(new A.a9(e,new C.aw7(),x),x.i("ap.E"))
x.$flags=1
x=x}else x=null
return new C.I4(e,f,d,g,x,null)},
jv:function jv(d,e,f){this.a=d
this.b=e
this.c=f},
iU:function iU(d,e){this.a=d
this.b=e},
I4:function I4(d,e,f,g,h,i){var _=this
_.c=d
_.d=e
_.r=f
_.w=g
_.y=h
_.a=i},
aw6:function aw6(){},
aw7:function aw7(){},
a4M:function a4M(d,e,f,g){var _=this
_.p1=d
_.p2=!1
_.p3=e
_.c=_.b=_.a=_.CW=_.ay=null
_.d=$
_.e=f
_.r=_.f=null
_.w=g
_.z=_.y=null
_.Q=!1
_.as=!0
_.at=!1},
aMI:function aMI(d,e){this.a=d
this.b=e},
aMH:function aMH(d,e,f){this.a=d
this.b=e
this.c=f},
aMJ:function aMJ(){},
aMK:function aMK(d){this.a=d},
aMG:function aMG(){},
aMF:function aMF(){},
aML:function aML(){},
I5:function I5(d,e,f){this.c=d
this.d=e
this.a=f},
a4L:function a4L(d,e,f){this.f=d
this.b=e
this.a=f},
By:function By(d,e){this.a=d
this.b=e},
a72:function a72(){},
b7K(d){var x
d.ak(y.P)
x=A.a5(d)
return x.y2}},D,T,E,A_,A0,U,M,V,A1,L,A2,A3,A4,A5,W,A6,A7,P,G,Q,H,A8,A9,F,I,Aa,X,Y,R,Ab,N,Ac,O
J=c[1]
A=c[0]
B=c[2]
S=c[105]
Z=c[123]
K=c[43]
C=a.updateHolder(c[15],C)
D=c[124]
T=c[23]
E=c[118]
A_=c[111]
A0=c[25]
U=c[32]
M=c[82]
V=c[33]
A1=c[47]
L=c[48]
A2=c[44]
A3=c[121]
A4=c[28]
A5=c[125]
W=c[119]
A6=c[31]
A7=c[79]
P=c[76]
G=c[65]
Q=c[77]
H=c[64]
A8=c[87]
A9=c[29]
F=c[89]
I=c[42]
Aa=c[97]
X=c[34]
Y=c[58]
R=c[99]
Ab=c[21]
N=c[60]
Ac=c[27]
O=c[26]
C.rF.prototype={
E(d){var x=null,w=this.c,v=C.bgn(w),u=w.b,t=A.p1(x,B.l,x,x,0,B.e,A.dx(x,x,B.rL,x,x,C.biI(),x,x,"Back"),A.x(u,1,B.a_,x,x,B.hO,x,x)),s=y.p,r=A.b([new C.a1l(w,B.l,x)],s),q=u.toLowerCase()
if(B.c.q(q,"program")||B.c.q(q,"schedule")){u=w.a
u=u!=="1814796"&&u!=="1814797"}else u=!1
if(u)B.b.J(r,A.b([B.G,new C.IZ(B.l,x)],s))
r.push(A1.Z)
u=w.a
if(u==="1411159")r.push(new C.a1d(B.l,x))
else if(u==="1814796"||u==="1814797")r.push(new C.Ls(B.l,x))
else if(u==="1411179")r.push(new C.Ka(w,B.l,x))
else if(u==="1411162")r.push(new C.a_L(w,B.l,x))
else if(u==="1411158")r.push(new C.a61(B.l,x))
else if(u==="1411172")r.push(new C.Zr(B.l,x))
else if(v.length===0)r.push(new C.AB(B.l,x))
else B.b.J(r,new A.a9(v,new C.a8L(),A.a3(v).i("a9<1,d>")))
w=w.r
if(w.length!==0)B.b.J(r,A.b([B.G,new C.Zt(w,B.l,x)],s))
return A.f8(t,B.a3,A.yc(r,x,D.lQ,x,!1),x,x)}}
C.a1l.prototype={
E(d){var x=null,w=A.a_(8),v=this.d,u=A.bi(A.Z(45,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),1),t=A.Z(20,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),s=A.a_(8),r=this.c.b,q=y.p
return A.a6(x,A.aA(A.b([A.a6(x,A.aC(C.bhj(r),v,x,x),B.i,x,x,new A.ac(t,x,x,s,x,x,B.o),x,44,x,x,x,x,x,44),P.DE,A.b7(A.an(A.b([A.x(r,x,x,x,x,D.os,x,x),B.aY,A.x("APSCVIR 2026",x,x,x,x,A.Y(x,x,v,x,x,x,x,x,x,x,x,12,x,x,B.x,x,x,!0,x,0,x,x,x,x,x,x),x,x)],q),B.u,B.h,B.j),1)],q),B.p,B.h,B.j,0,x,x),B.i,x,x,new A.ac(B.e,x,u,w,x,x,B.o),x,x,x,x,D.e_,x,x,x)}}
C.Ap.prototype={
E(d){var x=this,w=null,v=x.c
switch(v.a){case"heading":return new A.aP(D.LA,A.x(v.b,w,w,w,w,A.Y(w,w,x.d,w,w,w,w,w,w,w,w,19,w,w,B.C,w,1.25,!0,w,w,w,w,w,w,w,w),w,w),w)
case"image":v=v.c
if(v.length===0)return B.a5
return new A.aP(D.qE,A.n3(A.a_(8),A.pa(A.rE(B.H,v,new C.aAC(x),B.fE,w,1/0),B.e,!0),B.ao),w)
case"table":return new C.a4K(v.e,x.d,w)
default:v=v.b
if(v.length===0)return B.a5
return new A.aP(D.LB,A.x(v,w,w,w,w,D.a7F,w,w),w)}}}
C.a4K.prototype={
E(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=null,k=this.c
if(k.length===0)return B.a5
x=A.a_(8)
w=this.d
v=A.bi(A.Z(40,w.m()>>>16&255,w.m()>>>8&255,w.m()&255),1)
u=A.Z(18,w.m()>>>16&255,w.m()>>>8&255,w.m()&255)
t=A.b([],y.E)
for(s=0;s<J.bD(B.b.gY(k));++s){r=J.d2(B.b.gY(k),s)
t.push(new C.Qt(A.x(r,l,l,l,l,new A.n(!0,w,l,l,l,l,l,B.bl,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l),l,l)))}w=A.b([],y.j)
for(r=A.hk(k,1,l,A.a3(k).c),q=r.$ti,r=new A.bm(r,r.gD(0),q.i("bm<ap.E>")),p=y.d,q=q.i("ap.E");r.u();){o=r.d
if(o==null)o=q.a(o)
n=A.b([],p)
for(m=J.b9(o),s=0;s<J.bD(B.b.gY(k));++s)n.push(new C.Qs(A.x(s<m.gD(o)?m.h(o,s):"",l,l,l,l,l,l,l)))
w.push(new C.xx(n))}return A.a6(l,A.jt(new C.Qv(t,l,l,new A.bj(u,y.cE),w,C.b7L(t),l),l,B.F,l,l,B.aC),B.i,l,l,new A.ac(B.e,l,v,x,l,l,B.o),l,l,l,D.qE,l,l,l,l)}}
C.a1d.prototype={
E(d){var x=this.c
return A.an(A.b([new C.Js(x,"Organization",D.TZ,D.J9,null),I.dm,new C.Js(x,"Host Organizational Members",D.Se,B.ae,null),I.dm,new C.a1c(x,"assets/apscvir2026/images/organizing-committee-01-20240110230430-15331-276a808372.png","assets/apscvir2026/images/organizing-committee-02-20250624171034-49945-380e68e5bb.png",null)],y.p),B.aB,B.h,B.j)}}
C.Ka.prototype={
a9(){return new C.ZU()}}
C.ZU.prototype={
am(){var x,w=this
w.aG()
x=C.aPn(w.a.c)
w.d!==$&&A.b8()
w.d=x},
E(d){var x=this.d
x===$&&A.a()
return new A.ed(x,new C.aDl(this),null,null,y.y)},
aj5(d){var x=J.ij(d,new C.aDf(this,B.c.aA(this.e).toLowerCase()))
x=A.U(x,x.$ti.i("w.E"))
return x}}
C.a_1.prototype={
E(d){var x=null,w=A.a_(8),v=this.c,u=A.bi(A.Z(40,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),1),t=A.Z(18,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),s=A.a_(8),r=y.p
return A.a6(x,A.aA(A.b([A.a6(x,A.aC(B.j6,v,x,x),B.i,x,x,new A.ac(t,x,x,s,x,x,B.o),x,42,x,x,x,x,x,42),H.c6,A.b7(A.an(A.b([A.x(""+this.e+" / "+this.d+" Faculty",x,x,x,x,D.os,x,x),Q.fk,D.a8t],r),B.u,B.h,B.j),1)],r),B.p,B.h,B.j,0,x,x),B.i,x,x,new A.ac(B.e,x,u,w,x,x,B.o),x,x,x,x,B.E,x,x,x)}}
C.a_0.prototype={
E(d){var x=null,w=this.c,v=A.aC(A2.eY,w,x,x)
return X.fV(x,X.fm(x,x,x,A5.qG,x,x,x,x,!0,new A.cm(4,A.a_(8),new A.az(A.Z(45,w.m()>>>16&255,w.m()>>>8&255,w.m()&255),1,B.w,-1)),x,x,x,x,x,B.e,!0,x,x,x,x,new A.cm(4,A.a_(8),new A.az(w,1.5,B.w,-1)),x,x,x,x,x,x,x,x,E.EH,"Search faculty, hospital, country...",x,x,x,x,x,x,x,x,x,!0,!0,!1,x,v,x,x,x,x,x,x,x,x,x,x,x,x),x,x,x,!1,this.d,x,x,B.aj,B.ol)}}
C.ZX.prototype={
E(d){var x,w,v,u,t,s,r,q,p,o=this,n=null,m=A.b([""],y.s)
B.b.J(m,o.d)
x=A.a_(8)
w=o.c
v=A.bi(A.Z(35,w.m()>>>16&255,w.m()>>>8&255,w.m()&255),1)
u=A.b([],y.p)
for(t=m.length,s=o.e,r=0;r<m.length;m.length===t||(0,A.y)(m),++r){q=m[r]
p=q.length===0?"All":q
u.push(new A.aP(D.KY,new C.ZW(p,q===s,w,new C.aDm(o,q),n),n))}return A.a6(n,A.jt(A.aA(u,B.p,B.h,B.j,0,n,n),n,B.F,B.lT,n,B.aC),B.i,n,n,new A.ac(B.e,n,v,x,n,n,B.o),n,n,n,n,Y.eP,n,n,n)}}
C.ZW.prototype={
E(d){var x=this,w=null,v=x.d,u=x.e,t=v?u:A.Z(14,u.m()>>>16&255,u.m()>>>8&255,u.m()&255),s=A.a_(999),r=A.a_(999),q=x.c,p=q==="All"?48:34
return A.eg(!1,B.I,!0,s,A.he(!1,r,!0,A.c1(A.c4(A.x(q,w,w,w,w,A.Y(w,w,v?B.e:u,w,w,w,w,w,w,w,w,12,w,w,B.C,w,w,!0,w,w,w,w,w,w,w,w),w,w),w,w,w),34,p),w,!0,w,w,w,w,w,w,w,w,w,x.f,w,w,w,w,w,w),B.i,t,0,w,w,w,w,w,B.b8)}}
C.ZV.prototype={
E(d){var x=null,w=this.d,v=A.a_(8)
return A.aA(A.b([A.a6(x,A.c4(A.x(this.c,x,x,x,x,D.EB,x,x),x,x,x),B.i,x,x,new A.ac(w,x,x,v,x,x,B.o),x,30,x,x,x,x,x,30),B.aq,A.b7(Ac.ack(A.Z(50,w.m()>>>16&255,w.m()>>>8&255,w.m()&255),x),1)],y.p),B.p,B.h,B.j,0,x,x)}}
C.ZZ.prototype={
E(d){var x=null,w=this.d,v=this.c,u=y.p
return new A.aP(W.lK,A.eg(!1,B.I,!0,A.a_(8),A.he(!1,A.a_(8),!0,new A.aP(L.ci,A.aA(A.b([new C.K9(v,w,58,x),H.c6,A.b7(A.an(A.b([A.x(v.b,x,x,x,x,D.a68,x,x),K.cX,A.a6(x,x,B.i,A.Z(90,B.e.m()>>>16&255,B.e.m()>>>8&255,B.e.m()&255),x,x,x,1,x,x,x,x,x,1/0),K.cX,A.x(v.c,2,B.a_,x,x,D.a62,x,x)],u),B.u,B.h,B.j),1),B.aq,D.NE],u),B.p,B.h,B.j,0,x,x),x),x,!0,x,x,x,x,x,x,x,x,x,new C.aDo(this),x,x,x,x,x,x),B.i,w,0,x,x,x,x,x,B.b8),x)}}
C.K9.prototype={
E(d){var x=this,w=null,v=x.e,u=A.bi(B.e,2),t=x.c,s=t.e
t=s.length===0?new C.vN(t,x.d,w):A.rE(B.H,s,new C.aDe(x),B.by,w,w)
return A.a6(w,t,B.ao,w,w,new A.ac(B.e,w,u,w,w,w,B.bc),w,v,w,w,w,w,w,v)}}
C.vN.prototype={
E(d){var x=null,w=B.c.aA(this.c.b)
w=w.length===0?"?":w[0].toUpperCase()
return A.c4(A.x(w,x,x,x,x,A.Y(x,x,this.d,x,x,x,x,x,x,x,x,22,x,x,B.C,x,x,!0,x,x,x,x,x,x,x,x),x,x),x,x,x)}}
C.ZY.prototype={
E(d){var x=null,w=A.a_(8),v=this.c,u=A.bi(A.Z(40,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),1)
return A.a6(x,A.aA(A.b([A.c1(O.aa4(x,v,x,x,x,x,x,2,x,x),18,18),F.co,D.LP],y.p),B.p,B.h,B.j,0,x,x),B.i,x,x,new A.ac(B.e,x,u,w,x,x,B.o),x,x,x,x,D.e_,x,x,x)}}
C.a__.prototype={
E(d){var x=null,w=A.a_(8),v=this.c
return A.a6(x,D.a8r,B.i,x,x,new A.ac(B.e,x,A.bi(A.Z(40,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),1),w,x,x,B.o),x,x,x,x,D.e_,x,x,x)}}
C.Ag.prototype={
E(d){var x,w,v,u=null,t=this.c,s=A.p1(u,B.l,u,u,0,B.e,u,D.a8A),r=A.a_(8),q=A.bi(A.Z(45,B.l.m()>>>16&255,B.l.m()>>>8&255,B.l.m()&255),1),p=y.p
r=A.a6(u,A.an(A.b([new C.K9(t,B.l,104,u),I.dm,A.x(t.b,u,u,u,u,D.a3B,B.at,u),B.as,A.x(t.c,u,u,u,u,D.a4X,B.at,u)],p),B.p,B.h,B.j),B.i,u,u,new A.ac(B.e,u,q,r,u,u,B.o),u,u,u,u,D.e_,u,u,u)
q=A.a_(8)
x=A.bi(A.Z(40,B.l.m()>>>16&255,B.l.m()>>>8&255,B.l.m()&255),1)
w=A.b([new C.r6(D.MH,"Index",t.d,B.l,u)],p)
if(t.ga2_().length!==0)B.b.J(w,A.b([B.G,new C.r6(E.mK,"Country / Region",t.ga2_(),B.l,u)],p))
q=A.a6(u,A.an(w,B.u,B.h,B.j),B.i,u,u,new A.ac(B.e,u,x,q,u,u,B.o),u,u,u,u,B.E,u,u,u)
x=A.Z(12,B.l.m()>>>16&255,B.l.m()>>>8&255,B.l.m()&255)
w=A.a_(8)
v=A.bi(A.Z(35,B.l.m()>>>16&255,B.l.m()>>>8&255,B.l.m()&255),1)
return A.f8(s,B.a3,A.yc(A.b([r,B.G,q,B.G,A.a6(u,A.aA(A.b([D.NJ,B.aq,A.b7(T.aTj("https://www.apscvir2026.com/en/minisite/speaker-detail/29839?user_id="+t.a,D.EJ),1)],p),B.u,B.h,B.j,0,u,u),B.i,u,u,new A.ac(x,u,v,w,u,u,B.o),u,u,u,u,G.cN,u,u,u)],p),u,D.lQ,u,!1),u,u)}}
C.fa.prototype={
ga2_(){var x=new A.a9(A.b(this.c.split(","),y.s),new C.aDp(),y.e).mL(0,new C.aDq()),w=A.U(x,x.$ti.i("w.E"))
return w.length<2?"":B.b.gaf(w)}}
C.qR.prototype={}
C.a_L.prototype={
E(d){return new A.ed(C.aPo(this.c),new C.aFk(this),null,null,y.F)}}
C.a_M.prototype={
E(d){var x=null,w=A.a_(8),v=this.c,u=A.bi(A.Z(40,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),1),t=A.Z(18,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),s=A.a_(8),r=y.p
return A.a6(x,A.aA(A.b([A.a6(x,A.aC(B.mN,v,x,x),B.i,x,x,new A.ac(t,x,x,s,x,x,B.o),x,42,x,x,x,x,x,42),H.c6,A.b7(A.an(A.b([A.x(""+this.d+" Partner Hotels",x,x,x,x,D.os,x,x),B.aY,D.a8w],r),B.u,B.h,B.j),1)],r),B.u,B.h,B.j,0,x,x),B.i,x,x,new A.ac(B.e,x,u,w,x,x,B.o),x,x,x,x,B.E,x,x,x)}}
C.a_K.prototype={
E(d){var x,w=null,v=A.a_(8),u=this.d,t=A.bi(A.Z(45,u.m()>>>16&255,u.m()>>>8&255,u.m()&255),1),s=this.c,r=y.p,q=A.b([A.x(s.a,w,w,w,w,D.a70,w,w)],r),p=s.b
if(p.length!==0)B.b.J(q,A.b([D.DK,A.x(p,w,w,w,w,D.a4l,w,w)],r))
q=A.b([A.b7(A.an(q,B.u,B.h,B.j),1)],r)
p=s.c
if(p.length!==0)q.push(A.x(p,w,w,w,w,D.a6b,w,w))
q=A.a6(w,A.aA(q,B.u,B.h,B.j,0,w,w),B.i,u,w,w,w,w,w,w,Aa.qM,w,w,w)
p=A.b([new C.Kz(B.j7,"Address",s.d,u,w),B.G,new C.KA("Room Rates",s.f,u,w)],r)
x=s.r
if(x.length!==0)B.b.J(p,A.b([B.cE,new C.KA("Buffet Rates",x,u,w)],r))
s=s.w
if(s.length!==0)B.b.J(p,A.b([B.cE,new C.a_I(s,u,w)],r))
p.push(I.dm)
p.push(A.c1(C.aXz(D.rI,D.a8H,new C.aFj(this),A.fH(w,w,u,w,w,w,w,w,w,B.e,w,w,w,w,new A.bN(A.a_(8),B.v),w,w,w,E.oq,w)),44,w))
return A.a6(w,A.an(A.b([q,new A.aP(G.cN,A.an(p,B.aB,B.h,B.j),w)],r),B.aB,B.h,B.j),B.ao,w,w,new A.ac(B.e,w,t,v,w,w,B.o),w,w,w,w,w,w,w,w)}}
C.Kz.prototype={
E(d){var x=this,w=null
return A.aA(A.b([A.aC(x.c,x.f,w,18),B.aq,A.b7(A.ar0(w,w,w,B.ca,w,w,!0,w,A.cP(A.b([A.cP(w,w,w,w,w,w,w,w,w,D.a5E,x.d+": "),A.cP(w,w,w,w,w,w,w,w,w,w,x.e)],y.m),w,w,w,w,w,w,w,w,D.a3U,w),B.aj,w,w,B.b0,B.aT),1)],y.p),B.u,B.h,B.j,0,w,w)}}
C.KA.prototype={
E(d){var x,w,v,u,t,s,r,q=null,p=this.d
if(p.length===0)return B.a5
x=A.a_(8)
w=this.e
v=y.p
u=A.b([A.x(this.c,q,q,q,q,A.Y(q,q,w,q,q,q,q,q,q,q,q,14,q,q,B.C,q,q,!0,q,q,q,q,q,q,q,q),q,q),B.as],v)
for(t=p.length,s=0;s<p.length;p.length===t||(0,A.y)(p),++s){r=p[s]
u.push(new A.aP(D.qD,A.aA(A.b([new A.ha(1,B.c2,A.x(r.a,q,q,q,q,D.Es,q,q),q),B.aq,new A.j8(1,B.da,A.x(r.b,q,q,q,q,D.a78,B.dK,q),q)],v),B.u,B.h,B.j,0,q,q),q))}return A.a6(q,A.an(u,B.u,B.h,B.j),B.i,q,q,new A.ac(B.a3,q,new A.dJ(B.v,B.v,B.v,new A.az(w,3,B.w,-1)),x,q,q,B.o),q,q,q,q,L.ci,q,q,q)}}
C.a_I.prototype={
E(d){var x,w,v,u,t=null,s=A.a_(8),r=this.d,q=A.bi(A.Z(35,r.m()>>>16&255,r.m()>>>8&255,r.m()&255),1),p=A.b([A.x("Distance Information",t,t,t,t,A.Y(t,t,r,t,t,t,t,t,t,t,t,14,t,t,B.C,t,t,!0,t,t,t,t,t,t,t,t),t,t),B.as],y.p)
for(x=this.c,w=x.length,v=0;v<x.length;x.length===w||(0,A.y)(x),++v){u=x[v]
p.push(new A.aP(D.qD,new C.Kz(E.rC,u.a,u.b,r,t),t))}return A.a6(t,A.an(p,B.u,B.h,B.j),B.i,t,t,new A.ac(B.e,t,q,s,t,t,B.o),t,t,t,t,L.ci,t,t,t)}}
C.a_J.prototype={
E(d){var x=null,w=A.a_(8),v=this.c,u=A.bi(A.Z(40,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),1)
return A.a6(x,A.aA(A.b([A.c1(O.aa4(x,v,x,x,x,x,x,2,x,x),18,18),F.co,D.LQ],y.p),B.p,B.h,B.j,0,x,x),B.i,x,x,new A.ac(B.e,x,u,w,x,x,B.o),x,x,x,x,D.e_,x,x,x)}}
C.qV.prototype={}
C.kn.prototype={}
C.a61.prototype={
E(d){var x,w=null,v=this.c,u=y.p,t=A.b([new C.a66(v,w),B.G,new C.a65(v,w),B.G],u)
for(x=0;x<5;++x)B.b.J(t,A.b([new C.a63(D.Sf[x],v,w),B.cE],u))
t.push(new C.a62(v,w))
return A.an(t,B.aB,B.h,B.j)}}
C.a66.prototype={
E(d){var x=null,w=A.a_(8),v=this.c,u=A.bi(A.Z(40,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),1),t=A.Z(18,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),s=A.a_(8),r=y.p
return A.a6(x,A.an(A.b([A.aA(A.b([A.a6(x,A.aC(B.j4,v,x,x),B.i,x,x,new A.ac(t,x,x,s,x,x,B.o),x,42,x,x,x,x,x,42),H.c6,D.LN],r),B.u,B.h,B.j,0,x,x),B.G,D.a8i],r),B.u,B.h,B.j),B.i,x,x,new A.ac(B.e,x,u,w,x,x,B.o),x,x,x,x,B.E,x,x,x)}}
C.a65.prototype={
E(d){var x,w=null,v=A.a_(8),u=this.c,t=A.bi(A.Z(40,u.m()>>>16&255,u.m()>>>8&255,u.m()&255),1),s=A.b([],y.p)
for(x=0;x<4;++x)s.push(new C.a64(D.TV[x],u,w))
return A.a6(w,U.IV(M.d1,s,M.fs,8,8),B.i,w,w,new A.ac(B.e,w,t,v,w,w,B.o),w,w,w,w,L.ci,w,w,w)}}
C.a64.prototype={
E(d){var x=null,w=A.bI(d,B.fy,y.w).w.a.a<380?1/0:170,v=A.a_(8),u=A.bi(B.c0,1),t=this.c,s=this.d,r=y.p
return A.a6(x,A.aA(A.b([A.aC(t.a,s,x,18),B.aq,A.b7(A.an(A.b([A.x(t.b,x,x,x,x,A.Y(x,x,s,x,x,x,x,x,x,x,x,13,x,x,B.C,x,x,!0,x,x,x,x,x,x,x,x),x,x),Q.fk,A.x(t.c,x,x,x,x,D.a5Q,x,x)],r),B.u,B.h,B.j),1)],r),B.u,B.h,B.j,0,x,x),B.i,x,x,new A.ac(B.a3,x,u,v,x,x,B.o),x,x,x,x,N.iE,x,x,w)}}
C.a63.prototype={
E(d){var x=null,w=A.a_(8),v=this.d,u=A.bi(A.Z(38,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),1),t=this.c,s=y.p
return A.a6(x,A.aA(A.b([A.a6(x,x,B.i,x,x,new A.ac(v,x,x,x,x,x,B.bc),x,8,x,D.qI,x,x,x,8),F.co,A.b7(A.an(A.b([A.x(t.a+" ("+t.b+" countries)",x,x,x,x,A.Y(x,x,v,x,x,x,x,x,x,x,x,15,x,x,B.C,x,1.25,!0,x,x,x,x,x,x,x,x),x,x),K.cX,A.x(t.c,x,x,x,x,D.a5X,x,x)],s),B.u,B.h,B.j),1)],s),B.u,B.h,B.j,0,x,x),B.i,x,x,new A.ac(B.e,x,u,w,x,x,B.o),x,x,x,x,G.cN,x,x,x)}}
C.a62.prototype={
E(d){var x=null,w=this.c,v=A.Z(12,w.m()>>>16&255,w.m()>>>8&255,w.m()&255),u=A.a_(8),t=A.bi(A.Z(35,w.m()>>>16&255,w.m()>>>8&255,w.m()&255),1),s=A.Z(150,w.m()>>>16&255,w.m()>>>8&255,w.m()&255)
return A.a6(x,A.an(A.b([D.a8m,B.cE,A.c1(A6.FE(D.rI,D.a8I,new C.aNX(),A.ui(x,x,x,x,x,x,x,x,x,w,x,x,x,x,new A.bN(A.a_(8),B.v),new A.az(s,1,B.w,-1),x,x,E.oq,x)),42,x)],y.p),B.aB,B.h,B.j),B.i,x,x,new A.ac(v,x,t,u,x,x,B.o),x,x,x,x,G.cN,x,x,x)}}
C.rl.prototype={}
C.wh.prototype={}
C.Js.prototype={
E(d){var x,w,v,u,t,s=this,r=null,q=A.a_(8),p=s.c,o=A.bi(A.Z(40,p.m()>>>16&255,p.m()>>>8&255,p.m()&255),1),n=A.a6(r,r,B.i,r,r,new A.ac(p,r,r,A.a_(999),r,r,B.o),r,r,r,Z.qH,r,r,r,3),m=y.p
p=A.b([A.x(s.d,r,r,r,r,A.Y(r,r,p,r,r,r,r,r,r,r,r,16,r,r,B.C,r,1.25,!0,r,r,r,r,r,r,r,r),r,r),B.as],m)
for(x=s.e,w=x.length,v=s.f,u=0;u<w;++u){t=x[u]
p.push(new A.aP(D.KX,A.x(t,r,r,r,r,new A.n(!0,v,r,r,r,r,14,B.aa,r,r,r,r,1.45,r,r,r,r,r,r,r,r,r,r,r,r,r),r,r),r))}return A.a6(r,new A.EA(A.aA(A.b([n,A.b7(new A.aP(G.cN,A.an(p,B.u,B.h,B.j),r),1)],m),B.aB,B.h,B.j,0,r,r),r),B.i,r,r,new A.ac(B.e,r,o,q,r,r,B.o),r,r,r,r,r,r,r,r)}}
C.a1c.prototype={
E(d){var x=this,w=null,v=A.a_(8),u=x.c,t=A.bi(A.Z(45,u.m()>>>16&255,u.m()>>>8&255,u.m()&255),1),s=x.e,r=y.p
return A.a6(w,A.an(A.b([A.a6(w,D.a8G,B.i,u,w,w,w,w,w,w,D.Lb,w,w,w),new A.aP(B.E,A.aA(A.b([new C.Q4(A.rE(B.H,x.d,new C.aII(x),B.by,106,106),w),A8.dl,A.b7(A.an(A.b([new C.vD(s,"Academician of the Chinese Academy of Sciences",w),new C.vD(s,"President of the Chinese College of Interventionalists (CCI)",w),new C.vD(s,"Former President of Chinese Society of Interventional Radiology (CSIR)",w),new C.vD(s,"Former President of Asia-Pacific Society of Cardiovascular and Interventional Radiology (APSCVIR) (2016-2018)",w)],r),B.u,B.h,B.j),1)],r),B.u,B.h,B.j,0,w,w),w)],r),B.aB,B.h,B.j),B.ao,w,w,new A.ac(B.e,w,t,v,w,w,B.o),w,w,w,w,w,w,w,w)}}
C.vD.prototype={
E(d){var x=null
return new A.aP(N.lM,A.aA(A.b([new A.aP(D.qI,A.rE(B.H,this.c,new C.aAp(),B.by,8,8),x),B.aq,A.b7(A.x(this.d,x,x,x,x,D.a6Y,x,x),1)],y.p),B.u,B.h,B.j,0,x,x),x)}}
C.Ls.prototype={
a9(){return new C.a24()}}
C.a24.prototype={
am(){this.aG()
var x=A.xy("20262026-0611-4614-8614-000000029839")
this.d!==$&&A.b8()
this.d=x},
E(d){var x=A.abw("20262026-0611-4614-8614-000000029839"),w=this.d
w===$&&A.a()
return new A.ed(w,new C.aJz(this,x),x,null,y.g)},
akA(d){var x,w,v,u=A.B(y.N,y.aF)
for(x=d.length,w=0;w<d.length;d.length===x||(0,A.y)(d),++w){v=d[w]
J.dA(u.bP(v.r,new C.aJt()),v)}for(x=new A.cS(u,u.r,u.e);x.u();)J.C8(x.d,new C.aJu())
return u},
apn(d,e){var x,w,v,u,t,s,r=A.B(y.N,y._)
for(x=e.length,w=0;w<e.length;e.length===x||(0,A.y)(e),++w){v=e[w]
r.p(0,this.Y7(v),v)}x=A.b([],y.I)
for(u=J.by(d);u.u();){t=u.gN()
s=r.h(0,this.Y7(t))
x.push(s==null?t:s)}return x},
aof(d){var x,w,v,u,t=A.aL(y.N),s=A.b([],y.I)
for(x=d.length,w=0;w<d.length;d.length===x||(0,A.y)(d),++w){v=d[w]
u=B.c.aA(v.c).toLowerCase()
if((B.c.q(u,"opening ceremony")||B.c.q(u,"closing ceremony"))&&t.A(0,v.a))s.push(v)}B.b.d5(s,new C.aJv())
return s},
Y7(d){var x=B.c.aA(d.r),w=d.glt()
return B.b.bh(A.b([d.ch,x.toLowerCase(),A.aG(w," ",""),B.c.aA(d.c).toLowerCase()],y.f),"|")}}
C.a2i.prototype={
E(d){var x,w,v,u=null,t=A.a_(8),s=this.c,r=A.bi(A.Z(45,s.m()>>>16&255,s.m()>>>8&255,s.m()&255),1),q=y.p,p=A.b([A.aA(A.b([A.aC(D.Nk,s,u,22),B.aq,A.x("Important Events",u,u,u,u,A.Y(u,u,s,u,u,u,u,u,u,u,u,16,u,u,B.C,u,u,!0,u,u,u,u,u,u,u,u),u,u)],q),B.p,B.h,B.j,0,u,u),B.cE],q)
for(x=this.d,w=0;w<x.length;++w){v=A.b([new C.a2h(s,x[w],u)],q)
if(w!==x.length-1)v.push(new V.nb(14,A.Z(150,B.c0.m()>>>16&255,B.c0.m()>>>8&255,B.c0.m()&255),u))
B.b.J(p,v)}return A.a6(u,A.an(p,B.aB,B.h,B.j),B.i,u,u,new A.ac(B.e,u,r,t,u,u,B.o),u,u,u,u,G.cN,u,u,u)}}
C.a2h.prototype={
E(d){var x=null,w=A.a_(8),v=this.c,u=A.Z(14,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),t=A.a_(8),s=this.d,r=s.x,q=y.p
return A.eg(!1,B.I,!0,x,A.he(!1,w,!0,new A.aP(Y.eP,A.aA(A.b([A.a6(x,A.an(A.b([A.x(B.jd[A.cx(r)-1],x,x,x,x,A.Y(x,x,v,x,x,x,x,x,x,x,x,11,x,x,B.C,x,1,!0,x,x,x,x,x,x,x,x),x,x),D.DK,A.x(B.f.j(A.cZ(r)),x,x,x,x,A.Y(x,x,v,x,x,x,x,x,x,x,x,18,x,x,B.C,x,1,!0,x,x,x,x,x,x,x,x),x,x)],q),B.p,B.h,B.j),B.i,x,x,new A.ac(u,x,x,t,x,x,B.o),x,x,x,x,D.L0,x,x,48),F.co,A.b7(A.an(A.b([A.x(s.c,x,x,x,x,D.a7J,x,x),B.aY,A.x(s.glt()+" \xb7 "+s.r,x,x,x,x,D.Es,x,x)],q),B.u,B.h,B.j),1),A.aC(B.dc,A.Z(180,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),x,x)],q),B.u,B.h,B.j,0,x,x),x),x,!0,x,x,x,x,x,x,x,x,x,new C.aJG(this),x,x,x,x,x,x),B.i,B.D,0,x,x,x,x,x,B.b8)}}
C.a26.prototype={
E(d){var x,w,v,u=null,t=A.a_(8),s=this.c,r=A.bi(A.Z(45,s.m()>>>16&255,s.m()>>>8&255,s.m()&255),1),q=y.p,p=A.b([],q)
for(x=this.d,w=0;w<4;++w){v=D.tn[w]
v=A.b([new A.ha(1,B.c2,new C.a25(v,s,v.a===x,new C.aJA(this,D.tn,w),u),u)],q)
if(w!==3)v.push(B.aq)
B.b.J(p,v)}return A.a6(u,A.aA(p,B.p,B.h,B.j,0,u,u),B.i,u,u,new A.ac(B.e,u,r,t,u,u,B.o),u,u,u,u,N.iE,u,u,u)}}
C.w1.prototype={}
C.a25.prototype={
E(d){var x,w,v=this,u=null,t=v.e,s=t?B.e:v.d,r=A.a_(8),q=v.d,p=t?q:A.Z(14,q.m()>>>16&255,q.m()>>>8&255,q.m()&255),o=A.a_(8),n=t?0:45
q=A.bi(A.Z(n,q.m()>>>16&255,q.m()>>>8&255,q.m()&255),1)
n=A.x("Jun",u,u,u,u,A.Y(u,u,s,u,u,u,u,u,u,u,u,12,u,u,B.bl,u,1,!0,u,u,u,u,u,u,u,u),u,u)
x=v.c
w=A.x(x.c,u,u,u,u,A.Y(u,u,s,u,u,u,u,u,u,u,u,24,u,u,B.C,u,1,!0,u,u,u,u,u,u,u,u),u,u)
return A.eg(!1,B.I,!0,u,A.he(!1,r,!0,A.a6(u,A.an(A.b([n,B.aY,w,B.aY,A.x(x.d,u,u,u,u,A.Y(u,u,t?B.a9:B.cf,u,u,u,u,u,u,u,u,11,u,u,B.x,u,1,!0,u,u,u,u,u,u,u,u),u,u)],y.p),B.p,B.bC,B.j),B.i,u,u,new A.ac(p,u,q,o,u,u,B.o),u,68,u,u,u,u,u,u),u,!0,u,u,u,u,u,u,u,u,u,v.f,u,u,u,u,u,u),B.i,B.D,0,u,u,u,u,u,B.b8)}}
C.a2g.prototype={
E(d){var x=null,w=A.a_(8),v=this.c,u=A.bi(A.Z(40,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),1),t=y.p,s=A.b([],t),r=this.d
if(r)B.b.J(s,A.b([A.c1(O.aa4(x,v,x,x,x,x,x,2,x,x),18,18),F.co],t))
s.push(A.b7(A.x(r?"Loading sessions for this date...":"No sessions are available for this date.",x,x,x,x,D.Ez,x,x),1))
return A.a6(x,A.aA(s,B.p,B.h,B.j,0,x,x),B.i,x,x,new A.ac(B.e,x,u,w,x,x,B.o),x,x,x,x,D.e_,x,x,x)}}
C.a2k.prototype={
E(d){var x,w=null,v=A.a_(8),u=this.c,t=A.bi(A.Z(45,u.m()>>>16&255,u.m()>>>8&255,u.m()&255),1),s=A.a6(w,A.x(this.d,w,w,w,w,D.EB,w,w),B.i,u,w,w,w,w,w,w,D.Le,w,w,w),r=y.p,q=A.b([],r)
for(x=J.by(this.e);x.u();)q.push(new C.a2l(u,x.gN(),w))
return A.a6(w,A.an(A.b([s,new A.aP(D.L9,A.an(q,B.p,B.h,B.j),w)],r),B.aB,B.h,B.j),B.ao,w,w,new A.ac(B.e,w,t,v,w,w,B.o),w,w,w,w,w,w,w,w)}}
C.a2l.prototype={
E(d){var x=null,w=A.a_(8),v=A.bi(B.c0,1),u=A.a_(8),t=this.c,s=A.l5(0,A.a6(x,x,B.i,x,x,new A.ac(t,x,x,D.FT,x,x,B.o),x,x,x,x,x,x,x,5),x,x,0,x,0,x),r=this.d,q=y.p
t=A.b([A.aA(A.b([A.aC(R.eX,t,x,15),D.DG,A.x(r.glt(),x,x,x,x,A.Y(x,x,t,x,x,x,x,x,x,x,x,13,x,x,B.C,x,x,!0,x,x,x,x,x,x,x,x),x,x),B.DX,A.aC(B.dc,A.Z(180,t.m()>>>16&255,t.m()>>>8&255,t.m()&255),x,20)],q),B.p,B.h,B.j,0,x,x),K.cX,A.x(r.c,x,x,x,x,D.EI,x,x)],q)
r=r.as
if(r.length!==0&&r!=="APSCVIR Faculty")B.b.J(t,A.b([K.cX,A.x(r,2,B.a_,x,x,D.a2Z,x,x)],q))
return new A.aP(W.lK,A.eg(!1,B.I,!0,x,A.aSK(A.he(!1,u,!0,A.eW(B.b1,A.b([s,new A.aP(D.L7,A.an(t,B.u,B.h,B.j),x)],q),B.O,B.bo,x),x,!0,x,x,x,x,x,x,x,x,x,new C.aJI(this),x,x,x,x,x,x),x,new A.ac(B.a3,x,v,w,x,x,B.o)),B.i,B.D,0,x,x,x,x,x,B.b8),x)}}
C.kG.prototype={
a9(){return new C.XU()}}
C.XU.prototype={
am(){var x,w=this
w.aG()
x=C.aPv(w.a.c)
w.d!==$&&A.b8()
w.d=x},
E(d){var x=null,w=this.a.c,v=C.bi4(w),u=A.p1(x,B.l,x,x,0,B.e,x,D.a8j),t=y.p,s=A.b([new C.a2b(w,B.l,x),B.G,new C.a2c(w,B.l,x)],t),r=w.as
if(r.length!==0&&r!=="APSCVIR Faculty")B.b.J(s,A.b([B.G,new C.a2a(w,B.l,x)],t))
s.push(B.G)
s.push(new C.a2f(w,B.l,x))
if(v.length!==0)B.b.J(s,A.b([B.G,new C.a2e(v,B.l,x)],t))
s.push(B.G)
t=this.d
t===$&&A.a()
s.push(new A.ed(t,new C.ayz(),x,x,y.A))
return A.f8(u,B.a3,A.jt(A.an(s,B.aB,B.h,B.j),x,B.F,D.lQ,x,B.a6),x,x)}}
C.a2b.prototype={
E(d){var x=null,w=A.a_(8),v=this.d,u=A.bi(A.Z(45,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),1),t=A.Z(18,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),s=A.a_(999),r=this.c
return A.a6(x,A.an(A.b([A.a6(x,A.x(r.ga6s(),x,x,x,x,A.Y(x,x,v,x,x,x,x,x,x,x,x,11,x,x,B.C,x,x,!0,x,x,x,x,x,x,x,x),x,x),B.i,x,x,new A.ac(t,x,x,s,x,x,B.o),x,x,x,x,D.L6,x,x,x),B.cE,A.x(r.c,x,x,x,x,D.a36,x,x)],y.p),B.u,B.h,B.j),B.i,x,x,new A.ac(B.e,x,u,w,x,x,B.o),x,x,x,x,D.e_,x,x,x)}}
C.a2c.prototype={
E(d){var x=null,w=A.a_(8),v=this.d,u=A.bi(A.Z(40,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),1),t=this.c,s=t.x
return A.a6(x,A.an(A.b([new C.r6(A7.j1,"Date",B.jd[A.cx(s)-1]+" "+A.cZ(s)+", "+A.dY(s)+" ("+B.tf[A.yM(s)-1]+")",v,x),B.G,new C.r6(R.eX,"Time",t.glt(),v,x),B.G,new C.r6(D.Nc,"Room",t.r,v,x)],y.p),B.p,B.h,B.j),B.i,x,x,new A.ac(B.e,x,u,w,x,x,B.o),x,x,x,x,B.E,x,x,x)}}
C.r6.prototype={
E(d){var x=this,w=null,v=x.f,u=A.Z(16,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),t=A.a_(8),s=y.p
return A.aA(A.b([A.a6(w,A.aC(x.c,v,w,18),B.i,w,w,new A.ac(u,w,w,t,w,w,B.o),w,34,w,w,w,w,w,34),F.co,A.b7(A.an(A.b([A.x(x.d,w,w,w,w,D.a5c,w,w),Q.fk,A.x(x.e,w,w,w,w,D.EI,w,w)],s),B.u,B.h,B.j),1)],s),B.u,B.h,B.j,0,w,w)}}
C.a2a.prototype={
E(d){var x,w,v,u,t,s,r,q,p=null,o=new A.a9(A.b(this.c.as.split(","),y.s),new C.aJB(),y.e).mL(0,new C.aJC()),n=A.U(o,o.$ti.i("w.E"))
o=A.a_(8)
x=this.d
w=A.bi(A.Z(40,x.m()>>>16&255,x.m()>>>8&255,x.m()&255),1)
x=A.x("Faculty",p,p,p,p,A.Y(p,p,x,p,p,p,p,p,p,p,p,16,p,p,B.C,p,p,!0,p,p,p,p,p,p,p,p),p,p)
v=y.p
u=A.b([],v)
for(t=n.length,s=0;s<n.length;n.length===t||(0,A.y)(n),++s){r=new A.aS(999,999)
q=new A.az(B.c0,1,B.w,-1)
u.push(A.a6(p,A.x(n[s],p,p,p,p,D.a35,p,p),B.i,p,p,new A.ac(B.a3,p,new A.dJ(q,q,q,q),new A.cE(r,r,r,r),p,p,B.o),p,p,p,p,A3.lO,p,p,p))}return A.a6(p,A.an(A.b([x,B.cE,U.IV(M.d1,u,M.fs,8,8)],v),B.u,B.h,B.j),B.i,p,p,new A.ac(B.e,p,w,o,p,p,B.o),p,p,p,p,B.E,p,p,p)}}
C.a2f.prototype={
E(d){var x,w
$.O()
x=y.v
w=$.N
if(w==null)w=$.N=B.q
if(!$.cF.ab(w.dK(A.be(x),null)))return B.a5
w=$.N
return new A.dg(new C.aJE(this,(w==null?$.N=B.q:w).aC(null,x)),null)}}
C.a2e.prototype={
E(d){var x=null,w=this.d,v=A.Z(12,w.m()>>>16&255,w.m()>>>8&255,w.m()&255),u=A.a_(8),t=A.bi(A.Z(35,w.m()>>>16&255,w.m()>>>8&255,w.m()&255),1)
return A.a6(x,A.aA(A.b([A.aC(S.mI,w,x,18),B.aq,A.b7(T.aTj(this.c,D.EJ),1)],y.p),B.u,B.h,B.j,0,x,x),B.i,x,x,new A.ac(v,x,t,u,x,x,B.o),x,x,x,x,G.cN,x,x,x)}}
C.a2d.prototype={
E(d){var x=null,w=A.a_(8),v=this.c,u=A.bi(A.Z(40,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),1)
return A.a6(x,A.aA(A.b([A.c1(O.aa4(x,v,x,x,x,x,x,2,x,x),18,18),F.co,D.LM],y.p),B.p,B.h,B.j,0,x,x),B.i,x,x,new A.ac(B.e,x,u,w,x,x,B.o),x,x,x,x,B.E,x,x,x)}}
C.a29.prototype={
E(d){var x=null,w=A.a_(8),v=this.c
return A.a6(x,D.a8y,B.i,x,x,new A.ac(B.e,x,A.bi(A.Z(40,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),1),w,x,x,B.o),x,x,x,x,B.E,x,x,x)}}
C.a27.prototype={
E(d){var x,w,v,u,t=null,s=A.a_(8),r=this.d,q=A.bi(A.Z(40,r.m()>>>16&255,r.m()>>>8&255,r.m()&255),1),p=y.p,o=A.b([A.x("Detailed Agenda",t,t,t,t,A.Y(t,t,r,t,t,t,t,t,t,t,t,16,t,t,B.C,t,t,!0,t,t,t,t,t,t,t,t),t,t),B.G],p)
for(x=this.c,w=J.b9(x),v=0;v<w.gD(x);++v){u=A.b([new C.a28(w.h(x,v),r,t)],p)
if(v!==w.gD(x)-1)u.push(new V.nb(18,A.Z(120,B.c0.m()>>>16&255,B.c0.m()>>>8&255,B.c0.m()&255),t))
B.b.J(o,u)}return A.a6(t,A.an(o,B.u,B.h,B.j),B.i,t,t,new A.ac(B.e,t,q,s,t,t,B.o),t,t,t,t,B.E,t,t,t)}}
C.a28.prototype={
E(d){var x=null,w=this.c,v=A.c1(A.x(w.a,x,x,x,x,A.Y(x,x,this.d,x,x,x,x,x,x,x,x,12,x,x,B.C,x,1.3,!0,x,x,x,x,x,x,x,x),x,x),x,70),u=y.p,t=A.b([A.x(w.b,x,x,x,x,D.a49,x,x)],u),s=w.c
if(s.length!==0){w=w.d
B.b.J(t,A.b([B.aY,A.x(w.length===0?s:s+"\n"+w,x,x,x,x,D.a6h,x,x)],u))}return A.aA(A.b([v,F.co,A.b7(A.an(t,B.u,B.h,B.j),1)],u),B.u,B.h,B.j,0,x,x)}}
C.r5.prototype={}
C.JS.prototype={}
C.Zr.prototype={
E(d){var x,w=null,v=A.a_(8),u=this.c,t=A.bi(A.Z(40,u.m()>>>16&255,u.m()>>>8&255,u.m()&255),1),s=A.Z(18,u.m()>>>16&255,u.m()>>>8&255,u.m()&255),r=A.a_(8),q=y.p
q=A.b([A.a6(w,A.aA(A.b([A.a6(w,A.aC(B.mL,u,w,w),B.i,w,w,new A.ac(s,w,w,r,w,w,B.o),w,42,w,w,w,w,w,42),H.c6,D.LR],q),B.p,B.h,B.j,0,w,w),B.i,w,w,new A.ac(B.e,w,t,v,w,w,B.o),w,w,w,w,B.E,w,w,w),B.G],q)
for(x=0;x<2;++x)q.push(new A.aP(P.lL,new C.Zs(D.QV[x],u,w),w))
return A.an(q,B.aB,B.h,B.j)}}
C.Zs.prototype={
E(d){var x=this,w=null,v=A.a_(8),u=A.a_(8),t=A.a_(8),s=x.d,r=A.bi(A.Z(40,s.m()>>>16&255,s.m()>>>8&255,s.m()&255),1),q=x.c,p=y.p
return A.eg(!1,B.I,!0,v,A.he(!1,u,!0,A.a6(w,A.aA(A.b([A.n3(A.a_(8),A.rE(B.H,q.c,new C.aBS(x),B.by,76,76),B.ao),H.c6,A.b7(A.an(A.b([A.x(q.a,2,B.a_,w,w,D.a7t,w,w),K.cX,A.x(q.b,w,w,w,w,D.EG,w,w),B.as,A.aA(A.b([A.aC(E.mM,s,w,18),D.DG,A.x("Download PPTX",w,w,w,w,A.Y(w,w,s,w,w,w,w,w,w,w,w,12,w,w,B.C,w,w,!0,w,w,w,w,w,w,w,w),w,w)],p),B.p,B.h,B.j,0,w,w)],p),B.u,B.h,B.j),1),A.aC(B.dc,s,w,w)],p),B.p,B.h,B.j,0,w,w),B.i,w,w,new A.ac(w,w,r,t,w,w,B.o),w,w,w,w,L.ci,w,w,w),w,!0,w,w,w,w,w,w,w,w,w,new C.aBT(x),w,w,w,w,w,w),B.i,B.e,0,w,w,w,w,w,B.b8)}}
C.Zt.prototype={
E(d){var x,w,v,u,t,s,r,q,p,o=null,n="[^A-Za-z0-9._-]",m="apscvir-download",l=A.a_(8),k=this.d,j=A.bi(A.Z(40,k.m()>>>16&255,k.m()>>>8&255,k.m()&255),1),i=A.b([A.x("Downloads",o,o,o,o,A.Y(o,o,k,o,o,o,o,o,o,o,o,16,o,o,B.C,o,o,!0,o,o,o,o,o,o,o,o),o,o),B.cE],y.p)
for(x=this.c,w=x.length,v=0;v<x.length;x.length===w||(0,A.y)(x),++v){u=x[v]
t=A.aC(E.mM,k,o,o)
s=A.x(u.c,o,o,o,o,B.hN,o,o)
r=u.a
if(A.a8S(r)==null){q=B.c.aA(B.b.gaf(r.split("/")))
r=A.ar(n,!0,!1)
p=A.aG(q,r,"_")
r="Saved locally - "+(p.length===0?m:p)}else{q=B.c.aA(B.b.gaf(r.split("/")))
r=A.ar(n,!0,!1)
p=A.aG(q,r,"_")
r="Available online - "+(p.length===0?m:p)}i.push(A.ya(B.V,!0,t,o,new C.aBU(u),o,A.x(r,1,B.a_,o,o,o,o,o),o,s,o))}return A.a6(o,A.an(i,B.u,B.h,B.j),B.i,o,o,new A.ac(B.e,o,j,l,o,o,B.o),o,o,o,o,B.E,o,o,o)}}
C.IZ.prototype={
E(d){var x=null,w=A.a_(8),v=this.c,u=A.bi(A.Z(40,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),1),t=A.Z(90,B.cg.m()>>>16&255,B.cg.m()>>>8&255,B.cg.m()&255),s=A.a_(8),r=y.p
return A.a6(x,A.an(A.b([A.aA(A.b([A.a6(x,A.aC(D.MD,v,x,x),B.i,x,x,new A.ac(t,x,x,s,x,x,B.o),x,42,x,x,x,x,x,42),H.c6,D.LO],r),B.u,B.h,B.j,0,x,x),B.G,A.c1(A.hU(D.a8q,this.gaeH(),A.fH(x,x,v,x,x,x,x,x,x,B.e,x,x,x,x,new A.bN(A.a_(8),B.v),x,x,x,x,x)),44,x)],r),B.aB,B.h,B.j),B.i,x,x,new A.ac(B.e,x,u,w,x,x,B.o),x,x,x,x,B.E,x,x,x)},
AA(){var x=0,w=A.t(y.H),v=this,u,t,s,r
var $async$AA=A.u(function(d,e){if(d===1)return A.p(e,w)
for(;;)switch(x){case 0:s=$.O()
r=$.N
if(r==null)r=$.N=B.q
x=2
return A.j(r.aC(null,y.v).kU("20262026-0611-4614-8614-000000029839"),$async$AA)
case 2:u=e
if(u){r=$.N
if(r==null)r=$.N=B.q
r=$.cF.ab(r.dK(A.be(y.Z),null))}else r=!1
if(r){r=$.N
if(r==null)r=$.N=B.q
r=r.aC(null,y.Z).ch
if(!r.q(r,"20262026-0611-4614-8614-000000029839")){t=r.go$
t===$&&A.a()
J.dA(t,"20262026-0611-4614-8614-000000029839")
r.k2$.i4(r.gn())}}r=u?"Added":"No Sessions Available"
t=u?"APSCVIR 2026 sessions were added to My Schedule.":"The local APSCVIR program could not be loaded."
A.e8(s,r,t,u?v.c:B.d6,B.e,B.E,B.au)
return A.q(null,w)}})
return A.r($async$AA,w)}}
C.AB.prototype={
E(d){var x=null,w=A.a_(8),v=this.c
v=A.bi(A.Z(40,v.m()>>>16&255,v.m()>>>8&255,v.m()&255),1)
return A.a6(x,A.x("This page is saved locally. Structured content was not available from the source page.",x,x,x,x,A.Y(x,x,B.bT,x,x,x,x,x,x,x,x,x,x,x,x,x,1.5,!0,x,x,x,x,x,x,x,x),x,x),B.i,x,x,new A.ac(B.e,x,v,w,x,x,B.o),x,x,x,x,A_.eQ,x,x,x)}}
C.vT.prototype={
E(d){var x=null,w=this.c,v=A.Z(18,w.m()>>>16&255,w.m()>>>8&255,w.m()&255)
return A.a6(B.H,A.aC(D.Nb,w,x,x),B.i,v,x,x,x,160,x,x,x,x,x,x)}}
C.Qt.prototype={}
C.xx.prototype={}
C.Qs.prototype={}
C.Qv.prototype={
ahw(d,e){var x,w
for(x=this.CW.length,w=0;w<x;++w);},
Tz(d,e,f,g,h,i,j){var x,w,v,u,t=null,s=A.a5(e).y2,r=s.x
if(r==null)r=24
x=s.Q
w=x==null?r:x
v=x==null?r/2:x
u=A.bz(t,t,new A.aP(new A.dM(w,0,v,0),A.c4(A0.aRZ(t,f,t,t,j,d),t,t,t),t),!0,t,t,!1,t,!1,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t)
return new C.I5(D.Eb,g!=null?C.bda(u,i,t,t,g,h):u,t)},
afr(d,e,f,g,h,i){return this.Tz(d,e,f,g,h,null,i)},
E(c5){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9=this,c0=null,c1=A.a5(c5),c2=C.b7K(c5),c3=b9.Q,c4=c2.b
if(c4==null)c4=c1.y2.b
x=b9.CW
w=B.b.eO(x,new C.abx())
v=w?new A.ah(x,new C.aby(),A.a3(x).i("ah<1>")):A.b([],y.j)
u=J.dt(v)
t=u.kD(v,new C.abz())
s=w&&t.gD(0)===u.gD(v)
r=w&&!t.ga8(0)&&!s
u=c2.x
q=u==null?c1.y2.x:u
if(q==null)q=24
u=c2.Q
p=u==null
o=p?c1.y2.Q:u
if(o==null)o=q
n=p?c1.y2.Q:u
if(n==null)n=q/2
u=c2.y
m=u==null?c1.y2.y:u
if(m==null)m=56
u=b9.c
p=u.length
l=A.bg(p+(w?1:0),D.If,!1,y.bA)
k=A.EU(x.length+1,new C.abA(b9,w,c4,c3,c5,c2,c1,new A.bK(new C.abB(c1),y.b),l),!0,y.B)
if(w){l[0]=new C.Rl(o+18+n)
p=k[0]
j=r?c0:s
p.c[0]=b9.afr(j,c5,new C.abC(b9,r),c0,c0,!0)
for(p=x.length,i=1,h=0;h<x.length;x.length===p||(0,A.y)(x),++h){j=k[i]
j.c[0]=b9.Tz(!1,c5,c0,c0,c4,c0,!1);++i}g=1}else g=0
for(p=y.D,j=y.P,f=y.p,e=y.C,d=b9.fr,a0=m/2,a1=q/2,a2=0;a3=u.length,a2<a3;++a2){a4=u[a2]
A:{a5=0===a2
if(a5)a6=w
else a6=!1
if(a6){a6=a1
break A}if(a5){a6=q
break A}a6=a0
break A}a7=new A.dM(a6,0,a2===a3-1?q:a0,0)
if(a2===d)l[g]=D.Oq
else l[g]=D.Or
A.aL(e).A(0,B.L)
a3=k[0]
a8=A.a5(c5)
c5.ak(j)
a9=A.a5(c5).y2
a6=A.b([],f)
a6.push(a4.a)
b0=A.bz(c0,c0,A.aA(a6,B.p,B.h,B.j,0,c0,c0),!1,c0,c0,!1,c0,!1,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,B.CY,c0,c0,c0,c0,c0,c0,c0,c0)
a6=a9.w
b1=a6==null?a8.y2.w:a6
if(b1==null){a6=a8.ok.x
a6.toString
b1=a6}a6=a9.r
b2=a6==null?a8.y2.r:a6
if(b2==null)b2=56
a6=c5.ak(p)
b0=A.a6(B.dO,A.oY(b0,B.M,B.dZ,!1,(a6==null?B.fT:a6).w.aQ(b1)),B.i,c0,c0,c0,c0,b2,c0,c0,a7,c0,c0,c0)
a3.c[g]=A.he(!1,c0,!0,b0,c0,!0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c0,c3,c0,c0,c0)
for(a3=x.length,i=1,h=0;h<x.length;x.length===a3||(0,A.y)(x),++h){b3=x[h]
b4=b3.f[a2]
a6=k[i]
a8=A.a5(c5)
c5.ak(j)
a9=A.a5(c5).y2
b5=a9.e
b6=b5==null?a8.y2.e:b5
if(b6==null){b5=a8.ok.z
b5.toString
b6=b5}b5=a9.c
b7=b5==null?a8.y2.c:b5
if(b7==null)b7=48
b5=a9.d
b8=b5==null?a8.y2.d:b5
if(b8==null)b8=48
b5=c5.ak(p)
b5=(b5==null?B.fT:b5).w.aQ(b6)
b0=A.a6(B.dO,new A.kM(b5.c_(c0),c0,!0,B.ca,c0,B.aT,c0,new Ab.xE(b4.a,c0),c0),B.i,c0,new A.al(0,1/0,b7,b8),c0,c0,c0,c0,c0,a7,c0,c0,c0)
a6.c[g]=new C.I5(c0,b0,c0);++i}++g}x=c2.a
if(x==null)x=c1.y2.a
return A.a6(c0,A.eg(!1,B.I,!0,c0,C.bd9(c0,k,new A.nB(l,A.a3(l).i("nB<1>")),D.Ea),B.i,c0,0,c0,c0,c0,c0,c0,B.dE),B.i,c0,c0,x,c0,c0,c0,c0,c0,c0,c0,c0)}}
C.I6.prototype={
H_(d){return new C.aw5(d)},
E2(d){this.a9K(d)
return!0}}
C.a15.prototype={
yT(d,e){return A.T(A.ey(null))},
yW(d,e){return A.T(A.ey(null))}}
C.a1a.prototype={
c9(){return A.T(A.ey(null))}}
C.ZO.prototype={
E(d){var x,w=null,v=this.e.a,u=w
if(v==null)v=u
else{v=v.a_(B.bF)
v=v==null?w:v.r}x=v
if(x==null)x=14
v=A.bW(d,B.c_)
v=v==null?w:v.gcP()
v=A.E((v==null?B.b0:v).aR(x)/14,1,2)
A.aXA(d)
v=A.aa(8,4,v-1)
v.toString
u=A.b([this.d,new A.j8(1,B.da,this.c,w)],y.p)
return A.aA(u,B.p,B.h,B.ab,v,w,w)}}
C.Um.prototype={
gtr(){var x=this.gv()
return new A.C(0,0,0+x.a,0+x.b)},
co(d,e){var x,w
this.jY()
x=this.T
w=x.gb_()
if(new A.h((e.a-w.a)/(x.c-x.a),(e.b-w.b)/(x.d-x.b)).goU()>0.25)return!1
return this.lA(d,e)},
au(d,e){var x,w,v,u=this,t=u.F$
if(t!=null)if(u.ad!==B.i){u.jY()
t=u.cx
t===$&&A.a()
x=u.T
if(!x.k(0,u.bg)){u.bg=x
w=A.bY($.ag().r)
w.an(new A.kD(x))
u.dD=w}w=u.dD
w===$&&A.a()
v=u.ch
v.saL(d.G5(t,e,x,w,A.fr.prototype.geU.call(u),u.ad,y.d0.a(v.a)))}else{d.di(t,e)
u.ch.saL(null)}else u.ch.saL(null)}}
C.mk.prototype={
j(d){var x=this.vS(0),w=this.b
w=w==null?"default vertical alignment":w.j(0)
return x+"; "+w}}
C.qA.prototype={
Om(d){return null},
j(d){return"TableColumnWidth"}}
C.Ez.prototype={
yW(d,e){var x,w,v,u,t
for(x=new A.lu(d.a()),w=0;x.u();){v=x.b
u=v.gbx()
t=B.aZ.dg(v.dy,1/0,u)
w=Math.max(w,t)}return w},
yT(d,e){var x,w,v,u,t
for(x=new A.lu(d.a()),w=0;x.u();){v=x.b
u=v.gbi()
t=B.av.dg(v.dy,1/0,u)
w=Math.max(w,t)}return w},
Om(d){return this.a},
j(d){var x=this.a
return"IntrinsicColumnWidth(flex: "+A.m(x==null?null:B.f.ae(x,1))+")"}}
C.Rl.prototype={
yW(d,e){return this.a},
yT(d,e){return this.a},
j(d){return"FixedColumnWidth("+A.iZ(this.a)+")"}}
C.Rn.prototype={
yW(d,e){return 0},
yT(d,e){return 0},
Om(d){return 1},
j(d){return"FlexColumnWidth("+A.iZ(1)+")"}}
C.qz.prototype={
H(){return"TableCellVerticalAlignment."+this.b}}
C.qg.prototype={
saz0(d){var x=this.a2
if(x===d)return
x.ga8(x)
this.a2=d
this.W()},
saAB(d){if(this.U===d)return
this.U=d
this.W()},
sbI(d){if(this.ac===d)return
this.ac=d
this.W()},
sayh(d){return},
sa6e(d){var x,w,v,u=this,t=u.al
if(t==null?d==null:t===d)return
u.al=d
t=u.aZ
if(t!=null)for(x=t.length,w=0;w<x;++w){v=t[w]
if(v!=null)v.l()}t=u.al
u.aZ=t!=null?A.bg(t.length,null,!1,y.G):null},
soM(d){if(d.k(0,this.b3))return
this.b3=d
this.aI()},
saAD(d){if(this.aD===d)return
this.aD=d
this.W()},
sQ8(d){return},
en(d){if(!(d.b instanceof C.mk))d.b=new C.mk(B.m)},
dT(d){this.hz(d)
d.aM=B.a0n
d.e=d.a=d.r=!0},
qo(c0,c1,c2){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5=this,b6=y.Q,b7=A.b([],b6),b8=b5.P,b9=J.nw(b8,y.bl)
for(x=y.M,w=0;w<b8;++w){v=b5.K
u=A.b(new Array(v),x)
for(t=0;t<v;++t)u[t]=A.b([],b6)
b9[w]=u}s=new C.aqE()
r=new C.aqD(b5)
q=new C.aqC(b5)
p=new C.aqF()
for(x=c2.length,o=b5.cn,n=0;n<c2.length;c2.length===x||(0,A.y)(c2),++n){m=c2[n]
if(o.ab(m.b)){l=o.h(0,m.b)
k=l.a
j=l.b
if(k<b5.P&&j<b5.K)b9[k][j].push(m)}else{i=s.$1(m)
k=r.$1(i.b)
j=q.$1(i.a)
if(k!==-1&&j!==-1)b9[k][j].push(m)}}for(x=b5.aw,h=b5.cb,g=b5.cf,k=0;k<b5.P;k=d){f=x[k]
e=b5.fy
e=(e==null?A.T(A.aB("RenderBox was not laid out: "+A.G(b5).j(0)+"#"+A.br(b5))):e).a
d=k+1
a0=x[d]
a1=a0-f
if(a1===0)continue
a2=g.h(0,k)
if(a2==null){a2=A.v_(null,new C.aqA(b5,new A.C(0,f,e,a0)))
g.p(0,k,a2)}a3=A.b([],b6)
for(a0=a1+1e-10,a1=0+a1,j=0;j<b5.K;++j){a4=b9[k][j]
a5=a4.length
if(a5===0)continue
if(a5<=1)a6=B.b.gbV(a4).K!==B.nW&&B.b.gbV(a4).K!==B.CY
else a6=!0
a7=A.ck()
if(!a6){a5=B.b.gbV(a4)
if(a7.b!==a7)A.T(A.aj8(a7.a))
a7.b=a5}else{a5=h.bP(new C.AP(k,j),new C.aqB())
a8=A.hG()
a8.aM=B.nW
a8.r=!0
a5.kC(a4,a8)
if(a7.b!==a7)A.T(A.aj8(a7.a))
a7.b=a5}a5=b5.K
a8=b5.bH
if(j===a5-1){a8.toString
a9=e-J.j1(a8,j)}else{a8.toString
a5=J.j1(a8,j+1)
a8=b5.bH
a8.toString
a9=a5-J.j1(a8,j)}if(a9<=0)continue
if(a6){a5=a7.b
if(a5===a7)A.T(A.pI(a7.a))
a8=b5.bH
a8.toString
a8=J.j1(a8,j)
b0=new Float64Array(16)
b1=new A.aZ(b0)
b1.dP()
b0[14]=0
b0[13]=0
b0[12]=a8
if(!A.am2(a5.d,b1)){a8=A.F5(b1)
a5.d=a8?null:b1
a5.hb()}a8=new A.C(0,0,0+a9,a1)
if(!a5.f.k(0,a8)){a5.f=a8
a5.hb()}}for(a5=a4.length,n=0;n<a4.length;a4.length===a5||(0,A.y)(a4),++n){m=a4[n]
o.p(0,m.b,new C.AP(k,j))
b2=s.$1(m)
b3=b2.d>a0?-x[k]:0
b4=0
if(a6){if(b2.a>=a9){a8=b5.bH
a8.toString
a8=J.b6n(J.j1(a8,j))
b4=a8}}else{a8=b2.c
b0=b5.bH
b0.toString
if(a8<=J.j1(b0,j)){a8=b5.bH
a8.toString
a8=J.j1(a8,j)
b4=a8}}if(b4!==0||b3!==0)p.$3(m,b4,b3)}a5=a7.b
if(a5===a7)A.T(A.pI(a7.a))
a5.x=j
a3.push(a5)}a0=A.hG()
a0.p4=k
a0.r=!0
a0.aM=B.CX
a2.kC(a3,a0)
a0=new Float64Array(16)
a5=new A.aZ(a0)
a5.dP()
a0[14]=0
a0[13]=f
a0[12]=0
if(!A.am2(a2.d,a5)){f=A.F5(a5)
a2.d=f?null:a5
a2.hb()}f=new A.C(0,0,0+e,a1)
if(!a2.f.k(0,f)){a2.f=f
a2.hb()}b7.push(a2)}c0.kC(b7,c1)},
a8f(d,e){var x,w,v,u,t,s,r,q,p=this,o=p.t
if(e===o&&d===p.K)return
if(d===0||e.length===0){p.K=d
x=o.length
if(x===0)return
for(w=0;w<o.length;o.length===x||(0,A.y)(o),++w){v=o[w]
if(v!=null)p.l3(v)}p.P=0
B.b.S(p.t)
p.W()
return}u=A.d5(y.u)
for(t=0;t<p.P;++t)for(o=t*d,s=0;x=p.K,s<x;++s){r=s+o
x=p.t[s+t*x]
if(x!=null)q=s>=d||r>=e.length||x!==e[r]
else q=!1
if(q)u.A(0,x)}for(t=0;o=t*d,o<e.length;){for(s=0;s<d;++s){r=s+o
x=p.K
q=e[r]
if(q!=null)x=s>=x||t>=p.P||p.t[s+t*x]!==q
else x=!1
if(x)if(!u.G(0,q)){x=e[r]
x.toString
p.i7(x)}}++t}u.ai(0,p.gaB1())
p.K=d
p.P=B.f.jP(e.length,d)
o=A.U(e,y.aa)
p.t=o
p.W()},
Rm(d,e,f){var x,w=this,v=d+e*w.K,u=w.t[v]
if(u==f)return
if(u!=null)w.l3(u)
x=w.t
x.$flags&2&&A.aO(x)
x[v]=f
if(f!=null)w.i7(f)},
ao(d){var x,w,v,u
this.dZ(d)
for(x=this.t,w=x.length,v=0;v<x.length;x.length===w||(0,A.y)(x),++v){u=x[v]
if(u!=null)u.ao(d)}},
ah(){var x,w,v,u,t,s=this
s.dR()
x=s.aZ
if(x!=null){for(w=x.length,v=0;v<w;++v){u=x[v]
if(u!=null)u.l()}s.aZ=A.bg(s.al.length,null,!1,y.G)}for(x=s.t,w=x.length,v=0;v<x.length;x.length===w||(0,A.y)(x),++v){t=x[v]
if(t!=null)t.ah()}},
bm(d){var x,w,v,u
for(x=this.t,w=x.length,v=0;v<x.length;x.length===w||(0,A.y)(x),++v){u=x[v]
if(u!=null)d.$1(u)}},
fX(){this.bm(this.gGe())},
bb(d){var x,w,v,u=this
if(u.P*u.K===0)return 0
for(x=0,w=0;w<u.K;++w){v=u.a2.h(0,w)
if(v==null)v=u.U
x+=v.yW(u.DH(w),1/0)}return x},
b5(d){var x,w,v,u=this
if(u.P*u.K===0)return 0
for(x=0,w=0;w<u.K;++w){v=u.a2.h(0,w)
if(v==null)v=u.U
x+=v.yT(u.DH(w),1/0)}return x},
ba(d){var x,w,v,u,t,s,r,q,p,o=this
if(o.P*o.K===0)return 0
x=o.AX(A.hv(1/0,d))
for(w=0,v=0;v<o.P;++v){for(u=0,t=0;s=o.K,t<s;++t){r=o.t[t+v*s]
if(r!=null){s=x[t]
q=r.gbw()
p=B.b_.dg(r.dy,s,q)
u=Math.max(u,p)}}w+=u}return w},
b9(d){return this.aj(B.b6,d,this.gbB())},
ft(d){return this.bR},
DH(d){return new A.jI(this.az_(d),y.bf)},
az_(d){var x=this
return function(){var w=d
var v=0,u=1,t=[],s,r,q
return function $async$DH(e,f,g){if(f===1){t.push(g)
v=u}for(;;)switch(v){case 0:s=0
case 2:if(!(s<x.P)){v=4
break}r=x.K
q=x.t[w+s*r]
v=q!=null?5:6
break
case 5:v=7
return e.b=q,1
case 7:case 6:case 3:++s
v=2
break
case 4:return 0
case 1:return e.c=t.at(-1),3}}}},
AX(a7){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2=this,a3=y.i,a4=A.bg(a2.K,0,!1,a3),a5=A.bg(a2.K,0,!1,a3),a6=A.bg(a2.K,null,!1,y.dd)
for(x=a7.b,w=0,v=0,u=0,t=0;s=a2.K,t<s;++t){r=a2.a2.h(0,t)
if(r==null)r=a2.U
q=a2.DH(t)
p=r.yT(q,x)
a4[t]=p
w+=p
a5[t]=r.yW(q,x)
o=r.Om(q)
if(o!=null){a6[t]=o
u+=o}else v+=p}n=a7.a
if(u>0){m=isFinite(x)?x:n
if(w<m){l=m-v
for(t=0;t<s;++t){a3=a6[t]
if(a3!=null){k=l*a3/u
a3=a4[t]
if(a3<k){w+=k-a3
a4[t]=k}}}}}else if(w<n){j=(n-w)/s
for(t=0;t<s;++t)a4[t]=a4[t]+j
w=n}if(w>x){i=w-x
h=s
for(;;){if(!(i>1e-10&&u>1e-10))break
for(g=0,t=0;t<s;++t){a3=a6[t]
if(a3!=null){f=a4[t]
e=f-i*a3/u
d=a5[t]
if(e<=d){i-=f-d
a4[t]=d
a6[t]=null;--h}else{i-=f-e
a4[t]=e
g+=a3}}}u=g}for(;;){if(!(i>1e-10&&h>0))break
j=i/h
for(a0=0,t=0;t<s;++t){a3=a4[t]
f=a5[t]
a1=a3-f
if(a1>0)if(a1<=j){i-=a1
a4[t]=f}else{i-=j
a4[t]=a3-j;++a0}}h=a0}}return a4},
a7u(d){var x=this.aw
return new A.C(0,x[d],this.gv().a,x[d+1])},
cX(d,e){var x,w,v,u,t,s,r,q,p,o,n=this,m=null
if(n.P*n.K===0)return m
x=n.AX(d)
for(w=y.L,v=m,u=0;u<n.K;++u){t=n.t[u]
s=A.h3(m,x[u])
if(t==null)continue
r=t.b
r.toString
q=w.a(r).b
if(q==null)q=n.aD
A:{r=m
if(D.a2x===q){r=t.gwd()
p=B.dU.dg(t.dy,new A.av(s,e),r)
r=p
break A}if(D.a2v===q||D.Ea===q||D.a2w===q||D.Eb===q||D.a2y===q)break A}if(r!=null)o=v==null||v<r
else o=!1
if(o)v=r}return v},
cl(d){var x,w,v,u,t,s,r,q,p,o,n,m=this
if(m.P*m.K===0)return d.bc(B.K)
x=m.AX(d)
w=B.b.m8(x,0,new C.aqG(),y.i)
for(v=y.L,u=0,t=0;t<m.P;++t){for(s=0,r=0;q=m.K,r<q;++r){p=m.t[r+t*q]
if(p!=null){q=p.b
q.toString
q=v.a(q).b
switch((q==null?m.aD:q).a){case 3:return B.K
case 0:case 1:case 2:case 5:q=A.h3(null,x[r])
o=p.gc2()
n=B.W.dg(p.dy,q,o)
s=Math.max(s,n.b)
break
case 4:break}}}u+=s}return d.bc(new A.J(w,u))},
bj(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0=this,a1="RenderBox was not laid out: ",a2=y.k.a(A.D.prototype.gX.call(a0)),a3=a0.P,a4=a0.K
if(a3*a4===0){a0.bl=0
a0.fy=a2.bc(B.K)
return}x=a0.AX(a2)
w=y.i
v=A.bg(a4,0,!1,w)
switch(a0.ac.a){case 0:v[a4-1]=0
for(u=a4-2;u>=0;--u){t=u+1
v[u]=v[t]+x[t]}a0.bH=new A.ci(v,A.a3(v).i("ci<1>"))
a0.bl=B.b.gY(v)+B.b.gY(x)
break
case 1:v[0]=0
for(u=1;u<a4;++u){t=u-1
v[u]=v[t]+x[t]}a0.bH=v
a0.bl=B.b.gaf(v)+B.b.gaf(x)
break}t=a0.aw
B.b.S(t)
a0.bR=null
for(s=y.L,r=0,q=0;q<a3;++q,r=f){t.push(r)
p=A.bg(a4,0,!1,w)
for(o=q*a4,n=0,m=!1,l=0,k=0,u=0;u<a4;++u){j=a0.t[u+o]
if(j!=null){i=j.b
i.toString
s.a(i)
i.d=q
h=i.b
switch((h==null?a0.aD:h).a){case 3:j.c7(A.h3(null,x[u]),!0)
h=a0.c5
h.toString
g=j.vr(h,!0)
h=j.fy
if(g!=null){l=Math.max(l,g)
k=Math.max(k,(h==null?A.T(A.aB(a1+A.G(j).j(0)+"#"+A.br(j))):h).b-g)
p[u]=g
m=!0}else{n=Math.max(n,(h==null?A.T(A.aB(a1+A.G(j).j(0)+"#"+A.br(j))):h).b)
i.a=new A.h(v[u],r)}break
case 0:case 1:case 2:case 5:j.c7(A.h3(null,x[u]),!0)
i=j.fy
n=Math.max(n,(i==null?A.T(A.aB(a1+A.G(j).j(0)+"#"+A.br(j))):i).b)
break
case 4:break}}}if(m){if(q===0)a0.bR=l
n=Math.max(n,l+k)}for(f=r+n,i=r+l,u=0;u<a4;++u){j=a0.t[u+o]
if(j!=null){h=j.b
h.toString
s.a(h)
e=h.b
switch((e==null?a0.aD:e).a){case 3:h.a=new A.h(v[u],i-p[u])
break
case 0:h.a=new A.h(v[u],r)
break
case 1:e=v[u]
d=j.fy
h.a=new A.h(e,r+(n-(d==null?A.T(A.aB(a1+A.G(j).j(0)+"#"+A.br(j))):d).b)/2)
break
case 2:e=v[u]
d=j.fy
h.a=new A.h(e,f-(d==null?A.T(A.aB(a1+A.G(j).j(0)+"#"+A.br(j))):d).b)
break
case 4:case 5:j.f6(A.h3(n,x[u]))
h.a=new A.h(v[u],r)
break}}}}t.push(r)
w=a0.bl
w===$&&A.a()
a0.fy=a2.bc(new A.J(w,r))},
cI(d,e){var x,w,v,u
for(x=this.t.length-1,w=y.x;x>=0;--x){v=this.t[x]
if(v!=null){u=v.b
u.toString
if(d.jk(new C.aqH(v),w.a(u).a,e))return!0}}return!1},
au(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=this
if(l.P*l.K===0)return
if(l.al!=null){x=d.gcz()
for(w=l.aw,v=e.a,u=e.b,t=l.ge6(),s=0;s<l.P;++s){r=l.al
if(r.length<=s)break
r=r[s]
if(r!=null){q=l.aZ
if(q[s]==null)q[s]=r.qA(t)
r=l.aZ[s]
r.toString
q=w[s]
p=l.b3
o=l.fy
if(o==null)o=A.T(A.aB("RenderBox was not laid out: "+A.G(l).j(0)+"#"+A.br(l)))
r.ik(x,new A.h(v,u+q),p.Na(new A.J(o.a,w[s+1]-q)))}}}for(w=y.x,v=e.a,u=e.b,n=0;t=l.t,n<t.length;++n){m=t[n]
if(m!=null){t=m.b
t.toString
t=w.a(t).a
d.di(m,new A.h(t.a+v,t.b+u))}}}}
C.AP.prototype={
k(d,e){if(e==null)return!1
if(this===e)return!0
if(!(e instanceof C.AP))return!1
return this.a===e.a&&this.b===e.b},
gB(d){return A.a1(this.a,this.b,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a)}}
C.Q4.prototype={
aK(d){var x=new C.Um(null,B.ao,null,new A.aV(),A.at())
x.aJ()
x.saY(null)
return x},
aN(d,e){e.soL(null)
e.ska(B.ao)},
uo(d){d.soL(null)}}
C.jv.prototype={
j(d){var x,w=this.a
w=w!=null?"TableRow("+(w.j(0)+", "):"TableRow("
w+=this.b.j(0)+", "
x=this.c
w=(x.length===0?w+"no children":w+A.m(x))+")"
return w.charCodeAt(0)==0?w:w}}
C.iU.prototype={}
C.I4.prototype={
c9(){return new C.a4M(D.TL,A.d5(y.h),this,B.az)},
aK(d){var x,w,v,u,t,s,r=this,q=r.c,p=q.length
q=p!==0?q[0].c.length:0
x=d.ak(y.t).w
w=A.BS(d,null)
v=y.q
u=y.ac
t=y.cB
s=A.b([],y.a)
q=new C.qg(D.TK,q,p,r.d,D.pw,x,r.r,w,r.w,null,A.B(v,u),A.B(v,t),A.B(u,t),s,new A.aV(),A.at())
q.aJ()
p=A.b([],y.K)
B.b.sD(p,q.K*q.P)
q.t=p
q.sa6e(r.y)
return q},
aN(d,e){var x,w=this
e.saz0(w.d)
e.saAB(D.pw)
x=d.ak(y.t).w
e.sbI(x)
e.sayh(w.r)
e.sa6e(w.y)
e.soM(A.BS(d,null))
e.saAD(w.w)
e.sQ8(null)}}
C.a4M.prototype={
ga1(){return y.S.a(A.b5.prototype.ga1.call(this))},
fW(d,e){var x,w,v=this,u={}
v.p2=!0
v.o2(d,e)
u.a=-1
x=v.e
x.toString
x=y.bg.a(x).c
w=A.a3(x).i("a9<1,iU>")
u=A.U(new A.a9(x,new C.aMI(u,v),w),w.i("ap.E"))
u.$flags=1
v.p1=u
v.a_W()
v.p2=!1},
jw(d,e){var x=y.S
x.a(A.b5.prototype.ga1.call(this))
if(!(d.b instanceof C.mk))d.b=new C.mk(B.m)
if(!this.p2)x.a(A.b5.prototype.ga1.call(this)).Rm(e.a,e.b,d)},
jC(d,e,f){},
kz(d,e){y.S.a(A.b5.prototype.ga1.call(this)).Rm(e.a,e.b,null)},
cL(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g=this
g.p2=!0
x=y.O
w=A.B(y.Y,x)
for(v=g.p1,u=v.length,t=0;t<v.length;v.length===u||(0,A.y)(v),++t){s=v[t]
r=s.a
if(r!=null)w.p(0,r,s.b)}v=B.b.ga5(g.p1)
q=new A.iM(v,new C.aMJ())
p=A.b([],y.R)
o=A.aL(x)
for(x=d.c,u=g.p3,r=y.V,n=0;n<x.length;++n){s=x[n]
m=s.a
l=m==null
if(!l&&w.ab(m)){l=w.h(0,m)
l.toString
o.A(0,l)
k=l}else k=l&&q.u()?v.gN().b:D.TM
l=s.c
j=l.length
i=A.b(new Array(j),r)
for(h=0;h<j;++h)i[h]=new C.By(h,n)
p.push(new C.iU(m,g.a6y(k,l,u,i)))}while(q.u())g.GG(v.gN().b,B.mY,u)
for(x=new A.bs(w,w.$ti.i("bs<2>")).ga5(0),v=new A.iM(x,new C.aMK(o));v.u();)g.GG(x.gN(),B.mY,u)
g.p1=p
g.a_W()
u.S(0)
g.mM(d)
g.p2=!1},
a_W(){var x=y.S.a(A.b5.prototype.ga1.call(this)),w=this.p1,v=w.length!==0?w[0].b.length:0,u=A.a3(w).i("fi<1,A>")
w=A.U(new A.fi(w,new C.aMG(),u),u.i("w.E"))
x.a8f(v,w)},
bm(d){var x,w,v,u
for(x=this.p1,w=A.a3(x),x=new A.jS(B.b.ga5(x),new C.aML(),B.ey,w.i("jS<1,b2>")),v=this.p3,w=w.i("b2");x.u();){u=x.d
if(u==null)u=w.a(u)
if(!v.q(0,u))d.$1(u)}},
iS(d){this.p3.A(0,d)
this.jN(d)
return!0}}
C.I5.prototype={
E(d){var x=null
return new C.a4L(this.c,A.bz(x,x,this.d,!1,x,x,!1,x,!1,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,B.nW,x,x,x,x,x,x,x,x),x)}}
C.a4L.prototype={
qm(d){var x,w=d.b
w.toString
y.L.a(w)
x=this.f
if(w.b!=x){w.b=x
w=d.gbd()
if(w!=null)w.W()}}}
C.By.prototype={
k(d,e){if(e==null)return!1
if(J.a7(e)!==A.G(this))return!1
return e instanceof C.By&&this.a===e.a&&this.b===e.b},
gB(d){return A.a1(this.a,this.b,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a,B.a)}}
C.a72.prototype={}
var z=a.updateTypes(["z(kn)","K(K)","z(xx)","vT(S,L,bQ?)","kn(l7)","kG()","Ap(i1)","d(S,dk<H<fa>>)","z(fa)","Ag()","vN(S,L,bQ?)","l(fa,fa)","H<fa>()","k(fa)","d(S,dk<H<qV>>)","kn()","a0(S,dk<H<r5>>)","a2<~>()","jv(l)","C()(A)","z(S)","z(jv)","h7?(jv)","iU(jv)","z(iU)","w<A>(iU)","H<b2>(iU)","~()","qR(fa?)"])
C.a8L.prototype={
$1(d){return new C.Ap(d,B.l,null)},
$S:z+6}
C.aOx.prototype={
$1(d){return d.a!=="image"},
$S:678}
C.aOy.prototype={
$1(d){var x=d.a
return x.length!==0&&!this.a.q(0,x)},
$S:679}
C.aOz.prototype={
$1(d){return new A.i1("image","",d.a,D.TN)},
$S:680}
C.aAC.prototype={
$3(d,e,f){return new C.vT(this.a.d,null)},
$S:z+3}
C.aDl.prototype={
$2(d,e){var x,w,v,u,t,s,r,q,p,o,n,m=null,l=e.b
if(l==null)l=D.ti
if(e.a===B.eK)return new C.ZY(this.a.a.d,m)
x=J.b9(l)
if(x.ga8(l))return new C.AB(this.a.a.d,m)
w=this.a
v=w.aj5(l)
u=C.bgO(l)
t=C.bgP(C.bhb(v))
s=A.bI(d,B.fy,y.w).w.a.b-230
r=s<440?440:s
q=w.a.d
x=x.gD(l)
p=v.length
o=w.a.d
n=w.f
return A.c1(A.an(A.b([new C.a_1(q,x,p,m),B.G,new C.a_0(o,new C.aDi(w),m),B.G,new C.ZX(o,u,n,new C.aDj(w),m),I.dm,A.b7(p===0?new C.a__(o,m):A4.yd(new C.aDk(w,t),t.length,m,!1,B.a6,!1),1)],y.p),B.aB,B.h,B.j),r,m)},
$S:z+7}
C.aDi.prototype={
$1(d){var x=this.a
return x.O(new C.aDh(x,d))},
$S:19}
C.aDh.prototype={
$0(){return this.a.e=this.b},
$S:0}
C.aDj.prototype={
$1(d){var x=this.a
return x.O(new C.aDg(x,d))},
$S:19}
C.aDg.prototype={
$0(){return this.a.f=this.b},
$S:0}
C.aDk.prototype={
$2(d,e){var x=this.b[e],w=x.a
if(w!=null)return new A.aP(N.lM,new C.ZV(w,this.a.a.d,null),null)
w=x.b
w.toString
return new C.ZZ(w,this.a.a.d,null)},
$S:212}
C.aDf.prototype={
$1(d){var x,w=this.a.f,v=w.length===0||d.d===w
w=this.b
x=w.length===0||B.c.q(d.b.toLowerCase(),w)||B.c.q(d.c.toLowerCase(),w)
return v&&x},
$S:z+8}
C.aDm.prototype={
$0(){return this.a.f.$1(this.b)},
$S:0}
C.aDo.prototype={
$0(){return A.kU($.O(),new C.aDn(this.a),y.z)},
$S:0}
C.aDn.prototype={
$0(){return new C.Ag(this.a.c,null)},
$S:z+9}
C.aDe.prototype={
$3(d,e,f){var x=this.a
return new C.vN(x.c,x.d,null)},
$S:z+10}
C.aDp.prototype={
$1(d){return B.c.aA(d)},
$S:46}
C.aDq.prototype={
$1(d){return d.length!==0},
$S:6}
C.aPI.prototype={
$1(d){return d.a},
$S:682}
C.aPJ.prototype={
$1(d){return B.c.q(d,"person-default")},
$S:6}
C.aPK.prototype={
$0(){return""},
$S:28}
C.aPL.prototype={
$2(d,e){var x=B.c.aS(d.d,e.d)
if(x!==0)return x
return B.c.aS(d.b.toLowerCase(),e.b.toLowerCase())},
$S:z+11}
C.aOV.prototype={
$0(){return A.b([],y.J)},
$S:z+12}
C.aOO.prototype={
$1(d){return d.d},
$S:z+13}
C.aOF.prototype={
$1(d){var x=d.vC(1),w=A.m9(x==null?"":x,null)
if(w==null){x=d.vC(0)
x.toString}else x=A.dh(w)
return x},
$S:76}
C.aOG.prototype={
$1(d){var x=d.vC(1),w=A.m9(x==null?"":x,16)
if(w==null){x=d.vC(0)
x.toString}else x=A.dh(w)
return x},
$S:76}
C.aFk.prototype={
$2(d,e){var x,w,v,u,t=null,s=e.b
if(s==null)s=D.mZ
if(e.a===B.eK)return new C.a_J(this.a.d,t)
x=J.b9(s)
if(x.ga8(s))return new C.AB(this.a.d,t)
w=this.a.d
v=y.p
u=A.b([new C.a_M(w,x.gD(s),t),B.G],v)
for(x=x.ga5(s);x.u();)B.b.J(u,A.b([new C.a_K(x.gN(),w,t),B.G],v))
return A.an(u,B.aB,B.h,B.j)},
$S:z+14}
C.aFj.prototype={
$0(){return C.aPc(this.a.c)},
$S:0}
C.aPM.prototype={
$1(d){return d.b.index},
$S:94}
C.aPN.prototype={
$1(d){return B.c.b1(d.a.toLowerCase(),"address")},
$S:z+0}
C.aPO.prototype={
$0(){return D.abe},
$S:z+15}
C.aPP.prototype={
$1(d){return!B.c.b1(d.a.toLowerCase(),"address")},
$S:z+0}
C.aOZ.prototype={
$1(d){var x=d.b,w=x[1]
w=C.b1k(w==null?"":w)
x=x[2]
return new C.kn(w,C.mF(x==null?"":x))},
$S:z+4}
C.aP_.prototype={
$1(d){return d.a.length!==0||d.b.length!==0},
$S:z+0}
C.aOX.prototype={
$1(d){var x=d.b,w=x[1]
w=C.b1k(w==null?"":w)
x=x[2]
return new C.kn(w,C.mF(x==null?"":x))},
$S:z+4}
C.aOY.prototype={
$1(d){return d.a.length!==0||d.b.length!==0},
$S:z+0}
C.aNX.prototype={
$0(){return C.aPd("https://en.nia.gov.cn/n147418/n147463/c183412/content.html")},
$S:0}
C.aII.prototype={
$3(d,e,f){return new C.vT(this.a.c,null)},
$S:z+3}
C.aAp.prototype={
$3(d,e,f){var x=null
return A.a6(x,x,B.i,B.l,x,x,x,8,x,x,x,x,x,8)},
$S:61}
C.aJz.prototype={
$2(d,e){var x,w,v,u,t,s,r,q=null,p=this.a,o=e.b
if(o==null)o=this.b
x=p.apn(o,this.b)
o=A.a3(x).i("ah<1>")
w=A.U(new A.ah(x,new C.aJx(p),o),o.i("w.E"))
v=p.akA(w)
u=p.aof(x)
o=y.p
t=A.b([new C.a26(p.a.c,p.e,new C.aJy(p),q),I.dm],o)
if(u.length!==0)B.b.J(t,A.b([new C.a2i(p.a.c,u,q),I.dm],o))
if(v.a===0)t.push(new C.a2g(p.a.c,e.a===B.eK,q))
else for(s=new A.dO(v,A.v(v).i("dO<1,2>")).ga5(0);s.u();){r=s.d
r.toString
B.b.J(t,A.b([new C.a2k(p.a.c,r.a,r.b,q),B.G],o))}return A.an(t,B.aB,B.h,B.j)},
$S:684}
C.aJx.prototype={
$1(d){return d.ch===this.a.e},
$S:18}
C.aJy.prototype={
$1(d){var x=this.a
x.O(new C.aJw(x,d))},
$S:20}
C.aJw.prototype={
$0(){return this.a.e=this.b},
$S:0}
C.aJt.prototype={
$0(){return A.b([],y.I)},
$S:685}
C.aJu.prototype={
$2(d,e){return d.x.aS(0,e.x)},
$S:42}
C.aJv.prototype={
$2(d,e){return d.x.aS(0,e.x)},
$S:42}
C.aJG.prototype={
$0(){return A.kU($.O(),new C.aJF(this.a),y.z)},
$S:0}
C.aJF.prototype={
$0(){return new C.kG(this.a.d,null)},
$S:z+5}
C.aJA.prototype={
$0(){return this.a.e.$1(this.b[this.c].a)},
$S:0}
C.aJI.prototype={
$0(){return A.kU($.O(),new C.aJH(this.a),y.z)},
$S:0}
C.aJH.prototype={
$0(){return new C.kG(this.a.d,null)},
$S:z+5}
C.ayz.prototype={
$2(d,e){var x=e.b
if(x==null)x=D.jg
if(e.a===B.eK)return new C.a2d(B.l,null)
if(J.kB(x))return new C.a29(B.l,null)
return new C.a27(x,B.l,null)},
$S:z+16}
C.aJB.prototype={
$1(d){return B.c.aA(d)},
$S:46}
C.aJC.prototype={
$1(d){return d.length!==0},
$S:6}
C.aJE.prototype={
$0(){var x,w,v=null,u=this.b,t=this.a,s=u.ay,r=s.q(s,t.c.a)
s=A.aC(r?D.Mh:D.Mf,v,v,v)
x=A.x(r?"Remove from My Schedule":"Add to My Schedule",v,v,v,v,v,v,v)
w=r?B.b3:t.d
return A.c1(C.aXz(s,x,new C.aJD(t,u),A.fH(v,v,w,v,v,v,v,v,v,B.e,v,v,v,v,new A.bN(A.a_(8),B.v),v,v,v,B.hO,v)),46,v)},
$S:142}
C.aJD.prototype={
$0(){var x=0,w=A.t(y.H),v=this,u,t,s,r,q
var $async$$0=A.u(function(d,e){if(d===1)return A.p(e,w)
for(;;)switch(x){case 0:s=v.b
r=v.a
q=r.c
x=2
return A.j(s.rG(q),$async$$0)
case 2:s=s.ay
u=s.q(s,q.a)
s=$.O()
t=u?"Added to My Schedule":"Removed from My Schedule"
A.e8(s,t,q.c,r.d,B.e,B.E,B.au)
return A.q(null,w)}})
return A.r($async$$0,w)},
$S:8}
C.aPQ.prototype={
$1(d){return d.b.index},
$S:94}
C.aPy.prototype={
$1(d){return d>0},
$S:53}
C.aBT.prototype={
$0(){var x=this.a.c
return C.rq(x.d,x.e)},
$S:0}
C.aBS.prototype={
$3(d,e,f){var x=null,w=this.a.d,v=A.Z(16,w.m()>>>16&255,w.m()>>>8&255,w.m()&255)
return A.a6(x,A.aC(P.ro,w,x,x),B.i,v,x,x,x,76,x,x,x,x,x,76)},
$S:61}
C.aBU.prototype={
$0(){var x=this.a
return C.rq(x.a,x.c)},
$S:0}
C.abB.prototype={
$1(d){if(d.q(0,B.af))return this.a.ax.b.be(0.08)
return null},
$S:44}
C.abx.prototype={
$1(d){return!1},
$S:z+2}
C.aby.prototype={
$1(d){return!1},
$S:z+2}
C.abz.prototype={
$1(d){return!1},
$S:z+2}
C.abA.prototype={
$1(d){var x,w,v,u,t,s,r,q,p,o=this,n=null,m=d>0
if(m)x=o.b
else x=!1
w=y.C
v=A.aL(w)
if(x)v.A(0,B.L)
if(m){u=o.c
t=u==null?n:u.a_(v)}else t=n
u=o.d
s=u==null?n:u.a_(A.aL(w))
r=m?t:s
m=o.f.z
if(m==null)m=o.r.y2.z
if(m==null)m=1
q=A.aXp(o.e,n,m)
p=d===0?n:new A.dJ(q,B.v,B.v,B.v)
m=d===0?$.b3b():n
w=r==null?o.w.a.$1(v):r
return new C.jv(m,new A.ac(w,n,p,n,n,n,B.o),A.bg(o.x.length,D.abV,!1,y.l))},
$S:z+18}
C.abC.prototype={
$1(d){return this.a.ahw(d,this.b)},
$S:143}
C.aw5.prototype={
$0(){var x,w,v,u,t=this.a,s=t.gbd(),r=new A.aZ(new Float64Array(16))
r.dP()
for(;;){if(!(s instanceof A.D&&!(s instanceof C.qg)))break
s.d6(t,r)
x=s.gbd()
t=s
s=x}if(s instanceof C.qg){w=t.b
w.toString
w=y.L.a(w).d
w.toString
v=s.a7u(w)
s.d6(t,r)
u=A.yl(r)
if(u!=null)return v.dw(new A.h(-u.a,-u.b))}return B.an},
$S:152}
C.aqE.prototype={
$1(d){var x=d.d,w=x!=null?A.yl(x):null
if(w==null)w=B.m
return d.f.dw(w)},
$S:688}
C.aqD.prototype={
$1(d){var x,w
for(x=this.a.aw,w=x.length-1;w>=0;--w)if(x[w]<=d)return w
return-1},
$S:209}
C.aqC.prototype={
$1(d){var x,w=this.a,v=w.bH
if(v==null)return-1
for(x=J.bD(v)-1;x>=0;--x){v=w.bH
v.toString
if(J.j1(v,x)<=d)return x}return-1},
$S:209}
C.aqF.prototype={
$3(d,e,f){var x=d.d,w=x!=null?A.yl(x):null
if(w==null)w=B.m
d.sbQ(A.nG(w.a+e,w.b+f,0))},
$S:690}
C.aqA.prototype={
$0(){var x=this.a
x.nY(x,this.b)},
$S:0}
C.aqB.prototype={
$0(){return A.v_(null,null)},
$S:691}
C.aqG.prototype={
$2(d,e){return d+e},
$S:49}
C.aqH.prototype={
$2(d,e){return this.a.co(d,e)},
$S:17}
C.aw6.prototype={
$1(d){return!0},
$S:z+21}
C.aw7.prototype={
$1(d){return d.b},
$S:z+22}
C.aMI.prototype={
$1(d){var x,w,v,u={}
u.a=0
x=this.a;++x.a
w=d.c
v=A.a3(w).i("a9<1,b2>")
u=A.U(new A.a9(w,new C.aMH(u,x,this.b),v),v.i("ap.E"))
u.$flags=1
return new C.iU(d.a,u)},
$S:z+23}
C.aMH.prototype={
$1(d){return this.c.uG(d,new C.By(this.a.a++,this.b.a))},
$S:692}
C.aMJ.prototype={
$1(d){return d.a==null},
$S:z+24}
C.aMK.prototype={
$1(d){return!this.a.q(0,d)},
$S:693}
C.aMG.prototype={
$1(d){var x=d.b
return new A.a9(x,new C.aMF(),A.a3(x).i("a9<1,A>"))},
$S:z+25}
C.aMF.prototype={
$1(d){var x=d.ga1()
x.toString
return y.u.a(x)},
$S:694}
C.aML.prototype={
$1(d){return d.b},
$S:z+26};(function installTearOffs(){var x=a._static_0,w=a._static_1,v=a._instance_0u,u=a._instance_1u
x(C,"biI","bh7",27)
w(C,"biH","bej",28)
v(C.IZ.prototype,"gaeH","AA",17)
var t
u(t=C.I6.prototype,"gQX","H_",19)
u(t,"ga29","E2",20)
u(t=C.qg.prototype,"gbx","bb",1)
u(t,"gbi","b5",1)
u(t,"gbB","ba",1)
u(t,"gbw","b9",1)})();(function inheritance(){var x=a.mixin,w=a.inheritMany,v=a.inherit
w(A.a0,[C.rF,C.a1l,C.Ap,C.a4K,C.a1d,C.a_1,C.a_0,C.ZX,C.ZW,C.ZV,C.ZZ,C.K9,C.vN,C.ZY,C.a__,C.Ag,C.a_L,C.a_M,C.a_K,C.Kz,C.KA,C.a_I,C.a_J,C.a61,C.a66,C.a65,C.a64,C.a63,C.a62,C.Js,C.a1c,C.vD,C.a2i,C.a2h,C.a26,C.a25,C.a2g,C.a2k,C.a2l,C.a2b,C.a2c,C.r6,C.a2a,C.a2f,C.a2e,C.a2d,C.a29,C.a27,C.a28,C.Zr,C.Zs,C.Zt,C.IZ,C.AB,C.vT,C.Qv,C.ZO,C.I5])
w(A.d9,[C.a8L,C.aOx,C.aOy,C.aOz,C.aAC,C.aDi,C.aDj,C.aDf,C.aDe,C.aDp,C.aDq,C.aPI,C.aPJ,C.aOO,C.aOF,C.aOG,C.aPM,C.aPN,C.aPP,C.aOZ,C.aP_,C.aOX,C.aOY,C.aII,C.aAp,C.aJx,C.aJy,C.aJB,C.aJC,C.aPQ,C.aPy,C.aBS,C.abB,C.abx,C.aby,C.abz,C.abA,C.abC,C.aqE,C.aqD,C.aqC,C.aqF,C.aw6,C.aw7,C.aMI,C.aMH,C.aMJ,C.aMK,C.aMG,C.aMF,C.aML])
w(A.W,[C.Ka,C.Ls,C.kG])
w(A.a4,[C.ZU,C.a24,C.XU])
w(A.fh,[C.aDl,C.aDk,C.aPL,C.aFk,C.aJz,C.aJu,C.aJv,C.ayz,C.aqG,C.aqH])
w(A.dK,[C.aDh,C.aDg,C.aDm,C.aDo,C.aDn,C.aPK,C.aOV,C.aFj,C.aPO,C.aNX,C.aJw,C.aJt,C.aJG,C.aJF,C.aJA,C.aJI,C.aJH,C.aJE,C.aJD,C.aBT,C.aBU,C.aw5,C.aqA,C.aqB])
w(A.L,[C.fa,C.qR,C.qV,C.kn,C.rl,C.wh,C.w1,C.r5,C.JS,C.Qt,C.xx,C.Qs,C.qA,C.AP,C.jv,C.iU,C.a72])
v(C.I6,A.pz)
w(C.qA,[C.a15,C.Ez,C.Rl,C.Rn])
v(C.a1a,A.d)
v(C.Um,A.w5)
v(C.mk,A.eO)
v(C.qz,A.iO)
v(C.qg,A.A)
v(C.Q4,A.b6)
v(C.I4,A.ax)
v(C.a4M,A.b5)
v(C.a4L,A.ev)
v(C.By,C.a72)
x(C.a72,A.am)})()
A.dT(b.typeUniverse,JSON.parse('{"Ap":{"a0":[],"d":[]},"Ka":{"W":[],"d":[]},"vN":{"a0":[],"d":[]},"Ag":{"a0":[],"d":[]},"Ls":{"W":[],"d":[]},"vT":{"a0":[],"d":[]},"rF":{"a0":[],"d":[]},"a1l":{"a0":[],"d":[]},"a4K":{"a0":[],"d":[]},"a1d":{"a0":[],"d":[]},"ZU":{"a4":["Ka"]},"a_1":{"a0":[],"d":[]},"a_0":{"a0":[],"d":[]},"ZX":{"a0":[],"d":[]},"ZW":{"a0":[],"d":[]},"ZV":{"a0":[],"d":[]},"ZZ":{"a0":[],"d":[]},"K9":{"a0":[],"d":[]},"ZY":{"a0":[],"d":[]},"a__":{"a0":[],"d":[]},"a_L":{"a0":[],"d":[]},"a_M":{"a0":[],"d":[]},"a_K":{"a0":[],"d":[]},"Kz":{"a0":[],"d":[]},"KA":{"a0":[],"d":[]},"a_I":{"a0":[],"d":[]},"a_J":{"a0":[],"d":[]},"a61":{"a0":[],"d":[]},"a66":{"a0":[],"d":[]},"a65":{"a0":[],"d":[]},"a64":{"a0":[],"d":[]},"a63":{"a0":[],"d":[]},"a62":{"a0":[],"d":[]},"Js":{"a0":[],"d":[]},"a1c":{"a0":[],"d":[]},"vD":{"a0":[],"d":[]},"a24":{"a4":["Ls"]},"a2i":{"a0":[],"d":[]},"a2h":{"a0":[],"d":[]},"a26":{"a0":[],"d":[]},"a25":{"a0":[],"d":[]},"a2g":{"a0":[],"d":[]},"a2k":{"a0":[],"d":[]},"a2l":{"a0":[],"d":[]},"kG":{"W":[],"d":[]},"XU":{"a4":["kG"]},"a2b":{"a0":[],"d":[]},"a2c":{"a0":[],"d":[]},"r6":{"a0":[],"d":[]},"a2a":{"a0":[],"d":[]},"a2f":{"a0":[],"d":[]},"a2e":{"a0":[],"d":[]},"a2d":{"a0":[],"d":[]},"a29":{"a0":[],"d":[]},"a27":{"a0":[],"d":[]},"a28":{"a0":[],"d":[]},"Zr":{"a0":[],"d":[]},"Zs":{"a0":[],"d":[]},"Zt":{"a0":[],"d":[]},"IZ":{"a0":[],"d":[]},"AB":{"a0":[],"d":[]},"Qv":{"a0":[],"d":[]},"I6":{"a0":[],"d":[]},"a15":{"qA":[]},"a1a":{"d":[]},"ZO":{"a0":[],"d":[]},"Um":{"A":[],"aU":["A"],"D":[],"aw":[]},"mk":{"eO":[],"cY":[]},"Ez":{"qA":[]},"Rl":{"qA":[]},"Rn":{"qA":[]},"qg":{"A":[],"D":[],"aw":[]},"Q4":{"b6":[],"ax":[],"d":[]},"I4":{"ax":[],"d":[]},"a4M":{"b5":[],"b2":[],"S":[]},"I5":{"a0":[],"d":[]},"a4L":{"ev":["mk"],"b4":[],"d":[],"ev.T":"mk"},"b7I":{"bn":[],"b4":[],"d":[]}}'))
var y=(function rtii(){var x=A.X
return{k:x("al"),x:x("eO"),P:x("b7I"),D:x("kM"),t:x("h8"),h:x("b2"),Z:x("jR"),g:x("ed<H<di>>"),y:x("ed<H<fa>>"),F:x("ed<H<qV>>"),A:x("ed<H<r5>>"),d:x("o<Qs>"),E:x("o<Qt>"),j:x("o<xx>"),m:x("o<ee>"),M:x("o<H<ca>>"),f:x("o<L>"),Q:x("o<ca>"),I:x("o<di>"),s:x("o<k>"),p:x("o<d>"),T:x("o<jC>"),W:x("o<qR>"),J:x("o<fa>"),X:x("o<qV>"),n:x("o<r5>"),R:x("o<iU>"),V:x("o<By>"),a:x("o<K>"),c4:x("o<l>"),K:x("o<A?>"),O:x("H<b2>"),bl:x("H<H<ca>>"),aF:x("H<di>"),r:x("H<fa>"),U:x("H<qV>"),cc:x("H<r5>"),Y:x("nC"),e:x("a9<k,k>"),w:x("hE"),a0:x("l7"),u:x("A"),S:x("qg"),v:x("o5"),cB:x("ca"),_:x("di"),c:x("i1"),N:x("k"),bg:x("I4"),L:x("mk"),bA:x("qA"),B:x("jv"),l:x("d"),C:x("cc"),cE:x("bj<I?>"),aX:x("qR"),o:x("kn"),ac:x("AP"),bf:x("jI<A>"),b:x("bK<I?>"),i:x("K"),z:x("@"),q:x("l"),G:x("lB?"),d0:x("xe?"),aa:x("A?"),dd:x("K?"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.FT=new A.cE(B.dH,B.J,B.dH,B.J)
D.pw=new C.Rn()
D.If=new C.a15()
D.J9=new A.I(1,0.2,0.4980392156862745,0.8980392156862745,B.k)
D.KX=new A.ae(0,0,0,4)
D.qD=new A.ae(0,0,0,6)
D.KY=new A.ae(0,0,6,0)
D.qE=new A.ae(0,10,0,10)
D.L0=new A.ae(0,6,0,6)
D.qI=new A.ae(0,7,0,0)
D.L6=new A.ae(10,5,10,5)
D.L7=new A.ae(12,10,10,10)
D.L9=new A.ae(12,12,12,4)
D.Lb=new A.ae(14,10,14,10)
D.Le=new A.ae(14,9,14,9)
D.lQ=new A.ae(16,16,16,32)
D.e_=new A.ae(18,18,18,18)
D.LA=new A.ae(4,18,4,8)
D.LB=new A.ae(4,6,4,8)
D.kf=new A.n(!0,B.b3,null,null,null,null,14,B.x,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a8u=new A.cn("Loading session agenda...",null,D.kf,null,null,null,null,null,null,null)
D.LM=new A.ha(1,B.c2,D.a8u,null)
D.a3p=new A.n(!0,B.ae,null,null,null,null,18,B.C,null,null,null,null,1.25,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a8C=new A.cn("China\u2019s 240-hour Visa-Free Transit Policy Coverage to 55 Countries",null,D.a3p,null,null,null,null,null,null,null)
D.LN=new A.ha(1,B.c2,D.a8C,null)
D.EE=new A.n(!0,B.ae,null,null,null,null,14,B.x,null,null,null,null,1.35,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a8D=new A.cn("Save the APSCVIR 2026 program to My Schedule.",null,D.EE,null,null,null,null,null,null,null)
D.LO=new A.ha(1,B.c2,D.a8D,null)
D.a8s=new A.cn("Loading faculty...",null,D.kf,null,null,null,null,null,null,null)
D.LP=new A.ha(1,B.c2,D.a8s,null)
D.a8z=new A.cn("Loading hotel reservation options...",null,D.kf,null,null,null,null,null,null,null)
D.LQ=new A.ha(1,B.c2,D.a8z,null)
D.a8J=new A.cn("Tap a template to download or share the local file.",null,D.EE,null,null,null,null,null,null,null)
D.LR=new A.ha(1,B.c2,D.a8J,null)
D.Mf=new A.ak(57586,"MaterialIcons",!1)
D.Mh=new A.ak(57589,"MaterialIcons",!1)
D.MD=new A.ak(58579,"MaterialIcons",!1)
D.MH=new A.ak(58835,"MaterialIcons",!1)
D.Nb=new A.ak(61727,"MaterialIcons",!1)
D.Nc=new A.ak(61843,"MaterialIcons",!1)
D.Nk=new A.ak(983508,"MaterialIcons",!1)
D.rI=new A.cd(B.dB,null,null,null,null)
D.NE=new A.cd(B.dc,22,B.e,null,null)
D.NJ=new A.cd(S.mI,18,B.l,null,null)
D.Oq=new C.Ez(1)
D.Or=new C.Ez(null)
D.ab1=new C.JS("Poster Template Download","2026/01/21 14:15:06","assets/apscvir2026/images/download-center-01-2026012114135281027954163-85d88862d0.png","assets/apscvir2026/files/abstract-results-file-12-2026011612540371016584932-cdb76d459a.pptx","APSCVIR 2026 Poster Template")
D.ab0=new C.JS("PowerPoint Templates Download","2025/09/08 13:43:18","assets/apscvir2026/images/download-center-02-2025090813425917869531024-ace71f351d.jpg","assets/apscvir2026/files/abstract-results-file-11-2026011523030913765941028-dd610fbb04.pptx","APSCVIR 2026 PowerPoint Template")
D.QV=x([D.ab1,D.ab0],A.X("o<JS>"))
D.Se=x(["Chinese Society of Interventional Radiology (CSIR)","Chinese College of Interventionalists (CCI)"],y.s)
D.aco=new C.rl("Europe",40,"Albania, Austria, Belarus, Belgium, Bosnia and Herzegovina, Bulgaria, Croatia, Cyprus, Czech Republic, Denmark, Estonia, Finland, France, Germany, Greece, Hungary, Iceland, Ireland, Italy, Latvia, Lithuania, Luxembourg, Malta, Monaco, Montenegro, the Netherlands, North Macedonia, Norway, Poland, Portugal, Romania, Russia, Serbia, Slovakia, Slovenia, Spain, Sweden, Switzerland, Ukraine, United Kingdom")
D.acn=new C.rl("North America",2,"Canada, United States")
D.acm=new C.rl("South America",4,"Argentina, Brazil, Chile, Mexico")
D.acl=new C.rl("Oceania",2,"Australia, New Zealand")
D.ack=new C.rl("Asia",7,"Brunei, Indonesia, Japan, Qatar, Singapore, South Korea, United Arab Emirates")
D.Sf=x([D.aco,D.acn,D.acm,D.acl,D.ack],A.X("o<rl>"))
D.TM=x([],A.X("o<b2>"))
D.TN=x([],A.X("o<H<k>>"))
D.acS=x([],A.X("o<jv>"))
D.ti=x([],y.J)
D.mZ=x([],y.X)
D.jg=x([],y.n)
D.TL=x([],y.R)
D.TK=x([],y.K)
D.acs=new C.wh(E.mK,"55 countries","Eligible nationalities")
D.Mq=new A.ak(58009,"MaterialIcons",!0)
D.acr=new C.wh(D.Mq,"Transit only","To third countries or regions")
D.acq=new C.wh(R.eX,"240 hours","No more than 10 days")
D.N7=new A.ak(61083,"MaterialIcons",!1)
D.acp=new C.wh(D.N7,"Visa required","Work, study, and news reporting")
D.TV=x([D.acs,D.acr,D.acq,D.acp],A.X("o<wh>"))
D.TZ=x(["International Society of Multidisciplinary Interventional Oncology (ISMIO)","Beijing Research Association for Chronic Diseases Control and Health Education","Asia-Pacific Society of Cardiovascular and Interventional Radiology (APSCVIR)"],y.s)
D.ac3=new C.w1(0,"11","Thu")
D.ac2=new C.w1(1,"12","Fri")
D.ac0=new C.w1(2,"13","Sat")
D.ac1=new C.w1(3,"14","Sun")
D.tn=x([D.ac3,D.ac2,D.ac0,D.ac1],A.X("o<w1>"))
D.DG=new A.c6(5,null,null,null)
D.DK=new A.c6(null,3,null,null)
D.a2v=new C.qz(0,"top")
D.Ea=new C.qz(1,"middle")
D.a2w=new C.qz(2,"bottom")
D.a2x=new C.qz(3,"baseline")
D.Eb=new C.qz(4,"fill")
D.a2y=new C.qz(5,"intrinsicHeight")
D.a2Z=new A.n(!0,B.cf,null,null,null,null,12,B.aa,null,null,null,null,1.3,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a35=new A.n(!0,B.ae,null,null,null,null,12,B.x,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a36=new A.n(!0,B.ae,null,null,null,null,21,B.C,null,null,null,null,1.25,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a3B=new A.n(!0,B.ae,null,null,null,null,24,B.C,null,null,null,null,1.15,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a3U=new A.n(!0,B.b3,null,null,null,null,13,B.aa,null,null,null,null,1.35,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.Es=new A.n(!0,B.b3,null,null,null,null,12,B.x,null,null,null,null,1.3,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a49=new A.n(!0,B.ae,null,null,null,null,14,B.bl,null,null,null,null,1.35,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a4l=new A.n(!0,B.a9,null,null,null,null,12,B.x,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a4X=new A.n(!0,B.b3,null,null,null,null,14,B.aa,null,null,null,null,1.45,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a5c=new A.n(!0,B.cf,null,null,null,null,12,B.x,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a5E=new A.n(!0,B.ae,null,null,null,null,null,B.C,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a5Q=new A.n(!0,B.b3,null,null,null,null,11,B.aa,null,null,null,null,1.25,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a5X=new A.n(!0,B.b3,null,null,null,null,13,B.aa,null,null,null,null,1.45,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.Ez=new A.n(!0,B.b3,null,null,null,null,14,B.aa,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a62=new A.n(!0,B.e,null,null,null,null,12,B.aa,null,null,null,null,1.35,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.EB=new A.n(!0,B.e,null,null,null,null,16,B.C,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a68=new A.n(!0,B.e,null,null,null,null,16,B.C,null,null,null,null,1.2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a6b=new A.n(!0,B.e,null,null,null,null,13,B.bl,null,0,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a6h=new A.n(!0,B.cf,null,null,null,null,12,B.aa,null,null,null,null,1.35,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a6Y=new A.n(!0,B.ae,null,null,null,null,13,B.aa,null,null,null,null,1.45,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a70=new A.n(!0,B.e,null,null,null,null,18,B.C,null,null,null,null,1.25,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a78=new A.n(!0,B.cM,null,null,null,null,12,B.C,null,null,null,null,1.3,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.EG=new A.n(!0,B.cf,null,null,null,null,12,B.aa,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a7t=new A.n(!0,B.ae,null,null,null,null,15,B.C,null,null,null,null,1.25,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a7F=new A.n(!0,B.b3,null,null,null,null,15,B.Y,null,null,null,null,1.55,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a7J=new A.n(!0,B.ae,null,null,null,null,14,B.C,null,null,null,null,1.25,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.os=new A.n(!0,B.ae,null,null,null,null,18,B.C,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.EI=new A.n(!0,B.ae,null,null,null,null,15,B.bl,null,null,null,null,1.3,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.EJ=new A.n(!0,B.b3,null,null,null,null,12,B.aa,null,null,null,null,1.35,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a5T=new A.n(!0,B.b3,null,null,null,null,14,B.aa,null,null,null,null,1.5,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a8i=new A.cn("Nationals of eligible countries who transit through China to third countries or regions may enter visa-free through designated open ports and stay in permitted areas for no more than 10 days, provided they hold valid international travel documents and onward tickets with confirmed seats and departure dates.",null,D.a5T,null,null,null,null,null,null,null)
D.a8j=new A.cn("Session Details",null,B.hO,null,null,null,null,null,null,null)
D.ED=new A.n(!0,B.b3,null,null,null,null,13,B.aa,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a8m=new A.cn("For more details, please refer to the National Immigration Administration page.",null,D.ED,null,null,null,null,null,null,null)
D.a8q=new A.cn("Add",null,null,null,null,null,null,null,null,null)
D.a8r=new A.cn("No matching faculty found.",null,D.kf,null,null,null,null,null,null,null)
D.a8t=new A.cn("Search or filter by surname initial.",null,D.EG,null,null,null,null,null,null,null)
D.a8w=new A.cn("Book directly through the official third-party hotel links for APSCVIR 2026 rates.",null,D.ED,null,null,null,null,null,null,null)
D.a8y=new A.cn("No detailed sub-session agenda is available locally yet.",null,D.Ez,null,null,null,null,null,null,null)
D.a8A=new A.cn("Faculty Profile",null,B.hO,null,null,null,null,null,null,null)
D.a7Q=new A.n(!0,B.e,null,null,null,null,16,B.C,null,null,null,null,1.35,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a8G=new A.cn("Organizing Chair\nGao-Jun Teng, Acad. CAS, FSIR, FCIRSE",null,D.a7Q,null,null,null,null,null,null,null)
D.a8H=new A.cn("Book Now",null,null,null,null,null,null,null,null,null)
D.a8I=new A.cn("Open Official Visa Policy",null,null,null,null,null,null,null,null,null)
D.abe=new C.kn("Address","")
D.abV=new C.a1a(null)})();(function lazyInitializers(){var x=a.lazyFinal
x($,"blr","b3b",()=>A.bdM())})()};
(a=>{a["GQjVZfTYNBZwfKALo2qionBO+r8="]=a.current})($__dart_deferred_initializers__);