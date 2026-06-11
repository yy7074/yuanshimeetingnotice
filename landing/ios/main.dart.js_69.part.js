((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var A,C,B={
aSM(d,e,f){return new B.Ew(d,e,f,null)},
aiE(d,e,f){var x,w,v=f.a,u=e.a,t=Math.pow(v[0]-u[0],2)+Math.pow(v[1]-u[1],2)
if(t===0)return e
x=d.V(0,e)
w=f.V(0,e)
return e.Z(0,w.mD(A.E(x.qO(w)/t,0,1)))},
b9H(d,e){var x,w,v,u,t,s,r,q=e.a,p=d.V(0,q),o=e.b,n=o.V(0,q),m=e.d,l=m.V(0,q),k=p.qO(n),j=n.qO(n),i=p.qO(l),h=l.qO(l)
if(0<=k&&k<=j&&0<=i&&i<=h)return d
x=e.c
w=[B.aiE(d,q,o),B.aiE(d,o,x),B.aiE(d,x,m),B.aiE(d,m,q)]
v=A.ck()
for(q=d.a,u=1/0,t=0;t<4;++t){s=w[t]
o=s.a
r=Math.sqrt(Math.pow(q[0]-o[0],2)+Math.pow(q[1]-o[1],2))
if(r<u){v.b=s
u=r}}return v.aT()},
bdJ(){var x=new A.aZ(new Float64Array(16))
x.dP()
return new B.WR(x,$.au())},
b1C(d,e,f){return Math.log(f/d)/Math.log(e/100)},
b2c(d,e){var x,w,v,u,t,s,r=new A.aZ(new Float64Array(16))
r.bq(d)
r.hK(r)
x=e.a
w=e.b
v=new A.c2(new Float64Array(3))
v.dY(x,w,0)
v=r.mx(v)
u=e.c
t=new A.c2(new Float64Array(3))
t.dY(u,w,0)
t=r.mx(t)
w=e.d
s=new A.c2(new Float64Array(3))
s.dY(u,w,0)
s=r.mx(s)
u=new A.c2(new Float64Array(3))
u.dY(x,w,0)
u=r.mx(u)
x=new A.c2(new Float64Array(3))
x.bq(v)
w=new A.c2(new Float64Array(3))
w.bq(t)
v=new A.c2(new Float64Array(3))
v.bq(s)
t=new A.c2(new Float64Array(3))
t.bq(u)
return new B.G7(x,w,v,t)},
b1x(d,e){var x,w,v,u,t,s,r=[e.a,e.b,e.c,e.d]
for(x=C.m,w=0;w<4;++w){v=r[w]
u=B.b9H(v,d).a
t=v.a
s=u[0]-t[0]
t=u[1]-t[1]
if(Math.abs(s)>Math.abs(x.a))x=new A.h(s,x.b)
if(Math.abs(t)>Math.abs(x.b))x=new A.h(x.a,t)}return B.aUA(x)},
aUA(d){return new A.h(A.aUM(C.d.ae(d.a,9)),A.aUM(C.d.ae(d.b,9)))},
bh2(d,e){if(d.k(0,e))return null
return Math.abs(e.a-d.a)>Math.abs(e.b-d.b)?C.aC:C.a6},
Ew:function Ew(d,e,f,g){var _=this
_.w=d
_.at=e
_.ax=f
_.a=g},
KN:function KN(d,e,f,g){var _=this
_.d=$
_.e=d
_.f=e
_.w=_.r=null
_.z=_.y=_.x=$
_.at=_.as=_.Q=null
_.ay=_.ax=0
_.ch=null
_.d8$=f
_.aU$=g
_.c=_.a=null},
aGY:function aGY(){},
a0e:function a0e(d,e,f,g,h,i,j){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.r=h
_.w=i
_.a=j},
WR:function WR(d,e){var _=this
_.a=d
_.k4$=0
_.ok$=e
_.p2$=_.p1$=0},
Km:function Km(d,e){this.a=d
this.b=e},
anM:function anM(d,e){this.a=d
this.b=e},
NS:function NS(){},
G7:function G7(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g}},D
A=c[0]
C=c[2]
B=a.updateHolder(c[18],B)
D=c[88]
B.Ew.prototype={
a9(){var x=null,w=y.z
return new B.KN(new A.bc(x,w),new A.bc(x,w),x,x)}}
B.KN.prototype={
gbU(){var x=this.d
if(x===$){this.a.toString
x=B.bdJ()
this.d=x}return x},
gAJ(){var x,w=$.ad.ar$.x.h(0,this.e).ga1()
w.toString
x=y.g.a(w).gv()
this.a.toString
return C.V.yx(new A.C(0,0,0+x.a,0+x.b))},
gD0(){var x=$.ad.ar$.x.h(0,this.f).ga1()
x.toString
x=y.g.a(x).gv()
return new A.C(0,0,0+x.a,0+x.b)},
tL(a0,a1){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this
if(a1.k(0,C.m)){x=new A.aZ(new Float64Array(16))
x.bq(a0)
return x}if(d.Q!=null){d.a.toString
switch(3){case 3:break}}w=new A.aZ(new Float64Array(16))
w.bq(a0)
w.dj(a1.a,a1.b,0,1)
v=B.b2c(w,d.gD0())
if(d.gAJ().ga4m(0))return w
x=d.gAJ()
u=d.ay
t=new A.aZ(new Float64Array(16))
t.dP()
s=x.c
r=x.a
q=s-r
p=x.d
x=x.b
o=p-x
t.dj(q/2,o/2,0,1)
t.Gt(u)
t.dj(-q/2,-o/2,0,1)
u=new A.c2(new Float64Array(3))
u.dY(r,x,0)
u=t.mx(u)
q=new A.c2(new Float64Array(3))
q.dY(s,x,0)
q=t.mx(q)
x=new A.c2(new Float64Array(3))
x.dY(s,p,0)
x=t.mx(x)
s=new A.c2(new Float64Array(3))
s.dY(r,p,0)
s=t.mx(s)
r=new Float64Array(3)
new A.c2(r).bq(u)
u=new Float64Array(3)
new A.c2(u).bq(q)
q=new Float64Array(3)
new A.c2(q).bq(x)
x=new Float64Array(3)
new A.c2(x).bq(s)
s=r[0]
p=u[0]
o=q[0]
n=x[0]
m=Math.min(s,Math.min(p,Math.min(o,n)))
r=r[1]
u=u[1]
q=q[1]
x=x[1]
l=Math.min(r,Math.min(u,Math.min(q,x)))
k=Math.max(s,Math.max(p,Math.max(o,n)))
j=Math.max(r,Math.max(u,Math.max(q,x)))
x=new A.c2(new Float64Array(3))
x.dY(m,l,0)
u=new A.c2(new Float64Array(3))
u.dY(k,l,0)
s=new A.c2(new Float64Array(3))
s.dY(k,j,0)
r=new A.c2(new Float64Array(3))
r.dY(m,j,0)
q=new A.c2(new Float64Array(3))
q.bq(x)
x=new A.c2(new Float64Array(3))
x.bq(u)
u=new A.c2(new Float64Array(3))
u.bq(s)
s=new A.c2(new Float64Array(3))
s.bq(r)
i=new B.G7(q,x,u,s)
h=B.b1x(i,v)
if(h.k(0,C.m))return w
x=w.H0().a
u=x[0]
x=x[1]
g=a0.rO()
u-=h.a*g
x-=h.b*g
f=new A.aZ(new Float64Array(16))
f.bq(a0)
s=new A.c2(new Float64Array(3))
s.dY(u,x,0)
f.Rz(s)
e=B.b1x(i,B.b2c(f,d.gD0()))
if(e.k(0,C.m))return f
s=e.a===0
if(!s&&e.b!==0){x=new A.aZ(new Float64Array(16))
x.bq(a0)
return x}u=s?u:0
x=e.b===0?x:0
s=new A.aZ(new Float64Array(16))
s.bq(a0)
r=new A.c2(new Float64Array(3))
r.dY(u,x,0)
s.Rz(r)
return s},
KA(d,e){var x,w,v,u,t,s,r,q=this
if(e===1){x=new A.aZ(new Float64Array(16))
x.bq(d)
return x}w=q.gbU().a.rO()
x=q.gD0()
v=q.gAJ()
u=q.gD0()
t=q.gAJ()
s=Math.max(w*e,Math.max((x.c-x.a)/(v.c-v.a),(u.d-u.b)/(t.d-t.b)))
t=q.a
r=A.E(s,t.ax,t.at)/w
x=new A.aZ(new Float64Array(16))
x.bq(d)
x.nT(r,r,r,1)
return x},
ape(d,e,f){var x,w,v,u
if(e===0){x=new A.aZ(new Float64Array(16))
x.bq(d)
return x}w=this.gbU().j0(f)
x=new A.aZ(new Float64Array(16))
x.bq(d)
v=w.a
u=w.b
x.dj(v,u,0,1)
x.Gt(-e)
x.dj(-v,-u,0,1)
return x},
Bl(d){var x
A:{x=!0
if(D.abc===d){x=!1
break A}if(D.ks===d){this.a.toString
break A}if(D.hU===d||d==null){this.a.toString
break A}x=null}return x},
VK(d){this.a.toString
if(Math.abs(d.d-1)>Math.abs(0))return D.ks
else return D.hU},
aqz(d){var x,w,v=this
v.a.toString
x=v.y
x===$&&A.a()
w=x.r
if(w!=null&&w.a!=null){x.eI()
x=v.y
x.sn(x.a)
x=v.r
if(x!=null)x.a.L(v.gBy())
v.r=null}x=v.z
x===$&&A.a()
w=x.r
if(w!=null&&w.a!=null){x.eI()
x=v.z
x.sn(x.a)
x=v.w
if(x!=null)x.a.L(v.gBB())
v.w=null}v.Q=v.ch=null
v.at=v.gbU().a.rO()
v.as=v.gbU().j0(d.b)
v.ax=v.ay},
aqB(d){var x,w,v,u,t,s,r=this,q=r.gbU().a.rO(),p=r.x=d.c,o=r.gbU().j0(p),n=r.ch
if(n===D.hU)n=r.ch=r.VK(d)
else if(n==null){n=r.VK(d)
r.ch=n}if(!r.Bl(n)){r.a.toString
return}switch(n.a){case 1:n=r.at
n.toString
r.gbU().sn(r.KA(r.gbU().a,n*d.d/q))
x=r.gbU().j0(p)
n=r.gbU()
w=r.gbU().a
v=r.as
v.toString
n.sn(r.tL(w,x.V(0,v)))
u=r.gbU().j0(p)
p=r.as
p.toString
if(!B.aUA(p).k(0,B.aUA(u)))r.as=u
break
case 2:n=d.r
if(n===0){r.a.toString
return}w=r.ax
w.toString
t=w+n
r.gbU().sn(r.ape(r.gbU().a,r.ay-t,p))
r.ay=t
break
case 0:if(d.d!==1){r.a.toString
return}if(r.Q==null){n=r.as
n.toString
r.Q=B.bh2(n,o)}n=r.as
n.toString
s=o.V(0,n)
r.gbU().sn(r.tL(r.gbU().a,s))
r.as=r.gbU().j0(p)
break}r.a.toString},
aqx(d){var x,w,v,u,t,s,r,q,p,o,n,m=this
m.a.toString
m.as=m.ax=m.at=null
x=m.r
if(x!=null)x.a.L(m.gBy())
x=m.w
if(x!=null)x.a.L(m.gBB())
x=m.y
x===$&&A.a()
x.sn(x.a)
x=m.z
x===$&&A.a()
x.sn(x.a)
x=m.ch
if(!m.Bl(x)){m.Q=null
return}A:{if(D.hU===x){x=d.a.a
if(x.gcj()<50){m.Q=null
return}w=m.gbU().a.H0().a
v=w[0]
w=w[1]
m.a.toString
u=A.afr(0.0000135,v,x.a,0)
m.a.toString
t=A.afr(0.0000135,w,x.b,0)
x=x.gcj()
m.a.toString
s=B.b1C(x,0.0000135,10)
x=u.guD()
r=t.guD()
q=y.A
p=A.cK(C.dV,m.y,null)
m.r=new A.as(p,new A.ay(new A.h(v,w),new A.h(x,r),q),q.i("as<aF.T>"))
m.y.e=A.ec(0,0,C.d.aF(s*1000))
p.a0(m.gBy())
m.y.bT()
break A}if(D.ks===x){x=d.b
w=Math.abs(x)
if(w<0.1){m.Q=null
return}o=m.gbU().a.rO()
m.a.toString
n=A.afr(0.0026999999999999997,o,x/10,0)
m.a.toString
s=B.b1C(w,0.0000135,0.1)
x=n.fa(s)
w=y.f
v=A.cK(C.dV,m.z,null)
m.w=new A.as(v,new A.ay(o,x,w),w.i("as<aF.T>"))
m.z.e=A.ec(0,0,C.d.aF(s*1000))
v.a0(m.gBB())
m.z.bT()
break A}break A}},
aox(d){var x,w,v,u,t,s,r,q=this,p=d.gds(),o=d.gby()
if(y.l.b(d)){x=d.gcp()===C.bE
if(x)q.a.toString
if(x){q.a.toString
x=o.Z(0,d.gmE())
w=d.gmE()
v=A.uo(d.gbQ(),null,w,x)
if(!q.Bl(D.hU)){q.a.toString
return}u=q.gbU().j0(p)
t=q.gbU().j0(p.V(0,v))
q.gbU().sn(q.tL(q.gbU().a,t.V(0,u)))
q.a.toString
return}if(d.gmE().b===0)return
x=d.gmE()
q.a.toString
s=Math.exp(-x.b/200)}else if(y.B.b(d))s=d.gh4()
else return
q.a.toString
if(!q.Bl(D.ks))return
u=q.gbU().j0(p)
q.gbU().sn(q.KA(q.gbU().a,s))
r=q.gbU().j0(p)
q.gbU().sn(q.tL(q.gbU().a,r.V(0,u)))
q.a.toString},
alV(){var x,w,v,u,t,s=this,r=s.y
r===$&&A.a()
r=r.r
if(!(r!=null&&r.a!=null)){s.Q=null
r=s.r
if(r!=null)r.a.L(s.gBy())
s.r=null
r=s.y
r.sn(r.a)
return}r=s.gbU().a.H0().a
x=r[0]
r=r[1]
w=s.gbU()
v=s.gbU().a
u=s.gbU()
t=s.r
w.sn(s.tL(v,u.j0(t.b.a6(t.a.gn())).V(0,s.gbU().j0(new A.h(x,r)))))},
amR(){var x,w,v,u,t,s=this,r=s.z
r===$&&A.a()
r=r.r
if(!(r!=null&&r.a!=null)){s.Q=null
r=s.w
if(r!=null)r.a.L(s.gBB())
s.w=null
r=s.z
r.sn(r.a)
return}r=s.w
x=r.b.a6(r.a.gn())
r=s.gbU().a.rO()
w=s.gbU()
v=s.x
v===$&&A.a()
u=w.j0(v)
s.gbU().sn(s.KA(s.gbU().a,x/r))
t=s.gbU().j0(s.x)
s.gbU().sn(s.tL(s.gbU().a,t.V(0,u)))},
anT(){this.O(new B.aGY())},
am(){var x=this,w=null
x.aG()
x.y=A.c3(w,w,w,w,x)
x.z=A.c3(w,w,w,w,x)
x.gbU().a0(x.gWI())},
aP(d){this.b0(d)
this.a.toString
return},
l(){var x=this,w=x.y
w===$&&A.a()
w.l()
w=x.z
w===$&&A.a()
w.l()
x.gbU().L(x.gWI())
x.a.toString
w=x.gbU()
w.ok$=$.au()
w.k4$=0
x.adl()},
E(d){var x,w,v,u=this,t=null
u.a.toString
x=u.gbU().a
w=u.a.w
v=new B.a0e(w,u.e,C.O,!0,x,t,t)
return A.tV(C.cO,A.dV(C.aX,v,C.F,!1,t,t,t,t,t,t,t,t,t,t,u.gaqw(),u.gaqy(),u.gaqA(),t,t,t,t,t,t,t,t,t,t,t,!1,new A.h(0,-0.005)),u.f,t,t,t,u.gaow(),t)}}
B.a0e.prototype={
E(d){var x=this,w=A.zW(x.w,new A.jX(x.c,x.d),null,x.r,!0)
return A.CX(w,x.e,null)}}
B.WR.prototype={
j0(d){var x=this.a,w=new A.aZ(new Float64Array(16))
if(w.hK(x)===0)A.T(A.h1(x,"other","Matrix cannot be inverted"))
x=new A.c2(new Float64Array(3))
x.dY(d.a,d.b,0)
x=w.mx(x).a
return new A.h(x[0],x[1])}}
B.Km.prototype={
H(){return"_GestureType."+this.b}}
B.anM.prototype={
H(){return"PanAxis."+this.b}}
B.NS.prototype={
bA(){this.ci()
this.c8()
this.ec()},
l(){var x=this,w=x.aU$
if(w!=null)w.L(x.ge0())
x.aU$=null
x.av()}}
B.G7.prototype={
j(d){var x=this
return"[0] "+x.a.j(0)+"\n[1] "+x.b.j(0)+"\n[2] "+x.c.j(0)+"\n[3] "+x.d.j(0)+"\n"},
k(d,e){var x=this
if(e==null)return!1
return e instanceof B.G7&&x.d.k(0,e.d)&&x.c.k(0,e.c)&&x.b.k(0,e.b)&&x.a.k(0,e.a)},
gB(d){var x=this
return A.a1(x.a,x.b,x.c,x.d,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)}}
var z=a.updateTypes(["~()","~(H2)","~(H3)","~(z9)","~(fQ)"])
B.aGY.prototype={
$0(){},
$S:0};(function aliases(){var x=B.NS.prototype
x.adl=x.l})();(function installTearOffs(){var x=a._instance_1u,w=a._instance_0u
var v
x(v=B.KN.prototype,"gaqy","aqz",1)
x(v,"gaqA","aqB",2)
x(v,"gaqw","aqx",3)
x(v,"gaow","aox",4)
w(v,"gBy","alV",0)
w(v,"gBB","amR",0)
w(v,"gWI","anT",0)})();(function inheritance(){var x=a.mixinHard,w=a.inherit,v=a.inheritMany
w(B.Ew,A.W)
w(B.NS,A.a4)
w(B.KN,B.NS)
w(B.aGY,A.dK)
w(B.a0e,A.a0)
w(B.WR,A.cb)
v(A.iO,[B.Km,B.anM])
w(B.G7,A.L)
x(B.NS,A.dQ)})()
A.dT(b.typeUniverse,JSON.parse('{"Ew":{"W":[],"d":[]},"KN":{"a4":["Ew"]},"a0e":{"a0":[],"d":[]},"WR":{"cb":["aZ"],"ai":[]}}'))
var y={z:A.X("bc<a4<W>>"),B:A.X("us"),l:A.X("q6"),g:A.X("A"),A:A.X("ay<h>"),f:A.X("ay<K>")};(function constants(){D.mP=new A.cd(C.mG,28,C.e,null,null)
D.acV=new B.anM(3,"free")
D.hU=new B.Km(0,"pan")
D.ks=new B.Km(1,"scale")
D.abc=new B.Km(2,"rotate")})()};
(a=>{a["zvmi81fsgVuSsleqLkKjRI4mZ1M="]=a.current})($__dart_deferred_initializers__);