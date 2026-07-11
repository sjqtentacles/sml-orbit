(* demo.sml - propagate a fixed circular LEO orbit, a Hohmann and a
   bi-elliptic transfer to GEO, a rocket delta-v budget, and Earth's sphere
   of influence, all from literal fixed orbital elements. Deterministic:
   identical output on every run and both compilers. Real output uses a
   fixed digit count and normalizes negative zero, since MLton and Poly/ML
   disagree on printing whole-number reals via Real.toString. *)

structure Orb = Orbit

fun fmt3 x =
  let val x' = if Real.== (x, 0.0) then 0.0 else x
  in Real.fmt (StringCvt.FIX (SOME 3)) x' end

val muEarth = Orb.muEarth
val g0      = Orb.g0

(* Fixed circular LEO orbit: 400 km altitude above a 6378.137 km Earth radius. *)
val r1 = 6778137.0
val a1 = r1

val () = print "LEO circular orbit, r = a = 6778.137 km (400 km altitude):\n"
val vCirc = Orb.circularV {mu=muEarth, r=r1}
val () = print ("  circularV        = " ^ fmt3 vCirc ^ " m/s\n")
val vVis  = Orb.visViva {mu=muEarth, r=r1, a=a1}
val () = print ("  visViva (r=a)    = " ^ fmt3 vVis ^ " m/s (matches circularV)\n")
val vEsc  = Orb.escapeV {mu=muEarth, r=r1}
val () = print ("  escapeV          = " ^ fmt3 vEsc ^ " m/s\n")
val per   = Orb.period {mu=muEarth, a=a1}
val () = print ("  period           = " ^ fmt3 per ^ " s (" ^ fmt3 (per / 60.0) ^ " min)\n")
val se    = Orb.specificEnergy {mu=muEarth, a=a1}
val () = print ("  specificEnergy   = " ^ fmt3 se ^ " J/kg\n")

val () = print "\nHohmann transfer LEO (r1 = 6778.137 km) -> GEO (r2 = 42164 km):\n"
val r2 = 42164000.0
val {dv1=hdv1, dv2=hdv2, dvTotal=hdvT, tof=htof} = Orb.hohmann {mu=muEarth, r1=r1, r2=r2}
val () = print ("  dv1              = " ^ fmt3 hdv1 ^ " m/s\n")
val () = print ("  dv2              = " ^ fmt3 hdv2 ^ " m/s\n")
val () = print ("  dvTotal          = " ^ fmt3 hdvT ^ " m/s\n")
val () = print ("  time of flight   = " ^ fmt3 htof ^ " s (" ^ fmt3 (htof / 3600.0) ^ " h)\n")

val () = print "\nBi-elliptic transfer LEO -> GEO via burn radius rb = 100000 km:\n"
val rb = 100000000.0
val {dv1=bdv1, dv2=bdv2, dv3=bdv3, dvTotal=bdvT} = Orb.biElliptic {mu=muEarth, r1=r1, rb=rb, r2=r2}
val () = print ("  dv1              = " ^ fmt3 bdv1 ^ " m/s\n")
val () = print ("  dv2              = " ^ fmt3 bdv2 ^ " m/s\n")
val () = print ("  dv3              = " ^ fmt3 bdv3 ^ " m/s\n")
val () = print ("  dvTotal          = " ^ fmt3 bdvT ^ " m/s (vs. Hohmann's " ^ fmt3 hdvT ^ ")\n")

val () = print "\nTsiolkovsky rocket equation, isp = 311 s, m0 = 25000 kg, mf = 5000 kg:\n"
val isp = 311.0
val m0  = 25000.0
val mf  = 5000.0
val dvIsp = Orb.tsiolkovsky {isp=isp, m0=m0, mf=mf}
val () = print ("  tsiolkovsky      = " ^ fmt3 dvIsp ^ " m/s\n")
val ve = g0 * isp
val dvVe = Orb.tsiolkovskyVe {ve=ve, m0=m0, mf=mf}
val () = print ("  tsiolkovskyVe    = " ^ fmt3 dvVe ^ " m/s (ve = g0*isp; matches)\n")

val () = print "\nEarth's sphere of influence around the Sun (a = 1 AU):\n"
val soi = Orb.soiRadius {a=1.496e11, mSmall=5.972e24, mBig=1.98892e30}
val () = print ("  soiRadius        = " ^ fmt3 (soi / 1000.0) ^ " km\n")
