((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,B,E,O,I,F,P,Q,G,R,S,T,U,K,V,W,X,Y,L,Z,A_,A0,A1,A2,A3,M,C={
aRJ(d){var x=0,w=A.t(y.y),v
var $async$aRJ=A.u(function(e,f){if(e===1)return A.p(f,w)
for(;;)switch(x){case 0:v=D.XJ.hB("add2Cal",d.it(),!1,y.u).aH(new C.a8m(),y.y)
x=1
break
case 1:return A.q(v,w)}})
return A.r($async$aRJ,w)},
a8m:function a8m(){},
ae7:function ae7(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.w=j},
a8q:function a8q(){},
ai3:function ai3(d){this.a=d},
bay(){return new C.nH(null)},
nH:function nH(d){this.a=d},
L3:function L3(d,e){var _=this
_.d=d
_.e=e
_.c=_.a=null},
aIr:function aIr(d,e){this.a=d
this.b=e},
aIq:function aIq(d,e,f){this.a=d
this.b=e
this.c=f},
aIp:function aIp(d,e){this.a=d
this.b=e},
aIg:function aIg(d,e){this.a=d
this.b=e},
aIe:function aIe(d,e){this.a=d
this.b=e},
aIf:function aIf(d,e){this.a=d
this.b=e},
aI8:function aI8(){},
aIj:function aIj(){},
aId:function aId(d,e,f){this.a=d
this.b=e
this.c=f},
aIc:function aIc(d,e,f){this.a=d
this.b=e
this.c=f},
aIb:function aIb(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j},
aIa:function aIa(d,e,f,g,h,i,j,k){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k},
aI9:function aI9(d,e){this.a=d
this.b=e},
aIo:function aIo(d){this.a=d},
aIk:function aIk(d,e){this.a=d
this.b=e},
aIh:function aIh(d,e){this.a=d
this.b=e},
aIi:function aIi(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
aIl:function aIl(d,e,f){this.a=d
this.b=e
this.c=f},
aIm:function aIm(d,e,f){this.a=d
this.b=e
this.c=f},
aIn:function aIn(d,e,f){this.a=d
this.b=e
this.c=f},
b9z(d,e){var x,w,v,u,t,s,r,q,p,o,n="\\\\",m="\\n",l="\\,",k="\\;",j="BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//APSCVIR//Conference App//EN\nCALSCALE:GREGORIAN\nMETHOD:PUBLISH\n"+("X-WR-CALNAME:"+C.b9y("APSCVIR My Schedule")+"\n"),i=C.aSG(new A.db(Date.now(),0,!1).pr())
for(x=d.length,w="DTSTAMP:"+i+"\n",v=0;v<d.length;d.length===x||(0,A.y)(d),++v){u=d[v]
t=e?u.d:u.c
s=e?u.f:u.e
r=e?u.w:u.r
q=C.aSG(u.x.pr())
p=C.aSG(u.y.pr())
o=A.aG(t,"\\",n)
o=A.aG(o,"\n",m)
o=A.aG(o,"\r","")
o=A.aG(o,",",l)
j=j+"BEGIN:VEVENT\n"+("UID:"+u.a+"@apscvir\n")+w+("DTSTART:"+q+"\n")+("DTEND:"+p+"\n")+("SUMMARY:"+A.aG(o,";",k)+"\n")
if(s.length!==0){q=A.aG(s,"\\",n)
q=A.aG(q,"\n",m)
q=A.aG(q,"\r","")
q=A.aG(q,",",l)
j+="DESCRIPTION:"+A.aG(q,";",k)+"\n"}if(r.length!==0){q=A.aG(r,"\\",n)
q=A.aG(q,"\n",m)
q=A.aG(q,"\r","")
q=A.aG(q,",",l)
j+="LOCATION:"+A.aG(q,";",k)+"\n"}q=A.aG(t,"\\",n)
q=A.aG(q,"\n",m)
q=A.aG(q,"\r","")
q=A.aG(q,",",l)
j=j+"BEGIN:VALARM\nACTION:DISPLAY\n"+("DESCRIPTION:"+A.aG(q,";",k)+"\n")+"TRIGGER:-PT15M\nEND:VALARM\nEND:VEVENT\n"}j+="END:VCALENDAR\n"
return j.charCodeAt(0)==0?j:j},
Ek(d,e,f){var x=0,w=A.t(y.H),v,u,t
var $async$Ek=A.u(function(g,h){if(g===1)return A.p(h,w)
for(;;)switch(x){case 0:v=C.b9z(d,e)
t=A
x=2
return A.j(A.wt(),$async$Ek)
case 2:u=t.aeH(h.a+"/my-schedule.ics")
x=3
return A.j(u.aIv(v),$async$Ek)
case 3:x=4
return A.j(A3.Hr(A.b([A.axX(u.a,"text/calendar","my-schedule.ics")],y.S),f,null),$async$Ek)
case 4:return A.q(null,w)}})
return A.r($async$Ek,w)},
aSG(d){var x=d.pr(),w=new C.ai9()
return B.c.ij(B.f.j(A.dY(x)),4,"0")+A.m(w.$1(A.cx(x)))+A.m(w.$1(A.cZ(x)))+"T"+A.m(w.$1(A.G_(x)))+A.m(w.$1(A.G0(x)))+A.m(w.$1(A.aoG(x)))+"Z"},
b9y(d){var x=A.aG(d,"\\","\\\\")
x=A.aG(x,"\n","\\n")
x=A.aG(x,"\r","")
x=A.aG(x,",","\\,")
return A.aG(x,";","\\;")},
ai9:function ai9(){},
aeZ:function aeZ(){},
anj:function anj(){},
a8o:function a8o(d,e){this.a=d
this.b=e},
aiv:function aiv(d,e){this.a=d
this.b=e},
aoK:function aoK(d,e){this.a=d
this.b=e},
ah3:function ah3(d,e){this.a=d
this.b=e},
a9_:function a9_(d,e){this.a=d
this.b=e},
a8p:function a8p(){},
abp:function abp(){},
aZ9(d,e,f){var x=null
return new L.FD(!1,e,x,x,x,f,x,x,!1,x,!0,x,d,x)}},D,H,A4,A5,A6,N,A7,A8,A9,Aa
J=c[1]
A=c[0]
B=c[2]
E=c[35]
O=c[32]
I=c[82]
F=c[47]
P=c[91]
Q=c[48]
G=c[50]
R=c[85]
S=c[51]
T=c[98]
U=c[55]
K=c[44]
V=c[45]
W=c[24]
X=c[101]
Y=c[28]
L=c[31]
Z=c[80]
A_=c[73]
A0=c[77]
A1=c[30]
A2=c[87]
A3=c[29]
M=c[89]
C=a.updateHolder(c[6],C)
D=c[96]
H=c[39]
A4=c[102]
A5=c[42]
A6=c[97]
N=c[34]
A7=c[58]
A8=c[74]
A9=c[99]
Aa=c[100]
C.ae7.prototype={
it(){var x,w=this,v=A.aD(["title",w.a,"desc",w.b,"location",w.c,"startDate",w.e.a,"endDate",w.f.a,"timeZone",w.d,"allDay",!1,"recurrence",null],y.N,y.z)
if($.b41()){x=w.w.a
v.p(0,"alarmInterval",x==null?null:B.f.cC(x.a,1e6))
v.p(0,"url",null)}else v.p(0,"invites",null)
return v}}
C.a8q.prototype={}
C.ai3.prototype={}
C.nH.prototype={
a9(){var x=$.b3o()
return new C.L3(x,new A.d_(B.ay,$.au()))}}
C.L3.prototype={
am(){var x,w
this.aG()
this.Kf()
$.O()
x=$.N
if(x==null)x=$.N=B.q
w=x.aC(null,y.n)
w.cy.sn("")
w.jI()},
l(){var x=this.e
x.ok$=$.au()
x.k4$=0
this.av()},
Kf(){var x=0,w=A.t(y.H),v
var $async$Kf=A.u(function(d,e){if(d===1)return A.p(e,w)
for(;;)switch(x){case 0:x=1
break
case 1:return A.q(v,w)}})
return A.r($async$Kf,w)},
Cz(d,e){return this.auH(d,e)},
auH(d,e){var x=0,w=A.t(y.H),v=this
var $async$Cz=A.u(function(f,g){if(f===1)return A.p(g,w)
for(;;)switch(x){case 0:x=2
return A.j(v.d.Hw(e,B.c.gB(d),D.HK,d),$async$Cz)
case 2:return A.q(null,w)}})
return A.r($async$Cz,w)},
E(d){var x,w,v=null
$.O()
x=$.N
if(x==null)x=$.N=B.q
w=x.aC(v,y.n)
return A.f8(v,B.a3,A.hF(!0,A.an(A.b([this.afA(B.ae,B.l),new A.dg(new C.aIr(this,w),v)],y.p),B.p,B.h,B.j),!0,B.V,!0,!0),v,v)},
afo(d,e){var x,w,v,u,t,s,r=null,q=d.gH8().length,p=d.ga5o().length,o=d.gaAo()
if(q===0&&p===0&&o.length===0)return B.a5
x=q>0
if(x&&p>0)w="My Schedule"
else w=p>0||o.length!==0?'Personal Tasks \xb7 matched by full name "'+o+'"':"Saved Schedule"
if(x&&p>0){x=p===1?"":"s"
v=q===1?"":"s"
u=""+p+" personal task"+x+" and "+q+" saved session"+v+"."}else if(p>0){x=p===1?"":"s"
x=""+p+" assigned task"+x+" found across the program."
u=x}else{if(x){x=q===1?"":"s"
x=""+q+" saved session"+x+" from your manual selections."}else x="No tasks matched in the APSCVIR 2026 program yet."
u=x}x=A.Z(20,e.m()>>>16&255,e.m()>>>8&255,e.m()&255)
v=A.a_(10)
t=A.bi(A.Z(55,e.m()>>>16&255,e.m()>>>8&255,e.m()&255),1)
s=y.p
return A.a6(r,A.aA(A.b([A.aC(H.j_,e,r,20),M.co,A.b7(A.an(A.b([A.x(w,r,r,r,r,A.Y(r,r,e,r,r,r,r,r,r,r,r,13,r,r,B.bl,r,1.25,!0,r,r,r,r,r,r,r,r),r,r),A0.fk,A.x(u,r,r,r,r,A.Y(r,r,B.bT,r,r,r,r,r,r,r,r,11,r,r,B.Y,r,1.3,!0,r,r,r,r,r,r,r,r),r,r)],s),B.u,B.h,B.j),1)],s),B.p,B.h,B.j,0,r,r),B.i,r,r,new A.ac(x,r,t,v,r,r,B.o),r,r,r,D.Lh,A6.qM,r,r,1/0)},
TI(d,e,f){var x=this,w=null,v=f?0:10,u=f?0:8,t=A.aC(K.eY,e,w,20),s=A.aA(A.b([A.dx(w,w,D.NC,w,w,new C.aIe(x,d),w,w,"Clear"),A.dx(w,w,D.NB,w,w,new C.aIf(x,d),w,w,"Search")],y.p),B.p,B.h,B.ab,0,w,w)
return new A.aP(new A.ae(16,v,16,u),N.fV(x.e,N.fm(w,new A.cm(4,A.a_(8),new A.az(A.Z(35,e.m()>>>16&255,e.m()>>>8&255,e.m()&255),1,B.w,-1)),w,Q.ci,w,w,w,w,!0,new A.cm(4,A.a_(8),new A.az(A.Z(35,e.m()>>>16&255,e.m()>>>8&255,e.m()&255),1,B.w,-1)),w,w,w,w,w,B.e,!0,w,w,w,w,new A.cm(4,A.a_(8),new A.az(e,1,B.w,-1)),w,w,w,w,w,w,w,w,w,"Search topic, speaker, room, or time",w,w,w,w,w,!0,w,w,w,!0,!0,!1,w,t,w,w,w,w,w,w,s,w,D.Gk,w,w,w),D.aas,w,w,!1,w,new C.aIg(x,d),w,B.aj,B.ol),w)},
afT(d,e){return this.TI(d,e,!1)},
Tl(d){var x=B.c.aA(this.e.a.a),w=d.cy
if(w.gn()===x)return
w.sn(x)
d.ch.sn(0)
this.O(new C.aI8())},
agz(d){var x
this.e.jO(B.fl)
x=d.cy
if(x.gn().length!==0){x.sn("")
d.ch.sn(0)}this.O(new C.aIj())},
wT(){var x=0,w=A.t(y.H),v,u=this,t,s,r,q
var $async$wT=A.u(function(d,e){if(d===1)return A.p(e,w)
for(;;)switch(x){case 0:s=$.O()
r=y.Z
q=$.N
if(q==null)q=$.N=B.q
x=$.cF.ab(q.dK(A.be(r),null))?3:4
break
case 3:q=$.N
t=(q==null?$.N=B.q:q).aC(null,r)
x=t.ay.gD(0)===0?5:6
break
case 5:x=7
return A.j(t.uQ(),$async$wT)
case 7:case 6:x=8
return A.j(t.nU("20262026-0611-4614-8614-000000029839"),$async$wT)
case 8:case 4:if(u.c==null){x=1
break}A.fk(s,"/event_agenda",A.aD(["eventId","20262026-0611-4614-8614-000000029839","initialTab",1],y.N,y.K),y.z)
case 1:return A.q(v,w)}})
return A.r($async$wT,w)},
afA(d,e){var x,w,v=null
$.O()
x=$.N
if(x==null)x=$.N=B.q
w=x.aC(v,y.n)
return A.a6(v,A.aA(A.b([A.dx(v,v,A.aC(B.db,e,v,v),v,v,this.gapD(),v,v,"Back"),A.x(A1.dR("my_schedule_title"),v,v,v,v,A.Y(v,v,d,v,v,v,v,v,v,v,v,18,v,v,B.x,v,v,!0,v,0,v,v,v,v,v,v),v,v),new A.dg(new C.aId(this,w,e),v)],y.p),B.p,B.bm,B.j,0,v,v),B.i,B.e,v,v,v,v,v,v,T.iF,v,v,v)},
apE(){var x=$.O(),w=$.c7().xr.gM()
if((w==null?null:w.k8())===!0)A.cG(x,null)
else A.hb(x,"/main",y.z)},
aft(d,e,f){var x,w,v
$.O()
x=$.cA().a
x=x==null?null:x.gbo()
w=y.s
v=A.b(["Mon","Tue","Wed","Thu","Fri","Sat","Sun"],w)
return new A.dg(new C.aIb(this,e,f,x==="__zh_disabled__",A.b(["Mon","Tue","Wed","Thu","Fri","Sat","Sun"],w),v,d),null)},
ahy(d,e){var x=A.cK(B.dx,e,D.qi),w=y.L
return new A.dd(x,!1,A.hh(d,new A.as(x,new A.ay(D.Yv,B.m,w),w.i("as<aF.T>")),null,!0),null)},
afu(d,e,f,g){var x,w,v,u,t,s,r,q,p=null
$.O()
x=$.cA().a
x=x==null?p:x.gbo()
if(g.length===0)return B.a5
w=this.Za(f,g)
v=f.gQ7().length
u=["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
t=["January","February","March","April","May","June","July","August","September","October","November","December"]
s=x==="__zh_disabled__"?u[A.yM(w)-1]+", "+t[A.cx(w)-1]+" "+A.cZ(w):u[A.yM(w)-1]+", "+t[A.cx(w)-1]+" "+A.cZ(w)
x=A.x(s,p,p,p,p,A.Y(p,p,e,p,p,p,p,p,p,p,p,20,p,p,B.x,p,p,!0,p,0,p,p,p,p,p,p),p,p)
r=A.Z(B.d.aF(25.5),d.m()>>>16&255,d.m()>>>8&255,d.m()&255)
q=A.a_(20)
return A.aA(A.b([x,A.a6(p,A.x(""+v+" TASKS",p,p,p,p,A.Y(p,p,d,p,p,p,p,p,p,p,p,10,p,p,B.x,p,p,!0,p,0,p,p,p,p,p,p),p,p),B.i,p,p,new A.ac(r,p,p,q,p,p,B.o),p,p,p,p,D.L5,p,p,p)],y.p),B.p,B.bm,B.j,0,p,p)},
Za(d,e){var x,w,v=A.Rj(d.gqM(),new C.aIo(d))
if(v!=null){x=v.x
return A.is(A.dY(x),A.cx(x),A.cZ(x),0,0)}w=d.ch.gn()
if(w>=0&&w<e.length)return e[w]
return B.b.gY(e)},
ahx(d,e,f){var x=A.Rj(d.gqM(),new C.aIk(this,e)),w=x==null?null:x.ch
return w==null?f:w},
X6(d,e){return A.dY(d)===A.dY(e)&&A.cx(d)===A.cx(e)&&A.cZ(d)===A.cZ(e)},
afU(d,e,f,g){var x,w,v,u,t,s,r,q,p,o=this,n=null
$.O()
x=$.cA().a
x=x==null?n:x.gbo()
w=g.z===B.fh
v=g.glt()
u=g.CW
if(u.length===0)u="Task"
t=g.cy
s=w?f:B.aN
r=w?A9.eX:H.j_
q=y.p
s=A.b([A.a6(n,A.aC(r,w?B.e:B.ai,n,16),B.i,n,n,new A.ac(s,n,n,n,n,n,B.bc),n,30,n,n,n,n,n,30)],q)
if(!e)s.push(A.b7(A.a6(n,n,B.i,B.aN,n,n,n,n,n,D.L2,n,n,n,2),1))
s=A.c1(A.an(s,B.p,B.h,B.j),n,36)
r=A.b([o.ZV(f,u)],q)
p=g.as
if(p.length!==0)r.push(o.ZV(B.b3,p))
p=g.c
v=A.b([O.IV(I.d1,r,I.fs,6,6),B.as,A.aA(A.b([A.b7(A.x(p,n,n,n,n,D.a4V,n,n),1),A.aA(A.b([A.dV(n,A.aC(D.rE,f,n,21),B.F,!1,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,new C.aIh(o,g),n,n,n,n,n,n,!1,B.ax),M.co,A.dV(n,A.aC(D.My,f,n,21),B.F,!1,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,new C.aIi(o,x==="__zh_disabled__",g,f),n,n,n,n,n,n,!1,B.ax)],q),B.p,B.h,B.j,0,n,n)],q),B.u,B.h,B.j,0,n,n),B.as,A.aA(A.b([A.aC(Z.h2,B.S,n,14),R.c7,A.b7(A.x(g.r+" \u2022 "+v,n,n,n,n,A.Y(n,n,B.S,n,n,n,n,n,n,n,n,14,n,n,B.Y,n,n,!0,n,n,n,n,n,n,n,n),n,n),1)],q),B.p,B.h,B.j,0,n,n)],q)
if(t.length!==0&&t!==p)B.b.J(v,A.b([D.DM,A.x(t,n,n,n,n,A.Y(n,n,B.ai,n,n,n,n,n,n,n,n,12,n,n,B.aa,n,1.35,!0,n,n,n,n,n,n,n,n),n,n)],q))
x=g.at
if(x.length!==0)B.b.J(v,A.b([D.a1T,A.x(x,n,n,n,n,A.Y(n,n,B.S,n,n,n,n,n,n,n,n,12,n,n,B.Y,n,1.35,!0,n,n,n,n,n,n,n,n),n,n)],q))
return new A.EA(A.aA(A.b([s,A2.dl,A.b7(new A.aP(D.KW,A.an(v,B.u,B.h,B.j),n),1)],q),B.aB,B.h,B.j,0,n,n),n)},
ZV(d,e){var x=null,w=A.Z(18,d.m()>>>16&255,d.m()>>>8&255,d.m()&255),v=A.a_(999),u=A.bi(A.Z(55,d.m()>>>16&255,d.m()>>>8&255,d.m()&255),1)
return A.a6(x,A.x(e,x,x,x,x,A.Y(x,x,d,x,x,x,x,x,x,x,x,11,x,x,B.bl,x,1,!0,x,x,x,x,x,x,x,x),x,x),B.i,x,x,new A.ac(w,x,u,v,x,x,B.o),x,x,x,x,B.dA,x,x,x)},
aj_(d,e){var x,w,v,u,t,s,r=null,q=" sessions to your calendar",p=$.O(),o=$.cA().a,n=(o==null?r:o.gbo())==="__zh_disabled__",m=d.gqM()
o=m.length
if(o===0){A.e8(p,"No Schedule","No assigned tasks are available to export",r,r,B.E,B.au)
return}x=A.a6(r,r,B.i,r,r,new A.ac(B.aw,r,r,A.a_(2),r,r,B.o),r,4,r,D.KV,r,r,r,40)
w=A.aC(D.rE,e,r,48)
v=A.x("Export to Calendar",r,r,r,r,Aa.Eu,r,r)
o=""+o
o=n?"Add "+o+q:"Add "+o+q
o=A.x(o,r,r,r,r,A.Y(r,r,B.ai,r,r,r,r,r,r,r,r,14,r,r,r,r,r,!0,r,r,r,r,r,r,r,r),r,r)
u=A.fH(r,r,e,r,r,r,r,r,r,B.e,r,r,r,r,new A.bN(A.a_(12),B.v),r,r,r,r,r)
t=""+m.length
u=A.c1(A.hU(A.x(n?"Export All ("+t+")":"Export All ("+t+")",r,r,r,r,G.dq,r,r),new C.aIl(this,m,e),u),48,1/0)
t=A.ui(r,r,r,r,r,r,r,r,r,e,r,r,r,r,new A.bN(A.a_(12),B.v),new A.az(e,1,B.w,-1),r,r,r,r)
t=A.c1(C.aZ9(A.x("Export Current Day Only",r,r,r,r,G.dq,r,r),new C.aIm(this,d,e),t),48,1/0)
s=A.ui(r,r,r,r,r,r,r,r,r,e,r,r,r,r,new A.bN(A.a_(12),B.v),new A.az(e,1,B.w,-1),r,r,r,r)
W.aSp(p,A.a6(r,A.an(A.b([x,w,F.Z,v,B.as,o,B.aR,u,B.G,t,B.G,A.c1(C.aZ9(A.x("Share .ics Calendar File",r,r,r,r,G.dq,r,r),new C.aIn(this,m,e),s),48,1/0),F.Z],y.p),B.p,B.h,B.ab),B.i,r,r,X.kY,r,r,r,r,S.cj,r,r,r),!1,y.z)},
B9(d,e){return this.aib(d,e)},
aib(d,e){var x=0,w=A.t(y.H),v=1,u=[],t,s,r,q,p
var $async$B9=A.u(function(f,g){if(f===1){u.push(g)
x=v}for(;;)switch(x){case 0:$.O()
r=$.cA().a
t=(r==null?null:r.gbo())==="__zh_disabled__"
v=3
x=6
return A.j(C.Ek(d,t,"APSCVIR My Schedule"),$async$B9)
case 6:v=1
x=5
break
case 3:v=2
p=u.pop()
s=A.aj(p)
r=$.O()
A.e8(r,"Export Failed",J.dB(s),B.eJ,B.e,B.E,B.au)
x=5
break
case 2:x=1
break
case 5:return A.q(null,w)
case 1:return A.p(u.at(-1),w)}})
return A.r($async$B9,w)},
V3(d,e){var x,w,v
$.O()
x=$.cA().a
if(x!=null)x.gbo()
for(x=d.length,w=0,v=0;v<d.length;d.length===x||(0,A.y)(d),++v){this.vZ(d[v],D.KM,w===0);++w}x=$.O()
A.e8(x,"Export Complete",""+w+" sessions exported to calendar",e,B.e,B.E,B.au)},
vZ(d,e,f){return this.aeJ(d,e,f)},
aeI(d,e){return this.vZ(d,e,!0)},
aeJ(d,e,f){var x=0,w=A.t(y.H),v,u=this,t,s
var $async$vZ=A.u(function(g,h){if(g===1)return A.p(h,w)
for(;;)switch(x){case 0:x=3
return A.j(u.Bf(f),$async$vZ)
case 3:if(!h){x=1
break}t=A.b([],y.s)
s=d.CW
if(s.length!==0)t.push(s)
s=d.as
if(s.length!==0)t.push(s)
s=d.cy
if(s.length!==0)t.push(s)
s=d.at
if(s.length!==0)t.push(s)
t=t.length===0?"APSCVIR 2026 session":B.b.bh(t," - ")
s=B.c.aA(d.r)
if(s.length===0)s=null
C.aRJ(new C.ae7(d.c,t,s,"Asia/Shanghai",d.x,d.y,new C.ai3(e)))
case 1:return A.q(v,w)}})
return A.r($async$vZ,w)},
Bf(d){return this.aiG(d)},
aiG(d){var x=0,w=A.t(y.y),v,u=2,t=[],s,r,q,p,o
var $async$Bf=A.u(function(e,f){if(e===1){t.push(f)
x=u}for(;;)switch(x){case 0:if(A.b0()!==B.a2){v=!0
x=1
break}u=4
x=7
return A.j(D.XI.hB("requestCalendarAccess",null,!1,y.y),$async$Bf)
case 7:s=f
if(J.e(s,!0)){v=!0
x=1
break}u=2
x=6
break
case 4:u=3
o=t.pop()
v=!0
x=1
break
x=6
break
case 3:x=2
break
case 6:if(d){q=$.O()
p=$.cA().a
if(p!=null)p.gbo()
A.e8(q,"Calendar Permission Required","Please allow calendar access in iOS Settings.",B.eJ,B.e,B.E,B.au)}v=!1
x=1
break
case 1:return A.q(v,w)
case 2:return A.p(t.at(-1),w)}})
return A.r($async$Bf,w)}}
C.aeZ.prototype={
Hw(d,e,f,g){return this.a8C(d,e,f,g)},
a8C(d,e,f,g){var x=0,w=A.t(y.H),v
var $async$Hw=A.u(function(h,i){if(h===1)return A.p(i,w)
for(;;)switch(x){case 0:x=1
break
case 1:return A.q(v,w)}})
return A.r($async$Hw,w)}}
C.anj.prototype={}
C.a8o.prototype={
H(){return"AndroidNotificationChannelAction."+this.b}}
C.aiv.prototype={
H(){return"Importance."+this.b}}
C.aoK.prototype={
H(){return"Priority."+this.b}}
C.ah3.prototype={
H(){return"GroupAlertBehavior."+this.b}}
C.a9_.prototype={
H(){return"AudioAttributesUsage."+this.b}}
C.a8p.prototype={}
C.abp.prototype={}
var z=a.updateTypes(["a2<~>()","~()","d(d,bu<K>)","rB()"])
C.a8m.prototype={
$1(d){return d===!0},
$S:140}
C.aIr.prototype={
$0(){var x,w,v,u,t,s,r=null,q=this.b,p=q.ga12()
if(p.length===0){x=this.a
w=B.c.aA(q.cy.gn())
v=q.gH8().length
u=A.aC(H.j_,B.aw,r,58)
t=w.length===0
s=t?"No assigned tasks found":"No matching tasks"
s=A.x(s,r,r,r,r,A.Y(r,r,B.S,r,r,r,r,r,r,r,r,18,r,r,B.x,r,r,!0,r,r,r,r,r,r,r,r),r,r)
if(t)v=v!==0?"No sessions are available for the selected day.":"No personal tasks or saved sessions yet."
else v="Try another topic, speaker, room, or time."
v=A.x(v,r,r,r,r,A.Y(r,r,B.S,r,r,r,r,r,r,r,r,13,r,r,r,r,r,!0,r,r,r,r,r,r,r,r),B.at,r)
q=x.TI(q,B.l,!0)
t=A.Z(120,B.l.m()>>>16&255,B.l.m()>>>8&255,B.l.m()&255)
return A.b7(A.c4(new A.aP(D.Lv,A.an(A.b([u,F.Z,s,B.as,v,A4.k6,q,A5.dm,L.FE(D.Ns,D.a8x,x.gar4(),A.ui(r,r,r,r,r,r,r,r,r,B.l,r,D.a1F,r,r,new A.bN(A.a_(8),B.v),new A.az(t,1,B.w,-1),r,r,r,r))],y.p),B.p,B.bC,B.j),r),r,r,r),1)}x=this.a
return A.b7(A.an(A.b([x.afo(q,B.l),x.afT(q,B.l),x.aft(B.l,q,p),A.b7(new A.dg(new C.aIq(x,q,p),r),1)],y.p),B.p,B.h,B.j),1)},
$S:674}
C.aIq.prototype={
$0(){var x,w=this,v=null,u=w.b,t=u.gQ7(),s=u.ch.gn()
if(t.length===0)return E.aWm(A.c4(A.x("No assigned tasks for this day",v,v,v,v,A.Y(v,v,B.S,v,v,v,v,v,v,v,v,v,v,v,v,v,v,!0,v,v,v,v,v,v,v,v),v,v),v,new A.cH("empty-"+s,y.O),v),D.qx,E.b2h(),B.M,B.M,w.a.gUL())
x=w.a
u=A.b([x.afu(B.l,B.ae,u,w.c),B.aR],y.p)
B.b.J(u,new A.nB(t,A.a3(t).i("nB<1>")).ghO().fU(0,new C.aIp(x,t),y.l))
return E.aWm(A.yc(u,new A.cH("day-"+s,y.O),P.qN,v,!1),D.qx,E.b2h(),B.dx,D.qi,x.gUL())},
$S:z+3}
C.aIp.prototype={
$1(d){var x=d.a
return this.a.afU(x===0,x===this.b.length-1,B.l,d.b)},
$S:675}
C.aIg.prototype={
$1(d){return this.a.Tl(this.b)},
$S:19}
C.aIe.prototype={
$0(){return this.a.agz(this.b)},
$S:0}
C.aIf.prototype={
$0(){return this.a.Tl(this.b)},
$S:0}
C.aI8.prototype={
$0(){},
$S:0}
C.aIj.prototype={
$0(){},
$S:0}
C.aId.prototype={
$0(){var x,w=null,v=this.b
if(v.gqM().length===0)return U.k5
x=this.c
return A.dV(w,A.a6(B.H,A.aC(D.Mt,x,w,22),B.i,w,w,w,w,48,w,w,w,w,w,48),B.F,!1,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,new C.aIc(this.a,v,x),w,w,w,w,w,w,!1,B.ax)},
$S:51}
C.aIc.prototype={
$0(){return this.a.aj_(this.b,this.c)},
$S:0}
C.aIb.prototype={
$0(){var x=this,w=null,v=x.a,u=x.b,t=x.c
return A.a6(w,Y.yd(new C.aIa(v,t,u,v.Za(u,t),x.d,x.e,x.f,x.r),t.length,B.lT,w,B.aC,!1),B.i,B.e,w,w,w,80,w,w,w,w,w,w)},
$S:154}
C.aIa.prototype={
$2(d,e){var x,w,v,u,t,s,r,q,p,o,n=this,m=null,l=n.b[e],k=n.a,j=n.c,i=k.ahx(j,l,e),h=k.X6(n.d,l)
k=n.e
x=k?n.f[A.yM(l)-1]:n.r[A.yM(l)-1]
w=k?""+A.cx(l)+"/"+A.cZ(l):B.jd[A.cx(l)-1]+" "+A.cZ(l)
k=A.a_(8)
v=A.a_(8)
if(h){u=n.w
u=A.Z(22,u.m()>>>16&255,u.m()>>>8&255,u.m()&255)}else u=B.D
t=A.a_(8)
if(h){s=n.w
s=A.Z(90,s.m()>>>16&255,s.m()>>>8&255,s.m()&255)}else s=B.D
s=A.bi(s,1)
if(h){r=n.w
r=A.b([new A.bl(0,B.U,A.Z(18,r.m()>>>16&255,r.m()>>>8&255,r.m()&255),A_.dF,10)],y.V)}else r=A8.th
q=h?B.bl:B.Y
q=A.Y(m,m,h?n.w:B.S,m,m,m,m,m,m,m,m,12,m,m,q,m,m,!0,m,0,m,m,m,m,m,m)
q=A.oY(A.x(x,m,m,m,m,m,m,m),B.dx,B.iA,!0,q)
p=A.Y(m,m,h?n.w:B.cy,m,m,m,m,m,m,m,m,14,m,m,B.x,m,m,!0,m,0,m,m,m,m,m,m)
p=A.oY(A.x(w,m,m,m,m,m,m,m),B.dx,B.iA,!0,p)
o=h?28:0
return new A.aP(D.LC,A.eg(!1,B.I,!0,k,A.he(!1,v,!0,A.a8s(A.an(A.b([q,B.aY,p,D.DM,A.a8s(m,m,B.dx,new A.ac(n.w,m,m,A.a_(99),m,m,B.o),D.qw,m,3,m,m,o)],y.p),B.p,B.bC,B.j),m,B.dx,new A.ac(u,m,s,t,r,m,B.o),D.qw,m,m,m,A7.eP,80),m,!0,m,m,m,m,m,m,m,m,m,new C.aI9(j,i),m,m,m,m,m,m),B.i,B.D,0,m,m,m,m,m,B.b8),m)},
$S:677}
C.aI9.prototype={
$0(){var x=this.a.ch,w=this.b
if(x.gn()!==w)x.sn(w)},
$S:0}
C.aIo.prototype={
$1(d){return d.ch===this.a.ch.gn()},
$S:18}
C.aIk.prototype={
$1(d){return this.a.X6(d.x,this.b)},
$S:18}
C.aIh.prototype={
$0(){return this.a.aeI(this.b,D.Kz)},
$S:0}
C.aIi.prototype={
$0(){var x=this,w='" is starting soon',v=x.c.c
v=x.b?'Your session "'+v+w:'Your session "'+v+w
x.a.Cz("Schedule Reminder",v)
v=$.O()
A.e8(v,"Reminder Set","We will notify you before the session starts",x.d,B.e,B.E,B.au)},
$S:0}
C.aIl.prototype={
$0(){A.cG($.O(),null)
this.a.V3(this.b,this.c)},
$S:0}
C.aIm.prototype={
$0(){A.cG($.O(),null)
this.a.V3(this.b.gQ7(),this.c)},
$S:0}
C.aIn.prototype={
$0(){A.cG($.O(),null)
this.a.B9(this.b,this.c)},
$S:0}
C.ai9.prototype={
$1(d){return B.c.ij(B.f.j(d),2,"0")},
$S:69};(function installTearOffs(){var x=a._instance_0u,w=a._instance_2u
var v
x(v=C.L3.prototype,"gar4","wT",0)
x(v,"gapD","apE",1)
w(v,"gUL","ahy",2)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.d9,[C.a8m,C.aIp,C.aIg,C.aIo,C.aIk,C.ai9])
x(A.L,[C.ae7,C.a8q,C.ai3,C.aeZ,C.anj,C.a8p,C.abp])
w(C.nH,A.W)
w(C.L3,A.a4)
x(A.dK,[C.aIr,C.aIq,C.aIe,C.aIf,C.aI8,C.aIj,C.aId,C.aIc,C.aIb,C.aI9,C.aIh,C.aIi,C.aIl,C.aIm,C.aIn])
w(C.aIa,A.fh)
x(A.iO,[C.a8o,C.aiv,C.aoK,C.ah3,C.a9_])})()
A.dT(b.typeUniverse,JSON.parse('{"nH":{"W":[],"d":[]},"L3":{"a4":["nH"]}}'))
var y=(function rtii(){var x=A.X
return{Z:x("jR"),V:x("o<bl>"),s:x("o<k>"),p:x("o<d>"),S:x("o<jC>"),K:x("L"),n:x("o5"),N:x("k"),L:x("ay<h>"),O:x("cH<k>"),l:x("d"),y:x("z"),z:x("@"),u:x("z?"),H:x("~")}})();(function constants(){D.Gk=new A.al(48,1/0,0,1/0)
D.acO=new C.aiv(6,"max")
D.acW=new C.aoK(3,"high")
D.acN=new C.ah3(0,"all")
D.acv=new C.a8o(0,"createIfNotExists")
D.acx=new C.a9_(7,"notification")
D.acy=new C.a8p()
D.acz=new C.a8q()
D.acB=new C.abp()
D.HK=new C.anj()
D.qi=new A.e6(0.55,0.055,0.675,0.19)
D.Kz=new A.b1(18e8)
D.qw=new A.b1(22e4)
D.qx=new A.b1(26e4)
D.KM=new A.b1(9e8)
D.KV=new A.ae(0,0,0,20)
D.KW=new A.ae(0,0,0,32)
D.L2=new A.ae(0,8,0,0)
D.L5=new A.ae(10,4,10,4)
D.Lh=new A.ae(16,12,16,0)
D.Lv=new A.ae(28,0,28,0)
D.LC=new A.ae(4,8,4,8)
D.Mt=new A.ak(58189,"MaterialIcons",!1)
D.My=new A.ak(58448,"MaterialIcons",!1)
D.rE=new A.ak(984763,"MaterialIcons",!1)
D.Ns=new A.cd(B.j5,18,null,null,null)
D.NB=new A.cd(K.eY,19,null,null,null)
D.NC=new A.cd(V.mF,18,null,null,null)
D.XI=new A.k1("apscvir/calendar_permission",B.bS)
D.XJ=new A.k1("add_2_calendar",B.bS)
D.Yv=new A.h(0.035,0)
D.a1F=new A.J(240,44)
D.a1T=new A.c6(null,5,null,null)
D.DM=new A.c6(null,7,null,null)
D.a4V=new A.n(!0,B.ae,null,null,null,null,16,B.x,null,null,null,null,1.25,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a8x=new A.cn("Browse Program",null,null,null,null,null,null,null,null,null)
D.aas=new A.cH("my-schedule-task-search",y.O)})();(function lazyInitializers(){var x=a.lazyFinal
x($,"blT","b3o",()=>new C.aeZ())})()};
(a=>{a["5EfnwzknftT7UF+uMrpqRLqqLzc="]=a.current})($__dart_deferred_initializers__);